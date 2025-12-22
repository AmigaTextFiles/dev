/*  Fraktalstern
 *  Norman Walter 26.12.2001
 *  Demonstriert rekursive Algorithmen
 *  und die Verwendung der Amiga Grafik-Primitiven
 */

-> E version LS 2004

MODULE 'intuition/intuition'

DEF rp
DEF window:PTR TO window

PROC box(x,y,r) IS RectFill(rp,x-r,y-r,x+r,y+r)

PROC star(x,y,r)
   IF r > 0
      star(x-r,y+r,r/2)
      star(x+r,y+r,r/2)
      star(x-r,y-r,r/2)
      star(x+r,y-r,r/2)
      box(x,y,r)
   ENDIF
ENDPROC

PROC main() HANDLE

      window := OpenW(20,
                   20,
                   400,
                   300,
                   NIL,
                   $F,
                   'Snowflake',
                   NIL,1,NIL)

      IF window = NIL THEN Raise("WIN")

      rp := window.rport

      SetAPen(rp, 1)
      RectFill(rp,0,0,400,300)

      SetAPen(rp, 2)

      star(200,150,80)

      WaitLeftMouse(window)

EXCEPT DO

   CloseW(window)

   IF exception = "WIN" THEN WriteF('could not open window!\n')

ENDPROC
