/*
  Main.C
  Algebraical Virtual Assembler
  Uros Platise, Feb. 1998
*/

#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Global.h"
#include "Preproc.h"
#include "Lexer.h"
#include "Syntax.h"
#include "Segment.h"
#include "Symbol.h"
#include "Keywords.h"
#include "Reports.h"
#include "Object.h"
#include "Avr.h"


const char* version = "AVA Version 0.2.5, Uros Platise";
const char* arch_file = AVA_ARCH;
const char* help = 
"Syntax: ava [-pLv] [-Adevice] [-lI<filename>] [-I<dirname>] [-T{filename}]\n"
"            [-Dmacro{=val}] [-fmacro{=val}] [-o outfile] files ...\n"
"Files:\n"
"  file.s     Assembler Source\n"
"  file.o     Object; if not else specifed, this is the assembler default\n"
"  a.out      Linker default output file name\n\n"
"Switches:\n"
"  -o         Set output file name (to redirect the output to stdout: -o"
" stdout)\n"
"  -p         Use stdin for input and stdout for output if -o is not set.\n"
"  -A         Declare target device; same as: -Ddevice -Tarch.inc\n"
"  -D         Define macro with value 'val'. If 'val' is not given 1 is"
" assumed.\n"
"  -f         Define public macro of the form __macro{=val}\n"
"  -I         Add directory to the search list or include a file.\n"
"  -T         Auto-include the 'target.inc' file or the 'filename' if given.\n"
"             File specifed by the -T option is always first in the queue.\n"
"\n"
"  -L         Generate listing report (assembler only)\n"
"  -v         Verbose (enable info)\n"
"  -l         All reports, infos, errors and warnings are printed on the\n"
"             stderr. If log file is specified info is redirected.\n"
"             Errors and warnings are reported to the stderr and log file."
"";


TPreproc preproc;
TLexer lexer;
TGAS gas;
TSyntax syntax;
TSegment segment;
TSymbol symbol;
TKeywords keywords;
TReports reports;
TObject object;
PArch archp;

int main(int argc, char* argv[]){
  char ftype;
  bool linker=false, assembler=false;
  const char* include_targetfile=NULL;	/* always pushed last! */
  char* outfile=NULL;
  char* asmfile=NULL;
  int ai;
  TMicroStack<char *> files;
  try{
    for (ai=1; ai<argc; ai++){
      ftype = argv[ai][strlen(argv[ai])-1];

      
      if (argv[ai][0]=='-'){
        if (argv[ai][2]==0){
          switch(argv[ai][1]){
  	  case 'h': printf("%s\n%s\n", version, help); exit(1);
  	  case 'v': reports.IncVerboseLevel(); break;
	  case 'L': reports.listing.Enable(); break;
          case 'T':
	    if (include_targetfile!=NULL){
	      throw generic_error("Target file already defined.");
	    }
	    include_targetfile=&argv[ai][2]; 
	    break;
          case 'p': 
            files.push("stdin"); outfile="stdout"; asmfile="stdin";
            assembler=true; 
            break;
	  case 'e': break;
          case 'o': 
	    ai++; 
            if (strstr(argv[ai],".s")!=NULL){
              throw generic_error("Output file name has source extension"
                " `*.s'");
            }
            outfile=argv[ai];
	    break;	  
	  default: throw generic_error("Invalid switch.");
	  }
	}
	else if (argv[ai][0]=='-' && argv[ai][1]=='-'){
	  if (strcmp(&argv[ai][2], "help")==0){
	    printf("%s\n%s\n", version, help); exit(1);
	  }
	  else{throw generic_error("Invalid switch.");}
	}
        else{
          switch(argv[ai][1]){      
	  case 'l': reports.Config(&argv[ai][2]); break;
	  case 'D': {
              char *val = strchr(&argv[ai][2],'=');
              if (val==NULL){symbol.addMacro(&argv[ai][2],"1");}
              else{
                char buf[LX_STRLEN]; int i=0; 
                while(val!=&argv[ai][i+2]){buf[i]=argv[ai][i+2];i++;} buf[i]=0;
                symbol.addMacro(buf,val+1);
              }
            } break;
          case 'f': {
              char *val = strchr(&argv[ai][2],'=');
              char buf[LX_STRLEN]; strcpy(buf, "__");
              if (val==NULL){
                strcat(buf, &argv[ai][2]); symbol.addMacro(buf,"1");
              } else{
                int i=2; 
                while(val!=&argv[ai][i]){buf[i]=argv[ai][i];i++;} buf[i]=0;
                symbol.addMacro(buf,val+1,TSymbolRec::Public);
              }
            } break;
	  case 'I': {
	      struct stat file_info;
	      if (stat(&argv[ai][2], &file_info)<0){
	        throw file_error(&argv[ai][2]);
	      }
	      if (S_ISDIR(file_info.st_mode)){preproc.AddDir(&argv[ai][2]);}
	      else if (S_ISREG(file_info.st_mode)){files.push(&argv[ai][2]);}
	      else{
	        throw generic_error("Invalid file type for -I switch.");
	      }
	    } break;
	  case 'T':
	    if (include_targetfile!=NULL){
	      throw generic_error("Target file already defined.");
	    } 
	    include_targetfile=&argv[ai][2]; 
	    break;
	  case 'A':
	    if (include_targetfile!=NULL){
	      throw generic_error("Target file already defined.");
	    }
	    symbol.addMacro(&argv[ai][2],"1"); 
	    include_targetfile = arch_file;
	    break;
	  default: throw generic_error("Invalid switch.");
          }
	}
      }else{      
        switch(ftype){
        case 's': 
          if (assembler){
	    throw generic_error("Only one assembler source can"
	                        " be assembled at a time.");
          }
	  assembler=true;
          asmfile=argv[ai];
	  break;
        case 'o': 
          linker=true; 
          files.push(argv[ai]); 
          break;
        default: throw generic_error("Unknown file type.");
        }
      }
    }
    
    if (linker && assembler){ 
      throw generic_error("Only assembler or linker can be invoked at a time.");
    }
    /* if assembler source was given, put it on the list as last */
    if (assembler){files.push(asmfile);}
    
    /* resort files */
    if (files.empty()){
      fprintf(stderr,"%s: No input files.\n",argv[0]);exit(1);
    }
    while(!files.empty()){preproc.insert(files.pop());}

    if (assembler){
      preproc.AddDir(AVA_LIB);
      if (include_targetfile){
        char buf[LX_STRLEN];
        if (*include_targetfile==0){strcpy(buf,AVA_TARGET);}
        else{strcpy(buf,include_targetfile);}
        preproc.insert(preproc.FindFullPathName(buf));
      }
      object.assemble(outfile, asmfile);
    }
    if (linker){object.link(outfile);}
  }
  catch (segment_error &x){reports.Error(x);}
  catch (lexer_error &x){reports.Error(x);}
  catch (syntax_error &x){reports.Error(x);}
  catch (file_error &x){reports.Error(x);}
  catch (generic_error &x){reports.Error(x);}
  
  return reports.ErrorCount();
}

