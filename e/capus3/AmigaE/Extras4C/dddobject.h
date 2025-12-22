ShowModule v1.10 (c) 1992 $#%!
now showing: "dddobject.m"
NOTE: don't use this output in your code, use the module instead.

(----) struct fc {
(   0)   v1:LONG
(   4)   v2:LONG
(   8)   v3:LONG
(----) }     /* SIZEOF=12 */

(----) struct vertice {
(   0)   x:LONG
(   4)   y:LONG
(   8)   z:LONG
(----) }     /* SIZEOF=12 */

(----) struct object3d {
(   0)   obj_node:ln (or ARRAY OF ln)
(  14)   nbrspts:LONG
(  18)   nbrsfcs:LONG
(  22)   datapts:LONG
(  26)   datafcs:LONG
(  30)   typeobj:LONG
(  34)   objcx:LONG
(  38)   objcy:LONG
(  42)   objcz:LONG
(  46)   objminx:LONG
(  50)   objmaxx:LONG
(  54)   objminy:LONG
(  58)   objmaxy:LONG
(  62)   objminz:LONG
(  66)   objmaxz:LONG
(  70)   selected:LONG
(  74)   bounded:LONG
(----) }     /* SIZEOF=78 */

(----) struct base3d {
(   0)   nbrsobjs:LONG
(   4)   totalpts:LONG
(   8)   totalfcs:LONG
(  12)   objlist:LONG
(  16)   fctoldcyber:LONG
(  20)   fctnewcyber:LONG
(  24)   fct3dpro:LONG
(  28)   fctsculpt:LONG
(  32)   fctimagine:LONG
(  36)   fctvertex:LONG
(  40)   vectorfactor:LONG
(  44)   minx:LONG
(  48)   maxx:LONG
(  52)   miny:LONG
(  56)   maxy:LONG
(  60)   minz:LONG
(  64)   maxz:LONG
(  68)   echelle:LONG
(  72)   plan:LONG
(  76)   basecx:LONG
(  80)   basecy:LONG
(  84)   basecz:LONG
(  88)   signex:LONG
(  92)   signey:LONG
(  96)   signez:LONG
( 100)   format:LONG
( 104)   centrex:LONG
( 108)   centrey:LONG
( 112)   draw_x:LONG
( 116)   draw_y:LONG
( 120)   draw_w:LONG
( 124)   draw_h:LONG
( 128)   stopcode:LONG
( 132)   anglerotation:LONG
( 136)   palette:LONG
( 140)   rgbpts:INT
( 142)   rgbnormal:INT
( 144)   rgbselect:INT
( 146)   rgbbounding:INT
( 148)   drawmode:LONG
( 152)   saveformat:INT
( 154)   savewhat:INT
( 156)   freedata:LONG
( 160)   formatname:PTR TO LONG
(----) }     /* SIZEOF=164 */

#define ERR3D_NODIR 4
#define FV_DOUBLE 2
#define FV_DIRECT 1
#define FV_INDIRECT 0
#define ERR3D_WRONGPRIMTYPE 7
#define PRIM_DOME 18
#define PRIM_PLAN 11
#define SAVE_DXF 0
#define ID_VR3D 0x56523344
#define SAVE_POV1 4
#define ERR3D_MEM 0
#define SAVE_POV2 5
#define ID_3DDD 0x33444444
#define PRIMD_OCTATRONQUE 24
#define PRIM_CYLINDRE 16
#define VECTOR_LIB 0
#define PRIM_MOEBIUS 10
#define ERR3D_OPEN 8
#define PRIMD_ICOSA 23
#define TYPE_VERTEX2 8
#define ID_EDGE 0x45444745
#define TYPE_3DPRO 6
#define ID_3DPRO 0x43533344
#define ERR3D_CONVVECTOR 5
#define TYPE_SCULPT 3
#define SAVE_GEO 1
#define SAVEOBJ_ALL 0
#define PRIM_CONED 17
#define ID_POLS 0x504F4C53
#define ID_VE3D 0x56453344
#define TYPE_NEWVERTEX 5
#define TYPE_OLDVERTEX 4
#define TYPE_NEWCYBER 2
#define TYPE_OLDCYBER 1
#define DRAW_PTS 0
#define AXE_X 0
#define SAVE_RAY 2
#define AXE_Y 1
#define AXE_Z 2
#define ERR3D_NOVECTORLIB 6
#define TYPE_IMAGINE 0
#define STOP_DRAWING 1
#define ID_FORM 0x464F524D
#define PRIMD_TETRA 20
#define PRIM_TRBL 12
#define PRIMD_OCTA 21
#define PLAN_XOY 0
#define PRIM_SPHERE 13
#define PLAN_XOZ 1
#define PRIM_SPIRALE 14
#define SAVE_BIN 3
#define TYPE_UNKNOWN 26
#define TYPE_LIGHTWAVE 7
#define ID_TDDD 0x54444444
#define ERR3D_NONE -1
#define PRIM_VAGUES 15
#define DRAW_PTSFCS 2
#define VECTOR_MOD 1
#define PRIMD_CUBE 19
#define SAVEOBJ_DES 2
#define ID_SC3D 0x53433344
#define PRIMD_CUBO 25
#define ID_FACE 0x46414345
#define PRIMD_DODECA 22
#define PLAN_YOZ 2
#define ID_VERT 0x56455254
#define ID_3D2 0x3D02
#define SAVEOBJ_SEL 1
#define PRIM_TORUS 9
#define ERR3D_UNKNOWNFILE 3
#define ERR3D_NOFILE 2
#define ID_3D3D 0x3D3D
#define ERR3D_MATHLIB 1
#define ID_SIZE 0x53495A45
#define ID_PNTS 0x504E5453
#define DRAW_FCS 1
#define ID_NAME 0x4E414D45
#define ID_LWOB 0x4C574F42

