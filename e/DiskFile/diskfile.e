/****** teaching/diskfile *******************************************
* 
*   NAME
*       diskfile -- Copy raw disk tracks to a file.
*
*   SYNOPSIS
*       diskfile DEVICE/A,OUTFILE/A,DISKNAME,KEEPERRORS/S
*
*   FUNCTION
*       Copies the raw data contained on a disk into a normal AmigaDOS file.
*       It supports all drive types and disk formats that are installed on
*       the system. It basically acts like the DiskCopy utility, with the
*       difference that the destination is a file and not another disk.
*       It is designed to look reasonably presentable for usage in
*       installation scripts.
*
*       You may want to use this to create HD installation disk images, or
*       ADF files for an Amiga emulator.
*
*   INPUTS
*       DEVICE/A       - Specifies the device to to read from. Only disk-
*                        like devices can be read from, such as the disk
*                        device DF0:, or the RAD: device. Non disk-based
*                        devices like RAM: cannot be copied. You may specify
*                        the device name with or without a trailing colon.
*
*       OUTFILE/A      - Specifies the file to which the disk data is to be
*                        written to. It can not be located on the device
*                        which is being copied.
*
*       DISKNAME       - This is the 'name' of the disk which the user will
*                        be prompted for ('Please insert DISKNAME ...').
*                        This option is not used for anything more than
*                        gloss, the diskname is not stored in the output
*                        file or anything like that. The default message is
*                        'Please insert disk ...'.
*
*       KEEPERRORS/S   - This switch allows you to specifies that media
*                        errors should be ignored. The data is read on a
*                        per-track basis, if an error occurs it the entire
*                        track will be empty.
*
*   RESULT
*       Demonstrates the following programming techniques:
*       - Examining contents of DosList for information about DOS device
*       - Standard device IO to access data on a trackdisk-like structure
*       - Detecting an interactive console and changing it to raw mode
*
*       Also demonstrates usage of ReadArgs(), DOS Errors, self-defined
*       objects with methods, automatically raised exceptions, and points
*       out some user interface and maintainability considerations.
*
*   EXAMPLES
*       As an exercise for the reader, possible extensions include:
*       - Improving efficiency using Fwrite() asyncronous write-to-disk,
*         with appropriate block sizes.
*       - Support writing disk images back to disk, checking sizes match.
*       - Making a graphical WB version, using:
*          - SimpleGauge EasyPlugin for progress indication
*          - NextDosEntry(LDF_DEVICES) to create a "Format"-like listview,
*            and the PopAsl EasyPlugin for output filename.
*
*   NOTE
*	Thanks to Eric Sauvageau for advice and code.
*
****************************************************************************
*
*
*/

-> we use PREPROCESS mode for macros like TEMPLATE, free() and BADDR()

OPT PREPROCESS

MODULE 'devices/trackdisk', 'dos/dos', 'dos/dosasl', 'dos/dosextens',
       'exec/io', 'exec/memory', 'dos/filehandler', '*string', '*clr'

-> string.m contains strdup(), which makes a fresh copy of a string,
-> and also can copy BSTRs. Also contains free(), which frees the string.


-> This is where we define our ReadArgs() template, and our own arguments
-> structure for accessing the read-in arguments.
-> it is a _lot_ easier to change if we leave it out here.

#define TEMPLATE 'DEVICE/A,OUTFILE/A,DISKNAME,KEEPERRORS/S'

OBJECT our_args
  device, file, diskname, keeperr
ENDOBJECT

DEF args:our_args

-> This is fun. If any of these functions go wrong - or go right, in the
-> case of CtrlC() - then an exception will happen and we will cleanup.
-> This allows us to program 'flat', and relieve ourselves of the heavy
-> indentation more normally associated with C programming.

-> However, beware using automatic raise too often, as it can easily
-> give too much control away to the compiler and take it away from your
-> own code.

RAISE	"^C"	IF CtrlC()<>FALSE,
	"ndev"	IF Inhibit()=0,
	"ndev"	IF OpenDevice()<>0,
	"rdsk"	IF CreateIORequest()=NIL,
	"rdsk"	IF CreateMsgPort()=NIL,
	"ofle"	IF Open()=NIL,
	"wfle"	IF Write()=-1,
	"MEM"	IF AllocVec()=NIL,
	"MEM"	IF String()=NIL,
	"ARGS"	IF ReadArgs()=NIL


-> We define our own object that holds underlying device information for
-> a particular DOS 'drive'. It's constructor and destructor are defined
-> at the bottom of this source.

OBJECT device_info
  name, device, unit  -> 'DF0:', 'trackdisk.device', 0
  lowcyl, highcyl     -> 0, 79
  trksize, sides      -> 5632, 2
ENDOBJECT

->--------------------------------------------------------------------------

PROC main() HANDLE
  -> Note that most of these variables are physically set to NIL before
  -> we start. NIL means to us that the resource hasn't been opened,
  -> this helps us on cleanup to decide whether to try and 'free' the
  -> resource - an exception could happen any time, before some things
  -> have been allocated.

  DEF rdargs=NIL, dev=NIL:PTR TO device_info, ioreq=NIL:PTR TO iostd,
      outfile=NIL, ioerr, port=NIL, buffer=NIL, devopen=1, inhibited=FALSE

  -> read in our arguments, as defined above
  clr(args, SIZEOF our_args)
  rdargs := ReadArgs(TEMPLATE,args,NIL)

  -> prompt user to insert their disk. Allow a breakout before we start
  CtrlC(); IF IsInteractive(stdin) THEN prompt_user()

  -> Create a device_info structure based on the device the user asked for
  NEW dev.create(args.device)

  -> inhibit the drive. We now can't access files on this disk
  inhibited := Inhibit(dev.name,DOSTRUE)

  -> allocate a track buffer for copying
  buffer  := AllocVec(dev.trksize, MEMF_PUBLIC OR MEMF_CLEAR)

  -> open the underlying device
  ioreq := CreateIORequest(port := CreateMsgPort(), SIZEOF iostd)
  devopen := OpenDevice(dev.device, dev.unit, ioreq, 0)

  -> open the output file, which now can't be on the disk we're reading
  outfile := Open(args.file, NEWFILE)

  -> actually read the disk
  read_disk(dev, ioreq, outfile, buffer)

-> Just writing 'EXCEPT' means that the exception handler is seperate from
-> the procedure it is defined from, and you have to Raise()/Throw() to get
-> it to execute. However, 'EXCEPT DO' means the exception handler will
-> execute like it was at the end of the procedure, with 'exception'=0

EXCEPT DO
  ioerr := IoErr() -> get DOS errorcode

  -> ensure we are in normal ('cooked') console mode
  IF IsInteractive(stdin) THEN SetMode(stdin, 0)

  IF devopen=0
    -> ensure disk motor is turned off
    ioreq.command := TD_MOTOR
    ioreq.length  := 0
    DoIO(ioreq)

    CloseDevice(ioreq)
  ENDIF

  IF outfile   THEN Close(outfile)
  IF ioreq     THEN DeleteIORequest(ioreq)
  IF port      THEN DeleteMsgPort(port)
  IF buffer    THEN FreeVec(buffer)
  IF inhibited THEN Inhibit(dev.name,DOSFALSE)
  IF dev       THEN END dev
  IF rdargs    THEN FreeArgs(rdargs)

  -> Some appropriate error messages - most implemented with DOS's usual
  -> error method. Annoyingly, there isn't an 'error reading disk' error
  -> as standard in DOS. Guess it's not that important.

  SELECT exception
  CASE "^C"   ; ioerr := ERROR_BREAK; PutStr('\n')
  CASE "ndev" ; ioerr := ERROR_DEVICE_NOT_MOUNTED
  CASE "MEM"  ; ioerr := ERROR_NO_FREE_STORE
  CASE "wfle" ; ioerr := exceptioninfo
  CASE "rdsk" ; WriteF('\nError reading disk!\n')
  ENDSELECT

  -> if there _was_ an error, PrintFault() will print it.
  PrintFault(ioerr,NIL)

  CleanUp(IF exception THEN RETURN_FAIL ELSE RETURN_OK)
ENDPROC

->--------------------------------------------------------------------------

PROC read_disk(dev:PTR TO device_info, ioreq:PTR TO iostd, outf, buf) HANDLE

  -> actually read the disk described by the device_info

  -> Nicely formatted output - stay on same line for cylinder updates,
  -> if KEEPERRORS is on then use the line underneath for an error report,
  -> remembering to skip over when finished/breaking...

  DEF cyl, side, offset=0, err=FALSE, size, diskerr

  -> size of a single read/save
  size := dev.trksize

  FOR cyl := dev.lowcyl TO dev.highcyl
    CtrlC()

    WriteF(
      '\cReading disk... cylinder \d/\d  \d bytes = \d%',
      13, cyl, dev.highcyl, offset, cyl*100/dev.highcyl
    )

    FOR side := 1 TO dev.sides
      ioreq.command := CMD_READ
      ioreq.offset  := offset
      ioreq.length  := size
      ioreq.data    := buf

      IF DoIO(ioreq)<>0
        IF args.keeperr = 0 THEN Raise("rdsk")
        err := TRUE; clr(buf, size)
        WriteF('\nError reading cylinder \d side \d\c', cyl, side, 11)
      ENDIF

      -> save to disk
      Write(outf, buf, size)

      offset := offset + size
    ENDFOR
  ENDFOR
  WriteF('\n\sFinished.\n', IF err THEN '\n' ELSE '')

EXCEPT
  -> we know this can only be "rdsk" or "wfle" exception
  -> for 'wfle', we provide the IoErr() as exceptioninfo
  diskerr := IoErr()
  WriteF('\n\s', IF err THEN '\n' ELSE '')
  Throw(exception, diskerr)
ENDPROC

->--------------------------------------------------------------------------

PROC prompt_user()

  -> Prompt the user to insert their disk.

  -> We use raw mode so we are not forced to wait
  -> for a newline just to recieve a CtrlC()

  DEF buffer[20]:STRING

  WriteF(
    'Insert \e[1m\s\e[0m in device \e[1m\s\e[0m\n'+
    'Press RETURN to begin or CTRL-C to abort: ',
    IF args.diskname THEN args.diskname ELSE 'disk',
    args.device
  )

  -> raw mode
  SetMode(stdin, 1)

  REPEAT; CtrlC(); Read(stdin, buffer, 20); UNTIL buffer[0]=13

  -> normal ('cooked') mode
  SetMode(stdin, 0)

  WriteF('\n')
ENDPROC

->--------------------------------------------------------------------------

PROC create(drivename) OF device_info HANDLE

  -> the DEVICE_INFO object is purely a read-only information structure,
  -> only the constructor and destructor are necessary.
  -> we pass in a device name ('DF0:', 'ram', 'Dh0', etc...) and
  -> get out the information about that device, or an "ndev" exception 

  -> Note how all the possible exceptions are sandwiched between the
  -> LockDosList() and the UnLockDosList() in the handler. This is
  -> essential, as we cannot allow any DOS calls without unlocking
  -> the dos list, or the system will hang.

  DEF dl:PTR TO doslist, fssm:PTR TO filesysstartupmsg,
      de:PTR TO dosenvec, devname=NIL, pos, found=FALSE

  dl:=LockDosList(LDF_DEVICES OR LDF_READ)

  -> get name of device (without ending in ':')
  devname:=strdup(drivename)
  IF (pos:=InStr(devname,':'))<>-1 THEN devname[pos] := "\0"

  -> use this to find the disk device
  IF dl:=FindDosEntry(dl,devname,LDF_DEVICES)
    IF dl.type=DLT_DEVICE

      -> we found the entry we wanted. Copy relevant information
      found:=TRUE

      -> convert dl.name=BSTR('DF0') to self.name='DF0:'
      drivename := BADDR(dl.name)
      self.name := String(Char(drivename)+1)
      StrCopy(self.name, drivename+1, Char(drivename))
      StrAdd(self.name, ':')

      -> filesystemstartupmsg holds all information about the
      -> diskdevice underneath the handler

      -> device and unit are used for call to OpenDevice()
      fssm         := BADDR(dl::devicenode.startup)
      self.device  := strdup(fssm.device,BSTR)
      self.unit    := fssm.unit

      -> diskenvironment holds the drive geometry - start and end
      -> cylinder, number of surfaces, size of track (in blocks),
      -> size of blocks (in longwords - *4 to get size in bytes)

      de           := BADDR(fssm.environ)
      self.lowcyl  := de.lowcyl
      self.highcyl := de.highcyl
      self.sides   := de.surfaces
      self.trksize := Mul(BADDR(de.sizeblock),de.blockspertrack)
    ENDIF
  ENDIF

  IF found=FALSE THEN Raise("ndev")

EXCEPT DO
  UnLockDosList(LDF_DEVICES OR LDF_READ)
  free(devname)
  ReThrow()
ENDPROC

PROC end() OF device_info
  free(self.name)
  free(self.device)
ENDPROC

->--------------------------------------------------------------------------

-> $VER: diskfile.e 1.0 (21.03.98)
CHAR '$VER: diskfile 1.0 (21.03.98)\0'
