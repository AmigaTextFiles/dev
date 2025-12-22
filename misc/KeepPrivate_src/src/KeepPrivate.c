//
// keepprivate.c
//
// (C) 1999  John M Haubrich Jr
//            All Rights Under Copyright Reserved
//
// MUI header file is split into two sections:
//    Header section declares the list of attrs/methods
//    Detail section itemizes the attrs/methods with corresponding full description
//
// Input file must have formfeed after header section.
// Input file must have formfeed immediately preceding method/attribute
// name in detail section.
//
// Return codes:
//    20 Cannot open file
//    10 Program arguments are incorrect
//     5 Buffer overflow (non-deadend)
//     2 Exclusion count mismatch between header and detail sections
//

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>


typedef int    BOOL;
#define  TRUE  1
#define FALSE  0


#define FORMFEED  12


static const char *pszProgram = "KeepPrivate";
static const char *pszVersion = "$VER: 1.1 (3.7.1999)";


#define MAX_PRIVATES 2048
char* aszPrivates[ MAX_PRIVATES + 1 ]; // list of attrs/methods that are private


int main( int argc, char *argv[] )
{
   int            rc = 0;                 // assume success
   BOOL        fHeaderProcessing = TRUE;  // FALSE after MUI header section is processed
   BOOL        fOverflowWarning = FALSE;  // don't print overflow warning more than once
   BOOL        fPrivateFound;
   BOOL        fHeaderFileParse;
   FILE*       fpi;
   FILE*       fpo;
   long        l;
   long        lPrivatesIndex = 0;        // index for Privates array
   long        lSize;
   unsigned long  ulNumPrivatesHeader = 0;   // stats
   unsigned long  ulNumPrivatesDetail = 0;   // stats
   static char    szLineBuf[ 2048 + 1 ];     // input buffer
   static char    szTempBuf[ 2048 + 1 ];     // comparison buffer
   char*       psz;
   char*       pszTemp;


   // print banner
   printf( "%s %s\n", pszProgram, pszVersion + 6 );
   printf( "(C) 1999  John M Haubrich Jr\n" );
   printf( "          All Rights Under Copyright Reserved.\n" );
   printf( "EMail: johnh@kc.net    WWW: www.kc.net/~johnhkc/\n\n" );

   // do we have the info we need?
   if ( argc < 3  ||  argc > 4  ||
       ( argc == 4  &&  strcmpi( argv[3], "HEADER" ) ) )
   {
      printf( "USAGE: %s infile outfile [HEADER]\n", pszProgram );
      printf( "       infile  = master file with '//private' keywords\n" );
      printf( "       outfile = public output file\n" );
      printf( "       HEADER    Use HEADER keyword to parse a header file.\n" );
      printf( "                 Default parses autodocs file.\n\n" );
      rc = 10;
   }
   else
   {
      fHeaderFileParse = ( ( argc == 4 ) ? TRUE : FALSE );

      // open files
      fpi = fopen( (const char *)argv[1], "r" );
      if ( fpi )
      {
         fpo = fopen( (const char *)argv[2], "w" );
         if ( fpo )
         {
            if ( FALSE == fHeaderFileParse )
            {
               // only applies to AUTODOCS parsing
               printf( "Parsing header section...\n" );
            }

            // parse input file, tracking private attributes and methods
            while ( !feof( fpi ) )
            {
               // read line
               fgets( szLineBuf, sizeof( szLineBuf ), fpi );

               if ( feof( fpi ) )
               {
                  break;
               }

               // zap the newline
               if ( strlen( szLineBuf ) )
               {
                  if ( '\n' == szLineBuf[ strlen( szLineBuf ) - 1 ] )
                  {
                     szLineBuf[ strlen( szLineBuf ) - 1 ] = 0;
                  }
               }

               // process header until first formfeed is found
               if ( TRUE == fHeaderProcessing )
               {
                  // *** HEADER PROCESSING: Record private attrs/methods

                  // if we have storage left, continue adding private declarations
                  if ( lPrivatesIndex < MAX_PRIVATES )
                  {
                     // convert input to uppercase for comparison
                     memset( szTempBuf, 0, sizeof( szTempBuf ) );
                     for ( psz = szLineBuf, pszTemp = szTempBuf; *psz; psz++, pszTemp++ )
                     {
                        *pszTemp = toupper( *psz );
                     }

                     // if '//PRIVATE' keyword is found, add it to the list of privates
                     // to be excluded from the output file
                     if ( psz = strstr( szTempBuf, "//PRIVATE" ) )
                     {
                        if ( psz > szTempBuf )
                        {
                           // find corresponding position in input buffer
                           // since we want the original keyword (case intact)
                           psz = szLineBuf + ( psz - szTempBuf );

                           // fly backwards thru input buffer until we hit a non-whitespace
                           for ( pszTemp = psz - 1; ( isspace( *pszTemp ) && ( pszTemp > szLineBuf ) ); pszTemp-- );

                           // we're at end of keyword -- force a NULL to terminate the string
                           *( pszTemp + 1 ) = 0;

                           // fly backwards until we hit a whitespace (this is start of keyword)
                           for ( psz = pszTemp - 1; ( !isspace( *psz ) && ( psz > szLineBuf ) ); psz-- );

                           // push keyword into Privates array
                           aszPrivates[ lPrivatesIndex++ ] = strdup( psz );

                           // report progress
                           if ( FALSE == fHeaderFileParse )
                           {
                              printf( "PRIVATE [%s] entity detected.\n", psz );
                              ulNumPrivatesHeader++;
                           }
                           else
                           {
                              pszTemp = strstr( szLineBuf, "MUI" );

                              printf( "PRIVATE [" );
                              if ( pszTemp )
                              {
                                 // fly forwards until we hit a whitespace (this is end of keyword)
                                 for ( psz = pszTemp; ( !isspace( *psz )  &&  *psz ); psz++ )
                                 {
                                    printf( "%c", *psz );
                                 }
                              }
                              printf( "] entity excluded.\n" );
                           }
                        }
                     }
                     else
                     {
                        // only output if this line does not contain our FORMFEED delimeter
                        if ( !strchr( szLineBuf, FORMFEED ) )
                        {
                           // not private -- output to public file
                           fputs( szLineBuf, fpo );
                           fputc( '\n', fpo );
                        }
                     }
                  }
                  else
                  {
                     if ( FALSE == fOverflowWarning )
                     {
                        printf( "+++ WARNING: The tracking array for private declarations is fixed at %lu entries.\n", (long)MAX_PRIVATES );
                        printf( "+++          The limit has been reached.  Processing will continue.  Resubmit the\n" );
                        printf( "+++          current output file as the input.  Another set of private declarations\n" );
                        printf( "+++          will be removed from the output.\n" );
                        printf( "+++     Contact johnh@kc.net or www.kc.net/~johnhkc/ for program updates.\n\n" );
                        fOverflowWarning = TRUE;
                        rc = 5;
                     }
                  }

                  // when hit the first formfeed character, we're done with the header
                  // go into detail processing mode
                  if ( strchr( szLineBuf, FORMFEED ) )
                  {
                     fHeaderProcessing = FALSE;
                     if ( FALSE == fHeaderFileParse )
                     {
                        // only applies to AUTODOCS parsing
                        printf( "\nParsing detail section...\n" );
                     }

                     // seek back one line for next iteration ONLY if we're not at end of file
                     if ( !feof( fpi ) )
                     {
                        // add one to compensate for the '\n' we zapped above
                        lSize = strlen( szLineBuf ) + 1;  // + 1 -- if compiling for PC (CR+LF), add another 1 here
                        fseek( fpi, -lSize, SEEK_CUR );
                     }
                  }
               }
               else
               {
                  // *** DETAIL PROCESSING: Exclude private attrs/methods

                  for ( fPrivateFound = FALSE, l = 0; l < lPrivatesIndex; l++ )
                  {
                     if ( strstr( szLineBuf, aszPrivates[ l ] ) )
                     {
                        // report progress
                        printf( "PRIVATE [%s] entity removed from output.\n", aszPrivates[ l ] );
                        ulNumPrivatesDetail++;

                        // read until next FormFeed; do not output to the public file
                        fgets( szLineBuf, sizeof( szLineBuf ), fpi );
                        while ( !strchr( szLineBuf, FORMFEED ) && !feof( fpi ) )
                        {
                           fgets( szLineBuf, sizeof( szLineBuf ), fpi );
                        }

                        // seek back one line for next iteration ONLY if we're not at end of file
                        if ( !feof( fpi ) )
                        {
                           lSize = strlen( szLineBuf );  // + 1 -- if compiling for PC (CR+LF), add 1 here
                           fseek( fpi, -lSize, SEEK_CUR );
                        }

                        fPrivateFound = TRUE;
                        break;
                     }
                  }

                  // if the input is not private, output the chunk to the public file
                  if ( FALSE == fPrivateFound )
                  {
                     // report progress
                     if ( strcmp( szLineBuf, "\f" ) )
                     {
                        // don't report a lone FORMFEED (at EOF, for example)
                        printf( "PUBLIC  [%s] entity detected.\n", &szLineBuf[ 1 ] );
                     }

                     // re-attach the newline we zapped earlier
                     strcat( szLineBuf, "\n" );

                     // read until next FormFeed
                     fputs( szLineBuf, fpo );
                     fgets( szLineBuf, sizeof( szLineBuf ), fpi );
                     while ( !strchr( szLineBuf, FORMFEED ) && !feof( fpi ) )
                     {
                        fputs( szLineBuf, fpo );
                        fgets( szLineBuf, sizeof( szLineBuf ), fpi );
                     }

                     // seek back one line for next iteration ONLY if we're not at end of file
                     if ( !feof( fpi ) )
                     {
                        lSize = strlen( szLineBuf );  // + 1 -- if compiling for PC (CR+LF), add 1 here
                        fseek( fpi, -lSize, SEEK_CUR );
                     }
                  }
               }
            }
         }
         else
         {
            printf( "*** ERROR: Unable to open output file [%s].\n\n", argv[2] );
            rc = 20;
         }
      }
      else
      {
         printf( "*** ERROR: Unable to open input file [%s].\n\n", argv[1] );
         rc = 20;
      }
   }

   // free allocated memory
   for ( l = 0; l < lPrivatesIndex; l++ )
   {
      if ( aszPrivates[ l ] )
      {
         free( aszPrivates[ l ] );
      }
   }

   // success!
   if ( rc < 10 )
   {
      if ( FALSE == fHeaderFileParse )
      {
         // only applies to AUTODOCS parsing
         printf( "\n%lu PRIVATEs detected -- %lu PRIVATEs excluded from public file.\n\n", ulNumPrivatesHeader, ulNumPrivatesDetail );
         if ( ulNumPrivatesHeader == ulNumPrivatesDetail )
         {
            printf( "Parsing completely successful.  Of course, Allan's version will be MUCH better...\n\n"  );
         }
         else
         {
            printf( "WARNING: Unequal exclusions in header and detail sections.\n\n" );
            rc = 2;
         }
      }
      else
      {
         printf( "\nParsing completely successful.  Of course, Allan's version will be MUCH better...\n\n"  );
      }
   }
   return( rc );
}
