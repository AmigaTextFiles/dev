
; soc25.s = IFF.s
; Aufruf über die Shell mit Paramter
; z.B. >soc25 dragonSun320x256x5.iff
; d.h. Objektdatei erstellen >wo soc25

; Coded by Denis Duplan for Stash of Code (http://www.stashofcode.fr, stashofcode@gmail.com) in 2018.

; Dieses Werk bzw. diese Werke werden unter den Bedingungen der Lizenz
; (http://creativecommons.org/licenses/by-nc/4.0/)
; Creative Commons Namensnennung - Keine kommerzielle Nutzung 4.0
; International veröffentlicht.

; Laden und Anzeigen einer IFF-Datei in 5 Bitplanes beliebiger Größe, solange diese nicht größer
; als DISPLAY_DX x DISPLAY_DY sind (DISPLAY_DEPTH muss der Anzahl der Bitplanes in der IFF-Datei 
; entsprechen: Vorsicht, da einige Programme Bilder in mehr Bitplanes speichern als man denkt, 
; wie z.B. Pro Motion NG, das systematisch in 8 Bitplanes speichert). 

; TODO: Testen von Overflows beim Dekomprimieren (Überschreitung der Länge der Eingabedatei,
; Überschreitung der Größe der Ausgabebitplanes)

;********** Direktiven **********

	SECTION yragael,CODE_C

;********** Konstanten **********

; Programm

DISPLAY_X=$81
DISPLAY_Y=$2C
DISPLAY_DX=320
DISPLAY_DY=256
DISPLAY_DEPTH=5
COPSIZE=10*4+DISPLAY_DEPTH*2*4+(1<<DISPLAY_DEPTH)*2*4+4
	; 10*4						Konfiguration der Anzeige
	; DISPLAY_DEPTH*2*4			Adressen der Bitebenen
	; (1<<DISPLAY_DEPTH)*2*4	Palette
	; 4							$FFFFFFFE

;********** Initialisierung **********

	; Register auf den Stack

	movem.l d0-d7/a0-a6,-(sp)
	lea $DFF000,a5

	; Den Pfad zum Bild abrufen

	lea readArgsData,a0
	move.l #argsTemplate,OFFSET_READARGS_TEMPLATE(a0)
	move.l #argsValues,OFFSET_READARGS_VALUES(a0)
	move.l #argsHelp,OFFSET_READARGS_HELP(a0)
	bsr _readArgs
	tst.w d0
	bne _readArgsSucceeded
	bsr _freeArgs
	movem.l (sp)+,d0-d7/a0-a6
	rts
_readArgsSucceeded:

	; Bild laden

	lea argsValues,a0
	movea.l (a0),a0
	bsr _loadFile
	move.l d0,pictureSize
	move.l a0,pictureData
	bne _pictureLoaded
	bsr _freeArgs
	movem.l (sp)+,d0-d7/a0-a6
	rts
_pictureLoaded:
	bsr _freeArgs

	; Speicher in CHIP zuordnen, der für die Copperliste auf 0 gesetzt ist

	move.l #COPSIZE,d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,copperList

	; Speicher in CHIP zuordnen, der für die Bitebene auf 0 gesetzt ist

	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	move.l #$10002,d1
	movea.l $4,a6
	jsr -198(a6)
	move.l d0,bitplanes

	; System ausschalten

	movea.l $4,a6
	jsr -132(a6)

	; Warten Sie auf ein VERTB (damit die Sprites nicht sabbern) und
	; schalten Sie alle Hardware-Interrupts und DMAs aus.

	bsr _waitVERTB
	move.w INTENAR(a5),oldintena
	move.w #$7FFF,INTENA(a5)
	move.w INTREQR(a5),oldintreq
	move.w #$7FFF,INTREQ(a5)
	move.w DMACONR(a5),olddmacon
	move.w #$07FF,DMACON(a5)

;---------- Copperlist ----------

	movea.l copperList,a0

	; Konfiguration des Bildschirms

	move.w #DIWSTRT,(a0)+
	move.w #(DISPLAY_Y<<8)!DISPLAY_X,(a0)+
	move.w #DIWSTOP,(a0)+
	move.w #((DISPLAY_Y+DISPLAY_DY-256)<<8)!(DISPLAY_X+DISPLAY_DX-256),(a0)+
	move.w #BPLCON0,(a0)+
	move.w #(DISPLAY_DEPTH<<12)!$0200,(a0)+
	move.w #BPLCON1,(a0)+
	move.w #$0000,(a0)+
	move.w #BPLCON2,(a0)+
	move.w #$0000,(a0)+
	move.w #DDFSTRT,(a0)+
	move.w #((DISPLAY_X-17)>>1)&$00FC,(a0)+
	move.w #DDFSTOP,(a0)+
	move.w #((DISPLAY_X-17+(((DISPLAY_DX>>4)-1)<<4))>>1)&$00FC,(a0)+
	move.w #BPL1MOD,(a0)+
	move.w #0,(a0)+
	move.w #BPL2MOD,(a0)+
	move.w #0,(a0)+

	;  Kompatibilität OCS mit AGA

	move.w #FMODE,(a0)+
	move.w #$0000,(a0)+

	; Adressen der Bitebenen

	move.w #BPL1PTH,d0
	move.l bitplanes,d1
	moveq #DISPLAY_DEPTH-1,d2
_copperListBitplanes:
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	move.w d0,(a0)+
	swap d1
	move.w d1,(a0)+
	addq.w #2,d0
	addi.l #DISPLAY_DY*(DISPLAY_DX>>3),d1
	dbf d2,_copperListBitplanes

	; Palette

	move.w #COLOR00,d1
	moveq #(1<<DISPLAY_DEPTH)-1,d0
_copperListColors:
	move.w d1,(a0)+
	addq.w #2,d1
	move.w #$0000,(a0)+
	dbf d0,_copperListColors

	; Ende

	move.l #$FFFFFFFE,(a0)

	; DMA aktivieren

	bsr _waitVERTB
	move.w #$83C0,DMACON(a5)	; DMAEN=1, BPLEN=1, COPEN=1, BLTEN=1

	; Start Copperlist

	move.l copperList,COP1LCH(a5)
	clr.w COPJMP1(a5)

;********** Hauptprogramm **********

	; Bild anzeigen
	
	lea IFFLoaderData,a0
	move.l pictureData,OFFSET_IFFLOADER_DATA(a0)
	move.l bitplanes,OFFSET_IFFLOADER_BITPLANES(a0)
	move.l #palette,OFFSET_IFFLOADER_PALETTE(a0)
	move.l pictureSize,OFFSET_IFFLOADER_FILESIZE(a0)
	move.l #DISPLAY_DX>>3,OFFSET_IFFLOADER_LINESMODULO(a0)
	move.l #DISPLAY_DY*(DISPLAY_DX>>3),OFFSET_IFFLOADER_BITPLANESMODULO(a0)
	bsr _IFFLoader

	movea.l copperList,a0
	lea 10*4+DISPLAY_DEPTH*2*4+2(a0),a0
	lea palette,a1
	moveq #(1<<DISPLAY_DEPTH)-1,d0
_setPalette:
	move.w (a1)+,(a0)
	lea 4(a0),a0
	dbf d0,_setPalette

	; Speicher freigeben der für die Datei verwendet wird

	movea.l pictureData,a1
	move.l pictureSize,d0
	movea.l $4,a6
	jsr -210(a6)

	; Warten, bis die linke Maustaste gedrückt wird

_loop:
	btst #6,$BFE001
	bne _loop
_loopEnd:

;********** Ende **********

	; Hardware-Interrupts und DMAs ausschalten

	move.w #$7FFF,INTENA(a5)
	move.w #$7FFF,INTREQ(a5)
	move.w #$07FF,DMACON(a5)

	; Hardware-Interrupts und DMAs wiederherstellen

	move.w olddmacon,d0
	bset #15,d0
	move.w d0,DMACON(a5)
	move.w oldintreq,d0
	bset #15,d0
	move.w d0,INTREQ(a5)
	move.w oldintena,d0
	bset #15,d0
	move.w d0,INTENA(a5)

	; Copperlist wiederherstellen

	lea graphicsLibrary,a1
	movea.l $4,a6
	jsr -408(a6)
	move.l d0,a1
	move.l 38(a1),COP1LCH(a5)
	clr.w COPJMP1(a5)
	jsr -414(a6)

	; System wiederherstellen

	movea.l $4,a6
	jsr -138(a6)

	; Speicher freigeben

	movea.l copperList,a1
	move.l #COPSIZE,d0
	movea.l $4,a6
	jsr -210(a6)

	movea.l bitplanes,a1
	move.l #DISPLAY_DEPTH*DISPLAY_DY*(DISPLAY_DX>>3),d0
	movea.l $4,a6
	jsr -210(a6)

; Register wiederherstellen

	movem.l (sp)+,d0-d7/a0-a6
	rts

;********** Routinen **********

	INCLUDE "common/registers.s"
PUTSTR:		MACRO
	move.l \1,d1
	movea.l dosBase,a6
	jsr -948(a6)			; PutStr ()
	ENDM

IFERROR:	MACRO
	cmp.l \2,\1
	bne _ifErrorDone\@
	PUTSTR \3
	move.w \4,\5
	bra \6
_ifErrorDone\@
	ENDM

;---------- Warten auf vertikal blank (funktioniert nur, wenn der VERTB-Interrupt aktiviert ist!)  ----------

_waitVERTB:
	movem.w d0,-(sp)
_waitVERTBLoop:
	move.w INTREQR(a5),d0
	btst #5,d0
	beq _waitVERTBLoop
	movem.w (sp)+,d0
	rts

;---------- Kommandozeilenargumente lesen ----------

; Eingang(s) :
;	(die Struktur readArgsData)
; Ausgang(s) :
;	D0 = 1 wenn erfolgreich, sonst 0
; Hinweis :
;	Zu nennen, bevor Sie das Betriebssystem beschneiden und die Hardware optimieren!
;   Vergessen Sie nicht, _freeArgs aufzurufen, nachdem Sie das Ergebnis verwendet haben.

_readArgs:
	movem.l a0-a6/d1-d7,-(sp)
	move.w #0,readArgsResult

	; Die DOS-Bibliothek öffnen

	lea dosLibrary,a1
	moveq #0,d0
	movea.l $4,a6
	jsr -408(a6)			; OpenLibrary ()
	move.l d0,dosBase
	beq _readArgsOpenLibraryError

	; Lesen der Argumente

	lea readArgsData,a0
	move.l OFFSET_READARGS_TEMPLATE(a0),d1
	move.l OFFSET_READARGS_VALUES(a0),d2
	moveq #0,d3
	movea.l dosBase,a6
	jsr -798(a6)			; ReadArgs ()
	move.l d0,readArgsStructure
	IFERROR d0,#0,readArgsData+OFFSET_READARGS_HELP,#0,readArgsResult,_readArgsError
	move.w #1,readArgsResult

	; DOS-Bibliothek schließen

_readArgsError:
	movea.l dosBase,a1
	movea.l $4,a6
	jsr -414(a6)			; CloseLibrary ()

_readArgsOpenLibraryError:
	move.w readArgsResult,d0
	movem.l (sp)+,a0-a6/d1-d7
	rts

readArgsResult:		DC.W 0
readArgsStructure:	DC.L 0
readArgsData:
OFFSET_READARGS_TEMPLATE=0
OFFSET_READARGS_VALUES=4
OFFSET_READARGS_HELP=8
DATASIZE_READARGS=3*4
	BLK.B DATASIZE_READARGS,0

; Eingang(s) :
;	(nichts)
; Ausgang(s) :
;	(nichts)
; Hinweis :
; Wird immer nach _readArgs aufgerufen, sobald die Argumente verwendet wurden. Wird nicht
; gestört, wenn es jemals aufgerufen wird, während _readArgs aus irgendeinem Grund 
; abgestürzt ist, da FreeArgs () nichts tut, wenn D1 auf 0 gesetzt ist.

_freeArgs:
	movem.l a0-a6/d0-d7,-(sp)

	; Die DOS-Bibliothek öffnen

	lea dosLibrary,a1
	moveq #0,d0
	movea.l $4,a6
	jsr -408(a6)			; OpenLibrary ()
	move.l d0,dosBase

	; Zugewiesene Ressourcen zum Lesen von Argumenten freigeben
	
	move.l readArgsStructure,d1
	movea.l dosBase,a6
	jsr -858(a6)			; FreeArgs ()

	; DOS-Bibliothek schließen

	movea.l dosBase,a1
	movea.l $4,a6
	jsr -414(a6)			; CloseLibrary ()

	movem.l (sp)+,a0-a6/d0-d7
	rts

;---------- Laden einer Datei ----------

; Eingang(s) :
;	A0 = Dateipfadadresse endet mit $00
; Ausgang(s) :
;	A0 = Adresse, wo der Inhalt der Datei geladen wurde, oder 0, wenn nicht erfolgreich
;	D0 = Größe des Dateiinhalts in Byte oder 0, falls fehlgeschlagen
; Hinweis :
;	Zu nennen, bevor Sie das Betriebssystem beschneiden und die Hardware optimieren!

_loadFile:
	movem.l a1-a6/d1-d7,-(sp)
	move.l a0,loadFileName
	move.l #0,loadFileNbBytesLoaded
	move.l #0,loadFileData

	 ; Die DOS-Bibliothek öffnen

	lea dosLibrary,a1
	moveq #0,d0
	movea.l $4,a6
	jsr -408(a6)			; OpenLibrary ()
	move.l d0,dosBase
	IFERROR d0,#0,#loadFileMsgOpenLibrary,#0,loadFileResult,_loadFileOpenLibraryError

	; Datei sperren

	move.l loadFileName,d1
	moveq #-2,d2
	movea.l dosBase,a6
	jsr -84(a6)				; Lock ()
	move.l d0,loadFileLock
	IFERROR d0,#0,#loadFileMsgLock,#0,loadFileResult,_loadFileLockFailed

	; Die Datei untersuchen
	
	move.l loadFileLock,d1
	move.l #loadFileInfoBlock,d2
	movea.l dosBase,a6
	jsr -102(a6)			; Examine ()
	IFERROR d0,#0,#loadFileMsgExamine,#0,loadFileResult,_loadFileExamineError
	move.l loadFileInfoBlock+124,d0
	move.l d0,loadFileSize

	; Datei öffnen

	move.l loadFileName,d1
	move.l #1005,d2
	movea.l dosBase,a6
	jsr -30(a6)				; Open ()
	move.l d0,loadFileHandle
	IFERROR d0,#0,#loadFileMsgOpen,#0,loadFileResult,_loadFileOpenError

	; Weisen Sie beliebigen Speicher für Dateiinhalte zu

	move.l loadFileSize,d0
	moveq #0,d1
	movea.l $4,a6
	movea.l $4,a6
	jsr -198(a6)			; AllocMem ()
	move.l d0,loadFileData
	IFERROR d0,#0,#loadFileMsgAllocMem,#0,loadFileResult,_loadFileAllocMemError

	; Dateiinhalt laden

	move.l loadFileHandle,d1
	move.l loadFileData,d2
	move.l loadFileSize,d3
	movea.l dosBase,a6
	jsr -42(a6)				; Read ()
	move.l d0,loadFileNbBytesLoaded
	IFERROR d0,#0,#loadFileMsgRead,#0,loadFileResult,_loadFileReadError

	; Datei schließen

_loadFileAllocMemError:
_loadFileReadError:
	move.l loadFileHandle,d1
	movea.l dosBase,a6
	jsr -36(a6)				; Close ()

	; Datei entsperren

_loadFileOpenError:
_loadFileExamineError:
	move.l loadFileLock,d1
	movea.l dosBase,a6
	jsr -90(a6)				; Unlock ()

	; Schließen Sie die DOS-Bibliothek

_loadFileLockFailed:
	movea.l dosBase,a1
	movea.l $4,a6
	jsr -414(a6)			; CloseLibrary ()
	
_loadFileOpenLibraryError:
	move.l loadFileNbBytesLoaded,d0
	move.l loadFileData,a0
	movem.l (sp)+,a1-a6/d1-d7
	rts

dosLibrary:				DC.B "dos.library",0
						EVEN
dosBase:				DC.L 0
loadFileName:			DC.L 0
loadFileSize:			DC.L 0
loadFileHandle:			DC.L 0
loadFileData:			DC.L 0
loadFileLock:			DC.L 0
						CNOP 0,4			; Auf 32 Bit ausrichten, da loadFileInfoBlock sonst bei
											; der Rückkehr von Examine () in Unordnung gerät.

loadFileInfoBlock:		BLK.B 260,0
loadFileNbBytesLoaded:	DC.L 0
loadFileResult:			DC.W 0
loadFileMsgOpenLibrary:	DC.B "Could not open DOS library",$0A,0
						EVEN
loadFileMsgLock:		DC.B "Could not lock file",$0A,0
						EVEN
loadFileMsgExamine:		DC.B "Could not examine file",$0A,0
						EVEN
loadFileMsgOpen:		DC.B "Could not open file",$0A,0
						EVEN
loadFileMsgAllocMem:	DC.B "Could not allocate memory for file",$0A,0
						EVEN
loadFileMsgRead:		DC.B "Could not read file",$0A,0
						EVEN

;---------- Laden eines Bildes im Format IFF ILBM ----------

; Inhalt des FORM-Chunks :

IFF_FORM_ID=0			; "FORM" = $464F524D
IFF_FORM_lENGTH=4		; Chunk-Größe ohne ID und Größe (dh: Dateigröße - 8)
IFF_FORM_ILBM=0			; "ILBM" = $494C424D

; Inhalt des CMAP-Chunks :

IFF_CMAP_ID=0			; "CMAP" = $434D4150
IFF_CMAP_LENGTH=4		; Größe des Chunks ohne Zählen der ID und der Größe (dh: Anzahl der Bytes des folgenden Chunks)
; (Reihe von R-, G-, B-Byte-Tripletts)

; Inhalt des BMHD-Chunks:

IFF_BMHD_ID=0			; "BMHD" = $424D4844
IFF_BMHD_LENGTH=4		; Größe des Chunks ohne Zählen der ID und der Größe (dh: Anzahl der Bytes des folgenden Chunks)
IFF_BMHD_WIDTH=0
IFF_BMHD_HEIGHT=2
IFF_BMHD_X=4
IFF_BMHD_Y=6
IFF_BMHD_NBPLANES=8
IFF_BMHD_MASKING=9
IFF_BMHD_COMPRESSION=10	; 1 wenn Komprimierung in RLE
IFF_BMHD_PADDING=11
IFF_BMHD_TRANSPARENTCOLOR=12
IFF_BMHD_XASPECT=14
IFF_BMHD_YASPECT=15
IFF_BMHD_PAGEWIDTH=16
IFF_BMHD_PAGEHEIGHT=18

; Inhalt des BODY-Chunks :

IFF_BODY_ID=0			; "BODY" = $424F4459
IFF_BODY_LENGTH=4		; Größe des Chunks ohne Zählen der ID und der Größe (dh: Anzahl der Bytes des folgenden Chunks)
; (Daten aufeinanderfolgender Zeilen, komprimiert oder nicht in RLE)

; Suchen eines IFF-ILBM-Chunks anhand seiner Kennung
;
; Eingang(s) :
;	A0 = Adresse des Starts
;	D0 = # maximale zu testende Bytes (WORD)
;	D1 = ID des zu findenden Chunks, umgekehrt (DWORD)
; Ausgang(s) :
;	A0 = Adresse des Bytes nach der ID
;	D0 = # der Anfangsbytes minus der Anzahl der bis zum Ende der ID durchlaufenen Bytes oder 0
;	D1 = 1 wenn der Chunk gefunden wurde, sonst 0

_IFFSeekChunk:
	movem.l d2-d3,-(sp)

	move.l d1,d2
	moveq #4,d3
_IFFSeekChunkLoop:

	subq.l #1,d0
	bge _IFFSeekChunkNext
	moveq #0,d1
	bra _IFFSeekChunkDone
_IFFSeekChunkNext:

	cmp.b (a0)+,d2
	beq _IFFSeekChunkCharFound

	moveq #4,d3
	move.l d1,d2
	bra _IFFSeekChunkLoop

_IFFSeekChunkCharFound:
	subq.b #1,d3
	bne _IFFSeekChunkNextChar
	moveq #1,d1
	bra _IFFSeekChunkDone

_IFFSeekChunkNextChar:
	lsr.l #8,d2
	bra _IFFSeekChunkLoop
	
_IFFSeekChunkDone:
	movem.l (sp)+,d2-d3
	rts

; Eingang(s) :
;	(die Struktur IFFLoaderData)
; Ausgang(s) :
;	D0 = 1 wenn OK, ansonsten 0

_IFFLoader:
	movem.l d1-d6/a2-a5,-(sp)

	; Lesen Sie den FORM-Block

	lea IFFLoaderData,a1
	movea.l OFFSET_IFFLOADER_DATA(a1),a0
	move.l OFFSET_IFFLOADER_FILESIZE(a1),d0
	move.l #$4D524F46,d1	; "MROF"
	bsr _IFFSeekChunk
	tst.w d1
	bne _IFFFORMFound
	moveq #0,d0
	bra _IFFLoaderDone
_IFFFORMFound:

	lea 8(a0),a0
	subq.l #8,d0

	; Lesen Sie den Block BMHD

	move.l #$44484D42,d1	; "DHMB"
	bsr _IFFSeekChunk
	tst.w d1
	bne _IFFBMHDFound
	moveq #0,d0
	bra _IFFLoaderDone
_IFFBMHDFound:

	move.l (a0)+,d1
	move.l a0,a2
	add.l d1,a0
	sub.l d1,d0

	; Lesen Sie den Block CMAP

	move.l #$50414D43,d1	; "PAMC"
	bsr _IFFSeekChunk
	tst.w d1
	bne _IFFCMAPFound
	moveq #0,d0
	bra _IFFLoaderDone
_IFFCMAPFound:

	move.l (a0)+,d1
	sub.l d1,d0	

	movea.l OFFSET_IFFLOADER_PALETTE(a1),a3
_IFFReadCMAP:
	clr.w d2
	move.b (a0)+,d2
	lsl.w #4,d2
	move.b (a0)+,d2
	and.b #$F0,d2
	move.b (a0)+,d3
	lsr.b #4,d3
	or.b d3,d2
	move.w d2,(a3)+
	subq.b #3,d1
	bne _IFFReadCMAP

	; Lesen Sie den Block BODY

	move.l #$59444F42,d1	; "YDOB"
	bsr _IFFSeekChunk
	tst.w d1
	bne _IFFBODYFound
	moveq #0,d0
	bra _IFFLoaderDone
_IFFBODYFound:

	lea 4(a0),a0
	move.w IFF_BMHD_HEIGHT(a2),d0
	movea.l OFFSET_IFFLOADER_BITPLANES(a1),a3
	tst.b IFF_BMHD_COMPRESSION(a2)
	bne _IFFDepack

_IFFCopy:
	movea.l a3,a4
	move.b IFF_BMHD_NBPLANES(a2),d1
_IFFCopyPlanes:
	move.w IFF_BMHD_WIDTH(a2),d2
	lsr.w #3,d2
	movea.l a4,a5
_IFFCopyRow:
	move.b (a0)+,(a5)+
	subq.w #1,d2
	bne _IFFCopyRow
	add.l OFFSET_IFFLOADER_BITPLANESMODULO(a1),a4
	subq.b #1,d1
	bne _IFFCopyPlanes
	add.l OFFSET_IFFLOADER_LINESMODULO(a1),a3
	subq.w #1,d0
	bne _IFFCopy
	bra _IFFLoaderSuccess

_IFFDepack:
	clr.w d3
	movea.l a3,a4
	move.b IFF_BMHD_NBPLANES(a2),d1
_IFFDepackPlanes:
	move.w IFF_BMHD_WIDTH(a2),d2
	lsr.w #3,d2
	movea.l a4,a5
_IFFDepackRow:
	move.b (a0)+,d3
	bge _IFFDepackRowCopy
	cmpi.b #$80,d3
	beq _IFFDepackRowStop
	neg.b d3
	sub.w d3,d2
	subq.w #1,d2
_IFFDepackReplicate:
	move.b (a0),(a5)+
	subq.b #1,d3
	bge _IFFDepackReplicate
	lea 1(a0),a0
	bra _IFFDepackRowDone
_IFFDepackRowCopy:
	move.b (a0)+,(a5)+
	subq.w #1,d2
	subq.b #1,d3
	bge _IFFDepackRowCopy
_IFFDepackRowDone:
	tst.w d2
	bne _IFFDepackRow
_IFFDepackRowStop:
	add.l OFFSET_IFFLOADER_BITPLANESMODULO(a1),a4
	subq.b #1,d1
	bne _IFFDepackPlanes
	add.l OFFSET_IFFLOADER_LINESMODULO(a1),a3
	subq.w #1,d0
	bne _IFFDepack

_IFFLoaderSuccess:
	moveq #1,d0

_IFFLoaderDone:
	movem.l (sp)+,d1-d6/a2-a5
	rts

IFFLoaderData:
OFFSET_IFFLOADER_DATA=0
OFFSET_IFFLOADER_BITPLANES=4
OFFSET_IFFLOADER_PALETTE=8
OFFSET_IFFLOADER_FILESIZE=12
OFFSET_IFFLOADER_LINESMODULO=16
OFFSET_IFFLOADER_BITPLANESMODULO=20
DATASIZE_IFFLOADER=6*4
	BLK.B DATASIZE_IFFLOADER,0

;********** Daten **********

olddmacon:			DC.W 0
oldintena:			DC.W 0
oldintreq:			DC.W 0
copperList:			DC.L 0
graphicsLibrary:	DC.B "graphics.library",0
					EVEN
bitplanes:			DC.L 0
palette:			BLK.W 256,0
pictureSize:		DC.L 0
pictureData:		DC.L 0
argsTemplate:		DC.B "PICTURE/A",0	; Informationen zum Format dieser Zeichenfolge finden Sie in der offiziellen ReadArgs()-Dokumentation
					EVEN
argsValues:			BLK.L 1,0			; Fügen Sie für jedes zusätzliche Argument ein LONG hinzu (ex: BLK.L 3,0)
argsHelp:			DC.B "Usage : IFF <any 5 bitplanes picture IFF File width <= 320 and height <= 256>",$0A,0
					EVEN


	end
