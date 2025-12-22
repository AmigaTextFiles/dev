/* Talk V1.0 - par Rob Verver in 1992                                      */
/* Traduction : Olivier ANH (BUGSS)                                        */
/*                                                                         */
/* Avec ces commandes shell, vous pourrez faire dire n'importe quel texte  */
/* avec le nouveau narrator.device de l'OS 2.0. Si une valeur donnée est   */
/* hors norme, la valeur correcte sera affichée. Voyez le manuel de l'Amiga*/
/* pour plus de renseignements.                                            */
/*                                                                         */
/* Améliorations possible :                                                */
/*   Capacité de dire des chaines phonétiques                              */
/*   Entrée par l'entrée standard (STDIN) pour les pipes                   */
/*   Fichier de préférences en ASCII, contrôlant tous les paramètres       */
/*   Les codes d'échappement modifie en partie le texte                    */

OPT OSVERSION=37

MODULE 'Translator', 'devices/narrator', 'dos/dos', 'exec/memory', 'exec/io'

CONST AUDIOCHANSIZE=4
ENUM NONE, ERR_DOS, ERR_MEM, ERR_FILE, ERR_DEVICE, ERR_TRANS, ERR_INVALID

OBJECT arglist
  file, rate, pitch, robotic, female, volume, enthusiasm, perturb, f1adj,
  f2adj, f3adj, a1adj, a2adj, a3adj, articulate, centralize, centphon, avbias,
  afbias, priority
ENDOBJECT

DEF template, args: arglist, phonebuf=NIL, rdargs=NIL, file=NIL, msgport=NIL,
    filebuf=NIL, ioreq: PTR TO ndi, audiochan: PTR TO CHAR, valid=TRUE,
    length, phonebufsize

PROC main () HANDLE
  audiochan := [3, 5, 10, 12]:CHAR

  /* analyse les options de la ligne de commande */
  args := [NIL, [DEFRATE], [DEFPITCH], 0, 0, [DEFVOL], [DEFF0ENTHUS],
          [DEFF0PERT], [0], [0], [0], [0], [0], [0], [DEFARTIC],
          [DEFCENTRAL], NIL, [0], [0], [25]]: arglist
  template := 'FILE,RATE/K/N,PITCH/K/N,ROBOTIC/S,FEMALE/S,VOLUME/K/N,' +
              'ENTHUSIASM/K/N,PERTURB/K/N,F1ADJ/K/N,F2ADJ/K/N,F3ADJ/K/N,' +
              'A1ADJ/K/N,A2ADJ/K/N,A3ADJ/K/N,ARTICULATE/K/N,CENTRALIZE/K/N,' +
              'CENTPHON/K,AVBIAS/K/N,AFBIAS/K/N,PRIORITY/K/N'
  rdargs := ReadArgs (template, args, NIL)
  IF rdargs=NIL THEN Raise (ERR_DOS)

  /* ouvre la bibliothèque translator.library */
  translatorbase := OpenLibrary ('translator.library', 37)
  IF translatorbase=NIL THEN Raise (ERR_TRANS)

  /* ouvre le fichier d'enntrée */
  file := Open (args.file, MODE_OLDFILE)
  IF file=NIL THEN Raise (ERR_FILE)
  length := FileLength (args.file)           /* !!! ascii, pas fh */
  IF length<1 THEN Raise (ERR_FILE)

  /* alloue le buffer d'entrée */
  filebuf := AllocVec (length, MEMF_PUBLIC)
  IF filebuf=NIL THEN Raise (ERR_MEM)

  /* alloue le buffer pour les chaines de caractères phonétiques */
  phonebufsize := Shl (length, 1)
  phonebuf := AllocVec (phonebufsize, MEMF_PUBLIC)
  IF phonebuf=NIL THEN Raise (ERR_MEM)

  /* ouvre le narrator.device */
  msgport := CreateMsgPort ()
  IF msgport=NIL THEN Raise (ERR_DEVICE)
  ioreq := CreateIORequest (msgport, SIZEOF ndi)
  IF ioreq=NIL THEN Raise (ERR_DEVICE)
  ioreq.flags := NDF_NEWIORB
  IF OpenDevice ('narrator.device', 0, ioreq, NIL)<>NIL THEN Raise (ERR_DEVICE)

  /* vérifie la validité des valeurs */
  checkVal (Long (args.rate), MINRATE, MAXRATE, 'Mauvais rate')
  checkVal (Long (args.pitch), MINPITCH, MAXPITCH, 'Mauvais pitch')
  checkVal (Long (args.volume), MINVOL, MAXVOL, 'Mauvais volume')
  checkVal (Long (args.centralize), MINCENT, MAXCENT, 'Mauvaise centralisation')
  IF valid=FALSE THEN Raise (ERR_INVALID)

  ioreq.chmasks := audiochan
  ioreq.nummasks := AUDIOCHANSIZE

  /* init values */
  ioreq.rate := Long (args.rate)
  ioreq.pitch := Long (args.pitch)
  ioreq.volume := Long (args.volume)
  ioreq.f0enthusiasm := Long (args.enthusiasm)
  ioreq.f0perturb := Long (args.perturb)
  ioreq.f1adj := Long (args.f1adj)
  ioreq.f2adj := Long (args.f2adj)
  ioreq.f3adj := Long (args.f3adj)
  ioreq.a1adj := Long (args.a1adj)
  ioreq.a2adj := Long (args.a2adj)
  ioreq.a3adj := Long (args.a3adj)
  ioreq.articulate := Long (args.articulate)
  ioreq.centralize := Long (args.centralize)
  ioreq.centphon := Long (args.centphon)
  ioreq.avbias := Long (args.avbias)
  ioreq.afbias := Long (args.afbias)
  ioreq.priority := Long (args.priority)
  IF args.robotic<>NIL THEN ioreq.mode := ROBOTICF0 ELSE ioreq.mode := MANUALF0
  IF args.female<>NIL THEN ioreq.sex := FEMALE

  process ()

  Raise (0)
EXCEPT
  SELECT exception
    CASE ERR_DOS;     PrintFault (IoErr(), 'Erreur')
    CASE ERR_MEM;     PutStr ('Erreur: Pas assez de mémoire\n')
    CASE ERR_FILE;    PutStr ('Erreur: Ne peut ouvrir le fichier\n')
    CASE ERR_DEVICE;  PutStr ('Erreur: Ne peut ouvrir le narrator.device\n')
    CASE ERR_TRANS;   PutStr ('Erreur: Ne peut ouvrir la translator.library V37\n')
    CASE ERR_INVALID; PutStr ('Erreur: Mauvais paramètres\n')
  ENDSELECT

  IF ioreq<>NIL THEN CloseDevice (ioreq) BUT DeleteIORequest (ioreq)
  IF translatorbase<>NIL THEN CloseLibrary (translatorbase)
  IF rdargs<>NIL THEN FreeArgs (rdargs)
  IF phonebuf<>NIL THEN FreeVec (phonebuf)
  IF filebuf<>NIL THEN FreeVec (filebuf)
  IF file<>NIL THEN Close (file)
  IF msgport<>NIL THEN DeleteMsgPort (msgport)
  IF exception THEN CleanUp (10)
ENDPROC

PROC checkVal (val, min, max, str)
  IF val<min OR (val>max)
    Vprintf ('%s: de bonnes valeurs sont entre %ld et %ld\n', [str, min, max])
    valid := FALSE
  ENDIF
ENDPROC

PROC process ()
  DEF readlen          /* !!!! était égal à globvar */

  readlen := Read (file, filebuf, length)
  IF readlen<>length THEN Raise (ERR_FILE)

  Translate (filebuf, length, phonebuf, phonebufsize)
  /* WriteF ('Chaines phonétique :\s\n', phonebuf) */
  speakBuffer (phonebuf, StrLen (phonebuf))
ENDPROC

PROC speakBuffer (buffer, length)
  DEF ior:PTR TO iostd
  ior := ioreq
  ior.command := CMD_WRITE
  ior.data := buffer
  ior.length := length
  DoIO (ioreq)
ENDPROC
