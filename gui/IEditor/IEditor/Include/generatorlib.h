#ifndef IEDIT_GENERATOR_H
#define IEDIT_GENERATOR_H
/*
**      Interface Editor generators definitions.
**
**      (C) Copyright 1996 Simone Tellini
**          All Rights Reserved
*/


struct Generator {
	    struct Library      Lib;
	    UBYTE              *Ext;
	    UBYTE              *Pattern;
};


#define     MAXPATH     256

/*  This structure is returned by OpenFiles  */

struct GenFiles {
	    BPTR        Std;    /* standard file, e.g. GMExample.c      */
	    BPTR        Main;   /* main file, e.g. GMExampleMain.c      */
	    BPTR        XDef;   /* XDef file, e.g. GMExample.h          */
	    BPTR        Temp;   /* Template File, e.g. GMExample_temp.c */
	    APTR        User1;  /* some user pointers                   */
	    APTR        User2;
	    APTR        User3;
	    UBYTE       XDefName[ MAXPATH ]; /* useful because it's     */
					     /* usually included in the */
					     /* Std file by the         */
					     /* WriteHeaders routine    */
};




/*  Error Codes    */

#define  GENERATOR_OK           0
#define  GENERATOR_IOERR        1   /* read-write error            */
#define  GENERATOR_NOTSUPPORTED 2   /* We're asked to do something */
				    /* we cannot do                */
#define  GENERATOR_LATER        3   /* call us later               */
#define  GENERATOR_NOMEMORY     4   /* out of memory               */

#endif
