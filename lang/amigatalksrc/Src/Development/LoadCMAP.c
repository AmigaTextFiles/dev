#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/graphics.h>

#include <stdio.h>
#include <stdlib.h>

#include "CustomLib.c"

#define	ERR_NONE	0
#define	ERR_ARGS	1
#define	ERR_MEM		2
#define	ERR_FILE	3
#define	ERR_READ	4
#define	ERR_FORM	5
#define ERR_LENGTH	6
#define	ERR_CMAP	7
#define	ERR_SCRN	8
#define	ERR_NOCMAP	9
#define ERR_ABOUT	10

const char*			versionstring	=     "LoadCMAP v1.2\n";
const char*			ver				="$VER:LoadCMAP v1.2";
const char*			usage 			="USAGE : LoadCMAP <Screen> <Palette-file>\n";
struct	Screen		*scrn=0;
struct	ColorMap	*cm=0;
BPTR				file=0;
long				size;
char				*cp;

void	Bye(long);

main(argc,argv)
int	argc;
char **argv;
{
	char	form[8];
	ULONG	v,r;
	char 	*pal;
	ULONG 	color,red,green,blue;
	
	if (argc == 1 || (argc == 2 && argv[1][0] == '?')) Bye(ERR_ABOUT);
	if (argc != 3) Bye(ERR_ARGS);

	file = Open(argv[2],MODE_OLDFILE);
	if (!file)	Bye(ERR_FILE);

	v = Read(file,form,8);
	if (v != 8) Bye(ERR_READ);

	if (*(long *)form != 0x464f524d) Bye (ERR_FORM); /*FORM*/

	size = *(long *)&form[4];
	cp = AllocMem(size,0);
	if (!cp) Bye(ERR_MEM);

	v = Read(file,cp,size);
	if (v != size)	Bye(ERR_LENGTH); /* Unexpected Size */

	pal = FindWord(cp,0x434d4150,size); /* CMAP */
	if (!pal) Bye(ERR_CMAP);

	scrn = LockPubScreen(argv[1]);
	if (!scrn) Bye(ERR_SCRN);

	cm = scrn->ViewPort.ColorMap;
	if (!cm) Bye(ERR_NOCMAP);

	v = *(long *)pal;
	v /= 3;
	pal += 4;
	r = 1 << (scrn->RastPort.BitMap->Depth);
	v = (v<r) ? v:r;

	color =0;
	while(v)
	{
		red = (*pal++)*0x01010101;
		green = (*pal++)*0x01010101;
		blue = (*pal++)*0x01010101;
		r = ObtainPen(cm,color,red,green,blue,0); /*PEN_EXCLUSIVE|PEN_NO_SETCOLOR*/
		if (r == -1) printf("Unable to obtain pen %d!\n",color);
		SetRGB32CM(cm,color++,red,green,blue);
		v--;
	}
	Bye(0);
}

void Bye(error)
long error;
{
	if (scrn) UnlockPubScreen(0,scrn);
	if (cp) FreeMem(cp,size);
	if (file) Close(file);
	switch (error)
	{
		case ERR_NONE:
		break;
		
		case ERR_ARGS:
		printf("Wrong number of arguments!\n");
		break;
		
		case ERR_MEM:
		printf("Unable to allocate memory!\n");
		break;
		
		case ERR_FILE:
		printf("Unable to open file!\n");
		break;
		
		case ERR_READ:
		printf("Error reading file!\n");
		break;
		
		case ERR_FORM:
		printf("No FORM in file!\n");
		break;
		
		case ERR_CMAP:
		printf("Not a ColorMAP file!\n");
		break;
		
		case ERR_LENGTH:
		printf("Unexpected length!\n");
		break;
		
		case ERR_SCRN:
		printf("Unable to lock on screen\n");
		break;
		
		case ERR_NOCMAP:
		printf("No colormap!\n");
		break;
		
		case ERR_ABOUT:
		printf("%s%s",versionstring,usage);
		break;
		
		default:
		printf("Unknown error code!\n");
		break;
	}
	exit(0);
}
