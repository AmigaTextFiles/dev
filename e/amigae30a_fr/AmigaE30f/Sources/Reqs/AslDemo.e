/* Une démo pour utiliser d'autres bibliothèques (Kick 2.0) en E.
   On va afficher une requête de fichier de l'asl.library.       */

MODULE 'Asl', 'libraries/Asl'

DEF req:PTR TO filerequester

PROC main()
  IF aslbase:=OpenLibrary('asl.library',37)
    IF req:=AllocFileRequest()
      WriteF('Pick a file:\n')
      IF RequestFile(req)
        WriteF('Devinez quoi! Vous avez choisit "\s" in "\s" !\n',req.file,req.drawer)
      ELSE
        WriteF('Dur, Hein ?\n')
      ENDIF
      FreeFileRequest(req)
    ELSE
      WriteF('Ne peut ouvrir la requête de fichier !\n')
    ENDIF
    CloseLibrary(aslbase)
  ELSE
    WriteF('Ne peut ouvrir l'asl.library!\n')
  ENDIF
ENDPROC
