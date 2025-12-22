\ JForth Language Interface for OpalVision's Opal.Library
\
\ Version 1.0 - 31 December 1992
\
\ By Marlin Schwanke

include? OpalScreen ji:opal/opallib.j

ANEW TASK-OPAL

\ JForth Amiga shared library words

:Library opal
: opal? ( -- ) opal_NAME opal_LIB lib? ;
: -opal ( -- ) opal_LIB -lib ;

\ Some useful macros

\ Set 24 bit pen value
: SetPen24 ( OpalScreen, Red8, Green8, Blue8 -- , Store 24 bitplane pen )
   >r >r                ( Now have OS R8 )
   over ..! OS_Pen_R     ( Store red pen )
   r> over ..! OS_Pen_G  ( Store green pen )
   r> swap ..! OS_Pen_B  ( Store blue pen
;

\ Set 15 bit pen value
: SetPen15 ( OpalScreen Red5 Green5 Blue5 -- , Store 15 bitplane pen )
   31 and >r 31 and swap 31 and        ( Now have OS 000GGGGG 000RRRRR )
   2 shift over  24 and -3 shift or    ( Now have OS 0RRRRRGG )
   swap 7 and 5 shift r> or            ( Now have OS 0RRRRRGG GGGBBBBB )
   2 pick ..! OS_Pen_G                  ( Store green pen )
   swap ..! OS_Pen_R                    ( Store red pen )
;

\ Set 8 bit pallette mapped pen value
: SetPen8P ( OpalScreen Pen8 -- , Store 8 bitplane pen )
   swap ..! OS_Pen_R
;

\ Set 8 bit pen value
: SetPen8
   3 and >r 7 and swap 7 and           ( Now have OS G3 R3 )
   5 shift swap 2 shift or r> or       ( Now have OS RRRGGGBB )
   swap ..!  OS_Pen_R                   ( Store Pen_R )
;

\ Get 24 bit pen values
: GetPen24 ( OpalScreen -- Red8 Green8 Blue8 , Get the current 24 bitplane pen )
   dup ..@ OS_Pen_R        ( Now have OS Pen_R )
   swap dup ..@ OS_Pen_G   ( Now have Pen_R OS Pen_G )
   swap ..@ OS_Pen_B       ( Now have Pen_R Pen_G Pen_B )
;

\ Get 15 bit pen values
: GetPen15 ( OpalScreen -- Red5 Green5 Blue5 , Get the current 15 bitplane pen )
   dup ..@ OS_Pen_R                    ( Now have OS 0RRRRRGG )
   dup -2 shift                        ( Now have OS 0RRRRRGG 000RRRRR )
   swap 3 and 3 shift                  ( Now have OS 000RRRRR 000GG000 )
   rot ..@ OS_Pen_G                    ( Now have 000RRRRR 000GG000 GGGBBBBB )
   swap over 224 and -5 shift or       ( Now have 000RRRRR GGGBBBBB 000GGGGG )
   swap 31 and                         ( Now have 000RRRRR 000GGGGG 000BBBBB )
;

\ Get 8 bit palette mapped pen value
: GetPen8P ( OpalScreen -- Pen8 , Get the current 8 bitplane pen )
   ..@ OS_Pen_R
;

\ Get 8 bit pen values
: GetPen8 ( OpalScreen -- Red3 Green3 Blue2 )
   ..@ OS_Pen_R
   dup -5 shift            ( Now have OS 00000RRR )
   over 28 and -2 shift    ( Now have OS 00000RRR 00000GGG )
   rot 3 and               ( Now have 00000RRR 00000GGG 000000BB )
;

\ Get 24 bit color values
: GetCol24 ( OpalScreen -- Red8, Green8 , Blue 8 , Get ReadPixel24 24 bitplane color values )
   dup ..@ OS_Red       ( Now have OS Red8 )
   over ..@ OS_Green    ( Now have OS Red8 Green8 )
   rot ..@ OS_Blue      ( Now have Red8 Green8 Blue8 )
;

\ Get 15 bit color values
: GetCol15 ( OpalScreen -- Red5 Green5 Blue5 , Get ReadPixel24 15 bitplane color values )
   dup ..@ OS_Red                   ( Now have OS 0RRRRRGGG )
   dup -2 shift                     ( Now have OS 0RRRRRGG 000RRRRR )
   swap 3 and 3 shift               ( Now have OS 000RRRRR 000GG000 )
   rot ..@ OS_Green                 ( Now have 000RRRRR 00000GG GGGBBBBB )
   swap over 224 and -5 shift or    ( Now have 000RRRRR GGGBBBBB 000GGGGG )
   swap 31 and                      ( Now have 000RRRRR 000GGGGG 000BBBBB )
;

\ Get 8 bit palette mapped color value
: GetCol8P ( OpalScreen -- Col8 , Get ReadPixel24 8 bitplane color value )
   ..@ OS_Red
;

\ Get 8 bit color values
: GetCol8 ( OpalScreen -- Red3 Green3 Blue2 )
   ..@ OS_Red
   dup -5 shift            ( Now have OS 00000RRR )
   over 28 and -2 shift    ( Now have OS 00000RRR 00000GGG )
   rot 3 and               ( Now have 00000RRR 00000GGG 000000BB )
;

\ Playfield & Priority stencil pens
: SetPFPen ( Opalscreen State -- Set playfield pen to state )
   swap ..! OS_Pen_R
;

: SetPRPen ( OpalScreen State -- Set priority pen to state )
   swap ..! OS_Pen_R
;

\ Opal Library Calls

\ Note that all addresses are JForth relative going into and coming out of these
\ routines.  The code for each call handles the necessary transformations.  Also
\ note that all filenames must be 0 terminated 'C' style strings.

: OpenScreen24()  ( Modes -- Screen/Null )
\ Allocates all resources and displays an OpalVision screen.
   call Opal_LIB OpenScreen24 if>rel
;

: CloseScreen24() ( -- )
\ Stop current display and free resources.
   callvoid Opal_LIB CloseScreen24
;

: WritePixel24() ( Screen X Y -- Result )
\ Write pixel into an OpalScreen.
   call>abs Opal_LIB WritePixel24
;

: ReadPixel24() ( Screen X Y -- Result )
\ Returns colour information for a given pixel.
   call>abs Opal_LIB ReadPixel24
;

: ClearScreen24() ( Screen -- )
\ Clears all bitplanes in a screen.
   callvoid>abs Opal_LIB ClearScreen24
;

: ILBMtoOV() ( Screen ILBMData SourceWidth Lines TopLine Planes -- )
\ Convert interleaved bitmap to OpalVision format.
   callvoid>abs Opal_LIB ILBMtoOV
;

: UpdateDelay24() ( Frames -- )
\ Sets the delay between consecutive frame buffer updates.
   callvoid Opal_LIB UpdateDelay24
;

: Refresh24() ( -- )
\ Refreshes the frame buffer.
   callvoid Opal_LIB Refresh24
;

: SetDisplayBottom24() ( BottomLine -- Result )
\ Sets the lower limit of the OpalVision screen.
   call Opal_LIB SetDisplayBottom24
;

: ClearDisplayBottom24() ( -- )
\ Clears the OpalVision display bottom setting.
   callvoid Opal_LIB ClearDisplayBottom24
;

: SetSprite24() ( SpriteData SpriteNumber -- )
\ Allows Amiga sprites to be displayed over OpalVision graphics.
   callvoid>abs Opal_LIB SetSprite24
;

: AmigaPriority() ( -- )
\ Gives Amiga graphics priority over OpalVision display.
   callvoid Opal_LIB AmigaPriority
;

: OVPriority() ( -- )
\ Give OpalVision graphics priority over the Amiga graphics.
   callvoid Opal_LIB OVPriority
;

: DualDisplay24() ( -- )
\ Sets up an Amiga/OpalVision dual display.
   callvoid Opal_LIB DualDisplay24
;

: SingleDisplay24() ( -- )
\ Sets up an Amiga/OpalVision single display.
   callvoid Opal_LIB SingleDisplay24
;

: AppendCopper24() ( CopperArray -- )
\ Attaches user copper lists to existing display copper lists.
   callvoid>abs Opal_LIB AppendCopper24
;

: RectFill24() ( OScrn Left Top Bottom Right -- )
\ Draws a solid rectangle.
   callvoid>abs Opal_LIB RectFill24
;

: UpdateCoPro24() ( -- )
\ Writes CoPro list for current the display screen to Video coprocessor.
   callvoid Opal_LIB UpdateCoPro24
;

: SetControlBit24() ( FrameNumber BitNumber State -- )
\ Modifies a bit in the control line register.
   callvoid Opal_LIB SetControlBit24
;

: PaletteMap24() ( PaletteMap -- )
\ Enable/Disable palette mapping.
   callvoid Opal_LIB PaletteMap24
;

: UpdatePalette24() ( -- )
\ Loads all 256 entries of Red, Green, and Blue values in the OpalScreen
\ structure into the OpalVision palette registers.
   callvoid Opal_LIB UpdatePalette24
;

: Scroll24() ( DeltaX DeltaY -- )
\ Scrolls currently displayed OpalVision image.
   callvoid Opal_LIB Scroll24
;

: LoadIff24() ( OpalScreen 0Filename Flags -- OpalScreen/Error )
\ Loads an image file.
   >r >abs swap            ( fn scr scr )
   if>abs                  ( fn scr/0 )
   swap r>                 ( scr/0 fn fl )
   call Opal_LIB LoadIff24 ( scr/error )
   dup OL_ERR_MAXERR >=    ( scr/error )
   if >rel then            ( scr/error )
;

: LoadImage24() ( OpalScreen 0Filename Flags -- OpalScreen/Error )
\ Alias for LoadIff24().
   LoadIFF24()
;

: SetScreen24() ( OpalScreen -- )
\ Fills screen with a specified colour.
   callvoid>abs Opal_LIB SetScreen24
;

: SaveIFF24() ( OpalScreen 0Filename ChunkFunction Flags -- Result )
\ Save an OpalScreen as an IFF file.
   call>abs Opal_LIB SaveIFF24
;

: CreateScreen24() ( ScreenModes Width Height -- OpalScreen/Null )
\ Create an arbitrarily sized virtual OpalScreen.
   call Opal_LIB CreateScreen24 if>rel
;

: FreeScreen24() ( OpalScreen -- )
\ Frees a virtual OpalScreen.
   callvoid>abs Opal_LIB FreeScreen24
;

: UpdateRegs24() ( -- )
\ Updates the hardware registers for the current display screen.
   callvoid Opal_LIB UpdateRegs24
;

: SetLoadAddress24() ( -- )
\ Updates the OpalVision load address register.
   callvoid Opal_LIB SetLoadAddress24
;

: RGBtoOV() ( OpalScreen RGBPlanes Top Left Width height -- )
\ Convert three planes of RGB to OpalVision bitplane data.
   callvoid>abs Opal_LIB RGBtoOV
;

: ActiveScreen24() ( -- OpalScreen/Null )
\ Provides a pointer to the currently displayed OpalVision screen.
   call Opal_LIB ActiveScreen24 if>rel
;

: FadeIn24() ( Time -- )
\ Fades display in from black.
   callvoid Opal_LIB FadeIn24
;

: FadeOut24() ( Time -- )
\ Fade display to black.
   callvoid Opal_LIB FadeOut24
;

: ClearQuick24() ( -- )
\ Clears frame buffer memory.
   callvoid Opal_LIB ClearQuick24
;

: WriteThumbnail24() ( OpalScreen File -- Result )
\ Writes an IFF thumb-nail chunk into a file.
   callvoid>abs Opal_LIB WriteThumbnail24
;

: SetRGB24() ( Entry Red Green Blue -- )
\ Updates a single palette entry to the OpalVision palette registers.
   callvoid Opal_LIB SetRGB24
;

: DrawLine24() ( OpalScreen X1 Y1 X2 Y2 -- )
\ Draws a line into an OpalScreen.
   callvoid>abs Opal_LIB DrawLine24
;

: StopUpdate24() ( -- )
\ Stops updates to the frame buffer memory.
   callvoid Opal_LIB StopUpdate24
;

: WritePFPixel24() ( OpalScreen X Y -- )
\ Set or clear a pixel in the playfield stencil.
   callvoid>abs Opal_LIB WritePFPixel24
;

: WritePRPixel24() ( OpalScreen X Y -- )
\ Set or clear a pixel in the priority stencil.
   callvoid>abs Opal_LIB WritePRPixel24
;

: OVtoRGB() ( OpalScreen RGBPlanes Top Left Width Height -- )
\ Converts OpalVision bitplane data to three planes of RGB
   callvoid>abs Opal_LIB OVtoRGB
;

: OVtoILBM() ( OpalScreen ILBMData DestWidth Lines TopLine -- )
\ Convert OpalVision bit planes to interleaved bitmap format.
   callvoid>abs Opal_LIB OVtoILBM
;

: UpdateAll24() ( -- )
\ Resets the internal update stucture so all required banks are updated.
   callvoid Opal_LIB UpdateAll24
;

: UpdatePFStencil24() ( -- )
\ Updates playfield stencil at highest possible rate.
   callvoid Opal_LIB UpdatePFStencil24
;

: EnablePRStencil24() ( -- )
\ Enables the use of the priority stencil in dual display mode.
   callvoid Opal_LIB EnablePRStencil24
;

: DisablePRStencil24() ( -- )
\ Disables the use of the priority stencil in dual display mode.
   callvoid Opal_LIB DisablePRStencil24
;

: ClearPRStencil24() ( OpalScreen -- )
\ Clears the priority stencil of the specified screen.
   callvoid>abs Opal_LIB ClearPRStencil24
;

: SetPRStencil24() ( OpalScreen -- )
\ Sets the priority stencil of the specified screen.
   callvoid>abs Opal_LIB SetPRStencil24
;

: DisplayFrame24() ( Frame -- )
\ Sets the currently displayed frame within the frame buffer memory.
   callvoid Opal_LIB DisplayFrame24
;

: WriteFrame24() ( Frame -- )
\ Sets the current frame to be written within the frame buffer memory.
   callvoid Opal_LIB WriteFrame24
;

: BitPlanetoOV() ( OpalScreen ScrPlanes ScrWidth Lines TopLine ScrDepth -- )
\ Convert standard bitplane data to OpalVision format.
   callvoid>abs Opal_LIB BitPlanetoOV
;

: SetCoPro24() ( InstructionNumber Instruction -- )
\ Modifies a single instruction in the CoPro list.
   callvoid Opal_LIB SetCoPro24
;

: RegWait24() ( -- )
\ Wait for register update to complete.
   callvoid Opal_LIB RegWait24
;

: DualPlayField24 ( -- )
\ Sets up an OpalVision 24 bit dual playfield.
   callvoid Opal_LIB DualPlayField24
;

: SinglePlayField24 ( -- )
\ Set up an Amiga or OpalVision single playfield.
   callvoid Opal_LIB SinglePlayField24
;

: ClearPFStencil24() ( OpalScreen -- )
\ Clears the playfield stencil of the specified screen.
   callvoid>abs Opal_LIB ClearPFStencil24
;

: SetPFStencil24() ( OpalScreen -- )
\ Sets the playfield stencil of the specified screen.
   callvoid>abs Opal_LIB SetPFStencil24
;

: ReadPRPixel24() ( OpalScreen X Y --  Result )
\ Returns the state of a given priority stencil pixel.
   call>abs Opal_LIB ReadPRPixel24
;

: ReadPFPixel24() ( OpalScreen X Y --  Result )
\ Returns the state of a given playfield stencil pixel.
   call>abs Opal_LIB ReadPFPixel24
;

: OVtoBitPlane() ( OpalScreen BitPlanes DestWidth Lines TopLine -- )
\ Convert OpalVision bit plane data to standard bitplanes.
   callvoid>abs Opal_LIB OVtoBitPlane
;

: FreezeFrame24() ( Freeze -- )
\ Freezes the currently displayed screen.
   callvoid Opal_LIB FreezeFrame24
;

: LowMemUpdate24() ( OpalScreen Frame -- OpalScreen/Error )
   call>abs Opal_LIB LowMemUpdate24
   dup OL_ERR_MAXERR >=    ( scr/error )
   if >rel then            ( scr/error )
;

: DisplayThumbnail24() ( Screen 0Filename X Y -- Result )
\ Displays a file's thumbnail.
   call>abs Opal_LIB DisplayThumbnail24
;

: Config24() ( -- Result )
\ Returns the OpalVision hardware configuration.
   call Opal_LIB Config24
;

: AutoSync24() ( Sync -- )
\ Enables auto horizontal synchronisation.
   callvoid Opal_LIB AutoSync24
;

: DrawEllipse24() ( OpalScreen CX CY A B -- )
\ Draw an ellipse of given dimensions.
   callvoid>abs Opal_LIB DrawEllipse24
;

: DrawCircle24() ( opalScreen centerx centery radius -- , Draw circle )
\ An alias for DrawEllipse24() for drawing circles.
   dup DrawEllipse24()
;

: LatchDisplay24 ( Latch -- )
\ Locks OpalVision display.
   callvoid Opal_LIB LatchDisplay24
;

: SetHires24() ( Topline Lines -- )
\ Enable a hires display for a section of the screen.
   callvoid Opal_LIB SetHires24
;

: SetLores24() ( Topline Lines -- )
\ Enable a lores display for a section of the screen.
   callvoid Opal_LIB SetLores24
;

: DownLoadFrame24() ( OpalScreen X Y W H -- )
\ ??
   callvoid>abs Opal_LIB DownLoadFrame24
;

: SaveJPEG24() ( OpalScreen 0FileName Flags Quality -- Error )
\ Save an OpalScreen as a JPEG JFIF file.
   call>abs Opal_LIB SaveJPEG24
;

: LowMem2Update24() ( Screen Frame -- OpalScreen/Error )
\ Low chip ram usage OpalVision update.
   call>abs Opal_LIB LowMem2Update24
   dup OL_ERR_MAXERR >=       ( scr/error )
   if >rel then               ( scr/error )
;

: LowMemRGB24() ( ScreenModes Frame Width Height Modulo RGBPlanes -- )
\ Low chip ram usage OpalVision update from an RGB array.
   callvoid>abs Opal_LIB LowMemRGB24
   dup OL_ERR_MAXERR >=       ( scr/error )
   if >rel then               ( scr/error )
;

