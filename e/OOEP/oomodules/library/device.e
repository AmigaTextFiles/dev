/****** device/--background-- ******************************************

    PURPOSE
   The basic object for usage of devices. Will be changed when
   the Stream is ready.

    CREATION
   Back in February of 1995 by Gregor Goldbach

    HISTORY
   Modifications by Trey van Riper.

    SEE ALSO
   library

******************************************************************************

History


*/


OPT MODULE
OPT OSVERSION=37
OPT EXPORT

MODULE  'exec/devices',
     'exec/io',
     'exec/nodes',
     'exec/ports',
     'exec/devices',
     'oomodules/library'

CONST SIZE_OF_BIGGEST_DEVICE_BLOCK=100, -> the size of the biggest device block
   LONGEST_NAME=40

-> JEVR3 modification; moved 'name' to object 'library'.


OBJECT device OF library
/****** device/--device-- ******************************************

    NAME
   device

    ATTRIBUTES
   unit -- The unit of the device you want to use. If you don't know
       of a special unit to specify when you work with a device, set
       it to 0. Otherwise, as with the trackdisk.device for example,
       set it to the unit you want to operate on. Think of a unit as
       a 'sub-system' of that device.

   io -- Pointer to the io request structure used for this device.

   flags -- Special flags you set.

   lasterror -- You for convenience, this entry contains the last
       error as in io.error.

******************************************************************************

History


*/
  unit
  io:PTR TO io
  flags
  lasterror
ENDOBJECT

-> JEVR3 addition; select() handles 'unit' and 'flag' options.

PROC select(opts,i) OF device
/****** device/select ******************************************

    NAME
   select() -- Select action via taglist

    SYNOPSIS
   device.select()

    FUNCTION
   Select an action upon initialization of the object. See
   object/new() and object/select() for more information.

   Recognizes these items:
     "unit" -- set unit of device

     "flag" -- set flags of device

    INPUTS
   opts -- Optionlist

   i -- index of optionlist

    SEE ALSO
   object/select()
******************************************************************************

History


*/

DEF item

  item:=ListItem(opts,i)

  SELECT item

    CASE "unit"
   INC i
   self.unit := ListItem(opts,i)

    CASE "flag"
   INC i
   self.flags := ListItem(opts,i)

    DEFAULT
   i:=SUPER self.select(opts,i)

  ENDSELECT
ENDPROC i

-> JEVR3 modification; no more options (new() handles that).  Changed the
-> error handling a little bit.

PROC open() OF device HANDLE
/****** device/open ******************************************

    NAME
   open() -- Open a device with given attributes.

    SYNOPSIS
   device.open()

    FUNCTION
   Open a device with the attributes set.

    RETURNS
   TRUE if the device could be opened.

    EXCEPTIONS
   May raise "dev" with exceptioninfo

     {msgportfail} - CreateMsgPort() failed
     {ioreqfail}     - CreateIORequest() failed
     {opendev}  - OpenDevice() failed

    SEE ALSO
   close(), select()
******************************************************************************

History


*/
DEF ioreq=0:PTR TO io,
    meinport:PTR TO mp,
    fehler=0

  IF self.io THEN RETURN TRUE  -> JEVR3 modification.. reduce redundancy

->try to open a no-name message port

  meinport := CreateMsgPort()
  IF (meinport = NIL) THEN Throw("dev",{msgportfail})

->try to create an iorequest

  ioreq := CreateIORequest(meinport, SIZE_OF_BIGGEST_DEVICE_BLOCK)
  IF (ioreq = NIL) THEN Throw("dev",{ioreqfail})

->try to open the device

  fehler := OpenDevice(self.identifier,self.unit,ioreq,self.flags)
  IF(fehler)
    Throw("dev",{opendev})
  ELSE
    self.io := ioreq
    RETURN TRUE
  ENDIF

-> EXCEPT handling by JEVR3

EXCEPT DO
 IF ioreq THEN DeleteIORequest(ioreq)
 IF meinport THEN DeleteMsgPort(meinport)
 ReThrow()
ENDPROC FALSE

-> JEVR3 modification; added IF statement

PROC close() OF device
/****** device/close ******************************************

    NAME
   close() -- Close a device if open.

    SYNOPSIS
   device.close()

    FUNCTION
   Closes the device and frees allocated resources.

    SEE ALSO
   open()
******************************************************************************

History


*/
  IF self.io
   CloseDevice(self.io)
   DeleteIORequest(self.io)
   DeleteMsgPort(self.io.mn::mn.replyport)
  ENDIF
ENDPROC

PROC end() OF device
/****** device/end *****************************************

    NAME
   end() -- Frees allocated resources.

    SYNOPSIS
   device.end()

    FUNCTION
   Frees allocated resources of the object, that includes closing it.
   Automatically called when ENDing the object.

******************************************************************************

History


*/
  self.close()
ENDPROC

PROC doio() OF device
/****** device/doio ******************************************

    NAME
   doio() -- Perform a DoIO().

    SYNOPSIS
   device.doio()

    FUNCTION
   Perform exec.library's DoIO() on the io request.

    SEE ALSO
   exec/DoIO()
******************************************************************************

History


*/
  IF self.io THEN DoIO(self.io)
ENDPROC

PROC sendio() OF device
/****** device/sendio ******************************************

    NAME
   sendio() -- Perform a SendIO().

    SYNOPSIS
   device.sendio()

    FUNCTION
   Perform exec.library's SendIO() on the io request.

    SEE ALSO
   exec/SendIO()
******************************************************************************

History


*/
  IF self.io THEN SendIO(self.io)
ENDPROC

PROC abortio() OF device
/****** device/abortio ******************************************

    NAME
   abortio() -- Perform a AbortIO().

    SYNOPSIS
   device.abortio()

    FUNCTION
   Perform exec.library's AbortIO() on the io request.

    SEE ALSO
   exec/AbortIO()
******************************************************************************

History


*/
  IF self.io THEN AbortIO(self.io)
ENDPROC

PROC reset() OF device
/****** device/reset ******************************************

    NAME
   reset() -- Reset the device.

    SYNOPSIS
   device.reset()

    FUNCTION
   reset the device by sending the according command.

******************************************************************************

History


*/
  IF self.io
    self.io::iostd.command := CMD_RESET
    DoIO(self.io)
  ENDIF
ENDPROC

-> JEVR3 addition: strings for error messages.  These should change
-> in the future whenever we develop a fairly comprehensive locale
-> handling object for all our devices.  Sorry it's English for now.

msgportfail:
 CHAR 'Couldn''t create message port.',0
ioreqfail:
 CHAR 'Couldn''t create i/o request.',0
opendev:
 CHAR 'Couldn''t open the device.',0
/*EE folds
-1
41 30 45 49 117 24 120 19 123 20 126 20 129 20 132 21 
EE folds*/
