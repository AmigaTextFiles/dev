/* 
 *  Testing the NewGUI register-Plugin
 * -==================================-
 * 
 */

OPT     OSVERSION = 37
OPT     LARGE

MODULE  'intuition/intuition'
MODULE  'newgui/newgui'
MODULE  'newgui/ng_showerror'
MODULE  'newgui/pl_register'
MODULE  'tools/copylist'

CONST   REG_INIT = 2

DEF     mem1=NIL,
        mem2=NIL,
        mem3=NIL,
        mem4=NIL,
        mem5=NIL

DEF     img1=NIL:PTR TO image,
        img2=NIL:PTR TO image,
        img3=NIL:PTR TO image,
        img4=NIL:PTR TO image,
        img5=NIL:PTR TO image

DEF     reg1=NIL:PTR TO register,
        reg2=NIL:PTR TO register

PROC main()     HANDLE
 getimages()
  newguiA([
        NG_WINDOWTITLE,         'NewGUI-Register-Plugin',     
        NG_GUI,
                [ROWS,
                [COLS,
                [ROWS,
                        [TEXT,' ',' ',FALSE,3],         -> Just for fixed Space!
                        [REGISTER,{clicked1},NEW reg1.register(['',img1,'',img2,'',img3,'',img4,'',img5,NIL,NIL],REG_INIT,TRUE,REG_LEFT,TRUE)]
                ],
                [ROWS,
                        [REGISTER,{clicked2},NEW reg2.register(['Page1',img1,'Page2',img2,'LongPageText',img3,'Page3',img4,'Page4',img5,NIL,NIL],REG_INIT,TRUE,REG_ABOVE,TRUE)],
                        [SPACEV],
                        [SPACE],
                        [SPACEV]
                ]],
                [COLS,
                        [SBUTTON,{reset},'Reset']]],
        NIL,                    NIL])

EXCEPT DO
  freeimages()
 IF (reg1<>NIL) THEN END reg1
 IF (reg2<>NIL) THEN END reg2
  IF exception THEN ng_showerror(exception)
 CleanUp(exception)
ENDPROC

PROC clicked1()
 DEF    realpage=0
  realpage:=reg1.get()
   realpage:=realpage+1
    WriteF('Register1 changed to page \d\n',realpage)
   reg2.set(reg1.get())
ENDPROC

PROC clicked2()
 DEF    realpage=0
  realpage:=reg2.get()
   realpage:=realpage+1
    WriteF('Register2 changed to page \d\n',realpage)
   reg1.set(reg2.get())
ENDPROC

PROC reset()
 reg1.set(REG_INIT)
 reg2.set(REG_INIT)
ENDPROC


-> Images-Stuff

PROC getimages()
  img1:=[0,0,22,22,3,
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
                             $01FFE000,$00000000]),
         $0007,0,NIL]:image
  img2:=[0,0,22,22,3,
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
                             $00000000,$00000000]),
         $0007,0,NIL]:image
  img3:=[0,0,22,22,3,
         mem3:=copyListToChip([	/* Plane 0 */
                             $00000000,$10000000,$3C000000,$7E000000,
                             $3F000000,$1FB00000,$0FF00000,$07FC0000,
                             $07FC0000,$0BFC0000,$17FF8000,$17F8C000,
                             $11F8C000,$17FFE000,$14002000,$1C003800,
                             $18003000,$18006000,$18006000,$10004000,
                             $1FFF8000,$00000000,
                              /* Plane 1 */
                             $00000000,$00000000,$14000000,$3A000000,
                             $1D000000,$0E900000,$07200000,$03EC0000,
                             $01EC0000,$05F40000,$0BF00000,$08F74000,
                             $0F374000,$08000000,$0BFFC000,$0FFFD800,
                             $07FFD000,$07FFE000,$0FFFA000,$0FFF8000,
                             $00000000,$00000000,
                              /* Plane 2 */
                             $00000000,$00000000,$04000000,$02000000,
                             $01000000,$00900000,$00000000,$000C0000,
                             $000C0000,$04040000,$08000000,$08074000,
                             $0F274000,$08000000,$09554000,$0EAA9800,
                             $05555000,$02AAE000,$0D552000,$0AAA8000,
                             $00000000,$00000000]),
         $0007,0,NIL]:image
  img4:=[0,0,22,7,2,
        mem4:=copyListToChip([$00030000, $0003C000, $0003F000, $0003FC00,
                        $0003F000, $0003C000, $00030000,
                        $E3800000, $E3800000, $E3800000, $E3800000,
                        $E3800000, $E3800000, $E3800000]),
        $0003, 0, NIL]:image
  img5:=[0,0,22,7,2,
        mem5:=copyListToChip([$E3800000, $E3800000, $E3800000, $E3800000,
                        $E3800000, $E3800000, $E3800000,
                        $00030000, $0003C000, $0003F000, $0003FC00,
                        $0003F000, $0003C000, $00030000]),
        $0003, 0, NIL]:image
ENDPROC

PROC freeimages()
 IF (mem1<>NIL) THEN Dispose(mem1)
 IF (mem2<>NIL) THEN Dispose(mem2)
 IF (mem3<>NIL) THEN Dispose(mem3)
 IF (mem4<>NIL) THEN Dispose(mem4)
 IF (mem5<>NIL) THEN Dispose(mem5)
ENDPROC

->

