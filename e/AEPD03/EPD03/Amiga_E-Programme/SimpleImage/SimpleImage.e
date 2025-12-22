/*   simpleimage.e  translated from the RKRM libraries examples
     Translated by Eric Stringer    INTERNET #"NES@delphi.com"
     This program puts a single bitplane image of a box in a window.
*/


MODULE 'exec/types','intuition/intuition','intuition/intuitionbase'

CONST MYIMAGE_LEFT = 0
CONST MYIMAGE_TOP  = 0
CONST MYIMAGE_WIDTH = 24
CONST MYIMAGE_HEIGHT = 10
CONST MYIMAGE_DEPTH  = 1
CONST BUFSIZE=GADGETSIZE*3, IFLAGS=IDCMP_CLOSEWINDOW+IDCMP_GADGETUP
DEF buf[BUFSIZE]:ARRAY, w



PROC main()

DEF win:PTR TO window, myimage:PTR TO image, myimagedata:PTR TO LONG,t:PTR TO INT


myimagedata:= [$FFFF,$FF00,    /* Image data  */
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $FFFF,$FF00]:INT

intuitionbase:=OpenLibrary('intuition.library',37)

IF (intuitionbase <> NIL)
   IF (NIL <> (win:=OpenW(20,11,400,100,IFLAGS,$f,'SimpleImage',NIL,1,buf)))


myimage := [ MYIMAGE_LEFT,   /* leftedge offset */
             MYIMAGE_TOP,    /* topedge offset  */
             MYIMAGE_WIDTH,  /* width of image  */
             MYIMAGE_HEIGHT, /* height of image */
             MYIMAGE_DEPTH,  /* number of bitplanes */
             myimagedata,    /* image data          */
             $1,             /* plane on which data is to be put */
             $0,             /* Set or clear other planes   */
             NIL ]:image

       /* Draw Image on first bit plane  */
       DrawImage(win.rport, myimage,20,50)
       TextF(10,75,'First & second bit plane')

myimage := [ MYIMAGE_LEFT,   /* leftedge offset */
             MYIMAGE_TOP,    /* topedge offset  */
             MYIMAGE_WIDTH,  /* width of image  */
             MYIMAGE_HEIGHT, /* height of image */
             MYIMAGE_DEPTH,  /* number of bitplanes */
             myimagedata,    /* image data          */
             $2,
             $0,
             NIL ]:image
       /* draw Image on second plane */
       DrawImage(win.rport, myimage,80,50)

       Delay (200)

       CloseW(win)
    ENDIF
CloseLibrary(intuitionbase)
ENDIF
ENDPROC


