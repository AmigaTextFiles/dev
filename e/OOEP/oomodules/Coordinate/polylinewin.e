/*

Just draws some circle. Remove the Delay() and the second Plot() to
see its speed :)

*/

OPT PREPROCESS

MODULE 'oomodules/coordinate', 'oomodules/coordinate/polyline'

#define NULL_X (200)
#define NULL_Y (100)

DEF lastx=0,lasty=0,firstelement,polycolour

PROC main()
DEF win, coo:PTR TO coordinate,count,co2:PTR TO coordinate,
    polyline:PTR TO polyline, co3:PTR TO coordinate,
    co4:PTR TO coordinate

  NEW coo.new(["set",50.0,50.0,0.0])
  NEW co2.new(["set",0.0,-50.0,25.0])
  NEW co3.new(["set",-35.0,35.0,0.0])
  NEW co4.new(["set",50.0,50.0,0.0])

  NEW polyline.new()

  polyline.add(coo)
  polyline.add(co2)
  polyline.add(co3)
  polyline.add(co4)

  win := OpenW(0,0,400,200,0,$F,'ui',0,1,0,0)


  Line(NULL_X-100, NULL_Y, NULL_X+100, NULL_Y)
  Line(NULL_X, NULL_Y-50, NULL_X, NULL_Y+50)


  FOR count:=0 TO 180*5

    firstelement:=TRUE

    polycolour:=1
    polyline.coordinates.do({draw}) -> draw it

    WaitTOF()
    polycolour:=0
    polyline.coordinates.do({draw}) -> delete it

    polyline.coordinates.do({rotate}) -> rotate it
  ENDFOR

  Delay(150)

  CloseW(win)

ENDPROC

PROC drawline (x,y,x2,y2,colour=1)

    Line(NULL_X+(x/2),NULL_Y+(y/4),
         NULL_X+(x2/2)  ,NULL_Y+(y2/4),colour)

ENDPROC


PROC draw(obj:PTR TO coordinate)
DEF nux,nuy

  nux:=!obj.getX()!
  nuy:=!obj.getY()!

 /*
  * Die Flagge wird gelöscht, wenn das erste Element abgerabeitet wird.
  * Da Linien gezeichnet werden und der vorherige Punkt jeweils der Startpunkt
  * ist, kann beim ersten Punkt natürlich keine Linie gezeichnet werden...
  */

  IF firstelement=TRUE
    firstelement := FALSE
  ELSE
    drawline(lastx,lasty, nux, nuy,polycolour)
  ENDIF

  lastx:=nux
  lasty:=nuy
ENDPROC

PROC rotate(obj:PTR TO coordinate)

  obj.rotateY(2.0)
ENDPROC
