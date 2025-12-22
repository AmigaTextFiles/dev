#ifndef SSMISC_PROTOS_H
#define SSMISC_PROTOS_H
/********************************************************************
*      Society                   : PGES
*      Project                   : Circ
*
*      Creation author           : SS
*      Module name               : $RCSfile: SSMisc_protos.h,v $
*      Module version            : $Revision: 1.1 $
*      Current version date      : $Date: 2003/04/09 14:19:39 $
*
*      Description               : Misc Tools (TRUE/FALSE defines, ...)
*
*      Host                      : C-ANSI
*      Target                    : C-ANSI
*
*      Programmation language    : 
*      Creation date             : Thu Jan 02 14:31:13 2003
*
*      Prefixe                   : ss_
*
*      References                : fclc (usenet)
*
*         PGES proprietary and confidential information
*          Copyright (C) PGES - (All rights reserved)
*                ----------------------------------
*
*      CVS history               : 
*         $Log: SSMisc_protos.h,v $
*         Revision 1.1  2003/04/09 14:19:39  saragaglia
*         New Misc include file : defines for TRUE, MATH (PI), ...
*
*         Revision 1.1.1.1  2003/04/08 15:03:45  saragaglia
*         First insertion in CVS.
*         Contains String, Date, and I/O libs
*
*
*******************************************************************/

/*******************************************************************
 * INCLUDES
*******************************************************************/

/*******************************************************************
 * DEFINES
*******************************************************************/

#ifndef TRUE
#define TRUE (1 == 1)
#endif
#ifndef FALSE
#define FALSE (!TRUE)
#endif

#ifndef MIN
#define MIN(X, Y) (X<Y?X:Y)
#endif
#ifndef MAX
#define MAX(X, Y) (X<Y?Y:X)
#endif

/* Maths
**--------------------------------
*/
#ifndef M_PI
#define M_PI           3.14159265358979323846  /* pi */
#endif
#ifndef M_PI_2
#define M_PI_2         1.57079632679489661923  /* pi/2 */
#endif
#ifndef M_PI_4
#define M_PI_4         0.78539816339744830962  /* pi/4 */
#endif
#ifndef M_1_PI
#define M_1_PI         0.31830988618379067154  /* 1/pi */
#endif
#ifndef M_2_PI
#define M_2_PI         0.63661977236758134308  /* 2/pi */
#endif

#ifndef RAD2DEG
#define RAD2DEG(X) ((X*180.0)/M_PI)
#endif
#ifndef DEG2RAD
#define DEG2RAD(X) ((X*M_PI)/180.0)
#endif

#endif //#ifndef SSMISC_PROTOS_H
