/*

OBJECT device

V1.2 by Gregor Goldbach with suggs by Trey van Riper

methods:

open()
close()
end()
doio()
sendio()
abortio()
reset()

*/



OPT MODULE
OPT OSVERSION=37
OPT EXPORT
OPT PREPROCESS

MODULE  'exec/devices', 'exec/io', 'exec/nodes', 'exec/ports','exec/devices',
        'oomodules/library'

CONST SIZE_OF_BIGGEST_DEVICE_BLOCK=100, -> the size of the biggest device block
      LONGEST_NAME=40

OBJECT device OF library
  name
  unit
  io:PTR TO io
  flags
  lasterror
ENDOBJECT

PROC open(name, unit=NIL,flags=NIL) OF device
/*

METHOD

  open(name,unit,flags)

INPUTS

  name - the name of the device to be opened
  unit - the unit number
  flags - flags for this device

DESCRIPTION

  Opens the given unit of the device.

RESULTS

  TRUE if the device could be opened

EXCEPTIONS

    May raise "dev" with exceptioninfo

    -2      - CreateMsgPort() failed
    -3      - CreateIORequest() failed
    -4      - OpenDevice() failed

*/

DEF ioreq:PTR TO io,
    meinport:mp,fehler

  self.name := name
  self.unit := unit
  self.flags := flags

->try to open a no-name message port
->raise "dev,-2 if failed

  meinport := CreateMsgPort()
  IF (meinport = NIL)
    Throw("dev",-2)
  ENDIF

->try to create an iorequest
->close msgport and raise "dev",-3 if failed

  ioreq := CreateIORequest(meinport, SIZE_OF_BIGGEST_DEVICE_BLOCK)
  IF (ioreq = NIL)
    DeleteMsgPort(meinport)
    Throw("dev",-3)
  ENDIF

->try to open the device
->close iorequest, msgport and raise "dev",-4 if failed

  fehler := OpenDevice(self.name,self.unit,ioreq,flags)
  IF(fehler)
    DeleteIORequest(ioreq)
    DeleteMsgPort(meinport)
    Throw("dev",-4)
  ELSE
    self.io := ioreq
    RETURN(TRUE)
  ENDIF
ENDPROC

PROC close() OF device
  CloseDevice(self.io)
  DeleteIORequest(self.io)
  DeleteMsgPort(self.io.mn::mn.replyport)
ENDPROC

PROC end() OF device
  self.close()
ENDPROC

PROC doio() OF device
  IF self.io THEN DoIO(self.io)
ENDPROC

PROC sendio() OF device
  IF self.io THEN SendIO(self.io)
ENDPROC

PROC abortio() OF device
  IF self.io THEN AbortIO(self.io)
ENDPROC

PROC reset() OF device
  IF self.io
    self.io::iostd.command := CMD_RESET
    DoIO(self.io)
  ENDIF
ENDPROC
