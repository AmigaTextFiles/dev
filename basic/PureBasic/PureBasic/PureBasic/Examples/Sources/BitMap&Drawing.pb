;
; ***********************************************
;
; BitMap & 2D Drawing example file for Pure Basic
;
;       © 1999 - Fantaisie Software -
;
; ***********************************************
;
;

InitBitMap(1)   ; We will need 2 bitmaps...
InitScreen(0)   ; ... and 1 screen

AllocateBitMap(0,320,200*2,5)  ; Create our bitmaps
AllocateBitMap(1,320,200*2,5)  ;

If OpenScreen(0, 320, 200, 5, 0) ; Open a little screen 320*320 - 32 colours

  UseBitMap(0)  ; Set the bitmap 0 as used bitmap

  DrawingOutput(BitMapRastPort())  ; Set the 2D Drawing output to the bitmap 0

  FrontColour(1)         ; Change the front colour to 1
  BoxFill(30,30,60,60)   ; Draw a box of this colour !

  FrontColour(2)         ;
  Circle(60,60,50)       ; A circle...

  Ellipse(200,50,10,30)  ; ... followed by an ellipse

  FrontColour(4)
  Line(200,200,100,100)

  FrontColour(5)             ; Look, we print some text using the default font.
  Locate(200,200)            ;
  PrintText("Hello World")   ;

  UseBitMap(1)               ; Ok it's finished for this bitmap, now draw the bitmap 1

  DrawingOutput(BitMapRastPort())

  FrontColour(2)

  For k = 0 to 200 Step 2  ; A line of plots.
    Plot(k,k)              ;
  Next                     ;

  PrintN("Length in pixel of 'I'm Here': " +Str(TextLength("I'm Here")))

  Time = 100

  Repeat
    VWait()
    ShowBitMap(db,ScreenID(),0,y)

    db = 1-db               ; Look the double buffering routine. db is alternatively 0 and 1
    Time = Time-1           ;

    If y<200
      y=y+1
    Else
      y = 200
    EndIf
  Until Time = 0

EndIf

End      ; Finish the program and free all stuffs.
