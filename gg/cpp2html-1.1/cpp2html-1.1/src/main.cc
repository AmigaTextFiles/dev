/*
 * Copyright (C) 1999, 2000  Lorenzo Bettini, lorenzo.bettini@penteres.it
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#include <stdio.h>
#include <string.h>
#include <iostream.h>
#include <fstream.h>

#include "version.h"
#include "main.h"
#include "colors.h"
#include "tags.h"
#include "keys.h"
#include "textgen.h"
#include "decorators.h"
#include "generators.h"
#include "messages.h"

#include "cmdline.h"
#include "copyright.h"

#define OUTPUT_EXTENSION ".html"

/* global symbols */

char *inputFileName, *outputFileName ; /* what we're reading  */
ostream* sout ;

int tabSpaces = 0 ;     // space to substitue to tabs

int entire_doc = 0 ; // we want a real html doc
int otherArgs ;
short verbose = 0 ;
char *cssUrl = 0 ;
int use_css = 0 ; // Use CSS instead of font-tags

char *programName = 0 ;
char *programVersion = 0 ;

extern int yylex() ;
extern int parseTags() ;

static char *read_file(char *fileName);
static void file_error(const char *error, char *fileName);
static void internal_error(const char *error);

int
main( int argc, char * argv[] )
{
  char *docTitle;  
  char *docHeader; // the buffer with the header  
  char *docFooter; // the buffer with the footer
  char *header_fileName = 0;
  char *footer_fileName = 0;
  gengetopt_args_info args_info ;     // command line structure
  unsigned i;
  int v; 

  if((v = cmdline_parser(argc, argv, &args_info)) != 0) 
    // calls cmdline parser. The user gived bag args if it doesn't return -1 
    return 1; 

  programName = PACKAGE ;
  programVersion = VERSION ;

  /* initialization of global symbols */
  inputFileName = outputFileName = 0 ;
  sout = 0 ;
  docTitle = 0 ;
  docHeader = 0 ;
  docFooter = 0 ;
  
  // adjust flags for command line parameters
  otherArgs = 1;

  docTitle = args_info.title_arg ;
  header_fileName = args_info.header_arg ;
  footer_fileName = args_info.footer_arg ;
  verbose = args_info.verbose_given ;

  if ( args_info.tab_given > 0 )
    tabSpaces = args_info.tab_arg ;

  if (header_fileName)
    docHeader = read_file (header_fileName);

  if (footer_fileName)
    docFooter = read_file (footer_fileName);

  cssUrl = args_info.css_arg ;
  use_css = ( cssUrl != 0 ) ;

  entire_doc = ( args_info.doc_given || (docTitle != 0) || use_css ) ;
  
  inputFileName = args_info.input_arg ;
  if ( inputFileName ) {
    outputFileName = args_info.output_arg ;
    if ( ! outputFileName ) {
      outputFileName = createOutputFileName( inputFileName ) ;
    }
  }
  
  if ( verbose )
    setMessager( new DefaultMessages ) ;

  printMessage( PACKAGE " " VERSION ) ;
  
  parseTags() ;

  if( use_css ) {
    createGeneratorsForCSS() ;
  }
  else {
    createGenerators() ;
  }
  
  // let's start the translation :-)
  
  // first the --input file
  if ( ! args_info.inputs_num )
    processFile( inputFileName, outputFileName, docTitle, docHeader, docFooter ) ;

  // let's process other files, if there are any
  if ( args_info.inputs_num ) {
    for ( i = 0 ; i < (args_info.inputs_num) ; ++i ) {
      processFile( args_info.inputs[i], 
		   createOutputFileName( args_info.inputs[i] ),
		   docTitle, docHeader, docFooter ) ; 
      cerr << "Processed " << args_info.inputs[i] << endl ;
    }
  }
  
  return (0 );
}

char *
read_file(char *fileName)
{
  FILE *file;
  char *buffer = 0;
  long int char_count;

  // we open it as binary otherwise we may experience problems under
  // Windows system: when we fread, the number of char read can be
  // less then char_count, and thus we'd get an error...
  if ( (file = fopen(fileName,"rb") ) == 0 )	// The file does not exist :(
    file_error ("Error operning", fileName);
  else
    {
      // let's go to the end of the file...
      if (fseek (file, 0, SEEK_END) != 0)
        file_error ("Error positioning", fileName);

      // ...to read the dimension
      char_count = ftell (file);
      if (char_count < 0)
        file_error ("Error reading position", fileName);

      buffer = (char *) malloc (char_count +1);
      if (! buffer)
        internal_error ("Memory allocation failed");

      // let's go back to the start
      rewind (file);

      if (fread ((void *) buffer, 1, char_count, file) < (size_t) char_count)
        file_error ("read error", fileName);
      buffer[char_count] = '\0';

      fclose (file);
    }

  return buffer;
}

void
file_error(const char *error, char *file)
{
  fprintf (stderr, "%s: %s, file %s\n", PACKAGE, error, file);
  exit (1);
}

void
internal_error(const char *error)
{
  fprintf (stderr, "%s: Internal error: %s\n", PACKAGE, error);
  exit (1);
}

// output file name = input file name + ".html"
char *createOutputFileName( char *inputFileName ) {
  char *outputFileName = new char[ strlen(inputFileName) + 
                                 strlen(OUTPUT_EXTENSION) + 1 ] ;
  strcpy( outputFileName, inputFileName ) ;
  strcat( outputFileName, OUTPUT_EXTENSION ) ;

  return outputFileName ;
}

void processFile( char *inputFileName, char *outputFileName, char *docTitle, 
		  const char *docHeader, const char *docFooter) {
  FILE *in = 0;
  short deleteOStream = 1 ;

  if ( outputFileName ) {
    sout = new ofstream(outputFileName) ;
    if ( ! sout ) {
      cerr << "Error in creating " << outputFileName << " for output" << endl ;
      exit(1) ;
    }
  }

  if ( inputFileName ) {
      in = freopen (inputFileName, "r", stdin);
      if (!in) {
        cerr << "Error in opening " << inputFileName
             << " for input" << endl ;
        exit(1) ;
      }
  }

  /*
   * Use default values for any options not provided
   */
  if (sout == 0) {
    sout = &cout;
    deleteOStream = 0 ; // we can't delete cout !!!
  }
  if (in == 0) {
    ; /* Well stdin already points to stdin so, .... */
  }
  if (docTitle == 0) {
    docTitle = inputFileName; /* inputFileName may also be 0,
                                 this is OK. */
  }
  
  if ( entire_doc ) {
    print_top( docTitle, cssUrl, docHeader );
  }

  printMessage( "translating source code... ", cerr ) ;

  generateln( "<pre>" ) ;
  generateln( "<tt>" ) ;
  yylex() ;
  generateln( "</tt>" ) ;
  generateln( "</pre>" ) ;

  printMessage( "done !", cerr ) ;
  
  if ( entire_doc )
    print_bottom( docFooter ) ;

  if ( deleteOStream )
    delete sout ;
}

void
print_top( char *docTitle, char *cssUrl , const char *docHeader)
{
  if( cssUrl == 0 ) {
    generateln( "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML//EN\">" ) ;
  }
  else {
    generateln( "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\"");
    generateln( "    \"http://www.w3.org/TR/REC-html40/strict.dtd\">");
  }
  generateln( "<html>" ) ;
  generateln( "<head>" ) ;
  generateln( "<meta http-equiv=\"Content-Type\"" ) ;
  generateln( "content=\"text/html; charset=iso-8859-1\">" ) ;
  generate( "<meta name=\"GENERATOR\" content=\"" ) ;
  generate( PACKAGE " " VERSION ) ;
  generate( "\nby Lorenzo Bettini, bettini@gnu.org" ) ;
  generate( "\nhttp://w3.newnet.it/bettini" ) ;
  generate( "\nhttp://www.gnu.org/software/" PACKAGE "/" PACKAGE ".html" ) ;
  generateln( "\">" ) ;
  generate( "<title>" ) ;
  generate( ( docTitle ? docTitle : 
              ( inputFileName ? inputFileName : "source file" ) ) ) ;
  generateln( "</title>" ) ;
  if( cssUrl != 0 ) {
    generate( "<link rel=\"stylesheet\" href=\"" );
    generate( cssUrl );
    generateln( "\" type=\"text/css\">");
  }
  generateln( "</head>" ) ;
  if( cssUrl == 0 && docHeader == 0) {
    generate ("<body bgcolor=\"#FFFFFF\" text=\"#000000\" link=\"#0000EE\" ");
    generateln ( "vlink=\"#551A8B\" alink=\"#FF0000\">" );
  }
  else {
    generateln( "<body>" ) ;
  }
  if (docHeader)
    generateln (docHeader) ;
}

void print_bottom( const char *docFooter) {
  if ( docFooter ) generateln( docFooter ) ;
  generateln( "</body>" ) ;
  generateln( "</html>" ) ;
}

void generate( const char *s ) {
  GlobalGenerator->generate(s) ;
}

void
generate( const char *s, int start, int end )
{
  GlobalGenerator->generate(s, start, end) ;
}

void generateln( const char *s ) {
  GlobalGenerator->generateln(s) ;
}

void generateNewLine() {
  generateln( "" ) ;
}

void generateTab() {
  if ( tabSpaces )
    for ( register int i = 0 ; i < tabSpaces ; ++i )
      generate( SPACE_CHAR ) ;
  else
    generate( "\t" ) ;
}

void startComment( const char *s )
{
  CommentGenerator->beginText(s) ;
}

void endComment( const char *s )
{
  CommentGenerator->endText(s) ;
}

void generateComment( const char *s ) {
  CommentGenerator->generateEntire(s) ;
}

void startString( const char *s )
{
  StringGenerator->beginText(s) ;
}

void endString( const char *s )
{
  StringGenerator->endText(s) ;
}

void generateString( const char *s ) {
  StringGenerator->generateEntire(s) ;
}

void generateKeyWord( const char *s ) {
  KeywordGenerator->generateEntire(s) ;
}

void generateBaseType( const char *s ) {
  TypeGenerator->generateEntire(s) ;
}

void generateNumber( const char *s ) {
  NumberGenerator->generateEntire(s) ;
}

void startTAG( const char *tag, const char *attr, const char *val ) {
  (*sout) << "<" << tag ;
  if ( attr && val )
    (*sout) << " " << attr << "=" << val ;
  (*sout) << ">" ;
}

void endTAG( const char *tag ) {
  (*sout) << "</" << tag << ">" ;
}

void startColor( const char *color ) {
  startTAG( FONT_TAG, COLOR_TAG, color ) ;
}

void endColor() {
  endTAG( FONT_TAG ) ;
}
