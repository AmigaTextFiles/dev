/*
// ##########################################################################
// ####                                                                  ####
// ####             ConvertFDPlus - An Amiga FD file converter           ####
// ####          ===============================================         ####
// ####                                                                  ####
// #### ConvertFDPlus.c                                                  ####
// ####                                                                  ####
// #### Version 3.00  --  October 06, 2000                               ####
// ####                                                                  ####
// #### Copyright (C) 1992  Thomas Dreibholz                             ####
// ####                     Molbachweg 7                                 ####
// ####                     51674 Wiehl/Germany                          ####
// ####                     EMail: Dreibholz@bigfoot.com                 ####
// ####                     WWW:   http://www.bigfoot.com/~dreibholz     ####
// ####                                                                  ####
// ##########################################################################
*/

#include <exec/devices.h>
#include <exec/io.h>
#include <libraries/dos.h>
#include <intuition/intuition.h>
#include <graphics/rastport.h>

UBYTE *KNamen[]={"Close","Exit","Input","Open","Output","Read",
                 "Write","Translate","Wait","-","-"};
#define KNAMEN 9
#define VERSION "3.0"
#define HELP(t) if(GList[10]->Flags & SELECTED) Ausgabe(t);

struct IntuitionBase *IntuitionBase=NULL;
struct GfxBase *GfxBase=NULL;
struct Library *DigitalBase=NULL;
struct RastPort *rp=NULL;
struct ViewPort *vp=NULL;
struct Window *con=NULL;
struct Window *win=NULL;
struct Screen *scr=NULL;
struct Gadget *GList[50];
struct MsgPort *Port=NULL;
struct IOStdReq *io=NULL;
struct DateStamp *uhr=NULL;
LONG ConDev=-1L;
UBYTE FileName[200],Undo1[200],NeuerName[200],Undo2[200];
UWORD Array[]={0,0,595,0,595,12,0,12,0,0};
struct Border bor={-2,-2,2,0,JAM1,5,&Array,NULL};
struct StringInfo sp1={&FileName,&Undo1,0,200,0,0,0,0,0,0,0L,0L,0L};
struct StringInfo sp2={&NeuerName,&Undo2,0,200,0,0,0,0,0,0,0L,0L,0L};
struct Gadget str2={NULL,22,76,596,10,0L,RELVERIFY,STRGADGET,&bor,0L,0L,0L,&sp2,21,0L};
struct Gadget str1={&str2,22,46,596,10,0L,RELVERIFY,STRGADGET,&bor,0L,0L,0L,&sp1,20,0L};
struct TextAttr tx={"topaz.font",8,FS_NORMAL,FPF_ROMFONT};
struct NewScreen ns={0,0,640,256,4,0,1,HIRES,CUSTOMSCREEN,&tx,0L,0L,0L};
struct NewWindow nw={0,0,640,256,0,1,VANILLAKEY|GADGETDOWN|GADGETUP,RMBTRAP|ACTIVATE|BORDERLESS,
                     &str1,0L,0L,0L,0L,640,256,640,256,CUSTOMSCREEN};
struct NewWindow rd={95,75,450,75,0,1,GADGETUP,RMBTRAP|ACTIVATE,
                     0L,0L,0L,0L,0L,640,256,640,256,CUSTOMSCREEN};
struct NewWindow cw={320,180,296,57,0,2,0L,RMBTRAP|BORDERLESS,0L,0L,0L,0L,0L,640,256,640,256,CUSTOMSCREEN};
BOOL Arg1=FALSE,Arg2=FALSE,Auto=FALSE;

ULONG id=0L;
UBYTE *mem,*backup;
UBYTE *out;
UBYTE *cstr,*fstr,*tstr;

VOID OpenAll();
VOID CloseAll();
VOID GadgetPlus();
VOID Prt();
VOID Ausgabe();
BOOL BMAP=FALSE;
BOOL LLQ=TRUE;
BOOL OFFSET=FALSE;
BOOL BASIS=FALSE;
BOOL UMKEHRUNG=FALSE;
BOOL KO=FALSE;
BOOL BCPL=FALSE;
BOOL DOK=FALSE;
BOOL VOR=FALSE;
BOOL SREG=FALSE;

BOOL Req(tex1,tex2,tex3,a,b)
 UBYTE *tex1,*tex2,*tex3,*a,*b;
{
 REGISTER BOOL res;
 register struct Gadget *g;
 register struct IntuiMessage *msg;
 register struct Window *w;
 register struct RastPort *r;
 w=OpenWindow(&rd);
 if(w!=NULL)
  {
   r=w->RPort;
   id=15;
   GadgetPlus(w,10,55,75,12,a,0,RELVERIFY);
   if(b) GadgetPlus(w,365,55,75,12,b,0,RELVERIFY);
   SetAPen(r,2);
   if(tex1) { Move(r,10,15); Text(r,tex1,strlen(tex1)); }
   if(tex2) { Move(r,10,25); Text(r,tex2,strlen(tex2)); }
   if(tex2) { Move(r,10,35); Text(r,tex3,strlen(tex3)); }
   msg=WaitPort(w->UserPort);
   msg=GetMsg(w->UserPort);
   g=msg->IAddress;
   if(g->GadgetID==15) res=FALSE; else res=TRUE;
   ReplyMsg(msg);
   CloseWindow(w);
  }
 else
  {
   res=FALSE;
   DisplayBeep(scr);
  }
 return(res);
}

VOID Convert()
{
 REGISTER LONG i,j,k,l,regs,offset;
 UBYTE token[200];
 UBYTE BaseName[100];
 UBYTE RegTab[20];
 UBYTE RegNamTab[20][4];
 WORD w;
 REGISTER BOOL okay=TRUE,BaseOkay=FALSE;
 REGISTER UBYTE chr;
 register struct FileHandle *in,*o1,*o2,*o3,*o4,*o5;
 offset=-30;
 mem=backup;
 if((!BMAP)&&(!OFFSET)&&(!LLQ)&&(!DOK)&&(!VOR))
  {
   Req("Sie haben keine Konvertierungsart gewählt!","Bitte wählen Sie vorher eine Funktion.",0L,"Abbruch",NULL);
  }
 else
  {
   o1=o2=o3=o4=o5=in=NULL;
   in=Open(&FileName,MODE_OLDFILE);
   if(in==NULL)
    {
     Req("Die angegebene Datei",&FileName,"konnte nicht geöffnet werden.","Abbruch",NULL);
    }
   else
    {
     HELP("Konvertierung in\n");
     if(BMAP)
      {
       HELP(" - BMAP-Datei für AmigaBASIC\n");
       sprintf(mem,"%s.bmap",&NeuerName);
       o1=Open(mem,MODE_NEWFILE);
       if(o1==NULL)
        {
         Req("Die BMAP-Datei",mem,"konnte nicht eröffnet werden.","Abbruch",NULL);
         okay=FALSE;
        }
      }
     if(LLQ)
      {
       HELP(" - Linker-Library für C-Compiler\n");
       sprintf(mem,"%s.asm",&NeuerName);
       o2=Open(mem,MODE_NEWFILE);
       if(o2==NULL)
        {
         Req("Die LLQ-Datei",mem,"konnte nicht eröffnet werden.","Abbruch",NULL);
         okay=FALSE;
        }
      }
     if(OFFSET)
      {
       HELP(" - Offset-Datei für Assembler\n");
       sprintf(mem,"%s.i",&NeuerName);
       o3=Open(mem,MODE_NEWFILE);
       if(o3==NULL)
        {
         Req("Die Offset-Datei",mem,"konnte nicht eröffnet werden.","Abbruch",NULL);
         okay=FALSE;
        }
      }
     if(DOK)
      {
       HELP(" - Dokumentations-Grunddatei\n");
       HELP("   für spätere Dokumentation\n");
       sprintf(mem,"%s.doc",&NeuerName);
       o4=Open(mem,MODE_NEWFILE);
       if(o4==NULL)
        {
         Req("Die Dokumentations-Grunddatei",mem,"konnte nicht eröffnet werden.","Abbruch",NULL);
         okay=FALSE;
        }
      }
     if(VOR)
      {
       HELP(" - Vordefinitions-Datei\n");
       sprintf(mem,"%s.h",&NeuerName);
       o5=Open(mem,MODE_NEWFILE);
       if(o5==NULL)
        {
         Req("Die Include-Datei",mem,"konnte nicht eröffnet werden.","Abbruch",NULL);
         okay=FALSE;
        }
       else
        {
         strcpy(out,"#include <exec/types.h>\n");
         Write(o5,out,strlen(out));
        }
      }
     if(GList[31]->Flags & SELECTED) HELP("\nOfs.  Funktionsname\n");
     if(okay==TRUE)
      {
       k=Read(in,mem,249998);
       if(k<=249999)
        {
         if(k!=0)
          {
           for(i=0;i<k;i++)
            {
             if(mem[i]==0x0A) mem[i]=0;
            }
           j=0;
           while(j<k)
            {
             if((mem[0]!='#')&&(mem[0]!='*'))
              {
               l=0;
               if(!BASIS)
                {
                 regs=0;
                }
               else
                {
                 RegTab[0]=16;
                 strcpy(&RegNamTab[0],"A6");
                 regs=1;
                }
               while((mem[l]==' ')||(mem[l]==0x09)) l++;
               strcpy(&token,""); i=0;
               chr=toupper(mem[l]);
               while(( ((chr>='A')&&(chr<='Z')) || ((chr>='0')&&(chr<='9')) || (chr=='-') ))
                {
                 token[i]=mem[l]; i++; l++;
                 chr=toupper(mem[l]);
                }
               token[i]=0x00;
               while( (mem[l]!='(') && (mem[l]!=0x00) ) l++;
               if(mem[l]==0x00)
                {
                 if(o1) Close(o1);
                 if(o2) Close(o2);
                 if(o3) Close(o3);
                 if(o4) Close(o4);
                 if(o5) Close(o5);
                 Close(in);
                 o1=o2=o3=o4=o5=in=NULL;
                 Req("Die FD-Datei hat bei",&token,"einen Formatfehler!","Abbruch",0L);
                 return;
                }
               while( (mem[l]!=')') && (mem[l]!=0x00) ) l++;
               if(mem[l]==0x00)
                {
                 if(o1) Close(o1);
                 if(o2) Close(o2);
                 if(o3) Close(o3);
                 if(o4) Close(o4);
                 if(o5) Close(o5);
                 Close(in);
                 o1=o2=o3=o4=o5=in=NULL;
                 Req("Die FD-Datei hat bei",&token,"einen Formatfehler!","Abbruch",0L);
                 return;
                }
               l++;
               if(mem[l]!=0x00)
                {
                 while( (mem[l]!='(') && (mem[l]!=0x00) ) l++;
                 if(mem[l]==0x00)
                  {
                   if(o1) Close(o1);
                   if(o2) Close(o2);
                   if(o3) Close(o3);
                   if(o4) Close(o4);
                   if(o5) Close(o5);
                   Close(in);
                   o1=o2=o3=o4=o5=in=NULL;
                   Req("Die FD-Datei hat bei",&token,"einen Formatfehler!","Abbruch",0L);
                   return;
                  }
                 l++;
                 while((mem[l]!=')')&&(mem[l]!=0x00))
                  {
                   if(mem[l]!=')')
                    {
                     chr=toupper(mem[l]);
                     switch(chr)
                      {
                       case 'D':
                         RegTab[regs]=1;
                         RegNamTab[regs][0]='D';
                        break;
                       case 'A':
                         RegTab[regs]=9;
                         RegNamTab[regs][0]='A';
                        break;
                       default:
                         if(o1) Close(o1);
                         if(o2) Close(o2);
                         if(o3) Close(o3);
                         if(o4) Close(o4);
                         if(o5) Close(05);
                         Close(in);
                         o1=o2=o3=o4=o5=in=NULL;
                         Req("Falscher Registerbuchstabe bei",&token,0L,"Abbruch",0L);
                         return;
                        break;
                       }
                     RegTab[regs]+=mem[l+1]-48;
                     RegNamTab[regs][1]=mem[l+1];
                     RegNamTab[regs][2]=0x00;
                     if(RegTab[regs]>16)
                      {
                       if(o1) Close(o1);
                       if(o2) Close(o2);
                       if(o3) Close(o3);
                       if(o4) Close(o4);
                       if(o5) Close(o5);
                       Close(in);
                       o1=o2=o3=o4=o5=in=NULL;
                       Req("Falsche Registernummer bei",&token,0L,"Abbruch",0L);
                       return;
                      }
                     regs++;
                     l+=2;
                    }
                   l++;
                  }
                }
               if(BaseOkay==FALSE)
                {
                 if(o1) Close(o1);
                 if(o2) Close(o2);
                 if(o3) Close(o3);
                 if(o4) Close(o4);
                 if(o5) Close(o5);
                 Close(in);
                 o1=o2=o3=o4=o5=in=NULL;
                 Req("Das Befehlswort ##base muß vor dem ersten Befehl stehen.",0L,0L,"Abbruch",0L);
                 return;
                }
               if(o1)
                {
                 strcpy(out,"");
                 for(i=0;i<KNAMEN;i++)
                  {
                   if(!(strcmp(KNamen[i],&token))) { strcpy(out,"x"); i=KNAMEN; }
                  }
                 strcat(out,&token);
                 Write(o1,out,strlen(out));
                 w=0;
                 Write(o1,&w,1L);
                 w=offset;
                 Write(o1,&w,2L);
                 l=0; if(BASIS) l=1;
                 if(regs>l)
                  {
                   if(regs!=NULL)
                    {
                     for(i=l;i<regs;i++)
                      {
                       Write(o1,&RegTab[i],1L);
                      }
                    }
                  }
                 w=0;
                 Write(o1,&w,1L);
                }
               if(o3)
                {
                 sprintf(out,"_LVO%s:   EQU %ld\n",&token,offset);
                 Write(o3,out,strlen(out));
                }
               if(o4)
                {
                 sprintf(out,"%s()\n",&token);
                 Write(o4,out,strlen(out));
                 for(i=0;i<regs;i++)
                  {
                   sprintf(out,"   -> %s : \n",RegNamTab[i]);
                   Write(o4,out,strlen(out));
                  }
                 Write(o4,"\n\n",2);
                }
               if(o5)
                {
                 sprintf(out,"VOID %s();\n",&token);
                 Write(o5,out,strlen(out));
                }
               if(o2)
                {
                 if(!KO)
                  {
                   sprintf(out,"   XDEF _LVO%s\n_LVO%s: EQU %ld\n",&token,&token,offset);
                   Write(o2,out,strlen(out));
                  }
                 sprintf(out,"   XDEF _%s\n_%s:\n",&token,&token);
                 Write(o2,out,strlen(out));
                 if(SREG)
                  {
                   strcpy(out,"   MOVEM.L D2-D7/A0-A6,-(SP)\n");
                   Write(o2,out,strlen(out));
                   l=8+(12*4);
                  }
                 else
                   l=4;

                 if(!UMKEHRUNG)
                  {
                   for(i=0;i<regs;i++)
                    {
                     sprintf(out,"   MOVE.L %ld(SP),%s\n",l,RegNamTab[i]);
                     Write(o2,out,strlen(out)); l+=4;
                    }
                  }
                 else
                  {
                   for(i=regs-1;i>=0;i--)
                    {
                     sprintf(out,"   MOVE.L %ld(SP),%s\n",l,RegNamTab[i]);
                     Write(o2,out,strlen(out)); l+=4;
                    }
                  }

                 if(!BASIS)
                  {
                   sprintf(out,"   MOVE.L %s,A6\n",&BaseName);
                   Write(o2,out,strlen(out));
                  }

                 if((BCPL)||(SREG))
                  {
                   sprintf(out,"   JSR %ld(A6)\n",offset);
                   Write(o2,out,strlen(out));
                   if(BCPL) Write(o2,"   MOVE.L D0,D1\n",16);
                   if(SREG)
                     strcpy(out,"   MOVEM.L (SP)+,D2-D7/A0-A6\n   RTS\n");
                   else
                     strcpy(out,"   MOVE.L (SP)+,A6\n   RTS\n");
                   Write(o2,out,strlen(out));
                  }
                 else
                  {
                   sprintf(out,"   JMP %ld(A6)\n",offset);
                   Write(o2,out,strlen(out));
                  }
                }
               if(GList[31]->Flags & SELECTED)
                {
                 sprintf(tstr,"%5ld %s\n",offset,&token);
                 Ausgabe(tstr);
                }
               offset-=6;
              }
             else
              {
               if(!(strncmp(mem,"##base ",7)))
                {
                 strcpy(&BaseName,mem+7);
                 BaseOkay=TRUE;
                 if(o2)
                  {
                   sprintf(out,"   XREF %s\n",&BaseName);
                   Write(o2,out,strlen(out));
                  }
                }
               if(!(strncmp(mem,"##bias ",7)))
                {
                 offset=atol(mem+7);
                 offset=-offset;
                }
              }
             l=strlen(mem)+1;
             mem+=l; j+=l;
            }
          }
         else
          {
           Req("Die angegebene FD-Datei",&FileName,"ist leer.","Abbruch",NULL);
          }
         if(!Auto) Req("Die Konvertierung wurde erfolgreich beendet.",0L,0L,"Okay",0L);
        }
       else
        {
         Req("Die angegebene FD-Datei",&FileName,"ist über 200 KB lang.","Abbruch",NULL);
        }
      }
     if(o1) Close(o1);
     if(o2)
      {
       Write(o2," END\n\n",6);
       Close(o2);
      }
     if(o3)
      {
       Write(o3," END\n\n",6);
       Close(o3);
      }
     if(o5)
      {
       Write(o5,"\n\n",2);
       Close(o5);
      }
     if(o4) Close(o4);
     Close(in);
    }
  }
 if(GList[31]->Flags & SELECTED) Ausgabe("\n");
 o1=o2=o3=o4=o5=in=NULL;
}

VOID main(argc,argv)
 long   argc;
 UBYTE *argv[];
{
 register struct IntuiMessage *msg;
 register struct Gadget *gad;
 REGISTER ULONG class,chip,fast,total;
 REGISTER BOOL ende=FALSE;

 if((argc==1)&&(!(strcmp(argv[1],"?"))))
  {
   printf("Aufruf: %s [FD-Datei] [Ausgabe-Datei] [AUTO]\n",argv[0]);
   exit(0);
  }

 if(argc>1)
  { strcpy(&FileName,argv[1]); Arg1=TRUE; }
 if(argc>2)
  { strcpy(&NeuerName,argv[2]); Arg2=TRUE; }

 if(argc>3)
  {
   if(!(strcmp(argv[3],"AUTO")))
    {
     Auto=TRUE;
     OpenAll();
     Convert();
     CloseAll();
     exit(0);
    }
  }

 OpenAll();

 while(ende==FALSE)
  {
   msg=WaitPort(win->UserPort);
   msg=GetMsg(win->UserPort);
   class=msg->Class;
   gad=msg->IAddress;
   ReplyMsg(msg);
   switch(class)
    {
     case GADGETDOWN:
       id=gad->GadgetID;
      break;
     case GADGETUP:
       id=gad->GadgetID;
       switch(id)
        {
         case 20:
           ActivateGadget(&str2,win,NULL);
          break;
         case 21:
           ActivateGadget(&str1,win,NULL);
          break;
         case 7:
           HELP("Konvertierung starten\n");
           if(GList[0]->Flags & SELECTED) BMAP=TRUE; else BMAP=FALSE;
           if(GList[1]->Flags & SELECTED) LLQ=TRUE; else LLQ=FALSE;
           if(GList[2]->Flags & SELECTED) OFFSET=TRUE; else OFFSET=FALSE;
           if(GList[3]->Flags & SELECTED) BASIS=TRUE; else BASIS=FALSE;
           if(GList[4]->Flags & SELECTED) UMKEHRUNG=TRUE; else UMKEHRUNG=FALSE;
           if(GList[5]->Flags & SELECTED) KO=TRUE; else KO=FALSE;
           if(GList[6]->Flags & SELECTED) BCPL=TRUE; else BCPL=FALSE;
           if(GList[11]->Flags & SELECTED) DOK=TRUE; else DOK=FALSE;
           if(GList[12]->Flags & SELECTED) VOR=TRUE; else VOR=FALSE;
           if(GList[13]->Flags & SELECTED) SREG=TRUE; else SREG=FALSE;
           Convert();
           HELP("Konvertierung beendet\n");
          break;
         case 8:
           HELP("Programm beenden\n");
           ende=Req("Wollen Sie ConvertFD Plus wirklich beenden ?",0L,0L,"Zurück","Ende");
          break;
         case 9:
           HELP("Informationen über ConvertFD Plus\n");
           fast=AvailFastMem();
           chip=AvailChipMem();
           total=AvailMemory();
           sprintf(cstr,"Chip:    %4ld KB  =  %8ld Bytes",chip/1024,chip);
           sprintf(fstr,"Fast:    %4ld KB  =  %8ld Bytes",fast/1024,fast);
           sprintf(tstr,"Gesamt:  %4ld KB  =  %8ld Bytes",total/1024,total);
           Req(cstr,fstr,tstr,"Weiter",0L);
           sprintf(tstr,"ConvertFD Plus Version %s",VERSION);
           Req(tstr,"Copyright (C) 1992 by Thomas Dreibholz.","All rights reserved.","Okay",0L);
          break;
         case 10:
           if(GList[10]->Flags & SELECTED)
            {
             Ausgabe("Hilfsfunktion eingeschaltet\n");
            }
           else
            {
             Ausgabe("Hilfsfunktion ausgeschaltet\n");
            }
          break;
         case 30:
           Ausgabe("\f");
           HELP("Ausgabebereich löschen\n");
          break;
         case 31:
           HELP("Ausgabe von Offset und Name ein/aus\n");
          break;
         case 32:
           DateStamp(uhr);
           sprintf(tstr,"Es ist %ld:%02ld:%02ld Uhr.\n",uhr->ds_Minute/60,
                                                    uhr->ds_Minute%60,
                                                    uhr->ds_Tick/50);
           Ausgabe(tstr);
          break;
         default:
          if( ((id>=0)&&(id<=2)) || (id==11) || (id==12) )
           {
            HELP("Funktion aktiviert/deaktiviert\n");
           }
          else
           {
            switch(id)
             {
              case 3:
                HELP("LLQ ist Basisorientiert (ein/aus)\n");
               break;
              case 4:
                HELP("Registerumkehrung (ein/aus)\n");
               break;
              case 5:
                HELP("Keine Offsets (ein/aus)\n");
               break;
              case 6:
                HELP("LLQ ist BCPL-Kompatibel (ein/aus)\n");
               break;
             }
           }
          break;
        }
      break;
     case VANILLAKEY:
       ende=TRUE;
      break;
    }
  }
 CloseAll();
}

VOID GadgetPlus(w,ax,ay,aw,ah,tex,flgs,act)
 struct Window *w;
 LONG ax,ay,aw,ah;
 UBYTE *tex;
 ULONG flgs,act;
{
 register struct RastPort *r;
 register struct Gadget *gad;
 REGISTER LONG x1,y1,x2,y2,x,y,pl;
 gad=AllocRMemory(sizeof(struct Gadget));
 if(gad==NULL)
  {
   printf("Es steht nicht genug Speicher für Schalter zur Verfügung.\n");
   CloseAll();
  }
 gad->LeftEdge=ax;
 gad->TopEdge=ay;
 gad->Width=aw;
 gad->Height=ah;
 gad->Flags=flgs;
 gad->Activation=act;
 gad->GadgetType=BOOLGADGET;
 gad->GadgetID=id;
 GList[id]=gad;
 id++;
 r=w->RPort;

 x1=ax+1;
 y1=ay+1;
 x2=x1+aw-3;
 y2=y1+ah-3;
 SetAPen(r,1);
 Move(r,x1-1,y2);
 Draw(r,x1-1,y1-1);
 Draw(r,x2,y1-1);
 SetAPen(r,2);
 Move(r,x2+1,y1-1);
 Draw(r,x2+1,y2);
 Move(r,x2+1,y2+1);
 Draw(r,x1-1,y2+1);
 pl=TextLength(r,tex,strlen(tex));
 x=ax+((aw-pl)/2);
 y=ay+3+(ah/2);
 Move(r,x,y);
 Text(r,tex,strlen(tex));

 AddGadget(w,gad,-1L);
 OnGadget(gad,w,0L);
}

VOID CloseAll()
{
 if(con) CloseWindow(con);
 if(ConDev==NULL) CloseDevice(io);
 if(io) DeleteExtIO(io);
 if(Port) DeletePort(Port);
 if(win) CloseWindow(win);
 if(scr) CloseScreen(scr);
 if(DigitalBase)
  {
   FreeRMemory();
   CloseLibrary(DigitalBase);
  }
 if(GfxBase) CloseLibrary(GfxBase);
 if(IntuitionBase) CloseLibrary(IntuitionBase);
 exit(0);
}

VOID Ausgabe(tex)
 UBYTE *tex;
{
 io->io_Command=CMD_WRITE;
 io->io_Data=tex;
 io->io_Length=strlen(tex);
 DoIO(io);
}

VOID Prt(x,y,t)
 LONG x,y;
 UBYTE *t;
{
 SetAPen(rp,3);
 Move(rp,x,y);
 Text(rp,t,strlen(t));
}

VOID OpenAll()
{
 IntuitionBase=OpenLibrary("intuition.library",0L);
 GfxBase=OpenLibrary("graphics.library",0L);
 DigitalBase=OpenLibrary("digital.library",0L);
 if(DigitalBase==NULL)
  {
   printf("Die Digital-Library ist nicht verfügbar.\n");
   CloseAll();
  }
 mem=AllocRMemory(250000);
 out=AllocRMemory(1000);
 if((mem==NULL)||(out==NULL))
  {
   printf("Es steht nicht genug Speicher für DOS-Operationen zur Verfügung.\n");
   printf("ConvertFD Plus benötigt 250 KB für die Dateisicherung\n");
   CloseAll();
  }
 backup=mem;
 cstr=AllocRMemory(60);
 fstr=AllocRMemory(60);
 tstr=AllocRMemory(120);
 uhr=AllocRMemory(sizeof(struct DateStamp));
 if((cstr==NULL)||(fstr==NULL)||(tstr==NULL)||(uhr==NULL))
  {
   printf("Es steht nicht genug Speicher für das Info-Fenster zur Verfügung.\n");
   CloseAll();
  }
 Port=CreatePort("output.port");
 if(Port==NULL)
  {
   printf("Es steht nicht genug Speicher für die Task-Kommunikation\n");
   printf("zur Verfügung.\n");
   CloseAll();
  }
 io=CreateExtIO(Port,250);
 if(io==NULL)
  {
   printf("Es steht nicht genug Speicher für die Device-Kommunikation\n");
   printf("zur Verfügung.\n");
   CloseAll();
  }
 if(Auto) ns.Type |= SCREENBEHIND;
 scr=OpenScreen(&ns);
 if(scr==NULL)
  {
   printf("Es steht nicht genug Speicher für die Oberfläche zur Verfügung.\n");
   CloseAll();
  }
 nw.Screen=scr;
 rd.Screen=scr;
 cw.Screen=scr;
 if(!Arg1) strcpy(&FileName,"FD:dos_lib.fd");
 if(!Arg2) strcpy(&NeuerName,"RAM:dos");
 win=OpenWindow(&nw);
 if(win==NULL)
  {
   printf("Es steht nicht genug Speicher für die Windows zur Verfügung.\n");
   CloseAll();
  }
 con=OpenWindow(&cw);
 if(con==NULL)
  {
   printf("Es steht nicht genug Speicher für das Ausgabefenster\n");
   printf("zur Verfügung.\n");
   CloseAll();
  }
 io->io_Data=con;
 io->io_Length=sizeof(struct Window);
 ConDev=OpenDevice("console.device",0L,io,0L);
 if(ConDev!=NULL)
  {
   printf("Es steht nicht genug Speicher für das \"console.device\"\n");
   printf("zur Verfügung.\n");
   CloseAll();
  }
 rp=win->RPort;
 vp=ViewPortAddress(win);
 SetRGB4(vp,0,7,7,7);
 SetRGB4(vp,1,15,15,15);
 SetRGB4(vp,2,0,0,0);
 SetRGB4(vp,3,15,15,5);
 SetRGB4(vp,13,15,15,15);
 SetRGB4(vp,14,0,0,0);
 SetRGB4(vp,15,3,7,15);
 GadgetPlus(win,20,110,296,12,"AmigaBASIC BMAP-Datei",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,20,125,296,12,"Linker-Library-Quellcode",SELECTED,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,20,140,296,12,"Offset-Tabelle",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,20,180,296,12,"Basis als erster Parameter",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,20,195,296,12,"Umkehrung der Registerablage",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,20,210,296,12,"Keine Assembler-Offsets",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,20,225,296,12,"Rückgabe in D0 und D1",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,20,10,68,12,"Start",0,RELVERIFY);
 GadgetPlus(win,89,10,68,12,"Ende",0,RELVERIFY);
 GadgetPlus(win,163,10,68,12,"Info",0,RELVERIFY);
 GadgetPlus(win,232,10,68,12,"Hilfe",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,320,110,296,12,"Dokumentations-Grunddatei",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,320,125,296,12,"Aztec-C VOID-Vordefinition",0,RELVERIFY|TOGGLESELECT);
 GadgetPlus(win,320,140,296,12,"Register sichern",0,RELVERIFY|TOGGLESELECT);
 id=30; GadgetPlus(win,568,166,48,12,"CLS",0,RELVERIFY);
        GadgetPlus(win,518,166,48,12,"Ein",0,RELVERIFY|TOGGLESELECT);
        GadgetPlus(win,468,166,48,12,"Uhr",0,RELVERIFY);
 GadgetPlus(win,320,140,296,12,"Register sichern",0,RELVERIFY|TOGGLESELECT);
 Prt(30,40,"Name der FD-Datei:");
 Prt(30,70,"Neuer Dateiname ohne Endung:");
 Prt(30,105,"Umwandlung in");
 Prt(30,175,"LLQ-Optionen");
 Prt(330,175,"Ausgabe");
 sprintf(tstr," Willkommen zu ConvertFD Plus V%s\n",VERSION);
 Ausgabe(tstr);
 Ausgabe("       Copyright (C) 1992 by\n");
 Ausgabe("          Thomas Dreibholz   \n");
 Ausgabe("        All rights reserved.\n\n");
}

