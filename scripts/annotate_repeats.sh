#!/bin/bash
#script to run dnaPipeTE

#get dnaPipeTE from https://github.com/clemgoub/dnaPipeTE
#follow installation instructions

#here, I used version 1.2, which was setup by Patrick Tran Van
#copy from Patrick's path

#set up environment
#module add Development/java/1.8.0_152 --> this simply does not work
module add Development/java_jre/1.7.0_17
#module add UHTS/Aligner/bowtie2/2.3.1;
module add UHTS/Aligner/bowtie2/2.3.0
module add R/latest

# reads						data/Avag1/reads-trimmed-pair1.fastq.gz
# sample code				244000000
# output dir				data/Avag1/dnaPipeTE

READS=$1
GENOME_SIZE=$(Rscript scripts/get_genome_length.R $2)
OUTPUT=$3
SP_DIR=$(dirname "$OUTPUT")

#tmp has to be adjusted -> already in the wrapper script, maybe I should veify
LOCAL_DIR="/scratch/local/monthly/$USER"
mkdir -p "$LOCAL_DIR"/"$SP_DIR"/temp
mkdir -p "$LOCAL_DIR"/"$OUTPUT"
export TMPDIR="$LOCAL_DIR"/"$SP_DIR"/temp
export _JAVA_OPTIONS="-XX:ParallelGCThreads=6"

cp "$READS" "$LOCAL_DIR"/"$READS"

#run the dnaPipeTE pipeline
#IMPORTANT: must be run from installed software path !!


#mabye better softlink to program folder if run on local scratch
cd /scratch/beegfs/monthly/jbast/software/dnaPipeTE_old/1.2
#cd /scratch/beegfs/monthly/ptranvan/Software/dnaPipeTE/1.2

#run with single-end reads (can be gzipped)
#IMPORTANT: give genome size of organism
#the genome_coverage and sample_number depends on how many TEs are expected, but the setting here should be generally ok

python3 ./dnaPipeTE.py -input "$LOCAL_DIR"/"$READS" \
    -output "$LOCAL_DIR"/"$OUTPUT" \
    -cpu 12 -genome_size "$GENOME_SIZE" -genome_coverage 0.5 -sample_number 3

cd "$LOCAL_DIR"

printf "****DONE****\n"