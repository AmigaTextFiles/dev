/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '0'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 Vector.library démo.
 ===============================*/


MODULE 'libraries/vector'
MODULE 'vector'
MODULE 'graphics/displayinfo'
OPT LARGE

OBJECT rworld
    flags:INT
    number:INT
    theobject:LONG
ENDOBJECT
/* ====================================================== */
/* WARNING !! WARNING !! WARNING !! WARNING !! WARNING !! */
/* ====================================================== */
/*
    There a mistake in the source code of the vector.library,
object are define like this in vector.h,but without the o_flags in ASM source.
*/

OBJECT robject
    o_point_data:LONG
    o_area_data:LONG
    o_move_table:LONG
    o_flags:INT             /* <- This flags don't appear in ASM include,but it is present in C include.   */
    o_pos_x:INT             /* i suppose that's the C include is good because all ASM examples crash my */
    o_pos_y:INT             /* machine !!*/
    o_pos_z:INT
    o_rot_x:INT
    o_rot_y:INT
    o_rot_z:INT
ENDOBJECT
/* =================================== */
/* ALL OBJECTS ARE CONVERT WITH 3DView */
/* =================================== */
DEF myvscreen:PTR TO newvscreen
DEF myjoy:PTR TO joy
/*"All Object definitions"*/
/*============================*/
DEF pcone_obj:PTR TO robject
DEF pcone_move:PTR TO INT
DEF pcone_world:PTR TO rworld
/*===========================*/
DEF pcube_obj:PTR TO robject
DEF pcube_move:PTR TO INT
DEF pcube_world:PTR TO rworld
/*===========================*/
DEF pcylinder_obj:PTR TO robject
DEF pcylinder_move:PTR TO INT
DEF pcylinder_world:PTR TO rworld
/*==============================*/
DEF phsphere_obj:PTR TO robject
DEF phsphere_move:PTR TO INT
DEF phsphere_world:PTR TO rworld
/*==============================*/
DEF ppyramid_obj:PTR TO robject
DEF ppyramid_move:PTR TO INT
DEF ppyramid_world:PTR TO rworld
/*===============================*/
DEF psphere1_obj:PTR TO robject
DEF psphere1_move:PTR TO INT
DEF psphere1_world:PTR TO rworld
/*================================*/
DEF psphere2_obj:PTR TO robject
DEF psphere2_move:PTR TO INT
DEF psphere2_world:PTR TO rworld
/*=============================*/
DEF psphere3_obj:PTR TO robject
DEF psphere3_move:PTR TO INT
DEF psphere3_world:PTR TO rworld
/*================================*/
DEF ptetra_obj:PTR TO robject
DEF ptetra_move:PTR TO INT
DEF ptetra_world:PTR TO rworld
/*=================================*/
DEF ptorus_obj:PTR TO robject
DEF ptorus_move:PTR TO INT
DEF ptorus_world:PTR TO rworld
/*===================================*/
DEF pwheel_obj:PTR TO robject
DEF pwheel_move:PTR TO INT
DEF pwheel_world:PTR TO rworld
/*===================================*/
DEF vector_obj:PTR TO robject
DEF vector_move:PTR TO INT
DEF vector_world:PTR TO rworld
/**/
DEF mycoltab:PTR TO INT
DEF myworld:PTR TO rworld
DEF viewstruct
/*"p_InitData() :initilise les datas."*/
PROC p_InitData()
    myvscreen:=[0,0,     /* Linke obere Ecke des Screen */
               640,512, /* Breite und Höhe */
               3,       /* Tiefe */
               0,0,     /* Screentitel- und -randfarben */
               HIRESLACE_KEY,       /* Screenmode */
               NIL,    /* Zeiger auf Font des Screens; hier Standard-Font */
               'vector.library  ©1991 by A.Lippert',
               0,       /* Flags (bisher ungenutzt) */
               0,0,     /* Offset des Vektorfensters im Screen (bisher nicht unterstützt) */
              640,512, /* Breite und Höhe des Vektorfensters (muß bisher identisch sein mit Breite und Höhe des Screens) */
              3]:newvscreen       /* von Vektoranimation wirklich genutzte Bitplanes */

myjoy:=[50,50000,-50000,3,3,3]:INT


pcone_move:=[360,0,0,0,1,0,0,
             360,0,0,0,1,1,1,
             END_1]:INT

pcylinder_move:=[360,0,0,0,1,1,0,
                 100,10,0,0,0,0,1,
                 END_1]:INT

pwheel_move:=[180,-10,0,0,0,0,1,
              END_1]:INT

phsphere_move:=[360,0,0,42,0,1,0,
                360,0,0,5,0,2,0,
                END_1]:INT

psphere1_move:=[400,0,0,-100,1,1,1,
                450,10,0,0,1,1,1,
                100,-100,0,0,1,0,0,
               END_1]:INT

psphere2_move:=[100,-10,0,0,1,0,0,
                100,0,10,0,1,1,1,
                END_1]:INT

ppyramid_move:=[360,0,0,0,1,1,1,
                360,0,0,-50,1,1,1,
                END_1]:INT

ptetra_move:=[360,0,0,0,1,1,1,
              360,0,0,-50,1,1,1,
              100,0,-50,0,1,0,1,
              END_1]:INT

ptorus_move:=[200,0,5,0,0,0,0,
              10,0,0,0,0,0,0,
              360,0,0,0,1,1,1,
              90,0,0,0,1,0,0,
              90,0,0,0,0,1,0,
              90,0,0,0,0,0,1,
              200,0,0,-70,0,0,0,
              90,0,0,0,0,1,0,
              200,0,0,-80,0,0,0,
              100,-10,0,0,1,0,0,
              END_1]:INT

vector_move:=[100,10,0,0,0,0,0,
             360,0,0,-10,1,0,0,
             50,0,0,0,0,0,0,
             200,10,0,0,1,1,1,
             END_1]:INT

pcone_obj:=[{pcone_pts},{pcone_fcs},pcone_move,0,
           0,0,-2000,
           90,0,0]:robject

pcylinder_obj:=[{pcylinder_pts},{pcylinder_fcs},pcylinder_move,0,
           0,0,-1250,
           90,0,0]:robject

pwheel_obj:=[{pwheel_pts},{pwheel_fcs},pwheel_move,0,
           1000,0,-1250,
           90,0,0]:robject

phsphere_obj:=[{phsphere_pts},{phsphere_fcs},phsphere_move,0,
           0,0,-15500,
           90,0,0]:robject

psphere1_obj:=[{psphere1_pts},{psphere1_fcs},psphere1_move,0,
           0,0,380,
           90,0,0]:robject

psphere2_obj:=[{psphere2_pts},{psphere2_fcs},psphere2_move,0,
           1000,0,-1810,
           0,0,0]:robject

ppyramid_obj:=[{ppyramid_pts},{ppyramid_fcs},ppyramid_move,0,
           0,0,-500,
           0,0,0]:robject

ptetra_obj:=[{ptetra_pts},{ptetra_fcs},ptetra_move,0,
           0,0,-1800,
           0,90,0]:robject

ptorus_obj:=[{ptorus_pts},{ptorus_fcs},ptorus_move,0,
           0,-1000,-1800,
           0,0,0]:robject

vector_obj:=[{vector_pts},{vector_fcs},vector_move,0,
             -1000,0,-1000,
             0,0,0]:robject

mycoltab:=[0,  0, 0, 0,   /* Register, Rot,Grün,Blau */
           1, 0,12,12,
           2, 0,11,11,
           3, 0,10,10,
           4,  0, 9, 9,
           5,  0, 8, 8,
           6,  0, 7, 7,
           7,  15, 6, 6,
          -1]:INT

pcone_world:=[1,1,pcone_obj]:rworld
pcylinder_world:=[1,1,pcylinder_obj]:rworld
pwheel_world:=[1,1,pwheel_obj]:rworld
phsphere_world:=[1,1,phsphere_obj]:rworld
psphere1_world:=[1,1,psphere1_obj]:rworld
psphere2_world:=[1,1,psphere2_obj]:rworld
ppyramid_world:=[1,1,ppyramid_obj]:rworld
ptetra_world:=[1,1,ptetra_obj]:rworld
ptorus_world:=[1,1,ptorus_obj]:rworld
vector_world:=[1,1,vector_obj]:rworld
ENDPROC
/**/
/*"main()"*/
PROC main()
    DEF b
    p_InitData()
    IF vecbase:=OpenLibrary('vector.library',1)
        WriteF('Vector.library open.\n')
        IF viewstruct:=OpenVScreen(myvscreen)
            WriteF('viewstruct ok\n')
            SetColors(viewstruct,mycoltab)
            AutoScaleOn(myvscreen.viewmodes)
            DoAnim(vector_world)
            DoAnim(pcone_world)
            DoAnim(pcylinder_world)
            DoAnim(pwheel_world)
            DoAnim(phsphere_world)
            DoAnim(psphere1_world)
            DoAnim(psphere2_world)
            DoAnim(ppyramid_world)
            p_SameCoord(ptetra_obj,ppyramid_obj)
            DoAnim(ptetra_world)
            DoAnim(ptorus_world)
            vector_obj.o_pos_x:=-1000
            vector_obj.o_pos_y:=0
            vector_obj.o_pos_z:=-1000
            vector_obj.o_rot_x:=0
            vector_obj.o_rot_y:=0
            vector_obj.o_rot_z:=0
            DoAnim(vector_world)
        ELSE
            WriteF('Screen failed !\n')
        ENDIF
        IF viewstruct THEN CloseVScreen()
    ELSE
        WriteF('vector.library ?\n')
    ENDIF
    IF vecbase THEN CloseLibrary(vecbase)
ENDPROC
/**/
/*"p_SameCoord(dest:PTR TO robject,source:PTR TO robject)"*/
PROC p_SameCoord(dest:PTR TO robject,source:PTR TO robject)
    dest.o_pos_x:=source.o_pos_x
    dest.o_pos_y:=source.o_pos_y
    dest.o_pos_z:=source.o_pos_z
ENDPROC
/**/
/*"p_WriteFCoord(source:PTR TO robject)"*/
PROC p_WriteFCoord(source:PTR TO robject)
    DEF rx,ry,rz
    DEF ox,oy,oz
    IF source.o_pos_x>32768 THEN rx:=source.o_pos_x-65536 ELSE rx:=source.o_pos_x
    IF source.o_rot_x>32768 THEN ox:=source.o_rot_x-65536 ELSE ox:=source.o_rot_x
    IF source.o_pos_y>32768 THEN ry:=source.o_pos_y-65536 ELSE ry:=source.o_pos_y
    IF source.o_rot_y>32768 THEN oy:=source.o_rot_y-65536 ELSE oy:=source.o_rot_y
    IF source.o_pos_z>32768 THEN rz:=source.o_pos_z-65536 ELSE rz:=source.o_pos_z
    IF source.o_rot_z>32768 THEN oz:=source.o_rot_z-65536 ELSE oz:=source.o_rot_z
    WriteF('PosX :\d\n',rx)
    WriteF('PosY :\d\n',ry)
    WriteF('PosZ :\d\n',rz)
    WriteF('=====\n')
    WriteF('RotX :\d\n',ox)
    WriteF('RotY :\d\n',source.o_rot_y)
    WriteF('RotZ :\d\n',source.o_rot_z)
ENDPROC
/**/


/*"vbi()"*/
PROC vbi()
    IF CtrlC()
        RotateX(0,0,0,0,0,0,10)
    ENDIF
ENDPROC
/**/
/*"Include Binaires"*/
pcone_pts:       INCBIN 'Pcone_pts.bin'
pcone_fcs:       INCBIN 'PCone_fcs.bin'
pcube_pts:       INCBIN 'PCube_pts.bin'
pcube_fcs:       INCBIN 'Pcube_fcs.bin'
pcylinder_pts:   INCBIN 'PCylinder_pts.bin'
pcylinder_fcs:   INCBIN 'PCylinder_fcs.bin'
phsphere_pts:    INCBIN 'PHsphere_pts.bin'
phsphere_fcs:    INCBIN 'PHSphere_fcs.bin'
ppyramid_pts:    INCBIN 'PPyramid_pts.bin'
ppyramid_fcs:    INCBIN 'PPyramid_fcs.bin'
psphere1_pts:    INCBIN 'PSphere1_pts.bin'
psphere1_fcs:    INCBIN 'PSphere1_fcs.bin'
psphere2_pts:    INCBIN 'PSphere2_pts.bin'
psphere2_fcs:    INCBIN 'PSphere2_fcs.bin'
psphere3_pts:    INCBIN 'PSphere3_pts.bin'
psphere3_fcs:    INCBIN 'PSphere3_fcs.bin'
ptetra_pts:      INCBIN 'PTetra_pts.bin'
ptetra_fcs:      INCBIN 'PTetra_fcs.bin'
ptorus_pts:      INCBIN 'PTorus_pts.bin'
ptorus_fcs:      INCBIN 'PTorus_fcs.bin'
pwheel_pts:      INCBIN 'PWheel_pts.bin'
pwheel_fcs:      INCBIN 'PWheel_fcs.bin'
vector_pts:      INCBIN 'Vector_pts.bin'
vector_fcs:      INCBIN 'Vector_fcs.bin'
/**/
