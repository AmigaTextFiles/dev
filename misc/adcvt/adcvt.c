/* adcvt 0.1 -- AutoDoc to HTML converter
 * (C) Copyright 2004 Ekkehard Morgenstern. All rights reserved.
 * Free software. Use at your own risk.
 * If you modify this software, keep the original copyright statements and add yours.
 * e-mail: ekkehard.morgenstern@onlinehome.de
 */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct __FILELINE {
   struct __FILELINE*  next;
   char*               text;
} FILELINE;

typedef struct __FILEPAGE {
   struct __FILEPAGE*   next;
   FILELINE*            lines;
   int                  numlines;
   char*                filename;
   char*                linkname;
} FILEPAGE;

typedef struct __FILEENTRY {
   struct __FILEENTRY* next;
   char*               name;
   char*               lnkname;
   char*               tocfile;
   FILEPAGE*           pages;
   int                 numpages;
   int                 totallines;
} FILEENTRY;

size_t      memusage = 0;
FILE*       fpi;
FILE*       fpo;
char        linebuf[128];
char        linebuf2[128];
FILEENTRY*  filelist = 0;
int         numfiles = 0;

void* mymalloc( size_t size ) {
   void* blk = malloc( size );
   if ( blk == 0 ) {
      printf( "out of memory; memory usage was at least %u bytes.\n", memusage );
      exit(0);
   }
   memusage += size;
   return blk;
}

char* mystrdup( const char* src ) {
   size_t len = strlen(src) + 1U;
   char*  buf = (char*) mymalloc( len );
   memcpy( buf, src, len );
   return buf;
}

void checkoutput( void ) {
   if ( ferror( fpo ) ) { printf( "write error! not enough disk space?" ); exit(0); }
}

void createtocfilenames( void ) {
   FILEENTRY* fe = filelist;
   while ( fe ) {
      char* p;
      strcpy( linebuf, fe->name );
      p = strchr( linebuf, '.' );
      if ( p ) *p = '\0';
      if ( fe->lnkname == 0 ) fe->lnkname = mystrdup( linebuf );
      strcpy( linebuf, fe->name );
      p = strchr( linebuf, '.' );
      if ( p ) *p = '\0';
      sprintf( linebuf2, "toc_%s", linebuf );
      linebuf2[26] = '\0';
      strcat( linebuf2, ".html" );
      if ( fe->tocfile == 0 ) fe->tocfile = mystrdup( linebuf2 );
      fe = fe->next;
   }
}

void printtocfilename( FILEENTRY* fe ) {
   if ( fe->next ) printtocfilename( fe->next );
   checkoutput(); fprintf( fpo, "\n<a href=\"%s\" target=\"secondaryTOC\">%s</a><br>\r",
      fe->tocfile, fe->lnkname );
}

void printtocfilenames( void ) {
   printtocfilename( filelist );
}

void createpagefilenames( FILEENTRY* fe ) {
   FILEPAGE* pg = fe->pages;
   int       n  = fe->numpages;
   while ( pg ) {
      FILELINE* ln = pg->lines;
      while ( ln && ln->next ) ln = ln->next;
      if ( ln ) {
         char* p;
         int len;
         strcpy( linebuf, ln->text );
         p = strstr( linebuf, "  " );
         if ( p ) *p = '\0';
         else {
            FILELINE* fl = pg->lines;
            while ( fl ) {
               if ( fl->next ) {
                  const char* txt = fl->next->text;
                  int nxtlen = strlen( txt );
                  if ( nxtlen >= 4 && strcmp( txt+(nxtlen-4), "NAME" ) == 0 ) {
                     break;
                  }
               }
               fl = fl->next;
            }
            if ( fl ) {
               const char* s = fl->text;
               while ( *s == ' ' || *s == '\t' ) ++s;
               strcpy( linebuf, s );
               p = strchr( linebuf, '-' );
               if ( p ) *p = '\0';
            }
         }
         len = strlen( linebuf );
         while ( len > 0 && ( linebuf[len-1] == ' ' || linebuf[len-1] == '\t' ) ) linebuf[--len] = '\0';
         p = strchr( linebuf, '/' );
         if ( p ) { strcpy( linebuf2, p+1 ); strcpy( linebuf, linebuf2 ); }
         while ( ( p = strchr( linebuf, '/' ) ) != 0 ) *p = ' ';
         while ( ( p = strchr( linebuf, ' ' ) ) != 0 ) *p = '_';
         while ( ( p = strchr( linebuf, '\t' ) ) != 0 ) *p = '_';
         while ( ( p = strchr( linebuf, '-' ) ) != 0 ) *p = '_';
         while ( ( p = strchr( linebuf, '.' ) ) != 0 ) *p = '_';
         while ( ( p = strchr( linebuf, ':' ) ) != 0 ) *p = '_';
         if ( strlen(linebuf) == 0 ) sprintf( linebuf, "page_%d", n );
      }
      else {
         sprintf( linebuf, "page_%d", n );
      }
      sprintf( linebuf2, "%s_%s", linebuf, fe->lnkname );
      linebuf2[26] = '\0';
      strcat( linebuf2, ".html" );
      if ( pg->filename == 0 ) pg->filename = mystrdup( linebuf2 );
      if ( pg->linkname == 0 ) pg->linkname = mystrdup( linebuf  );
      pg = pg->next; --n;
   }
}

void printpagefilename( FILEPAGE* pg ) {
   if ( pg->next ) printpagefilename( pg->next );
   checkoutput(); fprintf( fpo, "\n<a href=\"%s\" target=\"content\">%s</a><br>\r",
      pg->filename, pg->linkname );
}

void printpagefilenames( FILEENTRY* fe ) {
   printpagefilename( fe->pages );
}

void printline( FILELINE* ln ) {
   if ( ln->next ) printline( ln->next );
   checkoutput(); fprintf( fpo, "\n%s\r", ln->text );
}

void printlines( FILEPAGE* pg ) {
   printline( pg->lines );
}

void createpagefiles( FILEENTRY* fe ) {
   FILEPAGE* pg = fe->pages;
   int       n  = fe->numpages;
   while ( pg ) {
      fpo = fopen( pg->filename, "wb" );
      if ( fpo == 0 ) { printf( "can't open \"%s\" for writing!\n", pg->filename ); 
         /* printf( "filename = '%s' linkname = '%s'\n", pg->filename, pg->linkname );
         printf( "tocfile = '%s' lnkname = '%s'\n", fe->tocfile, fe->lnkname ); */
         exit(0); }
      printf( "writing page \"%s\" ...\n", pg->filename );
      checkoutput(); fprintf( fpo, "\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" "
        " \"http://www.w3.org/TR/html4/strict.dtd\">\r"
        "\n<html>\r"
        "\n<head>\r"
        "\n<title> %s (%s) </title>\r"
        "\n</head>\r"
        "\n<body>\r\n<pre>\r", pg->linkname, fe->lnkname );
      printlines( pg );
      checkoutput(); fprintf( fpo, "\n</pre>\r\n</body>\r\n</html>\r" );
      checkoutput(); fclose( fpo );
      pg = pg->next;
   }
}

void createtocfiles( void ) {
   FILEENTRY* fe = filelist;
   while ( fe ) {
      createpagefilenames( fe );
      fpo = fopen( fe->tocfile, "wb" );
      if ( fpo == 0 ) { printf( "can't open \"%s\" for writing!\n", fe->tocfile ); exit(0); }
      printf( "writing table of contents \"%s\" ...\n", fe->tocfile );
      checkoutput(); fprintf( fpo, "\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" "
        " \"http://www.w3.org/TR/html4/strict.dtd\">\r"
        "\n<html>\r"
        "\n<head>\r"
        "\n<title> %s Table of Contents </title>\r"
        "\n</head>\r"
        "\n<body>\r", fe->lnkname );
      printpagefilenames( fe );
      checkoutput(); fprintf( fpo, "\n</body>\r\n</html>\r" );
      checkoutput(); fclose( fpo );
      createpagefiles( fe );
      fe = fe->next;
   }
}

void writeframeset( void ) {
   /* "\n" ... "\r" is SGML line format, I hope it works */
   fpo = fopen( "index.html", "wb" );
   if ( fpo == 0 ) { printf( "can't open \"index.html\" for writing!\n" ); exit(0); }
   printf( "writing frameset \"index.html\" ...\n" );
   checkoutput(); fprintf( fpo, "\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" "
                 "\"http://www.w3.org/TR/html4/frameset.dtd\">\r"
                 "\n<html>\r"
                 "\n<head>\r"
                 "\n<title> Autodocs </title>\r"
                 "\n</head>\r"
                 "\n<frameset cols=\"20%,20%,60%\">\r" );
   checkoutput(); fprintf( fpo, "\n<frame src=\"toc.html\" name=\"primaryTOC\">\r"
                 "\n<frame src=\"empty.html\" name=\"secondaryTOC\">\r"
                 "\n<frame src=\"empty.html\" name=\"content\">\r" );
   checkoutput(); fprintf( fpo, "\n</frameset>\r\n</html>\r" );
   checkoutput(); fclose( fpo );
   fpo = fopen( "empty.html", "wb" );
   if ( fpo == 0 ) { printf( "can't open \"empty.html\" for writing!\n" ); exit(0); }
   printf( "writing empty page \"empty.html\" ...\n" );
   checkoutput(); fprintf( fpo, "\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" "
                 " \"http://www.w3.org/TR/html4/strict.dtd\">\r"
                 "\n<html>\r"
                 "\n<head>\r"
                 "\n<title> Empty Document </title>\r"
                 "\n</head>\r"
                 "\n<body>\r"
                 "\n</body>\r"
                 "\n</html>\r" );
   checkoutput(); fclose( fpo );
   createtocfilenames();
   fpo = fopen( "toc.html", "wb" );
   if ( fpo == 0 ) { printf( "can't open \"toc.html\" for writing!\n" ); exit(0); }
   printf( "writing table of contents \"toc.html\" ...\n" );
   checkoutput(); fprintf( fpo, "\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" "
                 " \"http://www.w3.org/TR/html4/strict.dtd\">\r"
                 "\n<html>\r"
                 "\n<head>\r"
                 "\n<title> Table of Contents </title>\r"
                 "\n</head>\r"
                 "\n<body>\r" );
   printtocfilenames();
   checkoutput(); fprintf( fpo, "\n</body>\r"
                 "\n</html>\r" );
   checkoutput(); fclose( fpo );
   createtocfiles();
}

void readlistfile( const char* listfile ) {
   fpi = fopen( listfile, "r" );
   if ( fpi == 0 ) {
      printf( "can't open list file '%s'\n", listfile );
      exit(0);
   }
   while ( !ferror(fpi) && !feof(fpi) && fgets( linebuf, sizeof(linebuf), fpi ) ) {
      FILEENTRY* fe;
      char* str;
      int len = strlen(linebuf);
      if ( len > 0 && linebuf[len-1] == '\n' ) linebuf[--len] = '\0';
      if ( len > 0 && linebuf[len-1] == '\r' ) linebuf[--len] = '\0';
      while ( len > 0 && ( linebuf[len-1] == ' ' || linebuf[len-1] == '\t' ) ) linebuf[--len] = '\0';
      if ( len == 0 ) continue;
      str = mystrdup( linebuf );
      fe = (FILEENTRY*) mymalloc( sizeof(FILEENTRY) );
      fe->name = str;
      fe->lnkname = 0;
      fe->tocfile = 0;
      fe->next = filelist; filelist = fe;
      fe->pages = 0;
      fe->numpages = 0;
      fe->totallines = 0;
      ++numfiles;
   }
   printf( "%d input file%s. memory usage so far: %u bytes min.\n", numfiles, ( numfiles == 1 ? "" : "s" ),
      memusage );
   fclose( fpi );
}

void readfiles( void ) {
   FILEENTRY* fe = filelist;
   while ( fe ) {
      fpi = fopen( fe->name, "r" );
      if ( fpi ) {
         while ( !ferror(fpi) && !feof(fpi) && fgets( linebuf, sizeof(linebuf), fpi ) ) {
            FILEPAGE* pg;
            FILELINE* fl;
            char* str; int newpage = 0;
            int len = strlen(linebuf);
            if ( len > 0 && linebuf[len-1] == '\n' ) linebuf[--len] = '\0';
            if ( len > 0 && linebuf[len-1] == '\r' ) linebuf[--len] = '\0';
            while ( len > 0 && ( linebuf[len-1] == ' ' || linebuf[len-1] == '\t' ) ) linebuf[--len] = '\0';
            if ( len == 0 ) continue;
            if ( linebuf[0] == '\f' ) {
               str = mystrdup( linebuf+1 );
               newpage = 1;
            }
            else {
               str = mystrdup( linebuf );
            }
            if ( fe->numpages == 0 ) newpage = 1;
            if ( newpage ) {
               pg = (FILEPAGE*) mymalloc( sizeof(FILEPAGE) );
               pg->lines = 0;
               pg->numlines = 0;
               pg->next = fe->pages; fe->pages = pg;
               pg->filename = 0;
               pg->linkname = 0;
               newpage = 0;
               ++fe->numpages;
            }
            pg = fe->pages;
            fl = (FILELINE*) mymalloc( sizeof(FILELINE) );
            fl->text = str;
            fl->next = pg->lines; pg->lines = fl;
            ++pg->numlines;
            ++fe->totallines;
         }
         printf( "%d lines on %d pages read from file \"%s\". memory usage so far: %u bytes min.\n", 
            fe->totallines, fe->numpages, fe->name, memusage );
         fclose( fpi );
      }
      else {
         printf( "could not open file \"%s\".\n", fe->name );
      }
      fe = fe->next;
   }
}

int main( int argc, char** argv ) {


   if ( argc != 2 ) {
      printf( "Usage: adcvt <listfile>\n"
              "The list file contains a list of autodoc files to convert to HTML.\n" 
              "(C) Copyright 2004 Ekkehard Morgenstern. All rights reserved.\n"
              "This program is free software. Use at your own risk.\n" );
      return 0;
   }

   readlistfile( argv[1] );
   readfiles();
   writeframeset();
   printf( "done, memory used was %u bytes min.\n", memusage );
   printf( "View the file \"index.html\" with a frames-enabled browser.\n" );

   return 0;
}
