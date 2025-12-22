$@ # ifndef yy$
$@ # define yy$

/* $Id: Scanner.h,v 2.4 1992/08/07 15:28:42 grosch rel $ */

# if defined __STDC__ | defined __cplusplus
# define ARGS(parameters)	parameters
# else
# define ARGS(parameters)	()
# endif

# include "Positions.h"

$@ typedef struct { tPosition Position; } $_tScanAttribute;

$@ extern	$_tScanAttribute	$_Attribute;

$@ extern	int		$_GetToken	();
$@ extern	void		$_ErrorAttribute	ARGS((short yyToken, $_tScanAttribute * yyRepairAttribute));

# endif
