;
; *******************************************
;
; Font management example file for PureBasic
;
;       © 1999 - Fantaisie Software -
;
; *******************************************
;
;

InitFont(1)    ; We will need 2 fonts...
InitWindow(0)  ; ... and 1 window

If LoadFont(0,"XHelvetica.font",11)                 ; Load our font and check if the
  PrintN("Your system has the XHelvetica font.")   ; font is found or not.
  OkXHelvetica = 1                                   ;
Endif 

If LoadFont(1,"topaz.font",8)   ; The same for topaz font
  PrintN("Topaz font found.")    ;
  OkTopaz = 1                    ;
EndIf

If OpenWindow(0,10,100,200,200,0,0)  ; Open our window

  DrawingOutput(WindowRastPort()) ; 2D Drawing will be done on our window

  FrontColour(1)

  If OkTopaz                  ; Display text with the different fonts
    UseFont(1)                ;
    DrawingFont(FontID())     ;
    Locate(20,30)             ;
    PrintText("Topaz")        ;
  EndIf                       ;
                              ;
  If OkXHelvetica             ;
    UseFont(0)                ;
    DrawingFont(FontID())     ;
    Locate(20,50)             ;
    PrintText("XHelvetica")   ;
  Endif                       ;

  MouseWait()                 ; Wait the user mouse click

Endif

End                           ; Free all ressources and quit
