/*
**
** Demo for register PLUGIN
**
** Copyright: Ralph Wermke of Digital Innovations
** EMail    : wermke@gryps1.rz.uni-greifswald.de
** WWW      : http://www.user.fh-stralsund.de/~rwermke/di.html
**
** Date     : 02-Nov-1997
**
*/

OPT PREPROCESS

MODULE 'tools/easygui','tools/exceptions','tools/installhook',
       'utility/tagitem', 'utility/hooks',
       'easyplugins/register'

DEF h:hook, gh, g1, currentslider

PROC main() HANDLE
DEF mp:PTR TO register_plugin, labels, listlen

   labels :=['One','Two','Three','Four','Five']
   listlen:=ListLen(labels)-1

   /* init action hook */
   installhook(h, {actionhook})

   /* create new instance */
   NEW mp.register([PLA_Register_Titles, labels,
                    PLA_Register_ActionHook, h,
                    PLA_Register_ActivePage, PLV_Register_ActivePage_Next,
                    TAG_DONE])

   /* set attributes before gui is open */
   mp.set(PLA_Register_ActivePage, PLV_Register_ActivePage_Next)
   mp.set(PLA_Register_Disabled, TRUE)

   /* open gui */
   easyguiA('Register Test',
            [ROWS,
               [PLUGIN, {ignore}, mp],
               [BEVEL,
                  [EQCOLS,
                     [SBUTTON, {setfirst}, 'First', mp],
                     [SBUTTON, {setlast}, 'Last', mp],
                     [SBUTTON, {setprev}, 'Previous', mp],
                     [SBUTTON, {setnext}, 'Next', mp],
                     [SBUTTON, {dis}, 'Toggle', mp],
                     g1:=[SLIDE, {scroll}, NIL, FALSE, 0, listlen, 0, 2, '', mp]
                  ]
               ],
               [SBUTTON, {cwin}, 'Close', mp]
            ],
            [EG_GHVAR,{gh}, TAG_DONE])
EXCEPT
   END mp
   report_exception()
ENDPROC

/* action functions */
PROC ignore(i, mp:PTR TO register_plugin) IS EMPTY
PROC setfirst(mp:PTR TO register_plugin, i) IS mp.set(PLA_Register_ActivePage, PLV_Register_ActivePage_First)
PROC setlast(mp:PTR TO register_plugin, i) IS mp.set(PLA_Register_ActivePage, PLV_Register_ActivePage_Last)
PROC setnext(mp:PTR TO register_plugin, i) IS mp.set(PLA_Register_ActivePage, PLV_Register_ActivePage_Next)
PROC setprev(mp:PTR TO register_plugin, i) IS mp.set(PLA_Register_ActivePage, PLV_Register_ActivePage_Prev)
PROC dis(mp:PTR TO register_plugin, i) IS mp.set(PLA_Register_Disabled, Not(mp.get(PLA_Register_Disabled)))
PROC scroll(mp:PTR TO register_plugin, info, x) IS mp.set(PLA_Register_ActivePage, currentslider:=x)

/* set attributes during window is closed */
PROC cwin(mp:PTR TO register_plugin, i)
   closewin(gh)
   mp.set(PLA_Register_ActivePage, PLV_Register_ActivePage_Last)
   mp.set(PLA_Register_Disabled, TRUE)
   openwin(gh)
ENDPROC

/* sample action hook */
PROC actionhook(hook, obj, x)
   PrintF('hook=$\h obj=$\h current=\d\n', hook, obj, x)
   IF x<>currentslider        /* avoid recursion */
      setslide(gh, g1, x)
      currentslider:=x
   ENDIF
ENDPROC

