/* Filter.c  program to read MSdos files and produce Amiga files 19/3/97 */

#include <stdio.h>
#include <stdlib.h>
#include <libraries/dos.h>
#include <intuition/intuition.h>
#include <workbench/startup.h>	     /*   */
#include <workbench/workbench.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <libraries/asl.h>

char VERSTAG[]="\0$VER: asltest 37.2";

/***********************************************************************/

struct Library  *AslBase;
struct FileRequester *FileRequester;
struct FileRequester *FileSave;
#define maxline 220

/************************************************************************/


struct TagItem MultiTags[] = {
	ASL_FuncFlags,FILF_PATGAD,
	ASL_Pattern,(ULONG)"#?.FD",
	ASL_Hail,(ULONG)"Select file to convert",
	TAG_DONE,
	};

struct TagItem MultiTagread[] = {
	ASL_FuncFlags,FILF_PATGAD,
	ASL_Pattern,(ULONG)"#?",
	ASLFR_TitleText,(ULONG)"Select File to filter",
   ASLFR_RejectIcons,TRUE,
   TAG_DONE,TAG_DONE
	};

struct TagItem MultiTagsave[] = {
	ASL_FuncFlags,FILF_PATGAD,
	ASL_Pattern,(ULONG)"#?",
	ASLFR_TitleText,(ULONG)"Save FIltered file as..",
   ASLFR_DoSaveMode,TRUE,
   ASLFR_RejectIcons,TRUE,
   ASLFR_InitialFile,(ULONG)".flt",
   TAG_DONE,TAG_DONE
	};


#define false 0
#define true !false
struct DiskObject *mydiskinfo;
LONG IconBase,_fromWB=true;
char found[maxline];
/************************************************************************/

int main(argc,argv)
int argc;
char *argv[];
{
char infilename[maxline],outfilename[maxline],
     progname[maxline],filtstr[maxline];
struct WBArg *wb_arg;
struct WBStartup *argmsg;
int  filtval=7;


  if(argc == 0 && argv) _fromWB=true;

  if (_fromWB){
     argmsg=(struct WBStartup *)argv;
     wb_arg=(struct WBArg *)argmsg->sm_ArgList;
     if (*wb_arg->wa_Name)
	strcpy(&progname[0],(char *)wb_arg->wa_Name);
     else
        strcpy(&progname[0],"Filter");

     if (OpenLibrary("intuition.library",0L)){
	if ((IconBase=(LONG)OpenLibrary("icon.library",0L))){

	  strcpy(filtstr,"");
          if ((mydiskinfo=(struct DiskObject *)GetDiskObject(&progname[0]))){
	     strcpy(&filtstr[0],(char *)FindToolType(mydiskinfo->do_ToolTypes,"FILTER"));
	     FreeDiskObject(mydiskinfo);
             sscanf(&filtstr[0],"%d",&filtval);
          }
          CloseLibrary(IconBase);
        }

        if ((AslBase = (struct Library  *)OpenLibrary(AslName,36)) != 0 ) {
           FileRequester = (struct FileRequester *)AllocAslRequest(ASL_FileRequest, NULL);
           if (FileRequester != NULL){
              FileSave = (struct FileRequester *)AllocAslRequest(ASL_FileRequest, NULL);
              if (FileSave != NULL){

                 while(AslRequest(FileRequester,MultiTagread)) {
                    Parsename(FileRequester,&infilename[0]);
                    if (AslRequest(FileSave,MultiTagsave)){
                       Parsename(FileSave,&outfilename[0]);
                       if (strcmp(infilename,outfilename))
                          repeat_work(infilename,outfilename,(char)filtval);
                       else
                         printf("whoops, both names are same!\n");
                    }
	         }

                 FreeAslRequest(FileSave);
              }
              FreeAslRequest(FileRequester);
           }else
	       printf("Failed to allocate file request\n");

           CloseLibrary(AslBase);
        }else
	    printf("Can't open asl.library\n");
      }
   }
   else
      if (argc==3){
         strcpy(infilename,argv[1]);
         strcpy(outfilename,argv[2]);
         sscanf(argv[3],"%d",&filtval);
         repeat_work(infilename,outfilename,(char)filtval);
      }else
          printf("Usage: Filter <infile> <outfile> <filter>\n");

   exit(0);
   return(0);
}

/* ------------------------------------------------------------------- */
Parsename(FileReq,name)
struct FileRequester *FileReq;
char *name;
{
char filestring[maxline];

    if (strlen(FileReq->rf_Dir)){
       if (FileReq->rf_Dir[strlen(FileReq->rf_Dir)-1]==':')
          sprintf(&filestring[0],"%s%s",FileReq->rf_Dir,FileReq->rf_File);
       else
          sprintf(&filestring[0],"%s/%s",FileReq->rf_Dir,FileReq->rf_File);
    }else
        sprintf(&filestring[0],"%s",FileReq->rf_File);
    strcpy(name,&filestring[0]);

}
/* ------------------------------------------------------------------- */
repeat_work(infilename,outfilename,filtval)
char *infilename,*outfilename,filtval;
{
FILE *infile,*outfile;
char *inbuffer,*buffer;
int  exit_loop=0,offset=0;
long filesize=0;

      if ((infile=fopen(infilename,"r"))){
         if ((outfile=fopen(outfilename,"w"))){
            printf("Reading file '%s' with filter %d.....\n",infilename,filtval);
            filesize=get_filesize(infile);
            if (buffer =malloc(filesize)){
               inbuffer=buffer;
               fread(inbuffer,filesize,1,infile);
               do{
                   if (*inbuffer!=filtval)
                      fwrite(inbuffer,1,1,outfile);
                   inbuffer++;
                   offset++;

               }while(offset<filesize);
               free(buffer);
            }
            fclose(outfile);
            printf("Filter compleate.\n");
         }else
             printf("Could not open file '%s'\n",outfilename);
         fclose(infile);
      }else
          printf("Could not open file '%s'\n",infilename);

}
/* ======================================================================= */
FindTooltype(list,find)
char **list;
char *find;
{
char temp[maxline];
int  index=0,index2=0;

   while(list[index])
   {
      strcpy(&temp[0],list[index]);
      temp[strlen(find)]=0;	       /* just start of tooltype */

      while(temp[index2])
      {
	 temp[index2]=toupper(temp[index2]);
	 index2++;
      }

      if (strcmp(&temp[0],find)==0)
      {
	 strcpy(&temp[0],list[index]);
	 if (strlen(temp)>strlen(find))
	 {
	    strcpy(&found[0],&temp[strlen(find)+1]);
	 }
	 return ((char *)&found[0]);
      }
      index++;
   }
   return (0);
}
/* ======================================================================= */
get_filesize(filepointer)
FILE *filepointer;
{
long origpos,sizepos;

   origpos=ftell(filepointer);
   fseek(filepointer,0,SEEK_END);                /* go to end of file */
   sizepos=ftell(filepointer);
   fseek(filepointer,origpos,SEEK_SET);  /* report position, ie size */
   return(sizepos);
}
/* ====================================================================== */
