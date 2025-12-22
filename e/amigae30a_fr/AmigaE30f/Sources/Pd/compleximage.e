/*   compleximage.e  traduit des exemples de bibliothèques RKRM
     Traduit par Eric Stringer    INTERNET #"NES@delphi.com"
     Ce programme met une image en 2 plans de bit d'une boite dans une fenêtre.
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


      CopyMem([$FFFF,$FF00,    /* Données Image plan 1 */
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $C000,$0300,
               $FFFF,$FF00,

               $0000,$0000,    /* Données Image plan 2 */
               $0000,$0000,
               $0000,$0000,
               $00FF,$0000,
               $00FF,$0000,
               $00FF,$0000,
               $00FF,$0000,
               $0000,$0000,
               $0000,$0000,
               $0000,$0000]:INT,myimagedata:=NewM(80,2),80)

intuitionbase:=OpenLibrary('intuition.library',37)

IF (intuitionbase <> NIL)
   IF (NIL <> (win:=OpenW(20,11,400,100,IFLAGS,$f,'SimpleImage',NIL,1,buf)))


myimage := [ MYIMAGE_LEFT,   /* offset coté gauche */
             MYIMAGE_TOP,    /* offset haut */
             MYIMAGE_WIDTH,  /* largeur de l'image  */
             MYIMAGE_HEIGHT, /* hauteur de l'image */
             MYIMAGE_DEPTH,  /* nombre de plan de bits */
             myimagedata,    /* Données image */
             $3,             /* plan sur lequel les données doivent être mises */
             $0,             /* Met où efface les plans de bit */
             NIL ]:image

       /* Trace l'image sur le 1er plan */
       DrawImage(win.rport, myimage,20,50)
       TextF(10,75,'Premier et second plan')

myimage := [ MYIMAGE_LEFT,   /* offset coté gauche */
             MYIMAGE_TOP,    /* offset haut */
             MYIMAGE_WIDTH,  /* largeur de l'image */
             MYIMAGE_HEIGHT, /* hauteur de l'image */
             MYIMAGE_DEPTH,  /* nombre de plan */
             myimagedata,    /* Donnée image */
             %1010,
             $0,
             NIL ]:image
       /* Trace l'image sur le second plan */
       DrawImage(win.rport, myimage,80,50)

       Delay (200)

       CloseW(win)
    ENDIF
CloseLibrary(intuitionbase)
ENDIF
ENDPROC
