#ifndef _LISA_LEXER_H
#define _LISA_LEXER_H

#include <string.h>

#include "main.h"

/*
	SCOPES
*/
#define LISA_SCOPE_EXPRESSION 1<<0
#define LISA_SCOPE_STATEMENT  1<<1
#define LISA_SCOPE_DIRECTIVE  1<<2
#define LISA_SCOPE_BLOCK      1<<3
#define LISA_SCOPE_EMPTY      1<<4
#define LISA_SCOPE_SEMICOLON  1<<5
#define LISA_SCOPE_CONDITION  1<<6
#define LISA_SCOPE_ELSE       1<<7
#define LISA_SCOPE_ARGUMENTS  1<<8
#define LISA_SCOPE_INDEX      1<<9
#define LISA_SCOPE_COLON      1<<10
#define LISA_SCOPE_ANY        0xFFFF


/*
	PROTOS
*/
struct lisa_node *lex( unsigned int scope );

// error message
void syntaxError( char *msg );



#endif

