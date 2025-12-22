#ifndef	TDDD_H
#define	TDDD_H

#if defined(__HAVE_68881__) || defined(__MC68040__) || defined(__MC68060__)
#define	__HAVE_FPU__
#endif

#include "../libTDDD/IFF.h"

/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/*
 some rules:

 object chunk-priorities:
  FORM....TDDD
   OBJ 
    DESC
     NAME
     SHP2
     POSI
     AXIS
     SIZE
     BBOX
     PNTS
     EDGE
     EFLG
     FACE
     FGR?
     COLR
     REFL
     TRAN
     SPC1
     BRS?
     CLST
     RLST
     TLST
     PRP2
     TOBJ

 attribute chunk-priorities:

  FORM....TDDD
   OBJ 
    DESC
      NAME
      SHAP ... SHP2
      POSI
      AXIS
      SIZE
      BBOX
      COLR
     (REFL)
      TRAN
      SPC1
     (BRS1 ... BRS5 | TXT1 ... TXT4) ...
      PRP1 ... PRP2
      TOBJ
 */

/* TDDD-identifier */
#define ID_TDDD MKID('T','D','D','D')

/* main-chunks of TDDD */
#define ID_OBJ  MKID('O','B','J',' ')

/* sub-chunks of OBJ */
#define ID_DESC MKID('D','E','S','C')
#define ID_TOBJ MKID('T','O','B','J')

/* sub-sub-chunks of DESC */
#define ID_SHAP MKID('S','H','A','P')
#define ID_SHP2 MKID('S','H','P','2')
#define ID_POSI MKID('P','O','S','I')
#define ID_AXIS MKID('A','X','I','S')
#define ID_SIZE MKID('S','I','Z','E')
#define ID_PNTS MKID('P','N','T','S')
#define ID_PNT2 MKID('P','N','T','2')
#define ID_EDGE MKID('E','D','G','E')
#define ID_EDG2 MKID('E','D','G','2')
#define ID_FACE MKID('F','A','C','E')
#define ID_FAC  MKID('F','A','C','\0')
#define ID_BBOX MKID('B','B','O','X')

#define ID_NAME MKID('N','A','M','E')
#define ID_COLR MKID('C','O','L','R')
#define ID_REFL MKID('R','E','F','L')
#define ID_TRAN MKID('T','R','A','N')
#define ID_SPC1 MKID('S','P','C','1')
#define ID_SPC2 MKID('S','P','C','2')
#define ID_INT1 MKID('I','N','T','1')
#define ID_CLST MKID('C','L','S','T')
#define ID_CLS2 MKID('C','L','S','2')
#define ID_RLST MKID('R','L','S','T')
#define ID_RLS2 MKID('R','L','S','2')
#define ID_TLST MKID('T','L','S','T')
#define ID_TLS2 MKID('T','L','S','2')
#define ID_EFLG MKID('E','F','L','G')
#define ID_EFL2 MKID('E','F','L','2')
#define ID_PRP1 MKID('P','R','P','1')
#define ID_PRP2 MKID('P','R','P','2')
#define ID_FOGL MKID('F','O','G','L')
#define ID_FOG2 MKID('F','O','G','2')
#define ID_FOG3 MKID('F','O','G','3')
#define ID_BLB2 MKID('B','L','B','2')
#define ID_PART MKID('P','A','R','T')
#define ID_PAR2 MKID('P','A','R','2')
#define ID_PTFN MKID('P','T','F','N')
#define ID_FGRP MKID('F','G','R','P')
#define ID_FGR2 MKID('F','G','R','2')
#define ID_FGR3 MKID('F','G','R','3')
#define ID_FGR4 MKID('F','G','R','4')
#define ID_BBSG MKID('B','B','S','G')
#define ID_SBSG MKID('S','B','S','G')
#define ID_TXT1 MKID('T','X','T','1')
#define ID_TXT2 MKID('T','X','T','2')
#define ID_TXT3 MKID('T','X','T','3')
#define ID_TXT4 MKID('T','X','T','4')
#define ID_BRS1 MKID('B','R','S','1')
#define ID_BRS2 MKID('B','R','S','2')
#define ID_BRS3 MKID('B','R','S','3')
#define ID_BRS4 MKID('B','R','S','4')
#define ID_BRS5 MKID('B','R','S','5')

#define ID_DTOO MKID('D','T','O','O')
#define ID_PTHD MKID('P','T','H','D')
#define ID_PTH2 MKID('P','T','H','2')
#define ID_PTH3 MKID('P','T','H','3')
#define ID_FORD MKID('F','O','R','D')
#define ID_FOR2 MKID('F','O','R','2')
#define ID_FOR3 MKID('F','O','R','3')
#define ID_ANID MKID('A','N','I','D')

#define ID_STND MKID('S','T','N','D')
#define ID_STID MKID('S','T','I','D')
#define ID_STDT MKID('S','T','D','T')

/*
 * datatypes
 */
#ifdef	FRACTisFLOAT
typedef float fract;
#else
typedef signed int fract;
#endif

typedef struct {
  fract x;
  fract y;
  fract z;
} vector;

typedef struct {
  vector a;
  vector b;
  vector c;
} matrix;

typedef struct {
  vector pos;
  vector xaxis;
  vector yaxis;
  vector zaxis;
  vector size;
} tform;

/*
 * structures
 */

/* defines for SHAP/SHP2 shape */
#define SH_SPHERE	0
#define SH_STENCI	1
#define SH_AXIS		2
#define SH_FACETS	3
#define SH_SURFAC	4
#define SH_GROUND	5

/* defines for SHAP lamp */
#define LP_TYPE		0x0003	/* 0b000011 */
#define LP_NOLAMP	0
#define LP_SUN		1
#define LP_FALL		2
#define LP_SHADOW	0x0004	/* 0b000100 */
#define LP_SHDWOF	0
#define LP_SHDWON	4
#define LP_FORM		0x0018	/* 0b011000 */
#define LP_SPHERE	0
#define LP_CYLIND	8
#define LP_CONICA	16

/* defines for SHP2 lamp */
#define LP2_TYPE	0x0003	/* 0b00000000000000011 */
#define LP2_NOLAM	0
#define LP2_POINT	1
#define LP2_PARAL	2
#define LP2_SHAPE	0x000C	/* 0b00000000000001100 */
#define LP2_NOSHP	0
#define LP2_ROUND	8
#define LP2_RECTE	12
#define LP2_LENSF	0x0010	/* 0b00000000000010000 */
#define LP2_NORMA	0
#define LP2_NOLEN	16
#define LP2_FALLO	0x0060	/* 0b00000000001100000 */
#define LP2_NOFAL	0
#define LP2_1RFAL	32
#define LP2_CONTR	64
#define LP2_1R2FA	96
#define LP2_SHADO	0x0080	/* 0b00000000010000000 */
#define LP2_SHDOF	0
#define LP2_SHDON	128
#define LP2_SOFTS	0x0100	/* 0b00000000100000000 */
#define LP2_SSOFF	0
#define LP2_SSON	256
#define LP2_BRIGH	0x4000	/* 0b01000000000000000 */
#define LP2_BROFF	0
#define LP2_BRON	32768

struct shap {
  unsigned short int shape, lamp;
};

struct posi {
  vector position;
};

struct axis {
  vector xaxis, yaxis, zaxis;
};

struct size {
  vector size;
};

struct points {
  short int pcount;
  vector points[0];
};

struct edges {
  short int ecount;
  short int edges[0][2];
};

struct faces {
  short int tcount;
  short int connects[0][3];
};

struct bbox {
  vector mins, maxs;
};

struct name {
  char name[18];
};

struct colr {
  unsigned int color;
};

struct refl {
  unsigned int reflection;
};

struct tran {
  unsigned int transparency;
};

struct spc1 {
  unsigned int specular;
  /*char pad; */
  /*struct rgb color; */
};

struct spc2 {
  unsigned char pad;
  struct rgb color;
  fract overdrive;
};

struct int1 {
  vector intensity;
};

struct faceattr {
  short int count;
  struct rgb attr[0];
};

#define EDG_FLAGS	0xC0	/* 0b011000000 */
#define EDG_QUICK	0x40	/* 0b001000000 */
#define EDG_SHARP	0x80	/* 0b010000000 */

struct edgeflags {
  short int count;
  char flags[0];
};

struct props {
  unsigned char dither, hard, rough, shiny, index, quick, phong, genlock;
};

struct props2 {
  unsigned char bright, hard, rough, shiny, index, quick, phong, genlock;
};

struct fog {
  fract length;
};

#define FG_TYPE		0x0003	/* 0b00000000000000011 */
#define FG_NOFALL	0
#define FG_RAFALL	1
#define FG_AXFALL	2
#define FG_PLFALL	3
#define FG_AXIS		0x000C	/* 0b00000000000001100 */
#define FG_XAXIS	0
#define FG_YAXIS	4
#define FG_ZAXIS	8
#define FG_HOTC		0x0080	/* 0b00000000010000000 */
#define FG_HOTOFF	0
#define FG_HOTON	128

struct fog2 {
  fract length, falloff, hot;
  unsigned short int type;
};

struct fog3 {
  fract length, falloff, hot, overdrive;
  unsigned short int type;
};

struct blob {
  fract strength, threshold;
  unsigned short int meshdensity;
};

#define PRT_TYPE	0x000F	/* 0b00000000000001111 */
#define PRT_NOPRT	0
#define PRT_TETRA	1
#define PRT_PYRAM	2
#define PRT_OCTAH	3
#define PRT_CUBES	4
#define PRT_BLOCK	5
#define PRT_DODEC	6
#define PRT_SPHER	7
#define PRT_CENT	0x00F0	/* 0b00000000011110000 */
#define PRT_INSCR	0
#define PRT_CIRCU	16
#define PRT_INTER	32
#define PRT_BARYC	48
#define PRT_SIZE	0x0F00	/* 0b00000111100000000 */
#define PRT_SMALL	0
#define PRT_LARGE	256
#define PRT_RANDO	512
#define PRT_SPECI	768
#define PRT_ALIGN	0xF000	/* 0b01111000000000000 */
#define PRT_0
#define PRT_4096
#define PRT_8192

struct particle {
  unsigned short int type;
  fract size;
};

struct particle2 {
  unsigned int type;
  fract part;
};

struct particlename {
  char count;
  char name[0];
};

struct facesubgroup {
  short int count;
  char name[18];
  short int facelist[0];
};

struct facesubgroup2 {
  unsigned short int ptype;
  fract psize;
  char count;
  char filename[0];
};

struct facesubgroup3 {
  unsigned int ptype;
  fract psize;
  char count;
  char filename[0];
};

struct subgroup {
  char subgroup[18];
};

#define TXT_FLAGS	0x0007	/* 0b00000000000000111 */
#define TXT_CHILD	0
#define TXT_LIGHT	1
#define TXT_DISAB	2
#define TPT_FLAGS	0x003F	/* 0b00000000000111111 */
#define TPT_RED		0
#define TPT_GREEN	1
#define TPT_BLUE	2
#define TPT_SCALE	3
#define TPT_UNUSE	4
#define TPT_LUNUS	5

struct texture {
  unsigned short int flags;
  tform tform;
  fract params[16];
  char pflags[16];
  char length;
  char name[0];
};

struct texture2 {
  unsigned short int flags;
  tform tform;
  fract params[16];
  char pflags[16];
  char subgrp[18];
  char length;
  char name[0];
};

struct texture3 {
  unsigned short int flags;
  tform tform;
  fract params[16];
  char pflags[16];
  char subgrp[18];
  char stname[18];
  char length;
  char name[0];
};

struct texture4 {
  unsigned short int flags;
  tform tform;
  fract params[16];
  char pflags[16];
  char subgrp[18];
  char stname[18];
  char label[18];
  fract mixing;
  char length;
  char name[0];
};

#define BRS_FLAGS	0x0F	/* 0b000001111 */
#define BRS_COLOR	0
#define BRS_REFLE	1
#define BRS_FILTE	2
#define BRS_ALTIT	3
#define BRS_ENVRE	4
#define BRS_SPECU	5
#define BRS_HARDN	6
#define BRS_ROUGH	7
#define BRS_FOGLE	8
#define BRS_SHINI	9
#define BRS_BRIGH	10
#define BRS_INDEX	11
#define BRS_LIGHT	12
#define BRW_FLAGS	0x7F	/* 0b011111111 */
#define BRW_X		1
#define BRW_Y		2
#define	BRW_FLATZX	0
#define	BRW_CYLINDERX	1
#define	BRW_CYLINDERZ	2
#define	BRW_SPHEREZ	3
#define BRW_CHILD	4
#define BRW_REPEA	8
#define BRW_FLIP	16
#define BRW_INVER	32
#define BRW_ZEROC	64
#define BRW_DISAB	128

#if 0
struct brush {
  unsigned short int flags, wflags;
  tform tform;
  char length;
  char name[0];
};
#endif

struct brush2 {
  unsigned short int flags, wflags;
  tform tform;
  unsigned short int fullscale, maxseq;
  char length;
  char name[0];
};

struct brush3 {
  unsigned short int flags, wflags;
  tform tform;
  unsigned short int fullscale, maxseq;
  char subgrp[18];
  char length;
  char name[0];
};

struct brush4 {
  unsigned short int flags, wflags;
  tform tform;
  unsigned short int fullscale, maxseq;
  char subgrp[18];
  char stname[18];
  char length;
  char name[0];
};

struct brush5 {
  unsigned short int flags, wflags;
  tform tform;
  unsigned short int fullscale, maxseq;
  char subgrp[18];
  char stname[18];
  char label[18];
  fract mixing, foglo, foghi;
  char length;
  char name[0];
};

/*
 * tools
 */

#ifdef	FRACTisFLOAT
__inline static int fract2int(fract number) {
  return rint(number / 65536);
}
#else
__inline static int fract2int(fract number) {
  return (number >> 16);
}
#endif

#ifdef	FRACTisFLOAT
__inline static fract int2fract(int number) {
  return rint(number * 65536);
}
#else
__inline static fract int2fract(int number) {
  return (number << 16);
}
#endif

#ifndef	FRACTisFLOAT
#if defined(__STDC__) || defined(__cplusplus)
#define _DEFUN(name, args1, args2) name ( args2 )
#define _AND ,
#define _CONST const
#else
#define _DEFUN(name, args1, args2) name args1 args2;
#define _AND ;
#define _CONST
#endif

#ifdef __HAVE_FPU__
__inline static _CONST double 
_DEFUN(rintgr, (x),
    double x)
{
  __asm ("fint%.x %1,%0"
	  : "=f" (x)
	  : "0" (x));
  return x;
}
#endif

__inline static _CONST fract
_DEFUN(float2fract, (number), vec1D number)
{
#if defined(PROFILE) || !defined(__HAVE_MC68881__)
#if 0
  if (number < 0)
    return -(int)(-65536.0 * number + 0.5);
  else
    return (int)(65536.0 * number + 0.5);
#endif
#if defined(__HAVE_FPU__) && defined(_MATH_H_)
#ifdef GLOBAL_ROUND
  return (int)rintgr(scalb(number, 16));
#else
  if ((number = scalb(number, 16)) >= 0)
    return (int)(number += 0.5);
  else
    return (int)(number -= 0.5);
#endif
#else
#ifdef GLOBAL_ROUND
  return (int)rintgr(number *= 65536);
#else
  if ((number *= 65536) >= 0)
    return (int)(number += 0.5);
  else
    return (int)(number -= 0.5);
#endif
#endif
#else
  fract value;
  /* "const" should allow the compiler to eleminate the variable */
  /* "float" make the store faster */
  const register float sixteen __asm ("fp7") = 16.0;

#ifdef GLOBAL_ROUND
  __asm ("fscale%.x %2,%0"
	: "=f" (number)
	: "0" (number)
	, "f" (sixteen));
  __asm ("fint%.x %0,%0"
	: "=f" (number)
	: "0" (number));
#else
  const register float nullfive __asm ("fp6") = 0.5;
  
  __asm ("fscale%.x %2,%0
	fblt 0f
	fadd%.x %3,%0	| round highest number
	bras 1f
0:	fsub%.x %3,%0	| round lowest number
1:	"
	: "=f" (number)
	: "0" (number)
	, "f" (sixteen)
	, "f" (nullfive));
#endif
  __asm ("fmove%.l %1,%0"
	: "=d" (value)
	: "f" (number));

  return value;
#endif
}

__inline static _CONST vec1D
_DEFUN(fract2float, (number), fract number)
{
#if defined(PROFILE) || !defined(__HAVE_MC68881__)
#if defined(__HAVE_FPU__) && defined(_MATH_H_)
  return scalb((float)number, -16);
#else
  return (vec1D)number / 65536;
#endif
#else
  vec1D value;
  /* "const" should allow the compiler to eleminate the variable */
  /* "float" make the store faster */
  const register float sixteen __asm ("fp7") = 16.0;
  
  __asm ("fmove%.l %1,%0"
	: "=f" (value)
	: "d" (number));
  __asm ("fscale%.x %2,%0"
	: "=f" (value)
	: "0" (value)
	, "f" (sixteen));

  return value;
#endif
}
#endif
#endif
