/*
 * objects.c  V2.1.01
 *
 * TMObject managment routines
 *
 * (c) 1990-1995 Stefan Becker
 */

#include "ToolManagerLib.h"

static void *dummyfunc(void) {return(NULL);};

/* object functions arrays */
struct TMObject *CreateTMObjectExec(struct TMHandle *, char *,
                                    struct TagItem *);
struct TMObject *CreateTMObjectImage(struct TMHandle *, char *,
                                     struct TagItem *);
struct TMObject *CreateTMObjectSound(struct TMHandle *, char *,
                                     struct TagItem *);
struct TMObject *CreateTMObjectMenu(struct TMHandle *, char *,
                                    struct TagItem *);
struct TMObject *CreateTMObjectIcon(struct TMHandle *, char *,
                                    struct TagItem *);
struct TMObject *CreateTMObjectDock(struct TMHandle *, char *,
                                    struct TagItem *);
struct TMObject *CreateTMObjectAccess(struct TMHandle *, char *,
                                      struct TagItem *);
typedef struct TMObject *(*CreateFuncPtr)(struct TMHandle *, char *,
                                          struct TagItem *);
static CreateFuncPtr CreateFuncTab[TMOBJTYPES]={CreateTMObjectExec,
                                                CreateTMObjectImage,
                                                CreateTMObjectSound,
                                                CreateTMObjectMenu,
                                                CreateTMObjectIcon,
                                                CreateTMObjectDock,
                                                CreateTMObjectAccess};

BOOL DeleteTMObjectExec(struct TMObject *);
BOOL DeleteTMObjectImage(struct TMObject *);
BOOL DeleteTMObjectSound(struct TMObject *);
BOOL DeleteTMObjectMenu(struct TMObject *);
BOOL DeleteTMObjectIcon(struct TMObject *);
BOOL DeleteTMObjectDock(struct TMObject *);
BOOL DeleteTMObjectAccess(struct TMObject *);
typedef BOOL (*DeleteFuncPtr)(struct TMObject *);
static DeleteFuncPtr DeleteFuncTab[TMOBJTYPES]={DeleteTMObjectExec,
                                                DeleteTMObjectImage,
                                                DeleteTMObjectSound,
                                                DeleteTMObjectMenu,
                                                DeleteTMObjectIcon,
                                                DeleteTMObjectDock,
                                                DeleteTMObjectAccess};

BOOL ChangeTMObjectExec(struct TMHandle *, struct TMObject *,
                        struct TagItem *);
/* BOOL ChangeTMObjectImage(struct TMHandle *, struct TMObject *,
                         struct TagItem *); */
BOOL ChangeTMObjectSound(struct TMHandle *, struct TMObject *,
                         struct TagItem *);
BOOL ChangeTMObjectMenu(struct TMHandle *, struct TMObject *,
                        struct TagItem *);
BOOL ChangeTMObjectIcon(struct TMHandle *, struct TMObject *,
                        struct TagItem *);
BOOL ChangeTMObjectDock(struct TMHandle *, struct TMObject *,
                        struct TagItem *);
BOOL ChangeTMObjectAccess(struct TMHandle *, struct TMObject *,
                          struct TagItem *);
typedef BOOL (*ChangeFuncPtr)(struct TMHandle *, struct TMObject *,
                              struct TagItem *);
static ChangeFuncPtr ChangeFuncTab[TMOBJTYPES]={ChangeTMObjectExec,
                                                (ChangeFuncPtr) dummyfunc,
                                                ChangeTMObjectSound,
                                                ChangeTMObjectMenu,
                                                ChangeTMObjectIcon,
                                                ChangeTMObjectDock,
                                                ChangeTMObjectAccess};

struct TMLink *AllocLinkTMObjectExec(struct TMObject *);
struct TMLink *AllocLinkTMObjectImage(struct TMObject *);
struct TMLink *AllocLinkTMObjectSound(struct TMObject *);
struct TMLink *AllocLinkTMObjectDock(struct TMObject *);
struct TMLink *AllocLinkTMObjectAccess(struct TMObject *);
typedef struct TMLink *(*AllocLinkFuncPtr)(struct TMObject *);
static AllocLinkFuncPtr AllocLinkFuncTab[TMOBJTYPES]={AllocLinkTMObjectExec,
                                                      AllocLinkTMObjectImage,
                                                      AllocLinkTMObjectSound,
                                                      (AllocLinkFuncPtr) dummyfunc,
                                                      (AllocLinkFuncPtr) dummyfunc,
                                                      AllocLinkTMObjectDock,
                                                      AllocLinkTMObjectAccess};

void DeleteLinkTMObjectExec(struct TMLink *);
void DeleteLinkTMObjectMenu(struct TMLink *);
void DeleteLinkTMObjectIcon(struct TMLink *);
void DeleteLinkTMObjectDock(struct TMLink *);
void DeleteLinkTMObjectAccess(struct TMLink *);
typedef void (*DeleteLinkFuncPtr)(struct TMLink *);
static DeleteLinkFuncPtr DeleteLinkFuncTab[TMOBJTYPES]={DeleteLinkTMObjectExec,
                                                        (DeleteLinkFuncPtr) dummyfunc,
                                                        (DeleteLinkFuncPtr) dummyfunc,
                                                        DeleteLinkTMObjectMenu,
                                                        DeleteLinkTMObjectIcon,
                                                        DeleteLinkTMObjectDock,
                                                     DeleteLinkTMObjectAccess};

void ActivateTMObjectExec(struct TMLink *, void *);
void ActivateTMObjectImage(struct TMLink *, void *);
void ActivateTMObjectSound(struct TMLink *, void *);
void ActivateTMObjectMenu(struct TMLink *, void *);
void ActivateTMObjectIcon(struct TMLink *, void *);
void ActivateTMObjectDock(struct TMLink *, void *);
void ActivateTMObjectAccess(struct TMLink *, void *);
typedef void (*ActivateFuncPtr)(struct TMLink *, void *);
static ActivateFuncPtr ActivateFuncTab[TMOBJTYPES]={ActivateTMObjectExec,
                                                    ActivateTMObjectImage,
                                                    ActivateTMObjectSound,
                                                    ActivateTMObjectMenu,
                                                    ActivateTMObjectIcon,
                                                    ActivateTMObjectDock,
                                                    ActivateTMObjectAccess};

/* Allocate a TMObject structure */
struct TMObject *AllocateTMObject(ULONG size)
{
 struct TMObject *tmobj;

 /* Get memory for TMObject */
 if (tmobj=AllocMem(size,MEMF_CLEAR|MEMF_PUBLIC)) {
  /* Init link list */
  NewList(&tmobj->tmo_Links);

  /* All OK */
  return(tmobj);
 }

 /* call failed */
 return(NULL);
}

/* Find an object by name of a specified type */
static struct TMObject *FindObjectInList(struct TMHandle *handle, char *name,
                                         UBYTE type)
{
 struct TMObject *tmobj=GetHead(&handle->tmh_ObjectLists[type]);

 /* Scan list */
 while (tmobj)
  if (strcmp(name,tmobj->tmo_Name))
   tmobj=GetSucc(tmobj);            /* Object not found --> Next object */
  else
   break;                           /* Object found --> Leave loop */

 /* return pointer to object */
 return(tmobj);
}

/* Find an object by name in a specified TMHandle */
static struct TMObject *FindObjectInTMHandle(struct TMHandle *handle,
                                             char *name)
{
 int i;
 struct TMObject *tmobj;

 /* Scan all lists in TMHandle */
 for (i=0; i<TMOBJTYPES; i++)
  if (tmobj=FindObjectInList(handle,name,i)) break; /* Object found */

 /* return pointer to object */
 return(tmobj);
}

/* Create a TMObject of the specified type */
BOOL InternalCreateTMObject(struct TMHandle *handle, char *object, ULONG type,
                            struct TagItem *tags)
{
 struct TMObject *tmobj;

 /* Call type specific create function */
 if (tmobj=(*CreateFuncTab[type])(handle,object,tags)) {
  /* Object created */
  tmobj->tmo_Type=type;
  tmobj->tmo_Name=object;

  /* Add it to the TMHandle */
  AddTail(&handle->tmh_ObjectLists[type],(struct Node *) tmobj);

  /* call succeeded */
  return(TRUE);
 }

 /* call failed */
 return(FALSE);
}

/* Delete a TMObject (NOTE: object MUST Remove() itself from list!!!) */
BOOL CallDeleteTMObject(struct TMObject *tmobj)
{
 return((*DeleteFuncTab[tmobj->tmo_Type])(tmobj));
}

/* Delete a TMObject (NOTE: object MUST Remove() itself from list!!!) */
BOOL InternalDeleteTMObject(struct TMHandle *handle, char *object)
{
 struct TMObject *tmobj;

 /* find object */
 if (tmobj=FindObjectInTMHandle(handle,object))
  /* Object found, remove delete it */
  return((*DeleteFuncTab[tmobj->tmo_Type])(tmobj));

 /* call failed */
 return(FALSE);
}

/* Change a TMObject */
BOOL InternalChangeTMObject(struct TMHandle *handle, char *object,
                            struct TagItem *tags)
{
 struct TMObject *tmobj;

 /* find object */
 if (tmobj=FindObjectInTMHandle(handle,object)){
  /* Object found */

  /* any tags specified? */
  if (tags==NULL) return(TRUE); /* call succeeded :-) */

  /* Change object */
  return((ChangeFuncTab[tmobj->tmo_Type])(handle,tmobj,tags));
 }

 /* call failed */
 return(FALSE);
}

/* Add a link to a TMObject */
struct TMLink *AddLinkTMObject(struct TMHandle *handle, char *object,
                               ULONG type, struct TMObject *linkedto)
{
 struct TMObject *tmobj;

 /* Find object of specified type */
 if (tmobj=FindObjectInList(handle,object,type)) {
  struct TMLink *tml;

  /* Allocate TMLink structure */
  if (tml=(AllocLinkFuncTab[tmobj->tmo_Type])(tmobj)) {
   /* Initialize link */
   tml->tml_Linked=tmobj;
   tml->tml_LinkedTo=linkedto;

   /* Add link to list */
   AddTail(&tmobj->tmo_Links,(struct Node *) tml);

   /* All OK */
   return(tml);
  }
 }

 /* call failed */
 return(NULL);
}

/* Remove a link to a TMObject */
void RemLinkTMObject(struct TMLink *tml)
{
 /* Remove it from list */
 Remove((struct Node *) tml);

 /* Free link structure */
 FreeMem(tml,tml->tml_Size);
}

/* Remove all links to a TMObject (updating objects this object is linked to) */
void DeleteAllLinksTMObject(struct TMObject *tmobj)
{
 struct List *l=&tmobj->tmo_Links;
 struct TMLink *tml;

 /* Scan list */
 while (tml=(struct TMLink *) RemHead(l)) {
  /* Notify linkedTo object, that this link will be removed */
  (DeleteLinkFuncTab[tml->tml_LinkedTo->tmo_Type])(tml);

  /* Free link structure */
  FreeMem(tml,tml->tml_Size);
 }
}

/* Activate a TMObject */
void CallActivateTMObject(struct TMLink *tml, void *args)
{
 (ActivateFuncTab[tml->tml_Linked->tmo_Type])(tml,args);
}
