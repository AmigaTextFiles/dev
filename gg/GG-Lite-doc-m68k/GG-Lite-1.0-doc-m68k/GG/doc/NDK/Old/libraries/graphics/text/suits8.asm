* A sparse (but complete) sample font.
*
* Copyright (c) 1990 Commodore-Amiga, Inc.
*
* This example is provided in electronic form by Commodore-Amiga, Inc. for
* use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
* The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
* information on the correct usage of the techniques and operating system
* functions presented in this example.  The source and executable code of
* this example may only be distributed in free electronic form, via bulletin
* board or as part of a fully non-commercial and freely redistributable
* diskette.  Both the source and executable code (including comments) must
* be included, without modification, in any copy.  This example may not be
* published in printed form or distributed with any commercial product.
* However, the programming techniques and support routines set forth in
* this example may be used in the development of original executable
* software products for Commodore Amiga computers.
* All other rights reserved.
* This example is provided "as-is" and is subject to change; no warranties
* are made.  All use is at your own risk.  No liability or responsibility
* is assumed.
*
* To use this font, do the following:
*
* 1.  Assemble this file (assumed to have been saved as "suits8.asm").
*     For example, if you have the CAPE 680x0 assembler, and you have
*     assigned "include:" to the directory containing your include files,
*     use:
*        CAsm -a "suits8.asm" -o "suits8.o" -i "include:"
*
*     Link "suits8.o".  For example, if you have Lattice, use:
*        BLink from "suits8.o" to "suits8"
*
* 2.  Create the subdirectory "Fonts:suits".
*     Copy the file "suits8" (created in step 1.) to "Fonts:suits/8".
*
* 3.  Create a font contents file for the font.  You can do this
*     by three methods:
*   a. Run the program "Workbench1.3:System/FixFonts" which
*      will create the file "Fonts:suits.font" automatically.
*   b. Use the NewFontContents() call in the diskfont library to
*      create a FontContentsHeader structure, which can be saved
*      in the Fonts: directory as "suits.font".   This is essentially
*      what FixFonts does.
*   c. Create the file manually by following these directions:
*
* Create a file in the Fonts: directory named "suits.font" the
* contents of which are as follows:
* 
* The first word (two bytes) must contain the font header identifier, FCH_ID
* FCH_ID is defined in "libraries/diskfont.i" and is currently 0x0f00.
*
* The next word contains the number of FontContents entries.  There will
* be only one font descriptor file in this sample font's directory, so the
* value 0x0001 should be used.
*
* Follow this information with the hex values for the string "suits/8";
* the path AmigaDOS should follow to reach this font size.  The path is
* relative to "Fonts:"; "suits" is the directory in which AmigaDOS will find
* this font's font descriptor files and "8" is a font descriptor file.
* This should be followed by enough null characters (0x00) to pad the
* pathname to MAXFONTPATH bytes in length.  MAXFONTPATH is defined in
* "libraries/diskfont.i" and is currently 256 bytes.  The string in this
* example is 7 bytes long, therefore 249 bytes of padding are needed.
* Note that the font pathname must have at least one null character after
* it, making the maximum pathname length MAXFONTPATH-1.
*
* The next word contains the font YSize; in this case, 0x0008.  
*
* The next byte contains the font Flags, in this case 0x00.
*
* The last byte contains the font characteristics, in this case 0x60.
* This says it is a disk-based font (bit 1 set) and the font has been
* removed (bit 7 set), saying that the font is not currently resident.
*
* Summary of suits.font file:
*
* Name: fch_FileID fch_NumEntries fc_FileName     fc_YSize fc_Flags fc_Style
* Size: word       word         MAXFONTPATH bytes word     byte     byte
* Hex:  0f00       0001         73756974732F3800  0008     00       60
* ASCII:                        s u i t s / 8 \0
*
* The correct length of a font file may be calculated with this formula:
* length := ((number of font contents entries) * (MAXFONTPATH+4)) + 4.
* In this case (one entry), this becomes (MAXFONTPATH + 8) or 264.
*
* To try out this example font, do the following.
* Start up the Notepad program or any other program which allows the
* user to select fonts.  Choose the "suits" font in size 8 and type "abcd".
* This example font defines ASCII characters 'a' 'b' 'c' and 'd' only.
* All other characters map to a rectangle, meaning "character unknown".

        INCLUDE        "exec/types.i"
        INCLUDE        "exec/nodes.i"
        INCLUDE        "libraries/diskfont.i"

* Provide an easy exit in case this file is "Run" instead of merely loaded.

        MOVEQ        #-1,D0
        RTS

* The following five entries comprise a Node structure, used by the system
* to link disk fonts into a list.  See the definition of the "DiskFontHeader"
* structure in the "libraries/diskfont.i" include file for more information.

        DC.L        0               ; ln_Succ
        DC.L        0               ; ln_Pred
        DC.B        NT_FONT         ; ln_Type
        DC.B        0               ; ln_Pri
        DC.L        fontName        ; ln_Name

        DC.W        DFH_ID          ; FileID
        DC.W        1               ; Revision
        DC.L        0               ; Segment

* The next MAXFONTNAME bytes are a placeholder.  The name of the
* font contents file (e.g. "suits.font") will be copied here after this
* font descriptor is LoadSeg-ed into memory.  The Name field could have
* been left blank, but inserting the font name and size (or style) allows
* one to tell something about the font by using "Type OPT H" on the file.

fontName:
        DC.B        "suits8"        ; Name

* If your assembler needs an absolute value in place of the "length"
* variable, simply count the number of characters in Name and use that.

length  EQU         *-fontName      ; Assembler calculates Name's length.
        DCB.B       MAXFONTNAME-length,0 ; Padding of null characters.

* The rest of the information is a TextFont structure.
* See the "graphics/text.i" include file for more information.

font:
        DC.L        0               ; ln_Succ
        DC.L        0               ; ln_Pred
        DC.B        NT_FONT         ; ln_Type
        DC.B        0               ; ln_Pri
        DC.L        fontName        ; ln_Name
        DC.L        0               ; mn_ReplyPort
        DC.W        0               ; (Reserved for 1.4 system use.)
        DC.W        8               ; tf_YSize
        DC.B        0               ; tf_Style
        DC.B        FPF_DESIGNED!FPF_PROPORTIONAL!FPF_DISKFONT ; tf_Flags
        DC.W        14              ; tf_XSize
        DC.W        6               ; tf_Baseline

* tf_Baseline must be no greater than tf_YSize-1, otherwise algorithmically-
* generated styles (italic in particular) can corrupt system memory. 

        DC.W        1               ; tf_BoldSmear
        DC.W        0               ; tf_Accessors
        DC.B        97              ; tf_LoChar
        DC.B        100             ; tf_HiChar
        DC.L        fontData        ; tf_CharData
        DC.W        8               ; tf_Modulo, no. of bytes to add to the
                                    ; data pointer to go from one row of
                                    ; a character to the next row of it.
        DC.L        fontLoc         ; tf_CharLoc, bit position in the font
                                    ; data at which the character begins.
        DC.L        fontSpace       ; tf_CharSpace
        DC.L        fontKern        ; tf_CharKern

* The four characters of this font define the four playing-card suit symbols.
* The heart, club, diamond, and spade map to the lower-case ASCII characters
* 'a', 'b', 'c', and 'd' respectively.  The fifth entry in the table is the
* character to be output when there is no entry defined in the character set
* for the requested ASCII value.
*
*
*   97 (a)       98 (b)       99 (c)   100 (d)      255
* <            X            X        X            X            >
*  .@@@...@@@.  .....@.....  ...@...  ....@@@....  @@@@@@@@@@@@
*  @@@@@.@@@@@  ...@@@@@...  ..@@@..  ...@@@@@...  @@........@@
*  .@@@@@@@@@.  .@@@@@@@@@.  .@@@@@.  .@@..@..@@.  @@........@@
*  ..@@@@@@@..  @@@@@@@@@@@  @@@@@@@  @@@@@@@@@@@  @@........@@
*  ...@@@@@...  .@@@.@.@@@.  .@@@@@.  .@@..@..@@.  @@........@@
*  ....@@@....  .....@.....  ..@@@..  .....@.....  @@........@@
*  .....@.....  ...@@@@@...  ...@...  ...@@@@@...  @@@@@@@@@@@@
*  ...........  ...........  .......  ...........  ............

* Font data is bit-packed edge to edge to save space.

fontData:
        DC.W        $071C0,$08040,$070FF,$0F000
        DC.W        $0FBE3,$0E0E0,$0F8C0,$03000
        DC.W        $07FCF,$0F9F3,$026C0,$03000
        DC.W        $03F9F,$0FFFF,$0FFC0,$03000
        DC.W        $01F0E,$0B9F3,$026C0,$03000
        DC.W        $00E00,$080E0,$020C0,$03000
        DC.W        $00403,$0E040,$0F8FF,$0F000
        DC.W        $00000,$00000,$00000,$00000
        DC.W        $00000,$00000,$00000,$00000

* The fontLoc information is used to "unpack" the fontData.
* Each pair of words specifies how the characters are bit-packed.  For
* example, the first character starts at bit position 0x0000, and is 0x000B
* (11) bits wide.  The second character starts at bit position 0x000B and
* is 0x000B bits wide, and so on.  This tells the font handler how to unpack
* the bits from the array.

fontLoc:         
        DC.L        $00000000B,$0000B000B,$000160007,$0001D000B,$00028000C

* fontSpace array:  Use a space this wide to contain this character when it
* is printed.  For reverse-path fonts these values would be small or negative.

fontSpace:
        DC.W        000012,000012,000008,000012,000013

* fontKern array:  Place a space this wide after the corresponding character
* to separate it from the following character.  For reverse-path fonts these
* values would be large negative numbers, approximately the width of the
* characters.

fontKern:
        DC.W        000001,000001,000001,000001,000001

fontEnd:
        END

