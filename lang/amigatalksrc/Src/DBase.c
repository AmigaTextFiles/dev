/****h* AmigaTalk/DBase.c [3.0] ***************************************
*
* NAME 
*   DBase.c
*
* DESCRIPTION
*   Functions that handle dBC III to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleSrcFile( int numargs, OBJECT **args ); <???>
*
* HISTORY
*   20-Feb-2007 - Changed the namespace from DB* to DB_*
*
*   25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*   08-Jan-2003 - Moved all string constants to StringConstants.h
*
*   21-Dec-2002 - Removed ByteArrays & replaced them with String
*                 arguments.
*
*   19-Dec-2002 - Added DBReadTemplate() <primitive 209 6 13 fileName>
*
*   28-Jul-2002 - Added breakPoint <primitive 209 10 0 msgString>
*
*   21-May-2002 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/DBase.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <dbc.h>
#include <dbcstructs.h>
#include <dbcprotos.h>

#ifdef    __SASC

# include <clib/intuition_protos.h>

#else

# define __USE_INLINE__

# include <proto/intuition.h>

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See ReportErrs.c for these: ----------------------------------------

IMPORT UBYTE *ATalkProblem;
IMPORT UBYTE *AllocProblem;
IMPORT UBYTE *UserPgmError;

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

PRIVATE dBFIELD tempFields[128] = { 0, };

/*
typedef unsigned short U2BYTES; // unsigned 2 bytes data

typedef long          RECNUM;   // record number
typedef UBYTE         FLDWIDTH; // field width in bytes or characters
typedef UBYTE         FLDDEC;   // decimal places in field
typedef UBYTE         FLDNUM;   // number of fields per record
typedef unsigned int  RECLEN;   // record length
typedef UBYTE         KEYLEN;   // key length

//****************************************
// .DBF record field definition structure 
//****************************************

typedef struct   {

        char fieldnm[11]; // field name terminating with NULL(0)
        char type;        // type of data
                          // 'C' - character
                          // 'N' - numeric
                          // 'D' - date
                          // 'L' - logical
                          // 'M' - memo    
        FLDWIDTH width;   // field width
        FLDDEC   dec;     // length of decimal places

        } dBFIELD;

typedef struct   {

   int      _dbffn;    // file number == dbFileDescriptor
   BYTE     _dbfmode;  // mode of open file
   RECNUM   _alcnum;   // number of records allocated
   int      _dbfupd;   // data file update indicator
   RECLEN   _len;      // record length

                       // I/O buffer information
   U2BYTES  _bufsize;  // I/O buffer size
   char    *_bfptr;    // I/O buffer location pointer
   U2BYTES  _maxnum;   // maximum number of records in I/O buffer
   RECNUM   _first;    // number of first record in buffer
   U2BYTES  _bfhas;    // number of records currently contained in buffer
   BYTE     _month;    // file update date: month
   BYTE     _day;      //                   day
   BYTE     _year;     //                   year
   FLDNUM   _nflds;    // number of fields per record
   dBFIELD *_flds;     // pointer to array of dBC III field structure(dBFIELD) 
   U2BYTES  _begdata;  // beginning-of-data offset

}  DBFFILE;

*/

SUBFUNC void FileOpenProblem( char *filename, char *str )
{
   sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_NO_OPEN_DBASE ), filename, str );

   UserInfo( ErrMsg, UserPgmError );
   
   return;
}

SUBFUNC void FileCreateProblem( char *filename, char *str )
{
   sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_NO_CREAT_DBASE ), filename, str );
   
   UserInfo( ErrMsg, UserPgmError );
   
   return;
}

// ---- DataBase methods: ---------------------------------------------

/****i* DB_CheckForMemos() [3.0] ***************************************
*
* NAME
*    DB_CheckForMemos()
*
* DESCRIPTION
*    checkForMemosIn: recTemplate (is an Array of DBFields)
*    ^ <primitive 209 6 0 recTemplate>
*    This function is still necessary since create:for: method uses
*    it BEFORE the *.dbf file has been created & opened (see NOTES).
*
* NOTES
*    There should be a way to check for memos using the first byte
*    in the *.dbf file as a discriminator value:
*      0x03 == Plain *.dbf file.
*      0x83 == *.dbf file with memos attached.
***********************************************************************
*/

METHODFUNC OBJECT *DB_CheckForMemos( OBJECT *recTObj )
{
   OBJECT *rval   = o_false;
   OBJECT *fArray = recTObj->inst_var[0];
   int     size   = objSize( fArray ), i; // ->size, i;
    
   for (i = 0; i < size; i++)
      {
      OBJECT  *fldObj = fArray->inst_var[i];
      dBFIELD *field  = (dBFIELD *) int_value( fldObj->inst_var[0] );
            
      if (toupper( field->type ) == CAP_M_CHAR)
         {
         rval = o_true;

         break;
         }
      }
   
   return( rval );
}

/****i* DB_CreateFile() [3.0] ******************************************
*
* NAME
*    DB_CreateFile()
*
* DESCRIPTION
*    create: dbFileName for: recTemplate
*    ^ <primitive 209 6 1 dbFileName (recTemplate numberOfFields) recTemplate>
***********************************************************************
*/

METHODFUNC OBJECT *DB_CreateFile( char *dbfname, int nofields, OBJECT *recTObj )
{
   dBFIELD *fields = (dBFIELD *) NULL;
     
   _dbcerr = SUCCESS;

   if (nofields < 1)
      {
      _dbcerr = 101;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else if (nofields > 128)
      {
      _dbcerr = 102;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
      
   if (!(fields = (dBFIELD *) AT_AllocVec( nofields * sizeof( dBFIELD ),
                                           MEMF_CLEAR | MEMF_ANY, 
                                           "dbFields", TRUE ))) // == NULL)
      {
      _dbcerr = 114;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else
      {
      // Convert AmigaTalk Array into dBFIELD array:

      OBJECT *fArray = recTObj->inst_var[0];
      int     i;
      
      for (i = 0; i < nofields; i++)
         {
         OBJECT  *fldObj = fArray->inst_var[i];
         
         dBFIELD *field  = (dBFIELD *) int_value( fldObj->inst_var[0] );
           
         // DO NOT CHANGE field->inst_var[0]!!

         StringNCopy( fields[i].fieldnm, field->fieldnm, 10 );
         
         fields[i].type  = field->type;
         fields[i].width = field->width;
         fields[i].dec   = field->dec;
         }
      }

   if (dBcreat( dbfname, (FLDNUM) nofields, fields ) != SUCCESS)
      {
      AT_FreeVec( fields, "dbFields", TRUE );

      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else
      {   
      AT_FreeVec( fields, "dbFields", TRUE );

      return( AssignObj( new_int( 0 ) ) );
      }
}

/****i* DB_OpenFile() [3.0] ********************************************
*
* NAME
*    DB_OpenFile()
*
* DESCRIPTION
*    open: fileName for: recTemplate
*      ^ private <- <primitive 209 6 2 dbFileName>
***********************************************************************
*/

METHODFUNC OBJECT *DB_OpenFile( char *dbfname )
{
   long rval = 0L;
   
   _dbcerr = SUCCESS;

   if (dBopen( dbfname, (char **) &rval ) != SUCCESS)
      {
      return( o_nil );
      }
   else
      return( AssignObj( new_int( (int) rval ) ) );
}

/****i* DB_CloseFile() [3.0] *******************************************
*
* NAME
*    DB_CloseFile()
*
* DESCRIPTION
*    ^ <primitive 209 6 3 private>
***********************************************************************
*/

METHODFUNC OBJECT *DB_CloseFile( char *dbFileDescriptor )
{
   _dbcerr = SUCCESS;

   if (dBclose( dbFileDescriptor ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_GetFileInfo() [3.0] *****************************************
*
* NAME
*    DB_GetFileInfo()
*
* DESCRIPTION
*    ^ <primitive 209 6 4 private recTemplate>
***********************************************************************
*/

METHODFUNC OBJECT *DB_GetFileInfo( char *dbFileDescriptor, OBJECT *recTObj )
{
   RECLEN   reclen      = 0;
   BYTE     month       = 0, day = 0, year = 0;
   FLDNUM   nofields    = 0;
   OBJECT  *rval        = o_nil;
      
   _dbcerr = SUCCESS;

   if (dBgetf( dbFileDescriptor, &reclen, 
               &month, &day, &year, &nofields, tempFields ) == SUCCESS)
      {
      int i;

      if (objSize( recTObj ) == nofields)
         {
         OBJECT *fArray = recTObj->inst_var[0];
         
         for (i = 0 ; i < nofields; i++)
            {
            OBJECT *field = fArray->inst_var[i];

            if (toupper( char_value( field->inst_var[2] ) ) == CAP_M_CHAR)
               {
               // This function will probably screw up Memos!!
               obj_dec( field->inst_var[5] );
               obj_dec( field->inst_var[6] );
               }

            obj_dec( field->inst_var[0] );
            obj_dec( field->inst_var[1] );
            obj_dec( field->inst_var[2] );
            obj_dec( field->inst_var[3] );
            obj_dec( field->inst_var[4] );

            field->inst_var[0] = AssignObj( new_int(  (int) &tempFields[i]  )); // (int) field );
            field->inst_var[1] = AssignObj( new_str(  tempFields[i].fieldnm ));
            field->inst_var[2] = AssignObj( new_char( tempFields[i].type    ));
            field->inst_var[3] = AssignObj( new_int(  tempFields[i].width   ));
            field->inst_var[4] = AssignObj( new_int(  tempFields[i].dec     ));
            }

         return( recTObj ); 
         }
      else
         {
         // Make a new recTemplate (due to size mismatch):

         rval            = AssignObj( new_obj( recTObj->Class, nofields, FALSE ));
         rval->super_obj = AssignObj( recTObj->super_obj );

         // Setup all the fieldObjects for the recTemplate to be returned:
 
         for (i = 0; i < nofields; i++)
            {
            OBJECT  *field  = AssignObj( new_obj( recTObj->inst_var[0]->Class, 
                                                  objSize( recTObj->inst_var[0] ), 
                                                  FALSE 
                                                )
                                     );

            dBFIELD *newFld = (dBFIELD *) AT_AllocVec( sizeof( dBFIELD ),
                                                       MEMF_CLEAR | MEMF_ANY,
                                                       "newField", TRUE 
                                                     );
            if (!newFld) // == NULL)
               {
               _dbcerr = 114;
      
               MemoryOut( DBaseCMsg( MSG_DB_GETINFO_FUNC_DBASE ) );
         
               return( o_nil );
               }

            // Copy data from the dBgetf() call into our newFld struct:
            StringNCopy( newFld->fieldnm, tempFields[i].fieldnm, 10 );

            newFld->type  = (char)     tempFields[i].type;
            newFld->width = (FLDWIDTH) tempFields[i].width;
            newFld->dec   = (FLDDEC)   tempFields[i].dec;

            // Assign the instance variables of the field Object:  
            field->inst_var[0] = AssignObj( new_int(  (int) newFld    ));
            field->inst_var[1] = AssignObj( new_str(  newFld->fieldnm ));
            field->inst_var[2] = AssignObj( new_char( newFld->type    ));
            field->inst_var[3] = AssignObj( new_int(  newFld->width   ));
            field->inst_var[4] = AssignObj( new_int(  newFld->dec     ));

            rval->inst_var[i] = AssignObj( field );
            }
         }
      }

   return( rval );
}

/****i* DB_PutRecord() [3.0] *******************************************
*
* NAME
*    DB_PutRecord()
*
* DESCRIPTION
*    ^ <primitive 209 6 5 private recordNumber recordData self>
***********************************************************************
*/

METHODFUNC OBJECT *DB_PutRecord( char   *dbFileDescriptor, 
                                int     recno, 
                                OBJECT *recDObj, 
                                OBJECT *DBObj
                              )
{
   char *record = string_value( (STRING *) recDObj->inst_var[0] );
   char *fName  = string_value( (STRING *) DBObj->inst_var[9] );
      
   _dbcerr = SUCCESS;

   if (!record || record == (char *) o_nil)
      {
      _dbcerr = 4409;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }

   if (dBputr( dbFileDescriptor, (RECNUM) recno, record ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      {
      long rval = 0L;
   
      /* You have to close the *.dbf file (& re-open it) to update the # of records
      ** ULONG value in the *.dbf file
      */
      
      if (dBclose( dbFileDescriptor ) != SUCCESS)
         {
         _dbcerr = 4411;
         
         return( AssignObj( new_int( _dbcerr ) ) );
         }

      // Okay, now re-open the file:
      if (dBopen( fName, (char **) &rval ) != SUCCESS)
         {
         // Catastrophe!!
         _dbcerr = 4410;
         
         return( AssignObj( new_int( _dbcerr ) ) );
         }
      else
         {
         if (int_value( DBObj->inst_var[0] ) != (int) rval)
            {
            // dbFileDescriptor has changed, so renew the private Instance Var!
            KillObject( DBObj->inst_var[0] );
            
            DBObj->inst_var[0] = AssignObj( new_int( (int) rval ) );
            }
         }
      
      return( AssignObj( new_int( 0 ) ) ); 
      }
}

/****i* DB_ReadRecord() [3.0] ******************************************
*
* NAME
*    DB_ReadRecord()
*
* DESCRIPTION
*    read: recordNumber into: recordData
*    ^ <primitive 209 6 6 private recordNumber recordData currentRecStatus>   
***********************************************************************
*/

METHODFUNC OBJECT *DB_ReadRecord( char *dbFD, int recno,
                                 OBJECT *recDObj, OBJECT *statObj
                               )
{
   char *record = (char *) string_value( (STRING *) recDObj->inst_var[0] );
   char  status = NIL_CHAR;
   
   _dbcerr = SUCCESS;

   if (!record || (record == (char *) o_nil))
      {
      _dbcerr = 4409;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
      
   if (dBgetr( dbFD, (RECNUM) recno, record, &status ) != SUCCESS)
      return( new_int( _dbcerr ) );
   else
      {
      OBJECT *tmp = (statObj == o_nil) ? new_int( 0 ) : statObj;
      
      statObj = AssignObj( new_int( status ) );

      obj_dec( tmp );
      
      return( AssignObj( new_int( 0 ) ) ); 
      }
}

/****i* DB_Flush() [3.0] ***********************************************
*
* NAME
*    DB_Flush()
*
* DESCRIPTION
*    ^ <primitive 209 6 7 private>
***********************************************************************
*/

METHODFUNC OBJECT *DB_Flush( char *dbFileDescriptor )
{
   _dbcerr = SUCCESS;

   if (dBflush( dbFileDescriptor ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) ); 
}

/****i* DB_Size() [3.0] ************************************************
*
* NAME
*    DB_Size()
*
* DESCRIPTION
*    Return the number of Records in a DataBase file.
*    ^ <primitive 209 6 8 private>
***********************************************************************
*/

METHODFUNC OBJECT *DB_Size( char *dbFileDescriptor )
{
   RECNUM size = 0;
   
   _dbcerr = SUCCESS;

   if (dBsize( dbFileDescriptor, &size ) != SUCCESS)
      return( AssignObj( new_int( -1 ) ) );
   else
      return( AssignObj( new_int( size ) ) );
}

/****i* DB_Recall() [3.0] **********************************************
*
* NAME
*    DB_Recall()
*
* DESCRIPTION
*    Reactivate a previously deleted Record.
*    ^ <primitive 209 6 9 private recordNumber>
***********************************************************************
*/

METHODFUNC OBJECT *DB_Recall( char *dbFileDescriptor, int recno )
{
   _dbcerr = SUCCESS;

   if (dBrecall( dbFileDescriptor, (RECNUM) recno ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_Update() [3.0] **********************************************
*
* NAME
*    DB_Update()
*
* DESCRIPTION
*    Over-write the given Record[ recordNumber ] with the contents of
*    recordDataObject.
*    ^ <primitive 209 6 10 private recordNumber recordDataObject>
***********************************************************************
*/

METHODFUNC OBJECT *DB_Update( char *dbFileDescriptor, int recno, OBJECT *recDObj )
{
   char *record = (char *) recDObj->inst_var[0];
   
   _dbcerr = SUCCESS;

   if (!record || (record == (char *) o_nil))
      {
      _dbcerr = 4409;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
      
   if (dBupdr( dbFileDescriptor, (RECNUM) recno, record ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_Delete() [3.0] **********************************************
*
* NAME
*    DB_Delete()
*
* DESCRIPTION
*    Mark the given Record[ recordNumber ] as inactive (with '*').
*    ^ <primitive 209 6 11 private recordNumber>
***********************************************************************
*/

METHODFUNC OBJECT *DB_Delete( char *dbFileDescriptor, int recno )
{
   _dbcerr = SUCCESS;

   if (dBdelete( dbFileDescriptor, (RECNUM) recno ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_Remove() [3.0] **********************************************
*
* NAME
*    DB_Remove()
*
* DESCRIPTION
*    Physically delete the Record[ recordNumber ] from the DataBase
*    file.  Keep in mind that the dataBase will then contain two
*    copies of the last Record because this function simply shifts the
*    Records up by one index.
*    ^ <primitive 209 6 12 private recordNumber>
***********************************************************************
*/

METHODFUNC OBJECT *DB_Remove( char *dbFileDescriptor, int recno )
{
   _dbcerr = SUCCESS;

   if (dBrmvr( dbFileDescriptor, (RECNUM) recno ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_ReadTemplate() [3.0] ****************************************
*
* NAME
*    DB_ReadTemplate()
*
* DESCRIPTION
*    Open a .DBF file & read in the Record Field descriptors.
*    Create an instance of DBRecordTemplate & return it if all is okay,
*    otherwise return nil.
*    ^ <primitive 209 6 13 fileName templateName>
***********************************************************************
*/

METHODFUNC OBJECT *DB_CreateField( char *name, int type, int width, int decPlaces );

METHODFUNC OBJECT *DB_ReadTemplate( char *fileName, char *templateName )
{
   RECLEN  reclen   = 0;
   BYTE    month    = 0, day = 0, year = 0;
   FLDNUM  nofields = 0;
   long    dbfd     = 0L;
   OBJECT *rval     = o_nil;
   
   _dbcerr = SUCCESS;

   if (dBopen( fileName, (char **) &dbfd ) != SUCCESS)
      return( rval );

   if (dBgetf( (char *) dbfd, &reclen, 
               &month, &day, &year, &nofields, tempFields ) != SUCCESS)
      {
      goto exitDB_ReadTemplate;
      }
   else
      {
      OBJECT *newTemplate = o_nil;
      CLASS  *tempClass   = lookup_class( templateName ); // in CLDict.c
      CLASS  *tsuper      = (CLASS *) o_nil;
      int     i, inst_size = 0, offset = 0;

      if (NullChk( (OBJECT *) tempClass ) == TRUE)
         {
         sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_NO_CLDCT_DBASE ), templateName );
         
         UserInfo( ErrMsg, UserPgmError );

         goto exitDB_ReadTemplate;
         }

      // class->inst_vars is an Array OBJECT:

      inst_size = objSize( (OBJECT *) tempClass->inst_vars );

      if (inst_size != 4)
         {
         // DBRecordTemplate has to have four instance variables:

         sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_WRG_FMT_DBASE ), templateName );
         
         UserInfo( ErrMsg, UserPgmError );

         goto exitDB_ReadTemplate;
         }

      // Make a new DBRecordTemplate:
      newTemplate            = AssignObj( new_obj( tempClass, inst_size, FALSE ));

      // Make an instance of the Parent Class also:       
      tsuper                 = FindSuper( tempClass ); // In Global.c
      newTemplate->super_obj = new_inst( tsuper );     // In Class.c

      // Make the instance variables for DBRecordTemplate:
      newTemplate->inst_var[0] = AssignObj( new_array( nofields, FALSE ));
      newTemplate->inst_var[1] = AssignObj( new_int( reclen ));
      newTemplate->inst_var[2] = AssignObj( new_int( nofields ));
      newTemplate->inst_var[3] = AssignObj( new_array( nofields, FALSE ));

      (void) obj_inc( newTemplate );
      
      // Fill in DBField Objects into DBRecordTemplate:
      for (i = 0; i < nofields; i++)
         {
         OBJECT *flds = newTemplate->inst_var[0];
         OBJECT *offs = newTemplate->inst_var[3];
         
         OBJECT *newField = DB_CreateField( tempFields[i].fieldnm,
                                           tempFields[i].type,
                                           tempFields[i].width, 
                                           tempFields[i].dec 
                                         );

         if (NullChk( newField ) == TRUE)
            {
            MemoryOut( DBaseCMsg( MSG_DB_READTMP_FUNC_DBASE ) );
            
            goto exitDB_ReadTemplate;
            }

         flds->inst_var[i] = AssignObj( newField );
         offs->inst_var[i] = AssignObj( new_int( offset ) );

         offset += tempFields[i].width; // calculate next field offset.
         }
      
      rval = newTemplate;
      }

exitDB_ReadTemplate:

   if (dBclose( (char *) dbfd ) != SUCCESS) // gotta close what we opened!
      {
      sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_NO_CLOSE_DBASE ), fileName );
      
      UserInfo( ErrMsg, ATalkProblem );
      }

   return( rval );
}

/****h* HandleDBase() [3.0] *******************************************
*
* NAME
*    HandleDBase()
*
* DESCRIPTION
*    ^ <209 6 0 to 13 ??>
***********************************************************************
*/

PUBLIC OBJECT *HandleDBase( int numargs, OBJECT **args ) // <209 6 xx ??>
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // checkForMemosIn: recTemplate->inst_var[0] contains an Array of DBFldObjs
              // ^ <primitive 209 6 0 recTemplate>
         rval = DB_CheckForMemos( args[1] );
      
         break;      

      case 1: // create: dbFileName for: recTemplate
              // ^ <primitive 209 6 1 dbFileName numberOfFields recTemplate>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_CreateFile( string_value( (STRING *) args[1] ),
                                 int_value( args[2] ), args[3]
                               );
         break;
      
      case 2: // open: fileName for: recTemplate
              // ^ <primitive 209 6 2 dbFileName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_OpenFile( string_value( (STRING *) args[1] ) );

         break;

      case 3: // close
              // ^ <primitive 209 6 3 private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_CloseFile( (char *) int_value( args[1] ) );

         break;

      case 4: // getFileInformation: recTemplate
              // ^ <primitive 209 6 4 private recTemplate>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_GetFileInfo( (char *) int_value( args[1] ), args[2] );

         break;

      case 5: // write: [private] recordDataObject as: recordNumber [self]
              // ^ <primitive 209 6 5 private recordNumber recordDataObject self>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_PutRecord( (char *) int_value( args[1] ), 
                                         int_value( args[2] ),
                                                    args[3],
                                                    args[4] 
                              );
         break;

      case 6: // read: [private] recordNumber into: recordData [currentRecStatus]
              // ^ <primitive 209 6 6 private recordNumber recordData currentRecStatus>   
         if (!is_integer( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_ReadRecord( (char *) int_value( args[1] ),
                                          int_value( args[2] ),
                                                     args[3],
                                                     args[4]
                               );
         break;

      case 7: // DB_Flush()
              // ^ <primitive 209 6 7 private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_Flush( (char *) int_value( args[1] ) );

         break;

      case 8: // DB_Size()
              // ^ <primitive 209 6 8 private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_Size( (char *) int_value( args[1] ) );

         break;

      case 9: // DB_Recall()
              // ^ <primitive 209 6 9 private recordNumber>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_Recall( (char *) int_value( args[1] ),
                                      int_value( args[2] )
                           );
         break;

      case 10: // DB_Update()
               // ^ <primitive 209 6 10 private recordNumber recordData>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_Update( (char *) int_value( args[1] ),
                                      int_value( args[2] ),
                                                 args[3]
                           );
         break;

      case 11: // DB_Delete()
               // ^ <primitive 209 6 11 private recordNumber>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_Delete( (char *) int_value( args[1] ),
                                      int_value( args[2] )
                           );
         break;

      case 12: // DB_Remove()
               // ^ <primitive 209 6 12 private recordNumber>
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else 
            rval = DB_Remove( (char *) int_value( args[1] ),
                                      int_value( args[2] )
                           );
         break;

      case 13: // readTemplateFrom: fileName [templateName]
               // ^ <primitive 209 6 13 fileName templateName>
         if (!is_string( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 209 );         
         else
            rval = DB_ReadTemplate( string_value( (STRING *) args[1] ), 
                                   string_value( (STRING *) args[2] )
                                 );
         break;
         
      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

// ---- DBMemo methods: -----------------------------------------------

/****i* DB_MemoClose() [3.0] *******************************************
*
* NAME
*    DB_MemoClose()
*
* DESCRIPTION
*
*    ^ <primitive 209 7 0 private>
***********************************************************************
*/

METHODFUNC OBJECT *DB_MemoClose( char *dbtFileDescriptor )
{
   _dbcerr = SUCCESS;

   if (dBmclose( dbtFileDescriptor ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_MemoCreate() [3.0] ******************************************
*
* NAME
*    DB_MemoCreate()
*
* DESCRIPTION
*
*    ^ <primitive 209 7 1 memoFileName>
***********************************************************************
*/

METHODFUNC OBJECT *DB_MemoCreate( char *memoFileName )
{
   _dbcerr = SUCCESS;

   if (dBmcreat( memoFileName ) != SUCCESS)
      {
      FileCreateProblem( memoFileName, DBaseCMsg( MSG_DB_MCREAT_FUNC_DBASE ) );
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_MemoOpen() [3.0] ********************************************
*
* NAME
*    DB_MemoOpen()
*
* DESCRIPTION
*    ^ private <- <primitive 209 7 2 memoFileName>
***********************************************************************
*/

METHODFUNC OBJECT *DB_MemoOpen( char *memoFileName )
{
   char *dbtfiledescriptor = NULL;
   
   _dbcerr = SUCCESS;
   
   if (dBmopen( memoFileName, &dbtfiledescriptor ) != SUCCESS)
      {
      FileOpenProblem( memoFileName, DBaseCMsg( MSG_DB_MOPEN_FUNC_DBASE ) );
      
      return( o_nil );
      }
   else
      {
      return( AssignObj( new_int( (int) dbtfiledescriptor ) ) );
      }
}

/****i* DB_GetMemo() [3.0] *********************************************
*
* NAME
*    DB_GetMemo()
*
* DESCRIPTION
*    ^ <primitive 209 7 3 private memoNumber memoString>
*
* NOTES
*    memoNumber is a number-string that comes from dBputm()
***********************************************************************
*/

METHODFUNC OBJECT *DB_GetMemo( char *dbtFileDescriptor, char *field, char *memo )
{
   _dbcerr = SUCCESS;

   if (dBgetm( dbtFileDescriptor, field, memo ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_PutMemo() [3.0] *********************************************
*
* NAME
*    DB_PutMemo()
*
* DESCRIPTION
*    ^ <primitive 209 7 4 private memoString fieldNumber>
***********************************************************************
*/

METHODFUNC OBJECT *DB_PutMemo( char *dbtFileDescriptor, char *memo, char *field )
{
   _dbcerr = SUCCESS;

   if (dBputm( dbtFileDescriptor, memo, field ) != SUCCESS)
      {
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_SetMemoSize() [3.0] *****************************************
*
* NAME
*    DB_SetMemoSize()
*
* DESCRIPTION
*    <primitive 209 7 5 maximumSize>
***********************************************************************
*/

METHODFUNC void DB_SetMemoSize( unsigned int maxsize )
{
   _dbcmsiz = maxsize;

   return;
}

/****i* DB_GetMemoSize() [3.0] *****************************************
*
* NAME
*    DB_GetMemoSize()
*
* DESCRIPTION
*    ^ <primitive 209 7 6>
***********************************************************************
*/

METHODFUNC OBJECT *DB_GetMemoSize( void )
{
   return( AssignObj( new_int( _dbcmsiz ) ) );
}


/****h* HandleDBMemo() [3.0] ******************************************
*
* NAME
*    HandleDBMemo()
*
* DESCRIPTION
*    Interface AmigaTalk to dBC III functions that deal with memos.
***********************************************************************
*/

PUBLIC OBJECT *HandleDBMemo( int numargs, OBJECT **args ) // <209 7 xx ??>
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );
      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // closeFile [private]
              // ^ <primitive 209 7 0 private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_MemoClose( (char *) int_value( args[1] ) );
      
         break;      

      case 1: // createMemoFile: memoFileName
              // ^ <primitive 209 7 1 memoFileName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_MemoCreate( string_value( (STRING *) args[1] ) );

         break;      

      case 2: // openFile: memoFileName
              // ^ private <- <primitive 209 7 2 memoFileName>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_MemoOpen( string_value( (STRING *) args[1] ) );
      
         break;      

      case 3: // getMemoFrom: memoFileObj           /- fieldNumber
              // ^ <primitive 209 7 3 memoFileObj private myMemoContents>
         if (!is_integer( args[1] ) || !is_string( args[2] )
                                    || !is_string( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_GetMemo( (char *) int_value( args[1] ),
                              string_value( (STRING *) args[2] ),
                              string_value( (STRING *) args[3] )
                            );
         break;      

      case 4: // putMemo: memoString into: memoFileObj [private]
              // ^ <primitive 209 7 4 memoFileObj memoString fieldNumber>
         if (!is_integer( args[1] ) || !is_string( args[2] )
                                    || !is_string( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_PutMemo( (char *) int_value( args[1] ),
                              string_value( (STRING *) args[2] ),
                              string_value( (STRING *) args[3] )
                            );
         break;      

      case 5: // setMaximumMemoSizeTo: maximumSize
              //   <primitive 209 7 5 maximumSize>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            DB_SetMemoSize( (unsigned int) int_value( args[1] ) );

         break;      

      case 6: // getMaximumMemoSize
              // ^ <primitive 209 7 6>
         rval =  DB_GetMemoSize();
         break;

      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

// ---- DBIndex methods: ----------------------------------------------

/****i* DB_IndexCreate() [3.0] *****************************************
*
* NAME
*    DB_IndexCreate()
*
* DESCRIPTION
*    ^ <primitive 209 8 0 idxFileName keyExpr keyType>
***********************************************************************
*/

METHODFUNC OBJECT *DB_IndexCreate( char *idxFileName, char *keyExpr, int keyType )
{
   int keylen = 0;
   int len    = StringLength( keyExpr );
   
   _dbcerr = SUCCESS;

   switch (keyType)
      {
      case 'c': // Check for valid keyType specification:
      case 'C':
      case 'd':
      case 'D':
      case 'n':
      case 'N':
         break;
      
      default:
         _dbcerr = 1301;

         return( AssignObj( new_int( _dbcerr ) ) );
      }

   if (keyType == SMALL_C_CHAR || keyType == CAP_C_CHAR)
      {
      if (len < 1 || len > 100)
         {
         _dbcerr = 1304;

         return( AssignObj( new_int( _dbcerr ) ) );
         }
      else
         keylen = len;
      }
   else
      keylen = 8; // Dates & Numeric keys are only this length.

   if (dBicreat( idxFileName, keyExpr, keylen, keyType ) != SUCCESS)
      {
      FileCreateProblem( idxFileName, DBaseCMsg( MSG_DB_ICREAT_FUNC_DBASE ) );
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_IndexOpen() [3.0] *******************************************
*
* NAME
*    DB_IndexOpen()
*
* DESCRIPTION
*    ^ private <- <primitive 209 8 1 idxFileName> 
***********************************************************************
*/

METHODFUNC OBJECT *DB_IndexOpen( char *idxFileName )
{
   char *idxFileDescriptor = NULL;

   _dbcerr = SUCCESS;
   
   if (dBiopen( idxFileName, &idxFileDescriptor ) != SUCCESS)
      {
      FileOpenProblem( idxFileName, DBaseCMsg( MSG_DB_IOPEN_FUNC_DBASE ) );
      
      return( o_nil );
      }
   else
      return( AssignObj( new_int( (int) idxFileDescriptor ) ) );
}

/****i* DB_IndexClose() [3.0] ******************************************
*
* NAME
*    DB_IndexClose()
*
* DESCRIPTION
*    ^ <primitive 209 8 2 private>
***********************************************************************
*/

METHODFUNC OBJECT *DB_IndexClose( char *idxFileDescriptor )
{
   _dbcerr = SUCCESS;

   if (dBiclose( idxFileDescriptor ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_IndexFlush() [3.0] ******************************************
*
* NAME
*    DB_IndexFlush()
*
* DESCRIPTION
*    ^ <primitive 209 8 3 private>
***********************************************************************
*/

METHODFUNC OBJECT *DB_IndexFlush( char *idxFileDescriptor )
{
   _dbcerr = SUCCESS;

   if (dBiflsh( idxFileDescriptor ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_TranslateKey() [3.0] ****************************************
*
* NAME
*    DB_TranslateKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 4 private keyString>
***********************************************************************
*/

METHODFUNC OBJECT *DB_TranslateKey( char *idxFileDescriptor, char *key )
{
   RECNUM rval = 0;
    
   _dbcerr = SUCCESS;

   if (dBtkey( idxFileDescriptor, key, &rval ) != SUCCESS)
      {
      sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_TKEYFAIL_DBASE ), _dbcerr );
      
      UserInfo( ErrMsg, DBaseCMsg( MSG_DB_IDX_PROB_DBASE ) );

      return( o_nil );
      }
   else
      return( AssignObj( new_int( (int) rval ) ) );
}

/****i* DB_GetNextRecordIdx() [3.0] ************************************
*
* NAME
*    DB_GetNextRecordIdx()
*
* DESCRIPTION
*    ^ <primitive 209 8 5 keyFileObj private currentRecStatus recData>
***********************************************************************
*/

METHODFUNC OBJECT *DB_GetNextRecordIdx( char *idxFD, char *dbffd,
                                       OBJECT *statObj, 
                                       OBJECT *recData // DBData Object
                                     )
{
   char *record = string_value( (STRING *) recData->inst_var[0] );
   int   status = (int) CheckObject( statObj );
   char  stat[4];
      
   _dbcerr = SUCCESS;

   if (!record || record == (char *) o_nil)
      {
      _dbcerr = 4409;

      sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_GETNXT_DBASE ), _dbcerr );
      
      UserInfo( ErrMsg, DBaseCMsg( MSG_DB_IDX_PROB_DBASE ) );

      return( o_nil );
      }
      
   if (dBgetnr( dbffd, idxFD, record, &stat[0] ) != SUCCESS)
      {
      sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_GETNXT_DBASE ), _dbcerr );
      
      UserInfo( ErrMsg, DBaseCMsg( MSG_DB_IDX_PROB_DBASE ) );

      return( o_nil );
      }
   else
      {
      status = atoi( stat );

      obj_dec( statObj );

      statObj = AssignObj( new_int( status ) );
      
      return( recData );
      }
}

/****i* DB_GetPrevRecordIdx() [3.0] ************************************
*
* NAME
*    DB_GetPrevRecordIdx()
*
* DESCRIPTION
*    ^ <primitive 209 8 6 keyFileObj private currentrecStatus recData>
***********************************************************************
*/

METHODFUNC OBJECT *DB_GetPrevRecordIdx( char *idxFD, char *dbffd,
                                       OBJECT *statObj, 
                                       OBJECT *recData // DBData Object
                                     )
{
   char *record = string_value( (STRING *) recData->inst_var[0] );
   int   status = (int) CheckObject( statObj );
   char  stat[4];
      
   _dbcerr = SUCCESS;

   if (!record || record == (char *) o_nil)
      {
      _dbcerr = 4409;

      sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_GETPRV_DBASE ), _dbcerr );
      
      UserInfo( ErrMsg, DBaseCMsg( MSG_DB_IDX_PROB_DBASE ) );

      return( o_nil );
      }
      
   if (dBgetpr( dbffd, idxFD, record, &stat[0] ) != SUCCESS)
      {
      sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_GETPRV_DBASE ), _dbcerr );
      
      UserInfo( ErrMsg, DBaseCMsg( MSG_DB_IDX_PROB_DBASE ) );

      return( o_nil );
      }
   else
      {
      status = atoi( stat );

      obj_dec( statObj );

      statObj = AssignObj( new_int( status ) );
      
      return( recData );
      }
}

/****i* DB_ReadPrevKey() [3.0] *****************************************
*
* NAME
*    DB_ReadPrevKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 7 private keyString recNumber>
***********************************************************************
*/

METHODFUNC OBJECT *DB_ReadPrevKey( char   *idxFD, 
                                  char   *keyString,
                                  OBJECT *recNumObj
                                )
{
   RECNUM recnumber = (RECNUM) CheckObject( recNumObj );
   
   _dbcerr = SUCCESS;

   if (dBpkey( idxFD, keyString, (RECNUM *) &recnumber ) != SUCCESS)
      {
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else
      {
      OBJECT *tobj = recNumObj;
      
      recNumObj = AssignObj( new_int( recnumber ) );
      
      obj_dec( tobj );
      
      return( AssignObj( new_int( 0 ) ) );
      }
}

/****i* DB_ReadNextKey() [3.0] *****************************************
*
* NAME
*    DB_ReadNextKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 8 private keyString recNumber>
***********************************************************************
*/

METHODFUNC OBJECT *DB_ReadNextKey( char   *idxFD, 
                                  char   *keyString,
                                  OBJECT *recNumObj
                                )
{
   RECNUM recnumber = (RECNUM) CheckObject( recNumObj );
   
   _dbcerr = SUCCESS;

   if (dBnkey( idxFD, keyString, (RECNUM *) &recnumber ) != SUCCESS)
      {
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else
      {
      OBJECT *tobj = recNumObj;
      
      recNumObj = AssignObj( new_int( recnumber ) );
      
      obj_dec( tobj );
      
      return( AssignObj( new_int( 0 ) ) );
      }
}

/****i* DB_RemoveKey() [3.0] *******************************************
*
* NAME
*    DB_RemoveKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 9 private keyString recNumber>
***********************************************************************
*/

METHODFUNC OBJECT *DB_RemoveKey( char *idxFD, char *key, OBJECT *recNumObj )
{
   RECNUM recnum = (RECNUM) CheckObject( recNumObj );
   
   _dbcerr = SUCCESS;

   if (dBrmvkey( idxFD, key, recnum ) != SUCCESS)
      {
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   else
      {
      obj_dec( recNumObj );

      return( AssignObj( new_int( 0 ) ) );
      }
}

/****i* DB_ForwardToEOF() [3.0] ****************************************
*
* NAME
*    DB_ForwardToEOF()
*
* DESCRIPTION
*    ^ <primitive 209 8 10 private>
***********************************************************************
*/

METHODFUNC OBJECT *DB_ForwardToEOF( char *idxFileDescriptor )
{
   _dbcerr = SUCCESS;

   if (dBfwd( idxFileDescriptor ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else   
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_AddKey() [3.0] **********************************************
*
* NAME
*    DB_AddKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 11 private keyString recordNumber>
***********************************************************************
*/

METHODFUNC OBJECT *DB_AddKey( char *idxFileDescriptor, char *key, int recno )
{
   _dbcerr = SUCCESS;

   if (dBakey( idxFileDescriptor, key, (RECNUM) recno ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else   
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_ConvASCIIToKey() [3.0] **************************************
*
* NAME
*    DB_ConvASCIIToKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 12 numberString keyString keyType>
***********************************************************************
*/

METHODFUNC OBJECT *DB_ConvASCIIToKey( char *ascii, char *keyString, int kt )
{
   int size = StringLength( keyString );
   
   _dbcerr = SUCCESS;

   if (size < 8)
      {
      _dbcerr = 116;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
      
   switch (kt)
      {
      case SMALL_D_CHAR:
      case SMALL_N_CHAR:
      case CAP_D_CHAR:
      case CAP_N_CHAR:
         keyString[0] = (BYTE) (kt & 0x5F); // Convert to Uppercase 

         break;
         
      default:
         _dbcerr = 1301;

         return( AssignObj( new_int( _dbcerr ) ) );
      }
      
   if (dBatokey( ascii, keyString ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else   
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_ConvKeyToASCII() [3.0] **************************************
*
* NAME
*    DB_ConvKeyToASCII()
*
* DESCRIPTION
*    ^ <primitive 209 8 13 numberString keyString keyType>
***********************************************************************
*/

METHODFUNC OBJECT *DB_ConvKeyToASCII( char *ascii, char *keyString, int kt )
{
   int size  = StringLength( keyString );
//   int first = (int) ascii[0];
      
   _dbcerr = SUCCESS;

   if (size < 8)
      {
      _dbcerr = 116;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
   
   switch (kt)
      {
      case SMALL_D_CHAR:
      case CAP_D_CHAR:
         ascii[1] = (BYTE) (kt & 0x5F); // Convert to Uppercase

         break;

      case SMALL_N_CHAR:
      case CAP_N_CHAR:
         ascii[1] = (BYTE) (kt & 0x5F); // Convert to Uppercase

         // Now check for a valid key length specifier:      
         if (ascii[0] > 60) // first < 0 || first > 60)
            {
            _dbcerr = 116;
       
            return( AssignObj( new_int( _dbcerr ) ) );
            }

         break;
         
      default:
         _dbcerr = 1301;

         return( AssignObj( new_int( _dbcerr ) ) );
      }
      
   if (dBkeytoa( keyString, ascii ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else   
      return( AssignObj( new_int( 0 ) ) );
}

// For DB_GetRecordByKey() only:

SUBFUNC OBJECT *FaileddBgetrk( void )
{
   sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_GETREC_DBASE ), _dbcerr );
      
   UserInfo( ErrMsg, DBaseCMsg( MSG_DB_IDX_PROB_DBASE ) );
   
   return( o_nil );
}

/****i* DB_GetRecordByKey() [3.0] **************************************
*
* NAME
*    DB_GetRecordByKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 14 keyFileObj private keyStr recData currentRecStatus>
***********************************************************************
*
*/

METHODFUNC OBJECT *DB_GetRecordByKey( char   *idxFileDescriptor, 
                                     char   *dbffd,
                                     char   *key,     // Ordinary String 
                                     OBJECT *recData, // DBData Object
                                     OBJECT *statObj 
                                   )
{
   int     status   = (int) CheckObject( statObj );
   char   *record   = string_value( (STRING *) recData->inst_var[0] );
   char    stat[4], kt, keyString[80] = { 0, };
   int     kxprlen  = 0, i;
   KEYLEN  keylen   = 0;
   OBJECT *keyObj   = o_nil;
         
   _dbcerr = SUCCESS;

   if (!record || record == (char *) o_nil)
      {
      _dbcerr = 4409;

      return( FaileddBgetrk() );       
      }

   // First we have to convert key into a keyString for dBgetrk(): ----

   // kxprlen S/B char *, not int *!!
   // Get a value for kt (keyType):
   (void) dBkexpr( idxFileDescriptor, &kt, keyString, &kxprlen, &keylen );

   for (i = 0; i < 8; i++)
      keyString[i] = SPACE_CHAR; // Don't need keyexpr
   
   keyString[8] = NIL_CHAR;   // Only need 8 spaces for DB_ConvASCIIToKey().
   
   keyObj = DB_ConvASCIIToKey( key, keyString, kt ); // Change key into keyString

   if (int_value( keyObj ) != 0) // Error in DB_ConvASCIIToKey()
      return( FaileddBgetrk() );       
   else
      obj_dec( keyObj ); // keyObj was temporary, adjust ref_count.
      
   // -----------------------------------------------------------------

   if (dBgetrk( dbffd, idxFileDescriptor, keyString, record, &stat[0] ) != SUCCESS)
      {
      return( FaileddBgetrk() );       
      }
   else
      {
      OBJECT *tobj = statObj;
      
      status  = atoi( stat );

      statObj = AssignObj( new_int( status ) );

      obj_dec( tobj );
      
      return( recData );
      }
}

/****i* DB_PutRecordByKey() [3.0] **************************************
*
* NAME
*    DB_PutRecordByKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 15 keyFileObj private keyStr recData>
***********************************************************************
*
*/

METHODFUNC OBJECT *DB_PutRecordByKey( char   *idxFileDescriptor,
                                     char   *dbffd, 
                                     char   *key, 
                                     OBJECT *recData // DBData Object 
                                   )
{
   char *record = string_value( (STRING *) recData->inst_var[0] );
      
   _dbcerr = SUCCESS;

   if (!record || record == (char *) o_nil)
      {
      _dbcerr = 4409;
      
      return( AssignObj( new_int( _dbcerr ) ) );
      }
      
   if (dBputrk( dbffd, idxFileDescriptor, key, record ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else   
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_KeyExpression() [3.0] ***************************************
*
* NAME
*    DB_KeyExpression()
*
* DESCRIPTION
*    ^ <primitive 209 8 16 private keyString>
***********************************************************************
*/

METHODFUNC OBJECT *DB_KeyExpression( char *idxFileDescriptor, char *keyExpr )
{
   KEYLEN keylen   = 0;
   int    kexprlen = 0; // S/B char *, NOT int *
   char   keyType[2];
   
   _dbcerr = SUCCESS;

   if (dBkexpr( idxFileDescriptor, keyType, keyExpr, &kexprlen, &keylen ) != SUCCESS)
      {
      sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_READKEY_DBASE ), _dbcerr );
      
      UserInfo( ErrMsg, DBaseCMsg( MSG_DB_IDX_PROB_DBASE ) );

      return( o_nil );
      }
   else
      {
      switch (keyType[0]) 
         {
         case CAP_C_CHAR:
         case SMALL_C_CHAR:
            return( new_int( 0x43 ) ); // return 'C'
         
         case CAP_N_CHAR:
         case SMALL_N_CHAR: // FALL THROUGH

         case CAP_D_CHAR: // these should never occur
         case SMALL_D_CHAR:

         default:

            return( new_int( 0x4E ) ); // return 'N'
         }
      }
}

/****i* DB_CurrentKey() [3.0] ******************************************
*
* NAME
*    DB_CurrentKey()
*
* DESCRIPTION
*    ^ <primitive 209 8 17 private keyString recNumber>
***********************************************************************
*
*/

METHODFUNC OBJECT *DB_CurrentKey( char   *idxFileDescriptor, 
                                 char   *key, 
                                 OBJECT *recNumObj
                               )
{
   RECNUM recno = 0;
   
   _dbcerr = SUCCESS;

   if (dBckey( idxFileDescriptor, key, &recno ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      {
      OBJECT *tobj = recNumObj;
      
      recNumObj = AssignObj( new_int( recno ) );

      obj_dec( tobj );
      
      return( AssignObj( new_int( 0 ) ) );
      }
}

/****i* DB_Rewind() [3.0] **********************************************
*
* NAME
*    DB_Rewind()
*
* DESCRIPTION
*    ^ <primitive 209 8 18 private>
***********************************************************************
*/

METHODFUNC OBJECT *DB_Rewind( char *idxFileDescriptor )
{
   _dbcerr = SUCCESS;

   if (dBrewind( idxFileDescriptor ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else   
      return( AssignObj( new_int( 0 ) ) );
}

/****h* HandleDBIndex() [3.0] *****************************************
*
* NAME
*    HandleDBIndex()
*
* DESCRIPTION
*    Handle dBC III index file functions to AmigaTalk primitives.
*    ^ <primitive 209 8 0-18 ??>
***********************************************************************
*/

PUBLIC OBJECT *HandleDBIndex( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // createFile: indexFileName with: keyExpression ofType: keyTypeChar
              // ^ <primitive 209 8 0 idxFileName keyExpr keyType>
         if (!is_string( args[1] ) || !is_string( args[2] ) 
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_IndexCreate( string_value( (STRING *) args[1] ),
                                  string_value( (STRING *) args[2] ),
                                     int_value( args[3] ) & 0xFF 
                                );
         break;

      case 1: // openFile: indexFileName "private is an Integer (char *)"
              // ^ private <- <primitive 209 8 1 idxFileName> 
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_IndexOpen( string_value( (STRING *) args[1] ) );

         break;

      case 2: // closeFile [private]
              // ^ <primitive 209 8 2 private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_IndexClose( (char *) int_value( args[1] ) );

         break;

      case 3: // flushFile [private]
              // ^ <primitive 209 8 3 private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_IndexFlush( (char *) int_value( args[1] ) );

         break;
 
      case 4: // keyToRecordNumber: [private] keyString 
              // ^ <primitive 209 8 4 private keyString>
         if (!is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_TranslateKey( (char *) int_value( args[1] ),
                                         string_value( (STRING *) args[2] )
                                 );
         break;

      case 5: // getNextRecord: [private] dbFileObject [private2] from: recDBData
              // ^ <primitive 209 8 5 private dbFileObject private2 recData>
         if (!is_integer( args[1] ) || !is_integer( args[2] )
                                    || !is_string( args[4] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_GetNextRecordIdx( (char *) int_value( args[1] ),
                                       (char *) int_value( args[2] ),
                                       args[3], args[4]
                                     );
         break;

      case 6: // getPrevRecord: [private] dbFileObject [private2] from: recDBData
              // ^ <primitive 209 8 6 private dbFileObject private2 recData>
         if (!is_integer( args[1] ) || !is_integer( args[2] )
                                    || !is_string( args[4] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_GetPrevRecordIdx( (char *) int_value( args[1] ),
                                       (char *) int_value( args[2] ),
                                       args[3], args[4]
                                     );
         break;

      case 7: // readPrevKeyInto: [private] keyString for: recNumber
              // ^ <primitive 209 8 7 private keyString recNumber>
         if (!is_integer( args[1] ) || !is_string( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_ReadPrevKey( (char *) int_value( args[1] ),
                                  string_value( (STRING *) args[2] ),
                                                           args[3]
                                );
         break;

      case 8: // readNextKeyInto: [private] keyString for: recNumber
              // ^ <primitive 209 8 8 private keyString recNumber>
         if (!is_integer( args[1] ) || !is_string( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_ReadNextKey( (char *) int_value( args[1] ),
                                  string_value( (STRING *) args[2] ),
                                                           args[3]
                                );
         break;

      case 9: // removeKey: [private] keyString for: recNumber
              // ^ <primitive 209 8 9 private keyString recNumber>
         if (!is_integer( args[1] ) || !is_string( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_RemoveKey( (char *) int_value(            args[1] ),
                                      string_value( (STRING *) args[2] ),
                                                               args[3]
                              );
         break;

      case 10: // forwardToEOF [private] 
               // ^ <primitive 209 8 10 private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_ForwardToEOF( (char *) int_value( args[1] ) );

         break;

      case 11: // addKey: [private] newKey  for: recordNumber
               // ^ <primitive 209 8 11 private newKey recordNumber>
         if (!is_integer( args[1] ) || !is_string( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_AddKey( (char *) int_value( args[1] ),
                                      string_value( (STRING *) args[2] ),
                                         int_value( args[3] )
                           );
         break; 

      case 12: // convertASCII: numberString toKey: keyStr keyType: kt
               // ^ <primitive 209 8 12 numberString keyString keyType>
         if (!is_string( args[1] ) || !is_string( args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_ConvASCIIToKey( string_value( (STRING *) args[1] ),
                                     string_value( (STRING *) args[2] ),
                                        int_value( args[3] )
                                   );
         break;

      case 13: // convertKey: keyString toASCII: numberString keyType: kt
               // ^ <primitive 209 8 13 numberString keyString keyType>
         if (!is_string( args[1] ) || !is_string( args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_ConvKeyToASCII( string_value( (STRING *) args[1] ),
                                     string_value( (STRING *) args[2] ),
                                        int_value( args[3] )
                                   );
         break;

      case 14: // getRecordBy: keyString from: keyFileObj for: recordData
               // ^ <primitive 209 8 14 keyFileObj private keyString
               //                       recData currentRecStatus>
         if (!is_integer( args[2] ) || !is_string( args[3] )
                                    || !is_integer( args[5] ))
            (void) PrintArgTypeError( 209 );
         else
            {
            OBJECT *dbifd = args[1]->inst_var[0];
                
            rval = DB_GetRecordByKey( (char *) int_value( dbifd   ), // ndxfd
                                     (char *) int_value( args[2] ), // dbffd
                                     string_value( (STRING *) args[3] ), 
                                      args[4], args[5]
                                   );
            }
         break;

      case 15: // putRecordTo: recData using: keyStr from: keyFileObj
               // ^ <primitive 209 8 15 keyFileObj private keyString recData>
               
               // recData might have to be changed to String later:

         if (!is_integer( args[2] ) || !is_string( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            {
            OBJECT *dbifd = args[1]->inst_var[0];
            
            rval = DB_PutRecordByKey( (char *) int_value( dbifd   ), // ndxfd
                                     (char *) int_value( args[2] ), // dbffd
                                     string_value( (STRING *) args[3] ), 
                                                              args[4]
                                   );
            }
         break;
 
      case 16: // readKeyExpressionInto: [private] keyString
               // ^ <primitive 209 8 15 private keyString>
         if (!is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_KeyExpression( (char *) int_value( args[1] ), 
                                    string_value( (STRING *) args[2] )
                                  );

         break;

      case 17: // readCurrentKeyInto: [private] keyString [private3]
               // ^ <primitive 209 8 17 private keyString private3>
         if (!is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_CurrentKey( (char *) int_value( args[1] ),
                                       string_value( (STRING *) args[2] ), 
                                                                args[3]
                               );
         break;

      case 18: // rewindFile [private]
               // ^ <primitive 209 8 18 private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_Rewind( (char *) int_value( args[1] ) );

         break;      

      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

// ---- DBField methods: ----------------------------------------------

/****i* DB_CreateField() [3.0] *****************************************
*
* NAME
*    DB_CreateField()
*
* DESCRIPTION
*    ^ <primitive 209 9 0 fieldName type width decimalPlaces>
***********************************************************************
*/

METHODFUNC OBJECT *DB_CreateField( char *name, int type, int width, int decPlaces )
{
   dBFIELD *newFld = (dBFIELD *) AT_AllocVec( sizeof( dBFIELD ), 
                                              MEMF_CLEAR | MEMF_ANY, 
                                              "dbField", TRUE 
                                            );

   _dbcerr = SUCCESS;

   if (!newFld) // == NULL)
      {
      _dbcerr = 114;
      
      MemoryOut( DBaseCMsg( MSG_DB_CREATF_FUNC_DBASE ) );
      
      return( o_nil );
      }
      
   if (StringLength( name ) > 10)
      {
      _dbcerr = 103;

      sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_CREAT_DBASE ), _dbcerr );

      UserInfo( ErrMsg, UserPgmError );

      AT_FreeVec( newFld, "newField", TRUE );

      return( o_nil );
      }

   switch (type & 0xFF)
      {
      case SMALL_C_CHAR: // Character
      case SMALL_N_CHAR: // Numeric
      case SMALL_D_CHAR: // Date
      case SMALL_L_CHAR: // Logical
      case SMALL_M_CHAR: // Memo

         type -= 0x20; // Convert to Uppercase.

         // FALLTHROUGH:

      case CAP_C_CHAR:
      case CAP_N_CHAR:
      case CAP_D_CHAR:
      case CAP_L_CHAR:
      case CAP_M_CHAR:
         newFld->type = (char) type & 0xFF;
         break;
         
      default:
         sprintf( ErrMsg, DBaseCMsg( MSG_FMT_DB_UNKTYPE_DBASE ), type );
         
         UserInfo( ErrMsg, UserPgmError );
         
         newFld->type = CAP_C_CHAR;
         break;
      }

   StringNCopy( newFld->fieldnm, name, 10 );

   newFld->width = (FLDWIDTH) (width == 0) ? 1 : width;
   newFld->dec   = (FLDDEC)   decPlaces;
   
   return( AssignObj( new_int( (int) newFld ) ) );
}

/****i* DB_FormatString() [3.0] ****************************************
*
* NAME
*    DB_FormatString()
*
* DESCRIPTION
*    ^ <primitive 209 9 1 aString leftOrRightChar length>
***********************************************************************
*/

METHODFUNC OBJECT *DB_FormatString( char *inString, char mode, int length )
{
   char   *newStr = NULL;
   OBJECT *rval   = o_nil;
      
   _dbcerr = SUCCESS;

   if (length < 1)
      {
      return( rval );
      }
   
   newStr = (char *) AT_AllocVec( (length + 1) * sizeof( BYTE ), 
                                  MEMF_CLEAR | MEMF_ANY, 
                                  "dbFormatString", TRUE 
                                );
   
   if (!newStr) // == NULL)
      {
      return( rval );
      }
      
   if (mode == SMALL_R_CHAR || mode == CAP_R_CHAR)
      mode = CAP_R_CHAR;
   else
      mode = CAP_L_CHAR; // Use the default (LEFT) mode.
      
   dBstrcpy( newStr, mode, length, inString );
   
   rval = AssignObj( new_int( (int) newStr ) );
   
   return( rval );
}

/****i* DB_DisposeString() [3.0] ***************************************
*
* NAME
*    DB_DisposeString()
*
* DESCRIPTION
*    <primitive 209 9 2 private>
***********************************************************************
*/

METHODFUNC void DB_DisposeString( OBJECT *fieldStrObj )
{
   char *fStr = (char *) int_value( fieldStrObj );
   
   _dbcerr = SUCCESS;

   if (fStr) // != NULL)
      {
      AT_FreeVec( fStr, "dbFieldString", TRUE );
      
      return;
      }
   
   _dbcerr = 4408; // My additional error number.

   return;
}

/****i* DB_LastError() [3.0] *******************************************
*
* NAME
*    DB_LastError()
*
* DESCRIPTION
*    ^ <primitive 209 9 3>
***********************************************************************
*/

METHODFUNC OBJECT *DB_LastError( void )
{
   return( AssignObj( new_int( _dbcerr ) ) );
}

/****i* DB_AsciiToField() [3.0] ****************************************
*
* NAME
*    DB_AsciiToField()
*
* DESCRIPTION
*    ^ <primitive 209 9 4 inStr fieldOutput width decimal>
***********************************************************************
*/

METHODFUNC OBJECT *DB_AsciiToField( char *inStr, char *field, int width, int decimal )
{
   _dbcerr = SUCCESS;

   if (dBatofld( inStr, width, decimal, field ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* DB_FieldToAscii() [3.0] ****************************************
*
* NAME
*    DB_FieldToAscii()
*
* DESCRIPTION
*    ^ <primitive 209 9 5 inStr width floatString>
***********************************************************************
*/

METHODFUNC OBJECT *DB_FieldToAscii( char *inStr, int width, char *outStr )
{
   _dbcerr = SUCCESS;

   if (dBfldtoa( inStr, width, outStr ) != SUCCESS)
      return( AssignObj( new_int( _dbcerr ) ) );
   else
      return( AssignObj( new_int( 0 ) ) );
}

/****i* StrToByteArray() [3.0] ****************************************
*
* NAME
*    StrToByteArray()
*
* DESCRIPTION
*    This primitive is in Class String.
*    ^ <primitive 209 9 6 inStr>
***********************************************************************
*/

METHODFUNC OBJECT *StrToByteArray( char *inStr )
{
   int len = StringLength( inStr );
   
   if (len < 1)
      return( o_nil );
      
   return( AssignObj( new_bytearray( inStr, len ) ) );
}

/****i* ModifyDataString() [3.0] ****************************************
*
* NAME
*    ModifyDataString()
*
* DESCRIPTION
*    modifyWith: dataString at: offset length: length
*    <primitive 209 9 7 private dataString offset length>
***********************************************************************
*/

METHODFUNC void ModifyDataString( char *output, char *buffer, 
                                  int   offset, int   length
                                )
{
   int i, j;

   for (i = offset, j = 0; i < (length + offset); i++, j++)
      *(output + i) = *(buffer + j);
      
   return;
}

/****i* FSValue() [3.0] ***********************************************
*
* NAME
*    FSValue()
*
* DESCRIPTION
*    value
*    ^ <primitive 209 9 8 private>
***********************************************************************
*/

METHODFUNC OBJECT *FSValue( OBJECT *privObj )
{
   char *string = (char *) CheckObject( privObj );

   return( AssignObj( new_str( string ) ) );   
}

/****i* ResetDataString() [3.0] ***************************************
*
* NAME
*    ResetDataString()
*
* DESCRIPTION
*    reset [theData mySize]
*    <primitive 209 9 9 theData mySize>
***********************************************************************
*/

METHODFUNC void ResetDataString( char *theData, int mySize )
{
   int   i;

   for (i = 0; i < mySize; i++)
      *(theData + i) = SPACE_CHAR;
      
   return;
}

/****i* RetrieveFieldString() [3.0] ***********************************
*
* NAME
*    RetrieveFieldString()
*
* DESCRIPTION
*    retrieveFieldAt: [theData] offset length: length
*    <primitive 209 9 10 theData offset length>
***********************************************************************
*/

PRIVATE char tRTS[256] = { 0, }; // This is a real kludge!!

METHODFUNC OBJECT *RetrieveFieldString( char *theData, 
                                        int   offset, int length
                                      )
{
   OBJECT *rval = o_nil;
   int     i, j;

   _dbcerr = SUCCESS;

   if ((length < 1) || (length > 254))
      {
      _dbcerr = 105; // length out of range!!
      
      return( rval );
      }

   for (i = 0; i < 256; i++)
      tRTS[i] = NIL_CHAR;        // Re-initialize the temporary buffer space.
            
   for (i = offset, j = 0; j < length; i++, j++)
      tRTS[j] = *(theData + i);
      
   return( AssignObj( new_str( &tRTS[0] ) ) );
}

/****i* ByteArrayToStr() [3.0] ****************************************
*
* NAME
*    ByteArrayToStr()
*
* DESCRIPTION
*    This primitive is used only in Class ByteArray.
*    ^ <primitive 209 9 11 byteArray>
***********************************************************************
*/

METHODFUNC OBJECT *ByteArrayToStr( BYTEARRAY *inBytes )
{
   OBJECT *rval = o_nil;
   char   *tstr = NULL;
   int     len  = inBytes->bsize, i;
   
   if (len < 1)
      return( rval );

   if (!(tstr = (char *) AT_AllocVec( len + 1, MEMF_ANY | MEMF_CLEAR,
                                      "dbString", TRUE ))) // == NULL)
      {
      sprintf( ErrMsg, DBaseCMsg( MSG_DB_NO_209SPC_DBASE ), len + 1 );

      UserInfo( ErrMsg, AllocProblem );

      return( rval );
      }

   for (i = 0; i < len; i++)
      {
      if (inBytes->bytes[i] < 32)
         {
         switch (inBytes->bytes[i])
            {
            case 9:  // Tab
               *(tstr + i) = SPACE_CHAR;
               break;
               
            case 10: // newline
               *(tstr + i) = NEWLINE_CHAR;
               break;

            default:
               *(tstr + i) = PERIOD_CHAR;
               break;
            }
         }
      else if (inBytes->bytes[i] >= 32 && inBytes->bytes[i] < 0x7F)
         {
         *(tstr + i) = inBytes->bytes[i];
         } 
      else
         *(tstr + i) = PERIOD_CHAR;
      }            

   rval = AssignObj( new_str( tstr ) );
   
   if (tstr != NULL)
      AT_FreeVec( tstr, "dbString", TRUE );
   
   return( rval );
}

/****h* HandleDBField() [3.0] *****************************************
*
* NAME
*    HandleDBField()
*
* DESCRIPTION
*    <primitive 209 9 0-11 ??>
***********************************************************************
*/

PUBLIC OBJECT *HandleDBField( int numargs, OBJECT **args ) // <209 9 xx ??>
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // create: fieldName type: t width: w decimalPlaces: d
              // ^ <primitive 209 9 0 fieldName type width decimalPlaces>
         if (!is_string( args[1] ) || !is_character( args[2] )
                                   || !is_integer( args[3] )
                                   || !is_integer( args[4] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_CreateField( string_value( (STRING *) args[1] ),
                                  (int) char_value( args[2] ),
                                  int_value( args[3] ),
                                  int_value( args[4] )
                                );
         break;      

      case 1: // formatStringToField: aString to: length adjMode: leftOrRightChar
              // ^ <primitive 209 9 1 aString leftOrRightChar length>
         if (!is_string( args[1] ) || !is_character( args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_FormatString( string_value( (STRING *) args[1] ),
                                     char_value( args[2] ), 
                                      int_value( args[3] )
                                 );
         break;      

      case 2: // dispose
              //   <primitive 209 9 2 private>
         DB_DisposeString( args[1] );
      
         break;      

      case 3: // lastErrorNumber
              // ^ <primitive 209 9 3>
         rval = DB_LastError();
         break;      

      case 4: // ascii: aFloatString toField: fieldString width: w decimalPlaces: d
              // ^ <primitive 209 9 4 inStr field width decimal>
         if (!is_string( args[1] ) || !is_string( args[2] )
                                   || !is_integer( args[3] )
                                   || !is_integer( args[4] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_AsciiToField( string_value( (STRING *) args[1] ),
                                   string_value( (STRING *) args[2] ),
                                      int_value( args[3] ),
                                      int_value( args[4] )
                                 );
         break;      

      case 5: // field: aFieldString toASCII: floatString width: w
              // ^ <primitive 209 9 5 aFieldString w floatString>
         if (!is_string( args[1] ) || !is_integer( args[2] )
                                   || !is_string(  args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = DB_FieldToAscii( string_value( (STRING *) args[1] ),
                                      int_value(            args[2] ),
                                   string_value( (STRING *) args[3] )
                                 );
         break;      

      case 6: // asByteArray: inString
              // ^ <primitive 209 9 6 inString>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = StrToByteArray( string_value( (STRING *) args[1] ) );
         
         break;     

      case 7: // modifyWith: dataString at: offset length: length
              // <primitive 209 9 7 theData dataString offset length>
         if (!is_string( args[1] ) || !is_string( args[2] ) 
                                   || !is_integer( args[3] )
                                   || !is_integer( args[4] ))
            (void) PrintArgTypeError( 209 );
         else
            ModifyDataString( string_value( (STRING *) args[1] ),
                              string_value( (STRING *) args[2] ),
                                 int_value( args[3] ),
                                 int_value( args[4] )
                            );
         break;     

      case 8: // value ^ <primitive 209 9 8 private>
         rval = FSValue( args[1] );
         
         break;
                 
      case 9: // reset [theData mySize]  <primitive 209 9 9 theData mySize>
         if (!is_string( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            ResetDataString( string_value( (STRING *) args[1] ),
                                int_value( args[2] )
                           );
         break;     

      case 10: // retrieveFieldAt: [theData] offset length: length
               // ^ <primitive 209 9 10 theData offset length>
         if (!is_string( args[1] ) || !is_integer( args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = RetrieveFieldString( string_value( (STRING *) args[1] ),
                                           int_value( args[2] ),
                                           int_value( args[3] )
                                      );
         break;     

      case 11: // printAsChars (ByteArray.st)
               // ^ <primitive 209 9 11 byteArray>
         if (is_bytearray( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = ByteArrayToStr( (BYTEARRAY *) args[1] );
         
         break;
            
      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

/****i* DisplayMsg() [3.0] ********************************************
*
* NAME
*    DisplayMsg()
*
* DESCRIPTION
*    breakPoint: msgString
*    ^ <primitive 209 10 0 msgString>
***********************************************************************
*/

METHODFUNC OBJECT *DisplayMsg( char *msgString )
{
   IMPORT void DebugBreak( void ); // In Main.c file
   
   OBJECT *rval = o_nil;
   
   UserInfo( msgString, DBaseCMsg( MSG_DB_BREAK_PNT_DBASE ) );

   DebugBreak();
   
   return( rval );  
}

/****h* ObjectPrims() [3.0] *******************************************
*
* NAME
*    ObjectPrims()
*
* DESCRIPTION
*    Miscellaneous Object Primitives.
*
*    <primitive 209 10 0 ??>
***********************************************************************
*/

PUBLIC OBJECT *ObjectPrims( int numargs, OBJECT **args ) // <209 10 xx ??>
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // breakPoint: msgString
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = DisplayMsg( string_value( (STRING *) args[1] ) );

         break;

      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );

}
    
/* ---------------------- END of DBase.c file! --------------------- */
