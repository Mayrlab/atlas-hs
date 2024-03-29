[![DOI](https://zenodo.org/badge/646183013.svg)](https://zenodo.org/doi/10.5281/zenodo.10895336)

# Human UTRome Atlas
This pipeline analyzes the Tabula Sapiens dataset to define an atlas of 3' UTRs. At its core is a tabulation of how many distinct cell types use a particular tandem (non-intronic) isoform at either 5% or 10% frequency. Genes that have more that two isoforms of this type are classified as multi-UTR genes.

## Usage

The pipeline relies on Snakemake and Conda/Mamba. If Conda is not installed, we recommend [a Miniforge variant](https://github.com/conda-forge/miniforge), specifically [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge).

To run with the same Snakemake version, please recreate the environment using:

```bash
# replace 'mamba' with 'conda'
mamba env create -f envs/snakemake_6_8.min.yaml
```

After activating the above environment (`conda activate snakemake_6_8`), the pipeline can be run with:

```bash
snakemake
```

where the `Snakefile` is in the working directory.

One will need to update the `config.yaml` file to provide the file locations.

## Adding Datasets

Similar to [the Mouse UTRome Atlas pipeline](https://github.com/Mayrlab/atlas-mm), this pipeline supports integration of multiple datasets. The datasets are assumed to result from [the scUTRquant pipeline](https://mfansler.github.io/scutr-quant/) targeted to the `utrome_hg38_v1` index. They must be added to `config.yaml`, under the `sce` object, and added to the **merge_sces** rule in `Snakefile`. The colData columns retained in the merged dataset are:

 - **cell_id**
 - **tissue**
 - **cell_type**
 - **cluster**
 - **sample**
 - **age**

Conforming data is done in `scripts/merge_sces.R`.
