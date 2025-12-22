OPT MODULE, PREPROCESS
OPT EXPORT

ENUM PRELIM=1, COMPLETE, CONTINUE, TRANSIENT, ERROR

DEF typenames:PTR TO LONG,
    formnames:PTR TO LONG,
    strunames:PTR TO LONG,
    modenames:PTR TO LONG

ENUM TYPE_A=1, TYPE_E, TYPE_I, TYPE_L

#define _typenames ['0','ASCII','EBCDIC','Image','Local']

ENUM FORM_N=1, FORM_T, FORM_C

#define _formnames ['0','Nonprint','Telnet','Carriage-control']

ENUM STRU_F=1, STRU_R, STRU_P

#define _strunames ['0','File','Record','Page']

ENUM MODE_S=1, MODE_B, MODE_C

#define _modenames ['0','Stream','Block','Compressed']

PROC ftp_init_names()
  IF typenames=NIL
    typenames:=_typenames
    formnames:=_formnames
    strunames:=_strunames
    modenames:=_modenames
  ENDIF
ENDPROC

CONST REC_ESC=$FF,
      REC_EOR=1,
      REC_EOF=2

CONST BLK_EOR=$80,
      BLK_EOF=$40,
      BLK_ERRORS=$20,
      BLK_RESTART=$10,
      BLK_BYTECOUNT=2
