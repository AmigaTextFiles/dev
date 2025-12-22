/************************************************************************ 
*                                                                       * 
*                                                                       * 
*                      Filename:        MemFrag.c                       *      
*                       Version:        0.0                             * 
*                       Author :        Gary Duncan                     * 
*                                                                       * 
*                                frags , heavily modified               *
*-----------------------------------------------------------------------* 
*
* Function:
* ~~~~~~~~~
*
* Invocation:
* ~~~~~~~~~~
*
* 
* Modification record: 
*~~~~~~~~~~~~~~~~~~~~
* 
* Date         By whom             Change 
* ----         -------             ------ 
* 
* 17 Jan 89    GMD		  Original ; frags.c heavily modified
*                                            ( from FF69)
*
* 01 Jul 89	"		  Date added
*
* Contents:    Function    Description
* ~~~~~~~~     ~~~~~~~~    ~~~~~~~~~~~
*+  
*+  _main
*+  print_count
*+  ascify
*+  MemCleanup
*+ 
*
*
*******************************************************************************/


#include "gd_functions.h"


#include <exec/types.h>
#include <exec/exec.h>
#include <exec/execbase.h>


extern char *MakeDate[] ;

#if 0
char redpen[]  =  "\033[33m";  	/* red pen     */
char witepen[] =  "\033[0m";  	/* white  pen  */
#endif

char ghdr[] = "\n\033[33m\
                   Chip:Fast \n\
                   ~~~~ ~~~~\033[0m\n" ;

char buffer[100] = "12345678 : 123     123 :123         \n"  ;

struct gazza { int   kk ;
                BYTE chip ;
                BYTE fast ; }  Chunk_Count[25] ;



_main() 
{

long aggrF = 0 ;		/* GMD	*/
long aggrC = 0 ;		/* GMD	*/
char flag ;
struct MemHeader *hdr ;
struct MemChunk *chunk ;
long	size ;
extern struct ExecBase *SysBase ;
short j ;

	{
	 char vvv[100] ;
	 sprintf ( vvv, "\nMemFrag: (%s) \n", 
				MakeDate[0] ) ;
	 Write(Output(), vvv, (long)strlen(vvv) ) ;	/* GMD */	
	}
	Forbid() ;

	hdr = (struct MemHeader *) SysBase -> MemList . lh_Head ;

	while (hdr ->mh_Node.ln_Succ) 
         {
		flag = *(char *)(hdr->mh_Node.ln_Name) ; /* 'F'ast or 'C'hip */

		for (chunk = hdr -> mh_First; chunk; chunk = chunk -> mc_Next)
                  {
			size = chunk -> mc_Bytes ;
			for (j = 0; size; j += 1) 
				size >>= 1 ;

			Chunk_Count[j].kk += 1 ;
			if ( flag == 'e' )	/* count Fast or Chip chunks */
			  ++Chunk_Count[j].fast ;
			else
			  ++Chunk_Count[j].chip ;	/* GMD	*/

		}

		hdr = (struct MemHeader *) hdr -> mh_Node . ln_Succ ;

	  } /*end-while */

	Permit() ;

	Write(Output(), ghdr, (long)strlen(ghdr) ) ;	/* GMD */	

	for (j = 1; j <= 23; ++j )
          {
		if (Chunk_Count[j].kk)
		    print_count( j ) ;	/* print # of blocks	*/
          }

        exit ( 0 ) ;			/* GMD 		*/
}

/*************************************************************************** 
 
 
  Name :      	print_count 

  Purpose:           Given index into array , prints line


  Entry    :           
 
 
  Returns  :           
                               
 
 
****************************************************************************/ 



print_count ( j )

int j ;
{


	ascify ( (1L << (j-1)) ,             8 ,   &buffer[0]  ) ;
	ascify ( (long)Chunk_Count[j].kk ,   3 ,   &buffer[11] ) ;
	ascify ( (long)Chunk_Count[j].chip , 3 ,   &buffer[19] ) ;
	ascify ( (long)Chunk_Count[j].fast , 3 ,   &buffer[24] ) ;

	Write(Output(), buffer,(long)strlen(buffer) ) ;
}

/*************************************************************************** 
 
 
  Name :      	ascify

  Purpose:      Converts a long number  to an ASCII string


  Entry    :    (long)numb = number
 	        (int) digs = # of digits to print ( field-width )
                (char *) where = ptr to where sting is to be copied


  Returns  :           
                               
 
 
****************************************************************************/ 


ascify ( numb , digs , where )

long numb ;
int digs ;
char *where ;

{
int j , k ;
char *ptr = where ;

    for ( j=0 , where += digs-1 ; j < digs ; ++j  )
       {
         k = numb%10 ;
         numb /= 10  ; 
         *where-- = k + '0'  ;

       }
    while ( *ptr == '0' )
          *ptr++ = ' ' ;
    
    
}
/*************************************************************************** 
 
 
  Name :      	MemCleanup

  Purpose:

 *
 * To cut down on memory useage, we provide a stub for a routine pulled
 * in by the default startup code in _main. This code cleans up
 * dynamically allocated memory, which we don't need. So we flush the code
 * here. By making this a smallcode, smalldata program, turning off stack 
 * checking (nothing recursive, and only three routines, so who needs it?),
 * and adding this, I've reduced the size of MemFrag to 1644 bytes. Since the
 * original MemFrag is 1964 bytes long, I'm happy. Just out of curiosity, I'd
 * like to know how large a binary Manx 3.4 produces.
 

  Entry    :           
 
 
  Returns  :           
                               
 
 
****************************************************************************/ 


MemCleanup() {}

