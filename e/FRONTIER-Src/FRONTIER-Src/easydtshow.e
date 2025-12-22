/* 
 *  Demonstriert die Benutzung der amigaguide.library
 * -=================================================-
 * 
 * Mit diesem Programm lassen sich AmigaGUIDE-Dokumente anzeigen. Wird aber
 * ein anderes Fileformat erkannt (z.B. IFF-ILBM-Bild, oder eine Sounddatei
 * ect...) wird dieses entsprechen interpretiert (angezeigt/abgespielt!)
 * Dies ist (meines Erachtens) der einfachste Weg um eine Datei anzeigen
 * zu lassen, da das Fileformat ect... per Datatypes von der Amigaguide.library
 * automatisch erkannt wird und der Programmierer sich nicht um die inter-
 * pretation (anzeigen ect...) Gedanken machen braucht!
 */

OPT     OSVERSION=37

MODULE  'amigaguide'
MODULE  'dos/dos'
MODULE  'libraries/amigaguide'

ENUM    ERR_NONE,
        ERR_LIB_AGUIDE,
        ERR_LOCK

DEF     lock=NIL,
        guide:PTR TO newamigaguide,
        guidehandle=FALSE

PROC main() HANDLE
 openall()
  setguide()
   openguide()
EXCEPT DO
 closeguide()
 closeall()
  IF exception
   WriteF('Exception \d!\n',exception)
  ENDIF
 CleanUp(exception)
ENDPROC

PROC openall()
 IF (amigaguidebase:=OpenLibrary('amigaguide.library',37))=NIL THEN Raise(ERR_LIB_AGUIDE)
  NEW guide
ENDPROC

PROC closeall()
  END guide
 IF amigaguidebase THEN CloseLibrary(amigaguidebase)
ENDPROC

PROC setguide()
 IF (lock:=Lock(arg,ACCESS_READ))=NIL THEN Raise(ERR_LOCK)
  guide.lock      :=lock
  guide.screen    :=NIL                 -> Workbench!
  guide.pubscreen :=NIL                 -> Workbench
  guide.hostport  :=NIL
  guide.clientport:=NIL
  guide.basename  :=NIL
  guide.flags     :=2
  guide.context   :=NIL
  guide.extens    :=NIL
  guide.client    :=NIL
  guide.name      :=arg
  guide.node      :=NIL                 -> Node! (String!)
  guide.line      :=NIL                 -> Zeile!
ENDPROC

PROC openguide()
 guidehandle:=OpenAmigaGuideA(guide,NIL)
ENDPROC

PROC closeguide()
 CloseAmigaGuide(guidehandle)
  UnLock(lock)
ENDPROC
