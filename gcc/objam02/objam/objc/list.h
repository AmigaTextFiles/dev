/*
** ObjectiveAmiga: Generic single linked list to keep various information
** See GNU:lib/libobjam/ReadMe for details
*/


#include <objc/objc.h>


struct objc_list {
  void *head;
  struct objc_list *tail;
};

/* Return a cons cell produced from (head . tail) */

static inline struct objc_list* 
list_cons(void* head, struct objc_list* tail)
{
  struct objc_list* cell;

  cell = (struct objc_list*)__objc_xmalloc(sizeof(struct objc_list));
  cell->head = head;
  cell->tail = tail;
  return cell;
}

/* Return the length of a list, list_length(NULL) returns zero */

static inline int
list_length(struct objc_list* list)
{
  int i = 0;
  while(list)
    {
      i += 1;
      list = list->tail;
    }
  return i;
}

/* Return the Nth element of LIST, where N count from zero.  If N 
   larger than the list length, NULL is returned  */

static inline void*
list_nth(int index, struct objc_list* list)
{
  while(index-- != 0)
    {
      if(list->tail)
	list = list->tail;
      else
	return 0;
    }
  return list->head;
}

/* Remove the element at the head by replacing it by its successor */

static inline void
list_remove_head(struct objc_list** list)
{
  if ((*list)->tail)
    {
      struct objc_list* tail = (*list)->tail; /* fetch next */
      *(*list) = *tail;		/* copy next to list head */
      __objc_xfree(tail);			/* free next */
    }
  else				/* only one element in list */
    {
      __objc_xfree (*list);
      (*list) = 0;
    }
}


/* Remove the element with `car' set to ELEMENT */

static inline void
list_remove_elem(struct objc_list** list, void* elem)
{
  while (*list) {
    if ((*list)->head == elem)
      list_remove_head(list);
    list = &((*list)->tail);
  }
}

/* Map FUNCTION over all elements in LIST */

static inline void
list_mapcar(struct objc_list* list, void(*function)(void*))
{
  while(list)
    {
      (*function)(list->head);
      list = list->tail;
    }
}

/* Return element that has ELEM as car */

static inline struct objc_list**
list_find(struct objc_list** list, void* elem)
{
  while(*list)
    {
    if ((*list)->head == elem)
      return list;
    list = &((*list)->tail);
    }
  return NULL;
}

/* Free list (backwards recursive) */

static void
list_free(struct objc_list* list)
{
  if(list)
    {
      list_free(list->tail);
      __objc_xfree(list);
    }
}
