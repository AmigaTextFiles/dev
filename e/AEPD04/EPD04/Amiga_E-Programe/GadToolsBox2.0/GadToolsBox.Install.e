/* Installer GadgetToolBoxV2.0

    Klein, schnell, gut.

    abgewandelt aus dem Beispiel für die Shell.

    (1994) JCL_Power

*/

PROC main()
  DEF inputstring[80]:STRING,writestring[80] : STRING, con
  StrCopy(writestring,'GadToolsBoxV2_0c.run ',ALL)
  IF con:=Open('con:10/10/600/200/GadgettoolboxInstaller',NEWFILE)
    Write(con,'Hier ist das Ultimative Tool-Programm:\n',STRLEN)
    Write(con,'Die \e[1;32;41m GADTOOLBOX \e[0;31;40m.\n',STRLEN)
    Write(con,'Zusammen mit dem Programm Srcgen könnt Ihr so eure\n',STRLEN)
    Write(con,'eigenen Bildschirmmasken entwerfen.\n',STRLEN)
    Write(con,'Bitte den Pfad angeben, wohin die GadgetToolBox\n',STRLEN)
    Write(con,'entpackt werden soll ("#" = Abbruch): >',STRLEN)
    ReadStr(con,inputstring)
    IF inputstring[0] <> "#"
       StrAdd(writestring,inputstring,ALL)
       Execute(writestring,0,con)
       Write(con,'Das wars ...... Bye, bye.',STRLEN)
    ENDIF
    Close(con)
  ENDIF
ENDPROC
