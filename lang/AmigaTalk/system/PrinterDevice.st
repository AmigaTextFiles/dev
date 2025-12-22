" ------------------------------------------------------------------- "
" Printer Class is a class for controlling the printer device.        "
""
" If any 'Send' method seems to hang the System, either Ctrl-C or     "
" Ctrl-D should break the I/O hangup.                                 "
""
"  WARNING:  You should know what you're doing to the Amiga OS before "
"            messing with this Class, or any other System Class!      "
""
" If your printer does not support a method, AmigaTalk might display  "
" a Requester stating that the printer.device failed to open, because "
" the Error code returned by the printer.device is brain-damaged.     "
" ------------------------------------------------------------------- "

Class PrinterDevice :Device ! private !
[
   initialize: initString
     " Send an initialization string to the printer.device. " 
     <primitive 225 2 private initString>
|
   getPrinterClassString
     ^ <primitive 225 19>
|
   getPrinterColorClassString 
     ^ <primitive 225 20>
|
   getPrinterName 
     ^ <primitive 225 21>
|
   getNumberOfCharSets
     ^ <primitive 225 22>
|
   getHorizontalDPI 
     ^ <primitive 225 23>
|
   getVerticalDPI 
     ^ <primitive 225 24>
|
   getNumberOfPrintColumns 
     ^ <primitive 225 25>
|
   getNumberOfHeadPins 
     ^ <primitive 225 26>
|
   getMaxXRasterDump 
     ^ <primitive 225 27>
|
   getMaxYRasterDump 
     ^ <primitive 225 28>
|
   reset
     " Send CMD_RESET to printer.device. "
     <primitive 225 9 private>
|
   sendExtendedCmd: command parm1: p1 parm2: p2 parm3: p3 parm4: p4
     " Send an extended command to the printer.device. 
     * See PrtCommands class below.
     "
     <primitive 225 6 private command p1 p2 p3 p4>
|
   restart
     " Send CMD_START to the printer.device. "
     <primitive 225 10 private>
|
   stop
     " Send CMD_STOP to the printer.device. "
     <primitive 225 11 private>
|
   flush
     " Send CMD_FLUSH to the printer.device. "
     <primitive 225 8 private>
|
   query
     " Ask the printer.device to return two bytes of status (PRD_QUERY)
     * as a two-byte String.  The String might have non-displayable values!
     "
     ^ <primitive 225 5 private>
|
   dumpGraphics: specialArray ! rpObj cm modeID xOffset yOffset w h dc dr flags !
     " Send PRD_DUMPRPORT to the printer.device in order to print a screen
     * dump.
     *
     * The parameters needed in specialArray are as follows:
     *
     *   rpObj   = raster port,        struct RastPort *
     *   cm      = color map,          struct ColorMap *
     *   modeID  = screenModeID,       ULONG
     *   xOffset = source x origin,    UWORD
     *   yOffset = source y origin,    UWORD
     *   w       = source width,       UWORD
     *   h       = source height,      UWORD
     *   dc      = destination width,  LONG
     *   dr      = destination height, LONG
     *   flags   = option flags,       UWORD
     "
     rpObj   <- specialArray at: 1.
     cm      <- specialArray at: 2.
     modeID  <- specialArray at: 3.
     xOffset <- specialArray at: 4.
     yOffset <- specialArray at: 5.
     w       <- specialArray at: 6.
     h       <- specialArray at: 7.
     dc      <- specialArray at: 8.
     dr      <- specialArray at: 9.
     flags   <- specialArray at: 10. "See PrtRPFlags class below."

     <primitive 225 12 private rpObj cm modeID xOffset yOffset w h dc dr flags>
|
   readPrinterPrefsInto: aBuffer ofSize: length
     " If the read fails because the buffer is too small you should double
     * the size of the buffer and try it again.
     *
     * Never interpret the contents of the buffer. You are allowed to save
     * it to file (as one block of data) and of course to write it back to
     * the driver (writePrinterPrefs).
     *
     * If you close the printer device between PRD_EDITPREFS and the
     * actual printing (CMD_WRITE or PRD_DUMPRPORTTAGS) you must read
     * the prefs after PRD_EDITPREFS and write it back before printing
     * or the driver may forget the user changes.
     "
     ^ <primitive 225 14 private aBuffer length> 
|
   writePrinterPrefsFrom: aBuffer ofSize: length
     " This is a non standard write command that writes the driver 
     * preferences.  The printer driver checks the buffer before 
     * copying it to its preferences.  So you do not have to worry 
     * about changing the printer driver between readPrinterPrefsInto:ofSize:
     * and this method.
     "
     ^ <primitive 225 15 private aBuffer length>
|
   editPrinterPrefs: tagArray
     " New drivers can have their own preferences.  This method asks the driver
     * to open a window to allow the user to change the prefs.
     *
     * Every application should have a button 'Driver Options...' (that
     * calls this method in its printer dialog.
     "
     ^ <primitive 225 16 private tagArray>
|
   setPrinterErrorHook: hookObject
     " This command sets a hook that will be called if the printer.device
     * returns with an error from any other I/O command.  This allows
     * printer drivers to use private error messages.
     "
     ^ <primitive 225 17 private hookObject> 
|
   dumpTaggedGraphics: specialArray ! rpObj cm modeID xOffset yOffset w h dc dr flags tags !
     " Send PRD_DUMPRPORTTAGS to the printer.device in order to print a screen
     * dump.
     *
     * The parameters needed in specialArray are as follows:
     *
     *   rpObj   = raster port,        struct RastPort *
     *   cm      = color map,          struct ColorMap *
     *   modeID  = screenModeID,       ULONG
     *   xOffset = source x origin,    UWORD
     *   yOffset = source y origin,    UWORD
     *   w       = source width,       UWORD
     *   h       = source height,      UWORD
     *   dc      = destination width,  LONG
     *   dr      = destination height, LONG
     *   flags   = option flags,       UWORD
     *   tags    = tagList             struct TagItem * 
     "
     rpObj   <- specialArray at: 1.
     cm      <- specialArray at: 2.
     modeID  <- specialArray at: 3.
     xOffset <- specialArray at: 4.
     yOffset <- specialArray at: 5.
     w       <- specialArray at: 6.
     h       <- specialArray at: 7.
     dc      <- specialArray at: 8.
     dr      <- specialArray at: 9.
     flags   <- specialArray at: 10. "See PrtRPFlags class below."
     tags    <- specialArray at: 11.
     
     <primitive 225 13 private rpObj cm modeID xOffset yOffset w h dc dr flags tags>
|
   getPrinterErrorString
     " Return a String that describes the last Printer Error Number found. "
     ^ <primitive 225 18 private> 
|
   close

     " Close the printer.device & remove it from AmigaTalk program space. " 
     <primitive 225 0 private>.

     <primitive 250 5 0 private>.
     
     ^ nil
|
   open: printerName
     " Allocate the internal memory & structures needed for opening
     * the printer.device.  Return an Integer Object.
     " 
     private <- <primitive 225 1 printerName>
|
   sendRawWrite: buffer ofLength: length
     " Send a Raw buffer of data to the printer.device. "
     <primitive 225 7 private buffer length>
|
   write: thisString ofLength: length
     " Write a string length bytes long to the printer.device. "
     ^ <primitive 225 3 private thisString length>
|
   asyncWrite: thisString ofLength: length
     " Write a string length bytes long to the printer.device 
     * with asynchronous I/O.
     "
     ^ <primitive 225 4 private thisString length>
|
   " SHORTCUTS FOR COMMON PRINTER COMMANDS: "

   crlf ! prtCmds crlfCode !
     prtCmds  <- PrtCommands new.
     crlfCode <- prtCmds at: #aNEL.

     " Send a Carriage Return-LineFeed command code to the Printer:"
     <primitive 225 6 private crlfCode 0 0 0 0>
|
   nlqOn ! prtCmds nlqOnCode !
     prtCmds   <- PrtCommands new.
     nlqOnCode <- prtCmds at: #aDEN2.

     " Send a Near Letter Quality ON command code to the Printer:"
     <primitive 225 6 private nlqOnCode 0 0 0 0>
|
   nlqOff ! prtCmds nlqOffCode !
     prtCmds   <- PrtCommands new.
     nlqOffCode <- prtCmds at: #aDEN1.

     " Send a Near Letter Quality OFF command code to the Printer:"
     <primitive 225 6 private nlqOffCode 0 0 0 0>
|
   normalCharSet ! prtCmds normCode !
     prtCmds  <- PrtCommands new.
     normCode <- prtCmds at: #aSGR0.

     " Send a Normal Character Set command code to the Printer:"
     <primitive 225 6 private normCode 0 0 0 0>
|
   italicsOn ! prtCmds italicOnCode !
     prtCmds      <- PrtCommands new.
     italicOnCode <- prtCmds at: #aSGR3.

     " Send an Italics ON command code to the Printer:"
     <primitive 225 6 private italicOnCode 0 0 0 0>
|
   italicsOff ! prtCmds italicOffCode !
     prtCmds       <- PrtCommands new.
     italicOffCode <- prtCmds at: #aSGR23.

     " Send an Italics OFF command code to the Printer:"
     <primitive 225 6 private italicOffCode 0 0 0 0>
|
   underlineOn ! prtCmds underOnCode !
     prtCmds     <- PrtCommands new.
     underOnCode <- prtCmds at: #aSGR4.

     " Send an Underline ON command code to the Printer:"
     <primitive 225 6 private underOnCode 0 0 0 0>
|
   underlineOff ! prtCmds underOffCode !
     prtCmds      <- PrtCommands new.
     underOffCode <- prtCmds at: #aSGR24.

     " Send an Underline OFF command code to the Printer:"
     <primitive 225 6 private underOffCode 0 0 0 0>
|
   boldOn ! prtCmds boldOnCode !
     prtCmds    <- PrtCommands new.
     boldOnCode <- prtCmds at: #aSGR1.

     " Send an BoldFace ON command code to the Printer:"
     <primitive 225 6 private boldOnCode 0 0 0 0>
|
   boldOff ! prtCmds boldOffCode !
     prtCmds     <- PrtCommands new.
     boldOffCode <- prtCmds at: #aSGR22.

     " Send an BoldFace OFF command code to the Printer:"
     <primitive 225 6 private boldOffCode 0 0 0 0>
|
   normalPitch ! prtCmds normalCode !
     prtCmds    <- PrtCommands new.
     normalCode <- prtCmds at: #aSHORP0.

     " Send an Normal Pitch command code to the Printer:"
     <primitive 225 6 private normalCode 0 0 0 0>
|
   elitePitchOn ! prtCmds eliteOnCode !
     prtCmds     <- PrtCommands new.
     eliteOnCode <- prtCmds at: #aSHORP2.

     " Send an Elite Pitch ON command code to the Printer:"
     <primitive 225 6 private eliteOnCode 0 0 0 0>
|
   elitePitchOff ! prtCmds eliteOffCode !
     prtCmds      <- PrtCommands new.
     eliteOffCode <- prtCmds at: #aSHORP1.

     " Send an Elite Pitch OFF command code to the Printer:"
     <primitive 225 6 private eliteOffCode 0 0 0 0>
|
   condensedPitchOn ! prtCmds condensedOnCode !
     prtCmds         <- PrtCommands new.
     condensedOnCode <- prtCmds at: #aSHORP4.

     " Send a Condensed Fine Pitch ON command code to the Printer:"
     <primitive 225 6 private condensedOnCode 0 0 0 0>
|
   condensedPitchOff ! prtCmds condensedOffCode !
     prtCmds          <- PrtCommands new.
     condensedOffCode <- prtCmds at: #aSHORP3.

     " Send a Condensed Fine Pitch OFF command code to the Printer:"
     <primitive 225 6 private condensedOffCode 0 0 0 0>
|
   enlargedPitchOn ! prtCmds enlargedOnCode !
     prtCmds        <- PrtCommands new.
     enlargedOnCode <- prtCmds at: #aSHORP6.

     " Send a Enlarged Pitch ON command code to the Printer:"
     <primitive 225 6 private enlargedOnCode 0 0 0 0>
|
   enlargedPitchOff ! prtCmds enlargedOffCode !
     prtCmds         <- PrtCommands new.
     enlargedOffCode <- prtCmds at: #aSHORP5.

     " Send a Enlarged Pitch OFF command code to the Printer:"
     <primitive 225 6 private enlargedOffCode 0 0 0 0>
|
   superScriptOn ! prtCmds superOnCode !
     prtCmds     <- PrtCommands new.
     superOnCode <- prtCmds at: #aSUS2.

     " Send a SuperScript ON command code to the Printer:"
     <primitive 225 6 private superOnCode 0 0 0 0>
|
   superScriptOff ! prtCmds superOffCode !
     prtCmds      <- PrtCommands new.
     superOffCode <- prtCmds at: #aSUS1.

     " Send a SuperScript OFF command code to the Printer:"
     <primitive 225 6 private superOffCode 0 0 0 0>
|
   subScriptOn ! prtCmds subOnCode !
     prtCmds   <- PrtCommands new.
     subOnCode <- prtCmds at: #aSUS4.

     " Send a SubScript ON command code to the Printer:"
     <primitive 225 6 private subOnCode 0 0 0 0>
|
   subScriptOff ! prtCmds subOffCode !
     prtCmds    <- PrtCommands new.
     subOffCode <- prtCmds at: #aSUS3.

     " Send a SubScript OFF command code to the Printer:"
     <primitive 225 6 private subOffCode 0 0 0 0>
|
   normalizeLine ! prtCmds normCode !
     prtCmds  <- PrtCommands new.
     normCode <- prtCmds at: #aSUS0.

     " Send a Normalize the line (after super or sub-scripting)
     * command code to the Printer:
     "
     <primitive 225 6 private normCode 0 0 0 0>
|
   partialLineUp ! prtCmds partUpCode !
     prtCmds    <- PrtCommands new.
     partUpCode <- prtCmds at: #aPLU.

     " Send a Partial line UP command code to the Printer:"
     <primitive 225 6 private partUpCode 0 0 0 0>
|
   partialLineDown ! prtCmds partDnCode !
     prtCmds    <- PrtCommands new.
     partDnCode <- prtCmds at: #aPLD.

     " Send a Partial line DOWN command code to the Printer:"
     <primitive 225 6 private partDnCode 0 0 0 0>
|
   setFormLength: numLines ! prtCmds formCode !
     prtCmds  <- PrtCommands new.
     formCode <- prtCmds at: #aSLPP.

     " Send a Set Form Length nn command code to the Printer:"
     <primitive 225 6 private formCode numLines 0 0 0>
|
   setPerfSkip: numLines ! prtCmds perfCode !
     (numLines <= 0)
        ifTrue: [ ^ nil ]. " User is brain-damaged! "

     prtCmds  <- PrtCommands new.
     perfCode <- prtCmds at: #aPERF.

     " Send a Set Perforation Skip nn command code to the Printer:"
     <primitive 225 6 private perfCode numLines 0 0 0>
|
   perfSkipOff ! prtCmds perfOffCode !
     prtCmds     <- PrtCommands new.
     perfOffCode <- prtCmds at: #aPERF0.

     " Send a Perforation Skip OFF command code to the Printer:"
     <primitive 225 6 private perfOffCode 0 0 0 0>
|
   setLeftMargin: numSpaces ! prtCmds leftCode !
     prtCmds  <- PrtCommands new.
     leftCode <- prtCmds at: #aLMS.

     " Send a Left Margin Set nn command code to the Printer:"
     <primitive 225 6 private leftCode numSpaces 0 0 0>
|
   setRightMargin: numSpaces ! prtCmds rightCode !
     prtCmds   <- PrtCommands new.
     rightCode <- prtCmds at: #aRMS.

     " Send a Right Margin Set nn command code to the Printer:"
     <primitive 225 6 private rightCode numSpaces 0 0 0>
|
   setTopMargin: numLines ! prtCmds topCode !
     prtCmds <- PrtCommands new.
     topCode <- prtCmds at: #aTMS.

     " Send a Top Margin Set nn command code to the Printer:"
     <primitive 225 6 private topCode numLines 0 0 0>
|
   setBottomMargin: numLines ! prtCmds bottomCode !
     prtCmds    <- PrtCommands new.
     bottomCode <- prtCmds at: #aBMS.

     " Send a Bottom Margin Set nn command code to the Printer:"
     <primitive 225 6 private bottomCode numLines 0 0 0>
|
   setTopAndBottomMargins: topLines bottom: bottomLines ! prtCmds topCode !
     prtCmds <- PrtCommands new.
     topCode <- prtCmds at: #aSTBM.

     " Send a Top & Bottom Margin Set nn command code to the Printer:"
     <primitive 225 6 private topCode topLines bottomLines 0 0>
|
   setLeftAndRightMargins: leftSpcs right: rightSpcs ! prtCmds leftCode !
     prtCmds  <- PrtCommands new.
     leftCode <- prtCmds at: #aSLRM.

     " Send a Left & Right Margin Set nn command code to the Printer:"
     <primitive 225 6 private leftCode leftSpcs rightSpcs 0 0>
|
   clearMargins ! prtCmds clearCode !
     prtCmds   <- PrtCommands new.
     clearCode <- prtCmds at: #aCAM.

     " Send a Clear Margins command code to the Printer:"
     <primitive 225 6 private clearCode 0 0 0 0>
|
   setTabs: tab1 t2: tab2 t3: tab3 t4: tab4 ! prtCmds hTabCode !
     prtCmds  <- PrtCommands new.
     hTabCode <- prtCmds at: #aHTS.

     " Send a Set Horizontal Tabs command code to the Printer:"
     <primitive 225 6 private hTabCode tab1 tab2 tab3 tab4>
|
   setTab: tab ! prtCmds hTabCode !
     prtCmds  <- PrtCommands new.
     hTabCode <- prtCmds at: #aHTS.

     " Send a Set Horizontal Tab nn command code to the Printer:"
     <primitive 225 6 private hTabCode tab 0 0 0>
|
   clearTabs ! prtCmds clearCode !
     prtCmds   <- PrtCommands new.
     clearCode <- prtCmds at: #aTBC3.

     " Send a Clear ALL Horizontal Tabs command code to the Printer:"
     <primitive 225 6 private clearCode 0 0 0 0>
|
   sendFormFeed ! formfeed !
     formfeed <- <primitive 96 12>.

     " Send an ASCII FormFeed character (value = 12) to the Printer: "
     self asyncWrite: formfeed ofLength: 1
]     
