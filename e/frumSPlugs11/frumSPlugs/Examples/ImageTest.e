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

/* Example of frumSPlugs' Image plugin */
-> $VER: ImageTest.e V1.1 Stephen Sinclair (96.07.15)

OPT OSVERSION=37
MODULE 'Tools/EasyGUI','Intuition/intuition','Plugins/Image'

PROC main()
  DEF data,img,ip:PTR TO imageplugin
  IF data:=AllocRaster(50,50)
    img:=[0,0,50,50,1,data,$FF,0,NIL]:image
    easygui('Blah',
      [EQROWS,
        [TEXT,'Image:',NIL,TRUE,STRLEN],

/* Put an intuition image in the gui with a bevel box around it.  This    **
** particular image is just a solid colour, but you could give it imagery **
** simply by giving it a pointer to some bitplane data.                   */
        [BEVEL,[PLUGIN,0,NEW ip.imageplugin(img)]],
        [BUTTON,0,'Quit']
      ]
    )
    FreeRaster(data,50,50)
  ENDIF
ENDPROC

CHAR '$VER: ImageTest V1.1 Stephen Sinclair (96.07.15)',0
