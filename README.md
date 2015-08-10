Steps to get the data:

* run the script run.sh which downloads the data from the Broad. This is the contents of the script, it just logs in and grabs everything:

```bash
wget --tries=10 --continue --mirror --user $user --password $password --no-check-certificate https://get.broadinstitute.org/pkgs/SN0066569/
```

* the reads have been aligned to mm9, but have all of the reads kept in them. We will realign them against mm10. The reads that
are aligned have filenames *duplicates_marked*.bam, so move those to the data directory:

```bash
find . -name *duplicates_marked*.bam -exec cp data \;
```

* Each of the cells has been run across 4 lanes, so we need to combine those lanes together. We can do that with bcbio_prepare_samples.py, which needs CSV file that describes which samples are all of the same. We did that by picking out the sample identitity from the name and using that
as the ID to merge on. scripts/create_csv.py does this:

```bash
cd data/
python ../scripts/create_csv.py > danika-singlecell.csv
```

* run bcbio_prepare_samples.py which merges all of the samples together that have the same ID
```bash
bcbio_prepare_samples.py --out merged --csv danika-singlecell.csv
cp danika-singlecell-merged.csv ../
```
* set up bcbio_nextgen to run by getting the standard RNA-seq template and editing to use the correct genome:

```bash
wget https://raw.githubusercontent.com/chapmanb/bcbio-nextgen/master/config/templates/illumina-rnaseq.yaml
```

edit illumina-rnaseq.yaml so it looks like this:

```yaml
details:
  - analysis: RNA-seq
    genome_build: mm10
    algorithm:
      aligner: star
      trim_reads: read_through
      adapters: [polya]
      strandedness: unstranded
upload:
  dir: ../final
```

* run the bcbio-nextgen templating system to set up the configuration YAML file

```bash
bcbio_nextgen.py -w template illumina-rnaseq.yaml danika-singlecell-merged.csv data/merged/
```

* run bcbio-nextgen using this Bash script (saved as run_bcbio.sh):

```bash
#!/bin/bash
#SBATCH -n 1
#SBATCH -J danika-singlecell
#SBATCH --mem=2000
#SBATCH -p general
#SBATCH -o %J.err
#SBATCH -e %J.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=odyssey-slurm@gmail.com
#SBATCH --time=7-00:00
bcbio_nextgen.py --tag tsc -s slurm --timeout 6000 -n 96 -q general -t ipython  /n/regal/hsph_bioinfo/bcbio_nextgen/galaxy/bcbio_system.yaml ../config/danika-singlecell-merged.ya
ml
```

* get contents of danika-singlecell-merged/final/*project* directory for downstream analysis.
