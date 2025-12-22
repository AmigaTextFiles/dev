
->             CrM.e,  by Bluebird

OPT MODULE
OPT EXPORT
OPT PREPROCESS

#define CRMNAME 'CrM.library'

CONST CRMVERSION  = 4,
      CM_NORMAL    = 1,
      CM_LZH       = 2,
      CMB_SAMPLE   = 4,
      CMF_SAMPLE   = 16,
      CMB_PW       = 5,
      CMF_PW       = 32,
      CMB_OVERLAY  = 8,       /* nur für den */
      CMF_OVERLAY  = 256,     /* CMCS_Algo Tag! */
      CMB_LEDFLASH = 9,       /* nur für den */
      CMF_LEDFLASH = 512,     /* CMCS_Algo Tag! */

/* Bentze diese Maske um den Crunchalgorithmus zu bekommen, ohne andere Flags: */
      CM_ALGOMASK  = $F,

      CM_ADDPW     = 1,
      CM_REMOVEPW  = 2,
      CM_REMOVEALL = 3,

      CM_ENCRYPT   = 4,
      CM_DECRYPT   = 5,

      CM_ALLOCSTRUCT = 6,
      CM_FREESTRUCT  = 7,

      CM_TAGBASE    = $80000000,
      CMCS_ALGO     = $80000001,  /* Standard: CM_LZH */
      CMCS_OFFSET   = $80000002,  /* Standard: $7FFE */
      CMCS_HUFFSIZE = $80000003,  /* Standard: 16 */

   /* nur für älteren Code, NICHT in neuerem benutzen: */

   /* OrginalLen = OriginalLen; */
     CM_SAMPLE   = 16,
     CM_NORMSAMP = 17,
     CM_LZHSAMP  = 18


    OBJECT dataheader
      id: LONG
      minsecdist: INT
      originallen: LONG
      crunchedlen: LONG
    ENDOBJECT


    OBJECT currentstats
      toto: LONG
      len: LONG
    ENDOBJECT


    OBJECT crunchstruct
          src: PTR TO LONG   /* Source Start */
          srclen: LONG /* Source Len */
          dest: PTR TO LONG  /* Destination Start */
          destlen: LONG /* Destination Len (maximum) */
          datahdr: PTR TO dataheader /* DataHeader */
          displayhook: PTR TO LONG  /* Hook to display ToGo/Gain Counters */
 /** Die Register enthalten folgenden Werte, wenn der Hook aufgerufen wird: **/
 /** A0: p_Hook  A2: p_cmCrunchStruct  A1: p_cmCurrentStats **/
 /** In D0 muß TRUE/FALSE zurückgegeben werden, um das Crunchen abzubrechen/weiterzuführen **/
          displaystep: INT /* Zeit zwischen 2 Hook-Aufrufen */
         /******** nur Lesen: *********/
          offset: INT /* gewünschtes Offset */
          huffsize: INT /* HuffLen in KBytes */
          algo: INT  /* gewünschter Packalgorithmus */
          maxoffset: LONG /* größter möglicher Offset (allozierter Buffer) */
          realoffset: LONG /* gerade benutztes Offset */
          minsecdist: LONG /* MinSecDist für gepackte Data */
          crunchedlen: LONG /* Length der gepackten Data von cmcr_Dest */
           /******** Privat: *********/
          hufftabs: LONG
          huffbuf: LONG
          hufflen: LONG
          speedlen: LONG
          speedtab: LONG
          megaspeedtab: LONG
          quitflag: CHAR  /* nur Lesen: Grund für Fehler */
          overlayflag: CHAR
          ledflashFlag: CHAR
          pad: CHAR
 /* CrunchStruct geht hier weiter, aber HÄNDE WEG!!! */
         ENDOBJECT

DEF   crmbase: PTR TO LONG
