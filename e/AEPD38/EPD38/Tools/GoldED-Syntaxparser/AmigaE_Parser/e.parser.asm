; e.parser - GoldED syntax parser for the Amiga E Programming Language
;
; © 1995 by Leon Woestenberg (leon@stack.urc.tue.nl). Freeware.
;
; Assembled using the PhxAss shareware macro assembler by Frank Wille.
;
; The Amiga E Compiler is copyrighted by Wouter van Oortmerssen.
; GoldED is copyrighted by Dietmar Eilert.

  NOLIST
  ; system includes
  INCLUDE exec/initializers.i
  INCLUDE exec/resident.i
  INCLUDE exec/libraries.i
  INCLUDE exec_lib.i

  ; golded includes
  INCLUDE GOLDED:API/include/golded.i
  INCLUDE GOLDED:Syntax/Developer/include/scanlib.i

  ; revision include
  INCLUDE e.parser_rev.i
  LIST

  ; ebase structure
  STRUCTURE ebase,PB_SIZE
    ULONG ebase_seglist
    ULONG ebase_execbase
    LABEL ebase_SIZE

; fail when run as executable
first_address:
  moveq #-1,d0
  rts

; romtag (resident) structure
romtag:
  dc.w RTC_MATCHWORD
  dc.l romtag
  dc.l endcode
  dc.b RTF_AUTOINIT
  dc.b VERSION
  dc.b NT_LIBRARY
  dc.b 0
  dc.l libraryname
  dc.l idstring
  dc.l inittable

; we are RTF_AUTOINIT, so we present an init table
  EVEN
inittable:
  dc.l ebase_SIZE
  dc.l functable
  dc.l datatable
  dc.l initroutine
functable:
; absolute pointers to device standard routines
  dc.l Open
  dc.l Close
  dc.l Expunge
  dc.l Null
; absolute pointers to infraface device i/o entries
  dc.l MountScanner
  dc.l StartScanner
  dc.l CloseScanner
  dc.l FlushScanner
  dc.l SetupScanner
  dc.l BriefScanner
  dc.l ParseLine
  dc.l UnparseLines
  dc.l ParseSection
; function table end marker
  dc.l -1
datatable:
; initializes our library structure
; second argument to MakeLibrary
  INITBYTE LN_TYPE,NT_LIBRARY
  INITLONG LN_NAME,libraryname
  INITBYTE LIB_FLAGS,LIBF_SUMUSED ! LIBF_CHANGED
  INITWORD LIB_VERSION,VERSION
  INITWORD LIB_REVISION,REVISION
  INITLONG LIB_IDSTRING,idstring
  INITLONG PB_MAGIC,PARSER_MAGIC
  dc.l 0
initroutine:
  ; { d0 = ebase }
  ; { a0 = seglist }
  ; { a6 = execbase }
  exg d0,a0
  move.l d0,(ebase_seglist,a0)
  move.l a6,(ebase_execbase,a0)
  exg d0,a0
  ; { d0 = ebase }
  rts

Open:
  ; { d0 = version }
  ; { a6 = ebase }
  ; we have another opener
  addq.w #1,(LIB_OPENCNT,a6)
  ; prevent delayed expunges
  bclr.b #LIBB_DELEXP,(LIB_FLAGS,a6)
  ; return ebase
  move.l a6,d0
  rts

Close:
  ; set return value
  moveq #0,d0
  ; we lost one opener
  subq.w #1,(LIB_OPENCNT,a6)
  ; { Z = no openers }
  bne .end
  ; delayed expunge pending?
  btst.b #LIBB_DELEXP,(LIB_FLAGS,a6)
  ; { Z = no delayed expunge pending }
  beq .noexpunge
  bsr Expunge
.noexpunge:
.end:
  rts

Expunge:
  ;{ a6 = ebase }
  movem.l d2/a5/a6,-(sp)
  movea.l a6,a5
  ;{ a5 = ebase }
  movea.l (ebase_execbase,a5),a6
  ;{ a6 = execbase }
  tst.w (LIB_OPENCNT,a5)
  ; if zero users, expunge now
  beq .expungenow
  ;{ at least one user left }
  ; pend a delayed expunge and return 0
  bset.b #LIBB_DELEXP,(LIB_FLAGS,a5)
  moveq #0,d0
  bra .end
.expungenow:
  ;{ no users left }
  ; copy seglist into d2
  move.l (ebase_seglist,a5),d2
  ;{ d2 = pointer to our seglist }
  movea.l a5,a1
  ;{ a1 = ebase }
  ; remove library from list
  jsr (_LVORemove,a6)
  ;{ we are no longer in the library list }
  movea.l a5,a1
  ;{ a1 = ebase }
  moveq #0,d0
  move.w (LIB_NEGSIZE,a5),d0
  ;{ d0 = #bytes before library pointer }
  suba.l d0,a1
  ;{ a1 = first byte of our library }
  add.w (LIB_POSSIZE,a5),d0
  ;{ d0 = #bytes used by library }
  jsr (_LVOFreeMem,a6)
  ;{ d2 = pointer to our seglist }
  move.l d2,d0
  ;{ library no longer open }
  ;{ d0 = pointer to our seglist }
.end:
  movem.l (sp)+,d2/a5/a6
  rts

Null:
  moveq #0,d0
  rts

MountScanner:
  lea (parserdata,pc),a0
  move.l a0,d0
  ;{ a0 = parserdata }
  rts
StartScanner:
  ;{ d0 = syntaxstack }
  rts
CloseScanner:
FlushScanner:
SetupScanner:
BriefScanner:
  moveq #0,d0
  rts
ParseLine:
  bchg.b #1,$bfe001
  ;{ d0 = scanid }
  ;{ a0 = linenode }
  ;{ d1 = line }
  tst.l (LINENODE_FOLD,a0)
  bne .folded
  move.w (LINENODE_LEN,a0),d1
LENGTH EQUR d1
  ;{ d1 = length }
  beq .zerolength
  move.l (LINENODE_TEXT,a0),a1
TEXT EQUR a1
  ;{ a1 = text }
.leading:
  cmpi.b #' ',(TEXT)
  bne .trailing
  adda.l #1,TEXT
  subi.w #1,LENGTH
  beq .nothingleft
  bra .leading

.trailing:
  ; check last character against space
  cmpi.b #' ',(-1,TEXT,LENGTH)
  ; if no space then proceed
  bne .comment
  ; decrease length
  subi.w #1,LENGTH
  ; if zero length then leave
  beq .nothingleft
  ; check next last character
  bra .trailing

.comment:
  ;{ a1 = text (trimmed) }
  ;{ d1 = length (trimmed) }
  cmpi.b #'-',(TEXT)
  beq .second
  adda.l #1,TEXT
  subi.w #1,LENGTH
  beq .nothingleft
  bra .comment
.second:
  cmpi.b #'>',(1,TEXT)
  beq .gotone
  adda.l #1,TEXT
  subi.w #1,LENGTH
  beq .nothingleft
  bra .comment
.gotone:
  ;{ a0 = linenode }
  suba.l (LINENODE_TEXT,a0),TEXT
  ;{ a1 = start }
  movea.l d0,a0
  ;{ a0 = syntax stack }
  ;{ TEXT = start column }
  move.w TEXT,(SC_START,a0)
  add.l TEXT,LENGTH
  subq #1,LENGTH
  ;{ LENGTH = end column }
  move.w LENGTH,(SC_END,a0)
  move.w #1,(SC_LEVEL,a0)
  move.l #0,(SYNTAXCHUNK_SIZE,a0)
  move.w #0,(SYNTAXCHUNK_SIZE+SC_LEVEL,a0)
  ;{ d0 = syntax stack }
  bra .end
.nocomment:
.nothingleft:
.zerolength:
.folded:
  moveq #0,d0
.end:
  rts

UnparseLines:
  rts
ParseSection:
  rts

libraryname:
  dc.b 'e.parser',0
idstring:
  VSTRING

  EVEN
parserdata:
  dc.l SCANLIBVERSION
  dc.l VERSION
  dc.l 0 ;*** REVISION should be here, but GoldED rejects it then ?! ***
  dc.l info
  dc.w 2
  dc.l namelist
  dc.l colorlist
  dc.w 0
  dc.l 0
info:
  dc.b 'Amiga E Parser',0
  EVEN
namelist:
  dc.l standard
  dc.l onelinercomment
  dc.l 0
standard:
  dc.b 'Standard',0
onelinercomment:
  dc.b 'Single line comment ( -> bla bla )',0
  EVEN
colorlist:
  dc.l $000
  dc.l $fff
  dc.l 0
endcode:


