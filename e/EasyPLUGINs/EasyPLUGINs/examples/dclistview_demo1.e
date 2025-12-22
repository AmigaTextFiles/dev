OPT PREPROCESS, OSVERSION=37

MODULE 'tools/exceptions', 'tools/EasyGUI', 'exec/nodes', 'exec/lists',
       'easyplugins/dclistview', 'tools/constructors', 'utility', 'utility/tagitem'

DEF result=-1

PROC main() HANDLE
  DEF dclist:PTR TO dclistview
  DEF list, a, nodes
  IF (utilitybase:=OpenLibrary('utility.library', 37)) =NIL THEN Raise("util")
  list:=newlist()
  nodes:=['zero','one','two','three','four','five','six','seven',
          'eight','nine','ten','eleven','twelve','thirteen','fourteen']
  ForAll({a}, nodes, `AddTail(list, newnode(NIL, a)))
  NEW dclist.dclistview([DCLV_LABEL, 'L_abel',
                         DCLV_RELX, 15,
                         DCLV_RELY, 7,
                         DCLV_LIST, list,
                         DCLV_CURRENT, result,
                         TAG_DONE])
  easyguiA('Double Click test',
          [EQROWS,
            [DCLIST, {listaction},dclist,TRUE],  ->note use of ID constant (=PLUGIN)
            [EQCOLS,
              [SBUTTON, {okaction}, '_OK', dclist, "o"],
              [SBUTTON, {disable}, '_Disable', dclist, "d"],
              [SBUTTON, {cancelaction}, '_Cancel', NIL, "c"]
            ]
          ])
EXCEPT DO
  IF utilitybase THEN CloseLibrary(utilitybase)
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

PROC disable(dclist:PTR TO dclistview, info) IS dclist.set(DCLV_DISABLED, dclist.get(DCLV_DISABLED)=FALSE)

PROC cancelaction(info)
  PrintF('Operation cancelled.\n')
  quitgui()
ENDPROC

