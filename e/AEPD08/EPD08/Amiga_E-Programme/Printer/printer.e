/*

Einige Routinen zur ·einfachen· Druckerbenutzung.
Nur im Paket weiterzugeben. Freeeware. Hubs.
(c) + (p) 1994 Gregor Goldbach

*/

MODULE 'devices/printer', 'exec/devices', 'exec/io', 'exec/nodes',
		'exec/ports','exec/devices', 'intuition/intuition',
		'intuition/intuitionbase','graphics/gfxbase','graphics/view'

PROC printer_open()
/*
	Öffnen des voreingestellten Druckers.
	Das Ergebnis dieser Funktion wird bei den Übrigen benötigt.

	Erste lauffähig Version: 15-Apr-1994

	Autor: Gregor Goldbach

	Anmerkungen:

	Um alle Arten des Ausdruck über das printer.device zu ermöglichen, wird
	der größte Device-Block allokiert (IODumpRastPortREQuest).

	Parameter:

	-

	Ergebnis:

	>0		- Zeiger auf voll initialisierten Device-Block
	-2		- Fehler bei CreateMsgPort()
	-3		- Fehler bei CreateIORequest()
	-4		- Fehler bei OpenDevice()

*/

DEF ioreq:PTR TO iodrpreq,
	meinport:mp,fehler

  meinport := CreateMsgPort()
  IF (meinport = NIL)
	RETURN(-2)
  ENDIF
  ioreq := CreateIORequest(meinport, SIZEOF iodrpreq)
  IF (ioreq = NIL)
	DeleteMsgPort(meinport)
	RETURN(-3)
  ENDIF
  fehler := OpenDevice('printer.device',0,ioreq,0)
  IF(fehler)
	DeleteIORequest(ioreq)
	DeleteMsgPort(meinport)
	RETURN(-4)
  ELSE
	RETURN(ioreq)
  ENDIF
ENDPROC

PROC printer_close(ioreq)
/*
	Schließen des durch printer_open() geöffneten Druckers

	Erste lauffähig Version: 15-Apr-1994

	Autor: Gregor Goldbach

	Anmerkungen:

	Die große Anzahl von Variablen wird benötigt, da der zur Zeit der
	Entwicklung vorliegende Compiler (v2.1b) keine rekursiven Zugriffe auf
	Variablen zuließ (z.B. ioreq.io.mn.replyport).
	Der Parameter wird 'ausgenullt'.

	Parameter:

	ioreq		- Ergebnis von printer_open()

	Ergebnis:

	0
*/

DEF ioreq2:PTR TO iodrpreq,ios:iostd,nn:mn

  ioreq2 := ioreq
  CloseDevice(ioreq)
  DeleteIORequest(ioreq)
  ios := ioreq2.io
  nn := ios.mn
  DeleteMsgPort(nn.replyport)
  ioreq := 0

  RETURN ioreq
ENDPROC

PROC printer_rawwrite(ioreq,zkette,laenge)
/*
	Ausgabe von Text ohne Ersetzen von Escape-Sequenzen auf den voreinge-
	stellten Drucker.

	Erste lauffähig Version: 15-Apr-1994

	Autor: Gregor Goldbach

	Anmerkungen:

	Läuft über normalen IOStdReq

	Parameter:

	ioreq		- Ergebnis von printer_open()
	zkette		- Adresse der auszugebenden Zeichenkette
	laenge		- Länge der auszugebenden Zeichenkette

	Ergebnis:

	Fehler -- kein Fehler = 0

*/
DEF io2:PTR TO iostd

  io2 := ioreq
  io2.data := zkette
  io2.length := laenge
  io2.command := PRD_RAWWRITE
  DoIO(io2)

  RETURN(io2.error)

ENDPROC

PROC printer_write(ioreq,zkette,laenge)
/*
	Ausgabe von Text mit Ersetzen von Escape-Sequenzen auf den voreinge-
	stellten Drucker.

	Erste lauffähig Version: 15-Apr-1994

	Autor: Gregor Goldbach

	Anmerkungen:

	Läuft über normalen IOStdReq

	Parameter:

	ioreq		- Ergebnis von printer_open()
	zkette		- Adresse der auszugebenden Zeichenkette
	laenge		- Länge der auszugebenden Zeichenkette

	Ergebnis:

	Fehler -- kein Fehler = 0

*/
DEF io2:PTR TO iostd

  io2 := ioreq
  io2.data := zkette
  io2.length := laenge
  io2.command := CMD_WRITE
  DoIO(io2)

  RETURN(io2.error)

ENDPROC


PROC printer_command(ioreq,kommando,p0,p1,p2,p3)
/*
	Senden eines Kommandos an den voreingestellten Drucker.

	Erste lauffähig Version: 15-Apr-1994

	Autor: Gregor Goldbach

	Anmerkungen:

	Läuft über IOPrtCmdReq

	Parameter:

	ioreq		- Ergebnis von printer_open()
	kommando	- Nummer des Kommandos (oder die Konstante)
	p0-p3		- Parameter für das Kommando

	Ergebnis:

	Fehler -- kein Fehler = 0

*/
DEF io2:PTR TO ioprtcmdreq, ios:PTR TO iostd

  io2 := ioreq
  ios := io2.io
  io2.prtcommand := kommando
  io2.parm0 := p0
  io2.parm1 := p1
  io2.parm2 := p2
  io2.parm3 := p3
  ios.command := PRD_PRTCOMMAND
  DoIO(io2)

  RETURN(ios.error)

ENDPROC


PROC printer_graphicdump(ioreq,rport,cmap,vmodes,srcx,srcy,srcwidth,srcheight,destcols,destrows,special)
/*
	Ausdruck eines Ausschnitts des Rastports.

	Erste lauffähig Version: 15-Apr-1994

	Autor: Gregor Goldbach

	Anmerkungen:

	scrwidth = destcols und scrheight = destrows --> Bildschirm = Ausdruck

	Parameter:

	ioreq		- Ergebnis von printer_open()
	rport		- der auszudruckende RastPort
	cmap		- die ColorMap
	vmodes		- ViewModes des Screens
	srcx,srcy,
	srcwidth,
	srcheight	- Dimensionen des Ausschnitts: Startpunkt & Breite & Höhe
	destcols,
	destrows	- Druckbreite auf dem Drucker in Punkten
	Special		- Special-Flags

	Ergebnis:

	Fehler -- kein Fehler = 0

*/
DEF io2:PTR TO iodrpreq, ios:PTR TO iostd

  io2 := ioreq
  io2.rastport	:= rport
  io2.colormap	:= cmap
  io2.modes 	:= vmodes
  io2.srcx		:= srcx
  io2.srcy		:= srcy
  io2.srcwidth	:= srcwidth
  io2.srcheight	:= srcheight
  io2.destcols	:= destcols
  io2.destrows	:= destrows
  io2.special	:= special

  ios := io2.io
  ios.command := PRD_DUMPRPORT
  DoIO(io2)

  RETURN(ios.error)
ENDPROC




PROC main()
DEF drucker_request:PTR TO iodrpreq,

	ibase : PTR TO intuitionbase,
	win:PTR TO window,
	v:PTR TO view,
	vp:PTR TO viewport,
	gbase:PTR TO gfxbase

  drucker_request := printer_open()

/*
  printer_command(drucker_request,60,20,0,0,0) /* linken rand setzen */
  printer_write(drucker_request,'Tach!',5)
  printer_command(drucker_request,2,0,0,0,0) /* linefeed */
  printer_command(drucker_request,2,0,0,0,0)
  printer_command(drucker_request,2,0,0,0,0)
  printer_write(drucker_request,'[3mHI[0m',10)
*/

  WriteF('3 Sekunden... aktives Fenster wird dann gedruckt')
  Delay(150)
  gbase := gfxbase
  ibase := intuitionbase
  win := ibase.activewindow
  v := gbase.actiview
  vp := v.viewport
  WriteF('Fehler:\d\n',  printer_graphicdump(drucker_request,win.rport,vp.colormap,vp.modes,0,0,100,100,100,100,0))

  printer_close(drucker_request)

  WriteF('Drucker: \d\n', drucker_request)
ENDPROC
