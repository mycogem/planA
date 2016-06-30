SAMPLE=`basename \`pwd\``
SN=`echo $SAMPLE  | perl -p -e 's/.*Run33_(\d+).*/$1/'`
CTGDIR=${SAMPLE}_megahit_out
CTGFILE=final.contigs.fa
CPU=32
ln -s /usr/local/pkg/BUSCO/fungi .
BUSCO -g ${CTGDIR}/${CTGFILE} -o BUSCO_${SAMPLE} -c $CPU -l fungi

