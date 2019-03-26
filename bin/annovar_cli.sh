#!/usr/bin/env bash
#
# Usage:
#   annovar.sh [--downdb] [<vcf>...]
#
# Description:
#   Run ANNOVAR for VCF files
#
# Options:
#   --downdb      Download database files
#   -h, --help    Print usage
#
# Arguments:
#   <vcf>...      Paths to input VCF files

set -e
SCRIPT_PATH=$(realpath "${0}")
[[ "${1}" = '--debug' ]] \
  && set -x \
  && shift 1

BIN_DIR=$(dirname "${SCRIPT_PATH}")
DB_SH="${BIN_DIR}/annovar_db.sh"
VCF_SH="${BIN_DIR}/annovar_vcf.sh"
DB_DIR="${PWD}/humandb"
OUTPUT_DIR="${PWD}/output"

ARGS=()
DOWNDB=0
case "${OSTYPE}" in
  darwin*)
    THREAD=$(system_profiler SPHardwareDataType | sed -ne 's/ \+Total Number of Cores: \([0-9]\+\)/\1/p')
    ;;
  linux*)
    THREAD=$(grep -ce '^processor\s\+:' /proc/cpuinfo)
    ;;
  * )
    THREAD=''
    ;;
esac

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
      DOWNDB=1 && shift 1
      ;;
    '-h' | '--help' )
      print_usage && exit 0
      ;;
    * )
      ARGS+=("${1}") && shift 1
      ;;
  esac
done
VCF_FILES=("${ARGS[@]}")

set -u

if [[ ${DOWNDB} -eq 1 ]]; then
  [[ -d "${DB_DIR}" ]] || mkdir "${DB_DIR}"
  ${DB_SH} "${DB_DIR}"
fi

if [[ ${#ARGS[@]} -ne 0 ]]; then
  [[ -d "${OUTPUT_DIR}" ]] || mkdir "${OUTPUT_DIR}"
  for v in "${VCF_FILES[@]}"; do
    t="${OUTPUT_DIR}/"$(basename "${v}")
    ${VCF_SH} "${v}" "${DB_DIR}" "${t}" "${THREAD}"
  done
fi
