/* ANSI and traditional C compatibility macros

   ANSI C is assumed if __STDC__ is #defined.

	Macros
		PTR		- Generic pointer type
		LONG_DOUBLE	- `long double' type
		CONST		- `const' keyword
		VOLATILE	- `volatile' keyword
		SIGNED		- `signed' keyword
		PTRCONST	- Generic const pointer (void *const)

	EXFUN(name, prototype)		- declare external function NAME
					  with prototype PROTOTYPE
	DEFUN(name, arglist, args)	- define function NAME with
					  args ARGLIST of types in ARGS
	DEFUN_VOID(name)		- define function NAME with no args
	AND				- argument separator for ARGS
	NOARGS				- null arglist
	DOTS				- `...' in args

*/

#ifndef	_ANSIDECL_H
#define	_ANSIDECL_H	1


#ifdef	__STDC__



#define	PTR		void *
#define	PTRCONST	void *CONST
#define	LONG_DOUBLE	long double

#define	AND		,
#define	NOARGS		void
#define	CONST		const
#define	VOLATILE	volatile
#define	SIGNED		signed
#define	DOTS		, ...

#define	EXFUN(name, proto)		name proto
#define	DEFUN(name, arglist, args)	name(args)
#define	DEFUN_(name, arglist, args)	name(args)
#define	DEFUN_VOID(name)		name(NOARGS)
#define TYPE_FUN(name,args)		(* name) args



#else	/* not __STDC__  */



#define	PTR		char *
#define	PTRCONST	PTR
#define	LONG_DOUBLE	double

#define	AND		;
#define	NOARGS
#define	CONST
#define	VOLATILE
#define	SIGNED
#define	DOTS

#define	EXFUN(name, proto)		name()
#define	DEFUN(name, arglist, args)	name arglist args;
#define	DEFUN_(name, arglist, args)	name arglist args
#define	DEFUN_VOID(name)		name()
#define TYPE_FUN(name,args)             (* name)()


#endif	/* __STDC__  */



#endif	/* ansidecl.h	*/
