/* exemple d'utilisation des polices de caractères intégrés pour des images. 'paint.m' convertis
   de fichier font avec font2obj (aminet?) et o2m
*/

OPT OSVERSION=37

MODULE 'tools/clonescreen', '*paint', 'libraries/diskfont'

PROC main() HANDLE
  DEF screen=NIL,font=NIL,win=NIL,tf:PTR TO diskfontheader
  tf:={paintf}; tf:=tf.tf
  screen,font:=openclonescreen('Workbench','bla')
  win:=backdropwindow(screen)
  SetFont(stdrast:=screen+84,tf)
  TextF(200,40,'A B C D E F G H ')
  EasyRequestArgs(win,[20,0,'hm','hein','Voui'],0,NIL)
EXCEPT DO
  closeclonescreen(screen,font,win)
  SELECT exception
    CASE "SCR"; WriteF('Pas d'écran!\n')
    CASE "WIN"; WriteF('Pas de fenêtre!\n')
  ENDSELECT
ENDPROC
