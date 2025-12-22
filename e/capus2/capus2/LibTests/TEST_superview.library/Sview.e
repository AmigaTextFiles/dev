/* ============================================= */
/* TEST superview.library by NasGûl              */
/* all structures are in source code (no module) */
/* ============================================= */
MODULE 'exec/nodes','exec/lists','exec/libraries'
MODULE 'intuition/intuition','intuition/intuitionbase'
MODULE 'intuition/screens'
MODULE 'superviewsupport'
MODULE 'superview'
MODULE 'svdrivers'
MODULE 'svobjects'
MODULE 'gadtools'
MODULE 'eropenlib'

ENUM ER_NONE,ER_ONLYCLI,ER_SUPERVIEWLIB,ER_BADARGS,ER_HANDLE

/*"superview.h"*/
/* superview/superview.h            */
/* Version    : 6.1                 */
/* Date       : 27.05.1994          */
/* Written by : Andreas R. Kleinert */


/* *************************************************** */
/* *                                                 * */
/* * Version Defines                                 * */
/* *                                                 * */
/* *************************************************** */

CONST SVLIB_VERSION=6

/* *************************************************** */
/* *                             * */
/* * DEFINES                         * */
/* *                             * */
/* *************************************************** */


/* Possible FileTypes */

CONST SV_FILETYPE_NONE=0
CONST SV_FILETYPE_UNKNOWN=SV_FILETYPE_NONE
CONST SV_FILETYPE_ILLEGAL=$FFFFFFFF

CONST SV_FILETYPE_ILBM=1          /* IFF-ILBM, any derivat   */
CONST SV_FILETYPE_ACBM=2          /* IFF-ACBM, any derivat   */
CONST SV_FILETYPE_DATATYPE=3      /* V39-Datatype-Object     */

     /*
    up to here  : Constant codes for IFF-ILBM, IFF-ACBM and DataTypes
              (constant for compatibility reasons).
    above these : External, user defined FileSubTypes
              (defined EACH TIME NEW at Library's startup-time).
     */


/* Possible SubTypes of FileTypes */

CONST SV_SUBTYPE_NONE=0
CONST SV_SUBTYPE_UNKNOWN=SV_SUBTYPE_NONE
CONST SV_SUBTYPE_ILLEGAL=$FFFFFFFF

CONST SV_SUBTYPE_ILBM=1          /* Is IFF-ILBM              */
CONST SV_SUBTYPE_ILBM_01=2          /* Is IFF-ILBM, CmpByteRun1 */
CONST SV_SUBTYPE_ACBM=3          /* Is IFF-ACBM              */
CONST SV_SUBTYPE_DATATYPE=4          /* Is V39-DataType-Object   */

     /*
    up to here  : Constant codes for IFF-ILBM, IFF-ACBM and DataTypes
              (constant for compatibility reasons).
    above these : External, user defined FileSubTypes
              (defined EACH TIME NEW at Library's startup-time).
     */


/* Possible Input and Output mediums */

CONST AKO_MEDIUM_NONE=0          /* means : DEFAULT          */
CONST AKO_MEDIUM_ILLEGAL=$FFFFFFFF

CONST AKO_MEDIUM_DISK=1              /* Read and Write media     */
CONST AKO_MEDIUM_CLIP=2

     /* not any medium might be supported by any SVObject */


/* *************************************************** */
/* *                             * */
/* * Function Error Codes                * */
/* *                             * */
/* *************************************************** */

CONST SVERR_MAX_ERROR_TEXT_LENGTH=80       /* plus Null-Byte */

CONST SVERR_NO_ERROR=NIL
CONST SVERR_INTERNAL_ERROR=$FFFFFFFF

CONST SVERR_UNKNOWN_FILE_FORMAT=1
CONST SVERR_FILE_NOT_FOUND=2
CONST SVERR_NO_MEMORY=3
CONST SVERR_IFFPARSE_ERROR=4
CONST SVERR_NO_CLIPBOARD=5
CONST SVERR_NO_SCREEN=6
CONST SVERR_NO_FILE=7
CONST SVERR_NO_HANDLE=8
CONST SVERR_NO_DATA=9
CONST SVERR_GOT_NO_WINDOW=10
CONST SVERR_GOT_NO_SCREEN=11
CONST SVERR_NO_INFORMATION=12
CONST SVERR_ILLEGAL_ACCESS=13
CONST SVERR_DECODE_ERROR=14
CONST SVERR_UNKNOWN_PARAMETERS=15
CONST SVERR_ACTION_NOT_SUPPORTED=16
CONST SVERR_VERSION_CONFLICT=17
CONST SVERR_NO_DRIVER_AVAILABLE=18

    /* Each new Library-Subversion may contain new Codes above
       the last one of these.
       So do not interpret the codes directly, but use
       SVL_GetErrorString().
       Maybe, newer Codes will not be listed up here.
    */

OBJECT gfxbuffer /* SV_GfxBuffer */

 /*
    All values are strictly READ-ONLY :
    - DO NOT write-access any entries !
    - DO NOT free any memory by hand !
 */

 version:LONG        /* structure version, see below            */
 buffertype:LONG     /* Data organization, see below            */
 width:LONG          /* Graphic's Width                             */
 height:LONG         /* Graphic's Height                            */
 colordepth:LONG     /* Graphic's ColorDepth                        */
 viewmode32:LONG     /* if NULL, best ScreenMode is suggested       */
 colors[768]:ARRAY   /* For ColorDepth < 8 : 3-Byte RGB         */
 bytesperline:LONG   /* as in conventional BitMaps (see below)      */
                     /* only valid, if svgfx_BufferType == BITPLANE */
 pixelbits:LONG      /* how many Bits per Pixel : 8, 16, 24 ?       */
                     /* only valid, if svgfx_BufferType == ONEPLANE */
 buffer:LONG         /* any kind of memory (no chip ram needed)     */
 buffersize:LONG     /* if you want to copy it ...          */

ENDOBJECT /* size of structure may grow in future versions : Check svgfx_Version ! */

CONST SVGFX_VERSION=1

CONST SVGFX_BUFFERTYPE_BITPLANE=1  /* Amiga-like BitPlanes            */
CONST SVGFX_BUFFERTYPE_ONEPLANE=2  /* single Byte-/Word-/24 Bit-Plane */

/* there may be more types in the future */


/* structure of svgfx_Buffer is as follows :

   BITPLANE : Amiga-like BitPlane, upto 256 Colors (8 Bit)
          NO SPECIAL ALIGNMENT IS DONE.
   ONEPLANE :  8 Bit : Chunky Pixel (ColorMap)
          16 Bit : R:G:B = 5:5:5 plus 1 Bit Alpha Channel (IGNORED)
          24 Bit : R:G:B = 8:8:8
*/
/**/
/*"superviewbase.h"*/
/* superview/superviewbase.h        */
/* Version    : 6.1                 */
/* Date       : 23.05.1994          */
/* Written by : Andreas R. Kleinert */

   /*
      All entries are READ-ONLY.
      The private entries should NEVER be accessed.
   */

OBJECT superviewbase
 libnode:lib
 seglist:LONG
 sysbase:LONG
 dosbase:LONG
 intuitionbase:LONG
 gfxbase:LONG

  /* next have been added with V2 : */

 iffparsebase:LONG  /* may be NULL */
 datatypesbase:LONG /* may be NULL */

 svobjectlist:lh
 private1:LONG      /* DO NOT ACCESS */
 private2:LONG      /* DO NOT ACCESS */
 private3:LONG      /* DO NOT ACCESS */

  /* next have been added with V3 : */

 svdriverlist:lh
 globaldriver:LONG  /* may be NULL for Default-Driver */

  /* next have been added with V4 : */

 utilitybase:LONG
 svsupportbase:LONG
ENDOBJECT
/**/
/*"svinfo.h"*/
/* superview/svinfo.h               */
/* Version    : 6.1                 */
/* Date       : 27.05.1994          */
/* Written by : Andreas R. Kleinert */

/* *************************************************** */
/* *                                                 * */
/* * Information structures (SVObjects & SVDrivers)  * */
/* *                                                 * */
/* *************************************************** */

   /* the following have been introduced with V6 : */

OBJECT svobjectinfo
 type:LONG            /* valid SubTypeCode value       */
 flags:LONG           /* Copy of Flags from svo_Flags  */
 typename:LONG        /* Copy of svo_TypeID and        */
                      /* svo_SubTypeID[x]              */
 nextentry:LONG       /* Pointer to next entry or NULL */
ENDOBJECT

OBJECT svdriverinfo
 flags:LONG     /* Copy of Flags from svd_Flags  */
 name:LONG      /* Pointer to svd_ID             */
 nextentry:LONG /* Pointer to next entry or NULL */
ENDOBJECT
/**/

/*"superviewsupport.h"*/
/* superviewsupport/superviewsupport.h */
/* Version    : 3.1                    */
/* Date       : 23.05.1994             */
/* Written by : Andreas R. Kleinert    */

/* *************************************************** */
/* *                             * */
/* * Version Defines                     * */
/* *                             * */
/* *************************************************** */

CONST SVSUPPORTLIB_VERSION=3


/* *************************************************** */
/* *                             * */
/* * Includes                        * */
/* *                             * */
/* *************************************************** */

/*  === ControlPads === */

/* see documentation for more and detailed information on ControlPad-Files */

OBJECT controlpad          /* These ControlPads are supplied as    */
                           /* single-chained list, where the       */
 entryname:LONG            /* pointer to the last entry is NULL.   */
 entrycontent:LONG         /* Do not free them by Hand.            */
 nextentry:LONG
ENDOBJECT
/**/
/*"svsupportbase.h"*/
/* superviewsupport/svsupportbase.h */
/* Version    : 2.1                 */
/* Date       : 22.05.1994          */
/* Written by : Andreas R. Kleinert */

OBJECT svsupportbase
 libnode:lib
 seglist:LONG
 sysbase:LONG
 dosbase:LONG
 intuitionbase:LONG
 gfxbase:LONG
 utilitybase:LONG
ENDOBJECT
/**/

/*"svdrivers.h"*/
/* svdrivers/svdrivers.h            */
/* Version    : 3.5                 */
/* Date       : 25.03.1994          */
/* Written by : Andreas R. Kleinert */

/* SVDriver-Version V1.x+ */

OBJECT drivernode
 node:ln              /* chaining Node                         */
                      /* (svd_Node->ln_Name MUST               */
                      /*  point to svd_FileName !)             */

 version:LONG         /* Library-Version of svdriver           */

 flags:LONG           /* Flags, see below                      */

 filename[108]:ARRAY  /* use 30, as in struct FileInfoBlock    */

 maxwidth:LONG                /* max. Screen Dimensions or 0xFFFFFFFF  */
 maxheight:LONG
 maxdepth:LONG
 id[80]:ARRAY                 /* short description, e.g. "AGA Driver"  */

 /* size may grow with bigger svd_Version, see below */
ENDOBJECT

CONST SVD_VERSION=1             /* If this Version, which depends on the */
                                    /* svdriver's Library-Version, is set,   */
                                    /* it is guaranteed, that at least the   */
                                    /* above information is available.       */

   /* Flags allowed for svd_Flags field. Values are "just for info" yet. */

CONST SVDF_INTUITION=0       /* Intuition compatible Display          */
                             /* e.g. Amiga, ECS, AA                   */
                             /* or compatible Graphic Cards           */

CONST SVDF_FOREIGN=1       /* incompatible Gfx Display              */
                           /* e.g. EGS                              */
/**/
/*"svdriverbase.h"*/
/* svdrivers/svdriverbase.h     */
/* Version    : 3.5         */
/* Date       : 28.03.1994      */
/* Written by : Andreas R. Kleinert */


   /* An external Driver-Library (for graphics cards, framebuffers, etc.)
      for the superview.library is called a "svdriver".
      Each svdriver has to contain a "SVD_DriverNode" structure (as follows)
      in its Library-Header, which later will be READ and MODIFIED by
      the superview.library.
   */

   /* The Construction of a svdriver :
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      The Library Base
      ----------------

      Version MUST be 1 yet, Revision can be set freely

      (see structure described below)


      The Function Table
      ------------------

      (see <pragmas/svdrivers.h> or Reference_ENG.doc)

   */

/* *************************************************** */
/* *                             * */
/* * Library base Definition for svdrivers       * */
/* *                             * */
/* *************************************************** */

OBJECT svdriverbase
 libnode:lib       /* Exec LibNode           */
 svdriver:LONG     /* POINTER to initialized         */
                   /* SVD_DriverNode             */
                   /* Define it somewhere else,      */
                   /* then initialize this pointer.  */

 reserved[32]:ARRAY    /* Reserved for future expansion. */
                       /* Always NULL yet (Version 1).   */

 /*
   Private data of the svdriver, not to be accessed
   by superview.library, may follow.
 */
ENDOBJECT
/**/

/*"svobectbase.h"*/
/* svobjects/svobjectbase.h     */
/* Version    : 3.7         */
/* Date       : 28.04.1994      */
/* Written by : Andreas R. Kleinert */

/* SVObject-Version V2.x+ */


   /* An external support-library for the superview.library is called a
      "svobject".
      Each svobject has to contain a "SVO_ObjectNode" structure (as follows)
      in its Library-Header, which later will be READ and MODIFIED by
      the superview.library.
      Because the superview.library supports three different sorts
      of SVObjects at the time (internal, independent and external),
      there are three different types of this structure (might be more in
      the future), which can be identified via their "svo_ObjectType".
   */

   /* The Construction of a svobject :
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      The Library Base
      ----------------

      Version MUST be 2 yet, Revision can be set freely

      (see structure described below)


      The Function Table
      ------------------

      (see <pragmas/svobjects.h> or Reference_ENG.doc)

   */

/* *************************************************** */
/* *                             * */
/* * Library base Definition for svobjects       * */
/* *                             * */
/* *************************************************** */

OBJECT svobjectbase
 libnode:LONG       /* Exec LibNode           */
 svobject:LONG;      /* POINTER to initialized         */
                    /* SVO_ObjectNode             */
                    /* Define it somewhere else,      */
                    /* then initialize this pointer.  */

 reserved[32]:ARRAY  /* Reserved for future expansion. */
                     /* Always NULL yet (Version 1).   */

 /*
   Private data of the svobject, not to be accessed
   by superview.library, may follow.
 */
ENDOBJECT
/**/
/*"svobjects.h"*/
/* svobjects/svobjects.h            */
/* Version    : 4.1                 */
/* Date       : 15.05.1994          */
/* Written by : Andreas R. Kleinert */

/* SVObject-Version V2.x+ */



OBJECT objectnode
 node:ln              /* chaining Node                         */
                      /* (svo_Node->ln_Name is NULL            */
                      /*  by default !)                        */

 version:LONG         /* Library-Version of svobject           */

 objecttype:LONG      /* see below (SVO_OBJECTTYPE_...)        */

 filename[108]:ARRAY   /* use 30, as in struct FileInfoBlock    */

 typeid[32]:ARRAY        /* e.g. "GIF"                            */
 typecode:LONG                /* ... and its appropriate Code,  ,      */
                                    /* assigned by superview.library LATER.  */

 subtypenum:LONG              /* actually available SubTypes           */
                                    /* (maximum 16) of the svobject.         */

                                    /* 0xFFFFFFFF means, that it is an       */
                                    /* INDEPENDENT entry, which is an        */
                                    /* unimplemented feature yet and         */
                                    /* means that the SubTypeID and          */
                                    /* SubTypeCode fields should be skipped. */

 subtypeid[256]:ARRAY    /* e.g. "87a" or "89a"                   */
 subtypecode[16]:ARRAY        /* ... and their appropriate Codes,      */
                                    /* assigned by superview.library LATER.  */

 /* version 2 extensions : */

 flags:LONG                   /* SVO_FLAG_... (see below)              */

 /* size may grow with bigger svo_Version, see below */
ENDOBJECT

CONST SVO_VERSION=2             /* If this Version, which depends on the */
                                    /* svobject's Library-Version, is set,   */
                                    /* it is guaranteed, that at least the   */
                                    /* above information is available.       */

CONST SVO_FILENAME="INTE"     /* for internal svobjects only.          */


CONST SVO_OBJECTTYPE_NONE=0
CONST SVO_OJECTTYPE_UNKNOWN=SVO_OBJECTTYPE_NONE
CONST SVO_OBJECTTYPE_ILLEGAL=$FFFFFFFF

CONST SVO_OBJECTTYPE_INTERNAL=1 /* internal                   */
CONST SVO_OBJECTTYPE_INDEPENDENT=2 /* UNIMPLEMENTED              */
                                               /* Handle them like EXTERNAL, */
                                               /* but ignore some entries.   */
CONST SVO_OBJECTTYPE_EXTERNAL=3 /* external svobject          */


  /* The following flags have been introduced with the V2 SVObjects
     (depending on svo_Version : do not check them with V1 SVObjects).
     They should help any applications deciding, whether a specific
     SVObject may fulfil an action or not.
     Note : Some SVObjects may not have the correct flags set and might
            return SVERR_ACTION_NOT_SUPPORTED nevertheless
  */


CONST SVO_FLAG_READS_TO_BUFFER=0 /* allows reading to SV_GfxBuffer */
CONST SVO_FLAG_READS_TO_SCREEN=1 /* allows displaying on Screen    */

CONST SVO_FLAG_WRITES_FROM_BUFFER=2 /* writes SV_GfxBuffer to file    */
CONST SVO_FLAG_WRITES_FROM_SCREEN=4 /* writes Screen to file          */

CONST SVO_FLAG_SUPPORTS_SVDRIVER=8 /* uses default SVDriver,         */
                                           /* if available                   */
CONST SVO_FLAG_NEEDS_SVDRIVER=16   /* needs valid default SVDriver   */
                                           /* for working. Developers :      */
                                           /* Set SVO_FLAG_SVDRIVER instead  */

CONST SVO_FLAG_SVDRIVER=24


 /* This structure has to be passed to SVObject's SVO_CheckFileType()
    function, if media other than AKO_MEDIUM_DISK are used for reading.
    This is supported since superview.library V4 and may be ignored by
    SVObjects for compatibility reasons. To prevent older SVO_CheckFileType()
    functions from crashing, superview.library will create a dummy-file and
    pass it's handle also ...
    ("You wanna something to check ? - Here you get it !")

     In the V3-SVObject specification this structure will HAVE TO be
     examined, then. In the current V2-specification this is not the case.
  */
    
OBJECT svocheckfile
 medium:LONG   /* AKO_MEDIUM_... */
 future:LONG   /* as usual       */
ENDOBJECT
/**/
DEF strsource[256]:STRING
DEF strdestin[256]:STRING
DEF listf=FALSE
DEF c_f=NIL
DEF showdest=FALSE
/*"main()"*/
PROC main() HANDLE
    DEF tm
    IF wbmessage<>NIL THEN Raise(ER_ONLYCLI)
    IF (tm:=p_OpenLibraries())<>ER_NONE THEN Raise(tm)
    IF (tm:=p_StartCli())<>ER_NONE THEN Raise(tm)
    IF ((c_f=NIL) AND (listf=FALSE))
        p_ViewImage(strsource)
        Raise(ER_NONE)
    ELSEIF listf=TRUE
        p_ListObj()
        Raise(ER_NONE)
    ENDIF
    p_ConvertImage(strsource,strdestin,c_f)
    IF showdest=TRUE THEN p_ViewImage(strdestin)
    Raise(ER_NONE)
EXCEPT
    p_CloseLibraries()
    SELECT exception
        CASE ER_ONLYCLI;        WriteF('Error: Only cli\n')
        CASE ER_SUPERVIEWLIB;   WriteF('Error: superview.library ?\n')
        CASE ER_GADTOOLSLIB;    WriteF('Error: gadtools.library ?\n')
    ENDSELECT
ENDPROC
/**/
/*"p_StartCli()"*/
PROC p_StartCli() HANDLE
    DEF myargs:PTR TO LONG,rdargs=NIL
    myargs:=[0,0,0,0,0]
    IF rdargs:=ReadArgs('Source,Destin,Convert/N,ListFormat/S,ShowDest/S',myargs,NIL)
        IF myargs[0] THEN StrCopy(strsource,myargs[0],ALL)
        IF myargs[1] THEN StrCopy(strdestin,myargs[1],ALL)
        IF myargs[2] THEN c_f:=Long(myargs[2])
        IF myargs[3] THEN listf:=TRUE
        IF myargs[4] THEN showdest:=TRUE
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_OpenLibraires()"*/
PROC p_OpenLibraries() HANDLE
    IF (superviewbase:=OpenLibrary('superview.library',0))=NIL THEN Raise(ER_SUPERVIEWLIB)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',0))=NIL THEN Raise(ER_GADTOOLSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_CloseLibraries()"*/
PROC p_CloseLibraries()
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF superviewbase THEN CloseLibrary(superviewbase)
ENDPROC
/**/
/*"p_ViewImage(name)"*/
PROC p_ViewImage(name)
    DEF handle
    DEF w:PTR TO window
    DEF retval=SVERR_NO_ERROR,count
    DEF mess:PTR TO intuimessage,type
    DEF tick=0
    handle:=SvL_AllocHandle(NIL)
    IF handle
        retval:=SvL_InitHandleAsDOS(handle,NIL)
        IF retval=0
            retval:=SvL_SetWindowIDCMP(handle,IDCMP_INTUITICKS OR IDCMP_RAWKEY,NIL)
            IF retval=0
                /*
                retval:=SvL_SetScreenType(handle,WBENCHSCREEN+PUBLICSCREEN,NIL)
                IF retval=0
                */
                    WriteF('SuperView() ?\n')
                    retval:=SvL_SuperView(handle,name)
                    WriteF('SuperView() ok\n')
                    IF retval=0
                        retval:=SvL_GetWindowAddress(handle,{w},NIL)
                        IF retval=0
                            IF w
                                start:
                                WHILE mess:=Gt_GetIMsg(w.userport)
                                    type:=mess.class
                                    SELECT type
                                        CASE IDCMP_RAWKEY; IF mess.code=69 THEN JUMP end
                                        CASE IDCMP_INTUITICKS
                                            tick:=tick+1
                                            IF tick=50 THEN JUMP end
                                    ENDSELECT
                                    Gt_ReplyIMsg(mess)
                                ENDWHILE
                                JUMP start
                                end:
                            ENDIF
                        ELSE
                            WriteF('\s\n',SvL_GetErrorString(retval))
                        ENDIF
                    ELSE
                        WriteF('\s\n',SvL_GetErrorString(retval))
                    ENDIF
                /*
                ELSE
                    WriteF('\s\n',SvL_GetErrorString(retval))
                ENDIF
                */
            ELSE
                WriteF('\s\n',SvL_GetErrorString(retval))
            ENDIF
        ELSE
            WriteF('\s\n',SvL_GetErrorString(retval))
        ENDIF
        SvL_FreeHandle(handle)
    ELSE
        WriteF('Alloc handle failed.\n')
    ENDIF
ENDPROC
/**/
/*"p_ListObj()"*/
PROC p_ListObj()
   DEF l:PTR TO lh
   DEF n:PTR TO ln
   DEF o:PTR TO svobjectinfo
   DEF of:PTR TO svobjectinfo
   DEF retval
   retval:=SvL_GetSVObjectList({o})
   IF retval=0
        of:=o
        WHILE (o)
            WriteF('Name:\l\s[24] SubTypeCode:\d[2]\n',o.typename,o.type)
            o:=o.nextentry
        ENDWHILE
        SvL_FreeSVObjectList(of)
    ELSE
        WriteF('\s\n',SvL_GetErrorString(retval))
    ENDIF
ENDPROC
/**/
/*"p_ConvertImage(s,d,t)"*/
PROC p_ConvertImage(s,d,t) HANDLE
    DEF retval
    DEF h_s=NIL,h_d=NIL
    DEF s_screen=NIL,s_window=NIL
    /*=== Source Allocation ===*/
    h_s:=SvL_AllocHandle(NIL)
    IF h_s=NIL THEN Raise(ER_HANDLE)
    /*=========================*/
    retval:=SvL_InitHandleAsDOS(h_s,NIL)
    IF retval<>0 THEN Raise(retval)
    /*=========================*/
    retval:=SvL_SetWindowIDCMP(h_s,IDCMP_MOUSEBUTTONS+IDCMP_VANILLAKEY,NIL)
    IF retval<>0 THEN Raise(retval)
    /*=========================*/
    retval:=SvL_SetScreenType(h_s,CUSTOMSCREEN,NIL)
    IF retval<>0 THEN Raise(retval)
    retval:=SvL_SuperView(h_s,s)
    IF retval<>0 THEN Raise(retval)
    retval:=SvL_GetScreenAddress(h_s,{s_screen},NIL)
    IF retval<>0 THEN Raise(retval)
    retval:=SvL_GetWindowAddress(h_s,{s_window},NIL)

    /*=== Destination Allocation ===*/
    h_d:=SvL_AllocHandle(NIL)
    IF h_d=NIL THEN Raise(ER_HANDLE)
    retval:=SvL_InitHandleAsDOS(h_d,NIL)
    IF retval<>0 THEN Raise(retval)
    retval:=SvL_SetWriteType(h_d,t,NIL)
    IF retval<>0 THEN Raise(retval)
    retval:=SvL_SetWriteName(h_d,d,NIL)
    IF retval<>0 THEN Raise(retval)
    retval:=SvL_SetWriteScreen(h_d,s_screen,NIL)
    IF retval<>0 THEN Raise(retval)
    retval:=SvL_SuperWrite(h_d)
    IF retval<>0 THEN Raise(retval)
    Delay(150)
    IF h_d 
        /*SvL_FreeResources(h_d)*/
        SvL_FreeHandle(h_d)
    ENDIF
    IF h_s 
        /*SvL_FreeResources(h_s)*/
        SvL_FreeHandle(h_s)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF exception<>ER_NONE
        WriteF('\s\n',SvL_GetErrorString(exception))
        IF h_d THEN SvL_FreeHandle(h_d)
        IF h_s THEN SvL_FreeHandle(h_s)
    ENDIF
    RETURN exception
ENDPROC
/**/

