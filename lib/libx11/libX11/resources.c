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
     resources
   PURPOSE
     resource handling.
   NOTES
     
   HISTORY
     Terje Pedersen - Mar 12, 1995: Created.
***/

#include <intuition/intuition.h>
/*#include <intuition/intuitionbase.h>*/
#include <clib/intuition_protos.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/displayinfo.h>
#include <devices/timer.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>
#include <proto/layers.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include "libX11.h"

#define XLIB_ILLEGAL_ACCESS 1

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

#include "amigax_proto.h"
#include "amiga_x.h"

#include "resource_list.h"

listnode *_Xresources=NULL;

String *_XtFallbackResource=NULL;

char *X11ResourceManagerString="AmigaResources";
XrmDatabase X11DefaultResources=NULL;

extern listnode *makenode(char *,char *);
extern int debugxemul;

char *XResourceManagerString(display)
     Display *display;
{/*  File 'xv.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XResourceManagerString\n");
#endif
  return(X11ResourceManagerString);
}

void XrmSetDatabase(display, database)
     Display *display;
     XrmDatabase database;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XrmSetDatabase\n");
#endif
}

Bool XrmGetResource(database, str_name, str_class,
		    str_type_return, value_return)
     XrmDatabase database;
     _Xconst char *str_name;
     _Xconst char *str_class;
     char **str_type_return;
     XrmValue *value_return;
{/*          File 'resources.o'*/
  char str[80];
  char *lookfor,*entry,*c;
#ifdef DEBUGXEMUL_ENTRY
  printf("XrmGetResource\n");
#endif
  if(debugxemul)
    printf("XrmGetResource name: [%s]\n",str_name);

  if(database!=NULL){
    entry=findentry((listnode*)database,str_name);
    if(entry){
      value_return->size=strlen(entry);
      value_return->addr=entry;
      return(1);
    }else{
      value_return->size=0;
      value_return->addr=NULL;
    }
  }

  if((c=strchr(str_name,'.'))!=NULL) strcpy(str,c);
  else if((c=strchr(str_name,'*'))!=NULL) strcpy(str,c);
  else if((c=strchr(str_name,'-'))!=NULL) strcpy(str,c);
  else{
    str[0]='.';
    strcpy(&str[1],str_name);
  }

  if(_XtFallbackResource){
    char *hit;
    int n=0;
    while((entry=_XtFallbackResource[n++])){
      if((hit=strstr(entry,str+1))!=NULL){
	char *p=strchr(hit,':')+1;
	while((*p==' '||*p==9)&&*p!=0)p++;
	if(p){
	  value_return->size=strlen(p);
	  value_return->addr=p;
	  return(1);
	}
      }
      
    }
  }

  return(0);
}

XrmDatabase XrmGetStringDatabase(data)
     char *data;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XrmGetStringDatabase\n");
#endif
  return(X11DefaultResources);
}

void XrmMergeDatabases(source_db, target_db)
     XrmDatabase source_db, *target_db;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XrmMergeDatabases\n");
#endif
  if(!(*target_db)) *target_db=source_db;
  return(0);
}

void X11ScanFile(FILE *fp){
  while(!feof(fp)){
    char str1[80],str2[40],*c;
    fscanf(fp,"%s %s",str1,str2);
    if( (c=strrchr(str1,':'))!=NULL) *c=0;
    if(str1[0]!='!')
      XrmPutStringResource((listnode**)&X11DefaultResources,str1,str2);
    else while(fgetc(fp)!='\n'&&!feof(fp));
  }
}

void XrmInitialize(){/*           File 'xv.o' */
  FILE *fp;
#ifdef DEBUGXEMUL_ENTRY
  printf("XrmInitialize\n");
#endif
  if(X11DefaultResources!=NULL) return;
  makenull((listnode **)(&X11DefaultResources));
  fp=fopen("AmigaDefaults","r");
  if(!fp){
    fp=fopen("libx11:AmigaDefaults","r");
    if(!fp) return;
  }
  X11ScanFile(fp);
  fclose(fp);
  return(0);
}

XrmDatabase XrmGetFileDatabase(filename)
     char *filename;
{/*      File 'xv.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XrmGetFileDatabase\n");
#endif
  return(0);
}

void XrmDestroyDatabase(database)
     XrmDatabase database;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XrmDestroyDatabase\n");
#endif
  deletelist(&database);
  return(0);
}

void XrmPutStringResource(database, specifier, value)
      XrmDatabase *database;
     char *specifier;
     char *value;
{/*    File 'main.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XrmPutStringResource\n");
#endif
  if(debugxemul) printf("XrmPutStringResource: specifier [%s] value [%s]\n",specifier,value);
  if(*database==NULL){
    makenull((listnode**)database);
  }
  insert((listnode**)database,makenode(specifier,value));
}

void XrmPutResource(database, specifier, type, value)
     XrmDatabase *database;
     char *specifier;
     char *type;
     XrmValue *value;
{/*          File 'main.o'*/
#ifdef DEBUGXEMUL_ENTRY
  if(debugxemul) printf("XrmPutResource: specifier [%s]\n");
#endif
  deleteentry(database,specifier);
  insert(database,makenode(specifier,value->addr));
}

XrmDatabase XtDatabase(display)
     Display *display;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XtDatabase\n");
#endif
/*  if(_Xresources==NULL) makenull(&_Xresources);
  return(_Xresources);*/
  if(X11DefaultResources==NULL){
    makenull(&X11DefaultResources);
  }
  return(X11DefaultResources);
}

void XrmPutLineResource(database, line)
     XrmDatabase *database;
     char *line;
{/*      File 'xargs.o' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XrmPutLineResource\n");
#endif
  if(!(*database)) *database=XtDatabase(NULL);
  return(0);
}

void XrmParseCommand(database, table, table_count, name, argc_in_out,argv_in_out)
     XrmDatabase *database;
     XrmOptionDescList table;
     int table_count;
     char *name;
     int *argc_in_out;
     char **argv_in_out;
{/*         File 'xargs.o' */
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XrmParseCommand\n");
#endif
  return(0);
}

listnode *X11InternalAtoms=NULL;

#define INTERNALATOMS

Atom XInternAtom(display, property_name, only_if_exists)
     Display *display;
     char *property_name;
     Bool only_if_exists;
{/*             File 'xdaliclock.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XInternAtom\n");
#endif
#ifdef INTERNALATOMS
  if(only_if_exists){
    return((Atom)findentry(X11InternalAtoms,property_name));
  } else {
    if(findentry(X11InternalAtoms,property_name)==NULL)
      insert(&X11InternalAtoms,makenode(property_name,property_name));
    return((Atom)findentry(X11InternalAtoms,property_name));
  }
#else
  return 0;
#endif
}

void X11exit_resources(void){
#ifdef INTERNALATOMS
  if(X11InternalAtoms) deletelist(&X11InternalAtoms);
#endif
  deletelist(&X11DefaultResources);
}

void X11init_resources(void){
#ifdef INTERNALATOMS
  makenull(&X11InternalAtoms);
#endif
  XrmInitialize();
}
