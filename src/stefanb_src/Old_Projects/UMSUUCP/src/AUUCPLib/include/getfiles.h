
/*
 *  GETFILES.H
 */

#ifndef _GETFILES_H
#define _GETFILES_H

typedef struct dir_list {
	struct dir_list *next;
	char name[1];
} dir_list;

#ifndef _LIST_SORT_C
extern void *list_sort(void *_list, int (*_cmp)(void *, void *));
#endif

#endif

