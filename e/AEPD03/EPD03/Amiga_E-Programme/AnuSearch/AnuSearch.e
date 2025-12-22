/* Anubis-Suchprogramm in Amiga E © TOB 1993 */
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/* OBJECTS */
/*|||*/

OBJECT ob_brett
 name[20]:ARRAY,
 brettpfad[60]:ARRAY,
 diskpfad[80]:ARRAY,
 passwort[16]:ARRAY,
 verwalter[16]:ARRAY,
 leselevel:CHAR,
 schreiblevel:CHAR,
 maxmsg:LONG,
 typ:INT,
 date:LONG,
 gruppe:LONG,
 infoline[60]:ARRAY,
 nettyp:LONG,
 special:LONG,
 bytelimit:LONG,
 kosten:LONG,
 pad[20]:ARRAY
ENDOBJECT

OBJECT ob_index
 absender[80]:ARRAY,
 betreff[80]:ARRAY,
 kurzbetreff[60]:ARRAY,
 size:LONG,
 edate:LONG,
 qdate:LONG,
 ldate:LONG,
 typ:LONG,
 nr:LONG,
 nrbrett:LONG,
 mode:LONG,
 count:LONG,
 special:LONG,
 msgid[60]:ARRAY,
 bezug[60]:ARRAY,
 pad[40]:ARRAY
ENDOBJECT

/*|||*/
/* KONSTANTEN */
/*|||*/

/* Konstanten für Brettdaten */

CONST BRETTCOUNT=304
CONST BTYPE_ASCII=0,BTYPE_BIN=1,BTYPE_NET=2,BTYPE_BDIR=3

/* Konstanten für Indexdaten */

CONST INDEXCOUNT=420
CONST IMODE_READ=0,IMODE_PROT=1,IMODE_DEL=2

/*|||*/
/* VARIABLEN */
/*|||*/

/* Variablen für Brettdaten */

DEF brettliste=NIL,brettlaenge=0,brettanzahl=0,brett=NIL:PTR TO ob_brett

/* Variablen für Indexdaten */

DEF indexliste=NIL,indexlaenge=0,indexanzahl=0,index=NIL:PTR TO ob_index

/*|||*/
/* PROZEDUREN */
PROC main()
/*|||*/
 DEF str[80]:STRING,ok
 brettliste_laden()
 IF brettanzahl=0 THEN RETURN
 REPEAT
  WriteF('\n\nSearch vE1.0 © TOB 1993\n')
  WriteF('\nSuchstring : ')
  ok:=ReadStr(stdout,str)
  IF StrLen(str)>0 THEN suchen(str)
 UNTIL StrLen(str)=0
 CleanUp(0)
ENDPROC
/*|||*/
PROC brettliste_laden()
/*|||*/
 DEF handle,name,flen=TRUE
 name:='Anubis:Daten/Brettliste'
 IF (flen:=FileLength(name))=-1 THEN RETURN
 IF (brettliste:=New(flen+1))=NIL THEN RETURN
 IF (handle:=Open(name,1005))=NIL THEN RETURN
 brettlaenge:=Read(handle,brettliste,flen)
 Close(handle)
 IF brettlaenge<flen THEN RETURN
 brettanzahl:=(brettlaenge/BRETTCOUNT)-1
ENDPROC
/*|||*/
PROC index_laden(pfad)
/*|||*/
 DEF handle,name[86]:STRING,flen=TRUE
 StringF(name,'\s\s',pfad,'/Index')
 indexanzahl:=0
 IF indexliste<>NIL THEN Dispose(indexliste)
 IF (flen:=FileLength(name))=-1 THEN RETURN
 IF (indexliste:=New(flen+1))=NIL THEN RETURN
 IF (handle:=Open(name,1005))=NIL THEN RETURN
 indexlaenge:=Read(handle,indexliste,flen)
 Close(handle)
 IF indexlaenge<flen THEN RETURN
 indexanzahl:=(indexlaenge/INDEXCOUNT)-1
ENDPROC
/*|||*/
PROC suchen(suchstr)
/*|||*/
 DEF i,j,pfad[80]:STRING,hstr1,hstr2
 DEF bshow
 UpperStr(suchstr)
 FOR i:=0 TO brettanzahl
  brett:=brettliste+(i*BRETTCOUNT)
  pfad:=brett.diskpfad
  index_laden(pfad)
  bshow:=FALSE
  IF indexanzahl>0
   FOR j:=0 TO indexanzahl
    index:=indexliste+(j*INDEXCOUNT)
    hstr1:=String(80)
    hstr2:=String(60)
    StrAdd(hstr1,index.betreff,ALL)
    StrAdd(hstr2,index.kurzbetreff,ALL)
    UpperStr(hstr1)
    UpperStr(hstr2)
    IF (InStr(hstr1,suchstr,0)>=0) OR (InStr(hstr2,suchstr,0)>=0)
     IF bshow=FALSE
      IF StrLen(brett.brettpfad)=0 THEN WriteF('\n/\s\n',brett.name) ELSE WriteF('\n/\s/\s\n',brett.brettpfad,brett.name)
      bshow:=TRUE
     ENDIF
     WriteF('\d[3] \l\s[30] \l\s[30]\n',j+1,index.betreff,index.kurzbetreff)
    ENDIF
    IF CtrlC() THEN CleanUp(5)
   ENDFOR
  ENDIF
 ENDFOR
ENDPROC
/*|||*/

/*
        mfG,
            TOB


He who reads many fortunes gets confused.
*/

