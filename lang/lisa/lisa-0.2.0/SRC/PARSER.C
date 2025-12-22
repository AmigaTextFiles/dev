#include "parser.h"

/*
	GLOBALS
*/
// NOTE:
// 'END' keyword or directive is used while searching keywords/directives into the array.
// See 'parse' function on identifier match for an example...

// language KEYWORDS
char *keywords[] = { "array", "as", "break", "case", "continue", "database", "default",
					 "else", "endforeach", "endif", "endwhile", "extern", "foreach",
					 "function", "global", "if", "is", "next", "parameter", "return",
					 "set", "switch", "transaction", "var", "while",
					 "END" };

// language DIRECTIVES
char *directives[] = { "#self", "#include", "#asp", "#/asp","#jsp", "#/jsp", "#php", "#/php",
					   "END" };

// language VALUES
char *values[] = { "true", "false",
				   "END" };

// used for push-back
//	if this ptr not equals NULL, the parse() function will return this value...
lisa_node *pushback_node = NULL;





// initParser:
//	Initialize the parser.
void initParser( void )
{
	// empty pushback buffer...
	if ( pushback_node != NULL )
	{
		destroyNodeR( pushback_node );
		pushback_node = NULL;
	}
}//initParser





// parse:
//	Parse the input stream and return a node (token).
//	On error (ie: EOF), return a empty node.
//
//	The SYNTAX is: (pseudo-BNF)
//
//		bracket    ::= '(' | ')' | '[' | ']' | '{' | '}'
//		directive  ::= '#' (a..z) { (a..z) }
//		identifier ::= (a..z) { (a..z) | '_' | (0..9) }
//		number     ::= (0..9) { (0..9) } [ '.' (0..9) { (0..9) } ]
//		operator   ::= '+' | '-' | '*' | '/' | '%' | '<' | '>' |
//		               '<=' | '>=' | '==' | '!=' | '!' | '&&' |
//		               '||' | '=' | '&' | '|' | ',' | '.'
//		remark     ::= ( '//' {anychar} EOL ) | ( '/*' {anychar} '*/' )
//		colon      ::= ':'
//		semicolon  ::= ';'
//		string     ::= '"' { (anychar~'"') | ('\'anychar) } '"'
lisa_node *parse( void )
{
	lisa_node     *node = NULL;
	unsigned char ch;

	// return the push-back node if exists...
	if ( pushback_node != NULL )
	{
		node = pushback_node;
		pushback_node = NULL;
		return node;
	}

	// create a empty node
	node = createNode();

	ch = getCharS();

	// ignoring initial blanks...
	while ( strchr( " \t\n\r", ch ) )
	{
		if ( ch == 0 )
		{
			// if no more chars, return a empty node...
			return node;
		}

		// get next char
		ch = getCharS();
	}

	// lowercasing char...
	if ( ch >= 'A' && ch <= 'Z' )
	{
		ch |= 32;
	}

	switch ( ch )
	{
		case '\0':
		{
			// if no more chars, return a empty node...
			return node;
		}
	// bracket ::= '(' | ')' | '[' | ']' | '{' | '}'
		case '(':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_OPEN_ROUND_BRACKET;
			break;
		}
		case ')':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_CLOSE_ROUND_BRACKET;
			break;
		}
		case '[':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_OPEN_SQUARE_BRACKET;
			break;
		}
		case ']':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_CLOSE_SQUARE_BRACKET;
			break;
		}
		case '{':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_OPEN_BLOCK_BRACKET;
			break;
		}
		case '}':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_CLOSE_BLOCK_BRACKET;
			break;
		}
	// directive ::= '#' (a..z) { (a..z) }
		case '#':
		{
			// append the char to element
			int i=0;
			node->element[i++] = ch;
			// appending another chars...
			ch = getCharS();
			// lowercasing char...
			if ( ch >= 'A' && ch <= 'Z' )
				ch |= 32;
			while ( strchr( "abcdefghijklmnopqrstuvwxyz_0123456789#/", ch ) )
			{
				node->element[i++] = ch;
				ch = getCharS();
				if ( ch >= 'A' && ch <= 'Z' )
					ch |= 32;
			}
			node->element[i] = '\0';
			node->type       = LISA_TYPE_DIRECTIVE;

			// making a push-back action for readed char.
			// Thisn't a good idea, and MUST be fixed in
			// a near future...
			pushbackCharS();

			// testing directive match...
			for ( i=0 ; 1 ; i++ )
			{
				char *s = directives[i];
				if ( strcmp( s, node->element ) == 0 )
				{
					// founded a directive!!!
					node->type = LISA_TYPE_DIRECTIVE;
					break;
				}
				if ( strcmp( s, "END" ) == 0 )
				{
					// no directive match...
					error( "unknown directive" );
					break;
				}
			}

			// NOTE: (2002-07-03 Gabriele Budelacci)
			//	Now check if there's a target language directive
			//	(i.e. #asp, #jsp, #php...). If true, I will
			//	get all the target code, until the corresponding
			//	directive (respectively, #/asp, #/jsp, #/php...).
			//	This i a norml lexer work, but I make this now
			//	because I can't get all token of all the target
			//	languages.
			//	Every line of target language is stored as a
			//	element value in a node type LISA_TYPE_TARGET.

			if ( strcmp( node->element, "#php" ) == 0 )
			{
				struct lisa_node *prev = node;

				while ( 1 )
				{
					int i = 0;

					// creating a TARGET node...
					struct lisa_node *work = createNode();
					work->type = LISA_TYPE_TARGET;

					// get a line...
//debug( "get a line..." );
					ch = getCharS();
					while ( ch != '\n' )
					{
						if ( ch == 0 )
							syntaxError( "#/php directive not found" );
						work->element[i++] = ch;
						work->element[i] = '\0';
//debug( work->element );
						ch = getCharS();
					}
					work->element[i] = '\0';
					// check if line readed contains end directive #/php
					if ( strstr( work->element, "#/php" ) )
					{
						// NOTE: (2002-07-03 Gabriele Budelacci)
						//	End directive #/php MUST placed in a single empty
						//	line, elsewere the rest of the line is discarded.
						destroyNode( work );
						work = NULL;
						break;
					}
					prev->args = work;
					prev = work;
				}
			}

			break;
		}
	// identifier ::= (a..z) { (a..z) | '_' | (0..9) }
		case 'a':
		case 'b':
		case 'c':
		case 'd':
		case 'e':
		case 'f':
		case 'g':
		case 'h':
		case 'i':
		case 'j':
		case 'k':
		case 'l':
		case 'm':
		case 'n':
		case 'o':
		case 'p':
		case 'q':
		case 'r':
		case 's':
		case 't':
		case 'u':
		case 'v':
		case 'w':
		case 'x':
		case 'y':
		case 'z':
		{
			// append the char to element
			int i=0;
			node->element[i++] = ch;
			// appending another chars...
			ch = getCharS();
			// lowercasing char...
			if ( ch >= 'A' && ch <= 'Z' )
				ch |= 32;
			while ( strchr( "abcdefghijklmnopqrstuvwxyz_0123456789", ch ) )
			{
				node->element[i++] = ch;
				ch = getCharS();
				if ( ch >= 'A' && ch <= 'Z' )
					ch |= 32;
			}
			// making a push-back action for readed char.
			// Thisn't a good idea, and MUST be fixed in
			// a near future...
			pushbackCharS();

			node->element[i] = '\0';
			node->type       = LISA_TYPE_IDENTIFIER;

			// testing keyword match...
			for ( i=0 ; 1 ; i++ )
			{
				char *s = keywords[i];
				if ( strcmp( s, node->element ) == 0 )
				{
					// founded a keyword!!!
					node->type = LISA_TYPE_KEYWORD;
					break;
				}
				if ( strcmp( s, "END" ) == 0 )
				{
					// no keyword match...
					break;
				}
			}

			break;
		}
	// number ::= (0..9) { (0..9) } [ '.' (0..9) { (0..9) } ]
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
		{
			// append the char to element
			int i=0;
			node->element[i++] = ch;
			// appending another chars...
			ch = getCharS();
			while ( strchr( "0123456789", ch ) )
			{
				node->element[i++] = ch;
				ch = getCharS();
			}
			if ( ch == '.' )
			{
				node->element[i++] = ch;
				// appending another chars...
				ch = getCharS();
				while ( strchr( "0123456789", ch ) )
				{
					node->element[i++] = ch;
					ch = getCharS();
				}
			}
			node->element[i] = '\0';
			node->type       = LISA_TYPE_NUMBER;

			// making a push-back action for readed char.
			// Thisn't a good idea, and MUST be fixed in
			// a near future...
			pushbackCharS();

			break;
		}
	// operator ::= '+' | '-' | '*' | '/' | '%' | '<' | '>' |
	//              '<=' | '>=' | '==' | '!=' | '!' | '&&' |
	//              '||' | '=' | '&' | '|' | ','
		case '+':
		case '-':
		case '*':
		case '%':
		case '.':
		case ',':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_OPERATOR;
			break;
		}
		case '<':
		case '>':
		case '=':
		case '!':
		{
			node->element[0] = ch;
			node->element[1] = '\0';

			// get next element
			ch = getCharS();

			if ( ch == '=' )
			{
				node->element[1] = ch;
				node->element[2] = '\0';
			}
			else
			{
				// making a push-back action for readed char.
				// Thisn't a good idea, and MUST be fixed in
				// a near future...
				pushbackCharS();
			}

			node->type = LISA_TYPE_OPERATOR;
			break;
		}
		case '&':
		{
			node->element[0] = ch;
			node->element[1] = '\0';

			// get next element
			ch = getCharS();

			if ( ch == '&' )
			{
				node->element[1] = ch;
				node->element[2] = '\0';
			}
			else
			{
				// making a push-back action for readed char.
				// Thisn't a good idea, and MUST be fixed in
				// a near future...
				pushbackCharS();
			}

			node->type = LISA_TYPE_OPERATOR;
			break;
		}
		case '|':
		{
			node->element[0] = ch;
			node->element[1] = '\0';

			// get next element
			ch = getCharS();

			if ( ch == '|' )
			{
				node->element[1] = ch;
				node->element[2] = '\0';
			}
			else
			{
				// making a push-back action for readed char.
				// Thisn't a good idea, and MUST be fixed in
				// a near future...
				pushbackCharS();
			}

			node->type = LISA_TYPE_OPERATOR;
			break;
		}
	// remark ::= ( '//' {anychar} EOL ) | ( '/*' {anychar} '*/' )
		case '/':
		{
			node->element[0] = ch;
			node->element[1] = '\0';

			// get next element
			ch = getCharS();

			switch ( ch )
			{
				case '/':
				{
					// remark ::= '//' {anychar} EOL

					// read until EOL...
					while ( ch != '\n')
						ch = getCharS();

					node->type = LISA_TYPE_REMARK;
					break;
				}
				case '*':
				{
					// remark ::= '/*' {anychar} '*/'

					// get next char
					ch = getCharS();

					// read until '*/'...
					while ( 1 )
					{
						// scan for '*'...
						while ( ch != '*' )
							ch = getCharS();
						ch = getCharS();
						// ...and break if '/'...
						if ( ch == '/' )
							break;
					}

					node->type = LISA_TYPE_REMARK;
					break;
				}
				default:
				{
					// operator ::= '/'

					// making a push-back action for readed char.
					// Thisn't a good idea, and MUST be fixed in
					// a near future...
					pushbackCharS();

					node->type = LISA_TYPE_OPERATOR;
				}
			}

			// skip REMARK nodes, get next...
			if ( node->type == LISA_TYPE_REMARK )
			{
				// destroy remark node
				destroyNode( node );
				// get next node
				node = parse();
			}

			break;
		}
	// string ::= '"' { (anychar~'"') | ('\'anychar) } '"'
		case '"':
		{
			int i=0;
			ch = getCharS();
			while ( ch != '"' )
			{
				node->element[i++] = ch;
				if ( ch == '\\' )
				{
					ch = getCharS();
					node->element[i++] = ch;
				}
				ch = getCharS();
			}
			node->element[i] = '\0';
			node->type = LISA_TYPE_STRING;
			break;
		}
	// colon ::= ':'
		case ':':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_COLON;
			break;
		}
	// semicolon ::= ';'
		case ';':
		{
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_SEMICOLON;
			break;
		}
		default:
		{
			// Return an empty node with the unknown char...
			node->element[0] = ch;
			node->element[1] = '\0';
			node->type       = LISA_TYPE_UNKNOWN;
			return node;
		}
	}

	return node;
}//parse





// pushbackNode:
//	Perform a push-back of specified node to the parser.
//	NOTE: This method is criticable!
void pushbackNode( struct lisa_node *node )
{
	pushback_node = node;
}//pushbackNode

