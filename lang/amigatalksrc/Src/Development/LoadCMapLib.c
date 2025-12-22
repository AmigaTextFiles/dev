char	*FindWord(char *,long,long);
void	Ink(struct ViewPort *,ULONG,UBYTE,UBYTE,UBYTE);

char	*FindWord(cp,code,maxbytes)
char	*cp;
long	code;
long	maxbytes;
{
	for (;maxbytes;cp++,maxbytes--)
		if (*(long*)cp == code) return(cp+4);
	return(0);
}

void	Ink(vp,color,red,green,blue)
struct	ViewPort	*vp;
ULONG	color;
UBYTE	red,green,blue;
{
	SetRGB32(vp,color,red*0x01010101L,green*0x01010101L,blue*0x01010101L);
}