#include "eval.h"


// eval:
//	Evaluate a node in the specified environment.
void eval( struct lisa_node *node, struct lisa_environment *env )
{
	switch ( node->type )
	{
		case LISA_TYPE_CONDITION:
		{
			evalCondition( node->args, env );
			break;
		}
		case LISA_TYPE_DIRECTIVE:
		{
			evalDirective( node, env );
			break;
		}
		case LISA_TYPE_EXPRESSION:
		{
			evalExpression( node, env );
			break;
		}
		case LISA_TYPE_KEYWORD:
		{
			evalKeyword( node, env );
			break;
		}
		case LISA_TYPE_NUMBER:
		{
			evalNumber( node, env );
			break;
		}
		case LISA_TYPE_STRING:
		{
			evalString( node, env );
			break;
		}
		case LISA_TYPE_TAGKEYWORD:
		{
			evalTAGKeyword( node, env );
			break;
		}
		default:
		{
			evalError( "unimplemented token type evaluation", node );
		}
	}
}//eval





// evalArray:
//	Evaluate an array value or identifier in the specified environment.
void evalArray( struct lisa_node *node, struct lisa_environment *env )
{
	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			evalIdentifier( node, env );
//			fprintf( "$%s", node->element );
			if ( node->args )
			{
				fprintf( outstream, "[ " );
				evalCondition( node->args, env );
				fprintf( outstream, " ]" );
			}
			break;
		}
	}
}//evalArray





// evalBlock:
//	Evaluate a sub-block of statements in a child of the specified environment.
void evalBlock( struct lisa_node *node, struct lisa_environment *env, int brackets )
{
	struct lisa_node        *tmp;
	struct lisa_environment *e;

	// creating a child environment...
	e = childEnvironment( env );

	// write start of block...
	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			if ( brackets ) fprintf( outstream, "{\n" );
			break;
		}
	}

	tmp = node;
	while ( tmp )
	{
		eval( tmp, e );
		tmp = tmp->next;
	}

	// write stop of block...
	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			if ( brackets ) fprintf( outstream, "}\n" );
			break;
		}
	}

	// destroying the child environment...
	destroyEnvironment( e );

}//evalBlock





// evalCondition:
//	Evaluate a condition in the specified environment.
void evalCondition( struct lisa_node *node, struct lisa_environment *env )
{
	struct lisa_node *tmp;

	tmp = node;
	while( tmp )
	{
		switch ( tmp->type )
		{
			case LISA_TYPE_ARRAY:
			{
				evalArray( tmp, env );
				break;
			}
			case LISA_TYPE_FUNCTION:
			{
				evalFunction( tmp, env );
				break;
			}
			case LISA_TYPE_IDENTIFIER:
			{
				evalIdentifier( tmp, env );
				break;
			}
			case LISA_TYPE_NUMBER:
			{
				evalNumber( tmp, env );
				break;
			}
			case LISA_TYPE_OPERATOR:
			{
				evalOperator( tmp, env );
				break;
			}
			case LISA_TYPE_STRING:
			{
				evalString( tmp, env );
				break;
			}
		}
		tmp = tmp->next;
	}

}//evalCondition





// evalDirective:
//	Evaluate a directive node in the specified environment.
void evalDirective( struct lisa_node *node, struct lisa_environment *env )
{
	struct lisa_node        *tmp;

	if ( strcmp( node->element, "#include" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				if ( node->args->type == LISA_TYPE_STRING )
				{
					// including a general file...
					fprintf( outstream, "include( " );
					evalString( node->args, env );
					fprintf( outstream, " );\n" );
				}
				else
				{
					// including a module...
					fprintf( outstream, "require( '%s.php' );\n", node->args->element );
				}
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "#php" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				tmp = node->args;
				while ( tmp )
				{
					fprintf( outstream, "%s\n", tmp->element );
					tmp = tmp->args;
				}
				break;
			}
		}
		return;
	}

	evalError( "unimplemented directive evaluation", node );
}//evalDirective





// evalError:
//	Display an error message for the specified node
//	and exit from evaluation.
void evalError( char *msg, struct lisa_node *node )
{
	fprintf( stderr, "\nOn token '%s' (type %d) at line %d:\n\t", node->element, node->type, node->line );
	error( msg );
}//evalError





// evalExpression:
//	Evaluate an expression in the specified environment.
void evalExpression( struct lisa_node *node, struct lisa_environment *env )
{
	// NOTE: (2002-06-28 Gabriele Budelacci)
	//	An EXPRESSION is equivalent to a CONDITION, followed by a
	//	SEMICOLON ';' (lisa language). So, I will evaluate firsts
	//	the condition, then I will write the terminal character,
	//	depending wich target language is compiling to.

	// evaluating the condition firsts...
	evalCondition( node->args, env );

	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			fprintf( outstream, ";\n" );
			break;
		}
	}
}//evalExpression





// evalFunction:
//	Evaluate a function node in the specified environment.
void evalFunction( struct lisa_node *node, struct lisa_environment *env )
{
	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			// NOTE: (2002-07-03 Gabriele Budelacci)
			//	Functions compiled have the same name as specified
			//	in lisa source, undercased and preceased by an
			//	underscore ('_').
			fprintf( outstream, "_%s(", node->element );
			if ( ! emptyNode( node->args ) )
			{
				fprintf( outstream, " " );
				evalCondition( node->args->args, env );
				fprintf( outstream, " " );
			}
			fprintf( outstream, ")" );
			break;
		}
	}
}//evalFunction





// evalIdentifier:
//	Evaluate a identifier node in the specified environment.
void evalIdentifier( struct lisa_node *node, struct lisa_environment *env )
{
	if ( ! findNodeByElement( node->element, env->declared ) )
		evalError( "undeclared variable", node );

	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			if ( findNodeByElement( node->element, env->globals ) )
				fprintf( outstream, "$SESSION['$%s']", node->element );
			else
				fprintf( outstream, "$%s", node->element );
			break;
		}
	}
}//evalIdentifier





// evalKeyword:
//	Evaluate a keyword node in the specified environment.
void evalKeyword( struct lisa_node *node, struct lisa_environment *env )
{
	struct lisa_node *tmp, *next;

	if ( strcmp( node->element, "array" ) == 0 )
	{
		// firsts, check if there is another identifiers declared...
		next = node->args;
		while ( next )
		{
			// search the node in declared list...
			tmp = findNodeByElement( next->element, env->declared );
			// if not exists, append a new identifier...
			if ( tmp == NULL )
			{
				tmp = cloneNode( next );
				// NOTE: (2002-07-12 Gabriele Budelacci)
				//	When a new variable is declared whithin a block,
				//	then the type is negated.
				tmp->type = -LISA_TYPE_ARRAY;		// please note minus '-' sign
				appendNode( tmp, env->declared );
			}
			else
			{
				// The identifier is already declared...
				// If the type is positive, the identifier can be redeclared...
				if ( tmp->type < 0 )
				{
					evalError( "variable already declared", tmp );
				}
				tmp->type = -LISA_TYPE_ARRAY;
			}
			// process next element
			next = next->next;
		}

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				// NOTE: (2002-06-27 Gabriele Budelacci)
				// In PHP language, declaration of variants
				// can be omitted.
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "break" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, "break;\n" );
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "continue" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, "continue;\n" );
				break;
			}
		}
		return;
	}

			//
			//                    foreach
			//                      / |
			//  array-set-identifier   ...
			//             /  |
			//        block  { identifier }
			//
	if ( strcmp( node->element, "foreach" ) == 0 )
	{
		int type;
		struct lisa_environment *e;

		// check if identifier is declared...
		tmp = findNodeByElement( node->args->element, env->declared );
		if ( tmp == NULL )
			evalError( "undeclared variable", node->args );

		// get the identifier type...
		type = tmp->type;
		if ( type < 0 ) type = -type;

		// switch on array or set
		switch ( type )
		{
			case LISA_TYPE_ARRAY:
			{
				switch ( env->language )
				{
					case LISA_LANG_PHP:
					{
						fprintf( outstream, "foreach ( $%s as ", node->args->element );
						e = childEnvironment( env );

							// declaring the identifiers as variants...
							next = node->args->next;
							while ( next )
							{
								// search the node in declared list...
								tmp = findNodeByElement( next->element, e->declared );
								// if not exists, append a new identifier...
								if ( tmp == NULL )
								{
									tmp = cloneNode( next );
									// NOTE: (2002-07-12 Gabriele Budelacci)
									//	When a new variable is declared whithin a block,
									//	then the type is negated.
									tmp->type = -LISA_TYPE_VARIANT;		// please note minus '-' sign
									appendNode( tmp, e->declared );
								}
								else
								{
									// The identifier is already declared...
									// If the type is positive, the identifier can be redeclared...
									if ( tmp->type < 0 )
									{
										evalError( "variable already declared", tmp );
									}
									tmp->type = -LISA_TYPE_VARIANT;
								}
								// process next element
								next = next->next;
							}

							// eval the identifier list...
							next = node->args->next;
							fprintf( outstream, "$%s", next->element );
							if ( next->next )
								evalError( "no more than one variable allowed while processing an array", next );

							fprintf( outstream, " )\n" );
							evalBlock( node->args->args, e, 1 );

						destroyEnvironment( e );
						break;
					}
				}
				break;
			}

			case LISA_TYPE_SET:
			{
				int i;

				switch ( env->language )
				{
					case LISA_LANG_PHP:
					{
						fprintf( outstream, "for ( $_index_=0 ; $_index_<_foreach_( $%s ) ; $_index_++ )\n", node->args->element );
						fprintf( outstream, "{\n" );
						fprintf( outstream, "\t$_array_ = _fetch_( $%s );\n", node->args->element );
						e = childEnvironment( env );

							// declaring the identifiers as variants...
							next = node->args->next;
							i = 0;
							while ( next )
							{
								// search the node in declared list...
								tmp = findNodeByElement( next->element, e->declared );
								// if not exists, append a new identifier...
								if ( tmp == NULL )
								{
									tmp = cloneNode( next );
									// NOTE: (2002-07-12 Gabriele Budelacci)
									//	When a new variable is declared whithin a block,
									//	then the type is negated.
									tmp->type = -LISA_TYPE_VARIANT;		// please note minus '-' sign
									appendNode( tmp, e->declared );
								}
								else
								{
									// The identifier is already declared...
									// If the type is positive, the identifier can be redeclared...
									if ( tmp->type < 0 )
									{
										evalError( "variable already declared", tmp );
									}
									tmp->type = -LISA_TYPE_VARIANT;
								}
								fprintf( outstream, "\t$%s = _scan_( %d );\n", tmp->element, i++ );
								// process next element
								next = next->next;
							}

							evalBlock( node->args->args, e, 0 );

						destroyEnvironment( e );
						fprintf( outstream, "}\n" );
						break;
					}
				}
				break;
			}

			default:
			{
				evalError( "wrong variable type", node->args );
			}
		}
		return;
	}

	if ( strcmp( node->element, "function" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, "function _%s ( ", node->args->element );
				// NOTE: (2002-07-13 Gabriele Budelacci)
				//	I can't evaluate the parameters list as a condition,
				//	because lots of 'undeclared variable' errors are raised.
				tmp = node->args->next;
				while ( tmp )
				{
					switch ( tmp->type )
					{
						case LISA_TYPE_ARRAY:
						case LISA_TYPE_IDENTIFIER:
							fprintf( outstream, "$%s", tmp->element );
							break;
						case LISA_TYPE_OPERATOR:
							fprintf( outstream, ", " );
							break;
						default:
							evalError( "bad APT", tmp );
					}
					tmp = tmp->next;
				}
				fprintf( outstream, " )\n" );
				evalBlock( node->args->args, env, 1 );
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "global" ) == 0 )
	{
		// append the variants to the global list...
		appendNode( cloneNode( node->args->args ), env->globals );
		// NOTE: ( 2002-07-01 Gabriele Budelacci )
		//	The code above may be made better in future...

		// firsts, check if there is another identifiers declared...
		next = node->args->args;
		while ( next )
		{
			// search the node in declared list...
			tmp = findNodeByElement( next->element, env->declared );
			// if not exists, append a new identifier...
			if ( tmp == NULL )
			{
				tmp = cloneNode( next );
				// NOTE: (2002-07-12 Gabriele Budelacci)
				//	When a new variable is declared whithin a block,
				//	then the type is negated.
				tmp->type = -LISA_TYPE_VARIANT;		// please note minus '-' sign
				appendNode( tmp, env->declared );
			}
			else
			{
				// The identifier is already declared...
				// If the type is positive, the identifier can be redeclared...
				if ( tmp->type < 0 )
				{
					evalError( "variable already declared", tmp );
				}
				tmp->type = -LISA_TYPE_VARIANT;
			}
			// process next element
			next = next->next;
		}

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				// NOTE: (2002-07-01 Gabriele Budelacci)
				// In PHP language, declaration of variant
				// can be omitted.
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "if" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, "if ( " );
				evalCondition( node->args->args, env );
				fprintf( outstream, " )\n" );
				evalBlock( node->args->next->args, env, 1 );
				if ( node->args->next->next )
				{
					fprintf( outstream, "else\n" );
					evalBlock( node->args->next->next, env, 1 );
				}
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "parameter" ) == 0 )
	{
		// append the variants to the parameter list...
		appendNode( cloneNode( node->args->args ), env->parameters );

		// firsts, check if there is another identifiers declared...
		next = node->args->args;
		while ( next )
		{
			// search the node in declared list...
			tmp = findNodeByElement( next->element, env->declared );
			// if not exists, append a new identifier...
			if ( tmp == NULL )
			{
				tmp = copyNode( next );
				tmp->args = NULL;
				tmp->next = NULL;
				// NOTE: (2002-07-12 Gabriele Budelacci)
				//	When a new variable is declared whithin a block,
				//	then the type is negated.
				tmp->type = -LISA_TYPE_VARIANT;		// please note minus '-' sign
				appendNode( tmp, env->declared );
			}
			else
			{
				// The identifier is already declared...
				// If the type is positive, the identifier can be redeclared...
				if ( tmp->type < 0 )
				{
					evalError( "variable already declared", tmp );
				}
				tmp->type = -LISA_TYPE_VARIANT;
			}
			// process next element
			next = next->next;
		}

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				// each parameter must be set empty if not defined...
				next = node->args->args;
				while ( next )
				{
					fprintf( outstream, "$%s = ( empty( $%s ) ? '' : $%s );\n", next->element, next->element, next->element );
					next = next->next;
				}
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "return" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, "return " );
				if ( node->args )
				{
					evalCondition( node->args, env );
					fprintf( outstream, ";\n" );
				}
				else
				{
					fprintf( outstream, "0;\n" );
				}
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "set" ) == 0 )
	{
		// firsts, check if there is another identifiers declared...
		next = node->args;
		while ( next )
		{
			// search the node in declared list...
			tmp = findNodeByElement( next->element, env->declared );
			// if not exists, append a new identifier...
			if ( tmp == NULL )
			{
				tmp = cloneNode( next );
				// NOTE: (2002-07-12 Gabriele Budelacci)
				//	When a new variable is declared whithin a block,
				//	then the type is negated.
				tmp->type = -LISA_TYPE_SET;		// please note minus '-' sign
				appendNode( tmp, env->declared );
			}
			else
			{
				// The identifier is already declared...
				// If the type is positive, the identifier can be redeclared...
				if ( tmp->type < 0 )
				{
					evalError( "variable already declared", tmp );
				}
				tmp->type = -LISA_TYPE_SET;
			}
			// process next element
			next = next->next;
		}

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				// NOTE: (2002-06-27 Gabriele Budelacci)
				// In PHP language, declaration of set
				// can be omitted.
				break;
			}
		}
		return;
	}

	//
	//                        switch
	//                        /  |
	//                   empty
	//                   /  |
	//          condition  { case }
	//                      /   |
	//                 value   [ default ]
	//                  /        /
	//             block    block
	//
	if ( strcmp( node->element, "switch" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, "switch ( " );
				evalCondition( node->args->args, env );
				fprintf( outstream, " )\n" );
				fprintf( outstream, "{\n" );
				// eval case and default statements...
				next = node->args->next;
				while ( next )
				{
					if ( strcmp( next->element, "case" ) == 0 )
					{
						// evaluating 'case' statement...
						fprintf( outstream, "case " );
						eval( next->args, env );
						fprintf( outstream, ":\n" );
						if ( ! emptyNode( next->args->args ) )
							evalBlock( next->args->args, env, 1 );
					}
					else
					{
						// else, evaluating 'default' statement...
						fprintf( outstream, "default:\n" );
						if ( ! emptyNode( next->args ) )
							evalBlock( next->args, env, 1 );
					}
					// processing next statement...
					next = next->next;
				}
				fprintf( outstream, "}\n" );
				break;
			}
		}
		return;
	}

	//
	//           transaction
	//            /      |
	//       statement
	//
	if ( strcmp( node->element, "transaction" ) == 0 )
	{
		struct lisa_environment *child_env;

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				// create a child environment...
				child_env = childEnvironment( env );

				fprintf( outstream, "_transaction_();\n" );
				evalBlock( node->args, child_env, 0 );
				fprintf( outstream, "_commit_();\n" );

				// replace the parent environment...
				env = child_env->parent;
				destroyEnvironment( child_env );

				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "var" ) == 0 )
	{
		// firsts, check if there is another identifiers declared...
		next = node->args;
		while ( next )
		{
			// search the node in declared list...
			tmp = findNodeByElement( next->element, env->declared );
			// if not exists, append a new identifier...
			if ( tmp == NULL )
			{
				tmp = cloneNode( next );
				// NOTE: (2002-07-12 Gabriele Budelacci)
				//	When a new variable is declared whithin a block,
				//	then the type is negated.
				tmp->type = -LISA_TYPE_VARIANT;		// please note minus '-' sign
				appendNode( tmp, env->declared );
			}
			else
			{
				// The identifier is already declared...
				// If the type is positive, the identifier can be redeclared...
				if ( tmp->type < 0 )
				{
					evalError( "variable already declared", tmp );
				}
				tmp->type = -LISA_TYPE_VARIANT;
			}
			// process next element
			next = next->next;
		}

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				// NOTE: (2002-06-27 Gabriele Budelacci)
				// In PHP language, declaration of variant
				// can be omitted.
				break;
			}
		}
		return;
	}

	//
	//                     while
	//                      / |
	//                 empty
	//                 /   |
	//        condition     statement
	//
	if ( strcmp( node->element, "while" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, "while ( " );
				evalCondition( node->args->args, env );
				fprintf( outstream, " )\n" );
				evalBlock( node->args->next, env, 1 );
				break;
			}
		}
		return;
	}

	evalError( "unimplemented keyword evaluation", node );
}//evalKeyword





// evalNumber:
//	Evaluate a number node in the specified environment.
void evalNumber( struct lisa_node *node, struct lisa_environment *env )
{
	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			fprintf( outstream, "%s", node->element );
			break;
		}
	}
}//evalNumber





// evalOperator:
//	Evaluate an operator node in the specified environment.
void evalOperator( struct lisa_node *node, struct lisa_environment *env )
{
	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			fprintf( outstream, " %s ", node->element );
			break;
		}
	}
}//evalOperator





// evalString:
//	Evaluate a string node in the specified environment.
void evalString( struct lisa_node *node, struct lisa_environment *env )
{
	switch ( env->language )
	{
		case LISA_LANG_PHP:
		{
			fprintf( outstream, "\"%s\"", node->element );
			break;
		}
	}
}//evalString





// evalTAGKeyword:
//	Evaluate a TAG keyword node in the specified environment.
void evalTAGKeyword( struct lisa_node *node, struct lisa_environment *env )
{
	struct lisa_environment *e;
	struct lisa_node        *tmp, *next;

	if ( strcmp( node->element, "case" ) == 0 )
	{
		// replace the parent environment...
		e = env->parent;
		destroyEnvironment( global_env );
		global_env = e;

		// create a child environment...
		global_env = childEnvironment( global_env );

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " case " );
				eval( node->args, env );
				fprintf( outstream, ": " );
				break;
			}
		}

		return;
	}

	if ( strcmp( node->element, "default" ) == 0 )
	{
		// replace the parent environment...
		e = env->parent;
		destroyEnvironment( global_env );
		global_env = e;

		// create a child environment...
		global_env = childEnvironment( global_env );

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " default: " );
				break;
			}
		}

		return;
	}

	if ( strcmp( node->element, "else" ) == 0 )
	{
		// replace the parent environment...
		e = env->parent;
		destroyEnvironment( global_env );
		global_env = e;

		// create a child environment...
		global_env = childEnvironment( global_env );

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " else: " );
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "endif" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " endif; " );
				break;
			}
		}
		// replace the parent environment...
		e = env->parent;
		destroyEnvironment( global_env );
		global_env = e;

		return;
	}

	if ( ( strcmp( node->element, "endforeach" ) == 0 ) ||
		 ( strcmp( node->element, "next" ) == 0 ) )
	{
		int type;
		struct lisa_node *n = NULL;

		// get the type of loop...
		n = popNode( global_env->loops );
		type = n->type;
		if ( type < 0 ) type = -type;

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				switch ( type )
				{
					case LISA_TYPE_ARRAY:
					{
						fprintf( outstream, " endforeach; " );
						break;
					}
					case LISA_TYPE_SET:
					{
						fprintf( outstream, " endfor; " );
						break;
					}
				}
				break;
			}
		}

		// replace the parent environment...
		e = env->parent;
		destroyEnvironment( global_env );
		global_env = e;

		return;
	}

	if ( strcmp( node->element, "endswitch" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " endswitch; " );
				break;
			}
		}
		// replace the parent environment...
		e = env->parent;
		destroyEnvironment( global_env );
		global_env = e;

		return;
	}

	if ( strcmp( node->element, "endwhile" ) == 0 )
	{
		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " endwhile; " );
				break;
			}
		}
		// replace the parent environment...
		e = env->parent;
		destroyEnvironment( global_env );
		global_env = e;

		return;
	}

	if ( strcmp( node->element, "foreach" ) == 0 )
	{
		int type;
		struct lisa_node *n = NULL;

		// check if the identifier is declared...
		tmp = findNodeByElement( node->args->element, env->declared );
		if ( tmp == NULL )
			evalError( "undeclared variable", node->args );

		// get the identifier type...
		type = tmp->type;
		if ( type < 0 ) type = -type;

		// create a child environment...
		global_env = childEnvironment( env );

		// appending the variable type on the environment loops list...
		n = copyNode( tmp );
		n->args = NULL;
		n->next = NULL;
		pushNode( n, global_env->loops );

		// switch on array or set
		switch ( type )
		{
			case LISA_TYPE_ARRAY:
			{
				switch ( env->language )
				{
					case LISA_LANG_PHP:
					{
						fprintf( outstream, " foreach ( $%s as ", node->args->element );

						// declaring the identifiers as variants...
						next = node->args->next;
						while ( next )
						{
							// search the node in declared list...
							tmp = findNodeByElement( next->element, env->declared );
							// if not exists, append a new identifier...
							if ( tmp == NULL )
							{
								tmp = cloneNode( next );
								// NOTE: (2002-07-12 Gabriele Budelacci)
								//	When a new variable is declared whithin a block,
								//	then the type is negated.
								tmp->type = -LISA_TYPE_VARIANT;		// please note minus '-' sign
								appendNode( tmp, env->declared );
							}
							else
							{
								// The identifier is already declared...
								// If the type is positive, the identifier can be redeclared...
								if ( tmp->type < 0 )
								{
									evalError( "variable already declared", tmp );
								}
								tmp->type = -LISA_TYPE_VARIANT;
							}
							// process next element
							next = next->next;
						}

						// eval the identifier list...
						next = node->args->next;
						fprintf( outstream, "$%s", next->element );
						if ( next->next )
							evalError( "no more than one variable allowed while processing an array", next );

						fprintf( outstream, " ): " );
						break;
					}
				}
				break;
			}

			case LISA_TYPE_SET:
			{
				int i;

				switch ( env->language )
				{
					case LISA_LANG_PHP:
					{
						fprintf( outstream, " for ( $_index_=0 ; $_index_<_foreach_( $%s ) ; $_index_++ ): ", node->args->element );
						fprintf( outstream, "?>\n" );
						fprintf( outstream, "\t<? $_array_ = _fetch_( $%s );\n", node->args->element );
//						e = childEnvironment( env );

							// declaring the identifiers as variants...
							next = node->args->next;
							i = 0;
							while ( next )
							{
								// search the node in declared list...
								tmp = findNodeByElement( next->element, env->declared );
								// if not exists, append a new identifier...
								if ( tmp == NULL )
								{
									tmp = cloneNode( next );
									// NOTE: (2002-07-12 Gabriele Budelacci)
									//	When a new variable is declared whithin a block,
									//	then the type is negated.
									tmp->type = -LISA_TYPE_VARIANT;		// please note minus '-' sign
									appendNode( tmp, global_env->declared );
								}
								else
								{
									// The identifier is already declared...
									// If the type is positive, the identifier can be redeclared...
									if ( tmp->type < 0 )
									{
										evalError( "variable already declared", tmp );
									}
									tmp->type = -LISA_TYPE_VARIANT;
								}
								fprintf( outstream, "\t$%s = _scan_( %d );\n", tmp->element, i++ );
								// process next element
								next = next->next;
							}
							// NOTE: (2002-09-04 Gabriele Budelacci)
							//	Endtag ('?>') will be written by the caller function, so I don't
							//	put them out...
							fprintf( outstream, "\t" );

//							evalBlock( node->args->args, e, 0 );

//						destroyEnvironment( e );
//						fprintf( "}\n" );
						break;
					}
				}
				break;
			}

			default:
			{
				evalError( "wrong type variable", node->args );
			}
		}
		return;
	}

	if ( strcmp( node->element, "if" ) == 0 )
	{
		// create a child environment...
		global_env = childEnvironment( env );

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " if ( " );
				evalCondition( node->args->args, env );
				fprintf( outstream, " ): " );
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "switch" ) == 0 )
	{
		// create a child environment...
		global_env = childEnvironment( env );

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " while ( " );
				evalCondition( node->args->args, env );
				fprintf( outstream, " ): " );
				break;
			}
		}
		return;
	}

	if ( strcmp( node->element, "while" ) == 0 )
	{
		// create a child environment...
		global_env = childEnvironment( env );

		switch ( env->language )
		{
			case LISA_LANG_PHP:
			{
				fprintf( outstream, " while ( " );
				evalCondition( node->args->args, env );
				fprintf( outstream, " ): " );
				break;
			}
		}
		return;
	}

	evalError( "unimplemented TAG keyword evaluation", node );
}//evalTAGKeyword


