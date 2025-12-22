/* Lit les arguments lors du démarrage du workbench.
   Donnez à ce programme un fichier .info, et sélectionner
   quelques icones avec lui. */

MODULE 'workbench/startup'

PROC main()
  DEF wb:PTR TO wbstartup, args:PTR TO wbarg, a
  IF wbmessage=NIL                              /* du cli */
    WriteF('arguments = "\s"\n',arg)
  ELSE                                          /* du wb */
    wb:=wbmessage
    args:=wb.arglist
    FOR a:=1 TO wb.numargs DO WriteF('arcgument wb #\d = "\s"\n',a,args[].name++)
  ENDIF
ENDPROC
