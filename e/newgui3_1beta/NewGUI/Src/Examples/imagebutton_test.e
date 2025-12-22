OPT     LARGE
OPT     OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'tools/copylist'
MODULE  'intuition/intuition'
MODULE  'newgui/pl_imagebutton'

DEF     pp1,
        pp2,
        b2=NIL:PTR TO imagebutton
DEF     b1=NIL:PTR TO imagebutton,
        b3=NIL:PTR TO imagebutton,
        bp=NIL:PTR TO imagebutton

PROC main() HANDLE
  DEF img1, img2, img3,
      d1=NIL, d2=NIL, d3=NIL, d4=NIL, d5=NIL
  img1:=[0,0,22,22,3,
         d1:=copyListToChip([	/* Plane 0 */
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
         d2:=copyListToChip([	/* Plane 0 */
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
         d3:=copyListToChip([	/* Plane 0 */
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
  pp1:=[0,0,22,7,2,
        d4:=copyListToChip([$00030000, $0003C000, $0003F000, $0003FC00,
                        $0003F000, $0003C000, $00030000,
                        $E3800000, $E3800000, $E3800000, $E3800000,
                        $E3800000, $E3800000, $E3800000]),
        $0003, 0, NIL]:image
  pp2:=[0,0,22,7,2,
        d5:=copyListToChip([$E3800000, $E3800000, $E3800000, $E3800000,
                        $E3800000, $E3800000, $E3800000,
                        $00030000, $0003C000, $0003F000, $0003FC00,
                        $0003F000, $0003C000, $00030000]),
        $0003, 0, NIL]:image

  newguiA([
        NG_WINDOWTITLE, 'NewGUI-Image-Button-Plugin',     
        NG_GUI,
                [ROWS,
                        [TEXT,'ImageButton test...',NIL,TRUE,5],
                [COLS,
                        [IMGBUTTON,{buttonaction1},NEW b1.toggleimagebutton(img1)],
                        [IMGBUTTON,{buttonaction1},NEW b2.pushimagebutton(img2)],
                        [IMGBUTTON,{buttonaction2},NEW b3.imagebutton(img3)],
                        [IMGBUTTON,{buttonaction3},NEW bp.toggleimagebutton(pp1,30,22)]
                ],
                [SBUTTON,{toggle_enabled},'Toggle Enabled',bp]
                ],NIL,NIL])
EXCEPT DO
  END b1
  END b2
  END b3
  END bp
   Dispose(d1)
   Dispose(d2)
   Dispose(d3)
   Dispose(d4)
   Dispose(d5)
  IF exception THEN WriteF('Exception: \d\n',exception)
ENDPROC

PROC buttonaction1(i,b:PTR TO imagebutton)
  WriteF('button selected=\d\n', b.selected)
ENDPROC

PROC buttonaction2(i,b:PTR TO imagebutton)
  WriteF('button selected=\d\n', b.selected)
  b2.setselected(FALSE)
ENDPROC

PROC buttonaction3(i,b:PTR TO imagebutton)
  WriteF('button selected=\d\n', b.selected)
  b.setimage(IF b.selected THEN pp2 ELSE pp1)
ENDPROC

PROC toggle_enabled(b:PTR TO imagebutton,i)
  b.setdisabled(b.disabled=FALSE)
ENDPROC
