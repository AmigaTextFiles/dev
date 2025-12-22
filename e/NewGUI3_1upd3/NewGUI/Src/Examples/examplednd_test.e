/* 
 *  Test zur Drag 'N' Drop - Erweiterung von NewGUI 3.1
 * -===================================================-
 * 
 */

OPT     OSVERSION = 37
OPT     LARGE

MODULE  'intuition/intuition'
MODULE  'newgui/newgui'
MODULE  'newgui/ng_showerror'
MODULE  'newgui/ng_palette'
MODULE  'newgui/pl_dndexample'
MODULE  'tools/copylist'

DEF     gui=NIL:PTR TO guihandle,               -> !
        button=NIL,                             -> !
        plugin1=NIL,
        plugin2=NIL,
        disabled=FALSE,
        dnd1=NIL:PTR TO dndplug,
        dnd2=NIL:PTR TO dndplug,
        mem1,
        mem2


PROC main()     HANDLE
 DEF    img1,
        img2
  getimages()
  img1:=[0,0,22,22,3,mem1,$0007,0,NIL]:image
  img2:=[0,0,22,22,3,mem2,$0007,0,NIL]:image
   newguiA([
        NG_WINDOWTITLE,         'NewGUI-Drag \aN\a Drop-Test',
        NG_CLONESCREEN,         TRUE,
        NG_SCR_PUBNAME,         'NEWGUI',
        NG_OPENPUBSCREEN,       TRUE,
        NG_PALETTE,             {setpalette},
        NG_KEYFILTER,           {filter},                       -> Test für die Keyfilter - Prozedur!
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [EQCOLS,
                [BEVELR,
                [ROWS,
                        plugin1:=[PLUGIN,{dummy},NEW dnd1.dnd(DND_DROPBOX,img1,NIL,22,22,NIL,0,DND_ACT_XCHANGE,NIL)]]],
                [SPACEH],
                [BEVEL,
                [ROWS,
                        plugin2:=[PLUGIN,{dropped},NEW dnd2.dnd(DND_DRAGBOX,img2,NIL,22,22,0,NIL,DND_ACT_XCHANGE,NIL),'','',FALSE]]]
                ]
                ],
                [EQCOLS,
                        button:=[SBUTTON,{dummy},'Test',NIL,'','',disabled],
                [SPACEH],
                        [SBUTTON,{disable},'Disable']
                ]],
        NIL,                    NIL],{info})
EXCEPT DO
 END dnd2
 END dnd1
  Dispose(mem2)
  Dispose(mem1)
   IF exception THEN ng_showerror(exception)
ENDPROC

PROC filter(code,rawkey)                        -> Keyfilter, wenn rawkey=FALSE, dann sind es Vanilla-keys!
 IF rawkey
  WriteF('Code = $\h\n',code)
 ELSE
  WriteF('Code = $\c\n',code)
 ENDIF
ENDPROC

PROC setpalette(screen,depth)                   -> Diese Prozedur setzt die Palette des Screens, BEVOR ein Window darauf geöffnet wird!
 ng_readpalette('mwb.pal',screen,depth)         -> Eigene Prozedur in einem eigenen Modul (nicht zwingend nötig!), liest eine IFF-Palette!
ENDPROC

PROC info(g,s)                                  -> Holt den Guihandle von NewGUI (nur bei newguiA() nötig!), s=screenPTR!
 gui:=g
ENDPROC

PROC disable()                                  -> Alles disabled!
 IF disabled=TRUE
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   TRUE,
        NG_GADGET,      button,
        NG_ENABLE,      TRUE,
        NIL,            NIL])
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   TRUE,
        NG_GADGET,      plugin1,
        NG_ENABLE,      TRUE,
        NIL,            NIL])
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   TRUE,
        NG_GADGET,      plugin2,
        NG_ENABLE,      TRUE,
        NIL,            NIL])
   disabled:=FALSE
 ELSE
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   TRUE,
        NG_GADGET,      button,
        NG_DISABLE,     TRUE,
        NIL,            NIL])
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   TRUE,
        NG_GADGET,      plugin1,
        NG_DISABLE,     TRUE,
        NIL,            NIL])
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   TRUE,
        NG_GADGET,      plugin2,
        NG_DISABLE,     TRUE,
        NIL,            NIL])
   disabled:=TRUE
 ENDIF
ENDPROC

PROC dummy()    IS WriteF('Dummy!\n')

PROC dropped(x,plug:PTR TO dndplug)
 IF (plug.dnd_dest=NIL)
  WriteF('Clicked!\n')
 ELSE
  WriteF('Dropped!\n')
 ENDIF
ENDPROC

-> Nicht Plugin oder NewGUI-Spezifische Teile

PROC getimages()
 mem1:=copyListToChip([	/* Plane 0 */
                             $00000000,$00000000,$00000000,$00000000,
                             $00FC0000,$00060000,$00058000,$0404C000,
                             $0407E000,$04006000,$04006000,$04006000,
                             $04006000,$04006000,$04006000,$04006000,
                             $04006000,$04006000,$04006000,$07FFE000,
                             $01FFE000,$00000000,
                              /* Plane 1 */
                             $00000000,$02000000,$0A800000,$07000000,
                             $38C00000,$07F80000,$0BFA8000,$07FB4000,
                             $07F82000,$07FFA000,$07FFA000,$07FFA000,
                             $03FFA000,$03FFA000,$03FFA000,$03FFA000,
                             $03FFA000,$03FFA000,$03FFA000,$00002000,
                             $01FFE000,$00000000,
                              /* Plane 2 */
                             $00000000,$00000000,$00000000,$00000000,
                             $00C00000,$00000000,$00008000,$04004000,
                             $04002000,$04002000,$04002000,$04002000,
                             $00002000,$00002000,$00002000,$00002000,
                             $00002000,$00002000,$00002000,$00002000,
                             $01FFE000,$00000000])
 mem2:=copyListToChip([	/* Plane 0 */
                             $00000000,$00007000,$0003F000,$000FF000,
                             $001FF800,$000FF800,$0007F800,$1E0FF000,
                             $21DFF000,$40FFF000,$407FF000,$40FB2000,
                             $5FFF8000,$50008000,$7000E000,$6000C000,
                             $60018000,$60018000,$40010000,$7FFE0000,
                             $00000000,$00000000,
                              /* Plane 1 */
                             $00000000,$00004000,$00022000,$0001E000,
                             $0017E800,$000BE800,$0003D800,$0007D000,
                             $1ECE5000,$3F1DB000,$3FB9F000,$3F752000,
                             $20000000,$2FFF0000,$3FFF6000,$1FFF4000,
                             $1FFF8000,$3FFE8000,$3FFE0000,$00000000,
                             $00000000,$00000000,
                              /* Plane 2 */
                             $00000000,$00004000,$00020000,$00000000,
                             $00100800,$00080800,$00001800,$00001000,
                             $1EC01000,$3F01B000,$3F81F000,$3F052000,
                             $20000000,$25550000,$3AAA6000,$15554000,
                             $0AAB8000,$35548000,$2AAA0000,$00000000,
                             $00000000,$00000000])
ENDPROC
