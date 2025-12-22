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
MODULE  'newgui/pl_dndexample'
MODULE  'tools/copylist'

ENUM    GUI_DROPBOX = 1,
        GUI_DRAGBOX1,
        GUI_DRAGBOX2

DEF     img1,
        img2,
        mem1,
        mem2

DEF     gui=NIL:PTR TO guihandle,
        dnd1=NIL:PTR TO dndplug,
        dnd2=NIL:PTR TO dndplug,
        dnd3=NIL:PTR TO dndplug,
        string[80]:STRING

PROC main()     HANDLE
 StrCopy(string,'Dummy')
 getimages()
  img1:=[0,0,22,22,3,mem1,$0007,0,NIL]:image
  img2:=[0,0,22,22,3,mem2,$0007,0,NIL]:image
   gui:=guiinitA([
        NG_WINDOWTITLE,         'NewGUI-Drag \aN\a Drop-Test',
        NG_GUIID,               GUI_DROPBOX,
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [COLS,
                [COLS,
                [BEVELR,
                [ROWS,
                        [PLUGIN,{dragged},NEW dnd1.dnd(DND_DROPBOX,img1,NIL,22,22,NIL,44,DND_ACT_XCHANGE,NIL)]]],
                        [TEXT,'Dropbox!','<- Thats the',FALSE,3]
                ],
                [EQROWS,
                [DROP,                                                  -> Init a Drop-Group around the next element!
                        [STR,{stract},'Drop-String',string,80,10]       -> This element will automatically updated!
                ],
                [DROP,                                                  -> Another Drop-Group...
                        [NUM,0,'Drop-Number',FALSE,2]                   -> Attention! Output-Gadgets (like TEXT and NUM) are updated,
                ]]                                                      -> But if you use variables as starting values/strings, then
                ]                                                       -> This string wont be updated... maybe i will fix it later...
                ],
                        [SBUTTON,{dummy},'Test']
                ],
        NG_NEXTGUI,
->
        [NG_WINDOWTITLE,         'NewGUI-Drag \aN\a Drop-Test',
        NG_GUIID,               GUI_DRAGBOX1,
        NG_AUTOOPEN,            TRUE,
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [COLS,
                [BEVEL,
                [ROWS,
                        [PLUGIN,{dragged},NEW dnd3.dnd(DND_DRAGBOX,NIL,NIL,22,22,'Beispiel-String\0',99,DND_ACT_XCHANGE,NIL)]]],
                        [TEXT,'the Dropbox','Drop the Icon on',FALSE,3]
                ]
                ],
                        [SBUTTON,{dummy},'Test']
                ],
        NG_NEXTGUI,
->
        [NG_WINDOWTITLE,         'NewGUI-Drag \aN\a Drop-Test',
        NG_GUIID,               GUI_DRAGBOX2,
        NG_AUTOOPEN,            TRUE,
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [COLS,
                [BEVEL,
                [ROWS,
                        [PLUGIN,{dragged},NEW dnd2.dnd(DND_DRAGBOX,img2,NIL,22,22,'String2\0',20,DND_ACT_XCHANGE,NIL)]]],
                        [TEXT,'Dragbox!','Another',FALSE,3]
                ]
                ],
                        [SBUTTON,{dummy},'Test']
                ],
        NIL,                    NIL],
        NIL,                    NIL],
        NIL,                    NIL])

     handleall()

EXCEPT DO
 cleangui(gui,TRUE)
  END dnd3
  END dnd2
  END dnd1
   Dispose(mem2)
   Dispose(mem1)
    IF exception THEN ng_showerror(exception)
ENDPROC

PROC handleall()
 DEF    res=-1
  WHILE (res<0)
   Wait(gui.sig)
    res:=guimessage(gui)
  ENDWHILE
ENDPROC

PROC dummy()
 WriteF('String = "\s"\n',string)
ENDPROC

PROC dragged(x,plug:PTR TO dndplug)
 IF (plug.dnd_dest=NIL)
  WriteF('Clicked!\n')
 ELSE
  WriteF('Dropped!\n')
 ENDIF
ENDPROC

PROC stract(x,y)
 WriteF('string="\s"\n',y)
  StrCopy(string,y,StrLen(y))
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
