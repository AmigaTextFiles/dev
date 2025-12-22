OPT MODULE
OPT EXPORT


->*****
->** External modules
->*****
MODULE 'muimaster'

MODULE '*Locale'
MODULE '*GUI_MUIB'


->*****
->** Global variables
->*****
DEF deftII	:	PTR TO obj_app
DEF cat		:	PTR TO catalog_DeftII


/*******************************************************/
/* Prints an error message with an intuition requester */
/*******************************************************/
PROC deftII_error_simple( message : PTR TO CHAR ) IS EasyRequestArgs(	NIL , [ 20 , 0 ,
																		get_string( cat.msg_DeftII_Error ) ,
																		message ,
																		get_string( cat.msg_Simple_OK ) ] , NIL , NIL )


/*************************************************/
/* Prints an error message with an MUI requester */
/*************************************************/
PROC deftII_error( message : PTR TO CHAR ) IS	Mui_RequestA(	deftII.app ,
																deftII.wi_main ,
																NIL ,
																get_string( cat.msg_DeftII_Error ) ,
																get_string( cat.msg_OK ) ,
																message ,
																NIL )


/**************************************************/
/* Prints a request message with an MUI requester */
/**************************************************/
PROC deftII_request( message : PTR TO CHAR ) RETURN Mui_RequestA(	deftII.app ,
																	deftII.wi_main ,
																	NIL ,
																	get_string( cat.msg_DeftII_Request ) ,
																	get_string( cat.msg_Yes_No ) ,
																	message ,
																	NIL )
