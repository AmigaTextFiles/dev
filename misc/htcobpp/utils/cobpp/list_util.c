/************************************************************************
 *  Copyright (c) 1996 by Charles A. Measday                            *
 *                                                                      *
 *  Permission to use, copy, modify, and distribute this software       *
 *  and its documentation for any purpose and without fee is hereby     *
 *  granted, provided that the above copyright notice appear in all     *
 *  copies.  The author makes no representations about the suitability  *
 *  of this software for any purpose.  It is provided "as is" without   *
 *  express or implied warranty.                                        *
 ************************************************************************/

/*
@(#)  FILE: list_util.c  RELEASE: 1.8  DATE: 05/13/96, 15:36:34
*/
/*******************************************************************************

File:

    list_util.c

    List Manipulation Utilities


Author:    Alex Measday, ISI


Purpose:

    The list manipulation utilities are a set of general purpose functions
    used to build and access lists of items.  For example, the following
    fragment of code (i) inputs and save N lines from standard input,
    (ii) displays the N saved lines, and (iii) deletes the saved text:

        #include  "list_util.h"
        ...
        char  buffer[MAXINPUT], *s ;
        List  list = NULL ;
        ...
        while (s = gets (buffer))		-- Input and save text.
            listAdd (&list, -1, (void *) strdup (s)) ;
        for (i = 1 ;  s = (char *) listGet (list, i) ;  i++)
            printf ("Line %d: %s\n", i, s) ;	-- Display text.
        while (listDelete (&list, 1) != NULL)
            ;					-- Delete text.
        ...


Notes:

    These functions are reentrant under VxWorks.


Procedures:

    listAdd() - adds an item to a list.
    listDelete() - deletes an item from a list.
    listFind() - finds an item in a list.
    listGet() - retrieves the value of an item from a list.
    listLength() - returns the number of items in a list.

*******************************************************************************/


#include  <errno.h>			/* System error definitions. */
#include  <stdio.h>			/* Standard I/O definitions. */
#include  <stdlib.h>			/* Standard C Library definitions. */
#include  "vperror.h"			/* VPERROR() definitions. */
#include  "list_util.h"			/* List manipulation definitions. */


/*******************************************************************************
    List Data Structures - each list is represented internally using a
        doubly-linked list of nodes.  The PREV link of the first item
        in a list points to the last item in the list; the NEXT link
        of the last item in a list is always NULL.
*******************************************************************************/

typedef  struct  ListNode {
    struct  ListNode  *prev ;		/* Link to previous node in list. */
    struct  ListNode  *next ;		/* Link to next node in list. */
    void  *data ;			/* Data value for item I. */
}  ListNode ;

/*******************************************************************************

Procedure:

    listAdd ()


Purpose:

    Function listAdd() adds an item to a list.


    Invocation:

        List  list = NULL ;
        ...
        status = listAdd (&list, position, (void *) item) ;

    where

        <list>		- I/O
            is the list of items.  If the list of items is empty, a new
            list is created and a pointer to the list is returned in LIST.
        <position>	- I
            specifies the position in the list where ITEM will be inserted.
            The new item will normally be inserted to the right of POSITION.
            For example, if POSITION is 4, then the new item will become
            the 5th item in the list; old items 5..N become items 6..N+1.
            If POSITION equals 0, then ITEM is inserted at the front of
            the list.  If POSITION equals -1, then ITEM is added at the
            end of the list.
        <item>		- I
            is the item, cast as a (VOID *) pointer, to be added to the list.
        <status>	- O
            returns the status of adding ITEM to LIST, zero if there were no
            errors and ERRNO otherwise.

*******************************************************************************/


int  listAdd (

#    if __STDC__
        List  *list,
        int  position,
        void  *item)
#    else
        list, position, item)

        List  *list ;
        int  position ;
        void  *item ;
#    endif

{    /* Local variables. */
    ListNode  *node, *prev ;




/* Create a list node. */

    node = (ListNode *) malloc (sizeof (ListNode)) ;
    if (node == NULL) {
        vperror ("(listAdd) Error allocating list node for %p.\nmalloc: ", item) ;
        return (errno) ;
    }
    node->prev = node->next = NULL ;
    node->data = item ;

/* Add the item to the list. */

    prev = *list ;
    if (prev == NULL) {				/* Brand new list? */
        node->prev = node ;
        *list = node ;
    } else {					/* Existing list? */
        if (position < 0) {				/* End of list? */
            node->next = prev ;  prev = prev->prev ;
            node->prev = prev ;  prev->next = node ;
            prev = node->next ;  prev->prev = node ;
            node->next = NULL ;
        } else if (position == 0) {			/* Beginning of list? */
            node->next = prev ;  node->prev = prev->prev ;
            prev->prev = node ;  *list = node ;
        } else {					/* Position I in list? */
            while ((--position > 0) && (prev->next != NULL))
                prev = prev->next ;
            node->prev = prev ;  node->next = prev->next ;  prev->next = node ;
            if (node->next == NULL)			/* I at end of list? */
                (*list)->prev = node ;
            else					/* I in middle of list? */
                (node->next)->prev = node ;
        }
    }

    return (0) ;

}

/*******************************************************************************

Procedure:

    listDelete ()


Purpose:

    Function listDelete() deletes an item from a list.  An item being
    deleted is denoted by its position, 1..N, in the list; deleting
    an item adjusts the positions of all the items that follow in the
    list.  To delete an entire list, just keep deleting item #1 until
    the list is empty:

            while (listDelete (&list, 1) != NULL)
                ;


    Invocation:

        item = listDelete (&list, position) ;

    where

        <list>		- I/O
            is the list of items.  If the item being deleted is the very first
            item in the list, LIST will be updated to point to the "2nd" item
            in the list.  If the item being deleted is the only remaining item
            in the list, a NULL pointer is returned in LIST.
        <position>	- I
            specifies the item's position, 1..N, in the list.  Positions
            less than 1 or greater than N are ignored.
        <item>		- O
            returns the deleted item, cast as a (VOID *) pointer.  NULL is
            returned if POSITION is outside of the range 1..N or if N = 0.

*******************************************************************************/


void  *listDelete (

#    if __STDC__
        List  *list,
        int  position)
#    else
        list, position)

        List  *list ;
        int  position ;
#    endif

{    /* Local variables. */
    ListNode  *node, *prev ;
    void  *data ;




/* Locate the item in the list. */

    node = *list ;
    if ((node == NULL) || (position < 1)) {
        return (NULL) ;
    } else if (position == 1) {			/* Item 1 in list? */
        *list = node->next ;
        if (node->next != NULL)  (node->next)->prev = node->prev ;
    } else {					/* Item 2..N in list? */
        while ((--position > 0) && (node != NULL))
            node = node->next ;
        if (node == NULL)  return (NULL) ;
        prev = node->prev ;  prev->next = node->next ;
        if (node->next == NULL)			/* Very last item in list? */
            (*list)->prev = prev ;
        else					/* Middle of list? */
            (node->next)->prev = prev ;
    }

    data = node->data ;
    free ((char *) node) ;
    return (data) ;

}

/*******************************************************************************

Procedure:

    listFind ()


Purpose:

    Function listFind() finds an item in a list and returns its position
    in the list.


    Invocation:

        position = listFind (list, item) ;

    where

        <list>		- I
            is the list of items.
        <item>		- I
            is the item, cast as a (VOID *) pointer.
        <position>	- O
            returns the item's position, 1..N, in LIST.  If the item is
            not found or if the list is empty, zero is returned.

*******************************************************************************/


int  listFind (

#    if __STDC__
        List  list,
        void  *item)
#    else
        list, item)

        List  list ;
        void  *item ;
#    endif

{    /* Local variables. */
    int  i ;



/* Search the list for the item. */

    for (i = 1 ;  list != NULL ;  list = list->next, i++)
        if (list->data == item)  break ;

    return ((list == NULL) ? 0 : i) ;

}

/*******************************************************************************

Procedure:

    listGet ()


Purpose:

    Function listGet() returns the I-th item from a list.


    Invocation:

        item = (<type>) listGet (list, position) ;

    where

        <list>		- I
            is the list of items.
        <position>	- I
            specifies the desired item's position, 1..N, in the list.
            If POSITION is -1, LIST_GET() returns the last item in the
            list.  Positions 0 and N+1... are invalid.
        <item>		- O
            returns the deleted item, cast as a (VOID *) pointer.  NULL is
            returned if POSITION > N or if POSITION = 0 or if N = 0.

*******************************************************************************/


void  *listGet (

#    if __STDC__
        List  list,
        int  position)
#    else
        list, position)

        List  list ;
        int  position ;
#    endif

{

    if (list == NULL)			/* Empty list? */
        return (NULL) ;
    else if (position < 0)		/* Return last item? */
        return ((list->prev)->data) ;
    else if (position == 0)		/* I = 0? */
        return (NULL) ;

/* Position to the desired item in the list. */

    while ((--position > 0) && (list != NULL))
        list = list->next ;
    if (list == NULL)			/* I > N */
        return (NULL) ;
    else				/* 1 <= I <= N */
        return (list->data) ;

}

/*******************************************************************************

Procedure:

    listLength ()


Purpose:

    Function listLength() returns the number of items in a list.


    Invocation:

        numItems = listLength (list) ;

    where

        <list>		- I
            is the list of items.
        <numItems>	- O
            returns the number of items in the list.

*******************************************************************************/


int  listLength (

#    if __STDC__
        List  list)
#    else
        list)

        List  list ;
#    endif

{    /* Local variables. */
    int  count ;



/* Count the number of items in the list. */

    for (count = 0 ;  list != NULL ;  count++)
        list = list->next ;

    return (count) ;

}
