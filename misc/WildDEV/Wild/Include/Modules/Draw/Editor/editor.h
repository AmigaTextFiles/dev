#ifndef WILD_MODULE_DRAW_EDITOR_H
#define WILD_MODULE_DRAW_EDITOR_H

#include <wild/wild.h>

#define 	EDITOR_BASE			WILD_USERBASE+1200
#define		EDITOR_ADDSPECIALFACES		EDITOR_BASE+0
#define		EDITOR_ADDSPECIALEDGES		EDITOR_BASE+1
#define		EDITOR_ADDSPECIALPOINTS		EDITOR_BASE+2
#define		EDITOR_REMSPECIALOBJECTS	EDITOR_BASE+3	/* NOte: you can do a single setwildapptags call including this and some ADDSPECIAL???: the old objs will be removed, and THEN the new are added. */
#define		EDITOR_ADDINGCOLOR		EDITOR_BASE+4	/* any object you add in this setwildapptags call will have this color (colormap! 0-255, NOT 24bit color !!) */
#define		EDITOR_NORMALCOLOR		EDITOR_BASE+5
#define		EDITOR_ONLYSPECIALSDRAW		EDITOR_BASE+6	/* TRUE=Makes the module draw only the special ones: see note 1 */

#endif

/* note 1:
This is used to have a speeeed up: you do not draw the faces, and draw only the edges.
The edges are faster, because you never draw an edge 2 times: using faces, you draw
some edges twice or more.
*/