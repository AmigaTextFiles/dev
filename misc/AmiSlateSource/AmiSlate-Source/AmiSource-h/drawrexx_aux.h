/* Prototypes for drawrexx_aux.c */
#ifndef DRAWREXX_AUX_H
#define DRAWREXX_AUX_H

#include <ctype.h>

#ifndef AMISLATE_H
#include "amislate.h"
#endif

struct RexxState {
	struct RexxMsg *rexxmsg;
	long rc;
	long rc2;
	char *result;
	struct RexxHost *host;
	char *cargstr;
	LONG *array;
	char *argb;
	struct rxs_command *rxc;	
	LONG *resarray;
	LONG *argarray;
};

struct rxs_stemnode
{
	struct rxs_stemnode *succ;
	char *name;
	char *value;
};
 
char *CreateVAR( struct rxs_stemnode *stem );
struct rxs_stemnode *CreateSTEM( struct rxs_command *rxc, LONG *resarray, char *stembase );
void free_stemlist( struct rxs_stemnode *first );

void ReplyAndFreeRexxMsg(BOOL BProcessResults);
void ProcessResults(void);

extern struct PaintInfo PState;
extern char szReceiveString[256];

#ifndef DRAWREXX_AUX_C
extern struct RexxState RexxState;
#endif

#endif



#ifdef NOTE_TO_JEREMY

/* after redoing ARexxBox stuff, dont forget to restore drawrexx.c from a backup!
   We did in fact modify some stuff in there!  */

#endif