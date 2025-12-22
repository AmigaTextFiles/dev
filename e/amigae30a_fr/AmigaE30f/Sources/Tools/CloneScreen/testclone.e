-> test de clonage d'écran

OPT OSVERSION=37

MODULE 'tools/clonescreen'

PROC main() HANDLE
  DEF screen=NIL,font=NIL,win=NIL,xsize,ysize,depth
  screen,font:=openclonescreen('Workbench','Mon Workbench Cloné')
  win:=backdropwindow(screen)
  depth,xsize,ysize:=getcloneinfo(screen)
  EasyRequestArgs(win,[20,0,'Sur mon propre écran + fenêtre Backdrop!',
                            'Dimensions de l'écran:\dx\dx\d',
                            'Continue'],0,[xsize,ysize,depth])
EXCEPT DO
  closeclonescreen(screen,font,win)
  SELECT exception
    CASE "SCR"; WriteF('Pas d''écran!\n')
    CASE "WIN"; WriteF('Pas de fenêtre!\n')
  ENDSELECT
ENDPROC
