/*
 * C header file for class MathString.mcc
 *
 * $VER: MathString_MCC.h 1.3 (2.7.1996)
 * (C) 1996 V. Gervasi   gervasi@di.unipi.it
 *
 */

#ifndef MATHSTRING_MCC_H
#define MATHSTRING_MCC_H

#define MUI_SERIALNR_VIGI		446
#define TAGBASE_VIGI			(TAG_USER | (MUI_SERIALNR_VIGI << 16))
#define TAG_MATHSTRING			(TAGBASE_VIGI | 0x8100)	/* base */

#define MUIM_MathString_Eval		(TAG_MATHSTRING | 0x01)
#define MUIA_MathString_Units		(TAG_MATHSTRING | 0x02)
#define MUIA_MathString_Functions	(TAG_MATHSTRING | 0x03)
#define MUIA_MathString_DefaultUnit	(TAG_MATHSTRING | 0x04)
#define MUIA_MathString_ValueFormat	(TAG_MATHSTRING | 0x05)
#define MUIA_MathString_LastError	(TAG_MATHSTRING | 0x06)
#define MUIA_MathString_ValueMode	(TAG_MATHSTRING | 0x07)
#define MUIA_MathString_ValueUnit	(TAG_MATHSTRING | 0x08)
#define MUIA_MathString_Value		(TAG_MATHSTRING | 0x09)
#define MUIA_MathString_Constants	(TAG_MATHSTRING | 0x0a)
#define MUIA_MathString_Behaviour	(TAG_MATHSTRING | 0x0b)
#define MUIM_MathString_FuncEval	(TAG_MATHSTRING | 0x0d)

/* Predefined units for MUIA_MathString_Units */

#define MUIV_MathString_Units_Metric	(-1)	/* mm, cm, dm, m, dam, hm, km 		 */
#define MUIV_MathString_Units_Typo	(-2)	/* pt, c, mm, cm, in, d, c		 */
#define MUIV_MathString_Units_CS	(-3)	/* b, nib, Kb, Mb, Gb, Tb 		 */
#define MUIV_MathString_Units_Angular	(-4)	/* °, rad, deg 				 */
#define MUIV_MathString_Units_Time	(-5)	/* ns, µs, ms, s, m, h, d, week, yr, ayr */


/* Math representation of the Value for MUIA_MathString_ValueMode */

#define MUIV_MathString_ValueMode_dIEEEptr	(0)	/* pointer to double-precision IEEE */
#define MUIV_MathString_ValueMode_sIEEE		(1)	/* single-precision IEEE */
#define MUIV_MathString_ValueMode_sFFP		(2)	/* single-precision FFP  */


/* Unit to use for the Value for MUIA_MathString_ValueUnit */

#define MUIV_MathString_ValueUnit_Absolute	(-1)	/* use absolute value */
#define MUIV_MathString_ValueUnit_DefUnit	(-2)	/* use default unit   */


/* Useful shorthand */

#define MUIC_MathString		"MathString.mcc"
#define MathStringObject	MUI_NewObject(MUIC_MathString


/* Error codes for MUIA_MathString_LastError */

#define MS_OK			0	/* no error 				    */
#define MS_WRONG_NUMBER		1	/* syntax error while parsing a number      */
#define MS_WRONG_FUNNAME	2	/* wrong function name, or unknown function */
#define MS_WRONG_FUNCALL	3	/* syntax error in function call            */
#define MS_MISSING_CLOSE_PAREN	4	/* missing a ")"                            */
#define MS_SYNTAX_ERROR		5	/* general syntax error                     */
#define MS_WRONG_UNIT		6	/* wrong unit name, or unknown unit         */
#define MS_DIVIDE_BY_ZERO	7	/* division by zero                         */
#define MS_WRONG_CONSTANT	8	/* wrong constant name, or unknown constant */

/* error codes 256-4095 are available for use by custom functions
   (see MUIA_MathString_Functions); all other codes are reserved.     */

/* bit values for MUIA_MathString_Behaviour (OR the ones you need)    */

#define MSB_ONERROR_BEEP	  1	/* call DisplayBeep()		    */
#define MSB_ONERROR_ACTIVATE	  2	/* activate the gadget              */
#define MSB_ONERROR_SPOT	  4	/* place the cursor on error spot   */
#define MSB_ONEVAL_SUBST	  8	/* substitute result string	    */
#define MSB_ONACKNOWLEDGE_EVAL	 16	/* automatically evaluate           */
#define MSB_ONGETVALUE_EVAL	 32	/* automatically evaluate	    */


/* MUIA_MathString_Units wants a pointer to a NULL-terminated array of... */

struct umdef {
	ULONG id;	/* right-justified constant, eg <\0,\0,c,m> */
	double factor;	/* in double-precision IEEE format */
};

/* MUIA_MathString_Constants wants a pointer to a NULL-terminated array of... */

struct constdef {
	ULONG id;	/* right-justified constant, eg <\0,\0,\0,e> */
	double value;	/* in double-precision IEEE format */
};

/* MUIA_MathString_Functions wants a pointer to a NULL-terminated array of... */

struct fundef {
	ULONG id;	  /* right-justified constant, eg <\0,a,b,s> */
	struct Hook funh; /* see autodoc for parameters and return value */
};


/* MUIM_MathString_FuncEval gets this message... */

struct MUIP_MathString_FuncEval {
	ULONG	MethodID;		/* MUIM_MathString_FuncEval */
	ULONG	id;			/* like fundef.id */
	double	*arg;			/* in double-precision IEEE format */
	ULONG	private;		/* don't touch ! */
};

#endif

