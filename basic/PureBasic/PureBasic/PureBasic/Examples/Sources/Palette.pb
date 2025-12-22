;
; ***********************************
;
; Palette example file for Pure Basic
;
;    © 1999 - Fantaisie Software -
;
; ***********************************
;
;

InitScreen(0)  ; We need 1 screen
InitPalette(2) ; and 3 palettes objects

*ScrID = FindScreen(0,"") ; Get the default public screen and get its ID

ShowScreen()   ; Bring it to front

GetScreenPalette(1, *ScrID) ; Get the palette of the screen and save it
GetScreenPalette(2, *ScrID) ; in the palette 1 and 2

UsePalette(2)               ; Set the palette 2 as used palette

PaletteRgb(1, 255, 0, 0)        ; Change the colour 1 of the used palette to red

ScreenRgb(*ScrID, 1, 255, 255, 0) ; Change the display colour 1 to yellow !

CreatePalette(0,1 << ScreenDepth()) ; Create a blank palette with the number of colour of the screen

UsePalette(1)

PaletteRgb(1, 0, 0, 0)

#Rate = 5

a = Fade(0, 2, *ScrID, #Rate, 255/#Rate) ; Perform a nice fade between the palette 0 and 3

FadeOut(2, *ScrID, #Rate, 255/#Rate)     ; Finish with a cool fade out

DisplayPalette(1, *ScrID)

PrintN("Colour 3:"+Str(ScreenRed(3))+","+Str(ScreenGreen(3))+","+Str(ScreenBlue(3)))
PrintN("NbColour: "+Str(NbColour()))

End
