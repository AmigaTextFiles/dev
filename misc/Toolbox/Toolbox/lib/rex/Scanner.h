$@ # ifndef yy@
$@ # define yy@

/* $Id: Scanner.h,v 2.6 1992/08/07 15:29:41 grosch rel $ */

# if defined __STDC__ | defined __cplusplus
# define ARGS(parameters)	parameters
# else
# define ARGS(parameters)	()
# endif

$E user export declarations
 
$@ # define $_EofToken	0
 
# ifdef lex_interface
$@ #    define $_GetToken	yylex
$@ #    define $_TokenLength	yyleng
# endif

$@ extern	char *		$_TokenPtr	;
$@ extern	short		$_TokenLength	;
$@ extern	$_tScanAttribute	$_Attribute	;
$@ extern	void		(* @_Exit) ()	;
 
$@ extern	void		$_BeginScanner	();
$@ extern	void		$_BeginFile	ARGS ((char * yyFileName));
$@ extern	int		$_GetToken	();
$@ extern	int		$_GetWord		ARGS ((char * yyWord));
$@ extern	int		$_GetLower	ARGS ((char * yyWord));
$@ extern	int		$_GetUpper	ARGS ((char * yyWord));
$@ extern	void		$_CloseFile	();
$@ extern	void		$_CloseScanner	();

# endif
