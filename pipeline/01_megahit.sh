SAMPLE=`basename \`pwd\``
SN=`echo $SAMPLE  | perl -p -e 's/.*Run33_(\d+).*/$1/'`
echo "$SAMPLE $SN"
DATA1=~/data/trim_${SAMPLE}_S${SN}_R1_001.fastq.gz
DATA2=~/data/trim_${SAMPLE}_S${SN}_R2_001.fastq.gz
megahit --min-contig-len 250 --no-mercy --presets single-cell -1 $DATA1 -2 $DATA2  -o ${SAMPLE}_megahit_out -m 0.9 -t 32 &> megahit_${SAMPLE}.log
