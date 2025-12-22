/*

Dies ist ein schnuckeliger Set von trackdisk-Routinen. Benutzung nur auf
eigene Gefahr.

Eläuterungen: s. Dokumentation
Idee: Intern
Copyright: Keins. Macht damit, was Ihr wollt.
Geschrieben von: Gregor Goldbach alias Glotter Giger, 1993

*/

PROC trackdisk_open(laufwerksnummer)
DEF ioreq:PTR TO ioexttd,meinport:mp,fehler

  IF((laufwerksnummer < 0) OR (laufwerksnummer >3))
    RETURN(-1)
  ELSE
	meinport := CreateMsgPort()
	IF (meinport = NIL)
	  RETURN(-2)
	ENDIF
	ioreq := CreateIORequest(meinport, SIZEOF ioexttd)
	IF (ioreq = NIL)
	  DeleteMsgPort(meinport)
	  RETURN(-3)
	ENDIF
	fehler := OpenDevice('trackdisk.device',laufwerksnummer,ioreq,0)
	IF(fehler)
	  DeleteIORequest(ioreq)
	  DeleteMsgPort(meinport)
	  RETURN(-4)
	ELSE
	  RETURN(ioreq)
	ENDIF
  ENDIF
ENDPROC

PROC trackdisk_close(ioreq)
DEF ioreq2:PTR TO ioexttd,ios:iostd,nn:mn

  ioreq2 := ioreq
  CloseDevice(ioreq) /* device schließen */
  DeleteIORequest(ioreq) /* ioreq löschen */
  ios := ioreq2.iostd
  nn := ios.mn
  DeleteMsgPort(nn.replyport) /* ioreq.iostd.mn.replyport abmelden */
  ioreq := 0 /* ausnullen, damit es nicht noch einmal verwendet wird */

ENDPROC

PROC trackdisk_motor(ior,flag)
DEF ios:iostd,io2:PTR TO ioexttd
  io2 := ior
  ios := io2.iostd
  IF flag THEN ios.length := 1 ELSE ios.length := 0
   /* ior.iostd.length := 1 -> Motor an */
   /* ior.iostd.length := 0 -> Motor aus */
  ios.command := TD_MOTOR /* ior.iostd.command := TD_MOTOR */
  DoIO(ior)
ENDPROC


PROC trackdisk_getchangenum(ior)
DEF io2:PTR TO ioexttd,ios:iostd
  io2:=ior
  ios := io2.iostd
  ios.command := TD_CHANGENUM /* ior.iostd.command := TD_CHANGENUM */
  DoIO(ior)
  RETURN ios.actual /* ior.iostd.actual hier steht nach DoIO die Nummer drin */
ENDPROC

PROC trackdisk_readblock(ior,nummer)
DEF io2:PTR TO ioexttd,ios:iostd,slabelpuffer[16]:STRING
  io2 := ior
  ios := io2.iostd
  io2.count := trackdisk_getchangenum(ior)
  ios.offset := nummer*512
  /* der Offset wird in Bytes angegeben, ein Block = 512 Bytes */
  ios.data := blockpuffer
  ios.length := TD_SECTOR
  io2.seclabel := slabelpuffer
  /* vor jedem Block stehen noch 16 Bytes, sog. Label */
  ios.command := ETD_READ /* ior.iostd.command := ETD_READ */
  DoIO(ior)
ENDPROC


PROC trackdisk_writeblock(ior,nummer)
DEF io2:PTR TO ioexttd,ios:iostd,slabelpuffer[16]:STRING,laufvar
  FOR laufvar := 0 TO 15 DO slabelpuffer[laufvar]:=0
  /* labelpuffer mit Nullen beschreiben, da das Label des Blocks normaler-
     weise immer 0000000000000000 ist */
    
  io2 := ior
  ios := io2.iostd
  io2.count := trackdisk_getchangenum(ior)
  ios.offset := nummer*512 /* s. readblock*/
  ios.data := blockpuffer
  ios.length := TD_SECTOR
  io2.seclabel := slabelpuffer
  ios.command := ETD_WRITE /* ior.iostd.command := ETD_WRITE */
  DoIO(ior)
  ios.command := ETD_UPDATE
  /* nicht nur in den internen Puffer schreiben, sondern sofort abspeichern */
  DoIO(ior) /* tu's jetzt! */
ENDPROC


PROC trackdisk_diskindrive(ior)
/* ist eine Diskette im Laufwerk ? */
DEF io2:PTR TO ioexttd,ios:iostd

  io2 := ior
  ios := io2.iostd
  ios.command := TD_CHANGESTATE /* ior.iostd.command := TD_CHANGESTATE */
  DoIO(ior)
  IF(ios.actual = 0) THEN RETURN(TRUE) ELSE RETURN(FALSE)
  /* wenn eine Diskette drin ist, ist ioreq.iostd.actual == 0! */

ENDPROC

PROC trackdisk_diskprotected(ior)
/* ist die Diskette schreibgeschützt ? */
DEF io2:PTR TO ioexttd,ios:iostd
    
  io2 := ior
  ios := io2.iostd
  ios.command := TD_PROTSTATUS /* ior.iostd.command := TD_PROTSTATUS */
  DoIO(ior)
  RETURN(ios.actual)

ENDPROC
