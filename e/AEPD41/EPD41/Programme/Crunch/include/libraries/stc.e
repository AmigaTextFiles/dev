
->         Stc.e,  by Bluebird

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE  'exec/libraries'

#define STCNAME 'stc.library'

CONST STCVERSION = 3,
      S403   = 0,
      S404   = 1,
   
      PHNOHEADER = 1,
      PHNOMATCH = 2,
      PHUNIT  = 3,
      PHNAME  = 4,
      PHREHEADER = 5,
      PHOVERLAY = 6,
      PHBREAK  = 7,
      PHHUNKID  = 8,

      SEEXEC  = 0,
      SEPEXEC  = 1,
      SELIBRARY = 2,
      SEOVERLAY = 3,
      SEABSOLUTE = 4,

      ISEXEC  = $80000000,
      ISDATA  = $40000000,
      ISS403  = $20000000,
      ISS404  = $10000000,
      ISNPEXEC  = $01000000,
      ISLPEXEC  = $02000000,
      ISNABS  = $03000000,
      ISPABS  = $04000000,
      ISKABS  = $05000000,
      ISSKIPMASK = $00FFFFFF,
      ISINFOMASK = $FF000000,
      ISERRORMASK = $00FFFFFF,


      STC_TAGBASE = $80000000,

  /* CrunchDataTags Tags */
      CDDESTINATION = $80000000+$01,
      CDLENGTH   = $80000000+$02,
      CDABORTFLAGS = $80000000+$03,
      CDOUTPUTFLAGS = $80000000+$04,
      CDXPOS   = $80000000+$05,
      CDYPOS   = $80000000+$06,
      CDRASTPORT  = $80000000+$07,
      CDMSGPORT  = $80000000+$08,
      CDDISTBITS  = $80000000+$09,
      CDBUFFER   = $80000000+$0A,
      CDOUTPUTNIL  = 0,
      CDOUTPUTCLI  = 1,
      CDOUTPUTWIN  = 2,
      CDABORTNIL  = 0,
      CDABORTGADGET = 1,
      CDABORTCTRLC = 2,
      CDDIST1K   = 10,
      CDDIST2K   = 11,
      CDDIST4K   = 12,
      CDDIST8K   = 13,
      CDDIST16K  = 14,

  /* SaveExecTags Tags */
      SXSAVETYPE  = $80000000+$0B,
      SXFILENAME  = $80000000+$0C,
      SXDATABUFFER = $80000000+$0D,
      SXLENGTH   = $80000000+$0E,
      SXLOAD   = $80000000+$0F,
      SXJUMP   = $80000000+$10,
      SXDECR   = $80000000+$11,
      SXUSP    = $80000000+$12,
      SXSSP    = $80000000+$13,
      SXSR    = $80000000+$14,
      SXDATA   = 0,
      SXPEXEC   = 1,
      SXPEXECLIB  = 2,
      SXABSNORMAL  = 3,
      SXABSPLAIN  = 4,
      SXABSKILLSYSTEM= 5;


  /* Nur für ältere Library Versionen. Nicht mehr benutzen */

   OBJECT crunchinfo
          filelength: LONG
          buffer: PTR TO LONG
          filebuffer: PTR TO LONG
          msgport: PTR TO LONG  /*  Falls NIL, kein Ereignischeck  */
          rastport: PTR TO LONG
          gfxbase: PTR TO LONG  /*  Falls NIL, kein Crunchcounter  */
          xpos: INT
          ypos: INT
   ENDOBJECT

   OBJECT stcbase
     libnode: lib
     dosbase: PTR TO LONG
     seglist: LONG
     flags: LONG
     pad: LONG
   ENDOBJECT


  /* Nur für Kompatibilität. Nicht Lesen oder Schreiben */
DEF firstbuffer: PTR TO LONG,
    buffersize: LONG,
    securitylen: LONG,

  /* Diese Fehlermeldung ist GLOBAL. In den meisten Fällen ist sie mit
    dem Ergebnis der Funktion IOErr identisch.
    Beachte: Greifen mehrere Tasks auf die stc.library zu, so kann der
             erhaltene Wert nicht immer der richtige sein. */
   errormsg: LONG,

   stcbase: PTR TO stcbase;

