OPT MODULE
OPT EXPORT, PREPROCESS

MODULE '*easyRexx'
MODULE 'easyrexx','libraries/easyrexx','libraries/easyrexx_macros'
MODULE 'utility/tagitem','fw/wbObject'

ENUM AREXX_1=1,AREXX_2,AREXX_3,AREXX_4,AREXX_5

OBJECT myRexx OF easyRexx
ENDOBJECT

PROC open() OF myRexx HANDLE
  IF easyrexxbase=NIL THEN Raise(0)
  self.create(
            [AREXX_1, 'RAZ',   '', NIL,
             AREXX_2, 'DWA',   '', NIL,
             AREXX_3, 'TRZY',  '', NIL,
             AREXX_4, 'CZTERY','', NIL,
             AREXX_5, 'PIEC',  '', NIL,
             TABLE_END
            ]:arexxcommandtable,
            [ER_Author,       'Piotr Gapiïski',
             ER_Copyright,    '© 1996 Piotr Gapiïski',
             ER_Version,      'FWtest v1.0',
             ER_Portname,     'FWTEST',
             TAG_DONE
            ])
  IF self.context=NIL THEN Raise(0)
EXCEPT
  self.remove()
ENDPROC

CONST MAXLONG=2147483647
PROC handleMessage(msg: PTR TO arexxcontext) OF myRexx
  DEF id
  DEF result=NIL,resultstring=NIL,error=NIL
  DEF resultlong=MAXLONG

  IF GetARexxMsg(msg)=1
    id:=msg.id

    WriteF('rexx message ID = \d\n',id)

    ReplyARexxMsgA(msg,[ER_ReturnCode,result,
       IF resultstring        THEN ER_ResultString ELSE TAG_IGNORE,resultstring,
       IF resultlong<>MAXLONG THEN ER_ResultLong ELSE TAG_IGNORE,resultlong,
       IF error               THEN ER_ErrorMessage ELSE TAG_IGNORE,error,
                              TAG_DONE])
  ENDIF
ENDPROC PASS
