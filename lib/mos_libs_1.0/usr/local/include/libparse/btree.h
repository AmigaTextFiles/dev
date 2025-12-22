/** 
* @author Riccardo Manfrin [namesurname at gmail dot com]
* 
* @brief  Binary tree data structure
*/

#ifndef BTREE_H
#define BTREE_H

typedef struct node{
	///obj can be an operator, a value, a variable, or a string to parse.
	void *obj;
	///obj size
	unsigned int objsz;
	struct node *left;
	struct node *right;
} btree;

/**************************************** Function declaration ****************************************/

/** 
 * Creates a new btree, allocates it and returns a pointer to that.
 * All the btree must be initialized through this method, otherwise
 * we don't protect the code from NULL btree pointers.
 */
btree* btree_new();

/**
 * This function can dispatch function fptr to all the subnodes of
 * the binary tree bt (which are btree themselves), in a postorder 
 * fashion (starting from the bottom of the tree (leftmost node 
 * first, right ones afterwards) and climbing it up towards the root
 */
void btree_dispatcher_post(void(*fptr)(void *) ,btree* bt);
/**
 * This function is the same dispatcher but in preorder
 */
void btree_dispatcher_pre(void(*fptr)(void *) ,btree* bt);

/**
 * Printing function requires to specify stored object
 * printing functions. Printing is in preorder.
 * e.g.: Consider the following tree structure:
 * 
 * 	 ____a____
 *  __b__		 c
 * d		e
 * 
 * Sequence printing order follows: a,b,d,e,c
 */
void btree_print(btree* bt, void(*spec_obj_print)(void *));

void btree_fill(btree* bt, void* obj);

// void btree_addleft(btree* root, btree_type t, void* obj, unsigned int size);
// 
// void btree_addright(btree* root, btree_type t, void* obj, unsigned int size);

void btree_free(btree* bt, void(*spec_obj_free)(void *));

#endif
