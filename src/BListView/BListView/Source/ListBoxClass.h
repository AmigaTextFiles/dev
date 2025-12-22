#ifndef LISTBOXCLASS_H
#define LISTBOXCLASS_H
/*
**	ListBoxClass.h
**
**	Copyright (C) 1997 by Bernardo Innocenti
**
**	ListBox class built on top of the "groupgclass".
**
*/

#define LISTBOXCLASS	"listboxclass"
#define LISTBOXVERS		1


Class	*MakeListBoxClass (void);
void	 FreeListBoxClass (Class *ListViewClass);



/*****************/
/* Class Methods */
/*****************/

/* This class does not define any new methods */

/********************/
/* Class Attributes */
/********************/

/* #define LBA_Dummy			(TAG_USER | ('L'<<16) | ('B'<<8))
 */

/* This class does not define any new attributes */


#endif /* !LISTBOXCLASS_H */
