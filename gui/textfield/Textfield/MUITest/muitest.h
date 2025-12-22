/*
 * muitest.h was generated my MUIBuilder.
 */

struct ObjApp
{
	APTR	App;
	APTR	window;
	APTR	text;
	APTR	object;
	APTR	sbar;
};

extern struct ObjApp * CreateApp( void );
extern void DisposeApp( struct ObjApp * );
