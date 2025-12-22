OPT OSVERSION=38

MODULE 'easyplugins/textfield','*textfield_mod/aslFR',
       'tools/easygui',
       'intuition','intuition/intuition',
       'utility/tagitem',
       'libraries/gadtools',
       'dos/dos'

PROC main()
DEF tf:PTR TO textfield_plugin, asl:PTR TO aslFR

   NEW asl.asl()
   asl.setname('sys:')

   easyguiA('TextField Demo',
            [ROWS,
               [PLUGIN, 0, NEW tf.textfield()]
            ],
            [EG_MENU,[NM_TITLE,0,'Project'      ,0, 0,0,0,
                      NM_ITEM ,0,'Load...'      ,'l',0,0,{load},
                      NM_ITEM ,0,'Save...'      ,'s',0,0,{save},
                      NM_ITEM ,0,NM_BARLABEL    ,0,0,0,0,
                      NM_ITEM ,0,'About'        ,'?',0,0,{about},
                      NM_ITEM ,0,NM_BARLABEL    ,0,0,0,0,
                      NM_ITEM ,0,'Quit'         ,'q',0,0,0,
                      0,0,0,0,0,0,0]:newmenu,
            EG_INFO, [asl,tf],
            TAG_DONE]
           )

END asl
END tf

ENDPROC


PROC about()
   EasyRequestArgs(NIL,[SIZEOF easystruct,0,'About',
                   'TextField Plugin Demo\n~~~~~~~~~~~~~~~~~~~~~~\nWritten by Ralph Wermke of Digital Innovations\n\nPart of the EasyPLUGINs package',
                    'Okay']:easystruct,NIL,NIL)
ENDPROC

PROC load(l:PTR TO LONG)
DEF asl:PTR TO aslFR, tf:PTR TO textfield_plugin, fh, len=0,
    txt:PTR TO CHAR

   asl:=l[0]
   tf :=l[1]

   IF asl.open('Load Text')
      IF (fh:=Open(asl.name, OLDFILE))
         Seek(fh, 0, OFFSET_END)
         len:=Seek(fh, 0, OFFSET_BEGINNING)
         txt:=New(len+1)
         Read(fh, txt, len)
         txt[len]:=0
         tf.set(PLA_TextField_Text, txt)
         Dispose(txt)
         Close(fh)
      ELSE
         PrintF('ERROR: Can''t open file!\n')
      ENDIF
   ENDIF

ENDPROC

PROC save(l:PTR TO LONG)
DEF asl:PTR TO aslFR, tf:PTR TO textfield_plugin, fh, len, txt

   asl:=l[0]
   tf :=l[1]

   IF asl.open('Save Text',0,TRUE)
      len:=tf.get(PLA_TextField_TextLen)
      txt:=tf.get(PLA_TextField_Text)
      IF (fh:=Open(asl.name, NEWFILE))
         Write(fh, txt, len)
         Close(fh)
      ENDIF
   ENDIF

ENDPROC
