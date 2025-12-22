#include "xml.h"

#include <stdio.h>
#include <string.h>

/*
	GLOBALS
*/
char  line[INP_MAX_CHAR+1];		// input readed line
int   line_index;				// current char for readed line

// NOTE:
// 'END' keyword or directive is used while searching tags into the array.
// See 'parse' function on identifier match for an example...

// recognized tags
char *tags[] = { "database", "db-dsn", "db-host", "db-name", "db-password", "db-port",
				 "db-type", "db-username", "jdbc", "jdbc-driver", "jdbc-string",
				 "END" };

// db types
char *dbtypes[] = { "mysql",
					"END" };

// used for push-back
//	if this ptr not equals NULL, the parse() function will return this value...
lisa_node *pushback_XML_node = NULL;

// this is the XML stream
FILE *xml_stream = NULL;





/*
	FUNCTIONS
*/


// getXMLChar:
//	Get the next char from the xml stream.
//	Return 0 if EOF;
char getXMLChar( void )
{
	char ch;

	// get current char from the line
	ch = line[ line_index ];
	if ( ch == '\0' )
	{
		// empty the previous line...
		line[0] = '\0';
		// ...read a whole line...
		fgets( line, INP_MAX_CHAR, xml_stream );
		// ...and get first char
		line_index = 0;
		ch = line[ line_index ];
	}

	// second '\0' means EOF reached
	if ( ch == '\0' )
	{
		return 0;
	}

	// increase index for next time
	line_index += 1;

	// return current char
	return ch;
}//getXMLChar





// initXMLParser:
//	Initialize the parser.
void initXMLParser( FILE *stream )
{
	// empty pushback buffer...
	if ( pushback_XML_node != NULL )
	{
		destroyNodeR( pushback_XML_node );
		pushback_XML_node = NULL;
	}

	// set the input stream...
	xml_stream = stream;
}//initXMLParser





// parseXML:
//	Parse the xml stream and return a node (token).
//	On error (ie: EOF), return a empty node.
//
//	The SYNTAX is: (pseudo-BNF)
//
//		XML control tag ::= '<?' something '?>'
//		remark          ::= '<!--' anychar '-->'
//		lisa tag        ::= '<' tags '>'
//		                    '</' tags '>'
//		value           ::= { anychar }
lisa_node *parseXML( void )
{
	lisa_node     *node = NULL;
	unsigned char ch;

	// return the push-back node if exists...
	if ( pushback_XML_node != NULL )
	{
		node = pushback_XML_node;
		pushback_XML_node = NULL;
		return node;
	}

	// create a empty node
	node = createNode();

	ch = getXMLChar();

	// ignoring initial blanks...
	while ( strchr( " \t\n\r", ch ) )
	{
		if ( ch == 0 )
		{
			// if no more chars, return a empty node...
			return node;
		}

		// get next char
		ch = getXMLChar();
	}

	switch ( ch )
	{
		case '\0':
		{
			// if no more chars, return a empty node...
			return node;
		}

	// tag ::= '<' anychar... '>'
		case '<':
		{
			int i=0;
			node->element[i] = '\0';
			// search for another char...
			ch = getXMLChar();
			// lowercasing char...
			if ( ch >= 'A' && ch <= 'Z' )
				ch |= 32;

			switch ( ch )
			{
			// XML tag
				case '?':
				{
					// read until '?>'...
					ch = getXMLChar();
					while ( 1 )
					{
						// test for '?'...
						while ( ch != '?' )
						{
							node->element[ i++ ] = ch;
							ch = getXMLChar();
						}
						// test for '>'...
						ch = getXMLChar();
						if ( ch == '>' )
						{
							break;
						}
						else
						{
							node->element[ i++ ] = '?';
							node->element[ i++ ] = ch;
						}
					}
					node->element[ i ] = '\0';
					node->type         = XML_DEFINITION_TAG;
					break;
				}
			// remark tag
				case '!':
				{
					// check for '--'...
					ch = getXMLChar();
					if ( ch != '-' ) error( "bad XML <!-- --> tag" );
					ch = getXMLChar();
					if ( ch != '-' ) error( "bad XML <!-- --> tag" );
					// read until '-->'...
					ch = getXMLChar();
					while ( 1 )
					{
						// test for '-'...
						while ( ch != '-' )
						{
							node->element[ i++ ] = ch;
							ch = getXMLChar();
						}
						// test for '-'...
						ch = getXMLChar();
						if ( ch != '-' )
						{
							node->element[ i++ ] = '-';
							node->element[ i++ ] = ch;
						}
						else
						{
							// test for '>'...
							ch = getXMLChar();
							if ( ch != '>' )
							{
								node->element[ i++ ] = '-';
								node->element[ i++ ] = '-';
								node->element[ i++ ] = ch;
							}
							else
							{
								break;
							}
						}
					}
					node->element[ i ] = '\0';
					node->type         = XML_REMARK_TAG;
					break;
				}
			// end tag
				case '/':
				{
					ch = getXMLChar();
					// lowercasing char...
					if ( ch >= 'A' && ch <= 'Z' )
						ch |= 32;
					while ( strchr( "abcdefghijklmnopqrstuvwxyz_0123456789-", ch ) )
					{
						node->element[i++] = ch;
						ch = getXMLChar();
						if ( ch >= 'A' && ch <= 'Z' )
							ch |= 32;
					}
					node->element[i] = '\0';
					node->type       = XML_LISA_ENDTAG;

					// check for end tag '>' char
					if ( ch != '>' ) error( "bad XML lisa tag" );

					// testing tags match...
					for ( i=0 ; 1 ; i++ )
					{
						char *s = tags[ i ];
						if ( strcmp( s, node->element ) == 0 )
						{
							// founded a valid tag!!!
							node->type = XML_LISA_ENDTAG;
							break;
						}
						if ( strcmp( s, "END" ) == 0 )
						{
							// no tags match...
							error( "unknown XML tag" );
							break;
						}
					}

					break;
				}
			// lisa tag
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
					// lowercasing char...
					if ( ch >= 'A' && ch <= 'Z' )
						ch |= 32;
					while ( strchr( "abcdefghijklmnopqrstuvwxyz_0123456789-", ch ) )
					{
						node->element[i++] = ch;
						ch = getXMLChar();
						if ( ch >= 'A' && ch <= 'Z' )
							ch |= 32;
					}
					node->element[i] = '\0';
					node->type       = XML_LISA_TAG;

					// check for end tag '>' char
					if ( ch != '>' ) error( "bad XML lisa tag" );

					// testing tags match...
					for ( i=0 ; 1 ; i++ )
					{
						char *s = tags[ i ];
						if ( strcmp( s, node->element ) == 0 )
						{
							// founded a valid tag!!!
							node->type = XML_LISA_TAG;
							break;
						}
						if ( strcmp( s, "END" ) == 0 )
						{
							// no tags match...
							error( "unknown XML tag" );
							break;
						}
					}

					break;
				}
			// BAD TAG DEFINITION!!!
				default:
				{
					error( "bad XML configuration file" );
				}
			}

			break;
		}// case '>'

	// value  ::= { anychar }
		default:
		{
			int i = 0;
			// ignore initials blank spaces...
			while ( strchr( " \t\n\r", ch ) )
				ch = getXMLChar();
			// get the whole value...
			while ( ch != '<' )
			{
				node->element[i++] = ch;
				ch = getXMLChar();
				if ( strchr( "\t\r\n", ch ) ) ch = ' ';
			}
			node->element[i] = '\0';
			node->type       = XML_VALUE;
			// trim endings blank chars...
			if ( i > 0 )
			{
				while ( strchr( " \t\n\r", node->element[ i-1 ] ) )
				{
					node->element[ i-1 ] = '\0';
					i -= 1;
					if ( i == 0 ) break;
				}
			}

			// making a push-back of the '<' char
			pushbackXMLChar();
		}
	}

	return node;
}//parseXML





// processXMLStream:
//	Process a XML stream in a specified method.
void processXML( struct lisa_database *database, int method )
{
	struct lisa_node *tag, *value, *last;

	if ( method == LISA_XML_ROOT )
	{
		// get the <?xml?> tag...
		tag = parseXML();
		if ( tag->type != XML_DEFINITION_TAG )
		{
			error( "bad XML file, needed <?xml?> tag" );
		}
		destroyNode( tag );
	}

	// process lisa tags
	tag = parseXML();

	// skip remark tags...
	// ...and definition tags...
	while ( ( tag->type == XML_REMARK_TAG ) || ( tag->type == XML_DEFINITION_TAG ) )
	{
		destroyNode( tag );
		tag = parseXML();
	}

	if ( tag->type != XML_LISA_TAG )
		error( "bad XML file" );

	switch ( method )
	{
		case LISA_XML_ROOT:
		{
			destroyNode( tag );
			last = parseXML();
			while ( last->type != XML_LISA_ENDTAG )
			{
				pushbackXMLNode( last );
				// process database struct...
				processXML( database, LISA_XML_DATABASE );
				// check for </database>...
				last = parseXML();
			}
			if ( strcmp( last->element, "database" ) != 0 )
			{
				debug( last->element );
				error( "bad XML file, needed </database> tag" );
			}
			destroyNode( last );
			return;
		}
		case LISA_XML_DATABASE:
		{
			int i;

			if ( strcmp( tag->element, "db-dsn" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					destroyNode( value );
					break;
				}
				// check for dsn...
				if ( strlen( value->element ) != 0 )
				{
					strcpy( database->dsn, value->element );
				}
				// check for </db-dsn>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "db-dsn" ) != 0 ) )
					error( "bad XML file, needed </db-dsn> tag" );
				destroyNode( last );
			}

			if ( strcmp( tag->element, "db-host" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					strcpy( database->host, "127.0.0.1" );
					destroyNode( value );
					break;
				}
				// NOTE: (2002-08-10 Gabriele Budelacci)
				//	No host name means localhost.
				if ( strlen( value->element ) != 0 )
				{
					strcpy( database->host, value->element );
				}
				else
				{
					strcpy( database->host, "127.0.0.1" );
				}
				// check for </db-host>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "db-host" ) != 0 ) )
					error( "bad XML file, needed </db-host> tag" );
				destroyNode( last );
			}

			if ( strcmp( tag->element, "db-name" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					error( "no database name specified" );
					destroyNode( value );
					break;
				}
				if ( strlen( value->element ) != 0 )
				{
					strcpy( database->name, value->element );
				}
				else
				{
					error( "no database name specified" );
					break;
				}
				// check for </db-name>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "db-name" ) != 0 ) )
					error( "bad XML file, needed </db-name> tag" );
				destroyNode( last );
			}

			if ( strcmp( tag->element, "db-password" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					destroyNode( value );
					break;
				}
				// check for password...
				if ( strlen( value->element ) != 0 )
				{
					strcpy( database->password, value->element );
				}
				// check for </db-passord>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "db-password" ) != 0 ) )
					error( "bad XML file, needed </db-password> tag" );
				destroyNode( last );
			}

			if ( strcmp( tag->element, "db-port" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					destroyNode( value );
					break;
				}
				// NOTE: (2002-08-10 Gabriele Budelacci)
				//	Port number 0 means default port for specified database.
				database->port = atoi( value->element );
				// check for </db-port>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "db-port" ) != 0 ) )
					error( "bad XML file, needed </db-port> tag" );
				destroyNode( last );
			}

			if ( strcmp( tag->element, "db-type" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					error( "no database type specified" );
					destroyNode( value );
					break;
				}
				// lowercasing value...
				for ( i=0 ; i<strlen( value->element ) ; i++ )
				{
					char ch = value->element[i];
					if ( ch >= 'A' && ch <= 'Z' )
						ch |= 32;
					value->element[i] = ch;
				}
				// testing types match...
				for ( i=0 ; 1 ; i++ )
				{
					char *s = dbtypes[ i ];
					if ( strcmp( s, value->element ) == 0 )
					{
						// founded a valid tag!!!
						// Note: (2002-09-05 Gabriele Budelacci)
						//	I write the index i plus 1, because 0 value means
						//	'no database' (see main.h database.types defines).
						database->type = i + 1;
						break;
					}
					if ( strcmp( s, "END" ) == 0 )
					{
						// no types match...
						debug( value->element );
						error( "unsupported database type tag" );
						break;
					}
				}
				// check for </db-type>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "db-type" ) != 0 ) )
					error( "bad XML file, needed </db-type> tag" );
				destroyNode( last );
			}

			if ( strcmp( tag->element, "db-username" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					destroyNode( value );
					break;
				}
				// check for username...
				if ( strlen( value->element ) != 0 )
				{
					strcpy( database->username, value->element );
				}
				// check for </db-username>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "db-username" ) != 0 ) )
					error( "bad XML file, needed </db-username> tag" );
				destroyNode( last );
			}

			if ( strcmp( tag->element, "jdbc" ) == 0 )
			{
				destroyNode( tag );
				last = parseXML();
				while ( last->type != XML_LISA_ENDTAG )
				{
					pushbackXMLNode( last );
					// process jdbc struct...
					processXML( database, LISA_XML_JDBC );
					// check for </jdbc>...
					last = parseXML();
				}
				if ( strcmp( last->element, "jdbc" ) != 0 )
				{
					error( "bad XML file, needed </jdbc> tag" );
				}
				destroyNode( last );
				break;
			}

			break;
		}
		case LISA_XML_JDBC:
		{
			if ( strcmp( tag->element, "jdbc-driver" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					destroyNode( value );
					break;
				}
				// check for driver name...
				if ( strlen( value->element ) != 0 )
				{
					strcpy( database->jdbc_driver, value->element );
				}
				// check for </jdbc-driver>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "jdbc-driver" ) != 0 ) )
					error( "bad XML file, needed </jdbc-driver> tag" );
				destroyNode( last );
			}

			if ( strcmp( tag->element, "jdbc-string" ) == 0 )
			{
				// get the value
				value = parseXML();
				if ( value->type == XML_LISA_ENDTAG )
				{
					destroyNode( value );
					break;
				}
				// check for connection string...
				if ( strlen( value->element ) != 0 )
				{
					strcpy( database->jdbc_string, value->element );
				}
				// check for </jdbc-string>...
				last = parseXML();
				if ( ( last->type != XML_LISA_ENDTAG ) || ( strcmp( last->element, "jdbc-string" ) != 0 ) )
					error( "bad XML file, needed </jdbc-string> tag" );
				destroyNode( last );
			}

			break;
		}
	}
}//processXML




// processXMLDatabase:
//	this function process the database XML configuration file
//	and place the values into the specified structure.
void processXMLDatabase( struct lisa_database *database, char *filename )
{
	FILE *f;

	// firsts, empty database struct values...
	memset( database, 0, sizeof( struct lisa_database ) );

	// open the XML stream
	f = fopen( filename, "r" );
	// process the XML stream
	if ( f )
	{
		// initialize the XML parser...
		initXMLParser( f );

		// process the XML stream...
		processXML( database, LISA_XML_ROOT );

		// close the XML stream
		fclose( f );
	}

	// validating database info...
	database->valid = 1;

}//processXMLDatabase





// pushbackXMLChar:
//	Perform a push-back of last char on
//	the xml stream.
//	NOTE: This method is criticable!
void pushbackXMLChar( void )
{
	if ( line_index > 0 )
		line_index -= 1;
}//pushbackXMLChar





// pushbackXMLNode:
//	Perform a push-back of specified node to the parser.
//	NOTE: This method is criticable!
void pushbackXMLNode( struct lisa_node *node )
{
	pushback_XML_node = node;
}//pushbackXMLNode

