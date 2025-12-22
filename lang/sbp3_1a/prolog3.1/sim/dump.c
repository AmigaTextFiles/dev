/***************************************************************************
			 DIAGNOSTIC DUMP ROUTINE
***************************************************************************/
#define BPL 16
void dump(adr,len)
UBYTE *adr;
long len;
{
	unsigned char	 *strtchr,*endchr,*cnt;

	endchr = (unsigned char *) (adr + len -1);
	for (strtchr = (unsigned char *) adr;
	   strtchr <= endchr; strtchr += BPL) {
		printf("%08lX: ",(long) strtchr);
		for (cnt = strtchr; cnt < strtchr + BPL; cnt++)
			printf(" %02X",(int) *cnt);
		printf("    ");
		for (cnt = strtchr; cnt < strtchr + BPL; cnt++)
			if (!isalpha(*cnt))
			   printf(".");
			else
			   printf("%c", *cnt);
		printf("\n");
	}
}

