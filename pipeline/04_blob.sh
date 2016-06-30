SAMPLE=`basename \`pwd\``
SN=`echo $SAMPLE  | perl -p -e 's/.*Run33_(\d+).*/$1/'`
DATA1=~/data/trim_${SAMPLE}_S${SN}_R1_001.fastq.gz
# SO THIS SHOULD REALLY BE IN A MAKEFILE FORMAT BUT SHELL IS EASIER TO
# UNDERSTAND AT THIS POINT
# JS

DATA2=~/data/trim_${SAMPLE}_S${SN}_R2_001.fastq.gz
CTGDIR=${SAMPLE}_megahit_out
CTGFILE=final.contigs.fa
MINSIZE=1500
CPU=32
RND=${SAMPLE}.random_asm.fasta

NTDB=/usr/local/pkg/ncbi-db/nt
TAXDB=/usr/local/pkg/ncbi-db/taxdb

BLOBDIR=blob
mkdir -p $BLOBDIR

if [ ! -f $BLOBDIR/$RND ]; then
perl /usr/local/pkg/blobology/fastaqual_select.pl -f ${CTGDIR}/${CTGFILE} \
     -l 1500 -s L -rename "SAMPLE${SN}_"  > $BLOBDIR/$RND


fi

if [ ! -f $BLOBDIR/${RND}.1.bt2 ]; then
    bowtie2-build $BLOBDIR/$RND $BLOBDIR/$RND
fi

SHUFFLE=/usr/local/pkg/blobology/shuffleSequences_fastx.pl

BAMOUT=$BLOBDIR/${SAMPLE}.bowtie2.bam
if [ ! -f $BAMOUT ]; then
bowtie2 -x $BLOBDIR/$RND --very-fast-local -k 1 -t -p $CPU --reorder --mm \
        -U <($SHUFFLE 4 <(zcat $DATA1) <(zcat $DATA2)) \
        | samtools view -S -b -T $BLOBDIR/$RND - > $BAMOUT
fi

BLASTOUT=$BLOBDIR/${SAMPLE}.nt.1e-10.megablast
if [ ! -f $BLASTOUT ]; then

blastn \
-task megablast \
-query $RND \
-db  $NTDB  \
-outfmt '6 qseqid staxids bitscore std sscinames sskingdoms stitle' \
-culling_limit 5 \
-num_threads $CPU \
-evalue 1e-10 \
-out $BLASTOUT

fi

BLOBDB=$BLOBDIR/${SAMPLE}.BlobDB.json
if [ ! -f   ]; then
    /usr/local/pkg/blobtools/blobtools \
	create -i $BLOBDIR/${RND} \
	-o $BLOBDIR/${SAMPLE} -t $BLASTOUT \
	--nodes ${TAXDB}/nodes.dmp --names ${TAXDB}/names.dmp \
	-b $BAMOUT
fi


/usr/local/pkg/blobtools/blobtools blobplot -i $BLOBDB -o $BLOBDIR/${SAMPLE}
/usr/local/pkg/blobtools/blobtools blobplot -i $BLOBDB -o $BLOBDIR/${SAMPLE} -f pdf

