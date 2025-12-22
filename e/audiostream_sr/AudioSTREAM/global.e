/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     global.e
      Description:    general and debug macros,global declarations
      Version:    1.0
      Note:       Included TO ALL MODULES!
 --------------------------------------------------------------------
*/

/* This module controls the compilation. Many macros AND few functions
are defined here. They are common for ALL sources (including LIBS) */

      OPT MODULE
      OPT PREPROCESS
      OPT EXPORT


/*  DEBUG MACROS

    IF you want TO debug using CON window, define the macro
    CONDEBUG
*/
      #define CONDEBUG

      #ifdef CONDEBUG

      #define CDEBUG(text,arg) WriteF('text\n',arg)\

      #endif

      #ifndef CDEBUG
      #define CDEBUG(text,arg)
      #endif
      

->    #define OPENDEBUG Open('TEMP:AudioSTREAM_Debug.log',NEWFILE)
      #define OPENDEBUG Open('CON:////AudioSTREAM',NEWFILE)


/* ----------------------------------------------------------
                        Constants
   ---------------------------------------------------------- */

-> SPECIAL

#define UPDON  upd:=TRUE
#define UPDOFF upd:=FALSE
#define LOCK   lck:=TRUE
#define UNLOCK lck:=FALSE
#define RXON   rxm:=TRUE
#define RXOFF  rxm:=FALSE
#define CHANGED setchanged(TRUE)

#define SLEEP set (_appl.app,MUIA_Application_Sleep,MUI_TRUE)
#define AWAKE set (_appl.app,MUIA_Application_Sleep,FALSE)


-> AREXX RETURN CODES


-> ERROR CODES

ENUM ERR_OK,ERR_NOTFOUND,ERR_NOMEM,ERR_NOPMEM,ERR_READ,ERR_WRITE,
     ERR_IMP,ERR_LCK,ERR_AUD,ERR_CANTOPEN,ERR_UNRECOGNIZED,ERR_FSTRUCT,
     ERR_SCBE,ERR_STDMEO,ERR_16ONLY,ERR_PLAYER,ERR_MPEGA,ERR_MPSTREAM


-> Parameter selectors constants
-> -----------------------------

-> obj_song:

ENUM SGANNOT,SGTEMPO,SGLEFTVOL,SGRIGHTVOL,SGTRNSPS,SGDSPFLG

-> obj_track:

ENUM TRTEMPOC,TRLVOL,TRRVOL,TRCOMLS,TRDSPFLG,TRCHANNELS,TREXCL,TRCURCL

-> obj_channel:

ENUM CHTEMPOC,CHLINES

-> obj_sample:

ENUM SMFRAMES,SMTYPE,SMSTEREO,SMRATE,SMRNGSTART,SMRNGLEN,SMZOOM,SMOFFSET,SMRANGE,SMCURSOR

-> mpeg decoder:
ENUM MPSTART,MPEND,MPTYPE,MPSTEREO


-> Internal Command Interface (ICI) constants

/* There are two types OF constants, internal commands AND
command groups = IC_ AND CG_ */

ENUM CG_SYSTEM,CG_PLAYER,CG_DSP,CG_SED,CG_SONG,CG_TED,CG_DSP,CG_INST

-> GENERAL COMMANDS
ENUM IC_RENAME=1024,IC_GOFIRST,IC_GOLAST,IC_GOPREV,IC_GONEXT,IC_SETPARAM,
      IC_GETPARAM,IC_GUIINPUT,IC_SETACTIVEUSED,ICP_FLUSH



-> CG_SYSTEM commands
ENUM IC_QUIT,IC_UPDATEINFO,IC_UPDATEMAINTITLE,IC_SLEEP,IC_AWAKE,IC_FLUSHMEM,
      IC_SETMNAME,IC_SETMAUTHOR,IC_SETMANNOT,IC_STOP,IC_WAITPLMSG

-> CG_SONGS commands
ENUM IC_SPARAM,IC_SETSNAME,IC_SETACTIVE,IC_NEWSG,IC_DELSG,IC_DELALLSG,
      IC_NEXTSG,IC_PREVSG

-> CG_TED commands
ENUM IC_NEWT,IC_OCTAVE,
      IC_SETTPARAM,IC_SETCHPARAM,IC_JMPLINECH,IC_ACTIVATECH,IC_OPNTRNRNGWIN,
      IC_CHON,IC_EDITON,IC_SPCON,IC_DELT,IC_COPYT,IC_CUTT,IC_MCOPYRANGE,
      IC_MCOPYRANGEAL,IC_MCUTRANGE,IC_MCUTRANGEAL,IC_MPASTERANGE,IC_MCLEARRANGE,
      IC_MSELCHANNEL,IC_GPUTCMD,IC_SETCHPARAMISTR,
      IC_PASTET

-> CG_SED commands
ENUM  ICP1_SETPARAM,ICP_SCANRATE,IC_PLAY,IC_RNGALL,
      IC_SHOWRNG,IC_SHOWALL,IC_ZIN,IC_ZOUT,IC_PLAYRNG,IC_COPYRNG,IC_CUTRNG,
      IC_PASTERNG,IC_PLACERNG,IC_CLEARRNG,IC_ERASERNG,IC_REVRNG,ICP_SCROLLX,
      ICP_SCROLLY,IC_LOADSAMPLE,IC_DELSAMPLE,IC_SWPBYTEORDER,IC_CENTRALIZE,
      IC_SIGNEDUNSIGNED,IC_SAVESAMPLE,IC_LOCK,IC_UNLOCK,IC_PLAYCURSOR,
      IC_MPEGGETFILE,IC_MPEGPARAM,IC_MPEGSTART,IC_MPEGABORT,ICP_ADDSAMPLE,
      IC_CVOL,IC_CVOLDOUBLE,IC_CVOLHALVE,IC_CVOLMAX


