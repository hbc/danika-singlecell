#!/bin/bash
#SBATCH -t 1-00:00:00
#SBATCH -p general
#SBATCH --cpus-per-task=1
#SBATCH --mem=4000
#SBATCH --job-name=danika-getdata
#SBATCH --mail-user=odyssey-slurm@ruelz.com
#SBATCH --mail-type=ALL
wget --tries=10 --continue --mirror --user $user --password $password --no-check-certificate https://get.broadinstitute.org/pkgs/SN0066569/
