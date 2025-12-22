/* Anubis-Top20 Amiga E © TOB 1993 */

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
CONST ITYPE_ASC=0,ITYPE_BIN=1

/*|||*/
/* VARIABLEN */
/*|||*/
/* Variablen für Brettdaten */

DEF brettliste=NIL,brettlaenge=0,brettanzahl=0,brett=NIL:PTR TO ob_brett

/* Variablen für Indexdaten */

DEF indexliste=NIL,indexlaenge=0,indexanzahl=0,index=NIL:PTR TO ob_index

/*|||*/

OBJECT ob_top
 betreff:LONG,
 kurz:LONG,
 zug:LONG
ENDOBJECT

DEF top20[20]:ARRAY OF ob_top

PROC main()
 WriteF('Anubis-Top20 - Amiga_E-Shellversion 1.1 - © TOB 1993\n')
 WriteF('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
 brettliste_laden()
 IF brettanzahl=0 THEN RETURN
 get_top20()
 ausgabe()
 CleanUp(0)
ENDPROC

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
PROC get_top20()
/*|||*/
 DEF i,j,pfad[80]:STRING,name[80]:STRING
 name:=UpperStr(name)
 FOR i:=0 TO 19
  top20[i].zug:=0
  top20[i].betreff:=String(80)
  top20[i].kurz:=String(60)
 ENDFOR
 FOR i:=0 TO brettanzahl
  brett:=brettliste+(i*BRETTCOUNT)
  pfad:=brett.diskpfad
  index_laden(pfad)
  IF indexlaenge>0
   FOR j:=0 TO indexanzahl
    index:=indexliste+(j*INDEXCOUNT)
    IF (index.count>top20[19].zug) AND (index.typ=ITYPE_BIN) THEN sethigh()
   ENDFOR
  ENDIF
 ENDFOR
ENDPROC
/*|||*/
PROC sethigh()
/*|||*/
 DEF i,pos=-1
 IF index.count > 0
  pos:=posi(index.count)
  IF pos>=0
   FOR i:=19 TO (pos+1) STEP -1
    top20[i].zug:=top20[i-1].zug
    top20[i].betreff:=String(80)
    StrAdd(top20[i].betreff,top20[i-1].betreff,ALL)
    top20[i].kurz:=String(60)
    StrAdd(top20[i].kurz,top20[i-1].kurz,ALL)
   ENDFOR
   top20[pos].zug:=index.count
   top20[pos].betreff:=String(80)
   StrAdd(top20[pos].betreff,index.betreff,ALL)
   top20[pos].kurz:=String(60)
   StrAdd(top20[pos].kurz,index.kurzbetreff,ALL)
  ENDIF
 ENDIF
ENDPROC
/*|||*/
PROC posi(count)
/*|||*/
 DEF i,pos=-1
 FOR i:=19 TO 0 STEP -1
  IF count>top20[i].zug THEN pos:=i
 ENDFOR
ENDPROC pos
/*|||*/
PROC ausgabe()
/*|||*/
 DEF i
 WriteF('\s[3] \s[3] \l\s[30] \l\s[30]\n','Nr.','Zgr','Filename','Beschreibung')
 WriteF('\s[79]\n','~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
 FOR i:=0 TO 19
  WriteF('\r\d[2]  \r\d[3] \l\s[30] \l\s[38]\n',(i+1),top20[i].zug,top20[i].betreff,top20[i].kurz)
 ENDFOR
ENDPROC
/*|||*/

/*
        mfG,
            TOB


He who reads many fortunes gets confused.

*/

