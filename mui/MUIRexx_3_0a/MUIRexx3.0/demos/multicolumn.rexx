/* example of a multicolumn list */

MUIA_List_Active =                     0x8042391c /* V4  isg LONG              */
MUIA_List_Format =                     0x80423c0a /* V4  isg STRPTR            */

MUIV_EveryTime = 0x49893131
MUIV_List_Insert_Bottom = -3

address example

window TITLE """Multicolumn List Example""" COMMAND "quit" PORT example
  group
    list ID ALST TITLE """\033bcol 1,\033bcol 2,\033bcol 3""" ATTRS MUIA_List_Format """MIW=25 P=\033c BAR,MIW=50 P=\033c\033b BAR,MIW=25 P=\033c"""
    string ID ASTR COMMAND """list ID ALST INSERT POS "MUIV_List_Insert_Bottom" STRING %s""" PORT example
  endgroup
  group
    list ID BLST TITLE """\033bSingle column list"""
    string ID BSTR COMMAND """list ID BLST INSERT POS "MUIV_List_Insert_Bottom" STRING %s""" PORT example
  endgroup
endwindow
list ID ALST INSERT POS MUIV_List_Insert_Bottom STRING "1,2,3"
list ID ALST INSERT POS MUIV_List_Insert_Bottom STRING "4,5,6"
list ID ALST INSERT POS MUIV_List_Insert_Bottom STRING "7,8,9"
list ID ALST INSERT POS MUIV_List_Insert_Bottom STRING "A,B,C"
list ID ALST INSERT POS MUIV_List_Insert_Bottom STRING "D,E,F"
list ID ALST INSERT POS MUIV_List_Insert_Bottom STRING "G,H,I"
list ID BLST INSERT POS MUIV_List_Insert_Bottom STRING "This is a single column list."
list ID BLST INSERT POS MUIV_List_Insert_Bottom STRING "Try selecting lines from either list."
list ID BLST INSERT POS MUIV_List_Insert_Bottom STRING "This shows some of the new features of MUIRexx."
list ID BLST INSERT POS MUIV_List_Insert_Bottom STRING "Aren''t we impressed?"
callhook ID ALST COMMAND """string ID ASTR CONTENT %s""" PORT example ATTRS MUIA_List_Active MUIV_EveryTime
callhook ID BLST COMMAND """string ID BSTR CONTENT %s""" PORT example ATTRS MUIA_List_Active MUIV_EveryTime
exit
