/*
**   ((( frumSPlugs )))
** ©1996 Stephen Sinclair
**
** This source may be copied or edited in any
** way you wish.
**
** This file is part of the frumSPlugs package,
** and may only be distributed with it.
*/

/* Example use of AslPopups plugin */
-> $VER: AslPopupsExample.e V1.0 Stephen Sinclair (96.07.16)

OPT OSVERSION=37
MODULE 'Tools/EasyGUI','Plugins/AslPopups'

DEF gh:PTR TO guihandle
DEF filepop:PTR TO aslfileplugin,filename[200]:STRING,filegad
DEF fontpop:PTR TO aslfontplugin,fontname[50]:STRING,fontgad
DEF scrmdpop:PTR TO aslscrmdplugin,scrmdname[50]:STRING,scrmdgad

PROC main() HANDLE
  neweasygui('Asl Popups!',
    [ROWS,
      [COLS,
        filegad:=[STR,{dummy},'File Name:',filename,200,30],
        [PLUGIN,{showfile},NEW filepop.aslfileplugin(filename,'Select a file:',NIL,NIL,'#?','Thank you')]
      ],
      [COLS,
        fontgad:=[STR,{dummy},'Font:',fontname,50,30],
        [PLUGIN,{showfont},NEW fontpop.aslfontplugin(fontname,FALSE,TRUE,TRUE,TRUE,TRUE,0,0,'times.font',11)]
      ],
      [COLS,
        scrmdgad:=[TEXT,scrmdname,'Screen Mode:',TRUE,10],
        [PLUGIN,{showscrmd},NEW scrmdpop.aslscrmdplugin(scrmdname,0,320,200,2,1,TRUE)]
      ]
    ])
EXCEPT DO
  END filepop,fontpop,scrmdpop
  IF exception<>0 THEN WriteF('\s\n',[exception,0])
ENDPROC

CHAR '$VER: AslPopupsExample V1.0 Stephen Sinclair (96.07.16)'

PROC dummy(x,s) IS x,s

PROC showfile(x) IS setstr(gh,filegad,filename),x
PROC showfont(x) IS setstr(gh,fontgad,fontname),x
PROC showscrmd(x) IS settext(gh,scrmdgad,scrmdname),x

/* create our own version of easygui so that it uses the global guihandle */
PROC neweasygui(title,gui,info=0,screen=0,font=0) HANDLE
  DEF res=-1
  gh:=guiinit(title,gui,info,screen,font)
  WHILE res<0
    Wait(gh.sig)
    res:=guimessage(gh)
  ENDWHILE
EXCEPT DO
  cleangui(gh)
  ReThrow()
ENDPROC
