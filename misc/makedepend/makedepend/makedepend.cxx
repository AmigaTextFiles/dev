
#include "stringclass.h"
#include <new.h>

#ifndef __SASC__
#include <unistd.h>
#include <ctype.h>

int stricmp(char *p1, char *p2)
{
   while(*p1 && toupper(*p1)==toupper(*p2)) {p1++;p2++;}
   return toupper(*p1)!=toupper(*p2);
}

#endif



#define STARTMAXREF 4

struct Datei {
   struct Datei *next;

   String filename;
   String pathfile;
   String objfile;

   int marked;
   int ignore;

   struct Datei **ref;
   int refcnt;
   int maxref;
};


#define MAXINCLUDE 64

int  includeCnt;
String includedir[MAXINCLUDE];




void New_Handler()
{
   fprintf(stderr,"Out of memory");
   exit(EXIT_FAILURE);
}


Datei *files;

Datei *FindFile(String filename)
{
   Datei *f;

   for(f=files;f;f=f->next) {
      if(!stricmp(f->filename,filename)) return f;
   }

   return NULL;
}
Datei *FindPathFile(String filename)
{
   Datei *f;

   for(f=files;f;f=f->next) {
      if(!stricmp(f->pathfile,filename)) {
         return f;
      }
   }

   return NULL;
}
Datei *FindAddFile(String filename)
{
   Datei *d,*f;


   for(f=files;f;f=f->next) {
      if(!stricmp(f->filename,filename)) return f;
   }

   d=new Datei;

   d->next=NULL;
   d->filename=filename;
   d->marked=0;
   d->ignore=0;

   d->ref=new Datei *[STARTMAXREF];
   d->refcnt=0;
   d->maxref=STARTMAXREF;


   if(!files) {
      files=d;
   } else {
      for(f=files;f->next;f=f->next);
      f->next=d;
   }
   return d;
}
void AddRef(Datei *dat,Datei *ref)
{
   if(dat->refcnt<dat->maxref) {
      dat->ref[dat->refcnt++]=ref;

   } else {

      dat->maxref<<=1;
      Datei **newref=new Datei *[dat->maxref];

      int i;

      for(i=0;i<dat->refcnt;i++) newref[i]=dat->ref[i];
      delete[] dat->ref;
      dat->ref=newref;
   }
}
void DoFile(Datei *dat)
{
   FILE *fp;
   String line;

   int i;

   for(i=-1;i<includeCnt;i++) {

      String filename;

      if(i>=0) {
         filename=includedir[i];
         if(filename[filename.Len()-1]!=':' && filename[filename.Len()-1]!='/')
               filename+='/';
         filename+=dat->filename;
      } else {
         filename=dat->filename;
      }

      if(fp=fopen(filename,"r")) {

         if(FindPathFile(filename)) {
            dat->ignore=1;
            return;  // Datei-Referenzen wurden schon bearbeitet
         }

         if(stricmp(filename,dat->filename)) dat->pathfile=filename;

         printf("processing %s ... ",(char *)filename);

         int status=0xff;

         while(line.ReadLn(fp)>=0) {

            while(status==0xff) { // goto-Vermeidung :-) - Die Schleife wird immer nur einmal durchlaufen

               if(line[0]!='#') break;

               int i;
               for(i=1;i<line.Len() && (line[i]==' ' || line[i]=='\t');i++);
               line.Skip(i);

               if(line.Left(7)!="include") break;

               for(i=7;i<line.Len() && (line[i]==' ' || line[i]=='\t');i++);
               line.Skip(i);

               if(line[0]!='"') break;
               i=line.Index('"',1);
               line=line.Mid(1,i-1);

               if(line.Len()==0) break;

               Datei *ref;

               ref=FindAddFile(line);
               AddRef(dat,ref);
               break;
            }

            int i=line.Len();
            unsigned char *c=line;


#define STAT(s,c) ((s&0xff00)|(c&s))

            for(;i-->0;c++) {

               switch(STAT(status,*c)) {

                  case STAT(0x0ff,'"'):   status=0x1ff;break;
                  case STAT(0x0ff,'\''):  status=0x3ff;break;
                  case STAT(0x0ff,'/'):   if(i>0) {
                                             if(c[1]=='/') i=0;   // Kommentat
                                             else if(c[1]=='*') {
                                                i--;
                                                c++;
                                                status=0x5ff;
                                             }
                                          }
                                          break;


                  // Strings
                  case STAT(0x1ff,'\\'):  status=0x200;break;
                  case STAT(0x1ff,'"'):   status=0x0ff;break;
                  case STAT(0x200,0):     status=0x1ff;break;

                  // Characters
                  case STAT(0x3ff,'\\'):  status=0x400;break;
                  case STAT(0x3ff,'\''):  status=0x0ff;break;
                  case STAT(0x400,0):     status=0x3ff;break;

                  // Kommentar
                  case STAT(0x5ff, '*'):  if(i && c[1]=='/') {
                                             i--;
                                             c++;
                                             status=0xff;
                                          }
                                          break;
               }
            }
         }
         if(status!=0xff) {
            if(status==0x1ff || status==0x200) printf("unterminated string-constant\n");
            else if(status==0x3ff || status==0x300) printf("unterminated character-constant\n");
            else if(status==0x5ff) printf("unterminated comment\n");
         } else {
            puts("done");
         }
         fclose(fp);
         return;
      }
   }
   printf("file %s not found\n",(char *)dat->filename);
}

int AddObject(String file) // Anzahl der Objekte, die ergänzt wurden
{
   char *suffix[]={".c",".cxx",".cc",".cpp",".c++"};
   int i,j;


   String origfile=file;

   if((i=file.Index('/'))>=0) file.Skip(i+1);

   if(file.Right(2)==".o") {

      //String basename=file.Left(file.Len()-2);

      for(i=-1;i<includeCnt;i++) {

         for(j=0;j<2;j++) {

            String basename;
            if(j==0) basename=file.Left(file.Len()-2);
            else basename=origfile.Left(origfile.Len()-2);

            String filename;

            if(i>=0) {
               filename=includedir[i];
               if(filename[filename.Len()-1]!=':' && filename[filename.Len()-1]!='/')
                     filename+='/';
               filename+=basename;
            } else {
               filename=basename;
            }

            int a;

            for(a=0;a<sizeof(suffix)/sizeof(suffix[0]);a++) {
               String f=filename+suffix[a];

               if(!access(f,F_OK)) {

                  if(FindFile(f)) return 0; // Datei doppelt -> kein Fehler, aber nichts einfügen

                  Datei *d=FindAddFile(f);
                  d->objfile=origfile;
                  return 1;
               }
            }
         }
      }
   } else if((i=file.RIndex('.'))>=0) {
      String basename=file.Left(i);

      if(FindFile(origfile)) return 0; // Datei doppelt -> kein Fehler, aber nichts einfügen

      Datei *d=FindAddFile(origfile);
      d->objfile=basename+".o";

      return 1;
   }

   fprintf(stderr,"No sourcecode found for '%s'\n",(char*)origfile);
   return 0;
}


int lineLen;

void PrintRef(FILE *out, Datei *dat)
{
   if(dat->marked || dat->ignore) return;

   dat->marked=1;
   if(dat->pathfile.Len()) {

      if(lineLen+dat->pathfile.Len()>70) {
         fprintf(out, "\\\n\t");
         lineLen=4;
      }

      fprintf(out," %s",(char *)dat->pathfile);
      lineLen+=dat->pathfile.Len()+1;
   } else {
      if(lineLen+dat->filename.Len()>70) {
         fprintf(out, "\\\n\t");
         lineLen=4;
      }

      fprintf(out," %s",(char *)dat->filename);
      lineLen+=dat->filename.Len()+1;
   }

   int i;

   for(i=0;i<dat->refcnt;i++) {
      PrintRef(out,dat->ref[i]);
   }
}
void ResetMarks()
{
   Datei *f;

   for(f=files;f;f=f->next) f->marked=0;
}


void usage(char *progname)
{
   fprintf(stderr,"Makedepend © 1997 by Matthias Meixner\n\n"
                  "Usage: %s [-f <makefile>] [-i <idir>]  [-head <head>] <file1.o> [<file2.o> ...]\n"
                  "      The beginning of the dependencies in the makefile\n"
                  "      must be marked by '#DEPENDENCIES'\n",progname);
}

main(int argc, char *argv[])
{
   set_new_handler(New_Handler);

   if(argc<3) {
      usage(argv[0]);
      exit(1);
   }

   int i;

   String makefile="makefile";
   String head="";

   int objectCnt=0;

   for(i=1;i<argc;i+=2) {
      if(!stricmp(argv[i],"-i")) {
         if(includeCnt<MAXINCLUDE) {
            includedir[includeCnt++]=argv[i+1]?argv[i+1]:"";
         } else {
            fprintf(stderr,"Too many entries in includepath\n");
         }
      } else if(!stricmp(argv[i],"-f")) {
         makefile=argv[i+1]?argv[i+1]:"";
      } else if(!stricmp(argv[i],"-head")) {
         head=argv[i+1]?argv[i+1]:"";
      } else if(argv[i][0]=='-') {
         fprintf(stderr,"Unknown option %s\n",argv[i]);
         exit(1);
      } else {
         break;
      }
   }

   if(i>argc) {
      usage(argv[0]);
      exit(1);
   }


   for(;i<argc;i++) {
      objectCnt+=AddObject(argv[i]);
   }

   Datei *f;


   for(f=files;f;f=f->next) DoFile(f);

   FILE *in,*out;

   if(in=fopen(makefile,"r")) {
      String outname=makefile+".new";

      if(out=fopen(outname,"w")) {

         printf("patching makefile\n");

         String line;

         while(line.ReadLn(in)>=0) {
            if(line.Left(13)=="#DEPENDENCIES") break;

            if(fputs(line,out)==EOF || putc('\n',out)==EOF) {
               fprintf(stderr,"Write error\n");
               exit(1);
            }
         }

         if(fputs("#DEPENDENCIES\n\n",out)==EOF) {
            fprintf(stderr,"Write error\n");
            exit(1);
         }


         for(i=0,f=files;i<objectCnt && f;i++,f=f->next) {
            fprintf(out,"%s%s:",(char *)head,(char *)f->objfile);
            lineLen=head.Len()+f->objfile.Len()+1;
            ResetMarks();
            PrintRef(out,f);
            fputs("\n\n",out);
            if(ferror(out)) {
                fprintf(stderr,"Write error\n");
               exit(1);
            }
         }

         if(fclose(out)==EOF) {
            fprintf(stderr,"Write error\n");
            exit(1);
         }

         String bakname=makefile+".bak";

         if(!access(bakname,F_OK)) {
            if(remove(bakname)) {
               fprintf(stderr,"Could not remove '%s'\n",(char *)bakname);
            }
         }

         if(rename(makefile,bakname)) {
            fprintf(stderr,"Could not rename '%s' to '%s'\n",(char *)makefile,(char *)bakname);
         }

         if(rename(outname,makefile)) {
            fprintf(stderr,"Could not rename '%s' to '%s'\n",(char *)outname,(char *)makefile);
         }

      } else {
         fprintf(stderr,"Cannot create file '%s'\n",(char *)outname);
         exit(1);
      }
   } else {
      fprintf(stderr,"Cannot open file '%s'\n",(char *)makefile);
      exit(1);
   }
   return 0;
}




