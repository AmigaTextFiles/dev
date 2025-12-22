#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/dos.h>

struct FileHandle *out,*fh,*tmp;
ULONG              outputLen=0;
BOOL               HasBMHD=FALSE;
                   HasBODY=FALSE;
                   HasGRAB=FALSE;
                   HasPNTR=FALSE;
                   HasCMAP=FALSE;
ULONG              formLengthPos=0,pointerCountPos=0;
UWORD              pointerCount=0;

struct BMHD
{
 UWORD Width,Height,X,Y;
 UBYTE Depth;
 UBYTE pad01;
 UBYTE Compression;
 UBYTE pad02;
 UWORD pad03;
 UBYTE xAspect,yAspect;
 UWORD PageWidth,PageHeight;
};

struct GRAB
{
 WORD OffsetX,OffsetY;
};

struct PNTR
{
 UWORD PointerCount;
 UWORD pad01;
};

struct BMHD bmhd;
struct GRAB grab={0,0};
struct PNTR pntr={0,0};
UBYTE       cmap[20];


UBYTE tmpName[20];
struct FileHandle *OpenTmp()
{
 struct FileHandle *fh;
 int                i;

 for(i=0;i<200;i++)
  {
   sprintf(&tmpName,"RAM:temp.%d",i);
   fh=Open(&tmpName,MODE_READWRITE);
   if(fh) return(fh);
  }
 return(NULL);
}

void Out(data,len)
 UBYTE *data;
 ULONG  len;
{
 Write(out,data,len);
 outputLen+=len;
}

void main(argc,argv)
 long   argc;
 UBYTE *argv[];
{
 UBYTE id[4];
 ULONG size;
 int   count;
 long  i,j,k;

 if(argc<3) {
  printf("USAGE: %s [Target] [Source1] {Source2} {..}\n",argv[0]);
  exit(0); }

 out=Open(argv[1],MODE_NEWFILE);
 if(out==NULL) {
   puts("Unable to open output file.");
   exit(0); }

 tmp=OpenTmp();
 if(tmp==NULL) {
   puts("Unable to open temporary file RAM:temp.0.");
   exit(0); }

 /* ---- FORM ---------------------- */
 Out("FORMxxxxILBM",12);
 formLengthPos=4;

 /* ---- PNTR ---------------------- */
 Out("PNTR",4);
 j=sizeof(struct PNTR); Out(&j,4);
 pointerCountPos=outputLen;
 Out(&pntr,sizeof(struct PNTR));

 /* ---- CMAP, BODY ---------------- */
 for(k=2;k<argc;k++)
  {
   fh=Open(argv[k],MODE_OLDFILE);
   if(fh!=NULL)
    {
     printf("load: %s.\n",argv[k]);
     HasPNTR=HasBODY=FALSE;
     count=0;
     Read(fh,&id,4L);
     if(!(strncmp(&id,"FORM",4))) {
       Read(fh,&size,4);
       Read(fh,&id,4L);
       if(!(strncmp(&id,"ILBM",4))) {
         Read(fh,&id,4L);
         j=Read(fh,&size,4L);
         while((j==4)||(HasBODY==FALSE)) {

           if(!(strncmp(&id,"BMHD",4))) {
             if(HasBMHD==FALSE) {
               Read(fh,&bmhd,sizeof(struct BMHD));

               Out("BMHD",4);
               j=sizeof(struct BMHD); Out(&j,4);
               Out(&bmhd,sizeof(struct BMHD));
               Seek(fh,-sizeof(struct BMHD),OFFSET_CURRENT);

               printf("save: BMHD chunk; width=%ld, height=%ld.\n",bmhd.Width,bmhd.Height);
               HasBMHD=TRUE;
              }
            }

           else if(!(strncmp(&id,"CMAP",4))) {
             if(HasCMAP==FALSE) {
               Read(fh,&cmap,12);

               Out("CMAP",4);
               j=12; Out(&j,4);
               Out(&cmap,12);
               Seek(fh,-12,OFFSET_CURRENT);

               puts("save: CMAP chunk.");
               HasCMAP=TRUE;
              }
            }

           else if(!(strncmp(&id,"GRAB",4))) {
             if(HasGRAB==FALSE) {
               Read(fh,&grab,sizeof(struct GRAB));

               Out("GRAB",4);
               j=sizeof(struct GRAB); Out(&j,4);
               Out(&grab,sizeof(struct GRAB));
               Seek(fh,-sizeof(struct GRAB),OFFSET_CURRENT);

               printf("save: GRAB chunk; x=%ld, y=%ld.\n",grab.OffsetX,grab.OffsetY);
               HasGRAB=TRUE;
              }
            }

           else if(!(strncmp(&id,"PNTR",4))) {
             if(HasPNTR==FALSE) {
               Read(fh,&pntr,sizeof(struct PNTR));
               Seek(fh,-sizeof(struct PNTR),OFFSET_CURRENT);
               count=pntr.PointerCount;
               HasPNTR=TRUE;
              }
            }

           else if(!(strncmp(&id,"BODY",4))) {
             for(i=0;i<size;i++)
              {
               Read(fh,&id,1);
               Write(tmp,&id,1);
              }

             for(i=0;i<4;i++) id[i]=0x00;
             Write(tmp,&id,4L);
             Write(tmp,&id,4L);

             if(HasPNTR==FALSE) count=1;
             printf("save: %ld pointer images, %ld bytes.\n",count,size);
             HasBODY=TRUE;
            }

           if(size & 1) size++;
           Seek(fh,size,OFFSET_CURRENT);
           Read(fh,&id,4L);
           j=Read(fh,&size,4L);
          }
        }
      }

     Close(fh);
     pointerCount+=count;
    }
   else
     printf("Unable to open file: %s.\n",argv[k]);
  } 

 printf("save: BODY chunk; %ld pointer images total.\n",pointerCount);
 Out("BODY",4);
 j=Seek(tmp,0,OFFSET_BEGINNING);
 Out(&j,4);

 for(i=0;i<j;i++)
  {
   Read(tmp,&id,1);
   Out(&id,1);
  }

 puts("save: IFF data.");
 Seek(out,formLengthPos,OFFSET_BEGINNING);
 outputLen-=4;
 Write(out,&outputLen,4);

 Seek(out,pointerCountPos,OFFSET_BEGINNING);
 Write(out,&pointerCount,2);

 Close(tmp);
 DeleteFile(&tmpName);
 Close(out);
 puts("done.");
}

