#!/usr/bin/env bash
#
# Usage:
#   annovar_db.sh <dir>
#
# Arguments:
#   <db_dir>      Path to a database directory

set -uex

cd "${1}"

# annotate_variation.pl -buildver hg19 -downdb seq hg19_seq
wget -q http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz
mkdir hg19_seq
tar xvf chromFa.tar.gz -C hg19_seq
rm -f chromFa.tar.gz

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar refGene .
retrieve_seq_from_fasta.pl /wd/humandb/hg19_refGene.txt -seqdir /wd/humandb/hg19_seq -format refGene -outfile /wd/humandb/hg19_refGeneMrna.fa
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar ensGene .
retrieve_seq_from_fasta.pl /wd/humandb/hg19_ensGene.txt -seqdir /wd/humandb/hg19_seq -format ensGene -outfile /wd/humandb/hg19_ensGeneMrna.fa

annotate_variation.pl -buildver hg19 -downdb cytoBand .
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac03 .
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp150 .
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar dbnsfp35c .
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar ljb26_all .
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar esp6500siv2_all .
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar cosmic70 .
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar clinvar_20190305 .

# annotate_variation.pl -buildver hg19 -downdb -webfrom annovar 1000g2015aug .
wget -q http://www.openbioinformatics.org/annovar/download/hg19_1000g2015aug.zip
unzip hg19_1000g2015aug.zip
rm -f hg19_1000g2015aug.zip
ln -s hg19_ALL.sites.2015_08.txt hg19_1000g2015aug.txt
ln -s hg19_ALL.sites.2015_08.txt hg19_1000g2015aug.txt.idx
