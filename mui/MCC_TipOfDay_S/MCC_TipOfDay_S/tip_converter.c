
/*
** $Id: tip_converter.c,v 1.4 1999/11/20 13:34:54 carlos Exp $
**
**       © 1999 Marcin Orlowski <carlos@amiga.com.pl>
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <dos/dos.h>
#include <dos/dostags.h>
#include <libraries/iffparse.h>
#include <clib/utility_protos.h>

#include <proto/dos.h>
#include <proto/iffparse.h>
#include <proto/exec.h>

#include "tip_converter_revision.h"

#define ID_VERS    MAKE_ID('V','E','R','S')
#define ID_TIPS    MAKE_ID('T','I','P','S')     // Tips file
#define ID_TIPC    MAKE_ID('M','A','X',' ')     // Tips count
#define ID_LAST    MAKE_ID('L','A','S','T')     // last shown tip
#define ID_SHOW    MAKE_ID('S','H','O','W')     // show on startup

#define TIP_LEN 512


struct BaseVersion
{
  UWORD Version;
  UWORD Revision;
};


struct TipList
{
    struct MinNode tl_node;
    char   Tip[ TIP_LEN ];
};

struct List tips;

/// FreeTips
void FreeTips( void )
{

struct TipList *tip, *tip_next;

    if( !IsListEmpty(&tips) )
       {
       for(tip = (struct TipList *)tips.lh_Head; tip->tl_node.mln_Succ; )
           {
           Remove( (struct Node*)tip );
           tip_next = (struct TipList *)tip->tl_node.mln_Succ;
           free( tip );
           tip = tip_next;
           }
       }
}
//|
/// AddTip

char AddTip( char *tip )
{

struct TipList *nowy = calloc(1, sizeof(struct TipList) );

    if( nowy )
       {
       memcpy( &nowy->Tip, tip, TIP_LEN );
       AddTail( &tips, (struct Node *)nowy );
       }

    return(0);
}

//|
/// StrToLower

void strtolower( char *dest_buffer, char * src )
{
    for(; *src;)
       {
       *dest_buffer = ToLower(*src);
       src++;
       dest_buffer++;
       }
    *dest_buffer=0;
}
//|

// the following functions are taken
// as-is from the FlexCat source code

#define tolower         ToLower

/// FUNC: MemError

/*
    This shows the message: Memory error.
*/
void MemError(void)
{
  fprintf(stderr, "ERROR: Not enough memory!\n");
}
//|
/// FUNC: getoctal

/*
    This translates an octal digit.
*/
int getoctal(int c)
{

  if (c >= '0'  &&  c <= '7')
    {
    return(c - '0');
    }

  fprintf(stderr, "WARN: Expected Octal numer\n");
  return(0);

}
//|
/// FUNC: gethex
/*
    This translates a hex character.
*/
int gethex(int c)
{
  if (c >= '0'  &&  c <= '9')
  { return(c - '0');
  }
  else if (c >= 'a'  &&  c <= 'f')
  { return(c - 'a' + 10);
  }
  else if (c >= 'A'  &&  c <= 'F')
  { return(c - 'A' + 10);
  }

  fprintf(stderr, "WARN: Expected Hex number\n");
  return(0);
}
//|
/// FUNC: ReadChar

/*
    ReadChar scans an input line translating the backslash characters.

    Inputs: strptr  - a pointer to a stringpointer; the latter points to the
                      next character to be read and points behind the read
                      bytes after executing ReadChar
            dest    - a pointer to a buffer, where the read bytes should be
                      stored

    Result: number of bytes that are written to dest (between 0 and 2)
*/
int ReadChar(char **strptr, char *dest)
{
  char c;
  int i;

  switch(c = *((*strptr)++))
    {
    case '\\':

      switch(c = tolower((int) *((*strptr)++)))
        {
        case '\n':
          return(0);
        case 'b':
          *dest = '\b';
          break;
        case 'c':
          *dest = '\233';
          break;
        case 'e':
          *dest = '\033';
          break;
        case 'f':
          *dest = '\f';
          break;
        case 'g':
          *dest = '\007';
          break;
        case 'n':
          *dest = '\n';
          break;
        case 'r':
          *dest = '\r';
          break;
        case 't':
          *dest = '\t';
          break;
        case 'v':
          *dest = '\013';
          break;
        case 'x':
          *dest = gethex((int) **strptr);
          (*strptr)++;
          if (((c = **strptr) >= '0'  &&  c <= '9')  ||
              (c >= 'a'  &&  c <= 'f')  ||  (c >= 'A'  &&  c <= 'F'))
          { *dest = (*dest << 4) + gethex((int) c);
            (*strptr)++;
          }
          break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':

          *dest = getoctal((int)c);

          for(i = 0;  i < 2;  i++)
            {
            if((c = **strptr) >= '0'  &&  c <= '7')
              {
              *dest = (*dest << 3) + getoctal((int) c);
              (*strptr)++;
              }
            }
          break;
        case ')':
        case '\\':
          *(dest++) = '\\';
          *dest = c;
          return(2);
        default:
          *dest = c;
      }
      break;

    default:
      *dest = c;
  }
  return(1);
}
//|

// end of rip-offs

/// main
void main( int argc, char **argv)
{
char   outname[256];
BPTR   in = NULL;

ULONG  count    = 0;
ULONG  empty    = 0;
ULONG  comments = 0;

char   quiet = FALSE;


    NewList( &tips );



    if( argc < 2 || argc > 4 )
       {
       printf("ASCII->Tips converter " __AMIGADATE__ "\n");
       fprintf(stderr, "Usage: %s infile outfile [QUIET]\n", argv[0]);
       exit(20);
       }


    quiet = ( argc == 4 );

    if( !quiet )
        printf("ASCII->Tips converter " __AMIGADATE__ "\n");


    // reading source file...

    if( in = Open( argv[1], MODE_OLDFILE ) )
      {
      char   buffer[ 2*TIP_LEN ];
      char   buffer_tmp[ TIP_LEN ];

      if( !quiet )
        printf( "Reading '%s'...\n", argv[1] );


      // read loop

      while( FGets( in, buffer, sizeof( buffer ) ) )
        {
        int len = strlen( buffer );

        if( len > 0 )
           {
           if( (len != 1) && buffer[0] != 10 )
             {
             char *p = strchr( buffer, '\n' );
             if( p )
               *p = 0;

             if( buffer[0] != ';' )
               {
               char *tmp_ptr = buffer;
               char *dest    = buffer_tmp;

               while( *tmp_ptr )
                 dest += ReadChar( &tmp_ptr, dest );

               *dest = 0;


               AddTip( buffer_tmp );

               count++;
               }
             else
               {
               comments++;
               }
             }
           else
             {
             empty++;
             }
           }
        else
           {
           empty++;
           }
        }

      Close( in );

      if( !quiet )
         printf("  %ld tips read. %ld comments, %ld empty lines skipped\n", count, comments, empty );
      }
    else
      {
      fprintf(stderr,  "** Can't open input file '%s'\n", argv[1] );
      exit( 20 );
      }





    // saving...
       {
       struct IFFHandle *MyIFFHandle = NULL;
       int len = strlen( argv[2] );

       strcpy( outname, argv[2] );


       if( len > 4 )
           if( stricmp( ".tips", &argv[2][len-5] ))
              strcat( outname, ".tips" );



       if( MyIFFHandle = AllocIFF() )
         {
         BPTR  FileHandle;

         if( FileHandle = Open( outname, MODE_NEWFILE ) )
           {
           MyIFFHandle->iff_Stream = FileHandle;
           InitIFFasDOS( MyIFFHandle );

           if(OpenIFF( MyIFFHandle, IFFF_WRITE ) == 0)
               {
               struct TipList *node;
               struct BaseVersion version;

               if( !quiet )
                   printf( "Saving '%s'...\n", outname );

               PushChunk(MyIFFHandle, ID_TIPS, ID_CAT, IFFSIZE_UNKNOWN);

               // version string
               PushChunk(MyIFFHandle, ID_TIPS, ID_FORM, IFFSIZE_UNKNOWN);
                   PushChunk(MyIFFHandle, ID_TIPS, ID_VERS, IFFSIZE_UNKNOWN);
                   version.Version  = VERSION;
                   version.Revision = REVISION;
                   WriteChunkBytes( MyIFFHandle, &version, sizeof(version) );
                   PopChunk(MyIFFHandle);

/*
                   PushChunk(MyIFFHandle, ID_TIPS, ID_ANNO, IFFSIZE_UNKNOWN);
                   WriteChunkBytes( MyIFFHandle, anno, strlen(anno) );
                   PopChunk(MyIFFHandle);
*/

               PopChunk(MyIFFHandle);


               // header...

               PushChunk(MyIFFHandle, ID_TIPS, ID_FORM, IFFSIZE_UNKNOWN);
                   PushChunk(MyIFFHandle, ID_TIPS, ID_TIPC, IFFSIZE_UNKNOWN);
                   WriteChunkBytes( MyIFFHandle, &count, sizeof(ULONG) );
                   PopChunk(MyIFFHandle);
               PopChunk(MyIFFHandle);

               // Tips...
               PushChunk(MyIFFHandle, ID_TIPS, ID_FORM, IFFSIZE_UNKNOWN);

               {
               ULONG index = 0;

               for(node = (struct TipList *)tips.lh_Head; node->tl_node.mln_Succ; node = (struct TipList *)node->tl_node.mln_Succ)
                   {
                   // saving entry...
                   char _id[5];
                   ULONG IFF_ID;

                   sprintf( _id, "%04lx", index );
                   strtolower( _id, _id );
                   IFF_ID = MAKE_ID( _id[0], _id[1], _id[2], _id[3] );

                   PushChunk( MyIFFHandle, ID_TIPS, IFF_ID, IFFSIZE_UNKNOWN );
                   WriteChunkBytes( MyIFFHandle, node->Tip, strlen( node->Tip) );
                   PopChunk( MyIFFHandle );

                   index++;
                   }
               }
               PopChunk(MyIFFHandle);

               // pop CAT
               PopChunk(MyIFFHandle);
               CloseIFF(MyIFFHandle);
               }
           else
               {
               fprintf(stderr,  "** Can't OpenIFF() for '%s'\n", outname );
               }

           Close(FileHandle);
           }
        else
           {
           fprintf(stderr, "** Can't open \"%s\" for write\n", outname );
           }

        FreeIFF(MyIFFHandle);
        }
     else
        {
        fprintf(stderr, "** Can't AllocIFF()\n");
        exit(20);
        }

    }


    FreeTips();

    if( !quiet )
        printf("Done.\n");

}
//|

