/* <<<ANUBIS ZSort V1.34 (Jul 15 1993 19:34:27) (C)1992/93; Oliver Graf
<<<Route : BLANKER
<<<Absendedatum : 13.08.93 11:36 */

/* Anubis-Interface für Amiga E © TOB 1993 */

/* OBJECTS */
/*|||*/

OBJECT ob_sys
 boxname[30]:ARRAY,
 pad1[122]:ARRAY,
 sysnode[10]:ARRAY,
 pad2[60]:ARRAY,
 user[16]:ARRAY,
 pad3[26]:ARRAY,
 pmpfad[20]:ARRAY,
 pad4[160]:ARRAY,
 toolpfad[30]:ARRAY
ENDOBJECT

OBJECT ob_user
 username[16]:ARRAY,
 passwort[16]:ARRAY,
 name[32]:ARRAY,
 strasse[40]:ARRAY,
 ort[32]:ARRAY,
 telnr[16]:ARRAY,
 rechner[16]:ARRAY,
 level:CHAR,
 umlaute:CHAR,
 status:CHAR,
 ansi:CHAR,
 vertreter[40]:ARRAY,
 lastcall:LONG,
 scandate:LONG,
 gruppe:LONG,
 updown:LONG,
 protokoll:LONG,
 dfrei:LONG,
 ansage[60]:ARRAY,
 zeilen:CHAR,
 csi:CHAR,
 special:LONG,
 flags:LONG,
 more:CHAR,
 konto:LONG,
 pad[20]:ARRAY,
 anrufe:LONG,
 gebdate[12]:ARRAY,
 txt_up:LONG,
 txt_down:LONG,
 bin_up:LONG,
 bin_down:LONG
ENDOBJECT

OBJECT ob_brett
 name[20]:ARRAY,
 brettpfad[60]:ARRAY,
 diskpfad[80]:ARRAY,
 passwort[16]:ARRAY,
 verwalter[16]:ARRAY,
 leselevel:INT,
 schreiblevel:INT,
 maxmsg:INT,
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

/* Konstanten für Userdaten */

CONST USERCOUNT=364
CONST UML_AMIGA=0,UML_IBM=1,UML_SIMULATION=2
CONST USR_GAST=0,USR_SAUGER=1,USR_USER=2,USR_COSYSOP=3,USR_SYSOP=4

/* Konstanten für Brettdaten */

CONST BRETTCOUNT=304
CONST BTYPE_ASCII=0,BTYPE_BIN=1,BTYPE_NET=2,BTYPE_BDIR=3

/* Konstanten für Indexdaten */

CONST INDEXCOUNT=420
CONST IMODE_READ=0,IMODE_PROT=1,IMODE_DEL=2

/*|||*/

/* VARIABLEN */
/*|||*/

/* Variablen für Userdaten */

DEF userliste=0,userlaenge=0,useranzahl=0,user:ob_user

/* Variablen für Brettdaten */

DEF brettliste=0,brettlaenge=0,brettanzahl=0,brett:ob_brett

/* Variablen für Indexdaten */

DEF indexliste=0,indexlaenge=0,indexanzahl=0,index:ob_index

/*|||*/

PROC main()
 brettliste_laden()
 IF brettliste=NIL THEN RETURN
 brettliste_anzeigen()
ENDPROC

PROC userliste_laden()
/*|||*/
 DEF handle,name,flen=TRUE
 name:='Anubis:Daten/Userliste'
 IF (flen:=FileLength(name))=-1 THEN RETURN
 IF (userliste:=New(flen+1))=NIL THEN RETURN
 IF (handle:=Open(name,1005))=NIL THEN RETURN
 userlaenge:=Read(handle,userliste,flen)
 Close(handle)
 IF userlaenge<flen THEN RETURN
 useranzahl:=(userlaenge/USERCOUNT)-1
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
 DEF handle,name,flen=TRUE
 name:=StrAdd(pfad,'/Index',ALL)
 IF (flen:=FileLength(name))=-1 THEN RETURN
 IF (indexliste:=New(flen+1))=NIL THEN RETURN
 IF (handle:=Open(name,1005))=NIL THEN RETURN
 indexlaenge:=Read(handle,indexliste,flen)
 Close(handle)
 IF indexlaenge<flen THEN RETURN
 indexanzahl:=(indexlaenge/INDEXCOUNT)-1
ENDPROC
/*|||*/
PROC index_freigeben()
/*|||*/
 Dispose(indexliste)
ENDPROC
/*|||*/
PROC userliste_speichern()
/*|||*/
ENDPROC
/*|||*/
PROC user_lesen(name)
/*|||*/
 DEF tname[16]:STRING,i=-1,mem=0,data:ob_user
 REPEAT
  i++
  mem:=userliste+(i*USERCOUNT)
  tname:=mem
 UNTIL (i>=useranzahl) OR StrCmp(name,tname,16)
 IF i<useranzahl THEN data:=mem
ENDPROC data
/*|||*/
PROC userliste_anzeigen()
/*|||*/
 DEF i,j,name[16]:STRING
 FOR i:=0 TO useranzahl
  name:=userliste+(i*USERCOUNT)
  WriteF('\s\n',name)
 ENDFOR
ENDPROC
/*|||*/
PROC brettliste_anzeigen()
/*|||*/
 DEF i,j,name[20]:STRING,pfad[80]:STRING
 FOR i:=0 TO brettanzahl
  pfad:=brettliste+(i*BRETTCOUNT)+20
  name:=brettliste+(i*BRETTCOUNT)
  IF StrLen(pfad)=0 THEN WriteF('/\s\n',name) ELSE WriteF('/\s/\s\n',pfad,name)
 ENDFOR
ENDPROC
/*|||*/


/*        mfG,
            TOB


He who reads many fortunes gets confused.
- AnurEad v0.95a - © 1993 TOB -
*/

