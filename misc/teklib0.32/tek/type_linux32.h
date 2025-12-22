
#ifndef _TEK_TYPE_H
#define	_TEK_TYPE_H 1

/*
**	type.h
**	types and constants for linux/32bit
*/


#include <netinet/in.h>

/*
**	platform specific
*/

typedef char				TBYTE;
typedef signed char			TINT8;
typedef unsigned char		TUINT8;
typedef signed short		TINT16;
typedef unsigned short		TUINT16;
typedef signed int			TINT;
typedef unsigned int		TUINT;
typedef float				TFLOAT;
typedef	double				TDOUBLE;

#define	TALIGN_MINOR		3
#define TALIGN_DEFAULT		7
#define TALIGN_MAJOR		15

#define __ELATE_QCALL__(x)

#ifdef TDEBUG
	#include <stdio.h>
	#define platform_dbprintf(a)		fprintf(stderr,a)
	#define platform_dbprintf1(a,b)		fprintf(stderr,a,b)
	#define platform_dbprintf2(a,b,c)	fprintf(stderr,a,b,c)
#endif


/*
**	not platform specific
*/

typedef void				TVOID;
typedef void *				TAPTR;
typedef TBYTE *				TSTRPTR;
typedef TUINT				TBOOL;
typedef struct
{TBYTE data[16];}			TKNOB;

typedef struct				/* time/datestamp */
{
	TUINT sec;				/* seconds */
	TUINT usec;				/* microseconds */
}	TTIME;



#define TNULL				0
#define TTRUE				1
#define TFALSE				0
#define TABS(a)				((a)>0?(a):-(a))
#define TMIN(a,b)			((a)<(b)?(a):(b))
#define TMAX(a,b)			((a)>(b)?(a):(b))
#define TCLAMP(min,x,max)	((x)>(max)?(max):((x)<(min)?(min):(x)))
#define TPI					3.14159265358979323846


#ifdef __cplusplus
	#define TBEGIN_C_API extern "C" {
	#define TEND_C_API }
#else
	#define TBEGIN_C_API
	#define TEND_C_API
#endif


#endif
