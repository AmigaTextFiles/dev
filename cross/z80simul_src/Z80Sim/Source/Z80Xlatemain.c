/* -----------------------------------------------------------------
    Z80XLATEMAIN.C The Finite State Machine for the Z80 translator
                   program.

    PATHNAME:      MAIN:CPGM/Z80/Z80Xlatemain.c

    PARAMTERS:     Z80.regs must exist or the translator will exit
                   before a translation is attempted.  It contains
                   all of the register startup values that the Z80
                   simulator program will load along with the object
                   code translated by Z80Xlate.

    SEQUENCE:      z80xlate <intel_input >z80.cfg_file

    LAST CHANGED:  03/02/94
                   03/01/94
                   05/21/89

   ----------------------------------------------------------------- */

#include  <stdio.h>
#include  <string.h>
#include  <ctype.h>
#include  <MyFunctions.h>

/*  Action functions used by this machine */

void   echo( void ), skip( void ), show( void );
void   error( void ), line_inc( void );

void   process( void );
void   addr1( void ), addr2( void );
void   type( void );
void   dataproc( void ), termrec( void );
void   review( void ), complete( void );


#define  EMPTY    -1
#define  STOP     0

      /* Defines for Symbol names: */

#define   unallowed              0
#define   white                  1
#define   colon                  2
#define   byte                   3
#define   eol                    4
#define   eof                    5    /* not used yet! */

      /* Defines for State names: */
#define   start                  0
#define   intel                  1
#define   count                  2
#define   hi_addr                3
#define   lo_addr                4
#define   rectype                5
#define   data                   6
#define   check                  7
#define   accept                 8
#define   forbid                 9

struct   transitions    {

      int   nextstate;
      void  (*act)(void );
      };

struct transitions  fsm_table[][6] = {

   /*
      unallowed    white   colon   byte   eol   eof
   */

/*  start */

   forbid,error,  start,skip,     intel,show,
   forbid,error,  start,line_inc, STOP,complete,

/*  intel */

   forbid,error,  intel,skip,     forbid,error,
   count,process, intel,line_inc, STOP,complete,

/*  count */

   forbid,error,  count,skip,     forbid,error,
   hi_addr,addr1, count,line_inc, STOP,complete,

/*  hi_addr */

   forbid,error,  hi_addr,skip,     forbid,error,
   lo_addr,addr2, hi_addr,line_inc, STOP,complete,

/*  lo_addr */

   forbid,error,  lo_addr,skip,     forbid,error,
   rectype,type,  lo_addr,line_inc, STOP,complete,

/*  rectype */

   forbid,error,  rectype,skip,     forbid,error,
   data,dataproc, rectype,line_inc, STOP,complete,

/*  data */

   forbid,error,  data,skip,        forbid,error,
   check,review,  data,line_inc,    STOP,complete,

/*  check */

   forbid,error,  check,skip,       forbid,error,
   check,review,  accept,termrec,   STOP,complete,

/*  accept */

   forbid,error,  accept,skip,       intel,show,
   forbid,error,  accept,line_inc,   STOP,complete,

/*  forbid */

   forbid,error,  forbid,error,     intel,show,
   forbid,error,  forbid,line_inc,  STOP,complete
   
};

static int   mstate, token;

extern char *yytext;


/* Code for FSM Start_Function(): */

int   main( int argc, char **argv )
{
   extern   int yylex( void );
   
   int      ch;
   char     REGFILE[] = "Z80.regs", *regfile = &REGFILE[0];
   FILE     *RegFile;

   mstate = start;
   token  = EMPTY;

   if (argc != 1) 
      {
      fprintf( stderr, "USAGE: %s <IntelHexFile >Z80.cfg_File\n", argv[0] );
      exit( 120 );
      }
   if ((RegFile = fopen( regfile, "r" )) == NULL)  
      {
      fprintf( stderr, "Couldn't open %s to read!\n", regfile );
      exit( 224 );
      }

   while ((ch = getc( RegFile )) != EOF)
      (void) fputc( ch, stdout );               /* echo to stdout */
   fclose( RegFile );

   do {
      token = yylex();
      (*fsm_table[ mstate ][ token ].act)();
      mstate = fsm_table[ mstate ][ token ].nextstate;
      }
      while (mstate != STOP);
   return( 0 );
}

  /* Start of code section! */

int    checksum;
int    bytecount;
int    loadaddr;
int    typerec;
int    linenum = 0;

int    chs_to_byte( char ch1, char ch2 )
{
   int   rval = 0;

   ch1 = toupper( ch1 );
   ch2 = toupper( ch2 );

   if (ch1 >= '0' && ch1 <= '9')
      rval = ch1 - '0';
   else if (ch1 >= 'A' && ch1 <= 'F')
      rval = ch1 - 'A' + 10;
   rval <<= 4;

   if (ch2 >= '0' && ch2 <= '9')
      rval += ch2 - '0';
   else if (ch2 >= 'A' && ch2 <= 'F')
      rval += ch2 - 'A' + 10;
   remove_substring( yytext, 0, 2 );

   return( rval );
}

void  complete( void )
{
   fprintf( stdout, "END\n" );
   fprintf( stderr, "Completed!\n" );
   return;
}

void   line_inc()  { linenum++; return; }

void   termrec( void )
{
   fprintf( stdout, "\n@\n" );
   line_inc();
   return;
}

void   process( void )
{
   checksum   = 0x00;
   bytecount  = chs_to_byte( *yytext, *(yytext + 1) );
   if (bytecount == 0) 
      {
      complete();
      exit( 1 );
      }
   checksum  += bytecount;
   return;
}

void   addr1( void )
{
   loadaddr   = chs_to_byte( *yytext, *(yytext + 1) );
   checksum   = ((checksum + loadaddr) & 0xFF);
   loadaddr <<= 8;
   return;
}

void   addr2( void )
{
   char  *addrout, ad2_nil[5];
   int   tempaddr = 0;

   addrout   = &ad2_nil[0];
   loadaddr += chs_to_byte( *yytext, *(yytext + 1) );
   tempaddr  = loadaddr;
   to_hexstr( loadaddr, addrout, 4 );
   checksum  = ((checksum + tempaddr) & 0xFF);
   fprintf( stdout, "LOAD\n%s\n", addrout );
   return;
}

void   type( void )
{
   typerec  = chs_to_byte( *yytext, *(yytext + 1) );
   checksum = ((checksum + typerec) & 0xFF);
   return;
}

void   dataproc( void )
{
    static short   howmany = 1;
    char           c1, c2;

   c1 = toupper( *yytext );
   c2 = toupper( *(yytext + 1) );

   if (howmany < 4)  
      {
      fprintf( stdout, "%c%c ", c1, c2 );
      howmany++;
      }
   else  
      {
      fprintf( stdout, "%c%c\n", c1, c2 );
      howmany = 1;
      }
   checksum = ((checksum + chs_to_byte( *yytext,
                                        *(yytext + 1) )) & 0xFF);
   if (bytecount > 0)
      bytecount--;
   return;
}

void   review( void )
{
   if (bytecount > 0)
      dataproc();       /* haven't reached the checksum byte yet! */
   else  {
      checksum = ((checksum + chs_to_byte( *yytext,
                                           *(yytext + 1) )) & 0xFF);
      if (checksum != 0)
         fprintf( stderr, "Checksum incorrect for line %d\n", linenum );
      }
   return;
}

void   error( void )
{
   fprintf( stderr, "\nERROR!  Unknown character or malformed file.\n");
   fprintf( stderr, "Found on line # %d!\n", linenum );
   return;
}

void   skip( void ) { return; }

void   show( void )
{
   static short int    accross = 0;

   if (accross < 80)   
      {
      fprintf( stderr, ":" );
      accross++;
      }
   else {
      fprintf( stderr, "\n" );
      accross = 0;
      }
   *yytext = '\0';
   return;
}

/* ---------------------- End of Z80Xlatemain.c ------------------------ */
