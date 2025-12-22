/*

  This source is Public Domain

*/

MODULE 'easyplugins/dtpic', 
       'tools/EasyGUI', 'tools/exceptions',
       'utility/tagitem'

DEF dt1=NIL:PTR TO dtpic_plugin, dt2=NIL:PTR TO dtpic_plugin

PROC main() HANDLE

    NEW dt1.init([PLA_DTPic_Filename, 'dtpic_data/jupiter.bru', PLA_DTPic_Scale, TRUE, TAG_DONE])
    NEW dt2.init([PLA_DTPic_Filename, 'dtpic_data/andes.bru', PLA_DTPic_Scale, FALSE, TAG_DONE])

  easyguiA('Test',
            [ROWS,
              [PLUGIN, {ignore}, dt1],
              [PLUGIN, {ignore}, dt2]
              ])

EXCEPT DO
  report_exception()
  END dt1
  END dt2
ENDPROC

PROC ignore() IS EMPTY
