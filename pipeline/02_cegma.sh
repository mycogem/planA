SAMPLE=`basename \`pwd\``
SN=`echo $SAMPLE  | perl -p -e 's/.*Run33_(\d+).*/$1/'`
DATA1=~/data/trim_${SAMPLE}_S${SN}_R1_001.fastq.gz
DATA2=~/data/trim_${SAMPLE}_S${SN}_R2_001.fastq.gz
CTGDIR=${SAMPLE}_megahit_out
CTGFILE=final.contigs.fa
cegma -g ${CTGDIR}/${CTGFILE} -o cegma_$SAMPLE -T 32 >& cegma.log
