/* Example of frumSPlugs' ImageButton plugin. */
-> $VER: ImageButtonTest.e V1.0 Stephen Sinclair (96.06.16)

OPT OSVERSION=37
MODULE 'Tools/EasyGUI','Intuition/intuition','Plugins/ImageButton',
       'Intuition/ImageClass','Utility'

PROC main() HANDLE
  DEF ip:PTR TO imagebuttonplugin

  IF utilitybase:=OpenLibrary('utility.library',0)
    easygui('Blah',
      [ROWS,
        [TEXT,'Image:',NIL,TRUE,STRLEN],

/* Create a button from an intuition image.  This particular image is  **
** just a solid colour, but you could give it imagery simply by giving **
** it a pointer to some bitplane data.                                 */
        [PLUGIN,{customimage},NEW ip.imagebuttonplugin([0,0,50,50,2,NIL,0,3,NIL]:image,[0,0,50,50,2,NIL,0,7,NIL]:image)],
        [BUTTON,0,'Quit']
      ]
    )
  ENDIF

EXCEPT

/* Always END the object! */
  END ip
  IF utilitybase THEN CloseLibrary(utilitybase)
  WriteF('\s\b',[exception,0])
ENDPROC

CHAR '$VER: ImageButtonTest V1.0 Stephen Sinclair (96.06.16)',0

PROC customimage(x) IS WriteF('You clicked the custom image!\n'),x

/*
(----) OBJECT image
(   0)   leftedge:INT
(   2)   topedge:INT
(   4)   width:INT
(   6)   height:INT
(   8)   depth:INT
(  10)   imagedata:PTR TO INT
(  14)   planepick:CHAR
(  15)   planeonoff:CHAR
(  16)   nextimage:PTR TO image
(----) ENDOBJECT     /* SIZEOF=20 */
*/