/****************************************************************************
*   Extract.c								    *
*   									    *
*   Chas A. Wyndham     29th Nov 1992. 					    *
*									    *	
*   Compiles under Lattice 6 and links with decomp.o and macros.o to make   *
*   Hextract2, a programme for accessing header-file data.		    *
*									    *
*   This code is Freeware like Hextract itself.  You are welcome to improve *
*   it - but please send me a copy.					    *
*									    *
****************************************************************************/
  		
#include "exec/types.h"
#include "exec/memory.h"
#include "graphics/gfxbase.h"
#include "libraries/dos.h"
#include "intuition/intuition.h"
#include "intuition/intuitionbase.h"
#include "workbench/startup.h"
#include "string.h"
#include "stdlib.h"
#include "clib/all_protos.h"

#define ___main=___tinymain

extern struct WBStartup *_WBenchMsg;
char                    vers[] = "$VER: Hextract2 V1.1" ;

struct IntuitionBase    *IntuitionBase ;
struct Library          *GfxBase ;
struct Library          *IBase ;
struct Screen           *screendata ; 
BPTR                    window, fi ;
BPTR                    lock = 0, oldlock = 0 ;
char                    fhead[50], buffer[256], line[256] ;
APTR                    febuf=0, inbuf=0 ;
char                    winbase[] = "CON:100/0/400/30/HextractV2-" ;  
int                     found = 0, located = 0 ;
int                     fesize, insize, n, libh = 0 ;

unsigned int   DECOMPA (APTR, APTR) ;
int    cleanup (void) ;
VOID   getwin (void) ;
VOID   showlib(void) ;
VOID   search(void) ;
VOID   chkabort (void) ;
int    onbreak (int(*)(void)) ;
char   *fgts (char *) ;
int    stcpmw (char*, char*) ;
int    stcpmwa (char*, char*) ;

UWORD  *cptr ;
UWORD  chip ptrImage[] = {  
	 0x0000, 0x0000,
	 0x6018, 0x0000,
	 0xc00c, 0x0000,
	 0xc30c, 0x0000,
	 0xc78c, 0x0000,
	 0xcccc, 0x0000,
	 0x7878, 0x0000,
	 0x3030, 0x0000,
	 0x0000, 0x0000,  };

main(argc, argv)
int   argc ;
char  *argv[] ;
{
        
   char              header[2] ;
   unsigned int      i = 0, result = 1, win = 1, cont, iscomp = 0 ;
   char              ch ;
   BPTR              fum ;
   int               FromWb ;
   struct WBArg      *arg;  

   IBase = OpenLibrary("intuition.library", 0) ;
   IntuitionBase = (struct IntuitionBase *)IBase ;
   GfxBase = OpenLibrary("graphics.library",0) ;

   cptr = ptrImage ;

   screendata = (struct Screen *)AllocMem(30, MEMF_PUBLIC) ;
   GetScreenData (screendata, 30, WBENCHSCREEN, NULL) ;
        
   FromWb = (argc==0) ? TRUE : FALSE;
   if((FromWb)&&(_WBenchMsg->sm_NumArgs >= 1))
     { arg = _WBenchMsg->sm_ArgList;     /* Passed filename via Workbench */
       arg++;
       if (lock = (BPTR)arg->wa_Lock) ;
         oldlock  = (BPTR)CurrentDir(lock);
       strcpy ((char*)fhead, (char *)arg->wa_Name) ; 
     }
   
   else 
     { if (argc < 2) { puts ("Usage: Hextract <file> [output file]") ;
                       cleanup() ;
                     } 
       strcpy ((char*)fhead, argv[1]) ;
     }

   if ((fi = (BPTR)Open((STRPTR)fhead, MODE_OLDFILE)) == NULL) 
     { puts ("Can't open headers file\n") ;
       cleanup()  ;
     }

   Seek (fi, 0, 1) ;
   insize = Seek (fi, 0, -1) ;
   Read (fi, &header, 2); 
   if ((header[0] == 'L') && (header[1] == 'H'))
     { iscomp = 1 ;
       Read (fi, &fesize, 4) ;
       fesize = fesize + 4 ;
       Seek (fi, 2, -1) ;
       insize = insize - 2 ;
     }
   else   Seek (fi, 0, -1) ;

   if ((inbuf = (APTR)AllocMem(insize, MEMF_PUBLIC)) == NULL)
     { puts ("Insufficient memory\n") ;
       cleanup() ;
     }
    
   Read (fi, inbuf, insize) ;

   if (iscomp)
    { if ((febuf = (APTR)AllocMem((fesize), MEMF_PUBLIC)) == NULL)
       { puts ("Insufficient memory\n") ;
         cleanup() ;
       }
      if (iscomp)
        {  SetPointer (IntuitionBase->ActiveWindow, cptr, 7, 16, -4, -4) ;
           result = DECOMPA (inbuf, febuf) ;
           ClearPointer(IntuitionBase->ActiveWindow) ;
           FreeMem (inbuf, insize) ;
        }           
    }
   else
       { febuf = inbuf ;
         fesize = insize ;
       }

   Close (fi) ;
   if      (result == 0)  puts ("Decompression failed\n") ;
   else if (result == 2)  puts ("Out of memory\n") ;
    
   if (argc == 3)
    { fum = (BPTR)Open(argv[2], MODE_NEWFILE) ;
      Write (fum, febuf, fesize) ;
      Close (fum) ;
    } 

   strcat (winbase, (char*)fhead) ;
   window = (BPTR)Open (winbase, MODE_NEWFILE) ;
    
   Write (window, "\n Enter symbol: ", 16) ;
   
   while (1)
    { cont = 0 ;  n = 0 ;
      if (WaitForChar (window, 999999999)) 
      { Read (window, &ch, 1) ;
        buffer[i++] = ch ;
        if (ch == '\n')
         { /*Ctime (1) ;*/
          buffer[--i] = '\0' ;
          if (i)
           { if (!stricmp (buffer, "quit"))   cleanup() ;
             else
              { if (!stricmp (buffer, "ok"))
                {
                 if (!win) 
                  { Close(window) ;
                    window = (BPTR)Open("CON:100/0/400/30/Hextract V1.2", MODE_NEWFILE) ;
                    Write (window, "\n  Enter symbol: ", 17) ;
                    win = 1 ;  cont = 1 ;
                  }
                 else { i = 0 ; continue ; }
                }
                if (!cont)
                 { if (win)
                    { Close (window) ;
                      getwin() ;
                      win = 0 ;
                      Write (window, "\n     ", 6) ;
                      Write (window, buffer, strlen(buffer)) ;
                      Write (window, "\n", 1) ;
                    }  
                   SetPointer (IntuitionBase->ActiveWindow, cptr, 7, 16, -4, -4) ;
                   search () ; 
                   memset (buffer, '\0', 100) ;
                   ClearPointer(IntuitionBase->ActiveWindow) ;
                   Write (window, "\n  Enter symbol\n\n   ", 19) ;
              } }
             i = 0 ; 
            } /*Cend(1) ;*/
          } 
     } }

   cleanup() ;
}

void getwin()
{
   if (screendata->Height > 511)
    window = (BPTR)Open("CON:0/0/640/512/Hextract V1.2", MODE_NEWFILE) ;
   else if (screendata->Height >399)
    window = (BPTR)Open("CON:0/0/640/400/Hextract V1.2", MODE_NEWFILE) ;
   else if (screendata->Height >255)
    window = (BPTR)Open("CON:0/0/640/256/Hextract V1.2", MODE_NEWFILE) ;
   else 
    window = (BPTR)Open("CON:0/0/640/200/Hextract V1.2", MODE_NEWFILE) ;
}

int cleanup ()
{
     FreeMem (screendata, 30) ;
     if (febuf)  FreeMem (febuf, fesize) ;
     if (oldlock) CurrentDir (oldlock) ;
     if (window)  Close (window) ;
     if (GfxBase != NULL) CloseLibrary(GfxBase);
     if (IBase != NULL) CloseLibrary(IBase);
     /*Creport() ;*/
     exit(0);
     return (1) ;
}

void search()
{  
   char   *tok, *tok2, temp[256], *buf1, source[100], change = 0 ;
   char   libset[] = ".??????" ; 
   int    numbrackets = 0, libh ;

   located = 0 ;
   libh = 0 ;  
   while (fgts (line) != 0)
    { /*Ctime(2) ;*/ 
      onbreak(&cleanup) ;
      chkabort() ;
      buf1 = stpblk(line) ;
      if (!change)
        if (!strcmp (buf1, "FF\n"))   change = 1 ; 

      if (change)
       { if (stcpmw (buffer,libset))
          { showlib() ;
            break ;
          }  
         if (stcpmw (buf1, libset)) 
          { tok = strtok (buf1, " \n") ;
            strcpy (source, tok) ;
            libh = 1 ;
          }
       }
      /*Cend(2) ;*/  
      strcpy (temp, buf1) ;
      tok = strtok (temp, " \n") ;
      if (stcpmwa (temp,buffer))
       { located = 1 ;        
         strcpy (temp, line) ;
         tok = strtok (line, " \n") ;
         tok2 = strtok (NULL, "\n") ;
         Write (window, "\n   ", 4) ; 
         Write (window, tok2, strlen(tok2)) ;

         if (libh && !strcmp (source, "Amiga.library")) 
          { Write (window, "  ", 2) ;
            Write (window, "amiga.lib", 9) ;
          }

         else if (libh && strcmp (source, "pragma.library")) 
          { Write (window, "  ", 2) ;
            Write (window, source, strlen(source)) ;
          }
         Write (window, "\n", 1) ;

         if (stcpmw (temp, "struct")) 
          { fgts (temp) ;
            if (strchr (temp, '{'))
             { numbrackets++ ;
               Write (window, "    ", 4) ; 
               Write (window, temp, strlen(temp)) ;
               while  (numbrackets) 
                { fgts (temp) ;
                  if (strchr (temp, '{'))
                   { numbrackets++ ;
                     Write (window, "    ", 4) ;
                     Write (window, temp, strlen(temp)) ;
                     continue ;
                   }
                  else if (strchr (temp, '}'))
                   { numbrackets-- ;
                     Write (window, temp, strlen(temp)) ;
                     continue ;
                   }

                  tok = strtok (temp, " \0") ;
                  tok2 = strtok (NULL, " \0") ;
                  Write (window, "    ", 4) ;
                  Write (window, tok2, strlen(tok2)) ;

                  do
                   { tok2 = strtok (NULL, " \0") ;
                     if (stcpmw (tok2, "struct"))
                       { Write (window, "\n", 1) ;
                         break ;
                       } 
                     Write (window, " ", 1) ;
                     Write (window, tok2, strlen(tok2)) ;
                   } while (tok2) ; 
             }  }
          }

         tok = strtok (line, " \n") ;
         tok2 = strtok (NULL, "\n") ;
         Write (window, "\n       ", 8) ; 
         Write (window, tok2, strlen(tok2)) ;
      } 
    }
   if (!located)  Write (window, "        Not found\n", 18) ;
}


void showlib()
{
  char  *tok1, *tok2, buf[256] ;
  int num, i ;

  
  if (stcpmw (buffer,".device") || stcpmw (buffer,".resource")
                                      || stcpmw (buffer,".library"))
    { while (!stcpmw (line, buffer))
       if (!fgts (line)) {  libh = 0 ;  return ; }
    }
  else { libh = 0 ;
         return ;
       } 
   
  tok1 = strtok (line, " \n") ;
  tok2 = strtok (NULL, " \n") ;
  num = atoi (tok2) ;
  for (i = 0 ; i < num ; ++i)
   { fgts (buf) ;
     tok1 = strtok (buf, " \n") ;
     tok2 = strtok (NULL, "\0") ;
     Write (window, "   ", 3) ;
     Write (window, tok2, strlen(tok2)) ;
   }
  located = 1 ;
}
