#ifndef POBJECT_H
#define POBJECT_H

/* ==========================================================================
**
**                               PObject.h
**
**      Defines the basic struct from which all Precognition objects
**      are defined.
**
**   ©1991 WILLISoft
**
** ==========================================================================
*/
#include <exec/types.h>

#include "parms.h"

typedef void PClass;


typedef struct PObject
   {
      const PClass *isa;        /* Points to the objects 'PClass' structure. */
      char  *PObjectName;       /* Used by interface builder. */
   } PObject;

/* All 'objects' are derrived from this structrure, i.e. they have
** an 'isa' pointer as their first member.  The 'isa' pointer points
** to the 'PClass' structure for the object.
**
** NOTE: PObjects do NOT need to have an PObjectName associated with
** them.  This field is used by the Application builder to attach
** a variable name.
*/


/*
** All object methods must provide at least the following operations:
*/


void  CleanUp __PARMS(( PObject *self ));

/* Deallocates all but the base storage for an object.  e.g. given
** a structure like:
**
**    struct Abc
**       {
**          PClass *isa;
**          char *FirstName, *LastName;
**       };
**
** which once initialized, has FirstName & LastName pointing to
** 2 40 char buffers, 'CleanUp( Abc )' would deallocate the strings
** 'FirstName' & 'LastName', but not Abc itself.
**
** ==========================================================
**       YOU SHOULD CALL CleanUp FOR EVERY OBJECT
** ==========================================================
*/

void PObject_Init __PARMS((
                     PObject *self
                  ));


char *ClassName __PARMS((
                        PObject *self
                     ));
   /*
   ** Returns the name of the class to which the object belongs.
   ** (Useful for debugging.)
   */

/* Additions for missing Builder prototypes -- EDB */

void SetObjectName __PARMS(( PObject *self, char *name ));

BOOL isa __PARMS(( PObject *self,
          const PClass *class ));

#endif
