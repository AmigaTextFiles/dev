/*



  DOESN'T WORK!


*/

OPT MODULE
OPT EXPORT

MODULE 'oomodules/library/device','devices/audio','exec/devices','exec/io','exec/ports'

OBJECT audio OF device
ENDOBJECT

PROC open(channelmap,unit=0,flags=0) OF audio
-> a slightly modified version of device's open() method
-> it's not that oo i think, maybe it'll be changed

DEF ioreq:PTR TO io,
    meinport:mp,fehler,
    chanmap

  chanmap := channelmap
  self.name := 'audio.device'
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

/*
  ioreq::ioaudio.data := chanmap
  ioreq::ioaudio.length := ListLen(chanmap)
  ioreq::ioaudio.allockey := 0
*/
  ioreq::ioaudio.data := 0
  ioreq::ioaudio.length := 0
  ioreq::ioaudio.allockey := 0

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

PROC play(address,length,frequency,volume=64,cycles=1) OF audio

  self.io::ioaudio.data := address
  self.io::ioaudio.cycles := cycles
  self.io::ioaudio.length := length
  self.io::ioaudio.period := Div(100000000,Mul(Mul(length,frequency),28))
  self.io::ioaudio.volume := volume
  self.io::iostd.command :=CMD_WRITE
  self.io::iostd.flags := ADIOF_PERVOL
  self.doio()

  self.lasterror := self.io::iostd.error

ENDPROC
