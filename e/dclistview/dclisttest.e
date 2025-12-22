OPT PREPROCESS, OSVERSION=37

MODULE 'tools/exceptions', 'tools/EasyGUI', 'exec/nodes', 'exec/lists',
       'plugins/dclistview', 'tools/constructors', 'utility/tagitem',
       '*fonts', 'graphics/text'

DEF result=-1
DEF deffixedfont:PTR TO textfont

PROC main() HANDLE
  DEF dclist:PTR TO dclistview
  DEF list, a, nodes, attr:PTR TO textattr

-> let's make up a quick list
  list:=newlist()
  nodes:=['zero','one','two','three','four','five','six','seven',
          'eight','nine','ten','eleven','twelve','thirteen','fourteen']
  ForAll({a}, nodes, `AddTail(list, newnode(NIL, a)))
  getdeffonts()  -> Let's use the screen's fixed width font
                 -> Ugly alert: Gadtools uses this font for the label as well
  attr:=[deffixedfont::ln.name, deffixedfont.ysize, deffixedfont.style, deffixedfont.flags]:textattr

  NEW dclist.dclistview([DCLV_USEARROWS, TRUE,
                         DCLV_LABEL, 'Label',
                         DCLV_RELX, 15,
                         DCLV_RELY, 8,
                         DCLV_LIST, list,
                         DCLV_CURRENT, result,
                         DCLV_TEXTATTR, attr,
                         TAG_DONE])
  easyguiA('Double Click test',
          [EQROWS,
            [DCLIST, {listaction},dclist,TRUE],
            [EQCOLS,
              [SBUTTON, {okaction}, '_OK', dclist, "o"],
              [SBUTTON, {disable}, '_Disable', dclist, "d"],
              [SBUTTON, {cancelaction}, '_Cancel', NIL, "c"]
            ]
          ])
EXCEPT DO
  END dclist
  IF exception<>"QUIT" THEN report_exception()
ENDPROC

PROC listaction(info, dclist:PTR TO dclistview)
  IF dclist.get(DCLV_CLICK) THEN okaction(dclist, NIL)
  PrintF('Current Selection: \d\n',dclist.get(DCLV_CURRENT))
ENDPROC

PROC okaction(dclist:PTR TO dclistview, info)
  IF (result:=dclist.get(DCLV_CURRENT))= -1
    PrintF('No selection made\n')
    cancelaction(info)
  ENDIF
  PrintF('Final Selection: \d\n',result)
  quitgui(result)
ENDPROC

PROC disable(dclist:PTR TO dclistview, info) IS dclist.setA([DCLV_DISABLED, dclist.get(DCLV_DISABLED)=FALSE,TAG_DONE])

PROC cancelaction(info)
  PrintF('Operation cancelled.\n')
  quitgui()
ENDPROC

vers: CHAR 0, '$VER: dclisttest 1.6 (19.1.99)', 0

