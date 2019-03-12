#!/usr/bin/env bash

set -uex

DB_DIR='./humandb/'
BUILD_VER='hg19'
DB_NAMES=(
  refGene
  ensGene
  knownGene
  snp138
  esp6500siv2_all
  1000g2015aug
  cosmic80
  exac03
  clinvar_20180603
)

[[ -d "${DB_DIR}" ]] || mkdir "${DB_DIR}"

for f in ${DB_NAMES[@]}; do
  docker-compose run --rm --entrypoint=annotate_variation.pl annovar \
    -buildver "${BUILD_VER}" \
    -downdb "${f}" \
    -webfrom annovar \
    "${DB_DIR}"
done
