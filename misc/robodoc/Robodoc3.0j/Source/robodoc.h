/****** Robodoc.c/RB_header [2.0]
 *  NAME
 *    RB_header -- header data structure
 *  MODIFICATION HISTORY
 *    8. August 1995: Koessi
 *                    changed int version to char *version
 *  SOURCE
 */

struct RB_header
{
  struct RB_header *next_header ;
  struct RB_header *prev_header ;
  int    type ;
  int    size ;
/*int    version ; */
  char   *version ;
  char   *name ;
  char   *function_name ;
  char   *contents ;
} ;

/*********/

/****** Robodoc.c/RB_link [2.0e]
 *  NAME
 *    RB_link -- link data structure
 *  SOURCE
 */

struct RB_link
{
  struct RB_link *next_link ;
  struct RB_link *prev_link ;
  char   *label_name ;
  char   *file_name ;
} ;

/*********/


#define skip_while(cond) { for (;*cur_char && (cond);cur_char++) ; }
#define find_eol   { for (;*cur_char && *cur_char!='\n';cur_char++) ; }
#define find_quote { for (;*cur_char && *cur_char!='\"';cur_char++) ; }

#ifdef AMIGA
#define RB_RETURN_PANIC 20
#else
#define RB_RETURN_PANIC 100
#endif

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE  1
#endif

