#ifndef _LISA_EVAL_H
#define _LISA_EVAL_H

#include <string.h>

#include "main.h"

/*
	GLOBALS
*/

extern struct lisa_environment *global_env;





/*
	PROTOS
*/

// generic
void eval( struct lisa_node *node, struct lisa_environment *env );

// specific...
void evalArray( struct lisa_node *node, struct lisa_environment *env );
void evalBlock( struct lisa_node *node, struct lisa_environment *env, int brackets );
void evalCondition( struct lisa_node *node, struct lisa_environment *env );
void evalDirective( struct lisa_node *node, struct lisa_environment *env );
void evalExpression( struct lisa_node *node, struct lisa_environment *env );
void evalFunction( struct lisa_node *node, struct lisa_environment *env );
void evalIdentifier( struct lisa_node *node, struct lisa_environment *env );
void evalKeyword( struct lisa_node *node, struct lisa_environment *env );
void evalNumber( struct lisa_node *node, struct lisa_environment *env );
void evalOperator( struct lisa_node *node, struct lisa_environment *env );
void evalString( struct lisa_node *node, struct lisa_environment *env );
void evalTAGKeyword( struct lisa_node *node, struct lisa_environment *env );

// error management...
void evalError( char *msg, struct lisa_node *node );


#endif
