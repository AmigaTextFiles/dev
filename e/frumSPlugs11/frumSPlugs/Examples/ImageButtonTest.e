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

/* Example of frumSPlugs' ImageButton plugin. */
-> $VER: ImageButtonTest.e V1.1 Stephen Sinclair (96.07.15)

OPT OSVERSION=37
MODULE 'Tools/EasyGUI','Intuition/intuition','Plugins/ImageButton',
       'Intuition/ImageClass'

PROC main() HANDLE
  DEF ip:PTR TO imagebuttonplugin
  easygui('Blah',
    [ROWS,
      [TEXT,'Image:',NIL,TRUE,STRLEN],

/* Create a button from an intuition image.  This particular image is  **
** just a solid colour, but you could give it imagery simply by giving **
** it a pointer to some bitplane data.                                 */

      [PLUGIN,{customimage},NEW ip.imagebuttonplugin([0,0,50,50,2,NIL,0,3,NIL]:image,[0,0,50,50,2,NIL,0,7,NIL]:image,FALSE)],
      [BUTTON,0,'Quit']
    ]
  )
EXCEPT
/* Always END the object! */
  END ip
  IF exception<>0 THEN WriteF('Exception: \s\n',[exception,0])
ENDPROC

CHAR '$VER: ImageButtonTest V1.1 Stephen Sinclair (96.07.15)',0

PROC customimage(x) IS WriteF('You clicked the custom image!\n'),x
