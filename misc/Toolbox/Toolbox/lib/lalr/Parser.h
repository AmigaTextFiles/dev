$@ # ifndef yy@
$@ # define yy@

/* $Id: Parser.h,v 2.1 1992/08/07 15:28:42 grosch rel $ */

$E	/* EXPORT section is inserted here */

# ifdef yacc_interface
$@ # define @			yyparse
# define yyInitStackSize	YYMAXDEPTH
# endif

$@ extern	char *	@_TokenName [];

$@ extern	int	@	();
$@ extern	void	Close@	();

# endif
