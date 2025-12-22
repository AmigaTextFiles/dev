#ifndef _MAIN_H
#define _MAIN_H

#include <iostream.h>

int main( int argc, char * argv[] ) ;
char *createOutputFileName( char *inputFileName ) ;
void processFile( char *inputFileName, char *outputFileName, char *docTitle,
                  const char *docHeader, const char *docFooter ) ;
char *getCodeLine( void ) ;
void print_top( char *docTitle, char *s , const char *docHeader) ;
void print_bottom( const char *docFooter ) ;
void generate( const char *s ) ;
void generate( const char *s, int start, int end ) ;
void generateln( const char *s ) ;
void generateNewLine() ;
void generateTab() ;
void generateComment( const char *s ) ;
void generateString( const char *s ) ;
void generateKeyWord( const char *s ) ;
void generateBaseType( const char *s ) ;
void generateNumber( const char *s ) ;

void startComment( const char *s ) ;
void endComment( const char *s = NULL ) ; // NULL for // comments
void startString( const char *s ) ;
void endString( const char *s ) ;

void startTAG( const char *tag, const char *attr = NULL, const char *val = NULL ) ;
void endTAG( const char *tag ) ;
void startColor( const char *color ) ;
void endColor() ;

extern char *inputFileName ; /* what we're reading  */
extern ostream* sout ;

#endif /* _MAIN_H  */
