/* Converted from Georg Hörmann's original C includes.
**
** All structures and functions are exactly the same spelling as
** in the C-Includes. If it was not directly possible directly (because of
** restrictions of Amiga E) macros are added.
** Thanks to Dietmar Eilert for his GoldED making this conversation an
** easy job.
**
** Added the originally coments. (Sometimes very usefull)
** Replaced all #defines by CONSTs whenever possible
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

/* Converted from Georg Hörmann's original by DII. Comments have been
   removed to save space. */

MODULE 'exec/libraries'

OBJECT xfdMasterBase
  libnode:lib                
  seglist                         /* PRIVATE! */
  dosbase                         /* May be used for I/O etc. */
  firstslave                      /* List of available slaves */
  firstforeman,                   /* PRIVATE! */
  minbuffersize                   /* (V36) Min. BufSize for xfdRecogBuffer() */
  minlinkersize                   /* (V36) Min. BufSize for xfdRecogLinker() */
ENDOBJECT

CONST   XFDM_VERSION=37           /* for OpenLibrary() */
#define XFDM_NAME 'xfdmaster.library'

/***************************
*                          *
*    Object Types (V36)    *
*                          *
***************************/

CONST XFDOBJ_BUFFERINFO  = 1,     /* xfdBufferInfo structure */
      XFDOBJ_SEGMENTINFO = 2,     /* xfdSegmentInfo structure */
      XFDOBJ_LINKERINFO  = 3,     /* xfdLinkerInfo structure */
      XFDOBJ_SCANNODE    = 4,     /* (V37) xfdScanNode structure */
      XFDOBJ_SCANHOOK    = 5,     /* (V37) xfdScanHook structure */
      XFDOBJ_MAX         = 5      /* PRIVATE! */

OBJECT xfdBufferInfo
  xfdbi_SourceBuffer              /* Pointer to source buffer */
  xfdbi_SourceBufLen              /* Length of source buffer */
  xfdbi_Slave                     /* PRIVATE! */
  xfdbi_PackerName:PTR TO CHAR    /* Name of recognized packer */
  xfdbi_PackerFlags:INT           /* Flags for recognized packer */
  xfdbi_Error:INT                 /* Error return code */
  xfdbi_TargetBuffer              /* Pointer to target buffer */
  xfdbi_TargetBufMemType          /* Memtype of target buffer */
  xfdbi_TargetBufLen              /* Full length of buffer */
  xfdbi_TargetBufSaveLen          /* Used length of buffer */
  xfdbi_DecrAddress               /* Address to load decrunched file */
  xfdbi_JmpAddress                /* Address to jump in file */
  xfdbi_Special                   /* Special decrunch info (eg. password) */
  xfdbi_Flags:INT                 /* (V37) Flags to influence recog/decr */
ENDOBJECT

#define xfdbi_MaxSpecialLen xfdbi_Error /* Max. length of special info */

/*********************
*                    *
*    Segment Info    *
*                    *
*********************/

OBJECT xfdSegmentInfo
  xfdsi_SegList                   /* BPTR to segment list */
  xfdsi_Slave                     /* PRIVATE! */
  xfdsi_PackerName:PTR TO CHAR    /* Name of recognized packer */
  xfdsi_PackerFlags:INT           /* Flags for recognized packer */
  xfdsi_Error:INT                 /* Error return code */
  xfdsi_Special                   /* Special decrunch info (eg. password) */
  xfdsi_RelMode:INT               /* (V34) Relocation mode */
  xfdsi_Flags:INT                 /* (V37) Flags to influence recog/decr */
ENDOBJECT

#define xfdsi_MaxSpecialLen xfdsi_Error /* Max. length of special info */

/**************************
*                         *
*    Linker Info (V36)    *
*                         *
**************************/

OBJECT xfdLinkerInfo
  xfdli_Buffer                    /* Pointer to buffer */
  xfdli_BufLen                    /* Length of buffer */
  xfdli_LinkerName:PTR TO CHAR    /* Name of recognized linker */
  xfdli_Unlink                    /* PRIVATE! */
  xfdli_Reserved:INT              /* Set to NULL */
  xfdli_Error:INT                 /* Error return code */
  xfdli_Hunk1                     /* PRIVATE! */
  xfdli_Hunk2                     /* PRIVATE! */
  xfdli_Amount1                   /* PRIVATE! */
  xfdli_Amount2                   /* PRIVATE! */
  xfdli_Save1                     /* Pointer to first unlinked file */
  xfdli_Save2                     /* Pointer to second unlinked file */
  xfdli_SaveLen1                  /* Length of first unlinked file */
  xfdli_SaveLen2                  /* Length of second unlinked file */
ENDOBJECT

/************************
*                       *
*    Scan Node (V37)    *
*                       *
************************/

OBJECT xfdScanNode
  xfdsn_Next                      /* Pointer to next xfdScanNode or NULL */
  xfdsn_Save                      /* Pointer to data */
  xfdsn_SaveLen                   /* Length of data */
  xfdsn_PackerName:PTR TO CHAR    /* Name of recognized packer */
  xfdsn_PackerFlags:INT           /* Flags for recognized packer */
ENDOBJECT

/************************
*                       *
*    Scan Hook (V37)    *
*                       *
************************/

OBJECT xfdScanHook
  xfdsh_Entry                     /* Entrypoint of hook code */
  xfdsh_Data                      /* Private data of hook */
  xfdsh_ToDo                      /* Bytes still to scan (READ ONLY) */
  xfdsh_ScanNode                  /* Found data right now (or NULL) (READ ONLY) */
ENDOBJECT

/********************
*                   *
*    Error Codes    *
*                   *
********************/

CONST XFDERR_OK              = $0000, /* No errors */

      XFDERR_NOMEMORY        = $0001, /* Error allocating memory */
      XFDERR_NOSLAVE         = $0002, /* No slave entry in info structure */
      XFDERR_NOTSUPPORTED    = $0003, /* Slave doesn't support called function */
      XFDERR_UNKNOWN         = $0004, /* Unknown file */
      XFDERR_NOSOURCE        = $0005, /* No sourcebuffer/seglist specified */
      XFDERR_WRONGPASSWORD   = $0006, /* Wrong password for decrunching */
      XFDERR_BADHUNK         = $0007, /* Bad hunk structure */
      XFDERR_CORRUPTEDDATA   = $0008, /* Crunched data is corrupted */
      XFDERR_MISSINGRESOURCE = $0009, /* (V34) Missing resource (eg. library) */
      XFDERR_WRONGKEY        = $000a, /* (V35) Wrong 16/32 bit key */
      XFDERR_BETTERCPU       = $000b, /* (V37) Better CPU required */
      XFDERR_HOOKBREAK       = $000c, /* (V37) Hook caused break */
      XFDERR_DOSERROR        = $000d, /* (V37) Dos error */

      XFDERR_UNDEFINEDHUNK   = $1000, /* (V34) Undefined hunk type */
      XFDERR_NOHUNKHEADER    = $1001, /* (V34) File is not executable */
      XFDERR_BADEXTTYPE      = $1002, /* (V34) Bad hunk_ext type */
      XFDERR_BUFFERTRUNCATED = $1003, /* (V34) Unexpected end of file */
      XFDERR_WRONGHUNKAMOUNT = $1004, /* (V34) Wrong amount of hunks */
      XFDERR_NOOVERLAYS      = $1005, /* (V36) Overlays not allowed */

      XFDERR_UNSUPPORTEDHUNK = $2000, /* (V34) Hunk type not supported */
      XFDERR_BADRELMODE      = $2001  /* (V34) Unknown XFDREL_#? mode */

/*******************************
*                              *
*    Relocation Modes (V34)    *
*                              *
*******************************/

CONST XFDREL_DEFAULT   = $0000, /* Use memory types given by hunk_header */
      XFDREL_FORCECHIP = $0001, /* Force all hunks to chip ram */
      XFDREL_FORCEFAST = $0002  /* Force all hunks to fast ram */

/*************************************
*                                    *
*    Values for xfd??_PackerFlags    *
*                                    *
*************************************/

/* Bit numbers */
CONST XFDPFB_RELOC    = 0,        /* Relocatible file packer */
      XFDPFB_ADDR     = 1,        /* Absolute address file packer */
      XFDPFB_DATA     = 2,        /* Data file packer */

      XFDPFB_PASSWORD = 4,        /* Packer requires password */
      XFDPFB_RELMODE  = 5,        /* (V34) Decruncher supports xfdsi_RelMode */
      XFDPFB_KEY16    = 6,        /* (V35) Packer requires 16 bit key */
      XFDPFB_KEY32    = 7,        /* (V35) Packer requires 32 bit key */

      XFDPFB_EXTERN   = 15        /* (V37) PRIVATE */

/* Bit masks */
CONST XFDPFF_RELOC    = %0000000000000001, ->was (1<<XFDPFB_RELOC)
      XFDPFF_ADDR     = %0000000000000010, ->was (1<<XFDPFB_ADDR)
      XFDPFF_DATA     = %0000000000000100, ->was (1<<XFDPFB_DATA)

      XFDPFF_PASSWORD = %0000000000010000, ->was (1<<XFDPFB_PASSWORD)
      XFDPFF_RELMODE  = %0000000000100000, ->was (1<<XFDPFB_RELMODE)
      XFDPFF_KEY16    = %0000000001000000, ->was (1<<XFDPFB_KEY16)
      XFDPFF_KEY32    = %0000000010000000, ->was (1<<XFDPFB_KEY32)

      XFDPFF_EXTERN   = %1000000000000000  ->was (1<<XFDPFB_EXTERN)

/************************************
*                                   *
*    Values for xfd??_Flags (V37)   *
*                                   *
************************************/

/* Bit numbers */
CONST XFDPFB_RECOGEXTERN = 0      /* Use external slaves for xfdRecog#?() */

/* Bit masks */
CONST XFDPFF_RECOGEXTERN = %0000000000000001  ->was (1<<XFDPFB_RECOGEXTERN)

/****************************************************
*                                                   *
*    Flags for xfdTestHunkStructureFlags() (V36)    *
*                                                   *
****************************************************/

/* Bit numbers */
CONST XFDTHB_NOOVERLAYS = 0       /* Abort on hunk_overlay */

/* Bit masks */
CONST XFDTHF_NOOVERLAYS = %0000000000000001  ->was (1<<XFDTHB_NOOVERLAYS)

/****************************************
*                                       *
*    Flags for xfdStripHunks() (V36)    *
*                                       *
****************************************/

/* Bit numbers */
CONST XFDSHB_NAME   = 0,          /* Strip hunk_name */
      XFDSHB_SYMBOL = 1,          /* Strip hunk_symbol */
      XFDSHB_DEBUG  = 2           /* Strip hunk_debug */

/* Bit masks */
CONST XFDSHF_NAME   = %0000000000000001, ->was  (1<<XFDSHB_NAME)
      XFDSHF_SYMBOL = %0000000000000010, ->was  (1<<XFDSHB_SYMBOL)
      XFDSHF_DEBUG  = %0000000000000100  ->was  (1<<XFDSHB_DEBUG)

/**************************************
*                                     *
*    Flags for xfdScanData() (V37)    *
*                                     *
**************************************/

/* Bit numbers */
CONST XFDSDB_USEEXTERN = 0,       /* Use external slaves for scanning */
      XFDSDB_SCANODD   = 1        /* Scan at odd addresses too */

/* Bit masks */
CONST XFDSDF_USEEXTERN = %0000000000000001, ->was  (1<<XFDSDB_USEEXTERN)
      XFDSDF_SCANODD   = %0000000000000010  ->was  (1<<XFDSDB_SCANODD)

/****************
*               *
*    Foreman    *
*               *
****************/

OBJECT xfdForeMan
  xfdf_Security                   /* moveq #-1,d0 ; rts */
  xfdf_ID                         /* Set to XFDF_ID */
  xfdf_Version:INT                /* Set to XFDF_VERSION */
  xfdf_Reserved:INT               /* Not used by now, set to NULL */
  xfdf_Next                       /* PRIVATE! */
  xfdf_SegList                    /* PRIVATE! */
  xfdf_FirstSlave                 /* First slave (see below) */
ENDOBJECT

CONST XFDF_ID="XFDF",
      XFDF_VERSION=1

/**************
*             *
*    Slave    *
*             *
**************/

OBJECT xfdSlave
  xfds_Next                       /* Next slave (or NULL) */
  xfds_Version:INT                /* Set to XFDS_VERSION */
  xfds_MasterVersion:INT          /* Minimum XFDM_VERSION required */
  xfds_PackerName:PTR TO CHAR     /* Name of packer ('\0' terminated) */
  xfds_PackerFlags:INT            /* Flags for packer */
  xfds_MaxSpecialLen:INT          /* Max. length of special info (eg. password) */
  xfds_RecogBuffer                /* APTR to buffer recognition code (or NULL) */
  xfds_DecrunchBuffer             /* APTR to buffer decrunch code (or NULL) */
  xfds_RecogSegment               /* APTR to segment recognition code (or NULL) */
  xfds_DecrunchSegment            /* APTR to segment decrunch code (or NULL) */
  xfds_SlaveID:INT                /* (V36) Slave ID (only internal slaves) */
  xfds_ReplaceID:INT              /* (V36) ID of slave to be replaced */
  xfds_MinBufferSize              /* (V36) Min. BufSize for RecogBufferXYZ() */
ENDOBJECT

#define xfds_ScanData xfds_RecogSegment         /* (V37) XFDPFB_DATA: Scan code (or NULL) */
#define xfds_VerifyData xfds_DecrunchSegment    /* (V37) XFDPFB_DATA: Verify code (or NULL) */

CONST XFDS_VERSION=2

/*********************************
*                                *
*    Internal Slave IDs (V36)    *
*                                *
*********************************/

CONST XFDID_BASE                      = $8000,

      XFDID_PowerPacker23             = $8001,
      XFDID_PowerPacker30             = $8003,
      XFDID_PowerPacker30Enc          = $8005,
      XFDID_PowerPacker30Ovl          = $8007,
      XFDID_PowerPacker40             = $8009,
      XFDID_PowerPacker40Lib          = $800a,
      XFDID_PowerPacker40Enc          = $800b,
      XFDID_PowerPacker40LibEnc       = $800c,
      XFDID_PowerPacker40Ovl          = $800d,
      XFDID_PowerPacker40LibOvl       = $800e,
      XFDID_PowerPackerData           = $800f,
      XFDID_PowerPackerDataEnc        = $8010,
      XFDID_ByteKiller13              = $8011,
      XFDID_ByteKiller20              = $8012,
      XFDID_ByteKiller30              = $8013,
      XFDID_ByteKillerPro10           = $8014,
      XFDID_ByteKillerPro10Pro        = $8015,
      XFDID_DragPack10                = $8016,
      XFDID_TNMCruncher11             = $8017,
      XFDID_HQCCruncher20             = $8018,
      XFDID_RSICruncher14             = $8019,
      XFDID_ANCCruncher               = $801a,
      XFDID_ReloKit10                 = $801b,
      XFDID_HighPressureCruncher      = $801c,
      XFDID_STPackedSong              = $801d,
      XFDID_TSKCruncher               = $801e,
      XFDID_LightPack15               = $801f,
      XFDID_CrunchMaster10            = $8020,
      XFDID_HQCCompressor100          = $8021,
      XFDID_FlashSpeed10              = $8022,
      XFDID_CrunchManiaData           = $8023,
      XFDID_CrunchManiaDataEnc        = $8024,
      XFDID_CrunchManiaLib            = $8025,
      XFDID_CrunchManiaNormal         = $8026,
      XFDID_CrunchManiaSimple         = $8027,
      XFDID_CrunchManiaAddr           = $8028,
      XFDID_DefJamCruncher32          = $8029,
      XFDID_DefJamCruncher32Pro       = $802a,
      XFDID_TetraPack102              = $802b,
      XFDID_TetraPack11               = $802c,
      XFDID_TetraPack21               = $802d,
      XFDID_TetraPack21Pro            = $802e,
      XFDID_TetraPack22               = $802f,
      XFDID_TetraPack22Pro            = $8030,
      XFDID_DoubleAction10            = $8031,
      XFDID_DragPack252Data           = $8032,
      XFDID_DragPack252               = $8033,
      XFDID_FCG10                     = $8034,
      XFDID_Freeway07                 = $8035,
      XFDID_IAMPacker10ATM5Data       = $8036,
      XFDID_IAMPacker10ATM5           = $8037,
      XFDID_IAMPacker10ICEData        = $8038,
      XFDID_IAMPacker10ICE            = $8039,
      XFDID_Imploder                  = $803a,
      XFDID_ImploderLib               = $803b,
      XFDID_ImploderOvl               = $803c,
      XFDID_FileImploder              = $803d,
      XFDID_MasterCruncher30Addr      = $803f,
      XFDID_MasterCruncher30          = $8040,
      XFDID_MaxPacker12               = $8041,
      XFDID_PackIt10Data              = $8042,
      XFDID_PackIt10                  = $8043,
      XFDID_PMCNormal                 = $8044,
      XFDID_PMCSample                 = $8045,
      XFDID_XPKPacked                 = $8046,
      XFDID_XPKCrypted                = $8047,
      XFDID_TimeCruncher17            = $8048,
      XFDID_TFACruncher154            = $8049,
      XFDID_TurtleSmasher13           = $804a,
      XFDID_MegaCruncher10            = $804b,
      XFDID_MegaCruncher12            = $804c,
      XFDID_ProPack                   = $804d,
      XFDID_ProPackData               = $804e,
      XFDID_ProPackDataKey            = $804f,
      XFDID_STCruncher10              = $8050,
      XFDID_STCruncher10Data          = $8051,
      XFDID_SpikeCruncher             = $8052,
      XFDID_SyncroPacker46            = $8053,
      XFDID_SyncroPacker46Pro         = $8054,
      XFDID_TitanicsCruncher11        = $8055,
      XFDID_TitanicsCruncher12        = $8056,
      XFDID_TryItCruncher101          = $8057,
      XFDID_TurboSqueezer61           = $8058,
      XFDID_TurboSqueezer80           = $8059,
      XFDID_TurtleSmasher200          = $805a,
      XFDID_TurtleSmasher200Data      = $805b,
      XFDID_StoneCracker270           = $805c,
      XFDID_StoneCracker270Pro        = $805d,
      XFDID_StoneCracker292           = $805e,
      XFDID_StoneCracker299           = $805f,
      XFDID_StoneCracker299d          = $8060,
      XFDID_StoneCracker300           = $8061,
      XFDID_StoneCracker300Data       = $8062,
      XFDID_StoneCracker310           = $8063,
      XFDID_StoneCracker310Data       = $8064,
      XFDID_StoneCracker311           = $8065,
      XFDID_StoneCracker400           = $8066,
      XFDID_StoneCracker400Data       = $8067,
      XFDID_StoneCracker401           = $8068,
      XFDID_StoneCracker401Data       = $8069,
      XFDID_StoneCracker401Addr       = $806a,
      XFDID_StoneCracker401BetaAddr   = $806b,
      XFDID_StoneCracker403Data       = $806c,
      XFDID_StoneCracker404           = $806d,
      XFDID_StoneCracker404Data       = $806e,
      XFDID_StoneCracker404Addr       = $806f,
      XFDID_ChryseisCruncher09        = $8070,
      XFDID_QuickPowerPacker10        = $8071,
      XFDID_GNUPacker12               = $8072,
      XFDID_GNUPacker12Seg            = $8073,
      XFDID_GNUPacker12Data           = $8074,
      XFDID_TrashEliminator10         = $8075,
      XFDID_MasterCruncher30Data      = $8076,
      XFDID_SuperCruncher27           = $8077,
      XFDID_UltimatePacker11          = $8078,
      XFDID_ProPackOld                = $8079,
      XFDID_SACFPQCruncher            = $807a,
      XFDID_PowerPackerPatch10        = $807b

/* Because in Amiga E all function-calls must start with a capital letter
** followed by a lowercase one I added here some macros to replace the
** function-calls.
*/

#define xfdAllocBufferInfo         XfdAllocBufferInfo
#define xfdFreeBufferInfo          XfdFreeBufferInfo
#define xfdAllocSegmentInfo        XfdAllocSegmentInfo
#define xfdFreeSegmentInfo         XfdFreeSegmentInfo
#define xfdRecogBuffer             XfdRecogBuffer
#define xfdDecrunchBuffer          XfdDecrunchBuffer
#define xfdRecogSegment            XfdRecogSegment
#define xfdDecrunchSegment         XfdDecrunchSegment
#define xfdGetErrorText            XfdGetErrorText
#define xfdTestHunkStructure       XfdTestHunkStructure
/*
** New for V34
*/
#define xfdTestHunkStructureNew    XfdTestHunkStructureNew
#define xfdRelocate                XfdRelocate
/*
** New for V36
*/
#define xfdTestHunkStructureFlags  XfdTestHunkStructureFlags
#define xfdStripHunks              XfdStripHunks
#define xfdAllocObject             XfdAllocObject
#define xfdFreeObject              XfdFreeObject
#define xfdRecogLinker             XfdRecogLinker
#define xfdUnlink                  XfdUnlink
/*
** New for V37
*/
#define xfdScanData                XfdScanData
#define xfdFreeScanList            XfdFreeScanList
#define xfdObjectType              XfdObjectType
#define xfdInitScanHook            XfdInitScanHook

/* Macro for the librarybase */
#define XFDMasterBase              xfdmasterbase

