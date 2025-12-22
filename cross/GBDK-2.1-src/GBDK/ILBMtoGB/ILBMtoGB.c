#define INTUI_V36_NAMES_ONLY

#include <dos/rdargs.h>

#define OPT_FROM ((STRPTR)(ArgPtrs[0]))
#define OPT_TO ((STRPTR)(ArgPtrs[1]))
#define OPT_ASM ((BOOL)(ArgPtrs[2]))
#define OPT_FT ((ULONG*)(ArgPtrs[3]))
#define OPT_STD ((BOOL)(ArgPtrs[4]))
#define OPT_DN ((STRPTR)(ArgPtrs[5]))
#define OPT_FLAT ((BOOL)(ArgPtrs[6]))
#define OPT_V ((BOOL)(ArgPtrs[7]))

#define DEF_DATANAME "image"

#include "iffp/ilbmapp.h"

enum format_t {ASM_FORMAT,C_FORMAT};

#define NL fprintf(f,"\n");

#define BEGIN_COMMENT\
	fprintf(f,format==ASM_FORMAT?"\t;":"/*\n * ")
#define END_COMMENT\
	fprintf(f,format==ASM_FORMAT?"\n":"\n */\n")
#define NL_COMMENT\
	fprintf(f,format==ASM_FORMAT?"\n\t; ":"\n * ")
#define COMMENT(x)\
	fprintf(f,format==ASM_FORMAT?"; %s\n":"/* %s */\n",x)
#define IDENTIFIER(x)\
	fprintf(f,format==ASM_FORMAT?".%s:\n":"unsigned char %s[] = {\n",x)

typedef struct gbtile_struct
{
	UBYTE bmap[8][2];
} gbtile;

unsigned long __stack=16384;

void __chkabort(void) {}          /* Disable SAS CTRL-C checking. */

void bye(UBYTE *s, int e);
void cleanup(void);

struct Library *IFFParseBase=NULL;
struct Library *GfxBase=NULL;

/* ILBM frame */
struct ILBMInfo ilbm={0};


/* ILBM Property chunks to be grabbed - BMHD and CMAP needed for this app
 */
LONG ilbmprops[]=
{
	ID_ILBM,ID_BMHD,
	ID_ILBM,ID_CMAP,
	TAG_DONE
};

/* ILBM Collection chunks (more than one in file) to be gathered */
LONG *ilbmcollects=NULL;	/* none needed for this app */

/* ILBM Chunk to stop on */
LONG ilbmstops[]=
{
	ID_ILBM,ID_BODY,
	TAG_DONE
};

char* ilbmname=NULL;
char* outname=NULL;
char* dataname=NULL;

char HelpText[]="\n"
"ILBMtoGB is © 1998 by Lars Malmborg.\n"
"It is based upon the xloadimage extension © 1996 by Pascal Felber\n"
"and the ILBM parser from NDK3.1 © 1993 by Commodore-Amiga Inc.\n\n"
"Type \"ILBMtoGB ?\" for argument list.\n\n"
"From          - The ILBM to convert.\n"
"To            - Destination file for the tiles.\n"
"                (Defaults to input file name plus extension \".c\" or \".asm\".)\n"
"Assembler     - Generate assembler source instead of C.\n"
"FirstTile     - The first tile number to use.\n"
"                (Defaults to 0.)\n"
"StandardTiles - Use standard tiles in 0xFC to 0xFF.\n"
"DataName      - Part of the label names in the generated data.\n"
"                (Defaults to \"image\".) \n"
"Flat          - Generate an image to use with draw_image() in drawing.o.\n"
"                Input must be 160 x 144 x 2!\n"
"Verbose       - Write verbose information while generating source code.\n"
;

void gbDump(int width,int height,struct BitMap *bitmap,SHORT *cols,enum format_t format,int first,BOOL stdtiles,char* dataname,char* filename,BOOL flat,BOOL verbose);

main(void)
{
	LONG ArgPtrs[8]={0};
	struct RDArgs *Args;

	LONG error=NULL;

	enum format_t format=C_FORMAT;
	int first=0;
	BOOL std=FALSE;
	BOOL flat=FALSE;
	BOOL verbose=FALSE;
	ilbmname=NULL;
	outname=NULL;

	if(Args=ReadArgs("From/A,To/K,ASM=Assembler/S,FT=FirstTile/K/N,STD=StandardTiles/S,DN=DataName/K,Flat/S,V=Verbose/S",ArgPtrs,NULL))
	{
		if (OPT_FROM)
		{
			if (ilbmname=AllocVec(strlen(OPT_FROM)+1,MEMF_ANY|MEMF_CLEAR))
				strcpy(ilbmname,OPT_FROM);
		}

		if (OPT_TO)
		{
			if (outname=AllocVec(strlen(OPT_TO)+1,MEMF_ANY|MEMF_CLEAR))
				strcpy(outname,OPT_TO);
		}
		else
		{
			if (ilbmname)
			{
				if (outname=AllocVec(strlen(ilbmname)+4+1,MEMF_ANY|MEMF_CLEAR))
				{
					strcpy(outname,ilbmname);
					if (OPT_ASM)
						strcat(outname,".asm");
					else
						strcat(outname,".c");
				}
			}
		}

		if (OPT_ASM)
		{
			format=ASM_FORMAT;
		}

		if (OPT_FT)
		{
			first=(int)(*OPT_FT);
		}

		if (OPT_STD)
		{
			std=TRUE;
		}

		if (OPT_DN)
		{
			if (dataname=AllocVec(strlen(OPT_DN)+1,MEMF_ANY|MEMF_CLEAR))
				strcpy(dataname,OPT_DN);
		}
		else
		{
			if (dataname=AllocVec(strlen(DEF_DATANAME)+1,MEMF_ANY|MEMF_CLEAR))
				strcpy(dataname,DEF_DATANAME);
		}

		if (OPT_FLAT)
		{
			flat=TRUE;
		}

		if (OPT_V)
		{
			verbose=TRUE;
		}

		FreeArgs(Args);

		if(!(GfxBase = OpenLibrary("graphics.library",0)))
			bye("Can't open graphics.library",RETURN_FAIL);

		if(!(IFFParseBase = OpenLibrary("iffparse.library",0)))
			bye("Can't open iffparse.library",RETURN_FAIL);

/*
 * Here we set up default ILBMInfo fields for our
 * application's frames.
 * Above we have defined the propery and collection chunks
 * we are interested in (some required like BMHD)
 */
		ilbm.ParseInfo.propchks=ilbmprops;
		ilbm.ParseInfo.collectchks=ilbmcollects;
		ilbm.ParseInfo.stopchks=ilbmstops;
		if(!(ilbm.ParseInfo.iff=AllocIFF()))
			bye(IFFerr(IFFERR_NOMEM),RETURN_FAIL);	/* Alloc an IFFHandle */

		/* Load as a brush since we don't need to display it */
		if (error = loadbrush(&ilbm,ilbmname))
		{
			fprintf(stderr,"Can't load ilbm \"%s\",%s\n",ilbmname,IFFerr(error));
			bye("",RETURN_WARN);
		}
		else /* Successfully loaded ILBM */
		{
			if ((ilbm.camg&(HAM|EXTRA_HALFBRITE))||(ilbm.Bmhd.w%8)||(ilbm.Bmhd.h%8))
			{
				fprintf(stderr,"Only 4 color pictures where all dimensions are multiples of 8 are supported.\n");
			}
			else
			{
				if (dataname&&outname)
				{
					if (flat)
					{
						if ((ilbm.Bmhd.w==160)||(ilbm.Bmhd.h==144))
							gbDump(ilbm.Bmhd.w,ilbm.Bmhd.h,ilbm.brbitmap,ilbm.colortable,format,0,FALSE,dataname,outname,flat,verbose);
						else
							fprintf(stderr,"Only 160 x 144 x 2 pictures are supported when generating \"Flat\" data.\n");
					}
					else
					{
						gbDump(ilbm.Bmhd.w,ilbm.Bmhd.h,ilbm.brbitmap,ilbm.colortable,format,first,std,dataname,outname,flat,verbose);
					}
				}
			}
			unloadbrush(&ilbm);

		  if(error)
				bye(IFFerr(error),RETURN_WARN);
		  else
				bye("",RETURN_OK);
		}
	}
	else
	{
		puts(HelpText);
		FreeArgs(Args);
		exit(0);
	}
}

/*
void printtile(gbtile* tile)
{
	int i,j;
	for (i=0;i<8;i++)
	{
		for (j=7;j>=0;j--)
		{
			switch ((((tile->bmap[i][0])>>j)&0x01)|(((tile->bmap[i][1])>>j)&0x01)<<1)
			{
				case 0:
					printf("0");
					break;
				case 1:
					printf("1");
					break;
				case 2:
					printf("2");
					break;
				case 3:
					printf("3");
					break;
				default:
					break;
			}
		}
		printf("\n");
	}
	printf("\n");
}
*/

void gbDump(int width,int height,struct BitMap *bitmap,SHORT *cols,enum format_t format,int first,BOOL stdtiles,char* dataname,char* filename,BOOL flat,BOOL verbose)
{
  FILE *f;

	int i,j;
	int x,y,c;
  int last;
  int std;

	gbtile *tiles;
  gbtile t;

	char buffer[128];
  UBYTE *buf,*b;

/*
	gbtile testtile;
	testtile.bmap[0][0]=0x00;testtile.bmap[0][1]=0x00;
	testtile.bmap[1][0]=0xff;testtile.bmap[1][1]=0x00;
	testtile.bmap[2][0]=0x00;testtile.bmap[2][1]=0xff;
	testtile.bmap[3][0]=0xff;testtile.bmap[3][1]=0xff;
	testtile.bmap[4][0]=0x01;testtile.bmap[4][1]=0x00;
	testtile.bmap[5][0]=0x00;testtile.bmap[5][1]=0x80;
	testtile.bmap[6][0]=0x30;testtile.bmap[6][1]=0xf0;
	testtile.bmap[7][0]=0x0f;testtile.bmap[7][1]=0x03;
	printtile(&testtile);
*/

	if (verbose)
	{
		fprintf(stderr,"Dumping GB image to \"%s\"",filename);
		fprintf(stderr," (size: %d x %d x %d)\n",width,height,bitmap->Depth);
		if (flat)
			fprintf(stderr,"Generating \"Flat\" data\n");
	}

	if(!(f=fopen(filename,"w")))
	{
		fprintf(stderr, "Could not open target \"%s\".\n",filename);
		return;
	}

/*
	f=stdout;
*/

	if (stdtiles)
		std=4;
	else
		std=0;

	last=first;

	if (verbose)
	{
		fprintf(stderr,"First tile is 0x%02x\n",first);
		if (stdtiles)
			fprintf(stderr,"Using standard tiles in 0xFC to 0xFF\n");
		fprintf(stderr,"Dump format is %s\n",format==ASM_FORMAT?"Assembler":"C");
	}

	if(tiles=(gbtile*)AllocVec((width/8)*(height/8)*sizeof(gbtile),MEMF_ANY|MEMF_CLEAR))
	{
		if(stdtiles)
		{
			// Create the 4 basic tiles
			for (i=0;i<8;i++)
			{
				tiles[0xFF].bmap[i][0]=tiles[0xFF].bmap[i][1]=
					tiles[0xFE].bmap[i][0]=tiles[0xFD].bmap[i][1]=0x00;
				tiles[0xFD].bmap[i][0]=tiles[0xFE].bmap[i][1]=
					tiles[0xFC].bmap[i][0]=tiles[0xFC].bmap[i][1]=0xFF;
			}
		}

		// Create tiles list
		if (buf=(UBYTE*)AllocVec((bitmap->BytesPerRow)*(bitmap->Rows/8)*sizeof(UBYTE),MEMF_ANY|MEMF_CLEAR))
		{
			b=buf;

			// Loop over tile rows
			for(y=0;y<height/8;y++)

				// Loop over tile columns
				for(x=0;x<width/8;x++)
				{
					if (flat)
					{
						for(i=0;i<8;i++)
						{
							tiles[last].bmap[i][0]=(UBYTE)*((bitmap->Planes[0])+8*y*bitmap->BytesPerRow+i*bitmap->BytesPerRow+x);
							tiles[last].bmap[i][1]=(UBYTE)*((bitmap->Planes[1])+8*y*bitmap->BytesPerRow+i*bitmap->BytesPerRow+x);
						}
						last++;
					}
					else
					{
						// Copy current position to temporary tile
						for(i=0;i<8;i++)
						{
							t.bmap[i][0]=(UBYTE)*((bitmap->Planes[0])+8*y*bitmap->BytesPerRow+i*bitmap->BytesPerRow+x);
							t.bmap[i][1]=(UBYTE)*((bitmap->Planes[1])+8*y*bitmap->BytesPerRow+i*bitmap->BytesPerRow+x);
						}

						// Check if current tile is a standard one
						for(c=0x100-std;c<0x100;c++)
						{
							if(memcmp(tiles[c].bmap,t.bmap,sizeof(t.bmap))==0)
								break;
						}

						// Current tile is not a standard one
						if(c>=0x100)
						{
							c=first;
							while(c<last)
							{
								if(memcmp(tiles[c].bmap,t.bmap,sizeof(t.bmap))==0)
								{
									break;
								}
								c++;
							}

							// Remember this new tile
							if(c==last)
							{
								if(last>=0x100-std)
								{
									fprintf(stderr, "Image contains too many tiles.\n");
									if (unlink(filename))
										fprintf(stderr, "Could not delete target \"%s\".\n",filename);
									return;
								}
								memcpy(tiles[last].bmap,t.bmap,sizeof(t.bmap));
								last++;
							}
						}
						*b=c;
						b++;
					}
				}
			if (verbose)
			{
				fprintf(stderr,"Found %d unique tiles\n",last-first);
			}

/*
			for (i=first;i<last;i++)
			{
				printf("Tile: %d\n",i);
				printtile(&tiles[i]);
			}
*/

			// Write image info to file
			BEGIN_COMMENT;
			fprintf(f,"Image size: %d x %d",width,height);
			NL_COMMENT;
			if (flat)
			{
				fprintf(f,"Use draw_image(%s_data); to display image",dataname);
			}
			else
			{
				fprintf(f, "Number of tiles (total - unique): 0x%02X - 0x%02X",
					(width/8)*(height/8),last-first);
			}
			END_COMMENT;
			NL;

			// Write image data to file
			if (stdtiles)
			{
				IDENTIFIER("stdtiles_data");
				fprintf(f,"\t");
				COMMENT("Basic tiles (0xFC to 0xFF)");
				for (i=0x100-std;i<0x100;i++)
				{
					fprintf(f,"\t");
					if (format==ASM_FORMAT)
						fprintf(f,".byte\t");
					for (j=0;j<8;j++)
					{
						fprintf(f,"0x%02X,",tiles[i].bmap[j][0]);
						fprintf(f,"0x%02X",tiles[i].bmap[j][1]);
						if (j<7||(format==C_FORMAT&&i<0x100-1))
							fprintf(f,",");
					}
					fprintf(f,"\n");
				}
				if(format==C_FORMAT)
					fprintf(f,"};\n");
				NL;
			}

			sprintf(buffer,"%s_data",dataname);
			IDENTIFIER(buffer);
			i=first;
			while(i<last)
			{
				if(i==first||i%4==0)
				{
					if (flat)
					{
						if (i%20==0)
						{
						fprintf(f,"\n\t");
							sprintf(buffer,"Row %d",i/20);
							COMMENT(buffer);
						}
						else
						{
							fprintf(f,"\n");
						}
					}
					else
					{
						fprintf(f,"\n\t");
						sprintf(buffer,"Tile 0x%02X",i);
						COMMENT(buffer);
					}
				}
				fprintf(f,"\t");
				if (format==ASM_FORMAT)
					fprintf(f,".byte\t");
				for(j=0;j<8;j++)
				{
					fprintf(f,"0x%02X,",tiles[i].bmap[j][0]);
					fprintf(f,"0x%02X",tiles[i].bmap[j][1]);
					if (j<7||(format==C_FORMAT&&i<last-1))
						fprintf(f,",");
				}
				fprintf(f,"\n");
				i++;
			}
			if (format==C_FORMAT)
				fprintf(f,"};\n");
			NL;

			if (!flat)
			{
				// Write image table to file
				sprintf(buffer,"%s_tiles",dataname);
				IDENTIFIER(buffer);
				b=buf;
				for (y=0;y<height;y+=8)
				{
					fprintf(f,"\t");
					if (format == ASM_FORMAT)
						fprintf(f, ".byte\t");
					for (x=0;x<width;x+=8)
					{
						fprintf(f,"0x%02X",*b);
						if(x<width-8||(format==C_FORMAT&&y<height-8))
							fprintf(f,",");
						b++;
					}
					fprintf(f,"\n");
				}
				if(format==C_FORMAT)
					fprintf(f,"};\n");
			}

			fclose(f);
			FreeVec(buf);
		}
		else
		{
			fprintf(stderr,"Could not allocate tile map.\n");
		}

		FreeVec(tiles);
	}
	else
	{
		fprintf(stderr,"Could not allocate tile buffer.\n");
	}
}

void bye(UBYTE *s,int e)
{
	if(s&&(*s))
		printf("%s\n",s);
	cleanup();
	exit(e);
}

void cleanup(void)
{
	if (ilbmname)
		FreeVec(ilbmname);
	if (outname)
		FreeVec(outname);
	if (dataname)
		FreeVec(dataname);
	if (ilbm.ParseInfo.iff)
		FreeIFF(ilbm.ParseInfo.iff);
	if (IFFParseBase)
		CloseLibrary(IFFParseBase);
	if(GfxBase)
		CloseLibrary(GfxBase);
}





