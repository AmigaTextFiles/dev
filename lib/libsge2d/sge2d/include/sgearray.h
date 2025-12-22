#ifndef _SGEARRAY_H
#define _SGEARRAY_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgearray.h
 * @brief A dynamic array
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeArray
 * @brief A dynamic array
 */

/**
 * @addtogroup sgeArray
 *
 * Provides functions for handling dynamic arrays.
 *
 * @{
 */

typedef struct {
	/**
	 * @brief The number of elements in the array
	 */
	Uint32 numberOfElements;

	/**
	 * @privatesection
	 */
	void **element;
	void (*freeFunction)(Uint32, void *);
} SGEARRAY;

/**
 * @brief create a new array
 *
 * With the standard array you have to free the elements
 * resources by yourself when removing elements
 */
SGEARRAY *sgeArrayNew(void);

/**
 * @brief create a new auto array
 *
 * With auto array, you can provide a 'remove' function
 * which is called when elements are removed, where you
 * can free the resources.
 *
 * @param function a function that frees the element
 */
SGEARRAY *sgeAutoArrayNew(void (*function)(Uint32, void *));

/**
 * @brief free resources
 *
 * On standard array you have to free all elements resources
 * by yourself, on auto arrays the free function is called
 * for every element.
 *
 * @param a the array to free
 */
void sgeArrayDestroy(SGEARRAY *a);

/**
 * @brief add a element to the array
 *
 * @param a the array to add the element
 * @param e the pointer to the element
 */
void sgeArrayAdd(SGEARRAY *a, void *e);

/**
 * @brief insert a element in a certain position
 *
 * @param a the array to insert the element into
 * @param offset the position where to insert
 * @param e the element to insert
 */
void sgeArrayInsert(SGEARRAY *a, Uint32 offset, void *e);

/**
 * @brief replace a element in the array
 *
 * @param a the array where to replace the element
 * @param offset the position to replace
 * @param e the new element
 */
void sgeArrayReplace(SGEARRAY *a, Uint32 offset, void *e);

/**
 * @brief get a element from the array
 *
 * @param a the array to get the element from
 * @param offset the position of the element
 */
void *sgeArrayGet(SGEARRAY *a, Uint32 offset);

/**
 * @brief remove a element from the array
 *
 * On standard arrays the elements resources are not freed,
 * on auto arrays the free function is called.
 *
 * @param a the array to remove the element from
 * @param offset the position of the element to remove
 */
void sgeArrayRemove(SGEARRAY *a, Uint32 offset);

/**
 * @brief iterate through all elements of a element
 *
 * Call a function on every element in the array. The
 * function is passed a Uint32, which is the offset of the element,
 * and a void pointer, which is the element data itself.
 *
 * @param a the array to iterate over
 * @param function the function pointer to call for every element
 */
void sgeArrayForEach(SGEARRAY *a, void function(Uint32, void *));

/**
 * @brief the number of elements in a array
 *
 * @param a the array to check
 */
extern Uint32 sgeArraySize(SGEARRAY *a);

// }@

#ifdef __cplusplus
}
#endif

#endif
