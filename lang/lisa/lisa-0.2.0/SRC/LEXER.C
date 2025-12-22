#include "lexer.h"


// syntaxError:
//	Display a SYNTAX ERROR message and exit.
void syntaxError( char *msg )
{
	fprintf( stderr, "SYNTAX ERROR: " );
	error( msg );
}//syntaxError





// lex:
//	Generate the APT (Abstract Parse Tree) for a
//	language block (until TAG_SCRIPT has reached).
struct lisa_node *lex( unsigned int scope )
{
	lisa_node *node;
	lisa_node *next;
	lisa_node *work;
	lisa_node *tmp;
	char *element;

	// get a token
	node = parse();

	element = node->element;

	switch ( node->type )
	{
		case LISA_TYPE_OPEN_BLOCK_BRACKET:
		{
			if ( ! ( scope & LISA_SCOPE_BLOCK ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no '{' required" );
			}

			// destroy this node...
			destroyNode( node );

			// parse for INSTRUCTION...
			node = lex( LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION );

			// parse for optional INSTRUCTIONS...
			next = node;
			while( 1 )
			{
				// checking for '}'...
				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_BLOCK_BRACKET )
				{
					pushbackNode( work );
				}
				else
				{
					destroyNode( work );
					break;
				}

				// parse for INSTRUCTION...
				work = lex( LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION );
				next->next = work;
				next = work;
			}

			break;
		}

		case LISA_TYPE_OPEN_ROUND_BRACKET:
		{
			if ( ! ( scope & ( LISA_SCOPE_ARGUMENTS | LISA_SCOPE_EXPRESSION | LISA_SCOPE_CONDITION ) ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no '(' required" );
			}

			if ( scope & LISA_SCOPE_ARGUMENTS )
			{
				// APT:
				//
				//                    caller
				//                     /  |
				//                  '('    ...
				//                 /
				//      [ arglist ]
				//

				// parse for optional args lins...
				work = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );
				if ( emptyNode( work ) )
				{
					destroyNode( work );
					work = NULL;
				}
				node->args = work;

				// checking for ')'...
				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_ROUND_BRACKET )
				{
					syntaxError( "missed ')'" );
				}
			}
			else
			{
				node->type = LISA_TYPE_EXPRESSION;

				// get the rest of expression/condition...
				work = lex( LISA_SCOPE_CONDITION );
				node->args = work;

				// checking for ')'...
				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_ROUND_BRACKET )
				{
					syntaxError( "missed ')'" );
				}

				// parse for optional operator...
				work = parse();
				if ( work->type == LISA_TYPE_OPERATOR )
				{
					node->next = work;
				}
				else
				{
					pushbackNode( work );
					if ( scope & LISA_SCOPE_EXPRESSION )
						work = lex( LISA_SCOPE_SEMICOLON );
					break;
				}

				work = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );
				if ( emptyNode( work ) )
				{
					destroyNode( work );
					work = NULL;
				}
				node->next->next = work;

				if ( scope & LISA_SCOPE_EXPRESSION )
					lex( LISA_SCOPE_SEMICOLON );
			}

			// NOTE: (2002-06-20 Gabriele Budelacci)
			// Returning a '(' node in every case...
			break;
		}

		case LISA_TYPE_OPEN_SQUARE_BRACKET:
		{
			if ( ! ( scope & LISA_SCOPE_INDEX ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no '[' required" );
			}

			// APT:
			//
			//                    caller
			//                     /  |
			//                  '['    ...
			//                 /
			//   [ expression ]
			//

			// parse for optional index EXPRESSION...
			work = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );
			if ( emptyNode( work ) )
			{
				destroyNode( work );
				work = NULL;
			}
			node->args = work;

			// checking for ']'...
			work = parse();
			if ( work->type != LISA_TYPE_CLOSE_SQUARE_BRACKET )
			{
				syntaxError( "missed ']'" );
			}

			// NOTE: (2002-06-20 Gabriele Budelacci)
			// Returning a '[' node in every case...
			break;
		}

		case LISA_TYPE_COLON:
		{
			if ( ! ( scope & LISA_SCOPE_COLON ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no ':' required" );
			}
			break;
		}

		case LISA_TYPE_IDENTIFIER:
		{
			if ( ! ( scope & ( LISA_SCOPE_EXPRESSION | LISA_SCOPE_CONDITION ) ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no identifier required" );
			}

			// check for arg list => this is a function call...
			work = lex( LISA_SCOPE_ARGUMENTS | LISA_SCOPE_EMPTY );
			if ( emptyNode( work ) )
			{
				// not a function call...
				destroyNode( work );

				// check for index expression => this is an array value...
				work = lex( LISA_SCOPE_INDEX | LISA_SCOPE_EMPTY );
				if ( emptyNode( work ) )
				{
					// not an array...
					destroyNode( work );
				}
				else
				{
					// array value...
					node->args = work->args;
					destroyNode( work );
					node->type = LISA_TYPE_ARRAY;
				}
			}
			else
			{
				// function call...
				node->args = work;
				node->type = LISA_TYPE_FUNCTION;
			}

			// parse for optional operator...
			work = parse();
			if ( work->type == LISA_TYPE_OPERATOR )
			{
				node->next = work;
			}
			else
			{
				pushbackNode( work );
				if ( scope & LISA_SCOPE_EXPRESSION )
				{
					work = lex( LISA_SCOPE_SEMICOLON );
					destroyNodeR( work );

					// creating empty expression node...
					work = createNode();
					work->type = LISA_TYPE_EXPRESSION;
					// ...and returning it...
					work->args = node;
					node = work;
				}
				break;
			}

			work = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );
			if ( emptyNode( work ) )
			{
				destroyNode( work );
				work = NULL;
			}
			node->next->next = work;

			if ( scope & LISA_SCOPE_EXPRESSION )
			{
				work = lex( LISA_SCOPE_SEMICOLON );
				destroyNodeR( work );

				// creating empty expression node...
				work = createNode();
				work->type = LISA_TYPE_EXPRESSION;
				// ...and returning it...
				work->args = node;
				node = work;
			}

			break;
		}

		case LISA_TYPE_DIRECTIVE:
		{
			// NOTE: (2002-06-21 Gabriele Budelacci)
			// Im searching for a DIRECTIVE, but I accept
			// a STATEMENT now...
			if ( ! ( scope & LISA_SCOPE_STATEMENT ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no directive required" );
			}

			// #include "filename"
			//
			//          #include
			//            /  |
			//   "filename"   ...
			//
			// #include <modulename> (alternative syntax)
			//
			//          #include
			//            /  |
			//  modulename    ...
			//
			if ( strcmp( node->element, "#include" ) == 0 )
			{
				// parse for filename or modulename...
				work = parse();
				if ( work->type != LISA_TYPE_STRING )
				{
					if ( strcmp( work->element, "<" ) != 0 )
					{
						syntaxError( "filename or modulename required" );
					}
					destroyNode( work );

					// get modulename...
					work = parse();
					if ( work->type != LISA_TYPE_IDENTIFIER )
					{
						syntaxError( "bad or missing modulename" );
					}
					node->args = work;

					// get '>'...
					work = parse();
					if ( strcmp( work->element, ">" ) != 0 )
					{
						syntaxError( "'>' required" );
					}
					destroyNode( work );

					// restore a good value for work...
					work = node->args;
				}
				node->args = work;

				break;
			}

			// #php .. #/php
			//
			//             #php
			//             /  |
			//  php section    ...
			//
			if ( strcmp( node->element, "#php" ) == 0 )
			{
				// NOTE: (2002-07-03 Gabriele Budelacci)
				//	This part of code is performed by parser.
				break;
			}

			break;
		}

		case LISA_TYPE_KEYWORD:
		{
			if ( ! ( scope & LISA_SCOPE_STATEMENT ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no statement required" );
			}

			// break;
			if ( strcmp( element, "break" ) == 0 )
			{
				work = lex( LISA_SCOPE_SEMICOLON );
				if ( emptyNode( work ) )
					syntaxError( "missing ';'" );
				break;
			}

			// array identifier {, identifier};
			// set   identifier {, identifier};
			// var   identifier {, identifier};
			//
			//                    array
			//                     / |
			//           identifier   ...
			//                  |
			//                 { identifier }
			//
			if ( ( strcmp( element, "array" ) == 0 ) ||
			     ( strcmp( element, "set" ) == 0 ) ||
			     ( strcmp( element, "var" ) == 0 ) )
			{
				// parse for identifier...
				work = parse();
				if ( work->type != LISA_TYPE_IDENTIFIER )
					syntaxError( "missing identifier" );
				node->args = work;

				// parsing for optional declaration list...
				next = work;
				work = parse();
				while ( strcmp( work->element, "," ) == 0 )
				{
					// destroy ',' token
					destroyNode( work );
					// parse for identifier...
					work = parse();
					if ( work->type != LISA_TYPE_IDENTIFIER )
						syntaxError( "missing identifier" );
					next->next = work;
					next = work;
					// check if ","
					work = parse();
				}
				pushbackNode( work );

				work = lex( LISA_SCOPE_SEMICOLON );
				if ( emptyNode( work ) )
					syntaxError( "missing ';'" );
				break;
			}

			// case value:
			//
			//         case
			//          /|
			//     value
			//
			if ( strcmp( element, "case" ) == 0 )
			{
				node->type = LISA_TYPE_TAGKEYWORD;
				//parsing for value...
				work = parse();
				if ( ( work->type != LISA_TYPE_NUMBER ) &&
				     ( work->type != LISA_TYPE_STRING )  )
					syntaxError( "missing fixed value" );

				node->args = work;
				// parse for ':'...
				work = lex( LISA_SCOPE_COLON );
				destroyNode( work );

				break;
			}

			// continue;
			if ( strcmp( element, "continue" ) == 0 )
			{
				work = lex( LISA_SCOPE_SEMICOLON );
				if ( emptyNode( work ) )
					syntaxError( "missing ';'" );
				break;
			}

			// default:
			// else:
			if ( ( strcmp( element, "default" ) == 0 ) ||
				 ( strcmp( element, "else" ) == 0 ) )
			{
				node->type = LISA_TYPE_TAGKEYWORD;
				// parse for ':'...
				work = lex( LISA_SCOPE_COLON );
				destroyNode( work );

				break;
			}

			// endif;
			// endforeach;
			// endswitch;
			// endwhile;
			// next;
			if ( ( strcmp( element, "endif" ) == 0 ) ||
				 ( strcmp( element, "endforeach" ) == 0 ) ||
				 ( strcmp( element, "endswitch" ) == 0 ) ||
				 ( strcmp( element, "endwhile" ) == 0 ) ||
				 ( strcmp( element, "next" ) == 0 ) )
			{
				node->type = LISA_TYPE_TAGKEYWORD;

				// a ';' is required at end of statement
				work = lex( LISA_SCOPE_SEMICOLON );
				destroyNode( work );
				break;
			}

			// foreach ( set-identifier as identifier {, identifier} )
			//    block
			//
			// foreach ( array-identifier as identifier )
			//    block
			//
			//                    foreach
			//                      / |
			//  array-set-identifier   ...
			//             /  |
			//        block  { identifier }
			//
			if ( strcmp( element, "foreach" ) == 0 )
			{
				// parse for '('...
				work = parse();
				if ( work->type != LISA_TYPE_OPEN_ROUND_BRACKET )
					syntaxError( "missing '('" );
				destroyNode( work );

				// parse for set-identifier...
				work = parse();
				if ( work->type != LISA_TYPE_IDENTIFIER )
					syntaxError( "missing set identifier" );
				node->args = work;

				// parse for as keyword...
				work = parse();
				if ( work->type != LISA_TYPE_KEYWORD )
					syntaxError( "missing 'as' keyword" );
				destroyNode( work );

				// parse for identifiers...
				work = parse();
				if ( work->type != LISA_TYPE_IDENTIFIER )
					syntaxError( "missing identifier" );
				node->args->next = work;

				// parsing for optional declaration list...
				next = work;
				work = parse();
				while ( strcmp( work->element, "," ) == 0 )
				{
					// destroy ',' token
					destroyNode( work );
					// parse for identifier...
					work = parse();
					if ( work->type != LISA_TYPE_IDENTIFIER )
						syntaxError( "missing identifier" );
					next->next = work;
					next = work;
					// check if ","
					work = parse();
				}
				pushbackNode( work );

				// parse for ')'...
				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_ROUND_BRACKET )
					syntaxError( "missing ')'" );
				destroyNode( work );

				// parsing optional ':' for TAG type statement...
				work = parse();
				if ( work->type == LISA_TYPE_COLON )
				{
					node->type = LISA_TYPE_TAGKEYWORD;
					break;
				}
				else
				{
					pushbackNode( work );
				}

				// parse for BLOCK...
				work = lex( LISA_SCOPE_BLOCK | LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION );
				node->args->args = work;
				break;
			}

			// function name-identifier ( arg-list )
			//    block
			//
			//                   function
			//                     /  |
			//      name-identifier    ...
			//            /  |
			//       block    arg-list
			//
			// inline declaration:
			//
			// function name-identifier ( arg-list ) is expression;
			//
			if ( strcmp( element, "function" ) == 0 )
			{
				// parse for name-identifier...
				work = parse();
				if ( work->type != LISA_TYPE_IDENTIFIER )
					syntaxError( "missing function name" );
				node->args = work;

				// parse for '('...
				work = parse();
				if ( work->type != LISA_TYPE_OPEN_ROUND_BRACKET )
					syntaxError( "missing '('" );
				destroyNode( work );

				// parse for optional arg list...
				work = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );
				if ( emptyNode( work ) )
				{
					destroyNode( work );
					work = NULL;
				}
				node->args->next = work;

				// parse for ')'...
				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_ROUND_BRACKET )
					syntaxError( "missing ')'" );
				destroyNode( work );

				// parse for 'is' keyword...
				work = parse();
				if ( strcmp( work->element, "is" ) == 0 )
				{
					// free the 'is' keyword...
					destroyNode( work );
					// get the expression...
					work = lex( LISA_SCOPE_CONDITION );
					// creating 'return' statement...
					node->args->args = createNode();
					strcpy( node->args->args->element, "return" );
					node->args->args->type = LISA_TYPE_KEYWORD;
					// linking expression to return statement...
					node->args->args->args = work;
					// parsing for end of statement...
					work = lex( LISA_SCOPE_SEMICOLON );
					destroyNode( work );
				}
				else
				{
					pushbackNode( work );
					// parse for BLOCK...
					work = lex( LISA_SCOPE_BLOCK | LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION );
					node->args->args = work;
				}

				break;
			}

			// global declaration;
			//
			//                    global
			//                     / |
			//      var-declaration   ...
			//
			if ( strcmp( element, "global" ) == 0 )
			{
				// parse for 'var keyword...
				work = parse();
				if ( ( work->type != LISA_TYPE_KEYWORD ) ||
					 ( strcmp( work->element, "var" ) != 0 ) )
				{
					syntaxError( "only var declarations can be globals" );
				}
				pushbackNode( work );
				work = lex( LISA_SCOPE_STATEMENT );
				node->args = work;

				break;
			}

			// if ( condition ) [ { ] true-statement [ } ]
			// [ else [ { ] false-statement [ } ] ]
			//
			//                     if
			//                    /  |
			//               empty
			//               /   |
			//      condition     empty
			//                    /   |
			//                true   [ false ]
			//
			if ( strcmp( element, "if" ) == 0 )
			{
				// creating APT skeleton...
				node->args       = createNode();
				node->args->next = createNode();

				// parse for '('...
				work = parse();
				if ( work->type != LISA_TYPE_OPEN_ROUND_BRACKET )
					syntaxError( "missing '('" );

				// parsing CONDITION...
				work = lex( LISA_SCOPE_CONDITION );
				node->args->args = work;

				// parse for ')'...
				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_ROUND_BRACKET )
					syntaxError( "missing ')'" );

				// parsing optional ':' for TAG type statement...
				work = parse();
				if ( work->type == LISA_TYPE_COLON )
				{
					node->type = LISA_TYPE_TAGKEYWORD;
					break;
				}
				else
				{
					pushbackNode( work );
				}

				// parsing TRUE-STATEMENT
				work = lex( LISA_SCOPE_BLOCK | LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION );
				node->args->next->args = work;

				// parsing optional ELSE...
				work = parse();
				if ( work->type != LISA_TYPE_KEYWORD )
				{
					pushbackNode( work );
					break;
				}
				if ( strcmp( work->element, "else" ) != 0 )
				{
					pushbackNode( work );
					break;
				}

				// parsing FALSE-STATEMENT
				work = lex( LISA_SCOPE_BLOCK | LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION );
				node->args->next->next = work;

				break;
			}

			// parameter declaration;
			//
			//                   parameter
			//                     /  |
			//      var-declaration    ...
			//
			if ( strcmp( element, "parameter" ) == 0 )
			{
				// parse for 'var keyword...
				work = parse();
				if ( ( work->type != LISA_TYPE_KEYWORD ) ||
					 ( strcmp( work->element, "var" ) != 0 ) )
				{
					syntaxError( "parmeters may be only variants" );
				}
				pushbackNode( work );
				work = lex( LISA_SCOPE_STATEMENT );
				node->args = work;

				break;
			}

			// return [expression];
			//
			//                    return
			//                     /  |
			//         [ expression ]  ...
			//
			if ( strcmp( element, "return" ) == 0 )
			{
				// parse for optional expression...
				work = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );
				if ( emptyNode( work ) )
				{
					destroyNode( work );
					work = NULL;
				}
				node->args = work;

				// parse for ';'...
				work = lex( LISA_SCOPE_SEMICOLON );
				destroyNode( work );

				break;
			}

			// switch ( condition )
			// '{'
			// 		{ case value: {block} }
			//		[ default: {block} ]
			// '}'
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
			if ( strcmp( element, "switch" ) == 0 )
			{
				// creating APT skeleton...
				node->args = createNode();

				// parse for '('...
				work = parse();
				if ( work->type != LISA_TYPE_OPEN_ROUND_BRACKET )
					syntaxError( "missing '('" );

				// parsing CONDITION...
				work = lex( LISA_SCOPE_CONDITION );
				node->args->args = work;

				// parse for ')'...
				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_ROUND_BRACKET )
					syntaxError( "missing ')'" );

				// parsing optional ':' for TAG type statement...
				work = parse();
				if ( work->type == LISA_TYPE_COLON )
				{
					node->type = LISA_TYPE_TAGKEYWORD;
					break;
				}
				else
				{
					pushbackNode( work );
				}

				// parse for '{'...
				work = parse();
				if ( work->type != LISA_TYPE_OPEN_BLOCK_BRACKET )
					syntaxError( "missing '{'" );

				tmp = node->args;
				// parsing optional sequence of case statements
				work = parse();
				while ( strcmp( work->element, "case" ) == 0 )
				{
					tmp->next = work;

					// parse for value...
					work = parse();
					if ( ( work->type != LISA_TYPE_NUMBER ) &&
					     ( work->type != LISA_TYPE_STRING )  )
						syntaxError( "missing fixed value" );

					tmp->next->args = work;

					// parse for ':'...
					work = parse();
					if ( work->type != LISA_TYPE_COLON )
						syntaxError( "missing ':'" );

					// parse for optional block...
					tmp->next->args->args = lex( LISA_SCOPE_BLOCK | LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION | LISA_SCOPE_EMPTY );

					// parse next block...
					tmp = tmp->next;
					work = parse();
				}

				// test for optional default statement...
				if ( strcmp( work->element, "default" ) == 0 )
				{
					tmp->next = work;

					// parse for ':'...
					work = parse();
					if ( work->type != LISA_TYPE_COLON )
						syntaxError( "missing ':'" );

					// parse for optional block...
					tmp->next->args = lex( LISA_SCOPE_BLOCK | LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION | LISA_SCOPE_EMPTY );
				}
				else
				{
					pushbackNode( work );
				}

				// parse for '}'...
				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_BLOCK_BRACKET )
					syntaxError( "missing '}'" );

				break;
			}

			// transaction
			// '{' statement '}'
			//
			//              transaction
			//               /     |
			//         statement
			//
			if ( strcmp( element, "transaction" ) == 0 )
			{
				// parsing STATEMENT
				work = lex( LISA_SCOPE_BLOCK );
				node->args = work;

				break;
			}

			// while ( condition )
			// [ { ] statement [ } ]
			//
			//                     while
			//                      / |
			//                 empty
			//                 /   |
			//        condition     statement
			//
			if ( strcmp( element, "while" ) == 0 )
			{
				// creating APT skeleton...
				node->args       = createNode();

				work = parse();
				if ( work->type != LISA_TYPE_OPEN_ROUND_BRACKET )
					syntaxError( "missing '('" );

				// parsing CONDITION...
				work = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );
				if ( emptyNode( work ) )
				{
					destroyNode( work );
					work = NULL;
				}
				node->args->args = work;

				work = parse();
				if ( work->type != LISA_TYPE_CLOSE_ROUND_BRACKET )
					syntaxError( "missing ')'" );

				// parsing optional ':' for TAG type statement...
				work = parse();
				if ( work->type == LISA_TYPE_COLON )
				{
					node->type = LISA_TYPE_TAGKEYWORD;
					break;
				}
				else
				{
					pushbackNode( work );
				}

				// parsing STATEMENT
				work = lex( LISA_SCOPE_BLOCK | LISA_SCOPE_STATEMENT | LISA_SCOPE_EXPRESSION );
				node->args->next = work;

				break;
			}

			break;
		}

		case LISA_TYPE_NUMBER:
		case LISA_TYPE_STRING:
		{
			if ( ! ( scope & ( LISA_SCOPE_EXPRESSION | LISA_SCOPE_CONDITION ) ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no value required" );
			}

			// parse for optional operator...
			work = parse();
			if ( work->type == LISA_TYPE_OPERATOR )
			{
				node->next = work;
			}
			else
			{
				pushbackNode( work );
				if ( scope & LISA_SCOPE_EXPRESSION )
					work = lex( LISA_SCOPE_SEMICOLON );
				break;
			}

			work = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );
			if ( emptyNode( work ) )
			{
				destroyNode( work );
				work = NULL;
			}
			node->next->next = work;

			if ( scope & LISA_SCOPE_EXPRESSION )
			{
				work = lex( LISA_SCOPE_SEMICOLON );
				destroyNodeR( work );

				// creating empty expression node...
				work = createNode();
				work->type = LISA_TYPE_EXPRESSION;
				// ...and returning it...
				work->args = node;
				node = work;
			}

			break;
		}

		case LISA_TYPE_OPERATOR:
		{
			if ( ! ( scope & ( LISA_SCOPE_EXPRESSION | LISA_SCOPE_CONDITION ) ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no value required" );
			}

			// parsing the rest of the EXPRESSION/CONDITION...
			work = lex( LISA_SCOPE_CONDITION );
			node->next = work;

			if ( scope & LISA_SCOPE_EXPRESSION )
			{
				work = lex( LISA_SCOPE_SEMICOLON );
				destroyNodeR( work );

				// creating empty expression node...
				work = createNode();
				work->type = LISA_TYPE_EXPRESSION;
				// ...and returning it...
				work->args = node;
				node = work;
			}

			break;
		}

		case LISA_TYPE_SEMICOLON:
		{
			if ( ! ( scope & LISA_SCOPE_SEMICOLON ) )
			{
				// return an empty node if EMPTY required...
				if ( scope & LISA_SCOPE_EMPTY )
				{
					pushbackNode( node );
					return createNode();
				}
				// else, stop compiling...
				syntaxError( "no ';' required" );
			}
			break;
		}


		default:
		{
			// return an empty node if EMPTY required...
			if ( scope & LISA_SCOPE_EMPTY )
			{
				pushbackNode( node );
				return createNode();
			}

			// error on empty node...
			if ( emptyNode( node ) )
				syntaxError( "empty token" );

			// else, stop compiling...
			syntaxError( "bad token" );
		}
	}

	return node;
}//lex

