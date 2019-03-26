#!/usr/bin/env bash

set -uex

annotate_variation.pl -buildver hg19 -downdb -webfrom ucsc refGene "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom ucsc ensGene "${1}"
annotate_variation.pl -buildver hg19 -downdb cytoBand "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac03 "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp147 "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar dbnsfp30a "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom ucsc phastConsElements46way "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom ucsc genomicSuperDups "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar ljb26_all "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar esp6500_all "${1}"
annotate_variation.pl -buildver hg19 -downdb -webfrom ucsc 1000g2015aug "${1}"
