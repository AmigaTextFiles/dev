OPT MODULE
OPT EXPORT


->*****
->** Object definitions
->*****
OBJECT default_tool
	old		:	PTR TO CHAR
	old_raw	:	PTR TO CHAR
	pattern	:	LONG
	new		:	PTR TO CHAR
ENDOBJECT


->*****
->** Constant declarations
->*****
CONST	NO_CURRENT_EDITED_PATH		=	-1
CONST	NO_CURRENT_EDITED_DEF_TOOL	=	-1


->*****
->** Enumerations
->*****
ENUM	IDEX_WI_MAIN = 1 ,
		ID_BT_ABOUT ,
		ID_BT_STOP ,
		ID_AREXX_QUIT
