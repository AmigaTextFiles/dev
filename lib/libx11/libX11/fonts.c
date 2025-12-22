/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

/***
   NAME
     fonts
   PURPOSE
     add font handling to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 27, 1994: Created.
***/

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <graphics/text.h>
#include <devices/timer.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "libX11.h"
#include "lists.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include "amigax_proto.h"
#include "amiga_x.h"

extern GC amiga_gc;
extern struct Screen *wb;
extern struct RastPort backrp;
extern int debugxemul;

char *X11fontname[20]={"topaz"},*X11fontamiga[20]={"topaz.font"};
int X11fontmapped=1;

typedef struct {
  char zName[64];
  int vSize;
  void *pData;
} X11FontNode;

ListNode_t *X11FontList=NULL;

void X11init_fonts(void){
  FILE *fp;
  char str1[40],str2[40];
  
  fp=fopen("AmigaDefaults","r");
  if(!fp){
    fclose(fp);
    fp=fopen("libx11:AmigaDefaults","r");
  }
  if(!fp){
    fclose(fp);
    return;
  }
  while(!feof(fp)){
    char c;
    fscanf(fp,"%s %s",str1,str2);
    if(str1[0]=='!') while((c=fgetc(fp))!='\n'&&!feof(fp));
    else
    if(strstr(str1,"fontmap")!=NULL){
      char *p=str1,*q;
      while(*p!='.'&&*p!=':'&&*p!=0)p++;
      q=++p;
      while(*q!='.'&&*q!=':'&&*q!=0)q++;
      *q=0;
      X11fontname[X11fontmapped]=malloc(strlen(p)+1);
      if(!X11fontname[X11fontmapped]) X11resource_exit(FONTS3);
      strcpy(X11fontname[X11fontmapped],p);
      X11fontamiga[X11fontmapped]=malloc(strlen(str2)+1);
      if(!X11fontamiga[X11fontmapped]) X11resource_exit(FONTS4);
      strcpy(X11fontamiga[X11fontmapped++],str2);
    }
  }
  fclose(fp);
  X11FontList=List_MakeNull();
}

void X11exit_fonts(void){
  int i;
  for(i=1;i<X11fontmapped;i++){
    free(X11fontname[i]);
    free(X11fontamiga[i]);
  }
  X11fontmapped=1;
  List_FreeList(X11FontList);
}

int X11FontSize;
char X11FontName[256];
int nFontAccess=0;

Font XLoadFont(display, name)
     Display *display;
     char *name;
{
  FILE *fp;
  char str1[128],str2[128],fontname[64];
  UBYTE *fontdata;
  ULONG *fontloc;
  struct TextFont *tfont;
  struct TextAttr *tattr;
  int s1,X11FontSize,s3,s4,numchars,i,width,height,perline,k,l;
  int ascent,descent;
#ifdef DEBUGXEMUL_ENTRY
  printf("XLoadFont [%s] %d\n",name,nFontAccess);
#endif
  nFontAccess++;

  strcpy(X11FontName,"libx11:");
  strcat(X11FontName,name);
  strcat(X11FontName,".bdf");
  fp=fopen(X11FontName,"r+");
  if(!fp){
    fclose(fp);
    fp=fopen(X11FontName,"r+");
  }
  if(!fp){ /* 10x20 */
    int style=0;
    fclose(fp);
    if(strstr(name,"-i-")!=NULL) style=FSF_ITALIC;
    if(strstr(name,"-bold-")!=NULL) style|=FSF_BOLD;
    {
      char *c=name;
      X11FontSize=8;
      while(isdigit(*c)&&*c!=0) c++;
      if(*c=='x' && c!=name) sscanf(c+1,"%d",&X11FontSize);
      else{
	while(!isdigit(*c)&&*c!=0) c++;
	sscanf(c,"%d",&X11FontSize);
      }
    }
    if(wb&&wb->RastPort.Font)
      strcpy(X11FontName,wb->RastPort.Font->tf_Message.mn_Node.ln_Name);
    else strcpy(X11FontName,"topaz.font"); /* "helvetica.font" */
    for(i=0;i<X11fontmapped;i++)
      if(strstr(name,X11fontname[i])!=NULL) strcpy(X11FontName,X11fontamiga[i]);
    tattr=(struct TextAttr*)malloc(sizeof(struct TextAttr));
    if(!tattr) X11resource_exit(FONTS5);
    List_AddEntry(pMemoryList,(void*)tattr);
    tattr->ta_Name=X11FontName;
    if(debugxemul) printf("opening font %s size %d\n",X11FontName,X11FontSize);
    tattr->ta_YSize=X11FontSize;
    tattr->ta_Style=style;
    tattr->ta_Flags=FPF_DISKFONT;
    tfont=OpenDiskFont(tattr);

    if(!tfont){
      printf("font not found: %s size %d\n",X11FontName,X11FontSize);
      return NULL;
    }
    {
      sFont *sf=malloc(sizeof(sFont));
      List_AddEntry(pMemoryList,(void*)sf);
      if(!sf) X11resource_exit(FONTS6);
      sf->tfont=tfont;
      sf->tattr=tattr;
      return((Font)sf);
    }
  }
  fgets(X11FontName,256,fp);
  fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %s",str1,fontname);
  if(strcmp(str1,"FONT")!=0){
    fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %s",str1,fontname);
  }
/*  printf("font [%s]\n",fontname);*/
  
  fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d %d",str1,&s1,&X11FontSize,&s3);
  fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d %d %d",str1,&width,&height,&s3,&s4);
/*  printf("fontsize [%d %d]\n",width,height);*/
  perline=(width+7)>>3;
  fgets(X11FontName,256,fp);
  fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d",str1,&descent);
  fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d",str1,&ascent);
  fgets(X11FontName,256,fp);
  fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d",str1,&numchars);
/*  printf("number of chars %d\n",numchars);*/
  fontdata=malloc(perline*height*256);
  fontloc=malloc(256*sizeof(ULONG));
  tfont=(struct TextFont*)calloc(sizeof(struct TextFont),1);
  if(!fontdata||!fontloc||!tfont){
    fclose(fp);
    X11resource_exit(FONTS7);    
  }
  List_AddEntry(pMemoryList,(void*)tfont);
  tfont->tf_Message.mn_Node.ln_Name=fontname;
  tfont->tf_YSize=height;
  tfont->tf_XSize=width;
  tfont->tf_LoChar=0;
  tfont->tf_HiChar=255;
  tfont->tf_CharData=fontdata;
  tfont->tf_CharLoc=fontloc;
  tfont->tf_Modulo=perline*256;
  tfont->tf_Flags=42;
  tfont->tf_BoldSmear=1;
  tfont->tf_Baseline=ascent;
  for(i=0;i<numchars;i++){
    int encode;
    fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %s",str1,str2);
/*    printf("id [%s]\n",str2);*/
    fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d",str1,&encode);
    fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d",str1,&s1,&X11FontSize);
    fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d",str1,&s1,&X11FontSize);
    fgets(X11FontName,256,fp); sscanf(X11FontName,"%s %d %d %d %d",str1,&s1,&X11FontSize,&s3,&s4);
    fgets(X11FontName,256,fp);
    *(((UWORD*)fontloc)+encode*2)=(UWORD)(encode*(((width+7)>>3)<<3));
    *(((UWORD*)fontloc)+encode*2+1)=(UWORD)(width);
    
    for(l=0;l<height;l++){
      int val;
      char vstr[3];
      vstr[2]=0;
      fgets(X11FontName,256,fp);
      for(k=0;k<perline;k++){
	vstr[0]=X11FontName[k*2];
	vstr[1]=X11FontName[k*2+1];
	sscanf(vstr,"%x",&val);
	*(fontdata+l*perline*256+encode*perline+k)=(UBYTE)val;
      }
    }
    fgets(X11FontName,256,fp);
  }

  fclose(fp);
  return((Font)tfont);
}

XFontStruct *XLoadQueryFont(Display *display, char *name)
{
  XFontStruct*     xfont=calloc(sizeof(XFontStruct),1);
  struct TextFont* tf;
  boolean          bGotData=False;
  X11FontNode*     fnode;

#ifdef DEBUGXEMUL_ENTRY
  printf("XLoadQueryFont [%s]\n",name);
#endif
  List_AddEntry(pMemoryList,(void*)xfont);
  if(!name) return(NULL);
  if(!xfont) X11resource_exit(FONTS2);
  if(strcmp(name,"fixed")!=0){
    int style=0;
    xfont->fid=XLoadFont(display,name);
    if(strstr(name,"-i-")!=NULL) style=FSF_ITALIC;
    if(strstr(name,"-bold-")!=NULL) style|=FSF_BOLD;
  }
  else{
    char str[10];
    sprintf(str,"10x%d",wb->RastPort.Font->tf_YSize);
    xfont->fid=XLoadFont(display,str) /*amiga_gc->values.font*/;
  }
  {
    ListNode_t *pNode=X11FontList;
    while(pNode!=NULL && pNode->pData!=NULL){
      fnode=(X11FontNode*)pNode->pData;
      if(strcmp(fnode->zName,X11FontName)==0 && fnode->vSize==X11FontSize){
	bGotData=True;
	break;
      }
      List_GetNext(&pNode);
    }
  }
  if(xfont->fid){
    int i;
    tf=(struct TextFont *)((sFont*)xfont->fid)->tfont;
    xfont->min_char_or_byte2=tf->tf_LoChar;
    xfont->max_char_or_byte2=tf->tf_HiChar;
    xfont->max_bounds.width=tf->tf_XSize;
    xfont->max_bounds.ascent=tf->tf_Baseline;
    xfont->max_bounds.descent=tf->tf_YSize-tf->tf_Baseline;
    xfont->min_bounds.lbearing=1;
    xfont->min_bounds.rbearing=tf->tf_XSize-1;
    xfont->min_bounds.width=tf->tf_XSize;
    xfont->min_bounds.ascent=tf->tf_Baseline;
    xfont->min_bounds.descent=tf->tf_YSize-tf->tf_Baseline-1;
    xfont->ascent=xfont->max_bounds.ascent;
    if(!bGotData){
      xfont->per_char=malloc((tf->tf_HiChar-tf->tf_LoChar)*sizeof(XCharStruct));
      if(!xfont->per_char) X11resource_exit(FONTS2);
      List_AddEntry(pMemoryList,(void*)xfont->per_char);
      for(i=0;i<(tf->tf_HiChar-tf->tf_LoChar);i++){
	char c=i+tf->tf_LoChar;
	xfont->per_char[i].width=XTextWidth(xfont,&c,1);
      }

      fnode=malloc(sizeof(X11FontNode));
      if(!fnode) X11resource_exit(FONTS8);
      strcpy(fnode->zName,X11FontName);
      fnode->vSize=X11FontSize;
      fnode->pData=xfont->per_char;
      List_AddEntry(X11FontList,(void*)fnode);
    } else
      xfont->per_char=fnode->pData;
    xfont->descent=xfont->max_bounds.descent;
/*    printf(" font info width %d ascent %d descent %d\n",xfont->max_bounds.width,xfont->max_bounds.ascent,xfont->max_bounds.descent);*/
    return(xfont);
  }
  free(xfont);
  return(NULL);
}

XmFontListCreate(){/*        File 'statuswin.o'*/
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XmFontListCreate\n");
#endif
  return(0);
}

XFreeFont(display, font_struct)
     Display *display;
     XFontStruct *font_struct;
{
  struct TextFont *f=(struct TextFont*)(((sFont*)font_struct->fid)->tfont);
#ifdef DEBUGXEMUL_ENTRY
  printf("XFreeFont %d\n",nFontAccess);
  printf("XFreeFont\n");
#endif
  nFontAccess--;
  if(!f){
    printf("error freeing font!\n");
    exit(-1);
  }
  if(((struct TextFont*)((sFont*)font_struct->fid)->tfont)->tf_Flags==42){
    free(f->tf_CharData);
    free(f->tf_CharLoc);
    List_RemoveEntry(pMemoryList,(void*)f);
  }else{
    if(font_struct->fid!=amiga_gc->values.font)
      CloseFont((struct TextFont*)(((sFont*)font_struct->fid)->tfont));
    List_RemoveEntry(pMemoryList,(void*)((sFont*)font_struct->fid)->tattr);
    List_RemoveEntry(pMemoryList,(void*)font_struct->fid);
  }
  List_RemoveEntry(pMemoryList,(void*)font_struct->per_char);
  List_RemoveEntry(pMemoryList,(void*)font_struct);
  return(0);
}

XSetFont(display, gc, font)
     Display *display;
     GC gc;
     Font font;
{/*                File 'class1.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XSetFont\n");
#endif
  gc->values.font=font;
  return(0);
}

XTextExtents(font_struct, string, nchars, direction_return,
	     font_ascent_return, font_descent_return, overall)
     XFontStruct *font_struct;
     char *string;
     int nchars;
     int *direction_return;
     int *font_ascent_return, *font_descent_return;
     XCharStruct *overall;
{
/*
  struct TextFont *tf=((sFont*)font_struct->fid)->tfont;
  int len=0,i;
*/
#ifdef DEBUGXEMUL
  printf("XTextExtents\n");
#endif
/*  for(i=0;i<nchars;i++){
    char *addr=(char*)tf->tf_CharLoc+(string[i]-32)*4;
    len+=(*(unsigned long*)addr)&0xff;
  }*/
  overall->rbearing=XTextWidth(font_struct,string,nchars);
  overall->ascent=font_struct->max_bounds.ascent;
  overall->descent=font_struct->max_bounds.descent;
/*  overall->rbearing=font_struct->max_bounds.rbearing;*/
  overall->lbearing=font_struct->max_bounds.lbearing;
  overall->width=overall->rbearing;

  return(0);
}

int XTextWidth(font_struct, string, count)
     XFontStruct *font_struct;
     char *string;
     int count;
{
  struct TextFont *tf=((sFont*)font_struct->fid)->tfont;
  int len=0;
  struct RastPort *drp;
#ifdef DEBUGXEMUL_ENTRY
  printf("XTextWidth\n");
#endif
  X11testback(20,20,1);
  drp=&backrp;
/*  for(i=0;i<count;i++){
    char *addr=(char*)tf->tf_CharLoc+(string[i]-32)*4;
    len+=(*(unsigned long*)addr)&0xff;
  }*/
  SetFont(drp,tf);
  len=TextLength(drp,string,count)/*font_struct->min_bounds.rbearing*strlen(string) /*+strlen(string)*/*/;
  return(len);
}

char **XListFonts(display, pattern, maxnames, actual_count_return)
     Display *display;
     char *pattern;
     int maxnames;
     int *actual_count_return;
{/*              File 'w_drawprim.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XListFonts\n");
#endif
  *actual_count_return=X11fontmapped;
  return(X11fontname);
}

XFontStruct *XQueryFont(display, font_ID)
     Display *display;
     XID font_ID;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XQueryFont\n");
#endif
  return (XFontStruct*)NULL;
}
