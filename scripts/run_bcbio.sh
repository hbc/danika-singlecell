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
bcbio_nextgen.py --tag tsc -s slurm --timeout 6000 -n 96 -q general -t ipython  /n/regal/hsph_bioinfo/bcbio_nextgen/galaxy/bcbio_system.yaml ../config/danika-singlecell-merged.yaml
