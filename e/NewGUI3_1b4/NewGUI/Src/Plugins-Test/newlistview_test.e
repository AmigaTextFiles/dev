OPT     OSVERSION=37
OPT     LARGE

MODULE  'intuition/intuition'
MODULE  'newgui/newgui'
MODULE  'newgui/pl_newlistview'
MODULE  'newgui/pl_dndexample'
MODULE  'tools/copylist'

ENUM    GUI_MAIN = 1,
        GUI_DROPBOX

DEF     nlv=NIL:PTR TO newlistview,
        dnd=NIL:PTR TO dndplug,
        num=0,
        img1,
        img2,
        mem1,
        mem2,
        oldval=0,
        gui=NIL:PTR TO guihandle,
        scroller=NIL,
        string[80]:STRING

PROC main() HANDLE
 StrCopy(string,'Dummy')
 getimages()
  img1:=[0,0,22,22,3,mem1,$0007,0,NIL]:image
  img2:=[0,0,22,22,3,mem2,$0007,0,NIL]:image
   newguiA([
        NG_WINDOWTITLE, 'NewGUI-NewListView-Plugin',     
        NG_GUIID,       GUI_MAIN,
        NG_GUI,
                [ROWS,
                        [TEXT,'NewListView test...',NIL,TRUE,1],->  lines  Showselected  Unused (currently!)
                [COLS,
                [BEVELR,                                   ->   width | ShowBar| Readonly |
                        [NEWLISTV,{nlvaction},NEW nlv.newlistview(100,5,TRUE,TRUE,FALSE,FALSE)]],
                        scroller:=[SCROLL,{lv_updown},TRUE,0,0,10,2]
                ],
                [EQCOLS,
                        [SBUTTON,{add},'Add'],
                [SPACEH],
                        [SBUTTON,{dis},'Disable']
                ]],
        NG_NEXTGUI,
       [NG_WINDOWTITLE,         'NewGUI-Drag \aN\a Drop-Test',
        NG_AUTOOPEN,            TRUE,
        NG_GUIID,               GUI_DROPBOX,
        NG_GUI,
                [ROWS,
                [DBEVELR,
                [COLS,
                [COLS,
                [BEVELR,
                [ROWS,
                        [PLUGIN,{dragged},NEW dnd.dnd(DND_DROPBOX,img2,NIL,22,22,NIL,44,DND_ACT_XCHANGE,NIL)]]],
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
        NIL,            NIL],
        NIL,            NIL],{getgui})
EXCEPT DO
   END nlv
   END dnd
  Dispose(mem1)
  Dispose(mem2)
 CleanUp(exception)
ENDPROC

PROC getgui(gh,scr)     IS      gui:=gh

PROC nlvaction()
 WriteF('Double-Clicked!\n')
ENDPROC

PROC dummy()
 WriteF('String = "\s"\nNumber: \d\n',string,num)
ENDPROC

PROC add()
 nlv.addline(img1,img1,'DEMO-String (this will be cuted off if it is too long...)',200,NIL)
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGAD,   NG_TOTAL,
        NG_GADGET,      scroller,
        NG_NEWDATA,     nlv.numlines,
        NIL,            NIL])
ENDPROC

PROC lv_updown(x,y)
  IF (y-oldval)>0 
   nlv.linedown(y-oldval)
  ELSEIF (y-oldval)<0
   nlv.lineup(oldval-y)
  ENDIF
 oldval:=y
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

PROC dis()
  IF nlv.dis=TRUE THEN nlv.dis:=FALSE ELSE nlv.dis:=TRUE
 nlv.disable(nlv.dis)
ENDPROC

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
                                                                        
