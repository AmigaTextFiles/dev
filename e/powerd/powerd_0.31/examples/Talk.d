/* Talk V1.0 - by Rob Verver in 1992; Translated to PowerD by DMX in 2002  */
/*                                                                         */
/* With this shellcommand you can make the narrator say any text using the */
/* new OS2 features. See the helptemplate for more info. When specifying   */
/* a value which is out of range, the correct range will be displayed.     */
/*                                                                         */
/* Possible enhancements:                                                  */
/*   Ability to speak phonetic strings                                     */
/*   Input from standard input, for piping                                 */
/*   Preferences file in ascii format, controling all settings             */
/*   Escape codes changes values halfway a text                            */
OPT DOSONLY,OPTIMIZE=3

MODULE 'devices/narrator','dos/dos','exec/memory','exec/io','translator'

CONST AUDIOCHANSIZE=4
ENUM NONE, ERR_DOS, ERR_MEM, ERR_FILE, ERR_DEVICE, ERR_TRANS, ERR_INVALID

OBJECT arglist
  file, rate, pitch, robotic, female, volume, enthusiasm, perturb, f1adj,
  f2adj, f3adj, a1adj, a2adj, a3adj, articulate, centralize, centphon, avbias,
  afbias, priority
ENDOBJECT

DEF template, phonebuf=NIL, rdargs=NIL, file=NIL, msgport=NIL,
    filebuf=NIL, ioreq:PTR TO NDI, audiochan: PTR TO CHAR, valid=TRUE,
    length, phonebufsize,TranslatorBase

PROC main()
  audiochan := [3, 5, 10, 12]:CHAR

  /* parse commandline options */
  DEF args = [NIL, [DEFRATE], [DEFPITCH], 0, 0, [DEFVOL], [DEFF0ENTHUS],
          [DEFF0PERT], [0], [0], [0], [0], [0], [0], [DEFARTIC],
          [DEFCENTRAL], NIL, [0], [0], [25]]:arglist
  template := 'FILE,RATE/K/N,PITCH/K/N,ROBOTIC/S,FEMALE/S,VOLUME/K/N,' + 
              'ENTHUSIASM/K/N,PERTURB/K/N,F1ADJ/K/N,F2ADJ/K/N,F3ADJ/K/N,' +
              'A1ADJ/K/N,A2ADJ/K/N,A3ADJ/K/N,ARTICULATE/K/N,CENTRALIZE/K/N,' +
              'CENTPHON/K,AVBIAS/K/N,AFBIAS/K/N,PRIORITY/K/N'
  rdargs := ReadArgs (template, args, NIL)
  IF rdargs=NIL THEN Raise (ERR_DOS)

  /* open translator library */
  TranslatorBase := OpenLibrary ('translator.library', 37)
  IF TranslatorBase=NIL THEN Raise (ERR_TRANS)

  /* open input file */
  file := Open (args.file, MODE_OLDFILE)
  IF file=NIL THEN Raise (ERR_FILE)
  length := FileLength (args.file)           /* !!! ascii, no fh */
  IF length<1 THEN Raise (ERR_FILE)

  /* allocate input buffer */
  filebuf := AllocVec (length, MEMF_PUBLIC)
  IF filebuf=NIL THEN Raise (ERR_MEM)

  /* allocate buffer for phonetic strings */
  phonebufsize := Shl (length, 1)
  phonebuf := AllocVec (phonebufsize, MEMF_PUBLIC)
  IF phonebuf=NIL THEN Raise (ERR_MEM)

  /* open narrator device */
  msgport := CreateMsgPort ()
  IF msgport=NIL THEN Raise (ERR_DEVICE)
  ioreq := CreateIORequest (msgport, SIZEOF_NDI)
  IF ioreq=NIL THEN Raise (ERR_DEVICE)
  ioreq.flags := NDF_NEWIORB
  IFN OpenDevice ('narrator.device', 0, ioreq, NIL)=NIL THEN Raise (ERR_DEVICE)

  /* check values validity */
  checkVal (Long (args.rate), MINRATE, MAXRATE, 'Invalid rate')
  checkVal (Long (args.pitch), MINPITCH, MAXPITCH, 'Invalid pitch')
  checkVal (Long (args.volume), MINVOL, MAXVOL, 'Invalid volume')
  checkVal (Long (args.centralize), MINCENT, MAXCENT, 'Invalid centralization')
  IF valid=FALSE THEN Raise (ERR_INVALID)

  ioreq.ChMasks := audiochan
  ioreq.NumMasks := AUDIOCHANSIZE

  /* init values */
  ioreq.rate := Long (args.rate)
  ioreq.pitch := Long (args.pitch)
  ioreq.volume := Long (args.volume)
  ioreq.F0enthusiasm := Long (args.enthusiasm)
  ioreq.F0perturb := Long (args.perturb)
  ioreq.F1adj := Long (args.f1adj)
  ioreq.F2adj := Long (args.f2adj)
  ioreq.F3adj := Long (args.f3adj)
  ioreq.A1adj := Long (args.a1adj)
  ioreq.A2adj := Long (args.a2adj)
  ioreq.A3adj := Long (args.a3adj)
  ioreq.articulate := Long (args.articulate)
  ioreq.centralize := Long (args.centralize)
  ioreq.centphon := Long (args.centphon)
  ioreq.AVbias := Long (args.avbias)
  ioreq.AFbias := Long (args.afbias)
  ioreq.priority := Long (args.priority)
  IFN args.robotic=NIL THEN ioreq.mode := ROBOTICF0 ELSE ioreq.mode := MANUALF0
  IFN args.female=NIL THEN ioreq.sex := FEMALE

  process ()

  Raise (0)
EXCEPT
  SELECT exception
    CASE ERR_DOS;     PrintFault (IOErr(), 'Error')
    CASE ERR_MEM;     PutStr ('Error: not enough memory\n')
    CASE ERR_FILE;    PutStr ('Error: couldn\at open file\n')
    CASE ERR_DEVICE;  PutStr ('Error: couldn\at open narrator device\n')
    CASE ERR_TRANS;   PutStr ('Error: could\at open translator library V37\n')
    CASE ERR_INVALID; PutStr ('Error: wrong parameters\n')
  ENDSELECT

  IFN ioreq=NIL THEN CloseDevice (ioreq); DeleteIORequest (ioreq)
  IFN TranslatorBase=NIL THEN CloseLibrary (TranslatorBase)
  IFN rdargs=NIL THEN FreeArgs (rdargs)
  IFN phonebuf=NIL THEN FreeVec (phonebuf)
  IFN filebuf=NIL THEN FreeVec (filebuf)
  IFN file=NIL THEN Close (file)
  IFN msgport=NIL THEN DeleteMsgPort (msgport)
  IF exception THEN Exit(10)
ENDPROC

PROC checkVal (val, min, max, str)
  IF val<min OR (val>max)
    PrintF('%s: valid values are between %ld and %ld\n', str, min, max)
    valid := FALSE
  ENDIF
ENDPROC

PROC process ()
  DEF readlen          /* !!!! was equal to globvar */

  readlen := Read(file, filebuf, length)
  IFN readlen=length THEN Raise (ERR_FILE)

  Translate (filebuf, length, phonebuf, phonebufsize)
  /* WriteF ('phonetic string:\s\n', phonebuf) */
  speakBuffer (phonebuf, StrLen (phonebuf))
ENDPROC

PROC speakBuffer(buffer, length)
  DEF ior:PTR TO IOStd
  ior := ioreq
  ior.Command := CMD_WRITE
  ior.Data := buffer
  ior.Length := length
  DoIO (ioreq)
ENDPROC
