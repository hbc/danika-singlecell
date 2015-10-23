for file in *.bam; do base=`basename $file .ercc.bam`; samtools idxstats $file | awk -v base=$base '{print $0"\t"base}' > $base.stats; done
