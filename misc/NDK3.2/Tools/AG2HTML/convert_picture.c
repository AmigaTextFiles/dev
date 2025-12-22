/*
 * $Id: convert_picture.c 1.4 1998/12/12 14:45:04 olsen Exp olsen $
 *
 * :ts=4
 */

#include <exec/memory.h>

#include <datatypes/pictureclass.h>

#include <dos/dosextens.h>
#include <dos/rdargs.h>

#include <clib/datatypes_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/alib_protos.h>

#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/datatypes_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/dos_pragmas.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************/

extern struct Library * DataTypesBase;
extern struct Library * GfxBase;
extern struct Library * SysBase;
extern struct Library * DOSBase;
extern struct Library * UtilityBase;

/******************************************************************************/

extern void WriteGIF(FILE *fp, unsigned char *pic, int w, int h, unsigned char *rmap, unsigned char *gmap, unsigned char *bmap, int numcols);

/******************************************************************************/

STATIC UBYTE r[256];
STATIC UBYTE g[256];
STATIC UBYTE b[256];

/******************************************************************************/

BOOL
ConvertPicture(BPTR fromDir,STRPTR from,STRPTR to,int * pWidth,int * pHeight)
{
	struct BitMap * bitmap = NULL;
	UBYTE * picture = NULL;
	Object * pictureObject;
	LONG numColours = 0;
	LONG width = 0;
	LONG height = 0;
	BOOL result = FALSE;
	BPTR oldDir;

	oldDir = CurrentDir(fromDir);

	pictureObject = NewDTObject(from,
		DTA_SourceType,	DTST_FILE,
		DTA_GroupID,	GID_PICTURE,
		PDTA_Remap,		FALSE,
	TAG_DONE);

	CurrentDir(oldDir);

	if(pictureObject != NULL)
	{
		struct FrameInfo fri;

		memset(&fri,0,sizeof(fri));

		if(DoMethod(pictureObject,DTM_FRAMEBOX,NULL,&fri,&fri,sizeof(fri),0) && fri.fri_Dimensions.Depth > 0)
		{
			if(DoMethod(pictureObject,DTM_PROCLAYOUT,NULL,TRUE))
			{
				ULONG * cregs;
				struct BitMapHeader * bmh;
				struct BitMap * bm;

				bm = NULL;
				GetDTAttrs(pictureObject,
					PDTA_CRegs,			&cregs,
					PDTA_NumColors,		&numColours,
					PDTA_BitMapHeader,	&bmh,
					PDTA_BitMap,		&bm,
				TAG_DONE);

				if(bm != NULL)
				{
					int i;
					BOOL patchColours;

					memset(r,0,sizeof(r));
					memset(g,0,sizeof(g));
					memset(b,0,sizeof(b));

					for(i = 0 ; i < numColours ; i++)
					{
						r[i] = (cregs[i * 3 + 0] >> 24);
						g[i] = (cregs[i * 3 + 1] >> 24);
						b[i] = (cregs[i * 3 + 2] >> 24);
					}

					patchColours = TRUE;

					for(i = 0 ; patchColours && i < numColours ; i++)
					{
						if((r[i] & 0x0F) != 0x00 ||
						   (g[i] & 0x0F) != 0x00 ||
						   (b[i] & 0x0F) != 0x00)
						{
							patchColours = FALSE;
						}
					}

					if(patchColours)
					{
						for(i = 0 ; i < numColours ; i++)
						{
							r[i] = 0x11 * (r[i] >> 4);
							g[i] = 0x11 * (g[i] >> 4);
							b[i] = 0x11 * (b[i] >> 4);
						}
					}

					bitmap = AllocBitMap(bmh->bmh_Width,1,bmh->bmh_Depth,0,bm);
					if(bitmap != NULL)
					{
						struct RastPort tempRPort;
						LONG modulo;
						UBYTE * oneLine;

						InitRastPort(&tempRPort);
						tempRPort.BitMap = bitmap;

						modulo = (bmh->bmh_Width + 15) & ~15;
						width = bmh->bmh_Width;
						height = bmh->bmh_Height;

						picture = AllocVec(width * bmh->bmh_Height,MEMF_ANY|MEMF_CLEAR);
						oneLine = AllocVec(modulo,MEMF_ANY|MEMF_CLEAR);

						if(oneLine != NULL && picture != NULL)
						{
							struct RastPort sourceRPort;
							UBYTE * currentLine;
							LONG i;

							InitRastPort(&sourceRPort);
							sourceRPort.BitMap = bm;

							currentLine = picture;

							for(i = 0 ; i < height ; i++)
							{
								ReadPixelLine8(&sourceRPort,0,i,width,oneLine,&tempRPort);

								memcpy(currentLine,oneLine,width);
								currentLine += width;
							}
						}

						FreeVec(oneLine);
					}
				}
			}
		}
	}

	if(bitmap != NULL)
	{
		WaitBlit();
		FreeBitMap(bitmap);
	}

	if(pictureObject != NULL)
	{
		DisposeDTObject(pictureObject);
	}

	if(picture != NULL)
	{
		FILE * out;

		out = fopen(to,"wb");
		if(out != NULL)
		{
			WriteGIF(out,picture,width,height,r,g,b,numColours);

			(*pWidth)	= width;
			(*pHeight)	= height;

			result = TRUE;

			fclose(out);
		}

		FreeVec(picture);
	}

	return(result);
}
