#!/usr/bin/env Rscript

library(SingleCellExperiment)
library(S4Vectors)
library(tidyverse)
library(magrittr)

if (interactive()) {
    Snakemake <- setClass("Snakemake", slots=c(input='list', output='list', params='list'))
    snakemake <- Snakemake(
        input=list(
            tsapiens="/data/mayrc/fanslerm/scutr-quant/data/sce/utrome_hg38_v1/tabula-sapiens.txs.Rds"),
            ## brain="/data/mayrc/fanslerm/scutr-quant/data/sce/ximerakis19.utrome.txs.Rds",
            ## hspcs="/data/mayrc/data/mm-hspc-44k/sce/hspcs.utrome.txs.Rds",
            ## mescs="/data/mayrc/fanslerm/scutr-quant/data/sce/guo19.utrome.txs.Rds"),
        output=list(sce="/fscratch/fanslerm/merged.txs.raw.Rds"),
        params=list())
}

## Load SCEs
sce.tsapiens <- readRDS(snakemake@input$tsapiens)
## sce.brain  <- readRDS(snakemake@input$brain)
## sce.hspcs  <- readRDS(snakemake@input$hspcs)
## sce.mescs  <- readRDS(snakemake@input$mescs)

## Verify rownames are identical
## stopifnot(all(rownames(sce.tmuris) == rownames(sce.brain)),
##           all(rownames(sce.tmuris) == rownames(sce.hspcs)),
##           all(rownames(sce.tmuris) == rownames(sce.mescs)))

## Strip Row Data
## rowData(sce.brain) <- NULL
## rowData(sce.hspcs) <- NULL
## rowData(sce.mescs) <- NULL

## Exclude Untyped Cells
sce.tsapiens %<>% `[`(,!is.na(.$cell_ontology_class))

########################################
## Adjust Column Data to Match
########################################

## Tabula Sapiens
colData(sce.sapiens) %<>%
    as.data.frame %>%
    dplyr::rename(cell_type=cell_ontology_class,
                  tissue=organ_tissue,
                  cluster=as.integer(as.factor(cell_ontology_class)),
                  sample=sample_id.x) %>%
    mutate(age='adult') %>%
    select('cell_id', 'tissue', 'cell_type', 'cluster', 'sample', 'age') %>%
    DataFrame()

## combine SCEs
## sce <- cbind(sce.tmuris, sce.brain, sce.hspcs, sce.mescs)
## colnames(sce) <- sce$cell_id

## filter unannotated cells
## sce %<>% `[`(,!is.na(.$cell_type))

## export
saveRDS(sce, snakemake@output$sce)
