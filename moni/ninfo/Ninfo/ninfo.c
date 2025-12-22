/*
*
* Object information utility  Version 1.0 16-apr-1990
* Arguments are:
* Oinfo <options> <input file> ... <input file>.
* Description:
* This utility will read an object (from the Lattice Compiler) and
* decode the Hunks and informations comtained in the Hunks.
*
* Options:
*   -m   : Decode a block of memory
*   -v   : Decode boot block dump (check virus code)
*   -s   : symbols supressed
*   -d   : data words supressed
*   -c   : code words supressed
*
*/
#include <libraries/dos.h>
#include "hunk.h"
#include <ctype.h>
int Flgs[26];          /* user options */
void main(int, char **);
void main(argc, argv)
int   argc;                      /*number of arguments            */
char  *argv[];                   /*array of ptrs to arg strings   */
  {
  BPTR  file1;                    /* input File pointer                 */
  char *name1;
  int  i;
  long addrs;
  short More_Stuff;
  int Header[3];     /* Hunk type and size in words */
  /* get the file names and open the files */
  /* initialize input buffers and variables*/
  addrs = 0;
  Do_Arguments(argc, argv,&addrs);
  fprintf(stderr," \tObject/Executable/Library Disassembler\n");
  fprintf(stderr," \tVersion 2.0 © 1991 Custom Services\n");
  fprintf(stderr," \t\t***All Rights Reserved***\n");
  fprintf(stderr," \t\tShareware donation:$5.00\n");
  fprintf(stderr," \t\tCustom Services\n");
  fprintf(stderr," \t\tP. O. Box 254\n");
  fprintf(stderr," \t\tMoorestown, NJ 08057\n");
  file1 = NULL;
  if ( argc < 2 )
    {
    printf(" Format is:\n%s [-c -d -s -v -m<address>] <file>... <file>\n",argv[0]);
    exit(10);

    };
  /* collect the data */
  while (--argc > 0 )       /* while files to process */
    {
    if( file1 != NULL)
      {
      Close( file1);
      file1 = NULL;

      };
    name1      = *++argv;         /*   get a file name?      */
    if ( *name1 == '-' )continue;  /*   skip options          */
    printf("\n      Processing: %s\n",name1);
    file1      = Open(name1,MODE_OLDFILE);  /* open file for reading */
    if ( file1 == NULL )
      {
      printf(" Cannot Open Object file: %s\n",name1);
      break;

      };
    /*  read the entries and decode data  */
    More_Stuff = TRUE;
    if( ! Flgs[21] ) /* regular if no -V or -M<address> */
      {
      while ( More_Stuff )
        {
        Header[0] = ( GrabLong(file1) & 0x0000FFFF );
        switch ( Header[0] )
          {
          case  0 :                   /* end of file */
          More_Stuff = FALSE;
          break;
          case  Hunk_End   :          /* end of a Hunk */
          printf("Hunk_End(3F2)\n");
          break;
          case  Hunk_Code :  /* 3e9 */
          Header[0] = GrabLong(file1);  /* get length of code */
          printf("Hunk_Code(3E9) :%d words\n",Header[0]);
          Dump_Code(file1, Header[0]);
          break;
          case  Hunk_Data :
          case  Hunk_Bss  :
          Header[1] = GrabLong(file1);
          switch ( Header[0] )
            {
            case  Hunk_Data : printf("Hunk_Data(3EA) :"); break;
            case  Hunk_Bss  : printf("Hunk_Bss (3EB) :"); break;

            };
          printf("%d words\n",Header[1]);
          if( Header[0] != Hunk_Bss )Dump_Raw(file1,Header[0],Header[1]);
          break;
          case  Hunk_Debug:                /* debug hunks */
          Header[1] = GrabLong(file1);
          printf(" Hunk_Debug(3F1):(%d words)",Header[1]);
          Header[0] = GrabLong(file1);
          Header[1] = Header[1] - Header[0] - 1;
          Do_Name(file1,Header[0]);
          More_Stuff = Dump_Raw(file1,Header[0],Header[1]);
          break;
          case  Hunk_Name :
          case  Hunk_Unit :
          Header[1] = GrabLong(file1);
          switch ( Header[0] )
            {
            case Hunk_Unit :printf("Hunk_Unit(3E7"); break;
            case Hunk_Name :printf("Hunk_Name(3E8"); break;

            };
          Do_Name(file1,Header[1]);
          break;
          case  Hunk_Dreloc32:
          case  Hunk_Dreloc16:
          case  Hunk_Dreloc8 :
          case  Hunk_Reloc32 :
          case  Hunk_Reloc16 :
          case  Hunk_Reloc8  :
          Header[1] = GrabLong(file1);
          while( Header[1] != 0 && More_Stuff)
            {
            (void) Read(file1,(char *)&i,4);
            switch ( Header[0] )
              {
              case  Hunk_Dreloc32 : printf("Hunk_Dreloc32");break;
              case  Hunk_Dreloc16 : printf("Hunk_Dreloc16");break;
              case  Hunk_Dreloc8  : printf("Hunk_Dreloc8 ");break;
              case  Hunk_Reloc32  : printf("Hunk_Reloc32 ");break;
              case  Hunk_Reloc16  : printf("Hunk_Reloc16 ");break;
              case  Hunk_Reloc8   : printf("Hunk_Reloc8  ");break;

              };
            printf(" Hunk %d, %d words\n",i,Header[1]);
            More_Stuff = Dump_Raw(file1,Hunk_Code,Header[1]);
            Header[1] = GrabLong(file1);

            };
          break;
          case Hunk_Ext:
          printf("Hunk_Ext(3EF):\n");
          DoSymbolData(file1);
          break;
          case Hunk_Symbol:
          printf("Hunk_Symbol(3F0):\n");
          DoSymbolData(file1);
          break;
          case Hunk_Library:
          printf("Hunk_Library(3FA)\n");
          printf("   Value = %x\n",GrabLong(file1));
          break;
          case Hunk_Break:
          printf("Hunk_Break(3F6)\n");
          break;
          case Hunk_Overlay:
          printf("Hunk_Overlay(3F5)\n");
          Header[1] = GrabLong(file1);
          printf("%d words\n",Header[1]);
          Dump_Raw(file1,Header[0],Header[1]);
          break;
          case Hunk_Index:
          printf("Hunk_Index(3FB)\n");
          Header[1] = GrabLong(file1);
          printf("%d words\n",Header[1]);
          Dump_Raw(file1,Header[0],Header[1]);
          break;
          case Hunk_Header:
          printf("Hunk_Header(3F3)\n");
          Header[1] = GrabLong(file1);
          if( Header[1] == 0)
            {
            printf(" No Resident Libraries to open\n");

            }
          else
          while( Header[1] != 0 && More_Stuff)
            {
            Do_Name(file1,Header[1]);
            Header[1] = GrabLong(file1);

            };
          for( i=0; i<3; i++) Header[i] = GrabLong(file1);
          printf(" %d Hunks, Number %d thru %d\n",
          Header[0],   Header[1],  Header[2]);
          Dump_Raw(file1,Hunk_Code,Header[0]);
          break;
          default:
          printf( "Hunk type = %x\n",Header[0]);

          };

        };

      }
    else if( Flgs[21] )
      {
      Dump_Virus(file1);   /* if not regular then virus */

      };

    };
  if( file1 != NULL) Close( file1);
  if( Flgs[12] )
    {
    printf("Memory Dump as Code Hunk:60 bytess\n");
    (void)dumpcode(addrs,(char *)addrs,60); /* dump the code */

    };

  }
void Dump_Text(tptr,count)
char *tptr;
int count;
  {
  short t;
  for( t=0; t < count; t++)
    {
    tptr[t] = 0x7f & tptr[t];
    if( tptr[t] > 20 )
      {
      printf("%c",tptr[t]);

      }
    else  printf(".");

    };
  printf("\n");

  }
Dump_Raw(file,Type,Words)
BPTR file;
int Type,Words;
  {
  char *Data;
  char *tptr;
  int *k;
  short More_Stuff,i,j;
  if( Words == 0)return(0);
  Data = malloc(Words*4); /*get a large enough buffer */
  if( Data == 0 )
    {
    printf(" Memory not allocated for buffer:%d\n");
    exit(0);

    };
  More_Stuff = Read(file,Data,Words*4) == Words*4 ;
  i = j = 0;
  if( ( Flgs[2] && Type == Hunk_Code ) ||
  ( Flgs[3] && (Type == Hunk_Data || Type == Hunk_Debug) ) )
    {
    free(Data);
    return((int)More_Stuff);

    };
  while ( i < Words )
    {
    k = (int *)&Data[i*4];
    if ( i++ < Words)printf("%08.08X ",*k);
    if( ++j % 5 == 0)
      {
      tptr = &Data[(i-5)*4];
      Dump_Text(tptr,20);

      };

    };
  if( j % 5 != 0)
    {
    tptr = &Data[(i-5)*4];
    Dump_Text(tptr,20);

    };
  free(Data);
  return ((int)More_Stuff);

  }
Do_Name(file,Words)
int  Words;
BPTR file;
  {
  char *Data;
  printf("[%d words])",Words);
  if( Words > 100 || Words < 1)
    {
    printf("\n");
    return ( 0 );

    };
  Data = malloc(Words*4);
  if( Data == 0)
    {
    printf(" Memory not allocated for name:%d\n",Words);
    exit(10);

    };
  (void)Read(file,Data,Words*4);
  printf("%s\n",Data);
  free(Data);
  return(0);

  }
Dump_Code(file,Words)
BPTR file;
int Words;
  {
  char *Data; /* pointer to data */
  short More_Stuff;
  if( Words == 0)return(0);
  Data = malloc(Words*4); /*get a large enough buffer */
  if( Data == 0 )
    {
    printf(" Memory not allocated for buffer:%d\n");
    exit(10);

    };
  More_Stuff = Read(file,Data,Words*4) == Words*4 ;
  if( ! Flgs[2] )
    {
    (void)dumpcode((int)Data,Data,Words*4);

    };
  free(Data);
  return ((int)More_Stuff);

  }
Dump_Virus(file)  /* dump virus block code */
BPTR file;
  {
  char *Data;                /* pointer to data */
  short More_Stuff;
  int Words = 253;          /* preset the size */
  Data = malloc(Words*4);   /*get a large enough buffer to hold the virus */
  if( Data == 0 )
    {
    printf(" Memory not allocated for buffer:%d\n");
    exit(10);

    };
  printf(" Boot Block Header:\n");
  Dump_Raw(file,Hunk_Data,3);
  More_Stuff = Read(file,Data,Words*4) == Words*4 ;
  if( ! Flgs[2] )
    {
    (void)dumpcode((int)Data,Data,Words*4); /* dump the code */

    };
  free(Data);
  return ((int)More_Stuff);

  }
