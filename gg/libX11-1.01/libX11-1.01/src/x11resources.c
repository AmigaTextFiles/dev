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

7. Nov 96: Added comment headers to all functions and cleaned the code up
           somewhat. If you have the manual pages you may notice an eerie
	   similarity..
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

#include "x11display.h"
#include "x11resources.h"


/*******************************************************************************************/
/* structs */
/*******************************************************************************************/

typedef struct rnode {
  char *zName;
  char *pData;
  struct rnode *pNext;
} ResourceNode_t;

typedef ResourceNode_t* ResourceNode_p;

/*******************************************************************************************/
/* externals */
/*******************************************************************************************/

extern ResourceNode_p MakeRNode(char *,char *);
extern int debugxemul;
extern void init_memlist( void );
ResourceNode_p findentry( ListNode_t *list, char *name );

/********************************************************************************/
/* internal */
/********************************************************************************/

ListNode_t* _Xresources = NULL;

String *_XtFallbackResource = NULL;

char *X11ResourceManagerString = "AmigaResources";
XrmDatabase X11DefaultResources = NULL;
int bDeletedDefault = 0;

#ifdef DEBUGXEMUL_ENTRY
int bIgnoreResources = 1; /* ignore outputting information about resources */
#endif

int bReadDefaultsFile = 0;

/********************************************************************************
Function : XResourceManagerString()
Author   : Terje Pedersen
Input    : display   Specifies the connection to the X server.
Output   : 
Function : return the RESOURCE_MANAGER property.
********************************************************************************/

char *
XResourceManagerString( Display* display )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XResourceManagerString\n");
#endif

  return(X11ResourceManagerString);
}

/********************************************************************************
Function : XrmSetDatabase()
Author   : Terje Pedersen
Input    : 
     display   Specifies the connection to the X server.

     database  Specifies the resource database.

Output   : 
Function : associate a resource database with a display.
********************************************************************************/
void
XrmSetDatabase( Display* display, XrmDatabase database )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreResources )
    printf("WARNING: XrmSetDatabase\n");
#endif
}

/********************************************************************************
Function : XrmGetResource()
Author   : Terje Pedersen
Input    : 
     database  Specifies the database that is to be used.

     str_name  Specifies the  fully  qualified  name  of  the  value  being
               retrieved.

     str_class Specifies the fully  qualified  class  of  the  value  being
               retrieved.

     str_type_return
               Returns  a  pointer  to  the  representation  type  of   the
               destination.   In  this function, the representation type is
               represented as a string, not as an XrmRepresentation.

     value_return
               Returns the value in the database.  Do not  modify  or  free
               this data.

Output   : 
Function : get a resource from name and class as strings.
********************************************************************************/

Bool
XrmGetResource( XrmDatabase database,
	        _Xconst char* str_name,
	        _Xconst char* str_class,
	        char** str_type_return,
	        XrmValue* value_return )
{
  char str[80];
  char *entry,*c;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XrmGetResource\n");
#endif
  if( database ){
    ResourceNode_p p;

    p = findentry( (ListNode_t*)database, (char*)str_name );
    if( p ){
      entry = (char*)p->pData;
      value_return->size = strlen(entry);
      value_return->addr = entry;

      if( debugxemul )
	printf("XrmGetResource name: %s [%s] - %s\n", str_class, str_name, entry );

      return(1);
    } else {
      value_return->size = 0;
      value_return->addr = NULL;
    }
  }

  if( (c = strchr(str_name,'.')) )
    strcpy(str,c);
  else if( (c = strchr(str_name,'*')) )
    strcpy(str,c);
  else if( (c = strchr(str_name,'-')) )
    strcpy(str,c);
  else {
    str[0] = '.';
    strcpy(&str[1],str_name);
  }

  if( _XtFallbackResource ){
    char *hit;
    int n = 0;

    while( (entry = _XtFallbackResource[n++]) ){
      if( (hit = strstr(entry,str+1)) ){
	char *p = strchr(hit,':')+1;

	while( (*p==' ' || *p==9) && *p )p++;
	if( p ){
	  value_return->size = strlen(p);
	  value_return->addr = p;

	  if( debugxemul )
	    printf("XrmGetResource name: %s [%s] - %s\n",str_class,str_name,p);

	  return(1);
	}
      }
      
    }
  }

  if( debugxemul )
    printf("XrmGetResource name: [%s] - not found\n",str_name);

  return(0);
}

/********************************************************************************
Function : XrmGetStringDatabase()
Author   : Terje Pedersen
Input    : data      Specifies the database contents using a string.
Output   : 
Function : create a database from a string.
********************************************************************************/

XrmDatabase
XrmGetStringDatabase( _Xconst char* data )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XrmGetStringDatabase\n");
#endif

  return(X11DefaultResources);
}

/********************************************************************************
Function : XrmMergeDatabases()
Author   : Terje Pedersen
Input    : 
     source_db Specifies the  resource  database  to  be  merged  into  the
               existing database.

     target_db Specifies a pointer to the resource database into which  the
               source_db database will be merged.
Output   : 
Function : merge the contents of one database into another.
********************************************************************************/

void 
XrmMergeDatabases( XrmDatabase source_db,
		   XrmDatabase* target_db )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XrmMergeDatabases\n");
#endif
  if( !source_db )
    return;
  if( !(*target_db) )
    *target_db = source_db;
  else {
    ListNode_t *p = ((ListNode_t*) source_db )->pNext;

    while( p != NULL ){
      List_AddEntry( *(ListNode_t**)target_db, p->pData );
      List_RemoveNode( (ListNode_t*)source_db, p->pData );
      p = p->pNext;
    }
  }
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void X11ScanFile( FILE *fp )
{
  while(!feof(fp)){
    char str1[80],str2[40],*c,*pstr;

    fscanf(fp,"%s",str1);
    if( (c=strrchr(str1,':'))!=NULL )
      *c = 0;
    fgets( str2, 40, fp );
    if( (c=strrchr(str2,'\n'))!=NULL )
      *c = 0;
    pstr = str2;
    while( isspace(*pstr) )
      pstr++;

    if(str1[0]!='!')
      XrmPutStringResource(&X11DefaultResources,str1,pstr);
    else while(fgetc(fp)!='\n'&&!feof(fp));
  }
}

/********************************************************************************
Function : XrmInitialize()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : initialize the resource manager.
********************************************************************************/
void
XrmInitialize()
{
  FILE *fp;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XrmInitialize\n");
#endif
  if( X11DefaultResources )
    return;
  X11DefaultResources = (XrmDatabase)List_MakeNull();

  fp = fopen("AmigaDefaults","r");
  if( !fp ){
    fp = fopen("libx11:AmigaDefaults","r");
    if( !fp )
      return;
    if( debugxemul )
      printf("XrmInitialize scanning: [libx11:AmigaDefaults]\n");
  } else {
    if( debugxemul )
      printf("XrmInitialize scanning: [AmigaDefaults]\n");
  }
  X11ScanFile(fp);
  fclose(fp);
}

/********************************************************************************
Function : XrmGetFileDatabase()
Author   : Terje Pedersen
Input    : filename  Specifies the resource database filename.
Output   : 
Function : retrieve a database from a file.
********************************************************************************/
XrmDatabase
XrmGetFileDatabase( _Xconst char* filename )
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreResources )
    printf("WARNING: XrmGetFileDatabase\n");
#endif

  return(0);
}

/********************************************************************************
Function : XrmDestroyDatabase()
Author   : Terje Pedersen
Input    : database  Specifies the resource database.
Output   : 
Function : destroy a resource database.
********************************************************************************/

void
XrmDestroyDatabase( XrmDatabase database )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XrmDestroyDatabase\n");
#endif
  List_FreeList( (ListNode_t*)database );
  if( database == X11DefaultResources ){
    X11DefaultResources = NULL;
    bDeletedDefault = 1;
  }
}

/********************************************************************************
Function : XrmPutStringResource()
Author   : Terje Pedersen
Input    : 
     database  Specifies a pointer to the resource database.   If  database
               contains  NULL,  a  new  resource  database is created and a
               pointer to it is returned in database.

     specifier Specifies the resource, as a string.

     value     Specifies the value of the resource, as a string.

Output   : 
Function : add a resource specification with separate resource name and value.
********************************************************************************/

void
XrmPutStringResource( XrmDatabase* database,
		      _Xconst char* specifier,
		      _Xconst char* value )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XrmPutStringResource\n");
#endif
  if( debugxemul )
    printf("XrmPutStringResource: specifier [%s] value [%s]\n",specifier,value);
  if( !*database ){
    *database = (XrmDatabase)List_MakeNull();
#if (MEMORYTRACKING!=0)
    List_AddEntry(pMemoryList,(void*)*database);
#endif /* MEMORYTRACKING */
  }
  List_AddEntry( *(ListNode_t**)database, MakeRNode((char*)specifier,(char*)value) );
}

/********************************************************************************
Function : XrmPutResource()
Author   : Terje Pedersen
Input    : 
     database  Specifies a pointer to the resource database.   If  database
               contains  NULL,  a  new  resource  database is created and a
               pointer to it is returned in database.   If  a  database  is
               created, it is created in the current locale.

     specifier  Specifies  a  complete  or  partial  specification  of  the
               resource.

     type      Specifies the type of the resource.

     value     Specifies the value of the resource.

Output   : 
Function : store a resource specification into a resource database.
********************************************************************************/

void
XrmPutResource( XrmDatabase* database,
	        _Xconst char* specifier,
	        _Xconst char* type,
	        XrmValue* value )
{
  ResourceNode_p pData;

#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XrmPutResource: specifier [%s]\n");
#endif
  pData = findentry( *(ListNode_t**)database, (char*)specifier );
  if( pData )
    List_RemoveEntry( *(ListNode_t**)database, pData );
  List_AddEntry( *(ListNode_t**)database, MakeRNode((char*)specifier,(char*)value) );
}

/********************************************************************************
Function : XtDatabase()
Author   : Terje Pedersen
Input    : 
     display   Specifies the display for which the resource database should
               be returned.
Output   : 
Function : obtain the resource database for a display.
********************************************************************************/

XrmDatabase
XtDatabase( Display* display )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XtDatabase\n");
#endif
  if( !X11DefaultResources ){
    X11DefaultResources = (XrmDatabase)List_MakeNull();
  }

  return(X11DefaultResources);
}

/********************************************************************************
Function : XrmPutLineResource()
Author   : Terje Pedersen
Input    : 
     database  Specifies a pointer to the resource database.   If  database
               contains  NULL,  a  new  resource  database is created and a
               pointer to it is returned in database.   If  a  database  is
               created, it is created in the current locale.

     line       Specifies  the  resource  name  (possibly   with   multiple
               components) and value pair as a single string, in the format
               resource:value.

Output   : 
Function : add a resource specification to a resource database.
********************************************************************************/

void
XrmPutLineResource( XrmDatabase* database, _Xconst char* line )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XrmPutLineResource\n");
#endif
  if( !(*database) )
    *database = XtDatabase(NULL);
}

/********************************************************************************
Function : XrmParseCommand()
Author   : Terje Pedersen
Input    : 
     database  Specifies a pointer to the resource database.   If  database
               contains  NULL,  a  new  resource  database is created and a
               pointer to it is returned in database.   If  a  database  is
               created, it is created in the current locale.

     table     Specifies table of command line arguments to be parsed.

     table_count
               Specifies the number of entries in the table.

     name      Specifies the application name.

     argc_in_out
               Before the call, specifies the number  of  arguments.  After
               the call, returns the number of arguments not parsed.

     argv_in_out
               Before the call, specifies a pointer  to  the  command  line
               arguments.   After  the  call, returns a pointer to a string
               containing the command line  arguments  that  could  not  be
               parsed.

Output   : 
Function : load a resource database from command line arguments.
********************************************************************************/
void
XrmParseCommand( XrmDatabase* database,
		 XrmOptionDescList table,
		 int table_count,
		 _Xconst char* name,
		 int* argc_in_out,
		 char** argv_in_out )
{
  int i,j = 1;

#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if( !bIgnoreResources )
    printf("WARNING: XrmParseCommand\n");
#endif

  init_memlist();

  if( !*database ){
    *database = (XrmDatabase)List_MakeNull();
  }

  if( *argc_in_out<=1 )
    return;
  do {
    int bFound = FALSE;

    for( i=0; i<table_count; i++ ){

      char *str=argv_in_out[j];
      if( !strncmp(&str[1],&table[i].specifier[1],strlen(str)-1) ){
	int n;
	char str[80];
	
	strcpy(str,name);
	strcat(str,table[i].specifier);

	if( *argc_in_out>2 ) {
	  if( *argv_in_out[j+1]!='-' ){
	    XrmPutStringResource(database,str,argv_in_out[j+1]);
	    for( n=j; n<*argc_in_out-2; n++ ){
	      argv_in_out[n]=argv_in_out[n+2];
	    }
	    *argc_in_out -= 2;
	  } else {
	    XrmPutStringResource(database,str," ");
	    *argc_in_out -= 1;
	  }
	} else {
	  XrmPutStringResource(database,str," ");
	  *argc_in_out -= 1;
	}
	bFound = TRUE;
	break;
      }
    }
    if( !bFound )
      j++;
  } while( j<*argc_in_out );
}

ListNode_t* X11InternalAtoms = NULL;

#define INTERNALATOMS

/********************************************************************************
Function : XInternAtom()
Author   : Terje Pedersen
Input    : 
     display   Specifies  a  connection  to  an  X  server;  returned  from
               XOpenDisplay().

     property_name
               Specifies the string name of the property for which you want
               the atom. Upper or lower case is important.  If the property
               name is not in the Host Portable  Character  Encoding,  then
               the result is implementation-dependent.

     only_if_exists
               Specifies a boolean value: if no such  property_name  exists
               XInternAtom()  will  return  None if this argument is set to

Output   : 
Function : return an atom for a given property name string.
********************************************************************************/

Atom
XInternAtom( Display* display,
	     char* property_name,
	     Bool only_if_exists )
{
#ifdef DEBUGXEMUL_ENTRY
  if( !bIgnoreResources )
    printf("XInternAtom\n");
#endif
#ifdef INTERNALATOMS
  if( only_if_exists ){
    return((Atom)findentry((ListNode_t*)X11InternalAtoms,property_name));
  } else {
    if( !findentry((ListNode_t*)X11InternalAtoms,property_name) )
      List_AddEntry((ListNode_t*)X11InternalAtoms,MakeRNode(property_name,property_name));

    return((Atom)findentry((ListNode_t*)X11InternalAtoms,property_name));
  }
#else
  return 0;
#endif
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11exit_resources( void )
{
#ifdef INTERNALATOMS
#ifdef OPTDBG
  printf("intern %d\n",X11InternalAtoms);
#endif
  if( X11InternalAtoms )
    List_FreeList( (ListNode_t*)X11InternalAtoms );
#endif
  if( X11DefaultResources && !bDeletedDefault ){
    List_FreeList( (ListNode_t*)X11DefaultResources );
  }
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
X11init_resources( void )
{
#ifdef INTERNALATOMS
  X11InternalAtoms = List_MakeNull();
#endif
  XrmInitialize();
}

/********************************************************************************
Name     : XGetDefault()
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

char *
XGetDefault( Display* display, char* program, char* option )
{
  FILE *fp;
  XrmValue xv;

#ifdef DEBUGXEMUL_ENTRY
#endif
  if( !bReadDefaultsFile ){
    bReadDefaultsFile = 1;
    if( debugxemul && program )
      printf("XGetDefault: [%s] \n",program);
    else
      printf("XGetDefault:\n");

    fp = fopen(".XDefaults","r");
    if( fp ){
      X11ScanFile(fp);
      fclose(fp);
      XrmGetResource(XtDatabase(NULL),option,program,NULL,&xv);

      return((char*)xv.addr);
    }
    fclose(fp);
  } else {
    XrmGetResource(XtDatabase(NULL),option,program,NULL,&xv);

    return((char*)xv.addr);
  }

  return(NULL);
}

ResourceNode_p
findentry( ListNode_t *list, char *name )
{
  ListNode_t *p = list->pNext;

  while( p != NULL && stricmp( name, ((ResourceNode_p)(p->pData))->zName ) != 0 )
    p = p->pNext;
  if( p != NULL )
    return (ResourceNode_p)p->pData;
  return NULL;
}

/********************************************************************************
Function : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
ResourceNode_p
MakeRNode( char *name, char *data ) {
  ResourceNode_p n = malloc(sizeof(ResourceNode_t));
  char *str1 = NULL, *str2 = NULL;

  if(!n) X11resource_exit(RESOURCE1);
  if( name!=NULL ){
    str1 = malloc(strlen(name)+1);
    if(!str1) X11resource_exit(RESOURCE2);
    strcpy( str1, name );
  }
  if(data!=NULL){
    str2 = malloc(strlen(data)+1);
    if(!str2) X11resource_exit(RESOURCE3);
    strcpy( str2, data );
  }
  n->zName = str1;
  n->pData = str2;
  n->pNext = NULL;
  return( n );
}
