/*

Second module for the trackdisk.device. Uses my E-PROCs from 1993 which were
adapted to use the device object.

Gregor Goldbach 1st April 1995

VISION:

 - procs to read/write non-dos tracks
 - open device if not opened already

  V2.0    12.4.95   made it fit to 'Object'
                    works
*/


OPT MODULE
OPT OSVERSION=37
OPT EXPORT

MODULE  'exec/devices', 'exec/io', 'exec/nodes',
        'exec/ports','exec/devices', 'devices/trackdisk',
        'oomodules/library/device'

OBJECT trackdisk OF device
  label[16]:ARRAY OF CHAR
  buffer[512]:ARRAY OF CHAR
ENDOBJECT

PROC name() OF trackdisk IS 'Trackdisk'

PROC init() OF trackdisk
  self.name := 'trackdisk.device'
ENDPROC

PROC motor(flag=FALSE,drive=0) OF trackdisk
DEF wert

  IF self.io = NIL THEN self.open('trackdisk.device',drive)

  IF flag THEN wert := 1 ELSE wert := 0
   /* ior.iostd.length := 1 -> Motor an */
   /* ior.iostd.length := 0 -> Motor aus */

  self.io::iostd.length := wert
  self.io::iostd.command := TD_MOTOR
  self.doio()

ENDPROC

PROC getchangenum() OF trackdisk

  IF self.io = NIL THEN self.open('trackdisk.device')

  self.io::iostd.command := TD_CHANGENUM
  self.doio()
  RETURN self.io::iostd.actual /* ior.iostd.actual hier steht nach DoIO die Nummer drin */
ENDPROC

PROC readblock(nummer,drive=0) OF trackdisk

  IF self.io=NIL THEN self.open('trackdisk.device', drive, 0)

  self.io::ioexttd.count := self.getchangenum()
  self.io::iostd.offset := nummer*512           -> der Offset wird in Bytes angegeben, ein Block = 512 Bytes
  self.io::iostd.data := self.buffer
  self.io::iostd.length := TD_SECTOR
  self.io::ioexttd.seclabel := self.label       -> vor jedem Block stehen noch 16 Bytes, sog. Label
  self.io::iostd.command := ETD_READ
  self.doio()

ENDPROC self.io::iostd.error

PROC writeblock(nummer,drive=0) OF trackdisk
DEF laufvar

  IF self.io=NIL THEN self.open('trackdisk.device',drive)

  -> set the block's label to 0
  FOR laufvar := 0 TO 15 DO self.label[laufvar]:=0

  self.io::ioexttd.count := self.getchangenum()
  self.io::iostd.offset := nummer*512
  self.io::iostd.data := self.buffer
  self.io::iostd.length := TD_SECTOR
  self.io::ioexttd.seclabel := self.label
  self.io::iostd.command := ETD_WRITE
  self.doio()
  self.io::iostd.command := ETD_UPDATE ->nicht nur in den internen Puffer schreiben, sondern sofort abspeichern
  self.doio()

ENDPROC self.io::iostd.error

PROC diskindrive(drive=0) OF trackdisk
-> disk in drive?

  IF self.io=NIL THEN self.open('trackdisk.device', drive)

  self.io::iostd.command := TD_CHANGESTATE
  self.doio()
  IF(self.io::iostd.actual = 0) THEN RETURN(TRUE) ELSE RETURN(FALSE)
  /* wenn eine Diskette drin ist, ist ioreq.iostd.actual == 0! */

ENDPROC


PROC diskprotected(drive=0) OF trackdisk
-> disk write protected?

  IF self.io=NIL THEN self.open('trackdisk.device', drive)

  self.io::iostd.command := TD_PROTSTATUS
  self.doio()
  RETURN(self.io::iostd.actual)

ENDPROC
