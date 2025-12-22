#ifndef _SGEMEM_H
#define _SGEMEN_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgelist.h
 * @brief Hash list
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeList
 * @brief Hash list
 *
 * Functions for handling string based hash
 * lists. Think of it as sgeArray with a character
 * string as index instead of a integer.
 *
 * @{
 */

typedef struct {
	/**
	 * @brief The key of the element as char pointer
	 */
	char *id;

	/**
	 * @brief The data of the element as void pointer
	 */
	void *data;

	/** @privatesection */
	void *prev;
	void *next;
} SGELISTENTRY;

typedef struct {
	/**
	 * @brief The number of elements in the array
	 */
	Uint32 numberOfEntries;

	/** @privatesection */
	SGELISTENTRY *first;
	SGELISTENTRY *last;
	SGELISTENTRY *entries;
} SGELIST;

/**
 * @brief iterator function
 * @param id the element key
 * @param data the element data
 *
 * @see sgeListForEach
 */
typedef void(SGELISTFUNCTION)(const char *id, void *data);

/**
 * @brief create a new hash list
 * @return the new list as SGELIST pointer
 *
 * Elements have to be freed yourself, after/before removing from the list.
 */
SGELIST *sgeListNew(void);

/**
 * @brief add a element on the hash index id
 * @param l hash list to add the element to
 * @param id the hash key as string
 * @param data the actual element data
 * @return a pointer to the new element as SGELISTENTRY
 */
SGELISTENTRY *sgeListAdd(SGELIST *l, const char *id, void *data);

/**
 * @brief insert a element before a certain element
 * @param l the hash list to change
 * @param le the element where to insert before
 * @param id the hash key as string
 * @param data the actual element data
 * @return a pointer to the new element as SGELISTENTRY
 */
SGELISTENTRY *sgeListInsert(SGELIST *l, SGELISTENTRY *le, const char *id, void *data);

/**
 * @brief search a element in the hash list
 * @param l the hash list to search in
 * @param id the key to search for
 * @return the element as SGELISTENTRY pointer or NULL of not found
 */
SGELISTENTRY *sgeListSearch(SGELIST *l, char *id);

/**
 * @brief remove a element from a list
 * @param l the hash list to remove the element from
 * @param id the key of the element to remove
 *
 * element data is not freed, usually you want to first search for
 * the element and free the data before calling this.
 */
void sgeListRemove(SGELIST *l, char *id);

/**
 * @brief iterate over a hash list
 * @param l the hash list to iterate over
 * @param function a function
 * 
 * The function gets the id (char *) and the data (void *) of the element.
 */
void sgeListForEach(SGELIST *l, SGELISTFUNCTION function);

/**
 * @brief destroy a hash list
 *
 * Elements are not freed, you have to free them yourself before destroying
 */
void sgeListDestroy(SGELIST *l);

// }@

#ifdef __cplusplus
}
#endif

#endif
