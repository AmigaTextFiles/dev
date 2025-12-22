#ifndef DEVICES_GAMEPORT_H
#define DEVICES_GAMEPORT_H

#ifndef	EXEC_TYPES_H
MODULE 	'exec/types'
#endif
#ifndef	EXEC_IO_H
MODULE 	'exec/io'
#endif

#define	 GPD_READEVENT	   (CMD_NONSTD+0)
#define	 GPD_ASKCTYPE	   (CMD_NONSTD+1)
#define	 GPD_SETCTYPE	   (CMD_NONSTD+2)
#define	 GPD_ASKTRIGGER	   (CMD_NONSTD+3)
#define	 GPD_SETTRIGGER	   (CMD_NONSTD+4)


#define	 GPTB_DOWNKEYS	   0
#define	 GPTF_DOWNKEYS	   (1<<0)
#define	 GPTB_UPKEYS	   1
#define	 GPTF_UPKEYS	   (1<<1)
OBJECT GamePortTrigger
 
   Keys:UWORD	   
   Timeout:UWORD	   
   XDelta:UWORD	   
   YDelta:UWORD	   
ENDOBJECT


#define	 GPCT_ALLOCATED	   -1	 
#define	 GPCT_NOCONTROLLER 0
#define	 GPCT_MOUSE	   1
#define	 GPCT_RELJOYSTICK  2
#define	 GPCT_ABSJOYSTICK  3

#define	 GPDERR_SETCTYPE   1	 
#endif	
