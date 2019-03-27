#!/usr/bin/env bash
#
# Usage:
#   annovar_vcf.sh <vcf> <db_dir> <tag> [<thread>]
#
# Arguments:
#   <vcf>         Path to an input VCF file
#   <db_dir>      Path to a database directory
#   <tag>         Prefix of output files
#   <thread>      Number of threads

set -uex

if [[ ${#} -ge 4 ]]; then
  THREAD="${4}"
else
  THREAD=1
fi

VCF="${1}"
DB_DIR="${2}"
TAG="${3}"

table_annovar.pl \
  "${VCF}" "${DB_DIR}" \
  -buildver hg19 \
  -out "${TAG}" \
  -remove \
  -protocol refGene,ensGene,cytoBand,exac03,avsnp150,dbnsfp35c,ljb26_all,esp6500siv2_all,1000g2015aug,cosmic70,clinvar_20190305 \
  -operation g,g,r,f,f,f,f,f,f,f,f \
  -nastring . \
  -vcfinput \
  -thread ${THREAD}
