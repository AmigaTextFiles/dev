/*
 * readiff.c  V2.1
 *
 * read IFF ILBM/ANIM files
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Bitmap header (BMHD) structure */
struct BitMapHeader {
                     UWORD w,h;                   /* Width, height in pixels */
                     WORD  x,y;
                     UBYTE nplanes;               /* Number of planes */
                     UBYTE Masking;               /* Masking */
                     UBYTE Compression;           /* Compression algorithm */
                     UBYTE pad1;
                     UWORD TransparentColor;
                     UBYTE XAspect,YAspect;
                     WORD  PageWidth, PageHeight;
                    };
#define MSK_HASMASK   1
#define COMP_NO       0
#define COMP_BYTERUN1 1
#define BPR(w)        ((((w)+15)>>4)<<1) /* Bytes per row formula */

/* Animation header (ANHD) structure */
struct AnimHeader {
                   UBYTE operation;  /* We only accept code 5 */
                   UBYTE mask;
                   UWORD w,h;
                   WORD  x,y;
                   ULONG abstime;
                   ULONG reltime;    /* timing in jiffies (1/60 seconds) */
                   UBYTE interleave; /* We only accept 0(=2), 1 & 2 */
                   UBYTE pad0;
                   ULONG bits;
                  };

/* IFF ID's */
#define ID_ILBM MAKE_ID('I','L','B','M')
#define ID_BMHD MAKE_ID('B','M','H','D')
#define ID_BODY MAKE_ID('B','O','D','Y')
#define ID_ANIM MAKE_ID('A','N','I','M')
#define ID_ANHD MAKE_ID('A','N','H','D')
#define ID_DLTA MAKE_ID('D','L','T','A')

/* Read IFF ILBM BODY Chunk */
static BOOL ReadBODYChunk(struct IFFHandle *iff, struct BitMapHeader *bmhd,
                          UBYTE *dest, ULONG bpr, ULONG planeoff)
{
 UBYTE *src;
 ULONG size=CurrentChunk(iff)->cn_Size;
 BOOL rc=FALSE;

 DEBUG_PRINTF("IFF: Read BODY chunk\n");

 /* Get memory for BODY chunk contents */
 if (src=AllocMem(size,MEMF_PUBLIC)) {
  /* Read in the complete BODY chunk */
  if (ReadChunkBytes(iff,src,size)==size) {
   register UBYTE *sp=src;
   ULONG row;
   BOOL ncomp=bmhd->Compression==COMP_NO;
   BOOL mask=bmhd->Masking==MSK_HASMASK;

   /* Read data row by row */
   for (row=0; row<bmhd->h; row++) {
    ULONG pl;

    /* Read data plane by plane */
    for (pl=0; pl<bmhd->nplanes; pl++) {
     UBYTE *dp;

     /* Calculate destination pointer */
     dp=dest+pl*planeoff+row*bpr;

     /* Compressed? */
     if (ncomp) {
      /* No compression */
      UBYTE k;

      for (k=bpr; k--;) *dp++=*sp++; /* Copy all bytes */
     } else {
      /* Byte Run compression */
      ULONG rem=bpr;

      /* Row not completed */
      while (rem) {
       BYTE k=*sp++; /* Read compression code */

       if (k>=0) {
        /* Literal copy */
        if ((rem-=++k)<0) goto comperr; /* Error in de-compression? */

        while (k--) *dp++=*sp++;        /* Copy the following k+1 bytes */
       } else if (k!=-128) {            /* Code -128 == No Operation */
        /* Byte run encoded */
        UBYTE byte;

        k=-k;
        if ((rem-=++k)<0) goto comperr; /* Error in de-compression? */

        byte=*sp++;                     /* Get byte */
        while (k--) *dp++=byte;         /* Copy this byte -k+1 times */
       }
      }
     }
    }

    /* Skip mask plane */
    if (mask)
     /* Compressed? */
     if (ncomp)
      /* No compression */
      sp+=bpr;
     else {
      /* Byte Run compression */
      ULONG rem=bpr;

      /* Row not completed */
      while (rem) {
       BYTE k=*sp++; /* Read compression code */

       if (k>=0) {
        /* Literal copy */
        if ((rem-=++k)<0) goto comperr;  /* Error in de-compression? */
        sp+=k;                           /* Skip the following k+1 bytes */
       } else if (k!=-128) {             /* Code -128 == No Operation */
        /* Byte run encoded */
        k=-k;
        if ((rem-=++k)<0) goto comperr;  /* Error in de-compression? */
        sp++;                            /* Skip this byte */
       }
      }
     }
   }

   /* All OK */
   rc=TRUE;
comperr: /* Got a compression error */
  }
  FreeMem(src,size);
 }
 return(rc);
}

/* Read IFF ILBM Chunk */
static struct TMImageData *ReadILBMChunk(struct IFFHandle *iff)
{
 struct TMImageData *tmid;

 DEBUG_PRINTF("IFF: Read ILBM chunk\n");

 /* Allocate memory for main data structure */
 if (tmid=AllocMem(sizeof(struct TMImageData),MEMF_PUBLIC|MEMF_CLEAR)) {

      /* BMHD: FORM ILBM property chunk */
  if (!PropChunk(iff,ID_ILBM,ID_BMHD) &&

      /* BODY: FORM ILBM image data chunk */
      !StopChunk(iff,ID_ILBM,ID_BODY) &&

      /* FORM: begin of next context */
      !StopOnExit(iff,ID_ILBM,ID_FORM) &&

      /* Chunk types set, start parsing */
      !ParseIFF(iff,IFFPARSE_SCAN)) {

   struct StoredProperty *sp;

   /* BMHD chunk found? */
   if (sp=FindProp(iff,ID_ILBM,ID_BMHD)) {
    struct BitMapHeader *bmhd=(struct BitMapHeader *) sp->sp_Data;

    /* Check compression type */
    if ((bmhd->Compression==COMP_NO) || (bmhd->Compression==COMP_BYTERUN1)) {
     struct TMImageNode *tmin;

     /* Alloc memory for TMImageNode */
     if (tmin=AllocMem(sizeof(struct TMImageNode),MEMF_PUBLIC|MEMF_CLEAR)) {
      ULONG bpr,planeoff,size;

      /* Calculate sizes */
      bpr=BPR(bmhd->w);            /* Bytes per row */
      planeoff=bpr*bmhd->h;        /* Bytes per bitplane */
      size=planeoff*bmhd->nplanes; /* Bytes for image data */

      /* Alloc memory for image data */
      if (tmin->tmin_Data=AllocMem(size,MEMF_PUBLIC|MEMF_CHIP|MEMF_CLEAR)) {
       /* Read BODY Chunk */
       if (ReadBODYChunk(iff,bmhd,(UBYTE *) tmin->tmin_Data,bpr,planeoff)) {
        /* Retrieve BMHD chunk values */
        tmid->tmid_Normal.Width=bmhd->w;
        tmid->tmid_Normal.Height=bmhd->h;
        tmid->tmid_Normal.Depth=bmhd->nplanes;
        tmid->tmid_Normal.PlanePick=(1L<<bmhd->nplanes)-1;

        /* Copy values to second Image struct */
        tmid->tmid_Selected=tmid->tmid_Normal;

        /* Init rest of structure */
        tmid->tmid_Normal.ImageData=tmin->tmin_Data;
        tmid->tmid_Data=tmin;

        /* All OK. */
        return(tmid);
       }
       FreeMem(tmin->tmin_Data,size);
      }
      FreeMem(tmin,sizeof(struct TMImageNode));
     }
    }
   }
  }

  FreeMem(tmid,sizeof(struct TMImageData));
 }
 return(NULL);
}

/* Read one ANIM frame */
static BOOL ReadFrame(struct IFFHandle *iff, struct TMImageData *tmid,
                      struct TMImageNode **tminptr, ULONG size, BOOL *int2)
{
 struct StoredProperty *sp;

 DEBUG_PRINTF("IFF: Read ANIM Frame\n");

 /* Get ANHD chunk */
 if (sp=FindProp(iff,ID_ILBM,ID_ANHD)) {
  struct AnimHeader *ah=(struct AnimHeader *) sp->sp_Data;

  DEBUG_PRINTF("IFF: ANIM Opcode %ld\n",ah->operation);

  /* Check anim type (Only type 5 supported) and interleave */
  if ((ah->operation==5) && (ah->interleave<=2)) {
   UBYTE *chunkbuf;
   ULONG chunksize=CurrentChunk(iff)->cn_Size;

   DEBUG_PRINTF("IFF: DLTA chunk length %ld\n",chunksize);

   /* Alloc buffer for chunk data */
   if (chunkbuf=AllocMem(chunksize,MEMF_PUBLIC)) {
    /* Read chunk data */
    if (ReadChunkBytes(iff,chunkbuf,chunksize)==chunksize) {
     struct TMImageNode *tmin;

     DEBUG_PRINTF("IFF: DLTA chunk read\n");

     /* Alloc image node */
     if (tmin=AllocMem(sizeof(struct TMImageNode),MEMF_PUBLIC|MEMF_CLEAR)) {
      /* Alloc memory for image data */
      if (tmin->tmin_Data=AllocMem(size,MEMF_PUBLIC|MEMF_CHIP)) {
       ULONG bpr=BPR(tmid->tmid_Normal.Width);
       ULONG rows=tmid->tmid_Normal.Height;
       ULONG planeoff=bpr*rows;
       ULONG pl,planes=tmid->tmid_Normal.Depth;

       /* Interleave == 1?? */
       if (ah->interleave==1) {
        /* Yes. ANIM with 1 image interleave (DP ANIM brush). First image? */
        if (!(*tminptr))
         /* Yes. Set pointer. */
         *tminptr=tmid->tmid_Data;

        /* Copy old frame to new buffer */
        CopyMem((*tminptr)->tmin_Data,tmin->tmin_Data,size);

        /* Append new image node to list, move pointer */
        (*tminptr)->tmin_Next=tmin;
        *tminptr=tmin;
       }
       else {
        /* No. ANIM with 2 images interleave. First image? */

        if (!(*tminptr)) {
         /* Yes. Set pointer */
         *tminptr=tmid->tmid_Data;

         /* Copy old frame to new buffer */
         CopyMem((*tminptr)->tmin_Data,tmin->tmin_Data,size);
        } else {
         /* No. Copy old frame to new buffer */
         CopyMem((*tminptr)->tmin_Data,tmin->tmin_Data,size);

         /* Move pointer */
         *tminptr=(*tminptr)->tmin_Next;

        }

        /* Append new image node to list */
        (*tminptr)->tmin_Next=tmin;

        /* Interleave==2 */
        *int2=TRUE;
       }

       DEBUG_PRINTF("chunkbuf 0x%08lx",chunkbuf);
       DEBUG_PRINTF(" imagedata 0x%08lx\n",tmin->tmin_Data);

       /* XOR or STORE method? */
       if (ah->bits & 0x2)
        /* Apply DLTA data to frame for each plane with XOR method */
        for (pl=0; pl<planes; pl++) {
         ULONG off=*((ULONG *) chunkbuf+pl);

         /* Any data for this plane? */
         if (off) {
          ULONG col;
          register UBYTE *sp=chunkbuf+off;
          UBYTE *plane=(UBYTE *) tmin->tmin_Data+pl*planeoff;

          /* For each byte column in this plane */
          for (col=0; col<bpr; col++) {
           UBYTE *dp=plane+col;
           LONG opcount=*sp++;

           while (opcount-->0) {
            UBYTE code=*sp++; /* Get code */

            if (code==0) {
             /* Same bytes */
             UBYTE count=*sp++;
             UBYTE byte=*sp++;

             /* Copy byte count times */
             while (count--) {
              *dp^=byte;
              dp+=bpr; /* next ROW! */
             }
            } else if (code & 0x80) {
             /* Literal copy */
             UBYTE count=code&0x7f; /* Strip high bit */

             /* Copy data */
             while (count--) {
              *dp^=*sp++;
              dp+=bpr; /* next ROW! */
             }
            } else
             /* Move destination pointer code rows */
             dp+=code*bpr;
           }
          }
         }
        }
       else
        /* Apply DLTA data to frame for each plane with STORE method */
        for (pl=0; pl<planes; pl++) {
         ULONG off=*((ULONG *) chunkbuf+pl);

         /* Any data for this plane? */
         if (off) {
          ULONG col;
          register UBYTE *sp=chunkbuf+*((ULONG *) chunkbuf+pl);
          UBYTE *plane=(UBYTE *) tmin->tmin_Data+pl*planeoff;

          /* For each byte column in this plane */
          for (col=0; col<bpr; col++) {
           UBYTE *dp=plane+col;
           LONG opcount=*sp++;

           while (opcount-->0) {
            UBYTE code=*sp++; /* Get code */

            if (code==0) {
             /* Same bytes */
             UBYTE count=*sp++;
             UBYTE byte=*sp++;

             /* Copy byte count times */
             while (count--) {
              *dp=byte;
              dp+=bpr; /* next ROW! */
             }
            } else if (code & 0x80) {
             /* Literal copy */
             UBYTE count=code&0x7f; /* Strip high bit */

             /* Copy data */
             while (count--) {
              *dp=*sp++;
              dp+=bpr; /* next ROW! */
             }
            } else
             /* Move destination pointer code rows */
             dp+=code*bpr;
           }
          }
         }
        }

       /* All OK! free chunk buffer */
       FreeMem(chunkbuf,chunksize);
       return(TRUE);
      }
      FreeMem(tmin,sizeof(struct TMImageNode));
     }
    }
    FreeMem(chunkbuf,chunksize);
   }
  }
 }
 return(FALSE);
}

/* Read IFF ANIM Chunk */
static struct TMImageData *ReadANIMChunk(struct IFFHandle *iff)
{
 struct TMImageData *tmid=NULL;

 DEBUG_PRINTF("IFF: Read ANIM chunk\n");

 /* Go to first ILBM chunk */
 if (!ParseIFF(iff,IFFPARSE_STEP)) {
  struct ContextNode *cn;

  DEBUG_PRINTF("IFF: Skipped FORM ANIM chunk\n");

  /* Get current IFF chunk context, check chunk ID & type, read ILBM chunk */
  if ((cn=CurrentChunk(iff)) && (cn->cn_ID==ID_FORM) &&
      (cn->cn_Type==ID_ILBM) && (tmid=ReadILBMChunk(iff))) {

   ULONG size=BPR(tmid->tmid_Normal.Width) * tmid->tmid_Normal.Height *
              tmid->tmid_Normal.Depth;
   struct TMImageNode *tmin=NULL;
   struct TMImageNode *lasttmin=tmid->tmid_Data;
   struct TMImageNode *last2tmin=NULL;
   struct TMImageNode *last3tmin=NULL;
   BOOL int2=FALSE;

   /* Skip rest of current ILBM FORM */
   while (ParseIFF(iff,IFFPARSE_SCAN)==IFFERR_EOC)
        /* Step to next FORM chunk */
    if (!ParseIFF(iff,IFFPARSE_STEP) &&

        /* Check type of current chunk */
        (cn=CurrentChunk(iff)) && (cn->cn_ID==ID_FORM) &&
        (cn->cn_Type==ID_ILBM) &&

        /* ANHD: FORM ANIM property chunk */
        !PropChunk(iff,ID_ILBM,ID_ANHD) &&

        /* DLTA: FORM ANIM data chunk */
        !StopChunk(iff,ID_ILBM,ID_DLTA) &&

        /* FORM: begin of next frame */
        !StopOnExit(iff,ID_ILBM,ID_FORM) &&

        /* Start parsing */
        !ParseIFF(iff,IFFPARSE_SCAN) &&

        /* Read frame */
        ReadFrame(iff,tmid,&tmin,size,&int2)) {
     /* Move pointer chain */
     last3tmin=last2tmin;
     last2tmin=lasttmin;
     lasttmin=lasttmin->tmin_Next;
    }
    else break;

   /* ANIM chunk read */
   /* Delete last (int2==FALSE) or last two (int2==TRUE) frames. */
   /* These frames are unnecessary, because they are duplicates. */
   /* Got at least three nodes? */
   if (last3tmin) {
    /* Yes. Interleave==2 and at least four nodes? */
    if (int2 && (last3tmin!=tmid->tmid_Data)) {
      /* Yes. Delete second to last node */
      FreeMem(last2tmin->tmin_Data,size);
      FreeMem(last2tmin,sizeof(struct TMImageNode));

      /* Cut list off after third to last node */
      last3tmin->tmin_Next=NULL;
    } else
     /* No. Cut list off after second to last node */
     last2tmin->tmin_Next=NULL;

    /* Delete last node */
    FreeMem(lasttmin->tmin_Data,size);
    FreeMem(lasttmin,sizeof(struct TMImageNode));
   }

   /* Init rest of structure */
   if (tmin=tmid->tmid_Data->tmin_Next)
    tmid->tmid_Selected.ImageData=tmin->tmin_Data;
  }
 }
 return(tmid);
}

/* Read IFF file */
struct TMImageData *ReadIFFData(char *name)
{
 struct TMImageData *tmid=NULL;

 /* Open IFF parsing library */
 if (IFFParseBase=OpenLibrary("iffparse.library",0)) {
  struct IFFHandle *iff;

  DEBUG_PRINTF("IFF Library opened.\n");

  /* Alloc IFF handle */
  if (iff=AllocIFF()) {

   DEBUG_PRINTF("IFF Handle (0x%08lx)\n",iff);

   /* Open IFF file */
   if (iff->iff_Stream=Open(name,MODE_OLDFILE)) {
    /* Init IFF handle */
    InitIFFasDOS(iff);

    DEBUG_PRINTF("IFF Stream (0x%08lx)\n",iff->iff_Stream);

    /* Open IFF handle */
    if (!OpenIFF(iff,IFFF_READ)) {

     DEBUG_PRINTF("IFF Opened\n");

     /* Start IFF parsing */
     if (!ParseIFF(iff,IFFPARSE_STEP)) {
      struct ContextNode *cn;

      /* Get current IFF chunk context and check for FORM chunk ID */
      if ((cn=CurrentChunk(iff)) && (cn->cn_ID==ID_FORM))
       /* Yes. Check for FORM type */
       switch (cn->cn_Type) {
        case ID_ILBM:tmid=ReadILBMChunk(iff); /* FORM ILBM file */
                     break;
        case ID_ANIM:tmid=ReadANIMChunk(iff); /* FORM ANIM file */
                     break;
       }
     }
     CloseIFF(iff);
    }
    Close(iff->iff_Stream);
   }
   FreeIFF(iff);
  }
  CloseLibrary(IFFParseBase);
 }
 return(tmid);
}

/* Free IFF Data */
void FreeIFFData(struct TMImageData *tmid)
{
 struct TMImageNode *tmin1,*tmin2=tmid->tmid_Data;
 ULONG size=BPR(tmid->tmid_Normal.Width) * tmid->tmid_Normal.Height *
            tmid->tmid_Normal.Depth;

 /* Free all image datas and nodes */
 while (tmin1=tmin2) {
  /* Get pointer to next node */
  tmin2=tmin1->tmin_Next;

  /* Free Image Data */
  FreeMem(tmin1->tmin_Data,size);

  /* Free Node */
  FreeMem(tmin1,sizeof(struct TMImageNode));
 }

 /* Free main structure */
 FreeMem(tmid,sizeof(struct TMImageData));
}

