-> testmulti2.e - Another very simple use of multi-window GUI support.

OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui'
#endif

MODULE 'tools/exceptions', 'intuition/intuition'

-> The global for use with multiforall().
DEF gh:PTR TO guihandle

PROC main() HANDLE
  DEF mh=NIL, gh1:PTR TO guihandle,res
  mh:=multiinit()
  gh1:=addmultiA(mh,'GUI One',
                [ROWS,
                  [TEXT,'The first GUI.',NIL,TRUE,13],
                  [SBUTTON,{but1},'Press Me']
                ],
                [EG_LEFT,10, EG_TOP,20, NIL])
  addmultiA(mh,'GUI Two',
                [ROWS,
                  [TEXT,'And the second GUI.',NIL,TRUE,13],
                  [SBUTTON,{but2},'Press Me']
                ],
                -> Put the second window below the first, but hidden.
                [EG_LEFT,10, EG_TOP,gh1.wnd.topedge+gh1.wnd.height,
                 EG_HIDE,TRUE, NIL])
  -> Could add more...
  res:=multiloop(mh)
EXCEPT DO
  cleanmulti(mh)
  report_exception()
ENDPROC

-> Button on GUI one does something special.
PROC but1(info:PTR TO guihandle)
  WriteF('Hit button on GUI One. Closing then opening.\n')
  multiforall({gh},info.mh,
             `IF gh.wnd THEN WriteF('Title="\s"\n',gh.wnd.title) BUT closewin(gh) ELSE 0)
  WriteF('Sleeping a bit...\n')
  Delay(100)
  WriteF('Awake!\n')
  -> This shows that gh.wnd is NIL when the window is closed.
  multiforall({gh},info.mh,
              `WriteF('Win=$\h\n',gh.wnd) BUT openwin(gh))
ENDPROC

PROC but2(i) IS WriteF('Hit button on GUI Two\n')
