#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/dos.h>
#include <ctype.h>

UBYTE mem[256],buf[256],base[256];

struct FileHandle *in,*out,*make,*tmp;

BOOL ReadLine()
{
 long i,j;

 j=0;
 do
  {
   i=Read(in,&mem[j],1L);
   j++;
  } while((i==1)&&(mem[j-1]!=0xa));
 if(j>1)
  {
   mem[j-1]=0x00;
   return(TRUE);
  }
 return(FALSE);
}

void main(argc,argv)
 long   argc;
 UBYTE *argv[];
{
 BOOL bool;
 long i,cmds;

 puts("LL Linker-Library-Erstellung  -  Version 1.00");

 if(argc!=2)
  {
   puts("Aufruf: LL [CFD-Asm-Datei]");
   exit(0);
  }

 in=Open(argv[1],MODE_OLDFILE);
 if(in==NULL)
  {
   printf("Fehler: Kann <%s> nicht öffnen!\n",argv[1]);
   exit(0);
  }

 make=Open("t:makeit",MODE_NEWFILE);
 if(make==NULL)
  {
   Close(in);
   puts("Fehler: Kann <t:makeit> nicht erstellen!");
   exit(0);
  }

 tmp=Open("t:ll.$$$",MODE_READWRITE);
 if(tmp==NULL)
  {
   Close(in);
   Close(make);
   puts("Fehler: Kann <t:ll.$$$> nicht erstellen!");
   exit(0);
  }

 sprintf(&buf,"copy ccs:bin/as t:\ncopy ccs:bin/lb t:\necho \"Assemblieren...\"\n");
 Write(make,&buf,strlen(&buf));

 bool=ReadLine();
 strcpy(&base,&mem);

 cmds=0;
 strcpy(&buf,"t:lb ram:amiga.lib -a+ ");
 Write(tmp,&buf,strlen(&buf));

 do
  {
   bool=ReadLine();
   if(bool)
    {
     if(!(strncmp(&mem,"   XDEF _LVO",12)))
      {
       if(out) Close(out);
       out=NULL;
       if(isupper(mem[12]))
        {
         sprintf(&buf,"t:%s.asm",&mem[12]);
         out=Open(&buf,MODE_NEWFILE);
         if(out==NULL)
          {
           printf("Fehler: Kann <%s> nicht erstellen!\n",&buf);
           bool=FALSE;
          }
         else
          {
           cmds++;
           if(cmds>12)
            {
             cmds=0;
             strcpy(&buf,"\nt:lb ram:amiga.lib -a+ ");
             Write(tmp,&buf,strlen(&buf));
            }
           sprintf(&buf,"t:%s.o",&mem[12]);
           Write(tmp,&buf,strlen(&buf));
           Write(tmp," ",1L);

           Write(out,&base,strlen(&base));
           Write(out,"\n",1L);
           Write(out,&mem,strlen(&mem));
           Write(out,"\n",1L);

           sprintf(&buf,"t:as >nil: t:%s.asm -C -D\n",&mem[12]);
           Write(make,&buf,strlen(&buf));
          }
        }
      }
     else
      {
       if(out)
        {
         Write(out,&mem,strlen(&mem)); 
         Write(out,"\n",1L);
        }
      }
    }
  } while(bool==TRUE);

 strcpy(&buf,"echo \"Anfügen...\"\n");
 Write(make,&buf,strlen(&buf));

 Seek(tmp,0,OFFSET_BEGINNING);
 i=Read(tmp,&buf,250);
 while(i>0)
  {
   Write(make,&buf,i);
   i=Read(tmp,&buf,250);
  }  
 
 strcpy(&buf,"\ndel t:#?.o quiet\ndel t:#?.asm quiet\necho \"Fertig.\"\n");
 Write(make,&buf,strlen(&buf));

 if(out) Close(out);
 Close(make);
 Close(in);
 Close(tmp);
 DeleteFile("t:ll.$$$");
}

