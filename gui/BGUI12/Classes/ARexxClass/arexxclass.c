/*
**             File: arexxclass.c
**      Description: BOOPSI ARexx interface class.
**        Copyright: (C) Copyright 1994-1995 Jaba Development.
**                   (C) Copyright 1994-1995 Jan van den Baard.
**                   All Rights Reserved.
**/

/*
**      Uncomment the following line if you want the
**      class to use memory pools and you have got
**      the 3.1 amiga.lib. You need the 3.1 amiga.lib
**      because the earlier version do not contain
**      link versions of the pool routines.
**/

/* #define POOLS */

/*
**      When POOLS is defined the class will
**      use the allocation routines as defined
**      in the source. Otherwise it simply
**      allocates memory from the system pool.
**/
#ifdef POOLS
#define AllocMemory(s)          GetMem( ad, s )
#define FreeMemory(p)           PutMem( ad, p )
#else
#define AllocMemory(s)          AllocVec( s, MEMF_PUBLIC | MEMF_CLEAR )
#define FreeMemory(p)           FreeVec( p )
#endif

/*
**      Include necessary headers.
**/
#include "ARexxClass.h"

#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/rexxsyslib.h>
#include <proto/exec.h>
#include <proto/dos.h>

#include <clib/alib_protos.h>

#include <stdio.h>
#include <string.h>
#include <ctype.h>

/*
**      Compiler crap. Should compile under SAS this way...
**/
#ifdef _DCC
#define SAVEDS __geta4
#define ASM
#define REG(x) __ ## x
#else
#define SAVEDS __saveds
#define ASM __asm
#define REG(x) register __ ## x
#endif

/*
**      Object instance data. Every object
**      created from this class has this
**      data.
**/
typedef struct {
        struct MsgPort                  *ad_Port;       /* Host message port.         */
        UBYTE                           *ad_HostName;   /* Host name.                 */
        UBYTE                           *ad_FileExt;    /* File extention.            */
        ULONG                            ad_PendCnt;    /* Messages still un-reply'd. */
        REXXCOMMAND                     *ad_Commands;   /* Host command list.         */
        struct RDArgs                   *ad_DOSParser;  /* ReadArgs() parser.         */
        UWORD                            ad_Flags;      /* See below.                 */
#ifdef POOLS
        APTR                             ad_MemPool;    /* Memory pool.               */
#endif
} AD;

/*
**      Static module prototypes of functions
**      defined after they are referenced.
**/
STATIC ULONG SAVEDS ASM ARexxDispatch( REG(A0) Class *cl, REG(A2) Object *obj, REG(A1) Msg );

/*
**      Class initialization. Simply creates the
**      class and set's up the dispatcher.
**/
Class *InitARexxClass( void )
{
        Class                   *cl;

        if ( cl = MakeClass( NULL, ROOTCLASS, NULL, sizeof( AD ), 0L ))
                cl->cl_Dispatcher.h_Entry = (HOOKFUNC)ARexxDispatch;

        return( cl );
}

/*
**      Free the class. A simply FreeClass()
**      would suffice but in the future this
**      may do more.
**/
BOOL FreeARexxClass( Class *cl )
{
        return( FreeClass( cl ));
}

/*
**      These routines are only compiled when
**      POOLS is defined. In that case the memory
**      allocations are done in the object it's
**      memory pool.
**/
#ifdef POOLS
/*
**      Pool allocation.
**/
STATIC APTR GetMem( AD *ad, ULONG size )
{
        ULONG                   *ptr;

        /*
        **      Allocate the memory. Size is tracked so we do not
        **      need to remember it when deallocating the memory again.
        **/
        if ( ptr = LibAllocPooled( ad->ad_MemPool, size + sizeof( ULONG ))) {
                /*
                **      Store allocation size.
                **/
                *ptr = size + sizeof( ULONG );
                /*
                **      Adjust pointer.
                **/
                ptr++;
        }
        return(( APTR )ptr );
}

/*
**      Pool freeing.
**/
STATIC VOID PutMem( AD *ad, APTR mem )
{
        ULONG                   *ptr = ( ULONG * )mem;

        /*
        **      Retrieve the original allocation.
        **/
        ptr--;

        /*
        **      Deallocate.
        **/
        LibFreePooled( ad->ad_MemPool, ptr, *ptr );
}
#endif

/*
**      Duplicate a string.
**/
STATIC UBYTE *DupStr( AD *ad, UBYTE *str )
{
        UBYTE                   *dup = AllocMemory( strlen( str ) + 1 );

        /*
        **      Allocation OK?
        **/
        if ( dup )
                /*
                **      Copy the string.
                **/
                strcpy( dup, str );

        return( dup );
}

/*
**      Reply a rexx command.
**/
STATIC VOID ReplyRexxCommand( struct RexxMsg *rxm, LONG prim, LONG sec, UBYTE *res )
{
        UBYTE           buf[ 16 ];

        /*
        **      Result wanted?
        **/
        if ( rxm->rm_Action & RXFF_RESULT ) {
                /*
                **      Primary result?
                **/
                if ( ! prim ) {
                        /*
                        **      We setup the secondary result to
                        **      the result string when one was passed.
                        **/
                        sec = res ? ( LONG )CreateArgstring( res, strlen( res )) : 0L;
                } else {
                        /*
                        **      Primary result bigger than 0?
                        **/
                        if ( prim > 0 ) {
                                /*
                                **      Setup the result field
                                **      to point to a string containing
                                **      the secondary result number.
                                **/
                                sprintf( buf, "%ld", sec );
                                res = buf;
                        } else {
                                /*
                                **      Negate primary result and
                                **      setup the result field to
                                **      the secondary result.
                                **/
                                prim = -prim;
                                res = ( UBYTE * )sec;
                        }

                        /*
                        **      Setup ARexx it's "RC2" variable to
                        **      the result.
                        **/
                        SetRexxVar(( struct Message * )rxm, "RC2", res, strlen( res ));

                        /*
                        **      Clear secondary result.
                        **/
                        sec = 0L;
                }
        } else if ( prim < 0 )
                /*
                **      Negate primary result.
                **/
                prim = -prim;

        /*
        **      Setup result fields.
        **/
        rxm->rm_Result1 = prim;
        rxm->rm_Result2 = sec;

        /*
        **      Reply the RexxMsg.
        **/
        ReplyMsg(( struct Message * )rxm );
}

/*
**      Free a RexxMsg command.
**/
STATIC VOID FreeRexxCommand( struct RexxMsg *rxm )
{
        /*
        **      Delete the result Argstring.
        **/
        if ( ! rxm->rm_Result1 && rxm->rm_Result2 )
                DeleteArgstring(( UBYTE * )rxm->rm_Result2 );

        /*
        **      Close input handle.
        **/
        if ( rxm->rm_Stdin && rxm->rm_Stdin != Input()) {
                /*
                **      If the output handle is the
                **      same as the input handle we
                **      can safely clear it.
                **/
                if ( rxm->rm_Stdout == rxm->rm_Stdin )
                        rxm->rm_Stdout = NULL;
                Close( rxm->rm_Stdin );
                rxm->rm_Stdin = NULL;
        }

        /*
        **      Close output handle if it is not
        **      the same as Stdin.
        **/
        if ( rxm->rm_Stdout && rxm->rm_Stdout != Output()) {
                Close( rxm->rm_Stdout );
                rxm->rm_Stdout = NULL;
        }

        /*
        **      Delete the command Argstring.
        **/
        DeleteArgstring(( UBYTE * )ARG0( rxm ));
        /*
        **      Delete the message itself.
        **/
        DeleteRexxMsg( rxm );
}

/*
**      Create a RexxMsg command.
**/
STATIC struct RexxMsg *CreateRexxCommand( AD *ad, UBYTE *comname, BPTR handle )
{
        struct RexxMsg                  *rxm;

        /*
        **      Create the RexxMsg.
        **/
        if ( rxm = CreateRexxMsg( ad->ad_Port, ad->ad_FileExt, ad->ad_HostName )) {
                /*
                **      Create the Argstring.
                **/
                if ( rxm->rm_Args[ 0 ] = CreateArgstring( comname, strlen( comname ))) {
                        /*
                        **      Setup action flags.
                        **/
                        rxm->rm_Action = RXCOMM | RXFF_RESULT;
                        /*
                        **      Setup file handles.
                        **/
                        rxm->rm_Stdin  = rxm->rm_Stdout = handle;
                        return( rxm );
                }
                /*
                **      Argstring creation failed.
                **/
                DeleteRexxMsg( rxm );
        }
        return( NULL );
}

/*
**      Send a RexxMsg command to the
**      ARexx server.
**/
STATIC struct RexxMsg *CommandToRexx( AD *ad, struct RexxMsg *rxm )
{
        struct MsgPort          *rxp;

        /*
        **      Try to find the "REXX"
        **      message port.
        **/
        Forbid();

        if ( ! ( rxp = FindPort( RXSDIR ))) {
                /*
                **      Oops. ARexx server
                **      not active.
                **/
                Permit();
                return( NULL );
        }

        /*
        **      Send off the message.
        **/
        PutMsg( rxp, &rxm->rm_Node );

        Permit();

        /*
        **      Increase pending counter.
        **/
        ad->ad_PendCnt++;

        return( rxm );
}

/*
**      Send a command to the ARexx server.
**/
STATIC struct RexxMsg *SendRexxCommand( AD *ad, UBYTE *comname, BPTR handle )
{
        struct RexxMsg                  *rxm;

        /*
        **      Create a RexxMsg command and
        **      send it off to the ARexx server.
        **/
        if ( rxm = CreateRexxCommand( ad, comname, handle ))
                return( CommandToRexx( ad, rxm ));

        return( NULL );
}

STATIC REXXCOMMAND *FindRXCommand( AD *ad, UBYTE *comname, UWORD len )
{
        REXXCOMMAND             *rc = ad->ad_Commands;

        while ( rc->rc_Func ) {
                if ( ! strnicmp( comname, rc->rc_Name, len ) && isspace( comname[ strlen( rc->rc_Name ) ] ))
                        return( rc );
                rc++;
        }

        return( NULL );
}

/*
**      Execute a command.
**/
STATIC VOID DoRXCommand( AD *ad, struct RexxMsg *rxm )
{
        struct RexxMsg                  *rm;
        REXXCOMMAND                     *rco;
        REXXARGS                        *ra;
        UBYTE                           *comname, *args, *tmp, *result = NULL;
        LONG                             rc = 20, rc2 = 0;
        UWORD                            numargs = 0, len = 0;

        /*
        **      Allocate memory for the command
        **      name and it's argument string.
        **/
        if ( ! ( comname = ( UBYTE * )AllocMemory( strlen(( UBYTE * )ARG0( rxm )) + 2 ))) {
                rc2 = ERROR_NO_FREE_STORE;
                return;
        }

        /*
        **      Copy command name and argument string.
        **/
        strcpy( comname, ( UBYTE * )ARG0( rxm ));

        /*
        **      ReadArgs() requires the argument
        **      string to end with a newline.
        **/
        strcat( comname, "\n" );

        /*
        **      Find the length of the command
        **      the start of the arguments.
        **/
        args = comname;
        while ( isspace( *args )) args++;
        tmp  = args;
        while ( ! isspace( *args )) { len++; args++; }

        /*
        **      Find the command.
        **/
        if ( rco = FindRXCommand( ad, tmp, len )) {
                /*
                **      Allocate REXXARGS structure.
                **/
                if ( ra = ( REXXARGS * )AllocMemory( sizeof( REXXARGS ))) {
                        /*
                        **      Count number of expected args.
                        **/
                        if ( rco->rc_ArgTemplate ) {
                                tmp = rco->rc_ArgTemplate;
                                while ( *tmp != '\n' ) {
                                        if ( *tmp++ == ',' ) numargs++;
                                }
                                numargs++;
                                /*
                                **      Allocate arg array.
                                **/
                                if ( ra->ra_ArgList = ( ULONG * )AllocMemory( numargs * sizeof( ULONG ))) {
                                        /*
                                        **      Setup RDArgs.
                                        **/
                                        ad->ad_DOSParser->RDA_Source.CS_Buffer = args;
                                        ad->ad_DOSParser->RDA_Source.CS_Length = strlen( args );
                                        ad->ad_DOSParser->RDA_Source.CS_CurChr = 0;
                                        ad->ad_DOSParser->RDA_DAList           = NULL;
                                        ad->ad_DOSParser->RDA_Buffer           = NULL;
                                        /*
                                        **      Parse args.
                                        **/
                                        if ( ReadArgs( rco->rc_ArgTemplate, ra->ra_ArgList, ad->ad_DOSParser )) {
                                                /*
                                                **      Call the REXX routine.
                                                **/
                                                ( rco->rc_Func )( ra, rxm );

                                                rc     = ra->ra_RC;
                                                rc2    = ra->ra_RC2;
                                                result = ra->ra_Result;

                                                FreeArgs( ad->ad_DOSParser );
                                        } else {
                                                rc = 10;
                                                rc2 = IoErr();
                                        }
                                        FreeMemory( ra->ra_ArgList );
                                } else
                                        rc2 = ERROR_NO_FREE_STORE;
                        } else {
                                /*
                                **      No args.
                                **/
                                ( rco->rc_Func )( ra, rxm );

                                rc     = ra->ra_RC;
                                rc2    = ra->ra_RC2;
                                result = ra->ra_Result;
                        }
                        FreeMemory( ra );
                } else
                        rc2 = ERROR_NO_FREE_STORE;
        } else {
                /*
                **      Not found in our list?
                **      Maybe it's a script.
                **/
                if ( rm = CreateRexxCommand( ad, ( UBYTE * )ARG0( rxm ), NULL )) {
                        /*
                        **      Save original message.
                        **/
                        rm->rm_Args[ 15 ] = ( STRPTR )rxm;
                        /*
                        **      Let the REXX server see what
                        **      it can do with this.
                        **/
                        if ( ! CommandToRexx( ad, rm ))
                                rc2 = ERROR_NOT_IMPLEMENTED;
                } else
                        rc2 = ERROR_NO_FREE_STORE;

                goto byeBye;
        }

        ReplyRexxCommand( rxm, rc, rc2, result );

        byeBye:

        FreeMemory( comname );
}

/*
**      OM_NEW.
**/
STATIC ULONG ARexxNew( Class *cl, Object *obj, struct opSet *ops )
{
        struct TagItem         *attr = ops->ops_AttrList, *tag;
        struct MsgPort         *mp;
        AD                     *ad;
        ULONG                   rc, *ecode, ext = 1L;
        UBYTE                   unique_name[ 80 ], *tmp;

        /*
        **      Let the superclass set us up...
        **/
        if ( rc = ( ULONG )DoSuperMethodA( cl, obj, ( Msg )ops )) {
                /*
                **      Get the instance data.
                **/
                ad = ( AD * )INST_DATA( cl, rc );
                /*
                **      Safety precautions.
                **/
                bzero(( char * )ad, sizeof( AD ));

                /*
                **      First see if we got error storage.
                **/
                if ( tag = FindTagItem( AC_ErrorCode, attr ))
                        ecode = ( ULONG * )tag->ti_Data;

#ifdef POOLS
                /*
                **      Create a memory pool.
                **/
                if ( ad->ad_MemPool = LibCreatePool( MEMF_PUBLIC | MEMF_CLEAR, 4096L, 4096L )) {
#endif
                /*
                **      Create port if a
                **      host name is supplied.
                **/
                if ( tag = FindTagItem( AC_HostName, attr )) {
                        /*
                        **      Store host name.
                        **/
                        ad->ad_HostName = ( UBYTE * )tag->ti_Data;
                        /*
                        **      Name valid?
                        **/
                        if ( ad->ad_HostName && *ad->ad_HostName ) {
                                /*
                                **      Make the name unique.
                                **/
                                sprintf( unique_name, "%s.1", ad->ad_HostName );
                                Forbid();
                                while (( mp = FindPort( unique_name )) && ext <= 99 )
                                        sprintf( unique_name, "%s.%ld", ad->ad_HostName, ++ext );
                                Permit();
                                /*
                                **      Name unique?
                                **/
                                if ( ! mp ) {
                                        /*
                                        **      Copy the name.
                                        **/
                                        if ( ad->ad_HostName = DupStr( ad, unique_name )) {
                                                /*
                                                **      Uppercase it.
                                                **/
                                                tmp = ad->ad_HostName;
                                                while ( *tmp ) {
                                                        *tmp = toupper( *tmp );
                                                        tmp++;
                                                }
                                                /*
                                                **      Create the port.
                                                **/
                                                if ( ad->ad_Port = CreateMsgPort()) {
                                                        /*
                                                        **      Initialize and add the port.
                                                        **/
                                                        ad->ad_Port->mp_Node.ln_Name = ad->ad_HostName;
                                                        ad->ad_Port->mp_Node.ln_Pri  = 0;
                                                        AddPort( ad->ad_Port );
                                                } else if ( ecode )
                                                        *ecode = RXERR_OUT_OF_MEMORY;
                                        } else if ( ecode )
                                                *ecode = RXERR_OUT_OF_MEMORY;
                                } else if ( ecode )
                                        *ecode = RXERR_PORT_ALREADY_EXISTS;
                        } else if ( ecode )
                                *ecode = RXERR_NO_PORT_NAME;
                } else if ( ecode )
                        *ecode = RXERR_NO_PORT_NAME;

                /*
                **      Do we have a port now?
                **/
                if ( ad->ad_Port ) {
                        /*
                        **      Find the commandlist.
                        **/
                        if ( tag = FindTagItem( AC_CommandList, attr )) {
                                if ( ad->ad_Commands = ( REXXCOMMAND * )tag->ti_Data ) {
                                        /*
                                        **      Setup the AmigaDOS parser.
                                        **/
                                        if ( ad->ad_DOSParser = ( struct RDArgs * )AllocDosObject( DOS_RDARGS, NULL )) {
                                                ad->ad_DOSParser->RDA_Flags = RDAF_NOPROMPT;
                                                /*
                                                **      Obtain file extention.
                                                **/
                                                if ( tag = FindTagItem( AC_FileExtention, attr ))
                                                        ad->ad_FileExt = ( UBYTE * )tag->ti_Data;
                                                else
                                                        ad->ad_FileExt = "rexx";
                                                return( rc );
                                        } else if ( ecode )
                                                *ecode = RXERR_OUT_OF_MEMORY;
                                } else if ( ecode )
                                        *ecode = RXERR_NO_COMMAND_LIST;
                        } else if ( ecode )
                                *ecode = RXERR_NO_COMMAND_LIST;
                }
#ifdef POOLS
                } else if ( ecode )
                        *ecode = RXERR_OUT_OF_MEMORY;
#endif
                /*
                **      Bliep error...bliep....
                **/
                CoerceMethod( cl, ( Object * )rc, OM_DISPOSE );
        }
        return( 0L );
}

/*
**      OM_DISPOSE.
**/
STATIC ULONG ARexxDispose( Class *cl, Object *obj, Msg msg )
{
        AD                      *ad = ( AD * )INST_DATA( cl, obj );
        struct RexxMsg          *rxm;

        /*
        **      Do we have a port?
        **/
        if ( ad->ad_Port ) {
                /*
                **      Remove the port from the public list
                **/
                RemPort( ad->ad_Port );
                /*
                **      Wait for and handle all
                **      messages still pending.
                **/
                if ( ad->ad_PendCnt ) {
                        while ( ad->ad_PendCnt ) {
                                /*
                                **      Wait for a message.
                                **/
                                WaitPort( ad->ad_Port );
                                /*
                                **      Get messages.
                                **/
                                while ( rxm = ( struct RexxMsg * )GetMsg( ad->ad_Port )) {
                                        /*
                                        **      Replyed message?
                                        **/
                                        if ( rxm->rm_Node.mn_Node.ln_Type == NT_REPLYMSG ) {
                                                /*
                                                **      Free the message and decrease the
                                                **      pending counter.
                                                **/
                                                FreeRexxCommand( rxm );
                                                ad->ad_PendCnt--;
                                        } else
                                                /*
                                                **      Tell'm where getting out of here.
                                                **/
                                                ReplyRexxCommand( rxm, -20, ( LONG )"Host object closing down", NULL );
                                }
                        }
                } else {
                        /*
                        **      In case there are no messages pending we
                        **      still need to reply all that is waiting at
                        **      the port.
                        **/
                        while ( rxm = ( struct RexxMsg * )GetMsg( ad->ad_Port ))
                                ReplyRexxCommand( rxm, -20, ( LONG )"Host object closing down", NULL );
                }

                /*
                **      Delete the port.
                **/
                DeleteMsgPort( ad->ad_Port );
        }

        /*
        **      Delete the AmigaDOS parser.
        **/
        if ( ad->ad_DOSParser )
                FreeDosObject( DOS_RDARGS, ad->ad_DOSParser );

        /*
        **      Delete the port name.
        **/
        if ( ad->ad_HostName )
                FreeMemory( ad->ad_HostName );

#ifdef POOLS
        /*
        **      Free the pool.
        **/
        LibDeletePool( ad->ad_MemPool );
#endif

        /*
        **      Let the superclass do the rest.
        **/
        return( DoSuperMethodA( cl, obj, msg ));
}

/*
**      ACM_EXECUTE.
**/
STATIC ULONG ARexxExecute( Class *cl, Object *obj, struct acmExecute *acme )
{
        AD                              *ad = ( AD * )INST_DATA( cl, obj );
        REXXCOMMAND                     *rco;
        REXXARGS                        *ra;
        struct RexxMsg                  *rxm;
        UBYTE                           *args, *tmp, *result = NULL, *com;
        UWORD                            numargs = 0, len = 0;
        ULONG                            r = 20, r2;

        /*
        **      Allocate a private copy of the command string.
        **/
        if ( com = ( UBYTE * )AllocMemory( strlen( acme->acme_CommandString ) + 2 )) {
                /*
                **      Make a copy terminated with a newline.
                **/
                strcpy( com, acme->acme_CommandString );
                strcat( com, "\n" );
                /*
                **      Find the length of the command
                **      and the start of the arguments.
                **/
                args = com;
                while ( isspace( *args ))   args++;
                tmp = args;
                while ( ! isspace( *args )) { len++; args++; }
                /*
                **      Look up the command.
                **/
                if ( rco = FindRXCommand( ad, tmp, len )) {
                        /*
                        **      Allocate a REXXARGS structure.
                        **/
                        if ( ra = ( REXXARGS * )AllocMemory( sizeof( REXXARGS ))) {
                                /*
                                **      Args expected?
                                **/
                                if ( rco->rc_ArgTemplate ) {
                                        /*
                                        **      Count the expected number of arguments.
                                        **/
                                        tmp = rco->rc_ArgTemplate;
                                        while ( *tmp != '\n' ) {
                                                if ( *tmp++ != ',' ) numargs++;
                                        }
                                        numargs++;
                                        /*
                                        **      Allocate space to parse the args.
                                        **/
                                        if ( ra->ra_ArgList = ( ULONG * )AllocMemory( numargs * sizeof( ULONG ))) {
                                                /*
                                                **      Setup the parser.
                                                **/
                                                ad->ad_DOSParser->RDA_Source.CS_Buffer = args;
                                                ad->ad_DOSParser->RDA_Source.CS_Length = strlen( args );
                                                ad->ad_DOSParser->RDA_Source.CS_CurChr = 0;
                                                ad->ad_DOSParser->RDA_DAList           = NULL;
                                                ad->ad_DOSParser->RDA_Buffer           = NULL;
                                                /*
                                                **      Parse the args.
                                                **/
                                                if ( ReadArgs( rco->rc_ArgTemplate, ra->ra_ArgList, ad->ad_DOSParser )) {
                                                        /*
                                                        **      Run command.
                                                        **/
                                                        ( rco->rc_Func )( ra, NULL );
                                                        /*
                                                        **      Store results.
                                                        **/
                                                        r      = ra->ra_RC;
                                                        r2     = ra->ra_RC2;
                                                        result = ra->ra_Result;
                                                        FreeArgs( ad->ad_DOSParser );
                                                } else {
                                                        r  = 10;
                                                        r2 = IoErr();
                                                }
                                                /*
                                                **      Deallocate arg list.
                                                **/
                                                FreeMemory( ra->ra_ArgList );
                                        } else
                                                r2 = ERROR_NO_FREE_STORE;
                                } else {
                                        /*
                                        **      Run command.
                                        **/
                                        ( rco->rc_Func )( ra, NULL );
                                        /*
                                        **      Store results.
                                        **/
                                        r      = ra->ra_RC;
                                        r2     = ra->ra_RC2;
                                        result = ra->ra_Result;
                                }
                                /*
                                **      Deallocate the REXXARGS structure.
                                **/
                                FreeMemory( ra );
                        } else
                                r2 = ERROR_NO_FREE_STORE;
                        /*
                        **      When not passed to the rexx server
                        **      we must close the given IO handle
                        **      ourselves.
                        **/
                        if ( acme->acme_IO ) Close( acme->acme_IO );
                } else {
                        /*
                        **      We do not send the new-line to
                        **      the ARexx server.
                        **/
                        com[ strlen( com ) - 1 ] = '\0';
                        /*
                        **      Unknown commands are shipped
                        **      off to the REXX server.
                        **/
                        if ( rxm = CreateRexxCommand( ad, com, acme->acme_IO )) {
                                if ( ! CommandToRexx( ad, rxm ))
                                        r2 = ERROR_NOT_IMPLEMENTED;
                                else
                                        r = r2 = 0L;
                        } else
                                r2 = ERROR_NO_FREE_STORE;
                }
                /*
                **      Deallocate the command copy.
                **/
                FreeMemory( com );
        } else
                r2 = ERROR_NO_FREE_STORE;

        /*
        **      Put the results into their
        **      storage spaces.
        **/
        if ( acme->acme_RC     ) *( acme->acme_RC     ) = r;
        if ( acme->acme_RC2    ) *( acme->acme_RC2    ) = r2;
        if ( acme->acme_Result ) *( acme->acme_Result ) = result;

        return( 1L );
}

/*
**      OM_GET.
**/
STATIC ULONG ARexxGet( Class *cl, Object *obj, struct opGet *opg )
{
        AD                      *ad = ( AD * )INST_DATA( cl, obj );
        ULONG                   rc = 1L;

        /*
        **      What do they want?
        **/
        switch ( opg->opg_AttrID ) {

                case    AC_HostName:
                        *( opg->opg_Storage ) = ( ULONG )ad->ad_HostName;
                        break;

                case    AC_RexxPortMask:
                        *( opg->opg_Storage ) = ( 1L << ad->ad_Port->mp_SigBit );
                        break;

                default:
                        rc = DoSuperMethodA( cl, obj, ( Msg )opg );
                        break;
        }
        return( rc );
}

/*
**      ACM_HANDLE_EVENT.
**/
STATIC ULONG ARexxHandleEvent( Class *cl, Object *obj, Msg msg )
{
        struct RexxMsg          *rxm, *org;
        AD                      *ad = ( AD * )INST_DATA( cl, obj );
        ULONG                    rc = 1L;

        /*
        **      Get the messages from the port.
        **/
        while ( rxm = ( struct RexxMsg * )GetMsg( ad->ad_Port )) {
                /*
                **      A Rexx command?
                **/
                if (( rxm->rm_Action & RXCODEMASK ) != RXCOMM )
                        ReplyMsg(( struct Message * )rxm );
                else if ( rxm->rm_Node.mn_Node.ln_Type == NT_REPLYMSG ) {
                        /*
                        **      Reply'd message. See if it was started
                        **      as a script.
                        **/
                        if ( org = ( struct RexxMsg * )rxm->rm_Args[ 15 ] ) {
                                if ( rxm->rm_Result1 )
                                        ReplyRexxCommand( org, 20, ERROR_NOT_IMPLEMENTED, NULL );
                                else
                                        ReplyRexxCommand( org, 0, 0, ( UBYTE * )rxm->rm_Result2 );
                        }
                        /*
                        **      Free the message and decrease the
                        **      pending counter.
                        **/
                        FreeRexxCommand( rxm );
                        ad->ad_PendCnt--;
                } else if ( ARG0( rxm ))
                        /*
                        **      Execute message.
                        **/
                        DoRXCommand( ad, rxm );
                else
                        ReplyMsg(( struct Message * )rxm );
        }
}

/*
**      Class dispatcher.
**/
STATIC SAVEDS ASM ULONG ARexxDispatch( REG(A0) Class *cl, REG(A2) Object *obj, REG(A1) Msg msg )
{
        ULONG                   rc = 0L;

        /*
        **      Evaluate the method.
        **/
        switch ( msg->MethodID ) {

                case    OM_NEW:
                        rc = ARexxNew( cl, obj, ( struct opSet * )msg );
                        break;

                case    OM_GET:
                        rc = ARexxGet( cl, obj, ( struct opGet * )msg );
                        break;

                case    OM_DISPOSE:
                        rc = ARexxDispose( cl, obj, msg );
                        break;

                case    ACM_HANDLE_EVENT:
                        rc = ARexxHandleEvent( cl, obj, msg );
                        break;

                case    ACM_EXECUTE:
                        rc = ARexxExecute( cl, obj, ( struct acmExecute * )msg );
                        break;

                default:
                        rc = DoSuperMethodA( cl, obj, msg );
                        break;
        }
        return ( rc );
}
