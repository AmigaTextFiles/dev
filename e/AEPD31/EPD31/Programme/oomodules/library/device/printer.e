OPT MODULE
OPT OSVERSION=37
OPT EXPORT

MODULE  'devices/printer', 'exec/devices', 'exec/io', 'exec/nodes',
        'exec/ports','exec/devices',
        'oomodules/library/device'

/*

  V2.0 12.4.95  made it fit to 'Object'
                NEW <name>.new() runs fine, the rest should work, too.
*/

OBJECT printer OF device
ENDOBJECT

PROC name() OF printer IS 'Printer'

PROC init() OF printer
  self.name := 'printer.device'
ENDPROC

PROC rawwrite(zkette,laenge) OF printer
/*

METHOD

  rawwrite(string,len)

INPUTS

  string - the characters to be printed, 0-terminated
  len - number of characters

DESCRIPTION

  Sends the characters to the printer. Esc-sequences will not be substituted.
  Opens the printer.device if necessary.
*/

  IF self.io=NIL THEN self.open('printer.device',0,0)

  IF self.io

    self.io::iostd.data := zkette
    self.io::iostd.length := laenge
    self.io::iostd.command := PRD_RAWWRITE

    self.doio()

    self.lasterror := self.io.error
  ENDIF
ENDPROC

PROC write(zkette,laenge) OF printer
/*

METHOD

  rawwrite(string,len)

INPUTS

  string - the characters to be printed, 0-terminated
  len - number of characters

DESCRIPTION

  Sends the characters to the printer. Esc-sequences will be substituted.
  Opens the printer.device if necessary.
*/

  IF self.io=NIL THEN self.open('printer.device',0,0)

  IF self.io

    self.io::iostd.data := zkette
    self.io::iostd.length := laenge

    self.io::iostd.command := CMD_WRITE

    self.doio()

    self.lasterror := self.io.error
  ENDIF
ENDPROC

PROC xcommand(kommando,p0=NIL,p1=NIL,p2=NIL,p3=NIL) OF printer
/*

METHOD

  xcommand(command,param0,param1,param2,param3)

INPUTS

  command - the printer command to be executed (s. devices/printer)
  param0-3 - command parameters

DESCRIPTION

  Executes a printer command with the given parameters such as setting
  left and right border, justification etc.
  Opens the printer.device if necessary.

*/

  IF self.io=NIL THEN self.open('printer.device',0,0)

  self.io::ioprtcmdreq.prtcommand := kommando
  self.io::ioprtcmdreq.parm0 := p0
  self.io::ioprtcmdreq.parm1 := p1
  self.io::ioprtcmdreq.parm2 := p2
  self.io::ioprtcmdreq.parm3 := p3
  self.io.command := PRD_PRTCOMMAND
  self.doio()

ENDPROC

PROC graphicdump(rport,cmap,vmodes,srcx,srcy,srcwidth,srcheight,destcols,destrows,special) OF printer
/*

METHOD

  graphicdump(params)

INPUTS

    rport       - the RastPort containing the image
    cmap        - screen's ColorMap
    vmodes      - ViewModes of the screen
    srcx,srcy,
    srcwidth,
    srcheight   - dimensionen: start point & width & height
    destcols,
    destrows    - dimensions on the printer in points
    Special     - special flags

DESCRIPTION

  Prints a part of the rastport.
  Opens the printer.device if necessary.

*/

  IF self.io=NIL THEN self.open('printer.device',0,0)

  self.io::iodrpreq.rastport    := rport
  self.io::iodrpreq.colormap    := cmap
  self.io::iodrpreq.modes   := vmodes
  self.io::iodrpreq.srcx        := srcx
  self.io::iodrpreq.srcy        := srcy
  self.io::iodrpreq.srcwidth    := srcwidth
  self.io::iodrpreq.srcheight   := srcheight
  self.io::iodrpreq.destcols    := destcols
  self.io::iodrpreq.destrows    := destrows
  self.io::iodrpreq.special := special

  self.io.command := PRD_DUMPRPORT
  self.doio()

ENDPROC
