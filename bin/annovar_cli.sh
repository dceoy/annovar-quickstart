#!/usr/bin/env bash
#
# ANNOVAR execution kit for VCF files
#
# Usage:
#   annovar_cli.sh [--downdb] [--db-dir=<path>] [--out-dir=<path>]
#                  [--thread=<int>] [<vcf>...]
#   annovar_cli.sh -h|--help
#   annovar_cli.sh --version
#
# Options:
#   --downdb          Download database files
#   --db-dir=<path>   Set a database directory [default: ./humandb]
#   --out-dir=<path>  Set an output directory [default: ./output]
#   --thread=<int>    Limit cores for multithreading
#   -h, --help        Print usage information
#   --version         Print version information
#
# Arguments:
#   <vcf>...          Paths to input VCF files

set -ue
for a in "${@}"; do
  [[ "${a}" = '--debug' ]] && set -x && break
done

REPO_NAME='annovar-vcf-cli'
REPO_VERSION='v0.0.1'
SCRIPT_PATH=$(realpath "${0}")
BIN_DIR=$(dirname "${SCRIPT_PATH}")
DB_SH="${BIN_DIR}/annovar_db.sh"
VCF_SH="${BIN_DIR}/annovar_vcf.sh"
DB_DIR="${PWD}/humandb"
OUT_DIR="${PWD}/output"

VCF_FILES=()
DOWNDB=0
THREAD=''

function print_version {
  echo "${REPO_NAME}: ${REPO_VERSION}"
}

function print_usage {
  sed -ne '1,2d; /^#/!q; s/^#$/# /; s/^# //p;' "${1}"
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

while [[ ${#} -ge 1 ]]; do
  case "${1}" in
    '--debug' )
      shift 1
      ;;
    '--downdb' )
      DOWNDB=1 && shift 1
      ;;
    '--db-dir' )
      DB_DIR="${2}" && shift 2
      ;;
    --db-dir=* )
      DB_DIR="${1#*\=}" && shift 1
      ;;
    '--out-dir' )
      OUT_DIR="${2}" && shift 2
      ;;
    --out-dir=* )
      OUT_DIR="${1#*\=}" && shift 1
      ;;
    '--thread' )
      THREAD="${2}" && shift 2
      ;;
    --thread=* )
      THREAD="${1#*\=}" && shift 1
      ;;
    '--version' )
      print_version && exit 0
      ;;
    '-h' | '--help' )
      print_usage "${SCRIPT_PATH}" && exit 0
      ;;
    --* )
      abort "invalid option: ${1}"
      ;;
    * )
      VCF_FILES+=("${a}") && shift 1
      ;;
  esac
done

if [[ -z "${THREAD}" ]]; then
  case "${OSTYPE}" in
    darwin* )
      THREAD=$(system_profiler SPHardwareDataType | sed -ne 's/ \+Total Number of Cores: \([0-9]\+\)/\1/p')
      ;;
    linux* )
      THREAD=$(grep -ce '^processor\s\+:' /proc/cpuinfo)
      ;;
    * )
      THREAD=1
      ;;
  esac
fi

if [[ ${DOWNDB} -eq 1 ]]; then
  [[ -d "${DB_DIR}" ]] || mkdir "${DB_DIR}"
  ${DB_SH} "${DB_DIR}"
fi

if [[ ${#VCF_FILES[@]} -ne 0 ]]; then
  [[ -d "${OUT_DIR}" ]] || mkdir "${OUT_DIR}"
  for v in "${VCF_FILES[@]}"; do
    t="${OUT_DIR}/"$(basename "${v}")
    ${VCF_SH} "${v}" "${DB_DIR}" "${t}" "${THREAD}"
  done
fi
