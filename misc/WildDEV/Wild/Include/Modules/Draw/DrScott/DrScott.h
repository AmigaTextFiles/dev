
#include <wild/wild.h>

#define 	DRSCOTT_BASE			WILD_USERBASE+1000
#define		DRSCOTT_PERSPECTIVECORRECT	DRSCOTT_BASE+0
#define		DRSCOTT_FOGGING			DRSCOTT_BASE+1
#define 	DRSCOTT_ZBUFFER			DRSCOTT_BASE+2
#define		DRSCOTT_ALPHABLENDING		DRSCOTT_BASE+3
#define		DRSCOTT_ANTIALIASING		DRSCOTT_BASE+4
#define		DRSCOTT_DITHERING		DRSCOTT_BASE+5
#define		DRSCOTT_SHADING			DRSCOTT_BASE+6
#define		DRSCOTT_TEXTURE			DRSCOTT_BASE+7

// note: DrScott is a particular module: usually, a module only support 1 draw mode:
// gouraud for Fluff, flat fot Flat, texture+shading for Candy+,
// and has his own type.
// This supports a lot of modes, to the type should change dinamycally.
// Luckyly, I can use this as FULLCOMPATIBLE because doesn't need any broker struct.
// But, if it needed, a dynamic type is needed, and also a EngineReWork any time, to
// find the modules to satisfy that.
