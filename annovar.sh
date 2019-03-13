#!/usr/bin/env bash
#
# Usage:
#   annovar.sh --downdb
#   annovar.sh <vcf>...
#
# Description:
#   Run ANNOVAR for VCF files
#
# Options:
#   --downdb
#   -h, --help    Print usage

set -e
[[ "${1}" = '--debug' ]] \
  && set -x \
  && shift 1

DB_DIR='./humandb'
OUTPUT_DIR='./output'
BUILD_VER='hg19'
DBS=(
  cytoBand
)
WEB_DBS=(
  refGene
  exac03
  avsnp147
  dbnsfp30a
)
VCF_FILES=(
  /usr/local/src/annovar/example/ex2.vcf
)

ARGS=()
DOWNDB=0

function print_usage {
  sed -ne '1,2d; /^#/!q; s/^#$/# /; s/^# //p;' "${SCRIPT_PATH}"
}

function abort {
  {
    if [[ ${#} -eq 0 ]]; then
      cat -
    else
      # shellcheck disable=SC2086
      echo "$(basename ${SCRIPT_PATH}): ${*}"
    fi
  } >&2
  exit 1
}

while [[ -n "${1}" ]]; do
  case "${1}" in
    '--downdb' )
      DOWNDB=1 && shift 1 && break
      ;;
    '-h' | '--help' )
      print_usage && exit 0
      ;;
    * )
      ARGS+=( ${1} )
      ;;
  esac
done

set -u

if [[ ${DOWNDB} -eq 1 ]]; then
  [[ -d "${DB_DIR}" ]] || mkdir "${DB_DIR}"
  [[ ${#ARGS[@]} -ne 0 ]] && WEB_DBS=(${ARGS[@]})
  for f in "${DBS[@]}"; do
    annotate_variation.pl \
      -buildver "${BUILD_VER}" -downdb \
     "${f}" "${DB_DIR}"
  done
  for f in "${WEB_DBS[@]}"; do
    annotate_variation.pl \
      -buildver "${BUILD_VER}" -downdb \
      -webfrom annovar \
     "${f}" "${DB_DIR}"
  done
else
  [[ -d "${OUTPUT_DIR}" ]] || mkdir "${OUTPUT_DIR}"
  [[ ${#ARGS[@]} -ne 0 ]] && VCF_FILES=(${ARGS[@]})
  cp "${VCF_FILES[*]}" "${OUTPUT_DIR}"
  cd "${OUTPUT_DIR}"
  for v in ${VCF_FILES[@]}; do
    table_annovar.pl \
      "$(basename ${v})" \
      ../humandb/ \
      -buildver "${BUILD_VER}" \
      -out myanno \
      -remove \
      -protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a \
      -operation g,r,f,f,f \
      -nastring . \
      -vcfinput
  done
fi
