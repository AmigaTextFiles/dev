' identify-example 1
' Version : $Id: identify_1.bas V0.9
' Compiler:	HBC 2.0+
' Includes:	3.1
' Author:   steffen@styx.muc.de
' Status:   Freeware

'******************************************************************************

DEFLNG a-z

REM $JUMPS
REM $NOWINDOW
REM $NOLIBRARY
REM $NOSTACK
REM $NOARRAY
REM $NOLINES
REM $NOVARCHECKS
REM $NOAUTODIM

REM $INCLUDE exec.bh
REM $INCLUDE dos.bh
REM $INCLUDE utility.bh
REM $INCLUDE identify.bh

LIBRARY OPEN "identify.library"

'******************************************************************************


DIM tags&(4&)
TAGLIST VARPTR(tags&(0&)), _
	IDTAG_Localize&, TRUE&, _
TAG_END&


PRINT "      System: "; PEEK$(IdHardware&(IDHW_SYSTEM&, VARPTR(tags&(0&)))); _
						" ("; PEEK$(IdHardware&(IDHW_CPU&, VARPTR(tags&(0&)))); "/"; _
						PEEK$(IdHardware&(IDHW_FPU&, VARPTR(tags&(0&)))); "/"; _
						PEEK$(IdHardware&(IDHW_MMU&, VARPTR(tags&(0&)))); ")"

PRINT "     AmigaOS: "; PEEK$(IdHardware&(IDHW_OSNR&, VARPTR(tags&(0&)))); _
						" (Kickstart "; PEEK$(IdHardware&(IDHW_OSVER&, VARPTR(tags&(0&)))); _
						", Workbench "; PEEK$(IdHardware&(IDHW_WBVER&, VARPTR(tags&(0&)))); ")"
      
PRINT "         RAM: "; PEEK$(IdHardware&(IDHW_RAM&, VARPTR(tags&(0&)))); _
						" (CHIP "; PEEK$(IdHardware&(IDHW_CHIPRAM&, VARPTR(tags&(0&)))); _
						", FAST "; PEEK$(IdHardware&(IDHW_FASTRAM&, VARPTR(tags&(0&)))); ")"
      
PRINT "  GFX-System: "; PEEK$(IdHardware&(IDHW_GFXSYS&, VARPTR(tags&(0&))))

PRINT "Audio-System: "; PEEK$(IdHardware&(IDHW_AUDIOSYS&, VARPTR(tags&(0&))))



IF IdHardwareNum&(IDHW_TCPIP&, NULL&) <> IDTCP_NONE&
	PRINT "TCP/IP-Stack: "; PEEK$(IdHardware&(IDHW_TCPIP&, VARPTR(tags&(0&))))
END IF


'******************************************************************************

SYSTEM RETURN_OK&

'******************************************************************************

DATA "$VER: identify_1 V0.9 (05-08-98) "