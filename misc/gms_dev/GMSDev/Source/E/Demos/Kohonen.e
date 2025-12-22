/* Kohonen Feature Maps in E, implemented with integers
**
** Kohonen feature maps are special types of neural nets, and
** this implementation shows graphically how they organise themselves
** after a while.
**
** [This demo from the AmigaE archives has been converted to work with GMS.
** It is at about 33% faster than the original intuition version.]
*/

CONST ONE     = 1024*16,   KSHIFT = 14,      KSIZE  = 7,
      MAXTIME = 500,       DELAY  = 0,       YOFF   = 20
CONST KSTEP   = ONE/KSIZE, KNODES = KSIZE+1, ARSIZE = KSIZE*KSIZE,
      XRED    = 64,        YRED   = 128,     XOFF   = 10

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel','gms/graphics/pictures'
MODULE 'gms/files/files','gms/screens','gms/system/register','gms/system/modules'
MODULE 'gms/input/joydata','gms/graphics/screens','gms/graphics/blitter'
MODULE 'gms/blitter'

/*=========================================================================*/

PROC main()
 DEF screen    = NIL:PTR TO screen,
     scrmodule = NIL:PTR TO module,
     bltmodule = NIL:PTR TO module,
     map, t, input, x, y

 IF dpkbase := OpenLibrary('GMS:libs/dpkernel.library',0)
  IF (scrmodule := Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_SCREENS,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))
      scrbase := scrmodule.modbase

  IF (bltmodule := Init([TAGS_MODULE,NIL,
      MODA_NUMBER,    MOD_BLITTER,
      MODA_TABLETYPE, JMP_AMIGAE,
      TAGEND], NIL))
      bltbase := bltmodule.modbase

    IF (screen := Init([TAGS_SCREEN,NIL,
       GSA_Attrib,    SCR_DBLBUFFER OR SCR_CENTRE,
       GSA_ScrMode,   SM_HIRES,
       GSA_Width,     320,
       GSA_Height,    256,
         GSA_BitmapTags, NIL,
         BMA_Planes,     2,
         BMA_Palette,    [ PALETTE_ARRAY, 2, $000000, $f0f0f0 ],
         TAGEND,         NIL,
       TAGEND],NIL))

        Show(screen)

        map := kohonen_init(KSIZE,KSIZE,2)

        FOR t := 0 TO MAXTIME-1
          input := [Rnd(KNODES)*KSTEP,Rnd(KNODES)*KSTEP]
          x,y   := kohonen_BMU(map,input)
          kohonen_plot(map,screen,x,y)
          kohonen_learn(map,x,y,MAXTIME-t*(ONE/MAXTIME),input)
        ENDFOR

        WaitTime(100)

    Free(screen)
    ENDIF
   Free(bltmodule)
   ENDIF
  Free(scrmodule)
  ENDIF
 CloseDPK()
 ENDIF
ENDPROC

/*=========================================================================*/

PROC kohonen_plot(map,screen:PTR TO screen,bx,by)
DEF x,y,n:PTR TO LONG,cx,cy,i,ii,sx[ARSIZE]:ARRAY OF LONG
DEF sy[ARSIZE]:ARRAY OF LONG

  Clear(screen.bitmap)
  FOR x:=0 TO KSIZE-1
    FOR y:=0 TO KSIZE-1
      n := kohonen_node(map,x,y)
      i := x*KSIZE+y
      ii := x-1*KSIZE+y
      sx[i] := cx := s(n[0]/XRED+XOFF)
      sy[i] := cy := s(n[1]/YRED+YOFF)
      IF x>0 THEN DrawLine(screen.bitmap,sx[ii],sy[ii],cx,cy,1,$FFFFFFFF)
      IF y>0 THEN DrawLine(screen.bitmap,sx[i-1],sy[i-1],cx,cy,1,$FFFFFFFF)
    ENDFOR
  ENDFOR

  n := kohonen_node(map,bx,by)
  DrawPixel(screen.bitmap,s(n[0]/XRED+XOFF),s(n[1]/YRED+YOFF),1)
  WaitAVBL()
  SwapBuffers(screen)
  screen.bitmap.data := screen.memptr2
ENDPROC

/*=========================================================================*/

PROC s(c) IS IF c<0 THEN 0 ELSE IF c>1000 THEN 1000 ELSE c

/*=========================================================================*/

PROC kohonen_BMU(map,i:PTR TO LONG)
  DEF x,y,act,bestx,besty,bestact=$FFFFFFF,n:PTR TO LONG,len,a

  len:=ListLen(i)-1
  FOR x:=0 TO KSIZE-1
    FOR y:=0 TO KSIZE-1
      n:=kohonen_node(map,x,y)
      act:=0
      FOR a:=0 TO len DO act:=Abs(n[a]-i[a])+act
      IF act<bestact
         bestx := x
         besty := y
         bestact := act
      ENDIF
    ENDFOR
  ENDFOR

ENDPROC bestx,besty

/*=========================================================================*/

PROC kohonen_learn(m,bx,by,t,i:PTR TO LONG)
  DEF x,y,n:PTR TO LONG,d,a,len,bell:PTR TO LONG

  bell:=[50,49,47,40,25,13,10,8,6,5,4,3,2,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  len:=ListLen(i)-1

  FOR x:=0 TO KSIZE-1
    FOR y:=0 TO KSIZE-1
      n:=kohonen_node(m,x,y)
      d:=t*bell[Abs(bx-x)+Abs(by-y)]/50      -> cityblock
      IF d>0
        FOR a:=0 TO len DO n[a]:=n[a]+Shr(i[a]-n[a]*d,KSHIFT)
      ENDIF
    ENDFOR
  ENDFOR
ENDPROC

/*=========================================================================*/

PROC kohonen_node(map:PTR TO LONG,x,y)
  DEF r:PTR TO LONG
  r:=map[x]
ENDPROC r[y]

/*=========================================================================*/

PROC kohonen_init(numx,numy,numw)
DEF m:PTR TO LONG,r:PTR TO LONG,w:PTR TO LONG,a,b,c
  NEW m[numx]
  FOR a:=0 TO numx-1
    m[a]:=NEW r[numy]
    FOR b:=0 TO numy-1
      r[b]:=NEW w[numw]
      FOR c:=0 TO numw-1 DO w[c]:=ONE/2
    ENDFOR
  ENDFOR
ENDPROC m

