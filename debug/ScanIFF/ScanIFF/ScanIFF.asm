;
;   IFFscan - IFF file scanner - Jim Butterfield.  January 12/90.

; Exec library calls
_LVOOpenLibrary       EQU -$228
_LVOCloseLibrary      EQU -$19E
_LVOSetSignal         EQU -$132
; DOS library calls
_LVOSeek              EQU -$42
_LVOOutput            EQU -$3C
_LVOWrite             EQU -$30
_LVORead              EQU -$2A
_LVOClose             EQU -$24
_LVOOpen              EQU -$1E
;
BufSize EQU 10
;-- Initial setup:
Startup     move.l a0,a4       ; Remember ptr to argument line. cf MOVEA
            move.b #0,-$1(a0,d0.W)   ; binary zero at end
            lea    dosname(pc),a1    ; Name 'dos.library'.
            clr.l  d0                ;   Any version (0)
            move.l $4,a6             ;   Using Exec library
            jsr    _LVOOpenLibrary(a6)  ;   Open Dos library.
            move.l d0,a6             ; Remember DosBase ptr.
            tst.l  d0                ; Check for error (d0=0 means
            beq.s  StartupQuit       ;      dos not opened)
            bsr.s  DOSinit
            move.l a6,a1             ;-Specify Dos library in a1;
            move.l $4,a6             ;   then using Exec library,
            jsr    _LVOCloseLibrary(a6)    ;   close Dos library.
StartupQuit rts                      ; End of Program
;
;-- Get CLI outhandle:
DOSinit     jsr    _LVOOutput(a6)    ;   get CLI outhandle,
            move.l d0,d7             ;   & then remember it.
;
; -- Skin leading spaces:
skipspc     move.l a4,d1             ; filename start
            cmp.b  #$20,(a4)+        ; space?
            beq.s  skipspc
            move.l #1005,d2          ; MODE_OLDFILE (for reading)
            jsr    _LVOOpen(a6)
            move.l d0,d6             ; file inhandle
            beq.s  FileNot           ; no good, quit
            link   a5,#-$1C
            bsr.s  ScanFile          ; the main job
            unlk   a5
            move.l d6,d1             ; use the handle..
            jsr    _LVOClose(a6)     ; to close the file
DOSquit     rts                      ;   exit program.
FileNot     move.l d7,d1             ; handle
            lea    FNF.MSG(pc),a0 
            move.l a0,d2     
            moveq  #FNFlen,d3
            jmp    _LVOWrite(a6)
;
; DOS is open and we have our in/out handles.
; Global stack definitions
FileP   EQU -$4
DosBase EQU -$8
Type    EQU -$C
Abort   EQU -$10
String  EQU -$1C     ; 12 byte work area
; Look for 'FORM' or other drawer types
ScanFile:   move.l a6,DosBase(a5)
            moveq  #1,d4             ; start at Level 1
            moveq  #0,d0
            move.l d0,Abort(a5)      ; Ctrl-C trap
            move.l d0,FileP(a5)      ; file position=start
            bsr    ReadType
            tst.l  d5                ; is it a drawer?
            bne.s  GotDrawer         ; yes, exit
; First four characters are not valid type.  Give up.
            move.l d7,d1             ;output handle
            lea    NotIFF.MSG(pc),a0  ;message to
            move.l a0,d2             ;       buffer
            moveq  #NotIFFlen,d3     ;length
            jsr    _LVOWrite(a6)
            bra.s  SFexit
;
GotDrawer   bsr.s  DoBlock           ; recursive analysis job
            tst.l  Abort(a5)
            beq.s  SFexit
            move.l d7,d1             ;output handle
            lea    CtrlCMess(pc),a0  ;message to
            move.l a0,d2             ;       buffer
            moveq  #3,d3             ;length
            jsr    _LVOWrite(a6)
SFexit      rts                       ; job complete
; D4=Recursion level      D5=Drawer Flag
; D6=Inhandle (file)      D7=Outhandle (screen)
; A4=Local Stack Frame
; A5=Global Stack Frame   A6=DosLibrary
; 
BSize       EQU     -4
CSize       EQU     -8
FileF       EQU     -12
XType       EQU     -$10
DoBlock     link    a4,#-$10          ; local variables
; read Size of this block
            move.l d6,d1             ; input file handle
            lea    BSize(a4),a2      ; input buff (stack) address
            move.l a2,d2             ; .. to D2 for read
            moveq  #4,d3             ; read 4 characters
            add.l  d3,FileP(a5)      ; record file position
            jsr    _LVORead(a6)      ; read 'em
            move.l (a2),d0           ; take raw size
            addq.l #1,d0             ; round up to even value
            and.b  #$fe,d0
            move.l d0,CSize(a4)      ; store rounded value
            move.l FileP(a5),d1      ; start point this chunk
            add.l  d1,d0             ; log end point this chunk
            move.l d0,FileF(a4)
            tst.w  d5                ; a drawer?
            beq.s  NotDraw1
; read subType of the drawer
            move.l d6,d1             ; input file handle
            lea    XType(a4),a0      ; input buff (stack) address
            move.l a0,d2             ; .. to D2 for read
            moveq  #4,d3             ; read 4 characters
            add.l  d3,FileP(a5)      ; record file position
            jsr    _LVORead(a6)      ; read 'em
; print <indent> drawer Type <space> subType <newline>
            bsr    ShowType
            move.l d7,d1             ;output handle
            lea    Spaces(PC),a0     ;message to
            move.l a0,d2             ;       buffer
            moveq  #1,d3             ;length=1 space
            jsr    _LVOWrite(a6)
            move.l d7,d1             ;output handle
            lea    XType(a4),a0      ;message to
            move.l a0,d2             ;       buffer
            moveq  #4,d3             ;length
            jsr    _LVOWrite(a6)
            move.l d7,d1             ;output handle
            lea    NewLine(PC),a0    ;message to
            move.l a0,d2             ;       buffer
            moveq  #1,d3             ;length=1 char
            jsr    _LVOWrite(a6)
; Scan through size of drawer.  First, Check CTL-C
NotDraw1    move.l 4,a6              ; set Exec libr
            moveq  #0,d0
            move.l #$1000,d1
            jsr    _LVOSetSignal(a6) ;test CTRL-C
            move.l DosBase(a5),a6    ;restore DOS libr
            and.l  #$1000,d0
            or.l   d0,Abort(a5)
            tst.l  Abort(a5)
            bne.s  EndSect
            move.l FileP(a5),d0
            cmp.l  FileF(a4),d0
            bcc.s  EndSect
            tst.w  d5                ; a drawer?
            beq.s  NotDraw2
; Analyze drawer for sub elements - get Type!
            bsr.s  ReadType
; recurse .. look inside outer drawer
            addq   #1,d4
            bsr    DoBlock
            subq   #1,d4
            moveq  #1,d5             ; restore old drawer type!
            bra.s  NotDraw1
; found a non-drawer .. report it and position
; print <indent> Type <newline>
NotDraw2    bsr.s  ShowType
            move.l d7,d1             ;output handle
            lea    NewLine(PC),a0    ;message to
            move.l a0,d2             ;       buffer
            moveq  #1,d3             ;length=1 char
            jsr    _LVOWrite(a6)
; now position to FileP(a5)+CSize(a4)
            move.l d6,d1             ;input handle
            move.l FileF(a4),d2      ;new position
            move.l d2,FileP(a5)      ; synchronize
            moveq  #-1,d3            ;offset from start.file
            jsr    _LVOSeek(a6)
            bra.s  NotDraw1
EndSect     unlk    a4
            rts
; read Type and identify if drawer
ReadType    move.l d6,d1             ; input file handle
            lea    Type(a5),a2       ; input buff (stack) address
            move.l a2,d2             ; .. to D2 for read
            moveq  #4,d3             ; read 4 characters
            add.l  d3,FileP(a5)      ; record file position
            jsr    _LVORead(a6)      ; read 'em
; Look for 'FORM' or other drawer types
            moveq  #1,d5             ; drawer?
            moveq  #0,d0             ; zero table count
            lea    Ttab,a0           ; start of table
            move.l (a2),d1
RTloop      cmp.l  0(a0,d0.w),d1     ; is it drawer?
            beq.s  DrawerGot         ; yes, exit
            addq.w #4,d0             ; try next type
            cmp.w  #Ttlen,d0         ; any more?
            bne.s  RTloop            ; yes, try it
            moveq  #0,d5             ; not a drawer
DrawerGot   rts

; print <indent> Type..
ShowType    move.l d7,d1             ;output handle
            lea    Spaces(PC),a0     ;message to
            move.l a0,d2             ;       buffer
            move.l d4,d3             ; (Level) number of spaces
            jsr    _LVOWrite(a6)
            move.l d7,d1             ;output handle
            lea    Type(a5),a0       ;message to
            move.l a0,d2             ;       buffer
            moveq  #4,d3             ;length
            jsr    _LVOWrite(a6)
            move.l BSize(a4),d0      ; size of block
; MakeAscii
            lea    String(a5),a1     ; Address of string
            moveq  #11,d2            ; size of string
DigLoop     swap   d0                ; hi/lo swap
            moveq  #0,d1
            move.w d0,d1
            beq.s  Skipper
            divu   #10,d1
Skipper     move.w d1,d0
            swap   d0
            move.w d0,d1
            divu   #10,d1
            move.w d1,d0
            swap   d1
            or.b   #$30,d1
            move.b d1,0(a1,d2.w)
            tst.l  d0
            dbeq   d2,DigLoop
            lea    0(a1,d2.w),a0
            move.b #$20,-(a0)
            move.l d7,d1             ; outhandle
            moveq  #13,d3            ; max string size
            sub.b  d2,d3             ; less unused
            move.l a0,d2             ; num string address
; d2 string position, d3 length
            jsr _LVOWrite(a6)
            rts

Ttab        dc.b 'FORM'
            dc.b 'CAT '
            dc.b 'LIST'
            dc.b 'PROP'
Ttlen       EQU  *-Ttab
FNF.MSG     dc.b 'File not found.',$a
FNFlen      EQU  *-FNF.MSG
NotIFF.MSG  dc.b 'Not an IFF file!',$a
NotIFFlen   EQU  *-NotIFF.MSG
Spaces      dc.b '                        '
dosname     dc.b 'dos.library',0
CtrlCMess   dc.b '^C'
NewLine     dc.b $0a
            end
