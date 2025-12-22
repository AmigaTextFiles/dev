/*
	Typedefs for various models and compiler sizes, written by Mark Incley.
*/

#ifndef MITYPES
#define	MITYPES


#define	FALSE	0
#define	TRUE	1

/* Maximum length of a filename (inc. path, filename and ext.) */

#ifndef MAX_PATH
#define	MAX_PATH	64			/* Max length of filename, inc. path. */
#endif

#define	HUGE

typedef	unsigned char	BYTE;
typedef	unsigned short 	WORD;
typedef	unsigned long	DWORD;



#endif		/* __MITYPES__ */
