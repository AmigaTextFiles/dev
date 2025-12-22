#ifndef TAGLIST_H
#define TAGLIST_H 1
/*
**	$Filename: libraries/taglist.h
**  $Release: 1.0 $
**	$Revision: 104 $
**	$Date: 92/11/12 $
**	$Author: Sam Hepworth $
**
**	(C) Copyright 1992 Zeal-Computer.
**	All Rights Reserved
**
**	Disclaimer:
**    This  code  is  freely  redistributable upon the conditions that this
**    notice  remains intact and that modified versions of this file not be
**    distributed  in  any  way.   The author makes no warranty of any kind
**    with  respect  to  this  product and explicitly disclaims any implied
**    warranties of merchantability or fitness for any particular purpose.
**
**	History:
**	  92/11/12 First public release.
*/




	/*
	** Include
	*/
#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif




	/*
	** TagMapItem structure
	*/
struct TagMapItem {
	ULONG	tmi_ID;
	WORD	tmi_Offset;
	UBYTE	tmi_Miss;
	UBYTE	tmi_Type;
	ULONG	tmi_Default;
};
	



	/*
	** TagMapItem types
	*/
#define TMI_BYTE		(0)		/* store tagvalue in byte	*/
#define TMI_WORD		(4)		/* store tagvalue in word	*/
#define TMI_LONG		(8)		/* store tagvalue in long	*/
#define TMI_INT			(0)		/* tagvalue is an integer	*/
#define TMI_BOOL		(12)	/* TRUE sets bits			*/
#define TMI_bool		(24)	/* TRUE clears bits			*/
#define TMI_NODEFAULT	(0)		/* default undefined		*/
#define TMI_DEFAULT		(36)	/* default is TRUE			*/
#define TMI_default		(60)	/* default is FALSE			*/




	/*
	** Old name of TMI_INT
	*/
#define TMI_REAL		TMI_INT




	/*
	** New TAG command (only to be used in TAGMAP items)
	*/
#define TAG_INIT		(1)		/* copy default value */





	/*
	** TAGMAP(id,offset,missbits,BYTE|WORD|LONG,INT|BOOL|bool,NODEFAULT|DEFAULT|default)
	*/
#define TAGMAP(a,b,c,d,e,f,g,h) {a,OFFSET(b,c),d,TMI_##e+TMI_##f+TMI_##g,h}




/*
** How to use the TAGMAP macro
**
** You  have  a structure named "NewWindow".  In this structure you have an
** entry named "LeftEdge" containing a 16 bit integer.  Now, you have a tag
** named  "WA_Left"  that  should  be maped into "LeftEdge".  If the tag is
** missing the value "0" should be store in "LeftEdge.  To do this you must
** create a TAGMAP item like this:
**
** TAGMAP(WA_Left,NewWindow,LeftEdge,0,        REAL,  WORD,DEFAULT,   0)
**        ^       ^         ^        ^         ^      ^    ^          ^
**        ID      Structure Offset   MissFlag  Number Size Default is 0
**
** If  "LeftEdge"  is  the  position  of  the  left  edge of a window to be
** created,  it  may  be a better idea to center the window if no "WA_Left"
** tag  is found.  However to center a window you need to know the width of
** it  and  the  screen it will be created on.  So, if the "WA_Left" tag is
** missing  we  must know this.  The following TAGMAP item set bit 0 of the
** missflags.
**
** TAGMAP(WA_Left,NewWindow,LeftEdge,1,        REAL,  WORD,NODEFAULT, 0)
**        ^       ^         ^        ^         ^      ^    ^          ^
**        ID      Structure Offset   MissFlag  Number Size No default Ignored
*/


#endif /* TAGLIST_H */
