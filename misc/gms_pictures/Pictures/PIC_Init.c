
#include <proto/dpkernel.h>
#include <system/all.h>
#include <dpkernel/prefs.h>
#include "defs.h"

/************************************************************************************
** Action: CheckFile()
** Object: Picture
*/

LIBFUNC LONG PIC_CheckFile(mreg(__a0) struct File *File, mreg(__a1) LONG *Buffer)
{
  if (Buffer[0] IS CODE_FORM AND Buffer[2] IS CODE_ILBM) {
     DPrintF("2CheckFile:","File identified as a Picture");
     return(99);
  }
  else {
     return(NULL);
  }
}

/************************************************************************************
** Action: Free()
** Object: Picture
*/

LIBFUNC void PIC_Free(mreg(__a0) struct Picture *pic)
{
  if (pic->prvData)    FreeMemBlock(pic->prvData);
  if (pic->prvPalette) FreeMemBlock(pic->prvPalette);
  if (pic->Bitmap)     Free(pic->Bitmap);
  Public->OpenCount--;
}

/************************************************************************************
** Action: Get()
** Object: Picture
*/

LIBFUNC struct Picture * PIC_Get(mreg(__a0) struct Picture *Picture)
{
   if (Picture->Bitmap = Get(ID_BITMAP)) {
      Picture->Bitmap->Parent = Picture;
      Public->OpenCount++;
      return(Picture);
   }
   else DPrintF("!Get:","Failed to obtain a Bitmap for this Picture.");
   return(NULL);
}

/************************************************************************************
** Action: Init()
** Object: Picture
**
** Loads in a picture, automatically depacking it, assessing the info header and
** then copying it out to the bitmap.
*/

LIBFUNC LONG PIC_Init(mreg(__a0) struct Picture *Picture)
{
  struct File *File = NULL;
  struct BMHD *BMHD = NULL;
  LONG BodyPos  = NULL;
  LONG CAMG     = NULL;
  LONG *CMAP    = NULL;
  LONG *Buffer  = NULL;
  LONG error    = ERR_FAILED;
  APTR FILBase  = GVBase->FileBase;    /* Seek() and OpenFile() */
  WORD FreeFile = FALSE;
  LONG FileSize;

  /* Open the file and allocate a read buffer.  Note that we check
  ** if the Picture->Source is an initialised File, because we do
  ** not want to open the file twice (illegal).
  */

  if (((struct Head *)Picture->Source)->ID IS ID_FILE) {
     if (CheckInit(Picture->Source) IS TRUE) {
        File = Picture->Source;
     }
  }

  if (File IS NULL) {
     if ((File = OpenFile(Picture->Source,FL_READ)) IS NULL) {
        error = ErrCode(ERR_FILE);
        goto exit;
     }
     else FreeFile = TRUE;
  }

  Buffer = AllocMemBlock(BUFFERSIZE,MEM_DATA); /* Allocate a 4k buffer */

  /*** Check for the initial FORM/ILBM part ***/

  Seek(File, 0, POS_START); /* Required in case Picture->Source has been used */
  Read(File, Buffer, 12);   /* [FORM] [Size] [ILBM] */
  if ((Buffer[0] != CODE_FORM) OR (Buffer[2] != CODE_ILBM)) {
     DPrintF("!Init:","This file does not start with a FORM/ILBM header.");
     error = ERR_DATA;
     goto exit;
  }

  FileSize = Buffer[1];

  /*** Read each iff chunk in the file ***/

  while ((FileSize > 0) AND (BodyPos IS NULL)) {
     if (Read(File,Buffer,8) != 8) { /* [CODE] [Size] */
        DPrintF("!Query","I could not read the next chunk.");
        goto exit;
     }

     if (Buffer[1] & 0x00000001) Buffer[1] += 1;

     FileSize -= Buffer[1];

     if (Buffer[0] IS CODE_CMAP) {
        DPrintF("3Init:","IFF CMAP header found.");
        if (Buffer[1] > BUFFERSIZE) goto exit;
        if (CMAP = AllocMemBlock(Buffer[1],MEM_DATA)) {
           Read(File, CMAP, Buffer[1]);
        }
     }
     else if (Buffer[0] IS CODE_BMHD) {
        DPrintF("3Init:","IFF BMHD header found.");
        if (Buffer[1] > BUFFERSIZE) goto exit;
        if (BMHD = AllocMemBlock(Buffer[1],MEM_DATA)) {
           if (Read(File, BMHD, Buffer[1]) != Buffer[1]) {
              error = ErrCode(ERR_READ);
              goto exit;
           }
        }
        else {
           error = ErrCode(ERR_MEMORY);
           goto exit;
        }
     }
     else if (Buffer[0] IS CODE_CAMG) {
        DPrintF("3Init:","IFF CAMG header found.");
        if (Buffer[1] > BUFFERSIZE) goto exit;
        if (Read(File,Buffer,Buffer[1]) IS Buffer[1]) {
           CAMG = Buffer[0];
        }
        else {
           error = ErrCode(ERR_READ);
           goto exit;
        }
     }
     else if (Buffer[0] IS CODE_BODY) {
        DPrintF("Init:","IFF BODY header found.");
        BodyPos = File->BytePos;
     }
     else {
        if (Seek(File, Buffer[1], POS_CURRENT) IS -1) { /* Skip to the next chunk */
            DPrintF("!Init:","I could not seek to the correct file position.");
            goto exit;
        }
     }
  }

  if (BodyPos) {
     /* Query the Picture and then initialise the Bitmap before
     ** unpacking the file.
     */

     if (Query(Picture) IS ERR_OK) {
        Init(Picture->Bitmap,NULL);
        Seek(File, BodyPos, POS_START);
        error = UnpackPicture(Picture,BMHD,File,CMAP,CAMG);
     }
     else DPrintF("!Init:","Could not query picture information.");
  }
  else DPrintF("!Init:","Picture has no BODY chunk.");

  /*** Check for a Palette ***/

  if ((Picture->Bitmap->AmtColours <= 256) AND (Picture->Bitmap->Palette IS NULL)) {
     DPrintF("!Init:","Warning - I could not obtain a palette from the file.");
  }

exit:
  if (Buffer) FreeMemBlock(Buffer);
  if (BMHD)   FreeMemBlock(BMHD);
  if (CMAP)   FreeMemBlock(CMAP);
  if (FreeFile IS TRUE) Free(File);
  return(error);
}

/************************************************************************************
** Action: Load()
** Object: Picture
**
** Loads in an object file that is known to be of the Picture class.  This action
** will get the palette of the Picture if there is one, and store the data in
** standard memory.
**
** We use the File->Source rather than just the File, because we must assume
** that the File object will be freed by Load() and only the source will continue
** to be valid.
*/

LIBFUNC struct Picture * PIC_Load(mreg(__a0) struct File *File)
{
  struct Picture *Picture;

  Picture = InitTags(NULL,
    TAGS_PICTURE, NULL,
    PCA_Source,   File->Source,
    TAGEND);

  return(Picture);
}

/************************************************************************************
** Action: Query()
** Object: Picture
**
** Gets picture information - width, height, amount of colors, planes etc.  It does
** not grab the data of the picture.
*/

LIBFUNC LONG PIC_Query(mreg(__a0) struct Picture *Picture)
{
  struct BMHD   *BMHD   = NULL;
  struct File   *File   = NULL;
  struct Bitmap *Bitmap;
  LONG   error    = ERR_FAILED; /* The default code is for failure */
  LONG   CAMG     = NULL;
  LONG   *CMAP    = NULL;
  LONG   CMAPSize = NULL;       /* Size of the CMAP array */
  LONG   *Buffer  = NULL;
  WORD   FreeFile = FALSE;
  APTR   BLTBase  = GVBase->BlitterBase; /* GetBmpType() */
  APTR   FILBase  = GVBase->FileBase;    /* Seek() and OpenFile() */
  BYTE   *SrcPalette;
  BYTE   *DestPalette;
  LONG   i;
  LONG   FileSize;

  DPrintF("~Query()","Picture: $%x", Picture);

  /*** Validation procedures ***/

  if ((Bitmap = Picture->Bitmap) IS NULL) {
     DPrintF("!Query;","No Picture->Bitmap present.");
     goto exit;
  }

  /* Open the file and allocate a read buffer.  Note that we check
  ** if the Picture->Source is an initialised File, because we do
  ** not want to open the file twice (illegal).
  */

  if (((struct Head *)Picture->Source)->ID IS ID_FILE) {
     if (CheckInit(Picture->Source) IS TRUE) {
        File = Picture->Source;
     }
  }

  if (File IS NULL) {
     if ((File = OpenFile(Picture->Source,FL_READ)) IS NULL) {
        error = ErrCode(ERR_FILE);
        goto exit;
     }
     else FreeFile = TRUE;
  }

  Buffer = AllocMemBlock(BUFFERSIZE,MEM_DATA); /* Allocate a 4k buffer */

  /*** Check for the initial FORM/ILBM part ***/

  Seek(File, 0, POS_START); /* Required in case Picture->Source has been used */
  Read(File, Buffer, 12);   /* [FORM] [Size] [ILBM] */
  if ((Buffer[0] != CODE_FORM) OR (Buffer[2] != CODE_ILBM)) {
     DPrintF("!Query:","This file does not start with a FORM/ILBM header.");
     error = ERR_DATA;
     goto exit;
  }

  FileSize = GetFSize(File);

  /*** Read each iff chunk in the file ***/

  while (File->BytePos < FileSize) {
     if (Read(File,Buffer,8) != 8) { /* [CODE] [Size] */
        DPrintF("!Query:","I could not read the next chunk.");
        break;
     }

     if (Buffer[1] & 0x00000001) Buffer[1] += 1;

     if (Buffer[0] IS CODE_CMAP) {
        DPrintF("3Query:","IFF CMAP header found.");
        if (Buffer[1] > BUFFERSIZE) goto exit;

        CMAPSize = Buffer[1]/3;
        if (CMAP = AllocMemBlock(Buffer[1],MEM_DATA)) {
           Read(File, CMAP, Buffer[1]);
        }
     }
     else if (Buffer[0] IS CODE_BMHD) {
        DPrintF("3Query:","IFF BMHD header found.");
        if (Buffer[1] > BUFFERSIZE) goto exit;
        if (BMHD = AllocMemBlock(Buffer[1],MEM_DATA)) {
           if (Read(File, BMHD, Buffer[1]) != Buffer[1]) {
              error = ErrCode(ERR_READ);
              goto exit;
           }
        }
        else {
           error = ErrCode(ERR_MEMORY);
           goto exit;
        }
     }
     else if (Buffer[0] IS CODE_CAMG) {
        DPrintF("3Query:","IFF CAMG header found.");
        if (Buffer[1] > BUFFERSIZE) goto exit;
        if (Read(File,Buffer,Buffer[1]) IS Buffer[1]) {
           CAMG = Buffer[0];
        }
        else {
           error = ErrCode(ERR_READ);
           goto exit;
        }
     }
     else {
        DPrintF("3Query:","Unused chunk, skipping %ld bytes.",Buffer[1]);
        if (Seek(File, Buffer[1], POS_CURRENT) IS -1) { /* Skip to the next chunk */
            DPrintF("!Query:","I could not seek to the correct file position.");
            goto exit;
        }
     }
  }

  if (BMHD) {
     if (Bitmap->AmtColours IS NULL) Bitmap->AmtColours = CMAPSize;
     if (Bitmap->Height IS NULL)     Bitmap->Height     = BMHD->Height;
     if (Bitmap->Planes IS NULL)     Bitmap->Planes     = BMHD->Depth;
     if (Bitmap->Type IS NULL)       Bitmap->Type       = GetBmpType(); /* User preference */
     if (Picture->ScrWidth IS NULL)  Picture->ScrWidth  = BMHD->ScrWidth;
     if (Picture->ScrHeight IS NULL) Picture->ScrHeight = BMHD->ScrHeight;
     if (Bitmap->Width IS NULL) {
        Bitmap->Width     = BMHD->Width;
        Bitmap->ByteWidth = NULL;        /* Let the Init(Bitmap) calculate it */
     }
  }

  if (CAMG) {
     /* Note that if the programmer has preset a non-planar mode,
     ** then we cannot set HAM or EHB bits (the picture will be
     ** converted so special graphic flags do not apply).
     */

     if ((Bitmap->Type IS ILBM) OR (Bitmap->Type IS PLANAR)) {
        if ((Bitmap->Planes IS 6) OR (Bitmap->Planes IS 8)) {
           if (CAMG & OSV_HAM) Picture->Bitmap->Flags |= BMF_HAM;
           if (CAMG & OSV_EHB) Picture->Bitmap->Flags |= BMF_EXTRAHB;
        }
     }

     if (CAMG & OSV_LACED) Picture->ScrMode |= SM_LACED;
     if (CAMG & OSV_HIRES) {
        Picture->ScrMode |= SM_HIRES;
     }
     else Picture->ScrMode |= SM_LORES;
  }

  /*** Generate Palette ***/

  if ((Bitmap->Palette IS NULL) AND (Bitmap->AmtColours <= 256) AND (CMAP)) {
     if (Bitmap->Palette = AllocMemBlock((Bitmap->AmtColours * 4)+8,MEM_DATA)) {
        Picture->prvPalette = Bitmap->Palette;
        Bitmap->Palette[0]  = PALETTE_ARRAY;
        Bitmap->Palette[1]  = Bitmap->AmtColours;
        SrcPalette          = (BYTE *)CMAP;
        DestPalette         = ((BYTE *)Bitmap->Palette)+8;
        for (i=0; i < Bitmap->AmtColours; i++) {
           DestPalette[1] = SrcPalette[0];
           DestPalette[2] = SrcPalette[1];
           DestPalette[3] = SrcPalette[2];
           DestPalette += 4;
           SrcPalette  += 3;
        }
     }
     else {
        error = ErrCode(ERR_MEMORY);
        goto exit;
     }
  }

  /* Re/Initialise the Picture->Bitmap.  Note that because we are only
  ** querying the Bitmap we set up a dummy data pointer.
  */

  if (Query(Bitmap) != ERR_OK) {
     DPrintF("!Query:","Failed to Query() the Bitmap.");
     goto exit;
  }

  error = ERR_OK;

exit:
  if (Buffer) FreeMemBlock(Buffer);
  if (BMHD)   FreeMemBlock(BMHD);
  if (CMAP)   FreeMemBlock(CMAP);
  if (FreeFile IS TRUE) Free(File);
  StepBack();
  return(error);
}

/************************************************************************************
** Actions: File support.
** Object:  Picture
** Short:   These routines allow you to read/write to a Picture's Bitmap.
*/

LIBFUNC LONG PIC_Read(mreg(__a0) struct Picture *Picture, mreg(__a1) BYTE *Buffer, mreg(__d0) LONG Length) {
  return(Read(Picture->Bitmap,Buffer,Length));
}

LIBFUNC LONG PIC_Seek(mreg(__a0) struct Picture *Picture, mreg(__d0) LONG Offset, mreg(__d1) WORD Position) {
  return(Seek(Picture->Bitmap,Offset,Position));
}

LIBFUNC LONG PIC_Write(mreg(__a0) struct Picture *Picture, mreg(__a1) BYTE *Buffer, mreg(__d0) LONG Length) {
  return(Write(Picture->Bitmap,Buffer,Length));
}

