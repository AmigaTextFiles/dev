   IFND EXEC_TYPE_I
   include "exec/types.i"
   ENDC
******************************
* Include Asm de 3Dview v0.g *
******************************
*****************************
* ID IMAGINE		    *
*****************************
ID_FORM   equ $464F524D
ID_TDDD   equ $54444444
ID_NAME   equ $4E414D45
ID_PNTS   equ $504E5453
ID_EDGE   equ $45444745
ID_FACE   equ $46414345
*******************************
* ID SCULPT		      *
*******************************
ID_SC3D   equ  $53433344
ID_VERT   equ  $56455254
********************************
* ID 3D2		       *
********************************
ID_3D2	 equ  $3D02
ID_3D3D  equ  $3D3D
*********************************
* ID_VERTEX			*
*********************************
ID_VR3D   equ $56523344
ID_VE3D   equ $56453344
********************************
* ID 3Dpro		       *
********************************
ID_3DPRO  equ $43533344
*********************************
* ID LightWave			*
*********************************
ID_LWOB   equ $4C574F42
ID_POLS   equ $504F4C53
*********************************
* VUE				*
*********************************
PLAN_XOY   equ 0
PLAN_YOZ   equ 1
PLAN_XOZ   equ 2
*********************************
* AXE DE LA BASE		*
*********************************
AXE_X	equ  0
AXE_Y	equ  1
AXE_Z	equ  2
**********************************
* TYPE D'OBJET                   *
**********************************
TYPE_IMAGINE   equ  0
TYPE_OLDCYBER  equ  1
TYPE_NEWCYBER  equ  2
TYPE_SCULPT    equ  3
TYPE_OLDVERTEX equ  4
TYPE_NEWVERTEX equ  5
TYPE_3DPRO     equ  6
TYPE_LIGHTWAVE equ  7
**********************************
* ARGUMENT TYPE D'ECRAN          *
**********************************
ID_BR	equ   $42522020
ID_BRE	equ   $42524520
ID_HR	equ   $48522020
ID_HRE	equ   $48524520
ID_SHR	equ   $53485220
ID_SHRE equ   $53485245
**********************************
* Structure de la base		 *
**********************************
   STRUCTURE DataBase3d,0
      ULONG nbrsobjs
      ULONG totalpts
      ULONG totalfaces
      ULONG firstobj
      LABEL DataBase3d_SIZE
**********************************
* Structure d'un objet           *
**********************************
   STRUCTURE Object3d,0
      ULONG num
      ULONG nbrspts
      ULONG nbrsfaces
      ULONG datapts
      ULONG datafaces
      ULONG typeobj
      ULONG objcx
      ULONG objcy
      ULONG objcz
      ULONG objminx
      ULONG objmaxx
      ULONG objminy
      ULONG objmaxy
      ULONG objminz
      ULONG objmaxz
      ULONG selected
      ULONG bounded
      LABEL Object3d_SIZE
****************************
* Structure d'un point     *
****************************
   STRUCTURE Vertices,0
      ULONG x
      ULONG y
      ULONG z
      LABEL Vertices_SIZE
****************************
* Structure d'une face     *
****************************
   STRUCTURE Faces,0
      ULONG v1
      ULONG v2
      ULONG v3
      LABEL Faces_SIZE


