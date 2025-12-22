/*
 *	File:					Dirs.h
 *	Description:	Lets Recall handle directories.
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef DIRS_H
#define	DIRS_H

/*** GLOBALS *************************************************************************/
extern struct List *dirlist;

struct DirNode
{
	struct Node nn_Node;
	struct List *dir;
	struct EventNode *eventnode;
};

/*** PROTOTYPES **********************************************************************/
void PushDir(struct List *list, struct EventNode *eventnode);
struct List *PopDir(void);
void ShowChildren(struct EventNode *node);
void ShowParent(void);
void ShowRoot(void);
#endif
