/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <rexx/storage.h>
#include <rexx/rxslib.h>

#ifdef __GNUC__
/* GCC needs all struct defs */
#include <dos/exall.h>
#include <graphics/graphint.h>
#include <intuition/classes.h>
#include <devices/keymap.h>
#include <exec/semaphores.h>
#endif

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/rexxsyslib_protos.h>

#ifndef __NO_PRAGMAS

#ifdef AZTEC_C
#include <pragmas/exec_lib.h>
#include <pragmas/dos_lib.h>
#include <pragmas/rexxsyslib_lib.h>
#endif

#ifdef LATTICE
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>
#endif

#endif /* __NO_PRAGMAS */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifdef LATTICE
#undef toupper
#define inline __inline
#endif

#ifdef __GNUC__
#undef toupper
static inline char toupper( char c )
{
	return( islower(c) ? c - 'a' + 'A' : c );
}
#endif

#ifdef AZTEC_C
#define inline
#endif

#include "drawrexx.h"
#include "drawrexx_aux.h"
#include "drawrexx_rxif_aux.h"

extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;
extern struct RxsLib *RexxSysBase;


/* $ARB: I 790338933 */


/* $ARB: B 1 SETFCOLOR */
void rx_setfcolor( struct RexxHost *host, struct rxd_setfcolor **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setfcolor *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			PState.uwRexxFColor = MatchPalette(*rd->arg.red,
			                                   *rd->arg.green,
			                                   *rd->arg.blue,
			                                   (rd->arg.notbackground != FALSE),NULL, NULL);
			rd->rc2 = PState.uwRexxFColor;
			rd->rc = 1;  /* causes errors on high pens : PState.uwRexxFColor; */
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 1 SETFCOLOR */

/* $ARB: B 2 SETFPEN */
void rx_setfpen( struct RexxHost *host, struct rxd_setfpen **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setfpen *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((*rd->arg.pen < 0)||(*rd->arg.pen >= 1<<PState.ubDepth))
			{
				rd->rc = 0;
			}
			else
			{
				PState.uwRexxFColor = *rd->arg.pen;	                          			           
				rd->rc = 1;
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 2 SETFPEN */

/* $ARB: B 3 SETBCOLOR */
void rx_setbcolor( struct RexxHost *host, struct rxd_setbcolor **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setbcolor *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			PState.uwRexxBColor = MatchPalette(*rd->arg.red,
			                                   *rd->arg.green,
			                                   *rd->arg.blue,
			                                   (rd->arg.notbackground != FALSE),NULL, NULL);
			rd->rc = 1; /* PState.uwRexxBColor; */
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 3 SETBCOLOR */

/* $ARB: B 4 SETBPEN */
void rx_setbpen( struct RexxHost *host, struct rxd_setbpen **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setbpen *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((*rd->arg.pen < 0)||(*rd->arg.pen >= 1<<PState.ubDepth))
				rd->rc = 0;
			else
			{
				PState.uwRexxBColor = *rd->arg.pen;
				rd->rc = 1;
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 4 SETBPEN */

/* $ARB: B 5 POINT */
void rx_point( struct RexxHost *host, struct rxd_point **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_point *rd = *rxd;
    int x, y;
    
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			x = *rd->arg.x;
			y = *rd->arg.y;
			FixCoords(&x, &y);
			rd->rc = FixPos(&x, &y);
			if (rd->rc == TRUE)
			{
				if (rd->arg.xor)
					SetDrMd(DrawWindow->RPort, COMPLEMENT);
				else				
					SetAPen(DrawWindow->RPort, PState.uwRexxFColor);
					
				WritePixel(DrawWindow->RPort, x, y);
				SetDrMd(DrawWindow->RPort, JAM1);

				OutputAction(FROM_REXX, MODE_DOT | (MODE_XOR * (rd->arg.xor != 0)), x, y, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
			}
			break;

		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec(rd);
			break;
	}
	return;
}
/* $ARB: E 5 POINT */

/* $ARB: B 6 PENRESET */
void rx_penreset( struct RexxHost *host, struct rxd_penreset **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_penreset *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			XRexxPen = -1;
			YRexxPen = -1;
			rd->rc = 1;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 6 PENRESET */

/* $ARB: B 7 PEN */
void rx_pen( struct RexxHost *host, struct rxd_pen **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_pen *rd = *rxd;
    int x,y;
    
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((XRexxPen == -1)&&(YRexxPen == -1))
			{
				XRexxPen = *rd->arg.x;
				YRexxPen = *rd->arg.y;
				FixCoords(&XRexxPen, &YRexxPen);
				rd->rc = FixPos(&XRexxPen, &YRexxPen);
			}
			else
			{
				Move(DrawWindow->RPort, XRexxPen, YRexxPen);
				x = *rd->arg.x;
				y = *rd->arg.y;
				FixCoords(&x, &y);
				rd->rc = FixPos(&x, &y);
				if (rd->arg.xor)
					SetDrMd(DrawWindow->RPort, COMPLEMENT);
				else
					SetAPen(DrawWindow->RPort, PState.uwRexxFColor);
				
				Draw(DrawWindow->RPort, x, y);
				SetDrMd(DrawWindow->RPort, JAM1);  /* Restore regular mode */

				OutputAction(FROM_REXX, MODE_LINE | (MODE_XOR * (rd->arg.xor != 0)), XRexxPen, YRexxPen, x, y, DEST_PEER|DEST_FILE);
				XRexxPen = x;
				YRexxPen = y;
			}
			break;
				
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 7 PEN */

/* $ARB: B 8 LINE */
void rx_line( struct RexxHost *host, struct rxd_line **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_line *rd = *rxd;
	int x1, y1, x2, y2;
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			x1 = *rd->arg.x1; y1 = *rd->arg.y1;
			x2 = *rd->arg.x2; y2 = *rd->arg.y2;
			FixCoords(&x1, &y1);
			FixCoords(&x2, &y2);
			rd->rc = (FixPos(&x1, &y1) && FixPos(&x2, &y2));
			if (rd->rc == FALSE) FixPos(&x2, &y2);	/* avoid the short-circuit! */
			
			if (rd->arg.xor)
				SetDrMd(DrawWindow->RPort, COMPLEMENT);
			else
				SetAPen(DrawWindow->RPort, PState.uwRexxFColor);

			Move(DrawWindow->RPort, x1, y1);
			Draw(DrawWindow->RPort, x2, y2);
			SetDrMd(DrawWindow->RPort, JAM1);
			
			OutputAction(FROM_REXX, MODE_LINE | (MODE_XOR * (rd->arg.xor != 0)), x1, y1, x2, y2, DEST_PEER|DEST_FILE);
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 8 LINE */

/* $ARB: B 9 CIRCLE */
void rx_circle( struct RexxHost *host, struct rxd_circle **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_circle *rd = *rxd;
	int xCenter, yCenter, yTop, xLeft, yBottom, xRight, xR, yR;
	ULONG ulMode = MODE_CIRCLE;
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			xCenter = *rd->arg.x;
			yCenter = *rd->arg.y;
			FixCoords(&xCenter, &yCenter);
			
			xR = *rd->arg.rx;
			yR = *rd->arg.ry;
			
			yTop   = yCenter - yR;
			xLeft  = xCenter - xR;
			xRight = xCenter + xR;
			yBottom= yCenter + yR;
			
			FixPos(&xCenter, &yCenter);
			
			/* Make sure edges of circle are within canvas */
			if (FixPos(&xLeft, &yCenter)   == FALSE) xR = (xCenter - xLeft);
			if ((FixPos(&xRight, &yCenter)  == FALSE)&&(xR > (xRight - xCenter))) xR = (xRight  - xCenter);
				
			if (FixPos(&xCenter, &yTop)    == FALSE) yR = (yTop    - yCenter);
			if ((FixPos(&xCenter, &yBottom) == FALSE)&&(yR > (yBottom - yCenter))) 
			{
				yR = (yBottom - yCenter);
			
			}
				
			FixPos(&xRight,  &yBottom);
			
			
			if (rd->arg.xor)
				SetDrMd(DrawWindow->RPort, COMPLEMENT);
			else
				SetAPen(DrawWindow->RPort,PState.uwRexxFColor);
				
			Ellipse(xCenter, yCenter, xR, yR, (rd->arg.fill != FALSE));
			SetDrMd(DrawWindow->RPort, JAM1);
			
			if (rd->arg.fill) ulMode |= MODE_FILLED;
			if (rd->arg.xor)  ulMode |= MODE_XOR;
			
			OutputAction(FROM_REXX, ulMode, xCenter, yCenter, 
					xR, yR, DEST_PEER|DEST_FILE);
			rd->rc = 1;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 9 CIRCLE */

/* $ARB: B 10 SQUARE */
void rx_square( struct RexxHost *host, struct rxd_square **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_square *rd = *rxd;
	int x1, x2, y1, y2;
	ULONG ulMode = MODE_SQUARE;
	BOOL BTemp;
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			x1 = *rd->arg.x1;
			y1 = *rd->arg.y1;
			x2 = *rd->arg.x2;
			y2 = *rd->arg.y2;
			FixCoords(&x1, &y1);
			FixCoords(&x2, &y2);
			
			BTemp = FixPos(&x1, &y1);
			BTemp |= FixPos(&x2, &y2);
			
			if (BTemp)
			{
				if (rd->arg.xor)
					SetDrMd(DrawWindow->RPort, COMPLEMENT);
				else
					SetAPen(DrawWindow->RPort,PState.uwRexxFColor); 	
				
				Rectangle(x1, y1, x2, y2, (rd->arg.fill != 0)); 
				
				/* Reset draw mode */
				SetDrMd(DrawWindow->RPort, JAM1);

				if (rd->arg.fill) ulMode |= MODE_FILLED;
				if (rd->arg.xor)  ulMode |= MODE_XOR;
			
				OutputAction(FROM_REXX, ulMode, x1, y1, x2, y2, DEST_PEER|DEST_FILE);
				rd->rc = 1;
			}
			else
				rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 10 SQUARE */

/* $ARB: B 13 FLOOD */
void rx_flood( struct RexxHost *host, struct rxd_flood **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_flood *rd = *rxd;
	int x,y, ulFillThisColor;
    
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			x = *rd->arg.x;
			y = *rd->arg.y;
			FixCoords(&x, &y);
			rd->rc = FixPos(&x, &y);
			if (rd->rc == 0) return;		/* No offscreen flooding! */
			
			ulFillThisColor = ReadPixel(DrawWindow->RPort, x, y);
			
			if (ulFillThisColor == PState.uwRexxFColor)
			{
				/* fill same color pixel--trivial accept */
				rd->rc = 1;
			}
			else
			{			
  				SetPointer(DrawWindow, (UWORD *)waitPointer, 16, 16, -6, 0);       
				if (BSafeFloods == TRUE)
            			{
		        	    	/* Send flood info as a series of horizontal lines */
 					SetAPen(DrawWindow->RPort, PState.uwRexxFColor);
		        	        bFloodFromCode = FROM_REXX;		/* Set Flag */
                			FloodFill(x, y, ReadPixel(DrawWindow->RPort,x,y), 0, 0, 0, DEST_PEER|DEST_FILE);
					bFloodFromCode = FROM_IDCMP;	/* Reset flag */
            			}
            			else
            			{
		        	        /* Send flood info as simple co-ordinates */
      				        OutputAction(FROM_REXX, MODE_FLOOD, x, y, PState.uwRexxFColor, NOP_PAD, DEST_PEER|DEST_FILE);
 					SetAPen(DrawWindow->RPort, PState.uwRexxFColor);
		        	        FloodFill(x, y, ReadPixel(DrawWindow->RPort,x,y), 0, 0, 0, 0L);
            			}
		        	ClearPointer(DrawWindow);
		        }		        
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 13 FLOOD */

/* $ARB: B 14 CLEAR */
void rx_clear( struct RexxHost *host, struct rxd_clear **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_clear *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec(sizeof *rd, MEMF_CLEAR);
			break;

		case RXIF_ACTION:
			/* Insert your CODE here */
			ClearWindow();
			OutputAction(FROM_REXX, COMMAND, COMMAND_CLEAR, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
			rd->rc = 1;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 14 CLEAR */

/* $ARB: B 15 TYPEKEYS */
void rx_typekeys( struct RexxHost *host, struct rxd_typekeys **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_typekeys *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			while(*rd->arg.message != '\0') 
			{
				DisplayKeyPress(*rd->arg.message, TRUE);
				rd->arg.message++;
			}
			rd->rc = 1;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 15 TYPEKEYS */

/* $ARB: B 16 EASYREQUEST */
void rx_easyrequest( struct RexxHost *host, struct rxd_easyrequest **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_easyrequest *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = MakeReq(rd->arg.title,rd->arg.message,rd->arg.gadgets);
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 16 EASYREQUEST */

/* $ARB: B 17 STRINGREQUEST */
void rx_stringrequest( struct RexxHost *host, struct rxd_stringrequest **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_stringrequest *rd = *rxd;
	static char szUserStringBuf[200] = "";
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			strncpy(szUserStringBuf, rd->arg.defaultstring, sizeof(szUserStringBuf));
			if (GetUserString(szUserStringBuf, rd->arg.title, rd->arg.message, sizeof(szUserStringBuf)) == TRUE)
				rd->res.message = szUserStringBuf; 
				else
				rd->res.message = "(User aborted)";
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 17 STRINGREQUEST */

/* $ARB: B 18 FILEREQUEST */
void rx_filerequest( struct RexxHost *host, struct rxd_filerequest **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_filerequest *rd = *rxd;
	static char szFileBuf[500];
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			*szFileBuf = '\0';
			if (FileRequest(rd->arg.title, szFileBuf, NULL,
			 		rd->arg.dir, rd->arg.file, (rd->arg.save != 0)) == FALSE)
			 		rd->res.file = "(User Aborted)";
			else
				rd->res.file = szFileBuf;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 18 FILEREQUEST */

/* $ARB: B 19 CONNECT */
void rx_connect( struct RexxHost *host, struct rxd_connect **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_connect *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = 0;
			if (BNetConnect == TRUE) return;
			strncpy(targethost,rd->arg.hostname, sizeof(targethost));
			rd->rc = ConnectDrawSocket(FALSE);
			if (rd->rc) Synch();
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 19 CONNECT */

/* $ARB: B 20 DISCONNECT */
void rx_disconnect( struct RexxHost *host, struct rxd_disconnect **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_disconnect *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if (BNetConnect == FALSE) 
				rd->rc = 0;
			else
			{
				CloseDrawSocket();
				rd->rc = 1;
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 20 DISCONNECT */

/* $ARB: B 21 PLAYSCRIPT */
void rx_playscript( struct RexxHost *host, struct rxd_playscript **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_playscript *rd = *rxd;
	UWORD uwSaveRemoteMode   = PState.uwRemoteMode;
	UWORD uwSaveRemoteFColor = PState.uwRemoteFColor;
	UWORD uwSaveRemoteBColor = PState.uwRemoteBColor;
	FILE *fpScript;
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((fpScript = fopen(rd->arg.file, "rb")) == NULL)
			{
				rd->rc = 0;
			}
			else
			{
				SetPointer(DrawWindow, (UWORD *)waitPointer, 16, 16, -6, 0);
				/* playback script file */
				while (RemoteHandler(fpScript, TRUE) == TRUE);
				fclose(fpScript);
				
				/* Restore remote state */
				PState.uwRemoteMode   = uwSaveRemoteMode;
				PState.uwRemoteFColor = uwSaveRemoteFColor;
				PState.uwRemoteBColor = uwSaveRemoteBColor;
				ClearPointer(DrawWindow);
				
				rd->rc = 1;
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 21 PLAYSCRIPT */

/* $ARB: B 22 RECORDSCRIPT */
void rx_recordscript( struct RexxHost *host, struct rxd_recordscript **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_recordscript *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((rd->arg.stop) && (fpOut != NULL))
			{
				fclose(fpOut);
				fpOut = NULL;
				SetWindowTitle("Recording complete.");
				rd->rc = 1;
				SetMenuValues();
			}
			else
			{
				if ((rd->arg.start) && (fpOut == NULL) && 
					((fpOut = fopen(rd->arg.file,"a+b")) != NULL))
				{
					/* Save basic state information to disk */
					OutputAction(FROM_REXX, COMMAND, COMMAND_RGB,   PState.uwFColor, PState.uwBColor, NOP_PAD, DEST_FILE);
					OutputAction(FROM_REXX, MODE_CHANGE, PState.uwMode, NOP_PAD, NOP_PAD, NOP_PAD, DEST_FILE);
					SetWindowTitle("Now recording actions.");
					rd->rc = 1;
					SetMenuValues();
				}
				else
					rd->rc = 0;
			}
			break;
			
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 22 RECORDSCRIPT */

/* $ARB: B 23 LOCK */
void rx_lock( struct RexxHost *host, struct rxd_lock **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_lock *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if (rd->arg.off) EnableDraw(TRUE); else EnableDraw(FALSE);
			rd->rc = 1;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 23 LOCK */

/* $ARB: B 25 LOCKPALETTE */
void rx_lockpalette( struct RexxHost *host, struct rxd_lockpalette **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_lockpalette *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			
			/* We can only toggle ON if our palette >= their palette */
			if ((BPalettesLocked == FALSE)&&
			    (PState.ubDepth < PState.ubRemoteDepth))
			{
			    	rd->rc = 0;
			}
			else
			{
				if ((BNetConnect == TRUE) && 
					(((BPalettesLocked == TRUE)&&(rd->arg.off)&&(PState.ubDepth >= PState.ubRemoteDepth)) ||
					 ((BPalettesLocked == FALSE)&&(rd->arg.on))))
				{
						ToggleLockPalettes();
						rd->rc = 1;
				}
				else
					rd->rc = 0;			
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 25 LOCKPALETTE */

/* $ARB: B 29 SIZEWINDOW */
void rx_sizewindow( struct RexxHost *host, struct rxd_sizewindow **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_sizewindow *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = ReSizeWindow(*rd->arg.width, *rd->arg.height, TRUE);
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 29 SIZEWINDOW */

/* $ARB: B 30 QUIT */
void rx_quit( struct RexxHost *host, struct rxd_quit **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_quit *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = 1;
			BProgramDone = TRUE;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 30 QUIT */

/* $ARB: B 31 GETWINDOWATTRS */
void rx_getwindowattrs( struct RexxHost *host, struct rxd_getwindowattrs **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_getwindowattrs *rd = *rxd;
	static LONG lWintop, lWinleft, lWinwidth, lWinheight, lWindepth, lWinmaxwidth, lWinmaxheight;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			
			lWintop       = DrawWindow->TopEdge;
			lWinleft      = DrawWindow->LeftEdge;
			lWinwidth     = DrawWindow->Width;
			lWinheight    = DrawWindow->Height;
			lWindepth     = PState.ubDepth;
			lWinmaxwidth  = DrawWindow->MaxWidth;
			lWinmaxheight = DrawWindow->MaxHeight;
		
			if (lWinmaxwidth  >= 65535) lWinmaxwidth  = Scr->Width;
			if (lWinmaxheight >= 65535) lWinmaxheight = Scr->Height;
				
			rd->res.top       = &lWintop;
			rd->res.left      = &lWinleft;
			rd->res.width     = &lWinwidth;
			rd->res.height    = &lWinheight;
			rd->res.depth     = &lWindepth;
			rd->res.maxwidth  = &lWinmaxwidth;
			rd->res.maxheight = &lWinmaxheight;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 31 GETWINDOWATTRS */

/* $ARB: B 32 GETSTATEATTRS */
void rx_getstateattrs( struct RexxHost *host, struct rxd_getstateattrs **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_getstateattrs *rd = *rxd;
	static LONG lMode, lPendown, lLocked, lFpen, lBpen, lFred, lFgreen,
	            lFblue, lBred, lBgreen, lBblue;
	UWORD uwThisColor;
	        
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			lMode     = PState.uwMode;
			lPendown  = PState.BPenDown;
			lLocked   = Not[PState.BDrawEnabled];
			lFpen     = PState.uwFColor;
			lBpen	  = PState.uwBColor;

			/* Extract R, G, B for FColor from return value */
			uwThisColor = RGBComponents(lFpen);
			lFblue  = (uwThisColor      & 0x000F); /* Right 4 bits */
			lFgreen = ((uwThisColor>>4) & 0x000F); /* 2nd 4 bits from right */
			lFred   = ((uwThisColor>>8) & 0x000F); /* 3rd 4 bits from right */

			/* Extract R, G, B for BColor from return value */
			uwThisColor = RGBComponents(lBpen);
			lBblue  = (uwThisColor      & 0x000F); /* Right 4 bits */
			lBgreen = ((uwThisColor>>4) & 0x000F); /* 2nd 4 bits from right */
			lBred   = ((uwThisColor>>8) & 0x000F); /* 3rd 4 bits from right */

			rd->res.mode    = &lMode;
			rd->res.pendown = &lPendown;
			rd->res.locked  = &lLocked;
			rd->res.fpen    = &lFpen;
			rd->res.bpen    = &lBpen;
			rd->res.fred    = &lFred;
			rd->res.fgreen  = &lFgreen;
			rd->res.fblue   = &lFblue;
			rd->res.bred    = &lBred;
			rd->res.bgreen  = &lBgreen;
			rd->res.bblue   = &lBblue;
			
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 32 GETSTATEATTRS */

/* $ARB: B 33 GETREMOTESTATEATTRS */
void rx_getremotestateattrs( struct RexxHost *host, struct rxd_getremotestateattrs **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_getremotestateattrs *rd = *rxd;
	static LONG lMode, lFpen, lBpen, lFred, lFgreen,
	            lFblue, lBred, lBgreen, lBblue;
	UWORD uwThisColor;
	static char szTempRemoteString[256];
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			/* Insert your CODE here */
			
			if (BNetConnect == TRUE)
			{
				lMode     = PState.uwRemoteMode;
				lFpen     = PState.uwRemoteFColor;
				lBpen	  = PState.uwRemoteBColor;
	
				/* Extract R, G, B for FColor from return value */
				uwThisColor = RGBComponents(lFpen);
				lFblue  = (uwThisColor      & 0x000F); /* Right 4 bits */
				lFgreen = ((uwThisColor>>4) & 0x000F); /* 2nd 4 bits from right */
				lFred   = ((uwThisColor>>8) & 0x000F); /* 3rd 4 bits from right */
	
				/* Extract R, G, B for BColor from return value */
				uwThisColor = RGBComponents(lBpen);
				lBblue  = (uwThisColor      & 0x000F); /* Right 4 bits */
				lBgreen = ((uwThisColor>>4) & 0x000F); /* 2nd 4 bits from right */
				lBred   = ((uwThisColor>>8) & 0x000F); /* 3rd 4 bits from right */
			}
			else
			{
				lMode   = -1L;
				lFpen   = -1L;
				lBpen   = -1L;
				lFblue  = -1L;
				lFgreen = -1L;
				lFred   = -1L;
				lBblue  = -1L;
				lBgreen = -1L;
				lBred   = -1L;
			}
			
			strncpy(szTempRemoteString,szReceiveString,sizeof(szTempRemoteString));
			rd->res.mode    = &lMode;
			rd->res.fpen    = &lFpen;
			rd->res.bpen    = &lBpen;
			rd->res.fred    = &lFred;
			rd->res.fgreen  = &lFgreen;
			rd->res.fblue   = &lFblue;
			rd->res.bred    = &lBred;
			rd->res.bgreen  = &lBgreen;
			rd->res.bblue   = &lBblue;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );

			/* Reset szReceiveString so as not to send this out again */
			szReceiveString[0] = '\0';
			break;
	}
	return;
}
/* $ARB: E 33 GETREMOTESTATEATTRS */

/* $ARB: B 34 SETWINDOWTITLE */
void rx_setwindowtitle( struct RexxHost *host, struct rxd_setwindowtitle **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setwindowtitle *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			SetWindowTitle(rd->arg.message);
			rd->rc = 1;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 34 SETWINDOWTITLE */

/* $ARB: B 35 SETREMOTEWINDOWTITLE */
void rx_setremotewindowtitle( struct RexxHost *host, struct rxd_setremotewindowtitle **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setremotewindowtitle *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if (BNetConnect == FALSE)
				rd->rc = 0;
			else
			{
				strncpy(szSendString,rd->arg.message, sizeof(szSendString));
				OutputAction(FROM_REXX, COMMAND, COMMAND_SENDSTRING, STRING_SETWINTITLE, NOP_PAD, NOP_PAD, DEST_PEER);
				rd->rc = 1;
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 35 SETREMOTEWINDOWTITLE */

/* $ARB: B 36 REMOTEEASYREQUEST */
void rx_remoteeasyrequest( struct RexxHost *host, struct rxd_remoteeasyrequest **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_remoteeasyrequest *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((BNetConnect == FALSE) || ((strlen(rd->arg.title)+strlen(rd->arg.message)+strlen(rd->arg.gadgets)) > 250))
				rd->rc = 0;
			else
			{
				rd->rc = 1;
	  		        sprintf(szSendString,"%sÈ%sÈ%s", rd->arg.title, rd->arg.message, rd->arg.gadgets);
				OutputAction(FROM_REXX, COMMAND, COMMAND_SENDSTRING, STRING_EASYREQ, NOP_PAD, NOP_PAD, DEST_PEER);
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 36 REMOTEEASYREQUEST */

/* $ARB: B 38 SENDMESSAGE */
void rx_sendmessage( struct RexxHost *host, struct rxd_sendmessage **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_sendmessage *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if (BNetConnect == FALSE) 
				rd->rc = 0;
			else
			{
				strncpy(szSendString, rd->arg.message, sizeof(szSendString));
				OutputAction(FROM_REXX, COMMAND, COMMAND_SENDSTRING, STRING_USER, NOP_PAD, NOP_PAD, DEST_PEER);
				rd->rc = 1;
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 38 SENDMESSAGE */

/* $ARB: B 39 WAITEVENT */
void rx_waitevent( struct RexxHost *host, struct rxd_waitevent **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_waitevent *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			PState.uwRexxWaitMask = 0;
			if (rd->arg.message)     PState.uwRexxWaitMask |= REXX_REPLY_MESSAGE;
			if (rd->arg.mousedown)   PState.uwRexxWaitMask |= REXX_REPLY_MOUSEDOWN;
			if (rd->arg.mouseup)     PState.uwRexxWaitMask |= REXX_REPLY_MOUSEUP;
			if (rd->arg.resize)      PState.uwRexxWaitMask |= REXX_REPLY_RESIZE;
			if (rd->arg.quit)        PState.uwRexxWaitMask |= REXX_REPLY_QUIT;
			if (rd->arg.connect)     PState.uwRexxWaitMask |= REXX_REPLY_CONNECT;
			if (rd->arg.disconnect)  PState.uwRexxWaitMask |= REXX_REPLY_DISCONNECT;
			if (rd->arg.toolselect)  PState.uwRexxWaitMask |= REXX_REPLY_TOOLSELECT;
			if (rd->arg.colorselect) PState.uwRexxWaitMask |= REXX_REPLY_COLORSELECT;
			if (rd->arg.keypress)    PState.uwRexxWaitMask |= REXX_REPLY_KEYPRESS;
			if (rd->arg.mousemove)   PState.uwRexxWaitMask |= REXX_REPLY_MOUSEMOVE;
			if (rd->arg.timeout != NULL)
			{	
				if (*rd->arg.timeout > 0)
				{			
					/* First make sure there is no previous timer pending */
					if (!(CheckIO((struct IORequest *) TimerIO)))
					{
						AbortIO((struct IORequest *) TimerIO);
						WaitIO((struct IORequest *) TimerIO);
					}	
					TimerIO->tr_time.tv_secs = *rd->arg.timeout/10;
					*rd->arg.timeout -= TimerIO->tr_time.tv_secs*10;
					
					TimerIO->tr_time.tv_micro = (*rd->arg.timeout)*100000L;   /* There are 1,000,000 micros/sec, so 100,000 is 1/10th of a sec */
	
					/* Start ze timer */
					SendIO((struct IORequest *)TimerIO);
				
					PState.uwRexxWaitMask |= REXX_REPLY_TIMEOUT;
				}
				else
				{
					/* Reply this request immediately! */
					PState.uwRexxWaitMask |= REXX_REPLY_IMMEDIATE;
				}
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 39 WAITEVENT */

/* $ARB: B 40 REMOTESTRINGREQUEST */
void rx_remotestringrequest( struct RexxHost *host, struct rxd_remotestringrequest **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_remotestringrequest *rd = *rxd;
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((BNetConnect == FALSE) || ((strlen(rd->arg.title)+strlen(rd->arg.message)+strlen(rd->arg.defaultstring)) > 250))
			rd->rc = 0;
			else
			{
				rd->rc = 1;
			    	sprintf(szSendString,"%sÈ%sÈ%s", rd->arg.title, rd->arg.defaultstring, rd->arg.message);
				OutputAction(FROM_REXX, COMMAND, COMMAND_SENDSTRING, STRING_STRINGREQ, NOP_PAD, NOP_PAD, DEST_PEER);
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 40 REMOTESTRINGREQUEST */

/* $ARB: B 41 SETUSERFCOLOR */
void rx_setuserfcolor( struct RexxHost *host, struct rxd_setuserfcolor **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setuserfcolor *rd = *rxd;
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = 1;
			rd->rc2 = MatchPalette(*rd->arg.red,
		                              *rd->arg.green,
		                              *rd->arg.blue,
		                              (rd->arg.notbackground != FALSE),NULL, NULL);
			HandleToolBox(rd->rc2 + 100);
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 41 SETUSERFCOLOR */

/* $ARB: B 42 SETUSERBCOLOR */
void rx_setuserbcolor( struct RexxHost *host, struct rxd_setuserbcolor **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setuserbcolor *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = PState.uwBColor;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 42 SETUSERBCOLOR */

/* $ARB: B 43 REMOTEREXXCOMMAND */
void rx_remoterexxcommand( struct RexxHost *host, struct rxd_remoterexxcommand **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_remoterexxcommand *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((BNetConnect == FALSE) || ((strlen(rd->arg.message)+strlen(rd->arg.file)) > 250))
				rd->rc = 0;
			else
			{
				rd->rc = 1;
	  		        sprintf(szSendString,"%sÈ%s", rd->arg.message, rd->arg.file);
				OutputAction(FROM_REXX, COMMAND, COMMAND_SENDSTRING, STRING_REXXCOMMAND, NOP_PAD, NOP_PAD, DEST_PEER);
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 43 REMOTEREXXCOMMAND */

/* $ARB: B 44 SETUSERFPEN */
void rx_setuserfpen( struct RexxHost *host, struct rxd_setuserfpen **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setuserfpen *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if ((*rd->arg.pen >= 0)&&(*rd->arg.pen < (1<<PState.ubDepth)))
			{
				HandleToolBox(*rd->arg.pen + 100);
				rd->rc = 1;
			}
			else
				rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 44 SETUSERFPEN */

/* $ARB: B 45 SETUSERBPEN */
void rx_setuserbpen( struct RexxHost *host, struct rxd_setuserbpen **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setuserbpen *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 45 SETUSERBPEN */

/* $ARB: B 46 SETUSERTOOL */
void rx_setusertool( struct RexxHost *host, struct rxd_setusertool **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setusertool *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if (((*rd->arg.tool >= 0)&&(*rd->arg.tool <= 6)) ||
			    ((*rd->arg.tool == 13)||(*rd->arg.tool == 14)))
			{
				rd->rc = 1;
				HandleToolBox(*rd->arg.tool);
			}
			else
				rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 46 SETUSERTOOL */

/* $ARB: B 47 SETTOOLBEHAVIOR */
void rx_settoolbehavior( struct RexxHost *host, struct rxd_settoolbehavior **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_settoolbehavior *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 47 SETTOOLBEHAVIOR */

/* $ARB: B 48 GETVERSION */
void rx_getversion( struct RexxHost *host, struct rxd_getversion **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_getversion *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->res.version = szVersionString+5;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 48 GETVERSION */

/* $ARB: B 51 DISPLAYBEEP */
void rx_displaybeep( struct RexxHost *host, struct rxd_displaybeep **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_displaybeep *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			
			/* Default is local only */
			if ((rd->arg.local == 0)&&(rd->arg.remote == 0)) rd->arg.local = 1;
			
			if (rd->arg.remote != 0)
				OutputAction(FROM_REXX, COMMAND, COMMAND_BEEP, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER);

			if (rd->arg.local != 0) DisplayBeep(Scr);
			
			rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 51 DISPLAYBEEP */

/* $ARB: B 53 GETPIXEL */
void rx_getpixel( struct RexxHost *host, struct rxd_getpixel **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_getpixel *rd = *rxd;
	int x,y;
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			x = *rd->arg.x;
			y = *rd->arg.y;
			FixCoords(&x, &y);
			if (FixPos(&x, &y) == TRUE)
			{
				rd->rc2 = ReadPixel(DrawWindow->RPort, x, y);
				rd->rc = 1;
			}
			else
			{
				rd->rc = 0;
				rd->rc2 = -1;
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 53 GETPIXEL */

/* $ARB: B 54 BREAKAREXXSCRIPTS */
void rx_breakarexxscripts( struct RexxHost *host, struct rxd_breakarexxscripts **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_breakarexxscripts *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			BreakRexxScripts();		
			rd->rc = 1;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 54 BREAKAREXXSCRIPTS */

/* $ARB: B 55 SETRASTER */
void rx_setraster( struct RexxHost *host, struct rxd_setraster **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_setraster *rd = *rxd;
	int x,y;
	
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			x = *rd->arg.x;
			y = *rd->arg.y;
			FixCoords(&x, &y);
			PState.RexxRaster.nRX 	    	    = x;
			PState.RexxRaster.nRY 	    	    = y;
			PState.RexxRaster.nRWidth 	    = *rd->arg.width;
			PState.RexxRaster.nRHeight 	    = *rd->arg.height;
			PState.RexxRaster.nRCurrentOffset   = *rd->arg.offset;
			
			/* See if raster is entirely on screen */
			rd->rc = FixPos(&x, &y);
			
			/* check lower right corner */
			x = PState.RexxRaster.nRX + *rd->arg.width - 1;
			y = PState.RexxRaster.nRY + *rd->arg.height - 1;
			rd->rc &= FixPos(&x, &y);			
				
			/* We'll have to hack the OutputAction command to automatically use RexxRaster info */
			OutputAction(FROM_REXX, COMMAND, COMMAND_SETRASTER, NOP_PAD, NOP_PAD, NOP_PAD, DEST_PEER|DEST_FILE);
			break;
			
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 55 SETRASTER */

/* $ARB: B 57 PUTRASTERPIXELS */
void rx_putrasterpixels( struct RexxHost *host, struct rxd_putrasterpixels **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_putrasterpixels *rd = *rxd;
	UWORD uwColorCode;
	int nTempColor;
		
	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			if (rd->arg.pen == NULL)
			{
				/* no pen?  Then just use the RGB values */
				if ((rd->arg.red != NULL)&&(rd->arg.green != NULL)&&(rd->arg.blue != NULL))
					uwColorCode = (*rd->arg.red << 8) | (*rd->arg.green << 4) | (*rd->arg.blue);
				else
					/* no RGB values?  Use current rexx foreground color */
					uwColorCode = RGBComponents(PState.uwRexxFColor);
			}
			else
			uwColorCode = RGBComponents(*rd->arg.pen);

			if (PState.RexxRaster.nRX >= 0)
			{
				nTempColor = (int) PState.uwRexxFColor;
				DrawRasterChunk((UWORD)*rd->arg.length, uwColorCode, &PState.RexxRaster, &nTempColor);
				PState.uwRexxFColor = nTempColor;
				rd->rc = 1;
			}
			else rd->rc = 0;
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 57 PUTRASTERPIXELS */

/* $ARB: B 58 LOADIFF */
void rx_loadiff( struct RexxHost *host, struct rxd_loadiff **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_loadiff *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = 0;
			BRexxExpand       = (rd->arg.expand 	 != NULL);
			BRexxProtectInter = (rd->arg.protectgui  != NULL);
			BRexxLoadPalette  = (rd->arg.loadpalette != NULL);

			if ((rd->arg.file != NULL)&&(LoadUserIFFNamed(FROM_REXX,rd->arg.file) == TRUE))
			{
				if (BIFFLoadPending == TRUE)
				{			
					/* hold off reply until we hear back */
					PState.uwRexxWaitMask |= REXX_REPLY_IFFLOAD;
				}
			}	
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 58 LOADIFF */

/* $ARB: B 59 SAVEIFF */
void rx_saveiff( struct RexxHost *host, struct rxd_saveiff **rxd, long action, struct RexxMsg *rexxmsg )
{
	struct rxd_saveiff *rd = *rxd;

	switch( action )
	{
		case RXIF_INIT:
			*rxd = AllocVec( sizeof *rd, MEMF_CLEAR );
			if( rd = *rxd )
			{
				/* set your DEFAULTS here */
			}
			break;
			
		case RXIF_ACTION:
			/* Insert your CODE here */
			rd->rc = 0;
			if (rd->arg.file != NULL)
			{
				rd->rc = SaveUserIFFNamed(rd->arg.file);
			}
			break;
		
		case RXIF_FREE:
			/* FREE your local data here */
			FreeVec( rd );
			break;
	}
	return;
}
/* $ARB: E 59 SAVEIFF */


#ifndef RX_ALIAS_C
char *ExpandRXCommand( struct RexxHost *host, char *command )
{
	/* Insert your ALIAS-HANDLER here */
	return( NULL );
}
#endif

