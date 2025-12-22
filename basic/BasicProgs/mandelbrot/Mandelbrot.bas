1 '
1 ' Tacky, hacky program to do Mandelbrot pretty color pictures
1 '
1 ' Some storage declarations
1 '   XOrigin        Real part Origin
1 '   YOrigin        Imaginary part origin
1 '   Iterations%    Maximum number of iterations for each point
1 '   DeltaX         Maximum X delta
1 '   DeltaY         Maximum Y delta
1 '   X%             Current X coordinate
1 '   Y%             Current Y coordinate
1 '   XInc%          X increment
1 '   YInc%          Y increment
1 '   ScreenX%       Screen X coordinate
1 '   ScreenY%       Screen Y coordinate
1 '   MouseX         Screen X coordinate of mouse origin
1 '   MouseY         Screen Y coordinate of mouse origin
1 '   MouseDX        Screen delta X for mouse box
1 '   Scale%()       Current scaling array
1 '   Screen%        An array to save the screen into
1 '   FileName$      The filename to write the screen into
1 '   Resolution%    Screen resolution (0=320, 1=640)
1 '   BitPlanes%     Number of bit planes to use
1 '   Prompt$        Command prompt string
1 '   Command$       Command string
1 '   Upper$         String of upper case characters
1 '   Lower$         String of lower case characters
1 '   LowerCase%     Non-zero if lower case characters are ok from the command
1 '   Valid%         Non-zero if the screen data is valid
1 '   MouseValid%    Non-zero if the mouse data is valid
1 '   Default        Default numeric argument
1 '   Result         Numeric argument from keyboard
1 '   Direction%     Sign of direction for UP/DOWN/LEFT/RIGHT
1 '   Code%          Array containing iteration loop code
1 '   Regs%          Array containing registers for LibCall
1 '   ContourValid%  Non-zero if contouring array has been built
1 '   Boot%          True if we're bootstrapping
1 '
1000 Dim Scale%(2000), Screen%(16010), Code%(150), Regs%(16)
1010 Upper$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
1020 Lower$ = "abcdefghijklmnopqrstuvwxyz"
1030 Def FnMax(a%, b%) = a% - (a% < b%) * (b% - a%)
1035 Boot% = 0                            ' Assume not booting
1 '
1 ' Read the initial mandelbrot set:
1 '
1040 FileName$ = "MandelSet.640"
1050 GoSub 13000 : If Success% Then GoTo 1100
1060 FileName$ = "MandelSet.320"
1070 GoSub 13000 : If Success% Then GoTo 1100
1075 XOrigin = -2.0 : YOrigin = -1.125 : DeltaX = 3.99 : DeltaY = DeltaX * 180 / 320
1076 Iterations% = 250 : Resolution% = 0  ' Default iterations and resolution
1077 BitPlanes% = 4                       ' Default number of bit planes
1080 FileName$ = "MandelSet.320"          ' Default bootstrap filename
1090 Boot% = -1                           ' We're bootstrapping !
1 '
1 ' Read the iteration loop from disk:
1 '
1100 BLoad "MandelMung", VarPtr(Code%(0))
1 '
1 ' Zero all the regs:
1 '
1110 For I% = 0 to 15
1120    Regs%(I%) = 0
1130 Next I%
1140 ContourValid% = 0                  ' Contour array isn't valid yet
1150 MouseValid% = 0                    ' No valid mouse data yet
1 '
1 ' Setup the screen
1 '
2000 RGB 0, 0, 0, 0                     ' Set color register zero to black
2010 RGB 1, 6, 9, 15                    ' Set color register 1 to dark blue
2020 Screen Resolution%, BitPlanes%, 0  ' Setup screen resolution
2030 ScnClr                             ' Make sure the screen is clear
2040 If Boot% Then GoTo 6000            ' Compute set if in boot mode
2050 GShape (0, 0), Screen%()           ' Restore the old screen data
2060 Valid% = 1                         ' Say our data isn't valid
1 '
1 ' Look for some commands:
1 '
3000 GoSub 10000                 ' Wait for the user to be ready
3010 GShape (0, 0), Screen%      ' Restore the screen
3015 Prompt$ = "Command: "       ' Get the command prompt
3020 LowerCase% = 0              ' Make sure everything's upper case
3025 GoSub 14000                 ' Get the command string
3030 If Command$ = "EXIT"  Then End
3035 If Command$ = "GO"    Then GoTo 6000
3040 If Command$ = "SAVE"  Then GoTo 3100
3045 If Command$ = "RESET" Then GoTo 1010
3050 If Command$ = "READ"  Then GoTo 3200
3055 If Command$ = "CLEAR" Then GoTo 3500
3060 If Command$ = "SET"   Then GoTo 3300
3065 If Command$ = "SHOW"  Then GoTo 3400
3070 If Command$ = "UP"    Then GoTo 3600
3075 If Command$ = "DOWN"  Then GoTo 3610
3077 If Command$ = "RIGHT" Then GoTo 3700
3079 If Command$ = "LEFT"  Then GoTo 3710
3080 If Command$ = "ZOOM"  Then GoTo 3800
3085 If Command$ = "MOUSE" Then GoTo 4000
3090 If Command$ = "SYSTEM" Then System
3097 If Command$ = "HELP"  Then GoTo 3900
3098 If Command$ = ""      Then GoTo 3000
3099 Print at (0,0) "? Command error";: GoTo 3000
1 '
1 ' He wants to save something, prompt for the filename:
1 '
3100 If Valid% Then GoTo 3120    ' Only do this if screen active
3110 Print at (0,0) "? Data not computed";: GoTo 3000
3120 Prompt$ = "File name: "     ' Ask him for a filename
3130 LowerCase% = 1              ' Say lowercase here is ok
3140 GoSub 14000                 ' Go get the filename
3150 FileName$ = Command$        ' Copy the filename
3160 GoSub 12000                 ' Go write the file
3165 Boot% = 0                   ' We aren't booting anymore I guess
3170 If Success% Then GoTo 3010  ' Ok, go ask for another command
3180 Print at (0,0) "? File write error";
3190 GoTo 3000                   ' Wait for the mouse again
1 '
1 ' He wants to read a file.  Prompt for it:
1 '
3200 Prompt$ = "File name: "     ' Ask him for a filename
3210 LowerCase% = 1              ' Say lowercase here is ok
3220 GoSub 14000                 ' Ask for the filename
3230 FileName$ = Command$        ' Copy the filename
3240 GoSub 13000                 ' Go read the file
3250 If Success% Then GoTo 2000  ' Re-init the screen if happy
3260 Print at (0,0) "? File read error - Reset";
3270 GoSub 10000                 ' Wait for a mouse button
3280 GoTo 1010                   ' And restart
1 '
1 ' Prompt the user for the new values:
1 '
3300 Prompt$ = "X Origin "   : Default = XOrigin         : GoSub 16000
3305 XOrigin = Result
3310 Prompt$ = "Y Origin "   : Default = YOrigin         : GoSub 16000
3315 YOrigin = Result
3320 Prompt$ = "Delta X "    : Default = DeltaX          : GoSub 16000
3325 DeltaX = Result : DeltaY = DeltaX * 180/320
3330 Prompt$ = "Iterations " : Default = Iterations%     : GoSub 16000
3335 Iterations% = Result
3340 Prompt$ = "Resolution " : Default = Resolution%     : GoSub 16000
3345 Resolution% = Result
3350 Prompt$ = "Bit Planes " : Default = BitPlanes%      : GoSub 16000
3355 BitPlanes% = Result
3360 If ((Resolution% + BitPlanes%) < 6) And (Resolution% > -1) And (Resolution% < 2) And (BitPlanes% > 0) Then 3390
3370 Print at (0,0) "? Illegal resolution/bitplane values" : GoTo 3000
3390 GoTo 3880                   ' Say the screen and mouse isn't valid
1 '
1 ' Show the current values:
1 '
3400 If MouseValid% = 0 Then Print at (0,0) "X Origin = "; XOrigin; " Y Origin = "; YOrigin
3405 If MouseValid% = 1 Then Print at (0,0) "X Origin = "; MouseX ; " Y Origin = "; MouseY
3410 If MouseValid% = 0 Then Print "Delta X  = "; DeltaX; " Delta Y  = "; DeltaY
3415 If MouseValid% = 1 Then Print "Delta X  = "; MouseDX;" Delta Y  = "; MouseDY
3420 Print "Iterations = "; Iterations%
3430 Print "Resolution = "; Resolution%
3450 Print "  Bit Planes = "; BitPlanes%;
3460 GoTo 3000
1 '
1 ' Here if we want to clear the data just set.  About the only thing that
1 ' can be done is default back to the current screen data
1 '
3500 GoSub 13500                             ' Yank the data back from Screen%
3510 Valid% = 1                              ' Say the screen's valid again
3520 GoTo 2000                               ' Back to the prompt loop
1 '
1 ' Here if we want to increment Y some fraction of the screen:
1 '
3600 Direction% = 1 : GoTo 3620              ' Set sign of increment
1 '
1 ' Here if we want to decrement Y some fraction of the screen:
1 '
3610 Direction% = -1                         ' Set the sign of the increment
3620 Prompt$ = "Screen fraction "            ' Set the prompt
3630 Default = .5                            ' Assume half the screen
3640 GoSub 16000                             ' Read the screen fraction
3650 YOrigin = YOrigin + (DeltaY * Result * Direction%)
3660 GoTo 3880                               ' Screen data not valid
1 '
1 ' Here if we want to increment X some fraction of the screen:
1 '
3700 Direction% = 1 : GoTo 3720              ' Set sign of the increment
1 '
1 ' Here if we want to decrement X some fraction of the screen:
1 '
3710 Direction% = -1                         ' Set sign of the increment
3720 Prompt$ = "Screen fraction "            ' Set the prompt
3730 Default = .5                            ' Assume half the screen
3740 GoSub 16000                             ' Read the screen fraction
3750 XOrigin = XOrigin + (DeltaX * Result * Direction%)
3760 GoTo 3880                               ' Screen is no longer valid
1 '
1 ' If here we want to zoom in or out.  > 1 is zoom in, < 1 is zoom out
1 '
3800 Prompt$ = "Zoom Factor "                ' Set the prompt
3810 Default = 2                             ' Assume twice resolution
3820 GoSub 16000                             ' Get the zoom factor
3830 If Result > 0 Then GoTo 3860            ' Check range
3840 Print "? Must be greater than 0"        ' Complain
3850 GoTo 3000                               ' Let him think about it
3860 DeltaX = DeltaX / Result                ' Scale the DeltaX
3870 DeltaY = DeltaY / Result                ' Scale the DeltaY
3880 Valid% = 0                              ' Screen's no longer valid
3885 MouseValid% = 0                         ' No more mouse data
3890 GoTo 3010                               ' Prompt again
1 '
1 ' Give some hint as to what we're about:
1 '
3900 Print at (0,0) "One of the following commands:"
3905 Print "Clear  Clear data just set"
3910 Print "Down   Reset Y origin downwards"
3915 Print "Exit   Exit Mandelbrot.Bas"
3920 Print "Go     Compute the new set"
3925 Print "Help   Show this text"
3930 Print "Left   Reset X origin left"
3933 Print "Mouse  Use mouse to set origin"
3935 Print "Read   Read a saved screen"
3940 Print "Reset  Reset program"
3945 Print "Right  Reset X origin right"
3950 Print "Save   Save the screen"
3955 Print "Set    Set new data"
3960 Print "Show   Show current settings"
3965 Print "System Exit to CLI or workbench"
3970 Print "Up     Reset Y origin upwards"
3975 Print "Zoom   Zoom current settings"
3980 Print "Press left mouse button to continue"
3999 GoTo 3000
1 '
1 ' Here to set the new coordinates using the mouse:
1 '
4000 GoSub 20000                 ' Go get the new coordinates
4010 Print at (0,0) "X = "; MouseX
4020 Print "Y = "; MouseY
4030 Print "DeltaX = "; MouseDX
4040 Print "DeltaY = "; MouseDY
4050 GoTo 3000
1 '
1 ' Main loop here:
1'
6000 If ContourValid%= 0 Then GoSub 11000    ' Compute the contour map
6001 If MouseValid% = 0 Then GoTo 6010       ' Skip this if mouse not valid
6002 XOrigin = MouseX : YOrigin = MouseY
6003 DeltaX = MouseDX : DeltaY = MouseDY
6010 Screen Resolution%, BitPlanes%, 0       ' Setup the screen resolution
6020 ScnClr                                  ' And start with a clean screen
6023 XInc% = (2 ^ 30 * DeltaX / 320 / (Resolution% + 1))
6024 YInc% = (2 ^ 30 * DeltaY / 180)         ' Compute increments
6030 Y% = YOrigin * (2 ^ 30)                 ' Set initial Y
6040 For ScreenY% = 179 to 0 Step -1         ' Outside loop is Y%
6050    X% = XOrigin * (2 ^ 30)              ' Set initial X again
6060    For ScreenX% = 0 to (320 * (Resolution% + 1) - 1) Step 1
1 '
1 ' Initialize a single point's values:
1 '
6070       Regs%(0) = X% : Regs%(1) = Y%
6080       Regs%(2) = Iterations%
1 '
1 ' Per point loop:
1 '
6100       LibCall VarPtr(Code%(0)), 0, Regs%()
6110       I% = Peek_W(VarPtr(Regs%(2)) + 2)  ' Get the iteration count
6120       If I% > (Iterations% - 1) Then GoTo 6300
1 '
1 ' Here if we bummed out.  Plot the point
1 '
6200       Draw (ScreenX%, ScreenY%), Scale%(I% + 1)
1 '
1 ' Bump to the next point
1'
6300       X% = X% + XInc%
6310    Next ScreenX%
6320    Y% = Y% + YInc%
6330 Next ScreenY%
1 '
1 ' All done!
1 '
6340 Valid% = 1                        ' Say we're valid again
6350 MouseValid% = 0                   ' Mouse data isn't valid
6360 SShape (0, 0; (320 * (Resolution% + 1)) - 1, 199), Screen%
6370 If Boot% Then Goto 3160 Else GoTo 3000
1 '
1 ' Write the data file out and quit
1 '
7000 GoSub 10000                       ' Wait for the mouse button
7010 GoSub 12000                       ' Write the file out
7020 End                               ' End of proggie
1 '
1 ' Subroutine to wait for the mouse button to be pressed
1 '
10000 Ask Mouse X%, Y%, Button%
10010 If Button% = 0 Then GoTo 10000
10020 Return
1 '
1 ' Subroutine to fill in the scaling array given the number of bit planes
1 ' desired.
1 '
11000 Interval% = 1
11010 Print at (0,0) "Computing contouring array";
11020 I% = 1
11030 Color% = 1
11040 For J% = 1 to Interval%
11050    If I% <= 2000 Then Scale%(I%) = Color%
11060    I% = I% + 1
11070 Next J%
11080 If I% > 1000 Then GoTo 11130
11090 Color% = Color% + 1
11100 If Color% < (2 ^ BitPlanes%) Then 11040
11110 Interval% = Interval% + 2
11120 GoTo 11030
11130 ContourValid% = 1       ' So we don't have to do this again
11140 Return
1 '
1 '      The disk file is created/read with BSAVE/BLOAD into array Screen%.
1 ' The first elements of this array are obtained from/fed to SShape/GShape.
1 ' We load values into this array following the screen data itself.  On
1 ' write, the location in the array is determined by the resolution we're
1 ' writing.  When reading the file, the offset can be obtained from the
1 ' resolution implied by the width paramter in the front of the array.
1 '
1 ' The values appended to the screen array are:
1 '
1 ' Byte #     Contents
1 ' ==== =     ========
1 '    0       File format version number (1)
1 '    1       Screen resolution mode (0 or 1)
1 '   2-3      Iteration count
1 '   4-7      X Origin
1 '  8-11      Y Origin
1 ' 12-15      Delta X
1 ' 16-19      Delta Y
1 '
12000 SShape (0, 0; (320 * (Resolution% + 1) - 1), 199), Screen%()
12010 I% = (2000 * BitPlanes% * (Resolution% + 1)) + 2
12020 Poke VarPtr(Screen%(I%)), 2
12030 Poke VarPtr(Screen%(I%))+1, Resolution%
12040 Poke_W VarPtr(Screen%(I%))+2, Iterations%
12050 Screen%(I%+1) = Peek_L(VarPtr(XOrigin))
12060 Screen%(I%+2) = Peek_L(VarPtr(YOrigin))
12070 Screen%(I%+3) = Peek_L(VarPtr(DeltaX))
12080 Screen%(I%+4) = Peek_L(VarPtr(DeltaY))
12090 Success% = 0 : On Error GoTo 12130                 ' In case of errors
12100 BSave FileName$, Varptr(Screen%(0)), (I% + 5) * 4
12110 Success% = 1 : On Error GoTo 0
12120 Return
12130 Resume 12120
1 '
1 ' Converse of the previous routine, this routine restores a screen to
1 ' memory.  See the previous subroutine for notes on the file format.
1 '
13000 Success% = 0 : On Error GoTo 13660   ' In case the file lookup fails
13010 BLoad FileName$, VarPtr(Screen%(0))
13020 On Error GoTo 0
13500 BitPlanes% = Peek_W(VarPtr(Screen%(0)))
13510 Width% = Peek_W(VarPtr(Screen%(0))+2)
13520 If Width% < 320 Then Resolution% = 0 Else Resolution% = 1
13530 I% = (2000 * BitPlanes% * (Resolution% + 1)) + 2
13540 FileVersion% = Peek(VarPtr(Screen%(I%)))
13550 If (FileVersion% > 0) And (FileVersion% < 3) Then GoTo 13580
13560 Print "? File version number error"
13570 Return
13580 If FileVersion% < 2 Then Iterations% = Peek(VarPtr(Screen%(I%))+2)
13590 If FileVersion% >= 2 Then Iterations% = Peek_W(VarPtr(Screen%(I%))+2)
13600 Poke_L VarPtr(XOrigin), Peek_L(VarPtr(Screen%(I%+1)))
13610 Poke_L VarPtr(YOrigin), Peek_L(VarPtr(Screen%(I%+2)))
13620 Poke_L VarPtr(DeltaX), Peek_L(VarPtr(Screen%(I%+3)))
13630 Poke_L VarPtr(DeltaY), Peek_L(VarPtr(Screen%(I%+4)))
13640 Success% = 1
13650 Return
13660 Resume 13650
1 '
1 ' Subroutine to prompt for and read a command.  Called with the command
1 ' prompt in Prompt$, and returns the command keyword (uppercased) in
1 ' Command$.  We'll restore the screen after we're done.
1 '
14000 Print at (0,0) Prompt$;
14010 Input "", Command$
14020 GShape (0, 0), Screen%        ' Restore the screen
14030 If LowerCase% Then Return     ' Return now if lower case is ok
1 '
1 ' Subroutine to uppercase the alpha characters in the command string.
1 '
15000 For I% = 1 to Len(Command$)
15010    J% = InStr(1, Lower$, Mid$(Command$, I%, 1))
15030    If J% Then Replace$(Command$, I%, 1) = Mid$(Upper$, J%, 1)
15040 Next I%
15050 Return
1 '
1 ' Prompt for a numeric argument, preserving the old value if appropriate
1 '
16000 Prompt$ = Prompt$ + "(" + Str$(Default) + "): "
16010 GoSub 14000                   ' Go prompt and read the number
16020 If Command$ = "" Then Result = Default Else Result = Val(Command$)
16030 Return
1 '
1 ' Routine to take new coordinates from mouse input.
1 ' User positions mouse to lower left corner of intended
1 ' area to zoom, clicks mouse button once.  Position mouse
1 ' to upper left corner, click mouse button again.  This
1 ' goes to great lengths to preserve the proper aspect
1 ' ratio.
1 '
20000 PenA 1                     ' Set the default writing color
20005 XoverY = 320 * (Resolution% + 1) / 180 : YoverX = 1 / XoverY
1 '
1 ' Wait for the button to be pressed while on screen
1 '
20010 Ask Mouse X%, Y%, Button%  ' Go read the mouse
20020 If X% < 0 or Y% < 0 Then GoTo 20010 ' Ignore if not in window
20030 If X% > ((Resolution% + 1) * 320) - 1 Then GoTo 20010
20040 If Y% > 179 Then GoTo 20010    ' Ignore if too big also
20050 If Button% = 0 Then GoTo 20010 ' Wait for mouse buttom
20060 MouseX% = X% : MouseY% = Y% : NewDX% = 0 : OldDX% = 0
1 '
1 ' Wait for the button to be released
1 '
20070 While Button% <> 0: Ask Mouse X%, Y%, Button%: Wend
1 '
1 ' Loop here waiting for the second pressing of the button
1 '
20080 While Button% = 0
20090    If X% < MouseX% Then GoTo 20210     ' Don't make negative boxes
20100    If Y% > MouseY% Then GoTo 20210
20110    If X% > ((Resolution% + 1) * 320) -1 Then GoTo 20210
20120    If Y% > 179 Then GoTo 20210         ' Don't bother if too big
20130    OldDX% = NewDX%                     ' Copy the old delta X
20140    NewDX% = FnMax ((X% - MouseX%), int(XoverY * (MouseY% - Y%)))
20150    If NewDX% = OldDX% Then GoTo 20210  ' Don't bother if no change
20160    GShape (0, 0), Screen%              ' Something moved, restore the old screen
20170    X% = MouseX% + NewDX%               ' Find the corner
20180    Y% = MouseY% - int(YoverX * NewDX%) '  of the box
20190    Draw (MouseX%, MouseY% to X%, MouseY% to X%, Y%), 1
20200    Draw (X%, Y% to MouseX%, Y% to MouseX%, MouseY%), 1
20210    Ask Mouse X%, Y%, Button%           ' Get the new mouse position
20220 Wend
20230 MouseValid% = 1                        ' Say we have valid mouse data
20240 Gshape (0, 0), Screen%                 ' Restore the screen
20250 MouseX = XOrigin + DeltaX * MouseX% / (320 * (Resolution% + 1))
20260 MouseY = YOrigin + (DeltaX * 180 / 320) * (179 - MouseY%) / 180
20270 MouseDX = DeltaX * NewDX% / (320 * (Resolution% + 1))
20280 MouseDY = MouseDX * 180 / 320
20290 Return



