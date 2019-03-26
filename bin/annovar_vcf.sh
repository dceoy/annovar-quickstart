#!/usr/bin/env bash
#
# Usage:
#   annovar_db.sh <vcf> <db_dir> <tag> [<thread>]
#
# Arguments:
#   <vcf>         Path to an input VCF file
#   <db_dir>      Path to a database directory
#   <tag>         Prefix of output files
#   <thread>      Number of threads

set -ue

VCF="${1}"
DB_DIR="${2}"
TAG="${3}"

if [[ -n "${4}" ]]; then
  THREAD="${4}"
else
  THREAD=1
fi

set -x

table_annovar.pl \
  "${VCF}" "${DB_DIR}" \
  -buildver hg19 \
  -out "${TAG}" \
  -remove \
  -protocol refGene,ensGene,cytoBand,phastConsElements46way,genomicSuperDups,exac03,avsnp150,dbnsfp35c,ljb26_all,esp6500siv2_all,1000g2015aug,cosmic70,clinvar_20190305 \
  -operation g,g,r,r,r,f,f,f,f,f,f,f,f \
  -nastring . \
  -vcfinput \
  -thread ${THREAD}
