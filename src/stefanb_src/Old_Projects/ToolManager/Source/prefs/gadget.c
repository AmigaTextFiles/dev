/*
 * gadget.c  V2.1
 *
 * gadget handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

static struct TagItem GlobalTags[]={GT_Underscore, '_',
                                    TAG_MORE};

/* Create a gadget list from a GadgetData array */
struct Gadget *CreateGadgetList(struct GadgetData *gdata, ULONG maxgad)
{
 struct Gadget *gl,*g;

 /* Create GadTools gadget context */
 gl=NULL;
 if (g=CreateContext(&gl)) {
  struct GadgetData *gd=gdata;
  ULONG i;

  for (i=0; i<maxgad; i++, gd++) {

   DEBUG_PRINTF("i: %ld\n",i);

   /* Set NewGadget values */
   NewGadget.ng_LeftEdge=gd->left;
   NewGadget.ng_TopEdge=gd->top;
   NewGadget.ng_Width=gd->width;
   NewGadget.ng_Height=gd->height;
   NewGadget.ng_GadgetText=gd->name;
   NewGadget.ng_GadgetID=i;
   NewGadget.ng_Flags=gd->flags;

   /* Tags supplied? */
   if (gd->tags) {
    /* Yes. Add array */
    GlobalTags[1].ti_Tag=TAG_MORE;
    GlobalTags[1].ti_Data=(ULONG) gd->tags;
   } else
    /* No. Truncate array */
    GlobalTags[1].ti_Tag=TAG_DONE;

   /* Create gadget */
   if (!(g=CreateGadgetA(gd->type,g,&NewGadget,GlobalTags))) break;

   /* Save gadget pointer */
   gd->gadget=g;
  }

  /* All OK. */
  if (g) return(gl);

  /* Couldn't create a gadget */
  FreeGadgets(gl);
 }

 /* Call failed */
 return(NULL);
}

/* Disable a gadget */
void DisableGadget(struct Gadget *g, struct Window *w, BOOL disable)
{
 GT_SetGadgetAttrs(g,w,NULL,GA_Disabled,disable,TAG_DONE);
}

/* Duplicate a string gadget buffer */
char *DuplicateBuffer(struct Gadget *gadget)
{
 char *buf=((struct StringInfo *) gadget->SpecialInfo)->Buffer;
 ULONG len=strlen(buf);

 /* Buffer not empty? */
 if (len) {
  char *s;

  /* Allocate memory for new string */
  if (s=malloc(len+1)) {
   /* Copy string */
   strcpy(s,buf);
   return(s);
  } else
   /* Couldn't allocate memory */
   return(-1);
 }

 /* Buffer empty */
 return(NULL);
}

/* Find '_' character in gadget text */
char FindVanillaKey(char *gadtext)
{
 unsigned char *cp; /* unsigned is important for the toupper() macro! */

 /* Scan gadget text */
 if (cp=strchr(gadtext,'_'))
  /* Underscore found, return next character */
  return(toupper(*(cp+1)));
 else
  /* No underscore found, return dummy character */
  return(1);
}

/* Match a given vanilla key with the key array */
ULONG MatchVanillaKey(unsigned char key, char *array)
{
 char *cp;

 /* Scan array */
 if (cp=strchr(array,toupper(key)))
  /* Key found, return index */
  return(cp-array);
 else
  /* Key not found, return illegal value */
  return(-1);
}
