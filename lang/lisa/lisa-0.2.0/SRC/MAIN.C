#include "main.h"


/*
	GLOBALS
*/

FILE *inpstream;				// input stream file descriptor
FILE *outstream;				// output stream file descriptor
char  line[INP_MAX_CHAR+1];		// input readed line
int   line_index;				// current char for readed line
int   line_count;				// current line number
char *script;					// script block buffer
int   script_index;				// current char for stored script block
lisa_environment *global_env;	// ptr to global environment structure

struct lisa_database database;		// this is THE database structure
char *xmldbfile = "config.xml";	// name of the database xml file





/*
	main entry
*/
int main( int argc, char *argv[] )
{
	char ch;
	lisa_node *n, *tmp;	// ptr to a single node
	lisa_node *tree;		// ptr to APT
	int file_name;

	if ( argc == 1 )
	{
		// If no arguments we call the Usage routine and exit
		// Usage( APP_NAME );
		// return 1;
	}

	// NOTE: (2002-07-03 Gabriele Budelacci)
	// The global environment is created in HandleOption procedure...

	// handle the program options
	file_name = HandleOptions( argc, argv );

	if ( file_name == 0 )
	{
		inpstream = stdin;
		outstream = stdout;
		// comment the follow lines in debug versions...
		fprintf( stderr, "%s: No input files\n", APP_NAME );
		exit( 1 );
	}
	else
	{
		char *extension = NULL;

		inpstream = fopen( argv[ file_name ], "r" );
		// using line[] buffer for managing output stream name...
		strncpy( line, argv[ file_name ], INP_MAX_CHAR );
		// find the extension
		extension = strrchr( line, '.' );
		if ( ! extension )
		{
			// no extension founded, placing at the end of input file name
			extension = line + strlen( line );
		}
		switch ( global_env->language )
		{
			case LISA_LANG_PHP:
			{
				strncpy( extension, ".php", 8 );
				outstream = fopen( line, "w" );
				break;
			}
			case LISA_LANG_NONE:
			{
				outstream = stdout;
				break;
			}
		}
	}

	// handling error on streams...
	if ( ! inpstream )
	{
		fprintf( stderr, "Unable to open file: %s\n", argv[ file_name ] );
		exit( 0 );
	}
	if ( ! outstream )
	{
		fprintf( stderr, "Unable to open file: %s\n", argv[ file_name ] );
		exit( 0 );
	}

	line[0] = '\0';		// empty readed line
	line_index = 0;		// current char for readed line
	line_count = 1;		// current line number
	// this string is reserved for script blocks...
	script = (char*) malloc( SCRIPT_MAX_CHAR );
	// NOTE: (2002-06-25 Gabriele Budelacci)
	//	"script" is allocated dinamically, so if you need
	//	more space, you can specify it via a compiler option.
	script_index = 0;	// current char for stored script block

	// inp = fopen( argv[ file_name ], "r" );

	// processing database xml comfiguration file...
	processXMLDatabase( &database, xmldbfile );

	switch ( global_env->language )
	{
		case LISA_LANG_PHP:
		{
			// create the database driver only if module generation is disabled...
			if ( global_env->module == LISA_MODULE_OFF )
			{
				switch ( database.type )
				{
					case LISA_DBTYPE_MYSQL:
					{
						writeMySQLdriver( database.host, database.name, database.username, database.password );
					}
				}
			}

			// write headers only if module generation is disabled...
			if ( global_env->module == LISA_MODULE_OFF )
			{
				fprintf( outstream, "<?\n" );
				fprintf( outstream, "session_start();\n" );
				fprintf( outstream, "session_register( \"SESSION\" );\n" );
				fprintf( outstream, "if ( ! isset( $SESSION ) )\n" );
				fprintf( outstream, "{\n" );
				fprintf( outstream, "\t$SESSION['_l_s_i_'] = 0;\n" );
				fprintf( outstream, "}\n" );
				fprintf( outstream, "mt_srand ((double) microtime() * 1000000);\n" );
				fprintf( outstream, "require( 'std.php' );\n" );
				if ( database.valid )
				{
					fprintf( outstream, "$_link_ = 0;\n" );
					fprintf( outstream, "_database_();\n" );
					fprintf( outstream, "$_array_ = array();\n" );
					fprintf( outstream, "require( 'dbsupport.php' );\n" );
				}
				fprintf( outstream, "?>\n" );
			}
			break;
		}
	}

	while ( 1 )
	{
		// processing HTML code...
//debug( "processing HTML code..." );
		ch = processHTML();

		switch ( ch )
		{
			// EOF reached if ch==0...
			case 0:
			{
				switch ( global_env->language )
				{
					case LISA_LANG_PHP:
					{
						// write headers only if module generation is disabled...
						if ( global_env->module == LISA_MODULE_OFF )
						{
							if ( database.valid )
							{
								fprintf( outstream, "<?\n" );
								fprintf( outstream, "_close_();\n" );
								fprintf( outstream, "?>\n" );
							}
						}
						break;
					}
				}
				exit( 0 );
			}

			// Script block...
			case '%':
				// get the whole script block...
//debug( "get the whole script block..." );
				getScript();
				// APT is empty initially
				tree = createNode();
				tmp = tree;
				// initialize the parser
				initParser();
				// read the first node
				n = lex( LISA_SCOPE_EXPRESSION | LISA_SCOPE_STATEMENT | LISA_SCOPE_EMPTY );
				// if it's a TAG type node, then break...
				if ( n->type != LISA_TYPE_TAGKEYWORD )
				{
					// read the other nodes...
					while ( ! emptyNode( n ) )
					{
						tmp->next = n;
						tmp = n;
						n = lex( LISA_SCOPE_EXPRESSION | LISA_SCOPE_STATEMENT | LISA_SCOPE_EMPTY );
					}
				}
				else
				{
					n->next = createNode();
				}
				tmp->next = n;
				// NOTE: (2002-07-06 Gabriele Budelacci)
				//	Others statements in the same block of a TAG keyword
				//	are discarged, an this isn't a good idea!!!

				tmp = tree->next;
				if ( ! emptyNode( tmp ) )
				{
					startScript();

					// evaluating...
					while ( ! emptyNode( tmp ) )
					{
						eval( tmp, global_env );
						tmp = tmp->next;
					}

					stopScript();
				}

				// destroying APT...
				destroyNodeR( tree );

				break;

			// Expression value...
			case '=':
				// get the whole script block...
				getScript();
				// APT is empty initially
				tree = createNode();
				// initialize the parser
				initParser();
				// read the first node
				n = lex( LISA_SCOPE_CONDITION | LISA_SCOPE_EMPTY );

				// NOTE: (2002-07-02 Gabriele Budelacci)
				//	I must create a dummy node for condition evaluation.
				tree->next = createNode();
				tree->next->type = LISA_TYPE_CONDITION;
				tree->next->args = n;

				// check if another node
				n = lex( LISA_SCOPE_EXPRESSION | LISA_SCOPE_SEMICOLON | LISA_SCOPE_EMPTY );
				if ( ! emptyNode( n ) )
					error( "no more than one expressions allowed" );
				tree->next->next = n;

				tmp = tree->next;
				if ( ! emptyNode( tmp ) )
				{
					startExpression();

					// evaluating...
					eval( tmp, global_env );

					stopScript();
				}

				// destroying APT...
				destroyNodeR( tree );

				break;

			// Unimplemented code...
			default:
				error( "INTERNAL ERROR:\n\tUnimplemented block type" );
		}
	}

	// closing input stream...
	fclose( inpstream );
	// closing output stream...
	fclose( outstream );

	exit( 0 );
	return 0;
}//main





// HandleOptions:
//	returns the index of the first argument that is not an option; i.e.
//	does not start with a dash or a slash.
int HandleOptions( int argc,char *argv[] )
{
	int i, firstnonoption = 0;
	int language, module;

	// NOTE: (2002-06-27 Gabriele Budelacci)
	// I use PHP language for debugging. The language selection
	// must be performed via a --option to the compiler...
	language = LISA_LANG_NONE;
	// by default, module generation is disabled:
	module = LISA_MODULE_OFF;

	for ( i=1 ; i<argc ; i++ )
	{
		if ( argv[i][0] == '/' || argv[i][0] == '-')
		{
			switch ( argv[i][1] )
			{
				// An argument -? means help is requested
				case '?':
					Usage( APP_NAME );
					break;
				case 'h':
				case 'H':
					if ( !strcmp( argv[i]+1, "help" ) )
					{
						Usage( APP_NAME );
						return 0;
					}
					/* If the option -h means anything else
					   in your application add code here
					   Note: this falls through to the default
					   to print an "unknow option" message
					*/
					return 0;
					break;
				case 'm':
					module = LISA_MODULE_ON;
					break;
				case 'p':
					language = LISA_LANG_PHP;
					break;
				case '-':
					if ( !strcmp( argv[i]+2, "help" ) )
					{
						Usage( APP_NAME );
						exit( 0 );
					}
					if ( !strcmp( argv[i]+2, "module" ) )
					{
						module = LISA_MODULE_ON;
						break;
					}
					if ( !strcmp( argv[i]+2, "php" ) )
					{
						language = LISA_LANG_PHP;
						break;
					}
					if ( !strcmp( argv[i]+2, "version" ) )
					{
						Version();
						exit( 0 );
						break;
					}
					/* If the option -h means anything else
					   in your application add code here
					   Note: this falls through to the default
					   to print an "unknow option" message
					*/
					break;
				// add your option switches here
				default:
					fprintf( stderr, "unknown option %s\n", argv[i] );
					break;
			}
		}
		else
		{
			firstnonoption = i;
			break;
		}
	}

	// creating the global environment correctly
	global_env = createEnvironment( language );
	global_env->module = module;

	return firstnonoption;

}//HandleOptions





// Usage:
//	Display 'usage' string information.
void Usage( char *programName )
{
	fprintf( stderr, "\nusage: %s [options] filename\n\n", APP_NAME );
	fprintf( stderr, "Recognized options are:\n" );
	fprintf( stderr, "\n" );
	fprintf( stderr, "\t--asp, -a\tSet ASP target language (unimplemented yet)\n" );
	fprintf( stderr, "\t--jsp, -j\tSet JSP target language (unimplemented yet)\n" );
	fprintf( stderr, "\t--php, -p\tSet PHP target language\n" );
	fprintf( stderr, "\n" );
	fprintf( stderr, "\t--module, -m\tGenerate a module\n" );
	fprintf( stderr, "\n" );
	fprintf( stderr, "\t--help, -h\tShow this message\n" );
	fprintf( stderr, "\t--version\tShow version information\n" );
	fprintf( stderr, "\n" );
	fprintf( stderr, "%s v%s, %s\n", APP_NAME, APP_VERSION, APP_DATE );
	fprintf( stderr, "Copyright (c)2002 Gabriele Budelacci\n" );
	fprintf( stderr, "See COPYING file for license\n" );
	/* Modify here to add your usage message when the program is
	 * called without arguments */
}//Usage





// Version:
//	Display 'version' information.
void Version( void )
{
	fprintf( stderr, "%s v%s, %s\n", APP_NAME, APP_VERSION, APP_DATE );
}//Version





// appendNode:
//	Append a node to the specified list.
void appendNode( lisa_node *node, lisa_node *list )
{
	struct lisa_node *tmp;

	if ( list )
	{
		tmp = list;
		// scan for end of list...
		while ( tmp->next )
			tmp = tmp->next;
		// appending the node...
		tmp->next = node;
	}
}//appendNode





// createEnvironment:
//	Create an environment structure.
lisa_environment *createEnvironment( int language )
{
	lisa_environment *env = malloc( sizeof( lisa_environment ) );
	if ( env )
	{
		env->global     = env;
		env->parent     = env;
		env->language   = language;
		env->module     = LISA_MODULE_OFF;
		env->globals    = createNode();
		env->parameters = createNode();
		env->declared   = createNode();
		env->loops      = createNode();
	}
	return env;
}//createEnvironment





// childEnvironment:
//	Clone an environment for a child script block.
lisa_environment *childEnvironment( lisa_environment *env )
{
	struct lisa_environment *e = NULL;
	struct lisa_node        *n = NULL;

	if ( env )
	{
		// creating the new environment...
		e = createEnvironment( LISA_LANG_NONE );
		// ...and filling with existing data...
		memcpy( e, env, sizeof( lisa_environment ) );
		e->globals    = cloneNode( env->globals );
		e->parameters = cloneNode( env->parameters );
		e->declared   = cloneNode( env->declared );
		e->loops      = cloneNode( env->loops );
		// making global variables unchangeable...
		n = e->declared->next;	// skip initial empty node
		while ( n )
		{
			if ( findNodeByElement( n->element, e->globals ) )
			{
				if ( n->type > 0 ) n->type = -n->type;
			}
			else
			{
				if ( n->type < 0 ) n->type = -n->type;
			}
			n = n->next;
		}
		// ...last, setting the parent environment...
		e->parent  = env;
	}
	return e;
}//childEnvironment





// cloneNode:
//	Clone a node and, recursively, everyone present
//	in args and next lists.
lisa_node *cloneNode( lisa_node *node )
{
	lisa_node *n = NULL;
	if ( node )
	{
		// copying the existing node...
		n = copyNode( node );
		// ...and filling with existing data...
		memcpy( n, node, sizeof( lisa_node ) );
		// ...finally, do it recursivelly...
		n->args = cloneNode( node->args );
		n->next = cloneNode( node->next );
	}
	return n;
}//cloneNode





// copyNode:
//	Copy a node without args and next lists.
//	USE WITH CAUTIONS !!!
lisa_node *copyNode( lisa_node *node )
{
	lisa_node *n = NULL;
	if ( node )
	{
		// creating the new node...
		n = createNode();
		// ...and filling with existing data...
		memcpy( n, node, sizeof( lisa_node ) );
	}
	return n;
}//copyNode





// createNode:
//	Create an empty node structure.
lisa_node *createNode( void )
{
	lisa_node *node = malloc( sizeof( lisa_node ) );
	if ( node )
	{
		// set the node as a EMPTY node...
		node->args       = NULL;
		node->next       = NULL;
		node->element[0] = '\0';
		node->type       = 0;
		node->line       = line_count;
	}
	return node;
}//createNode





// debug:
//	Display a debug message.
void debug( char *msg )
{
	fprintf( stderr, "%s\n", msg );
}//debug





// destroyEnvironment:
//	Destroy an environment.
void destroyEnvironment( lisa_environment *env )
{
	destroyNodeR( env->globals );
	destroyNodeR( env->parameters );
	destroyNodeR( env->declared );
	destroyNodeR( env->loops );
	if ( env )
		free( env );
}//destroyEnvironment





// destroyNode:
//	Destroy a node.
void destroyNode( lisa_node *node )
{
	if ( node )
		free( node );
}//destroyNode





// destroyNodeR:
//	Destroy a node recursivelly.
void destroyNodeR( lisa_node *node )
{
	// destroy the args chain...
	if ( node->args )
		destroyNodeR( node->args );
	// destroy the next chain...
	if ( node->next )
		destroyNodeR( node->next );
	// finally, destroy the node...
	destroyNode( node );
}//destroyNodeR





// emptyNode:
//	Return TRUE (!= 0) if the node is an empty node.
int emptyNode( lisa_node *node )
{
	if ( node->type )
		return 0;
	return -1;
}//emptyNode





// error:
//	Display a error message and exit.
void error( char *msg )
{
	fprintf( stderr, "%s at line %d\n", msg, line_count );
	exit( 1 );
}//error





// extractNode:
//	Extract a node from the list. On error,
//	a NULL value is returned.
lisa_node *extractNode( lisa_node *node, lisa_node *list )
{
	struct lisa_node *tmp;

	if ( list )
	{
		// searching node...
		tmp = list;
		while ( tmp->next )
		{
			if ( tmp->next == node )
			{
				tmp->next = node->next;
				node->next = NULL;
				// Now, node is no more linked...
				return node;
			}
			tmp = tmp->next;
		}
	}

	// node not founded...
	return NULL;

}// extractNode





// findNodeByElement:
//	Return a node searching it by the element string.
//	On error, return a NULL value.
lisa_node *findNodeByElement( char *element, lisa_node *list )
{
	struct lisa_node *tmp;

	if ( list )
	{
		// searching node...
		tmp = list;
		while ( tmp )
		{
			if ( strcmp( tmp->element, element ) == 0 )
			{
				// Founded!!!
				return tmp;
			}
			tmp = tmp->next;
		}
	}

	// node not founded...
	return NULL;

}//findNodeByElement





// getChar:
//	Get the next char from the input stream.
//	Return 0 if EOF;
char getChar( void )
{
	char ch;

	// get current char from the line
	ch = line[ line_index ];
	if ( ch == '\0' )
	{
		// empty the previous line...
		line[0] = '\0';
		// ...read a whole line...
		fgets( line, INP_MAX_CHAR, inpstream );
		// ...and get first char
		line_index = 0;
		ch = line[ line_index ];
	}

	// second '\0' means EOF reached
	if ( ch == '\0' )
	{
		return 0;
	}

	// increase line number...
	if ( ch == '\n' )
	{
		line_count += 1;
	}

	// increase index for next time
	line_index += 1;

	// return current char
	return ch;
}//getChar





// getCharS:
//	Get the next char from stored script block.
//	Return 0 if EOF;
char getCharS( void )
{
	char ch;

	// get current char from the line
	ch = script[ script_index ];
	if ( ch != '\0' )
	{
		// increase index for next time
		script_index += 1;
	}

	// return current char
	return ch;
}//getCharS





// getScript
//	Get the whole script block until end tag ('%>')
//	into the default buffer.
void getScript( void )
{
	char ch;
	int  l;

	// restoring the index;
	script_index = 0;

	l = line_count;
	ch = getChar();
	// ch = 0 means End Of File reached!!!
	while ( ch != 0 )
	{
		// break if '%>' reached...
		if ( ch == '%' )
		{
			ch = getChar();
			if ( ch == '>' )
			{
				// End of Script Block reached!!!
				break;
			}
			putCharS( '%' );
		}
		putCharS( ch );
		ch = getChar();
	}

	if ( ch == 0 )
		error( "Unclosed Script Block" );

	// NOTE: (2002-06-25 Gabriele Budelacci)
	// Appending a '\n' char to prevent errors when
	// parsing "// comment... %>" in the same line.
	putCharS( '\n' );

	// End of Script
	putCharS( '\0' );

	// restoring the index;
	script_index = 0;

	// restoring the line count;
	line_count = l;
}//getScript





// popNode
//	Extract the last node in a list (STACK like use).
//	Returns NULL if the list is empty.
lisa_node *popNode( lisa_node *list )
{
	struct lisa_node *tmp = NULL;
	struct lisa_node *t   = NULL;

	if ( list )
	{
		if ( list->next )
		{
			tmp = list;
			// scan for end of list...
			while ( tmp->next->next )
				tmp = tmp->next;
		}
	}

	if ( tmp )
	{
		t = tmp->next;
		tmp->next = NULL;
	}

	return t;
}//popNode





// processHTML
//	Process the HTML source until a code block
//	('<% ... %>' or '<%= ... %>') has reached.
//	Returns the last character readed from the
//	input stream.
char processHTML( void )
{
	char ch;

	ch = getChar();
	// ch = 0 means End Of File reached!!!
	while ( ch != 0 )
	{
		// break if '<%' or '<%=' reached...
		if ( ch == '<' )
		{
			ch = getChar();
			if ( ch == '%' )
			{
				// Start of Script Block reached!!!
				ch = getChar();
				if ( ch != '=' )
				{
					pushbackChar();
					ch = '%';
				}
				break;
			}
			putChar( '<' );
		}
		putChar( ch );
		ch = getChar();
	}

	// NOTE: (2002-06-24 Gabriele Budelacci)
	// ch = 0   if EOF reached, or
	// ch = '%' if a simple block script has founded, or
	// ch = '=' if an output block script has founded...
	return ch;
}//processHTML





// pushNode
//	Insert a node in a list (STACK like use).
void pushNode( lisa_node *node, lisa_node *list )
{
	appendNode( node, list );
}//pushNode





// pushbackChar:
//	Perform a push-back of last char on
//	the input stream.
//	NOTE: This method is criticable!
void pushbackChar( void )
{
	if ( line_index > 0 )
		line_index -= 1;
}//pushbackChar





// pushbackCharS:
//	Perform a push-back of last char on
//	the stored script block.
//	NOTE: This method is criticable!
void pushbackCharS( void )
{
	if ( script_index > 0 )
		script_index -= 1;
}//pushbackCharS





// putChar:
//	Put a char to the output stream.
void putChar( char ch )
{
	fputc( ch, outstream );
}//putChar





// putCharS:
//	Put a char to the script block.
void putCharS( char ch )
{
	script[ script_index ] = ch;
	script_index += 1;
}//putCharS





// startScript:
//	Write the start tag script to the output stream.
void startScript( void )
{
	switch ( global_env->language )
	{
		case LISA_LANG_PHP:
			fprintf( outstream, "<? " );
			break;
		default:
			fprintf( outstream, "<%% " );
	}
}//startScript





// startExpression:
//	Write the start expression tag script to the output stream.
void startExpression( void )
{
	switch ( global_env->language )
	{
		case LISA_LANG_PHP:
			fprintf( outstream, "<?= " );
			break;
		default:
			fprintf( outstream, "<%%= " );
	}
}//startExpression





// stopScript:
//	Write the stop tag script to the output stream.
void stopScript( void )
{
	switch ( global_env->language )
	{
		case LISA_LANG_PHP:
			fprintf( outstream, " ?>" );
			break;
		default:
			fprintf( outstream, " %%>" );
	}
}//stopScript

