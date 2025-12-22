#ifndef _LISA_XML_H
#define _LISA_XML_H

#include <string.h>

#include "main.h"



/*
	CONSTANTS
*/

#define XML_DEFINITION_TAG 1
#define XML_REMARK_TAG     2
#define XML_LISA_TAG       3
#define XML_LISA_ENDTAG    4
#define XML_VALUE          5

#define LISA_XML_ROOT     1
#define LISA_XML_DATABASE 2
#define LISA_XML_JDBC     3





/*
	PROTOS
*/
char getXMLChar( void );
void initXMLParser( FILE *stream );
struct lisa_node *parseXML( void );
void processXML( struct lisa_database *database, int method );
void processXMLDatabase( struct lisa_database *database, char *filename );
void pushbackXMLChar( void );
void pushbackXMLNode( struct lisa_node *node );


#endif
