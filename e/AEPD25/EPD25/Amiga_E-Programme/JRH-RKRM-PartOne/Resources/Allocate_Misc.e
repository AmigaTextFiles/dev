-> Allocate_Misc.e
->
-> Example of allocating a miscellaneous resource.  We will allocate the serial
-> resource and wait until CTRL-C is pressed.  While we are waiting, the
-> Query_Serial program should be run.  It will try to open the serial device
-> and if unsuccessful, will return the name of the owner.  It will be us!

-> E-Note: E does not (as of v3.1a) support Resources in the conventional way
MODULE 'other/misc',
       'dos/dos',
       'resources/misc'

ENUM ERR_NONE, ERR_BITS, ERR_PORT

PROC main() HANDLE
  -> E-Note: to help with cleaning up "owner" has been split into "portowner"
  ->         and "bitsowner" which are initialised to non-NIL values
  DEF portowner=-1, bitsowner=-1  -> Owner of misc resource

  miscbase:=OpenResource('misc.resource')

  -> Allocate both pieces of the serial hardware
  IF portowner:=allocMiscResource(MR_SERIALPORT, 'Serial Port Hog')
    Raise(ERR_PORT)
  ENDIF
  IF bitsowner:=allocMiscResource(MR_SERIALBITS, 'Serial Port Hog')
    Raise(ERR_BITS)
  ENDIF

  -> Wait for CTRL-C to be pressed
  WriteF('\nWaiting for CTRL-C...\n')
  Wait(SIGBREAKF_CTRL_C)

  -> We're back

EXCEPT DO
  -> Deallocate the serial port register
  IF bitsowner=NIL THEN freeMiscResource(MR_SERIALBITS)
  -> Deallocate the serial port
  IF portowner=NIL THEN freeMiscResource(MR_SERIALPORT)
  SELECT exception
  CASE ERR_BITS
    WriteF('Unable to allocate MR_SERIALBITS because \s owns it\n', bitsowner)
  CASE ERR_PORT
    WriteF('Unable to allocate MR_SERIALPORT because \s owns it\n', portowner)
  ENDSELECT
ENDPROC
