/* Bump.h ©1999 Robin Cloutman. All Rights Reserved. */

/** User changeable... *****************************************************/

/* Prefix to use for code */
#define	PREFIX		"bump-"

/* Variable which can hold path to code */
#define	VARNAME		"BUMPCODE"

/* Default path of code without VARNAME */
#define	DEFPATH		"S:"

/* Buffer size, used for various things. */
#define	MAX_BUFFER	256

/** Private... *************************************************************/

/* Template... */
#define	TEMPLATE "NAME/A,"				\
						"CODE/M,"				\
						"VERSION/S,"			\
						"SETVERSION/K/N,"		\
						"NO=NOREVISION/S,"	\
						"SETREVISION/K/N,"	\
						"QUIET/S"

enum {
						ARGS_name,
						ARGS_code,
						ARGS_version,
						ARGS_setversion,
						ARGS_norevision,
						ARGS_setrevision,
						ARGS_quiet,
						ARGS_count
};

/* Macros... */
#define	LOWER(c)	((c)>='A'&&(c)<='Z'?(c)+'a'-'A':(c))

/* Prototypes... */
int	main		( void );
char	*strcat	( unsigned long start, char *str, const char *append );
char	*strcat2	( char *str, const char *append );
long	strcmp	( const char *a, const char *b );
void	bust_me	( BPTR file, const char *from, char *name, int ver, int rev, struct Library *DOSBase );

