/* Pointer-Verwaltung */
#include "multiwindows.h"
#include "iff-ilbm.h"

extern struct MultiWindowsBase *MultiWindowsBase;
extern struct ExecBase         *SysBase;
extern struct IntuitionBase    *IntuitionBase;

void ShowPointer();
void SetPointerColors();

/* ---- Pointer entfernen */
void UnLoadPointer(po)
 struct Pointer *po;
{
 int i;

 if(po)
  {
   i=0;
   Forbid();
   po->UserCount--;
   if(po->UserCount==0) {
    if(po->Node.ln_Succ!=NULL)
      { Remove(po); MultiWindowsBase->PointerCount--; i=1; }}
   Permit();

   if(i==1)
    {
     if(po->PointerImage) FreeVec(po->PointerImage);
     FreeVec(po);
    }
  }
}

/* ---- Pointer laden */
struct Pointer *LoadPointer(name)
 UBYTE *name;
{
 struct Pointer    *po;
 struct FileLock   *lock,*syslock;
 struct FileHandle *fh;
 struct BMHD        bmhd;
 struct GRAB        grab;
 struct PNTR        pntr;
 BOOL               HasBMHD,HasBODY,HasGRAB,okay;
 UBYTE              id[60];
 ULONG              size,res;
 int                i;

 for(i=0;i<strlen(name);i++)
   id[i]=tolower(name[i]);
 id[i]=0x00;
 Forbid();
 po=FindName(&MultiWindowsBase->PointerList,&id);
 if(po) po->UserCount++;
 Permit();
 if(po) return(po);

 lock=Lock(MultiWindowsBase->PointerDir,ACCESS_READ);
 if(lock) syslock=CurrentDir(lock); else syslock=NULL;
 fh=Open(name,MODE_OLDFILE);
 if(syslock) CurrentDir(syslock);
 if(lock) UnLock(lock);
 if(fh==NULL) return(NULL);

 po=AllocVec(sizeof(struct Pointer)+strlen(name)+2,MEMF_CLEAR|MEMF_PUBLIC);
 if(po!=NULL)
  {
   po->UserCount=1;
   strcpy(&po->Name,&id);
   po->Node.ln_Name=&po->Name;
   po->PointerCount=1;

   Read(fh,&id,4L);
   if(!(strncmp(&id,"FORM",4L)))
    {
     Read(fh,&size,4L);
     Read(fh,&id,4L);
     if(!(strncmp(&id,"ILBM",4L)))
      {
       HasBMHD=HasBODY=HasGRAB=po->HasColors=0;
       res=Read(fh,&id,4L);
       while((res==4)&&(HasBODY==FALSE))
        {
         Read(fh,&size,4L);
         if(!(strncmp(&id,"BMHD",4L)))
          {
           Read(fh,&bmhd,sizeof(struct BMHD));
           Seek(fh,-sizeof(struct BMHD),OFFSET_CURRENT);
           if((size % 2)==1) size++;
           Seek(fh,size,OFFSET_CURRENT);
           HasBMHD=TRUE;
          }
         else if(!(strncmp(&id,"GRAB",4L)))
          {
           Read(fh,&grab,sizeof(struct GRAB));
           Seek(fh,-sizeof(struct GRAB),OFFSET_CURRENT);
           if((size % 2)==1) size++;
           Seek(fh,size,OFFSET_CURRENT);
           HasGRAB=TRUE;
          }
         else if(!(strncmp(&id,"PNTR",4L)))
          {
           Read(fh,&pntr,sizeof(struct PNTR));
           Seek(fh,-sizeof(struct PNTR),OFFSET_CURRENT);
           po->PointerCount=pntr.PointerCount;
           if((size % 2)==1) size++;
           Seek(fh,size,OFFSET_CURRENT);
          }
         else if(!(strncmp(&id,"CMAP",4L)))
          {
           Read(fh,&po->Colors,12);
           Seek(fh,-12,OFFSET_CURRENT);
           if((size % 2)==1) size++;
           Seek(fh,size,OFFSET_CURRENT);
           for(i=0;i<12;i++)
             po->Colors[i]=po->Colors[i]/=16;
           po->HasColors=1;
          }
         else if(!(strncmp(&id,"BODY",4L)))
           HasBODY=TRUE;
         else
          {
           if((size % 2)==1) size++;
           Seek(fh,size,OFFSET_CURRENT);
          }

         res=Read(fh,&id,4L);
        }
       Seek(fh,-8,OFFSET_CURRENT);

       if((HasBODY)&&(HasBMHD))
        {
         if(bmhd.Compression==0)
          {
           if(bmhd.Width<=16)
            {
             if(bmhd.Depth>2) bmhd.Depth=2;
             if(bmhd.Height>18) bmhd.Height=18;
             po->Width=bmhd.Width;
             po->Height=bmhd.Height;
             if(HasGRAB)
              {
               po->HotSpotX=-grab.OffsetX;
               po->HotSpotY=-grab.OffsetY;
              }
             else
              {
               po->HotSpotX=-1;
               po->HotSpotY=-1;
              }

             po->PointerSize=size/po->PointerCount;
             po->PointerImage=AllocVec(size,MEMF_CHIP|MEMF_PUBLIC);
             if(po->PointerImage)
              {
               Read(fh,po->PointerImage,size);
              }
             else
              {
               ErrorL(1034,"LoadPointer():\nNot enough chip memory!");
               UnLoadPointer(po);
               po=NULL;
              }
            }
           else
            {
             ErrorL(1035,"LoadPointer():\nPointer width is greater than 16!");
             UnLoadPointer(po);
             po=NULL;
            }
          }
         else
          {
           ErrorL(1033,"LoadPointer():\nPointer files may not be compressed!");
           UnLoadPointer(po);
           po=NULL;
          }
        }
       else
        {
         ErrorL(1032,"LoadPointer():\nInvalid ILBM file!");
         UnLoadPointer(po);
         po=NULL;
        }
      }
     else
      {
       ErrorL(1031,"LoadPointer():\nNo IFF-ILBM file!");
       UnLoadPointer(po);
       po=NULL;
      }
    }
   else
    {
     ErrorL(1030,"LoadPointer():\nNo IFF file format!");
     UnLoadPointer(po);
     po=NULL;
    }
  }
 else
  {
   ErrorL(0,0);
   UnLoadPointer(po);
   po=NULL;
  }

 Close(fh);
 if(po)
  {
   Forbid();
   AddTail(&MultiWindowsBase->PointerList,po);
   MultiWindowsBase->PointerCount++;
   Permit();
  }
 return(po);
}

/* ---- Pointer benutzen */
void UsePointer(we,po)
 struct WindowEntry *we;
 struct Pointer     *po;
{

 if(we->GHWindow!=NULL)
  {
   we->Pointer=po;
   return;
  }

 we->Pointer=po;
 ShowPointer(we,po,0);
}

/* ---- Pointer laden und darstellen */
BOOL Pointer(name)
 UBYTE *name;
{
 struct WindowEntry *we;
 struct Pointer     *po;

 WE;
 if(we==NULL) return(FALSE);

 if(name==NULL)
  {
   UsePointer(we,NULL);
   if(we->SysPOAddress) UnLoadPointer(we->SysPOAddress);
   we->SysPOAddress=NULL;
   return(TRUE);
  }
 else
  {
   po=LoadPointer(name);
   if(po)
    {
     UsePointer(we,po);
     if(we->SysPOAddress) UnLoadPointer(we->SysPOAddress);
     we->SysPOAddress=po;
     return(TRUE);
    }
  }

 return(FALSE);
}

/* ---- Pointer anzeigen */
void ShowPointer(we,po,num)
 struct WindowEntry *we;
 struct Pointer     *po;
 UWORD               num;
{
 int i;

 if(!we->Iconify)
  {
   we->ActivePointer=po;
   if(po)
    {
     if(num>=po->PointerCount) num=0;
     we->ActivePointerImage=num;

     SetPointer(we->Window,
                (ULONG)po->PointerImage+(ULONG)num*(ULONG)po->PointerSize,
                po->Height,po->Width,po->HotSpotX,po->HotSpotY);
    }
   else
    {
     we->ActivePointerImage=0;
     ClearPointer(we->Window);
    }
   SetPointerColors();
  }
}

/* ---- Mauszeiger-Animation */
void NextPointer(we)
 struct WindowEntry *we;
{

 if(we->ActivePointer)
  {
   if(we->ActivePointer->PointerCount>1)
    {
     we->ActivePointerImage++;
     ShowPointer(we,we->ActivePointer,we->ActivePointerImage);
    }
  }
}

/* ---- Nächstes Pointer-Bild darstellen */
void AnimPointer()
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 NextPointer(we);
}

/* ---- Standard-Pointer anzeigen */
void StdPointer(num)
 UBYTE num;
{
 UBYTE *name;

 name=NULL;
 switch(num)
  {
   case STDP_SLEEP:
     name=MultiWindowsBase->SleepPointerName;
    break;
   case STDP_WORK:
     name=MultiWindowsBase->WorkPointerName;
    break;
   case STDP_HELP:
     name=MultiWindowsBase->HelpPointerName;
    break;
  }
 Pointer(name);
}

/* ---- Pointer-Farben setzen */
void SetPointerColors()
{
 UBYTE               array[12];
 APTR                lock;
 int                 i;
 struct Window      *win;
 struct WindowEntry *we;
 struct Pointer     *po;

 lock=LockIBase(NULL);
 po=NULL;
 win=IntuitionBase->ActiveWindow;
 if(win!=NULL)
  {
   we=win->UserData;
   if(we!=NULL)
    {
     if(!we->Iconify)
      {
       if(we->ActivePointer!=NULL)
        {
         if(we->ActivePointer->HasColors!=0)
          {
           po=we->ActivePointer;
          }
        }
      }
    }
  }
 else
  {
   UnlockIBase(lock);
   return;
  }

 if(po)
   CopyMem(&po->Colors,&array,12);
 else
  {
   /* Farbe 16 */
   array[0]=0;
   array[1]=0;
   array[2]=0;
   /* Farbe 17 */
   array[3]=(MultiWindowsBase->Preferences->color17>>8) & 0xf;
   array[4]=(MultiWindowsBase->Preferences->color17>>4) & 0xf;
   array[5]=(MultiWindowsBase->Preferences->color17>>0) & 0xf;
   /* Farbe 18 */
   array[6]=(MultiWindowsBase->Preferences->color18>>8) & 0xf;
   array[7]=(MultiWindowsBase->Preferences->color18>>4) & 0xf;
   array[8]=(MultiWindowsBase->Preferences->color18>>0) & 0xf;
   /* Farbe 19 */
   array[9]=(MultiWindowsBase->Preferences->color19>>8) & 0xf;
   array[10]=(MultiWindowsBase->Preferences->color19>>4) & 0xf;
   array[11]=(MultiWindowsBase->Preferences->color19>>0) & 0xf;
  }

 for(i=0;i<4;i++)
   SetRGB4(ViewPortAddress(win),16+i,array[3*i],array[3*i+1],array[3*i+2]);
 UnlockIBase(lock);
}

