#ifndef _LISA_PARSER_H
#define _LISA_PARSER_H

#include <string.h>

#include "main.h"

/*
	PROTOS
*/
void initParser( void );
struct lisa_node *parse( void );
void pushbackNode( struct lisa_node *node );


#endif
