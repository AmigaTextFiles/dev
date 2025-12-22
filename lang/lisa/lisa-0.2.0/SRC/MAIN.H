#ifndef _LISA_MAIN_H
#define _LISA_MAIN_H

// this is the APP info
#define APP_NAME    "lisac"
#define APP_VERSION "0.2.0"
#define APP_DATE    "2002-09-06"
// Maximum chars per line for input stream
#define INP_MAX_CHAR 4095
// Max sixe of a contiguous script block...
#define SCRIPT_MAX_CHAR 400000


#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/*
	STRUCTURES
*/

// lisa_node
//	APT node implementation
typedef struct lisa_node
{
	struct lisa_node *args;		// ptr to args tree
	struct lisa_node *next;		// ptr to next tree
	char               element[1024];
	char               type;		// see TYPES below...
	int                line;		// line in the source file
} lisa_node;



// lisa_environment
//	Interpreting/compiling dedicated environment
typedef struct lisa_environment
{
	struct lisa_environment *global;		// ptr to root env
	struct lisa_environment *parent;		// ptr to parent env
	int                      language;		// target language to compile (see below...)
	int                      module;		// generating module (see below...)
	struct lisa_node        *globals;		// list of global vars
	struct lisa_node        *parameters;	// list of parameter vars
	struct lisa_node        *declared;		// list of declared vars
	struct lisa_node        *loops;			// list of loop types ( for 'foreach:' tags )
} lisa_environment;



// lisa_environment
//	Interpreting/compiling dedicated environment
typedef struct lisa_database
{
	int  valid;					// != 0 if this is a valid structure

    int  type;					// see below...
	char host[ 256 ];			// host name
	int  port;
	char name[ 4096 ];			// database name
	char dsn[ 4096 ];			// data source name
	char username[ 4096 ];		// username database access
	char password[ 4096 ];		// password database access

	char jdbc_driver[ 4096 ];	// JDBC driver class
	char jdbc_string[ 4096 ];	// JDBC driver connection string
} lisa_database;




/*
	TYPES
*/

// lisa_environment.languages
#define LISA_LANG_NONE 0	// no compiling
#define LISA_LANG_PHP  1	// php compiling



// lisa_environment.module
#define LISA_MODULE_OFF 0	// module generation disabled
#define LISA_MODULE_ON  1	// module generation enabled



// lisa_node.type
#define LISA_TYPE_NULL                  0	// empty type
#define LISA_TYPE_IDENTIFIER            1	// identifier
#define LISA_TYPE_BRACKET               2	// open or close bracket
#define LISA_TYPE_NUMBER                3	// decimal or integer number
#define LISA_TYPE_STRING                4	// string
#define LISA_TYPE_KEYWORD               5	// keyword language
#define LISA_TYPE_OPERATOR              6	// operator
#define LISA_TYPE_DIRECTIVE             7	// directive to the compiler
#define LISA_TYPE_REMARK                8	// remark
#define LISA_TYPE_OPEN_ROUND_BRACKET    9	// open or close bracket
#define LISA_TYPE_CLOSE_ROUND_BRACKET  10	// open or close bracket
#define LISA_TYPE_OPEN_SQUARE_BRACKET  11	// open or close bracket
#define LISA_TYPE_CLOSE_SQUARE_BRACKET 12	// open or close bracket
#define LISA_TYPE_OPEN_BLOCK_BRACKET   13	// open or close bracket
#define LISA_TYPE_CLOSE_BLOCK_BRACKET  14	// open or close bracket
#define LISA_TYPE_SEMICOLON            15	// end of statement (;)
#define LISA_TYPE_EXPRESSION           16	// begin of an expression
#define LISA_TYPE_FUNCTION             17	// used for function call
#define LISA_TYPE_ARRAY                18	// used for array reference
#define LISA_TYPE_SET                  19	// used for set reference
#define LISA_TYPE_VARIANT              20	// used for variant reference
#define LISA_TYPE_CONDITION            21	// begin of a condition (used in '<%= %>')
#define LISA_TYPE_TARGET               22	// used in target language wrapping (see parser.c)
#define LISA_TYPE_COLON                23	// end of tag statements
#define LISA_TYPE_TAGKEYWORD           24	// TAG format keyword language
#define LISA_TYPE_UNKNOWN              -1



// lisa_database.types
#define LISA_DBTYPE_NONE  0	// no database
#define LISA_DBTYPE_MYSQL 1	// MySql



/*
	GLOBALS
*/
extern int line_index;
extern FILE *outstream;





/*
	PROTOS
*/

// main...
int main( int argc, char *argv[] );
int HandleOptions( int argc, char *argv[] );
void Usage( char *programName );
void Version( void );

// lisa_environment...
lisa_environment *createEnvironment( int language );
lisa_environment *childEnvironment( lisa_environment *env );
void destroyEnvironment( lisa_environment *env );

// lisa_node...
lisa_node *cloneNode( lisa_node *node );
lisa_node *copyNode( lisa_node *node );
lisa_node *createNode( void );
void destroyNode( lisa_node *node );
void destroyNodeR( lisa_node *node );
int emptyNode( lisa_node *node );

// list node support...
void appendNode( lisa_node *node, lisa_node *list );
lisa_node *extractNode( lisa_node *node, lisa_node *list );
lisa_node *findNodeByElement( char *element, lisa_node *list );
lisa_node *popNode( lisa_node *list );
void pushNode( lisa_node *node, lisa_node *list );

// input and output files...
char getChar( void );
void pushbackChar( void );
void putChar( char ch );

// processing HTML code...
char processHTML( void );

// scripting support...
void getScript( void );
void startScript( void );
void startExpression( void );
void stopScript( void );

// script block input...
char getCharS( void );
void pushbackCharS( void );
void putCharS( char ch );

// debugging and errors...
void debug( char *msg );
void error( char *msg );





/*
	PROJECT FILES
*/
#include "eval.h"
#include "lexer.h"
#include "parser.h"
#include "xml.h"
#include "phpdbdriver.h"


#endif
