#!/usr/bin/env bash

set -ue

if [[ -n "${3}" ]]; then
  THREAD="${3}"
else
  THREAD=1
fi

set -x

table_annovar.pl \
  "${1}" "${2}" \
  -buildver hg19 \
  -out myanno \
  -remove \
  -protocol refGene,ensGene,cytoBand,phastConsElements46way,genomicSuperDups,exac03,avsnp147,dbnsfp30a,ljb26_all,esp6500_all,1000g2015aug \
  -operation g,g,r,r,r,f,f,f \
  -nastring . \
  -vcfinput \
  -thread ${THREAD}
