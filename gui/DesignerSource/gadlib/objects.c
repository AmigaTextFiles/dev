/* This contains all of the object class creation and support routines   */


#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/cghooks.h>
#include <intuition/icclass.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <clib/intuition_protos.h>
#include <clib/utility_protos.h>
#include <clib/intuition_protos.h>
#include <clib/intuition_protos.h>

/* Include a source file for each object class to be made                */
/* Only one at present                                                   */

#include "percent.c"

void makeobjects(void)
{
  createpercentclass();
}

void freeobjects(void)
{
  removepercentclass();
}

