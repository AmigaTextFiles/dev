/* Example of frumSPlugs' Image plugin */
-> $VER: ImageTest.e V1.0 Stephen Sinclair (96.06.16)

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

CHAR '$VER: ImageTest V1.0 Stephen Sinclair (96.06.16)',0

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