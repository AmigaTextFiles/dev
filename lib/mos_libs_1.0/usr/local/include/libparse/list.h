/** 
* @author Riccardo Manfrin [namesurname at gmail dot com]
* 
* @brief  Linked list data structure
*/

#ifndef LIST_H
#define LIST_H

typedef struct elem{
	void* object;
	struct elem *next;
} elem;

typedef struct list{
	elem* el;
} list;

typedef enum{
	///Indicates list_find/list_pop function to return any (the first) found object
	FOUND = 0,
	///Indicates that the compared object is not matching the comparison term
	NOTFOUND = -1,
	///Indicates that the compared object matches the comparison term and must be used as subsequent comparison term
	SEARCHAGAIN = 1,
} compare_result;

/**************************************** Function declaration ****************************************/



/** 
 * Creates a new list, allocate it and return a pointer to that.
 * All the lists must be initialized through this method, therefore
 * we don't protect the code from NULL list pointers.
 */
list* list_new();

/**
 * Frees the list. If second argument is not NULL,
 * the function interprets it as a pointer to
 * the code of the function to use to free each object stored
 * in the list
 */
void list_free(list* l, void(*spec_obj_free)(void *));

/**
 * Returns the number of items present in the list
 */
unsigned int list_count(list *l);

/**
 * Prints list content using the printing function
 * specified as second argument (so we can adapt to
 * different type of objects
 */
void list_print(list *lst, void(*spec_obj_print)(void *));

/**
 * Append an object at the end of the list.
 * When size argument is set to NULL (zero), object reference only 
 * is copied, so you need an already mallocated object in order to 
 * preserve data.
 * When a size greater than zero is specified instead, the object
 * is cloned in a mallocated memory area.
 */
void list_push(list* lst, void* obj, unsigned int size);

/**
 * Pop object found through the specified index and return it
 * If we violate list max index or list is NULL, NULL is returned;
 * List node is freed while object is return via its reference.
 */
void *list_pop_index(list* lst, unsigned int index);

/**
 * Search for the object matching the comparizon_ref
 * criteria by applying function compare to all objects
 * stored in the list.
 * compare can return
 * 0 in case of absolute matching:
 *   => list_find returns the found object (first 
 *   matching one)
 * 1 in case of relative matching:
 *   => indicates that the object meets the matching 
 *   requirements but that search is not complete, and
 *   we must use the found object as the new comparison
 *   term for next comparisons up to the end of the list.
 *   When search terminates the last object found is returned
 *   (which should "best fit" the comparison term).
 * other values (typically -1) in case of missmatching
 *   => mean that we need to further search for a 
 *   matching object.
 *
 * Object and list element are not freed and neither popped from
 * the list. Reference only is returned.
 * Example:
 * if(p) printf("Proc found ... %s\n", p->pname);
 * int compare(proc_data *p1, proc_data *p2){
 * 	if (memcmp(p1->pname,p2->pname, strlen(p2->pname))) return 0;
 * 	return -1
 * }
 * if (p) if(list_find(processes, compare, p)) printf("Found\n");
 */
void *list_find(list* lst, compare_result (*compare) (void *, void *), void * comparison_ref);

/**
 * Search for the object matching the comparizon_ref
 * criteria by applying function compare to all objects
 * stored in the list.
 * 
 * compare can return
 * 0 in case of absolute matching:
 *   => list_find returns the found object (first 
 *   matching one)
 * 1 in case of relative matching:
 *   => indicates that the object meets the matching 
 *   requirements but that search is not complete, and
 *   we must use the found object as the new comparison
 *   term for next comparisons up to the end of the list.
 *   When search terminates the last object found is returned
 *   (which should "best fit" the comparison term).
 * other values (typically -1) in case of missmatching
 *   => mean that we need to further search for a 
 *   matching object.
 *   
 * List element is popped from the list, object reference is
 * returned and relative list elem is freed.
 */
void *list_pop(list* lst, compare_result (*compare) (void *, void *), void * comparison_ref);

/**
 * Reverse the input parameter list in a top-down fashion (last 
 * element becomes first and viceversa. Note that this function
 * acts on the objects references, not on the list elements.
 */
list* list_reverse(list * lst);

#endif
