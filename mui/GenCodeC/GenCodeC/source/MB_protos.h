/*
**
**	MUIBuilder.library
**
**	$VER: MUIBuilder.library 1.0
**
**		(c) copyright 1994
**		    Eric Totel
**
*/

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

BOOL	MB_Open(void);
void	MB_Close(void);
void	MB_GetA(struct TagItem *);
void	MB_Get(Tag, ... );
void	MB_GetVarInfoA(ULONG , struct TagItem *);
void	MB_GetVarInfo(ULONG , Tag, ... );
void	MB_GetNextCode(ULONG*, char ** );
void	MB_GetNextNotify(ULONG*, char ** ); 
