/******************************************************************************
 *
 * Just compile with 'lc -L bestid'
 *
 * (c) Copyright 1993 Commodore-Amiga, Inc.  All rights reserved.
 *
 * This software is provided as-is and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 *
 * bestid - program to let you play with the V39 BestModeID() function. Use the
 * CLI to build a TagList of BestModeID() tags to see how BestModeID() can be
 * used.
 *
 ******************************************************************************/

#define LIBVERSION 39

/*******************************************************************/
/*             TO DISABLE CTRL-C HANDLING, SET NO_CTRL_C TO 1      */
/*******************************************************************/

#define NO_CTRL_C 1

#include <exec/types.h>
#include <exec/exec.h>
#include <proto/exec.h>
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <proto/dos.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/displayinfo.h>
#include <proto/graphics.h>

#include <stdio.h>
#include <stdlib.h>

/*********************************************************************/
/*                            GLOBAL VARIABLES                       */
/*********************************************************************/

struct GfxBase *GfxBase = NULL ;

/**********************************************************************/
/*                                                                    */
/* void Error (char *String)                                          */
/* Print string and exit                                              */
/*                                                                    */
/**********************************************************************/

void Error (char *String)
{
	void CloseAll (void) ;
	
	printf (String) ;

	CloseAll () ;
	exit(0) ;
}


/**********************************************************************/
/*                                                                    */
/* void Init ()                                                       */
/*                                                                    */
/* Opens all the required libraries                                   */
/* allocates all memory, etc.                                         */
/*                                                                    */
/**********************************************************************/

void Init ()
{
	/* Open the graphics library.... */
	if ((GfxBase = (struct GfxBase *)OpenLibrary ("graphics.library", LIBVERSION)) == NULL)
		Error ("Could not open the Graphics.library") ;

	return ;
}

/**********************************************************************/
/*                                                                    */
/* void CloseAll ()                                                   */
/*                                                                    */
/* Closes and tidies up everything that was used.                     */
/*                                                                    */
/**********************************************************************/

void CloseAll ()
{
	/* Close the Graphics Library */
	if (GfxBase)
		CloseLibrary ((struct Library *) GfxBase) ;

	return ;
}

/***************************************************************************/

void main (int argc, char *argv[])
{
	#define TEMPLATE "MUST/N,MUSTNOT/N,V/N,W/N,H/N,DW/N,DH/N,D/N,MID/N,SID/N,RBITS/N,GBITS/N,BBITS/N"
	#define OPT_MUST	0
	#define OPT_MUSTNOT	1
	#define OPT_VP		2
	#define OPT_W		3
	#define OPT_H		4
	#define OPT_DW		5
	#define OPT_DH		6
	#define OPT_D		7
	#define OPT_MID		8 
	#define OPT_SID		9
	#define OPT_RBITS	10
	#define OPT_GBITS	11
	#define OPT_BBITS	12
	#define OPT_COUNT	13

	ULONG ID;
	LONG result[OPT_COUNT];
	LONG *val;
	struct RDArgs *rdargs;
	struct TagItem ti[OPT_COUNT+1];
	struct TagItem *next = ti;
	int i;

	Init () ;

	for (i=0; i<OPT_COUNT;ti[i].ti_Tag = TAG_DONE, result[i] = NULL, i++);
	if (rdargs = ReadArgs(TEMPLATE, result, NULL))
	{
		if (val = (LONG *)result[OPT_MUST])
		{
			next->ti_Tag = BIDTAG_DIPFMustHave;
			next->ti_Data = *val;
			next++;
			printf("DIPFMustHave = 0x%lx\n", *val);
		}
		if (val = (LONG *)result[OPT_MUSTNOT])
		{
			next->ti_Tag = BIDTAG_DIPFMustNotHave;
			next->ti_Data = *val;
			next++;
			printf("DIPFMustNotHave = 0x%lx\n", *val);
		}
		if (val = (LONG *)result[OPT_VP])
		{
			next->ti_Tag = BIDTAG_ViewPort;
			next->ti_Data = *val;
			next++;
			printf("ViewPort = 0x%lx\n", *val);
		}
		if (val = (LONG *)result[OPT_W])
		{
			next->ti_Tag = BIDTAG_NominalWidth;
			next->ti_Data = *val;
			next++;
			printf("NominalWidth = %ld\n", *val);
		}
		if (val = (LONG *)result[OPT_H])
		{
			next->ti_Tag = BIDTAG_NominalHeight;
			next->ti_Data = *val;
			next++;
			printf("NominalHeight = %ld\n", *val);
		}
		if (val = (LONG *)result[OPT_DW])
		{
			next->ti_Tag = BIDTAG_DesiredWidth;
			next->ti_Data = *val;
			next++;
			printf("DesiredWidth = %ld\n", *val);
		}
		if (val = (LONG *)result[OPT_DH])
		{
			next->ti_Tag = BIDTAG_DesiredHeight;
			next->ti_Data = *val;
			next++;
			printf("DesredHeight = %ld\n", *val);
		}
		if (val = (LONG *)result[OPT_D])
		{
			next->ti_Tag = BIDTAG_Depth;
			next->ti_Data = *val;
			next++;
			printf("Depth = %ld\n", *val);
		}
		if (val = (LONG *)result[OPT_MID])
		{
			next->ti_Tag = BIDTAG_MonitorID;
			next->ti_Data = *val;
			next++;
			printf("MonitorID = 0x%lx\n", *val);
		}
		if (val = (LONG *)result[OPT_SID])
		{
			next->ti_Tag = BIDTAG_SourceID;
			next->ti_Data = *val;
			next++;
			printf("SourceID = 0x%lx\n", *val);
		}
		if (val = (LONG *)result[OPT_RBITS])
		{
			next->ti_Tag = BIDTAG_RedBits;
			next->ti_Data = *val;
			next++;
			printf("RBits = %ld\n", *val);
		}
		if (val = (LONG *)result[OPT_GBITS])
		{
			next->ti_Tag = BIDTAG_GreenBits;
			next->ti_Data = *val;
			next++;
			printf("GBits = %ld\n", *val);
		}
		if (val = (LONG *)result[OPT_BBITS])
		{
			next->ti_Tag = BIDTAG_BlueBits;
			next->ti_Data = *val;
			next++;
			printf("BBits = %ld\n", *val);
		}
		next->ti_Tag = TAG_DONE;
		ID = BestModeIDA(ti);
		printf("BestModeID = 0x%lx\n", ID);
		FreeArgs(rdargs);
	}
		
	CloseAll () ;
}
