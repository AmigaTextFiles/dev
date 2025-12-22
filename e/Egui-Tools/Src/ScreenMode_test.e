MODULE  'req/screenobject'      -> Für das Object...
MODULE  'req/reqtypes'          -> Um einzustellen ob ASL oder REQTOOLS
MODULE  'req/screenmode'        -> Das eigendliche Modul...

PROC main()
 DEF    sd:PTR TO screenobj     -> Das Screenobject...
  NEW sd                        -> Objekt Initialisieren (muß IMMER gemacht werden!)
   screenmoderequest('test - ASL-Modus...',TYPE_ASL,sd)
    WriteF(' Width : \d\n',sd.width)
     WriteF(' Height: \d\n',sd.height)
      WriteF(' Depth : \d\n',sd.depth)
       WriteF(' ID    : $\h\n',sd.displayid)
   screenmoderequest('test - REQTOOLS-Modus...',TYPE_REQTOOLS,sd)
    WriteF(' Width : \d\n',sd.width)
     WriteF(' Height: \d\n',sd.height)
      WriteF(' Depth : \d\n',sd.depth)
       WriteF(' ID    : $\h\n',sd.displayid)
  END sd                        -> Objectspeicher wieder freigeben
ENDPROC

