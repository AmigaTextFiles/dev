/****h *AmigaTalk/SysImage.c [1.5]  ************************************
**
** NAME 
**    SysImage.c  Read & Write image files of the current AmigaTalk
**                system environment.  These functions are called from
**                other functions in LexCmd.c
**
** DEFINED FUNCTIONS:
**
** PUBLIC void dosave()
**
** PUBLIC void doload();
**
** ------------- Private functions: -----------------------------------
**
** void  lexinclude( char * );   Do ')i' command.
**       Call the PARSER via system( cmdbuff ).
**
** void  lexread( char * );      Do ')g' or ')r' command.
**       Use set_file( FILE * ) to set up line_grabber() to do the actual
**       reading of the file.
**
** int   lexedit( char * );      Do ')e' command.
**       Call the EDITOR defined in environment var EDITOR (or use 'Ed')
**       via system( cmdbuff )  After lexedit(), dolexcommand() calls
**       lexinclude() for this ')e' command.
**
** NOTES 
**
**     For Objects, the super_obj field points to a chain of Classes,
**     all the way to the root object 'Object', this is why new_inst()
**     is a RECURSIVE function.  Until a good procedure is determined
**     to get around this, this file is STILL IN DEVELOPMENT!
**
**     The Image file structure is as follows:
**
** NumberofClasses\n
** ClassName ParentClass SrcFileName\n (if NumberofClasses > 0)
** NumCInstVars\n
** CInstanceVar1\n                     (if NumCInstVars > 0)
** ...
** NumberofMethods\n
** MethodName NumberofByteCodes\n      (NumberofMethods has to be >= 1)
** 
** --------------- Method Instance variables are taken care of within
** --------------- the ByteCode representation of the method, hence
** --------------- there are no pointers in the class structures for
** --------------- them.  This means that NumMInstVars & 
** --------------- MInstVarArray are probably not needed.
**
** NumMInstVars\n
** MInstanceVar1\n                     (if NumMInstVars > 0)
** ...
** HH HH HH ... HH\n                   (the ByteCodes of the Method) 
** ...
** NumberofObjects\n
** ObjectName ClassName\n              (if NumberofObjects > 0)
** NumOInstVars\n
** OInstanceVar1\n                     (if NumOInstVars > 0)
** ...
** ContextSize StackSize\n
** ...
** <EOF>
************************************************************************
*/

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

#include <exec/types.h>

#include "env.h"
#include "Constants.h"
#include "FuncProtos.h"

PRIVATE char ClassName[80];
PRIVATE char ParentName[80];
PRIVATE char SrcFileName[80];
PRIVATE char MethodName[80];
PRIVATE char ObjectName[80];

PRIVATE char **CInstVarArray   = NULL;
PRIVATE char **MInstVarArray   = NULL;
PRIVATE char **OInstVarArray   = NULL;
PRIVATE char **MethodNameArray = NULL;

PRIVATE ULONG NumClasses   = 0L;
PRIVATE ULONG NumMethods   = 0L;
PRIVATE ULONG NumObjects   = 0L;
PRIVATE ULONG NumCInstVars = 0L;
PRIVATE ULONG NumMInstVars = 0L;
PRIVATE ULONG NumOInstVars = 0L;
PRIVATE ULONG ContextSize  = 0L;
PRIVATE ULONG StackSize    = 0L;
PRIVATE ULONG NumByteCodes = 0L;

PRIVATE UBYTE *ByteCodeArray = NULL;
PRIVATE APTR   memPool       = NULL;
PRIVATE char   lbuff[256];


PRIVATE void FreeStringArray( char **strarray, int numentries )
{
   int i = 0;

   if ((strarray == NULL) || (numentries < 1))
      return;

   while (i < numentries)
      {
      if (strarray[i] != NULL)
         {
         FreePooled( memPool, (APTR) strarray[i], 
                     strlen( strarray[i] ) + 1
                   );

         strarray[i] = NULL;
         }
      i++;
      }

   FreePooled( memPool, (APTR) strarray, numentries * sizeof( char * ) );
   strarray = NULL;
   return;    
}

PRIVATE void ReadByteCodes( FILE *fp, ULONG numbytecodes )
{
}

PRIVATE void StowMethod( char *methodName )
{
} 

/* numMethods HAS TO BE be greater than 1: */

PRIVATE void ReadMethods( FILE *fp, ULONG numMethods )
{
   char *t = NULL;
   int   i; 
    
   MethodNameArray = (char **) AllocPooled( memPool, 
                                            numMethods * sizeof( char * )
                                          );
   if (MethodNameArray == NULL)
      {
      (void) Handle_Problem( "Ran out of memory for readMethods Array!", 
                             "Allocation Problem:", NULL
                           );
      return;
      }

   for (i = 0; i < numMethods; i++)
      {
      fscanf( fp, "%s %d\n", MethodName, NumByteCodes );

      t = (char *) AllocPooled( memPool, 
                                (strlen( MethodName ) + 1 ) 
                                * sizeof( char )
                              );
      if (t == NULL)
         {
         (void) Handle_Problem( "Ran out of memory for readMethods Array!", 
                                "Allocation Problem:", NULL
                              );

         FreePooled( memPool, (APTR) MethodNameArray, 
                     numMethods * sizeof ( char * )
                   );
         return;
         }      
      
      MethodNameArray[i] = t;
      strcpy( t, MethodName );
      
      (void) fgets( lbuff, fp );
      NumMInstVars = atoi( lbuff );
      if (NumMInstVars > 0) 
         {
         ReadMInstVars( fp, NumMInstVars );
         }

      ReadByteCodes( fp, NumByteCodes );
      StowMethod( MethodName ); 

      FreeStringArray( MInstVarArray, NumMInstVars );
      FreeStringArray( ByteCodeArray, NumByteCodes );
      }
   
   FreeStringArray( MethodNameArray, numMethods );      
   return;
}

PRIVATE char **ReadOInstVars( FILE *fp, int numentries )
{
   char *t = NULL;
   int   i;
   
   if (numentries < 1)
      return( NULL );

   OInstVarArray = (char **) AllocPooled( memPool, 
                                          numentries * sizeof( char * )
                                        );
   if (OInstVarArray == NULL)
      return( NULL );
   
   for (i = 0; i < numentries; i++)
      {
      int len = 0;
      
      (void) fgets( lbuff, fp );
      len = strlen( lbuff );

      if (lbuff[ len ] == '\n')
         {
         len = len - 1;
         }

      t = (char *) AllocPooled( memPool, (len + 1) * sizeof( char ) );
      if (t == NULL)
         {
         (void) Handle_Problem( "Ran out of memory for readObjects Array!",
                                "Allocation Problem:", NULL
                              );

         FreeStringArray( OInstVarArray, numentries );
         return;
         }

      OInstVarArray[i] = t;
      strcpy( t, lbuff );
      }

   return( OInstVarArray );
}

PRIVATE void StowObject( char *objectName, char *className,
                         ULONG numInstVars, char **varArray,
                         ULONG contextSize, ULONG stackSize
                       )
{
   return;
}

PRIVATE void ReadObjects( FILE *fp )
{
   char **ovars = NULL;
   int   i; 
    
   (void) fgets( lbuff, fp );
   NumObjects = atoi( lbuff );
   
   for (i = 0; i < NumObjects; i++)
      {
      fscanf( fp, "%s %s\n", ObjectName, ClassName );

      (void) fgets( lbuff, fp ); 
      NumOInstVars = atoi( lbuff );
      
      if (NumOInstVars > 0) 
         {
         ovars = ReadOInstVars( fp, NumOInstVars );
         }

      fscanf( fp, "%d %d\n", &ContextSize, &StackSize );

      StowObject( ObjectName, ClassName, NumOInstVars,
                  ovars, ContextSize, StackSize
                );

      FreeStringArray( ovars, NumOInstVars );
      }
   
   return;
}

PRIVATE char **ReadInstances( FILE *fp, ULONG numentries )
{
   char *t = NULL, char **array = NULL;
   int   i;
       
   if (numentries < 1 )
      return( NULL);
      
   array = (char **) AllocPooled( memPool, numentries * sizeof( char * ) );
   if (array == NULL)
      return( NULL );
   
   for (i = 0; i < numentries; i++)
      {
      int len = 0;
      
      (void) fgets( lbuff, fp );
      len = strlen( lbuff );

      if (lbuff[ len ] == '\n')
         {
         len = len - 1;
         }

      t = (char *) AllocPooled( memPool, (len + 1) * sizeof( char ) );
      if (t == NULL)
         {
         (void) Handle_Problem( "Ran out of memory for Instance Array!", 
                                "Allocation Problem:", NULL
                              );

         FreeStringArray( array, numentries );
         return( NULL );
         }

      array[i] = t;
      strcpy( t, lbuff );
      }

   return( array );
}

PRIVATE void ReadMInstVars( FILE *fp, ULONG numentries )
{
   MInstVarArray = ReadInstances( fp, numentries );
   return;
}

PRIVATE void ReadCInstVars( FILE *fp, ULONG numentries )
{
   CInstVarArray = ReadInstances( fp, numentries );
   return;
}
 
PRIVATE void StowClass( void )
{
}

PRIVATE void FreeClassAllocs( void )
{
}

PRIVATE void FreeImageAllocs( void )
{
}

/* User issued a )l system directive: */

PUBLIC void doload( char *filename )
{
   FILE *infile = NULL;
   int   i;

   memPool = CreatePool( MEMF_FAST | MEMF_CLEAR, 1024, 128 );

   if (memPool == NULL)
      {
      (void) Handle_Problem( "Ran out of memory for loading image!", 
                             "Allocation Problem:", NULL
                           );
      return;
      }      

   if ((infile = fopen( filename, "r" )) == NULL)
      {
      (void) Handle_Problem( "", "", NULL );
      return;
      }

   (void) fgets( lbuff, infile );
   NumClasses = atoi( lbuff );
   for (i = 0; i < NumClasses; i++)
      {
      fscanf( infile, "%s %s %s\n", ClassName, ParentName, SrcFileName );

      Amiga_Printf( "Working on %s Class...\n", ClassName );
 
      (void) fgets( lbuff, infile );
      NumCInstVars = atoi( lbuff );

      if (NumCInstVars > 0)
         {
         ReadCInstVars( infile, NumCInstVars );
         }
 
      (void) fgets( lbuff, infile );
      NumMethods = atoi( lbuff );
      
      StowClass();
      ReadMethods( infile, NumMethods );
      FreeClassAllocs();
      }

   ReadObjects( infile );
   //   FreeImageAllocs();
   DeletePool( memPool );
   fclose( infile );
   return;
}

/* ----------------- Save Image Section: ------------------------- */

/* User issued a )s system directive: */

PUBLIC void dosave( char *filename )
{
   FILE *outfile = NULL;
   int   i;

   memPool = CreatePool( MEMF_FAST | MEMF_CLEAR, 1024, 128 );

   if (memPool == NULL)
      {
      (void) Handle_Problem( "Ran out of memory for saving image!", 
                             "Allocation Problem:", NULL
                           );
      return;
      }      

   if ((outfile = fopen( filename, "w" )) == NULL)
      {
      (void) Handle_Problem( "", "", NULL );
      return;
      }

   DeletePool( memPool );
   fclose( outfile );
   return;
}

/* ------------------ END of SysImage.c file! ------------------------ */
