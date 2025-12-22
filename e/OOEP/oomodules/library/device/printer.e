OPT MODULE
OPT OSVERSION=37
OPT EXPORT

-> NOTE: some modifications to this by JEVR3
-> All 'self.open()' statements changed to reflect use of 'new()'

MODULE  'devices/printer', 'exec/devices', 'exec/io', 'exec/nodes',
        'exec/ports','exec/devices',
        'oomodules/library/device'

OBJECT printer OF device
/****** printer/--printer-- ******************************************

    NAME 
        printer of device

    PURPOSE
        To provide basic means to control every printer.

    CREATION
        Back in February of 1995  by Gregor Goldbach

    HISTORY
        some minor modifications by Trey
******************************************************************************

History


*/
ENDOBJECT

-> JEVR3 addition: init() sets default name and unit for printer.device.

PROC init() OF printer
/****** printer/init ******************************************

    NAME 
        init() -- Initialization of the object.

    SYNOPSIS
        printer.init()

    FUNCTION
        Set default name and unit.
******************************************************************************

History


*/
 self.identifier:={defaultPrinter}
 self.unit:=0
ENDPROC

PROC rawwrite(zkette,laenge) OF printer
/****** printer/rawwrite ******************************************

    NAME 
        rawwrite() -- Printing chars without esc substitution.
    SYNOPSIS
        printer.rawwrite(PTR TO CHAR, LONG)

    FUNCTION
        Sends the characters to the printer. Esc-sequences will not be
        substituted. Opens the printer.device if necessary.

    INPUTS
        PTR TO CHAR -- The characters to print

        LONG -- The number of characters to print

******************************************************************************

History


*/

-> JEVR3 modification; removed surrounding IF/ENDIF; now in open() itself
-> Also tests to insure device opened.

  IF self.open()

    self.io::iostd.data := zkette
    self.io::iostd.length := laenge
    self.io::iostd.command := PRD_RAWWRITE

    self.doio()

    self.lasterror := self.io.error
  ENDIF
ENDPROC

PROC write(zkette,laenge) OF printer
/****** printer/write ******************************************

    NAME 
        write() -- Printing chars with esc substitution.
    SYNOPSIS
        printer.write(PTR TO CHAR, LONG)

    FUNCTION
        Sends the characters to the printer. Esc-sequences will be
        substituted. Opens the printer.device if necessary.

    INPUTS
        PTR TO CHAR -- The characters to print

        LONG -- The number of characters to print

******************************************************************************

History


*/
-> JEVR3 modification; removed surrounding IF/ENDIF; now in open() itself
-> Added test to see if it actually opened.

  IF self.open()


    self.io::iostd.data := zkette
    self.io::iostd.length := laenge

    self.io::iostd.command := CMD_WRITE

    self.doio()

    self.lasterror := self.io.error
  ENDIF
ENDPROC

PROC xcommand(kommando,p0=NIL,p1=NIL,p2=NIL,p3=NIL) OF printer
/****** printer/xcommand ******************************************

    NAME 
        xcommand() -- execute printer command.

    SYNOPSIS
        printer.xcommand(LONG, LONG=NIL, LONG=NIL, LONG=NIL, LONG=NIL)

    FUNCTION
        Executes a printer command with the given parameters such as setting
        left and right border, justification etc.
        Opens the printer.device if necessary.

    INPUTS
        command:LONG -- the printer command to be executed
        param0-3:LONG -- command parameters

******************************************************************************

History

DESCRIPTION


*/

-> JEVR3 modification; removed surrounding IF/ENDIF; now in open() itself
-> Added test to see if it actually opened.

  IF self.open()

  self.io::ioprtcmdreq.prtcommand := kommando
  self.io::ioprtcmdreq.parm0 := p0
  self.io::ioprtcmdreq.parm1 := p1
  self.io::ioprtcmdreq.parm2 := p2
  self.io::ioprtcmdreq.parm3 := p3
  self.io.command := PRD_PRTCOMMAND
  self.doio()

  ENDIF

ENDPROC

PROC graphicdump(rport,cmap,vmodes,srcx,srcy,srcwidth,srcheight,destcols,destrows,special) OF printer
/****** printer/graphicdump ******************************************

    NAME 
        graphicdump() -- Print a part of a rastport.

    SYNOPSIS
        printer.graphicdump(10 LONGs)

    FUNCTION
        It prints a part of a rastport.

    INPUTS
        rport -- the RastPort containing the image to print
        cmap -- screen's ColorMap
        vmodes -- ViewModes of the screen
        srcx,srcy,
        srcwidth,
        srcheight -- source dimensions: start point & width & height
        destcols,
        destrows    - dimensions on the printer in points
        Special     - special flags

******************************************************************************

History


*/

-> JEVR3 modification; removed surrounding IF/ENDIF; now in open() itself
-> Added test to make sure device was opened.

 IF self.open()
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
 ENDIF

ENDPROC

-> JEVR3 addition: strings for the default printer.

defaultPrinter:
 CHAR 'printer.device',0
/*EE folds
-1
12 20 16 18 19 36 22 37 25 41 28 48 
EE folds*/
