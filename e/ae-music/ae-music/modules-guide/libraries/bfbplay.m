ShowModule v1.10 (c) 1992 $#%!
now showing: "bfbplay.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT modinfo
(   0)   mi_moduletype:CHAR
(   1)   mi_playflag:CHAR
(   2)   mi_bufferptr:PTR TO modinfo
(   6)   mi_samplebufferptr:PTR TO modinfo
(  10)   mi_bufferlen:LONG
(  14)   mi_samplebufferlen:LONG
(  18)   mi_positions:INT
(  20)   mi_songs:INT
(  22)   mi_currentposition:INT
(  24)   mi_currentsong:INT
(  26)   mi_moduletypename:PTR TO modinfo
(  30)   mi_modulename:PTR TO modinfo
(  34)   mi_samplenamebuffer:PTR TO modinfo
(  38)   mi_samplenamebufferlen:LONG
(----) ENDOBJECT     /* SIZEOF=76 */

CONST BFBTAG_ModType=$8001F010,
      BFBTAG_ModInfo=$8001F007,
      MODTYPE_WHITTAKER=8,
      MODTYPE_MED=4,
      MODTYPE_STARTREKKER=17,
      BFBERR_TAGERR=-17,
      MODTYPE_THEPLAYER60A=2,
      BFBERR_NOMEDLIB=-4,
      BFBERR_NOPSIDLIB=-5,
      BFBTAG_SongBuf=$8001F003,
      BFBERR_020ERR=-14,
      MODTYPE_HIPPELCOSO=12,
      MODTYPE_PRORUNNER2=16,
      MODTYPE_THEPLAYER61A=1,
      MODTYPE_THX=11,
      BFBTAG_SongName=$8001F001,
      BFBTAG_SampleName=$8001F004,
      BFBTAG_SongBufLen=$8001F008,
      BFBTAG_SampleBufLen=$8001F009,
      BFBERR_NOEMULRES=-9,
      BFBERR_NOSUBLIB=-2,
      BFBERR_NOAUDIO=-12,
      BFBERR_NOERROR=0,
      BFBERR_FILEERROR=-7,
      BFBTAG_SampleBuf=$8001F006,
      MODTYPE_OKTALYZER=10,
      BFBERR_LOWKICK=-16,
      BFBTAG_SampleFH=$8001F005,
      MODTYPE_PSID=9,
      BFBERR_THXERR=-15,
      MODTYPE_NOMODULE=-1,
      BFBERR_NOMODULE=-1,
      MODTYPE_TRACKERPACKER3=14,
      MODTYPE_NOISEPACKER3=18,
      MODTYPE_SOUNDTRACKER4=15,
      BFBERR_NOCIA=-13,
      MODTYPE_DIGIBOOSTER=6,
      MODTYPE_XPKPACKED=$63,
      BFBTAG_SongFH=$8001F002,
      BFBERR_NOMEMORY=-8,
      MODTYPE_PROTRACKER=3,
      BFBERR_NOXPKERR=-3,
      MODTYPE_QUADRACOMPOSER=5,
      BFBERR_NOFILE=-6,
      BFBERR_LIBINUSE=-18,
      MODTYPE_BMOD=13,
      BFBERR_P60AINITERR=-10,
      BFBERR_P61AINITERR=-11,
      BFBERR_BMODERR=-19,
      MODTYPE_GMOD=7

