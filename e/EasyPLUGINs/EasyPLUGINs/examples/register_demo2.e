/*
**
** Demo for register PLUGIN (based on tabs_test.e shipped with easygui)
**
** Copyright: Ralph Wermke of Digital Innovations
** EMail    : wermke@gryps1.rz.uni-greifswald.de
** WWW      : http://www.user.fh-stralsund.de/~rwermke/di.html
**
** Date     : 03-Sep-1997
**
*/

MODULE 'tools/easygui', 'tools/exceptions',
       'utility/tagitem',
       'easyplugins/register'

PROC main() HANDLE
  DEF r=NIL:PTR TO register_plugin

  NEW r.register([PLA_Register_Titles,['Display','Edit','File'],
                 TAG_DONE])

  easyguiA('Register in EasyGUI!',
    [ROWS,
      [TEXT,'Register test...',NIL,TRUE,5],
      [PLUGIN,{regsaction},r],
      [EQCOLS,
        [BUTTON,{reset},'Reset',r],
        [BUTTON,{toggle_enabled},'Toggle Enabled',r]
      ]
    ])
EXCEPT DO
  END r
  report_exception()
ENDPROC

PROC regsaction(i,r:PTR TO register_plugin)
  WriteF('reg value = \d\n', r.get(PLA_Register_ActivePage))
ENDPROC

PROC reset(r:PTR TO register_plugin,i)
  r.set(PLA_Register_ActivePage, PLV_Register_ActivePage_First)
ENDPROC

PROC toggle_enabled(r:PTR TO register_plugin,i)
  r.set(PLA_Register_Disabled, Not(r.get(PLA_Register_Disabled)))
ENDPROC
