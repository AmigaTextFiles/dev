$@ # ifndef yy@
$@ # define yy@

/* $Id: Scanner.h,v 2.6 1992/08/07 15:29:41 grosch rel $ */

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

$@ extern	void		$_BeginScanner	(void);
$@ extern	void		$_BeginFile	(char * yyFileName);
$@ extern	int		$_GetToken	(void);
$@ extern	int		$_GetWord	(char * yyWord);
$@ extern	int		$_GetLower	(char * yyWord);
$@ extern	int		$_GetUpper	(char * yyWord);
$@ extern	void		$_CloseFile	(void);
$@ extern	void		$_CloseScanner	(void);

# endif
