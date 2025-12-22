#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "genglue.h"
#include "machine.h"

int reverse,basepar,baserel,single;
char *precede="",*precedevec="";
char *progname;

char namebuf[80];
int regbuf[NUMREGS];
int regbufcnt;
int liboffset;
int libbasereg=DEFAULTBASEREG;
char libbasevar[30];
int preserve;
int linecount=0;
int iflag;

void skipcomment(void)
{
  int c;
  while((c=getchar())!='\n'&&c!=EOF)
    ;
  ungetc(c,stdin);
}

char *commands[]=
{
  "flags","offset","basereg","basevar"
};

void getcommand(void)
{
  char command[20];
  int i,c,commandcount=0;
  while(islower(c=getchar())&&commandcount<20)
    command[commandcount++]=c;
  if(c!=' ')
  {
    exit(20);
  }
  for(i=0;i<sizeof(commands)/sizeof(char *);i++)
    if(!strncmp(command,commands[i],commandcount))
    {
      switch(i)
      {
        case 0: /* flags */
        {
          int d;
          d=getchar();
          if(d=='-'||d=='+')
          {
            while(islower(c=getchar()))
              switch(c)
              {
                case 'p': /* Preserve all registers */
                  preserve=(d=='+'?2:0);
                  break;
                case 'q': /* Preserve all address registers */
                  preserve=(d=='+');
                  break;
                case 'b': /* Function may destroy contents of a5/a6 too */
                  preserve=(d=='+'?-1:0);
                  break;
                case 'd': /* Function may destroy all registers */
                  preserve=(d=='+'?-2:0);
                  break;
                case 'i': /* Return result in Z bit of ccr */
                  iflag=(d=='+');
                  break;
                default:
                  fprintf(stderr,"Invalid flag: %c\n",c);
                  exit(20);
                  break;
	      }
	  }else
            ungetc(d,stdin);
          ungetc(c,stdin);
          break;
	}
      case 1: /* offset */
      {
        liboffset=0;
        while(isdigit(c=getchar()))
          liboffset=liboffset*10+(c-'0');
        ungetc(c,stdin);
        break;
      }
      case 2: /* basereg */
      {
        if(regnum(c=getchar())<0)
          ERROR("Invalid register name");
        libbasereg=regnum(c);
        if(libbasereg==SPREGNUM)
          ERROR("Invalid base register");
        break;
      }
      case 3: /* basevar */
      {
        int basenamecnt=0;
        if(isalpha(c=getchar())||c=='_')
        {
          libbasevar[basenamecnt++]=c;
          while((isalnum(c=getchar())||c=='_')&&basenamecnt<29)
            libbasevar[basenamecnt++]=c;
	}
        libbasevar[basenamecnt++]='\0';
        if(!basenamecnt)
          ERROR("Invalid base variable name");
        ungetc(c,stdin);
        break;
      }
      default:
        ERROR("Invalid command");
        break;
      }
    }
}

void getline(void)
{
  int c;
  int namebufcnt=0;
  regbufcnt=0;
  while(((c=getchar())=='_'||isalnum(c))&&namebufcnt<79)
    namebuf[namebufcnt++]=c;
  namebuf[namebufcnt++]='\0';
  if(c==',')
  {
    while(regnum(c=getchar())>=0&&regbufcnt<NUMREGS)
      regbuf[regbufcnt++]=regnum(c);
  }
  ungetc(c,stdin);
}

void putglue(void)
{
  if(reverse)
    reverseglue();
  else
    normglue();
}

int main(int argc,char *argv[])
{
  int i,fc=0,c;

  progname=argv[0];

  for(i=1;i<argc;i++)
  {
    if(argv[i][0]!='-')
    {
      switch(fc++)
      {
        case 0:
          if(freopen(argv[i],"r",stdin)==NULL)
          {
            fprintf(stderr,"%s: Couldn't open input file '%s'\n",progname,argv[i]);
            exit(20);
          }
          break;
        case 1:
          if(freopen(argv[i],"w",stdout)==NULL)
          {
            fprintf(stderr,"%s: Couldn't open output file '%s'\n",progname,argv[i]);
            exit(20);
          }
          break;          
      }
    }else
    {
      if(argv[i][1])
        switch(argv[i][1])
        {
          case 'r': /* Build the library part of the glue */
            reverse=1;
            break;
          case 'l': /* Add library base to the paramater list (as first argument) */
            basepar=1;
            break;
          case 'b': /* Baserelative code */
            baserel=1;
            break;
          case 's': /* Generate single files */
            single=1;
            break;
          case 'p': /* Precede functionnames with string */
            if(++i>=argc)
              ERROR("Missing argument");
            precede=argv[i];
            break;
          case 'q': /* Precede the jump vector's name with string */
            if(++i>=argc)
              ERROR("Missing argument");
            precedevec=argv[i];
            break;
          default:
            fprintf(stderr,"%s: Invalid option -%c\n",argv[0],argv[i][1]);
            break;
        }
    }
  }
  while((c=getchar())!=EOF)
  {
    linecount++;
    if(c=='#')
      skipcomment();
    else if(c=='@')
      getcommand();
    else if(isalpha(c)||c=='_')
    {
      ungetc(c,stdin);
      getline();
      if(single)
      {
        char namebuf2[100];
        namebuf2[0]='\0';
        strncat(namebuf2,precede,100);
        strncat(namebuf2,namebuf,100);
        strncat(namebuf2,".s"   ,100);

        if(freopen(namebuf2,"w",stdout)==NULL)
        {
          fprintf(stderr,"%s: Couldn't open output file '%s'\n",progname,namebuf2);
          exit(20);
        }        
      }
      putglue();
      liboffset++;
    }else if(c=='\n')
      ungetc(c,stdin);
    else
      ERROR("Syntax error");
    if((c=getchar())!='\n'&&c!=EOF)
      ERROR("Syntax error");
  }
  return 0;
}
