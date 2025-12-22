#include <intuition/classusr.h>
#include <intuition/classes.h>

#include <string.h>

/****** supermodel.class/SM_IsMemberOf ******************************************
*
*   NAME
*       SM_IsMemberOf -- Check if Object belongs to a Class
*
*   SYNOPSIS
*       memberof = SM_IsMemberOf(Object, ClassPtr, ClassID)
*
*       BOOL SM_IsMemberOf(Object *, Class *, STRPTR);
*
*   FUNCTION
*       Determines if the Object is a member of the Class
*       specified.
*
*   INPUTS
*       Object   - Object to check.
*       ClassPtr - (Class) May be NULL.
*       ClassID  - (STRPTR) May be NULL. 
*
*   RESULT
*       BOOL, non-zero on succes.
*
*   NOTES
*       Stolen from someone on the BOOPSI mailing list...
*          
*       Here's some IsMemberOf() code I whipped up quickly.  Might be nice if we all
*       posted useful little BOOPSI snippets like this... maybe even collected them
*       together on a web site.  (I volunteer NOT to maintain this site :)
*
******************************************************************************
*
*/

BOOL __asm LIB_SM_IsMemberOf(register __a0 Object *obj, register __a1 Class *class, register __a2 STRPTR class_id)
{
    BOOL found = FALSE;

    Class *obj_class = OCLASS(obj);

    while (!found && obj_class)
    {
        if (class)
        {
            if (obj_class == class)
                found = TRUE;
        }
        else if (class_id && obj_class->cl_ID)
        {
//            D( kprintf("comparing class names: %s and %s\n", class_id, obj_class->cl_ID); )
            if (strcmp(class_id, obj_class->cl_ID) == 0)
                found = TRUE;
        }
        if (!found)
            obj_class = obj_class->cl_Super;
    }
    return(found);
}
