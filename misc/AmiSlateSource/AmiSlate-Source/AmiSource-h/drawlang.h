/* DrawLang.h -- This file contains the drawing commands for the transmission
   language. */

#ifdef DEBUG
#define Printf printf
#endif

#ifndef DEBUG
#define Printf printf
#endif



#define SEND_EMPTY       0xF0F7 /* No words ready in incoming buffer */
#define SEND_ERROR       0xF0F8 /* Socket disconnected ?  */
#define COMMAND_QUIT     0xF0F9 /* Quit----------No parameters */
#define NOTSENDABLE      0xF0FA /* Guaranteed never to be transmitted */
#define CONTROL1         0xF0FB /* Meaning specific to operation */
#define NOP_PAD          0xF0FC /* Does nothing... used as padding */
#define COMMAND          0xF0FD /* Means next word is command word... */
#define STOP_STRING      0xF0FE /* Used to terminate strings */
#define MODE_CHANGE      0xF0FF /* Means next word is Mode change word... */

/* MODE_CHANGE followed by any of these makes a mode change command. */
#define MODE_FIRST       0x0000 /* Range Start marker */
#define MODE_DOT         0x0001 /* Two words: x,y */
#define MODE_PEN         0x0002 /* Stream of words x,y,x,y,... until STOP_STRING */
#define MODE_LINE        0x0003 /* Two words: x,y */
#define MODE_CIRCLE      0x0004 /* Three words: x,y,r */
#define MODE_SQUARE      0x0005 /* Four words: x1,y1,x2,y2 */
#define MODE_POLY        0x0006 /* Stream of words x,y,x,y,... until STOP_STRING */
#define MODE_FLOOD       0x0007 /* Two words: x,y */
#define MODE_DTEXT       0x0008 /* Stream of single words, each represents a char  */
#define MODE_RASTER	 0x0009 /* Two words:  color, length */
#define MODE_LAST        0x000A /* Range End marker */
#define MODE_INVALID     0x000B /* Used to force mode change */
#define MODE_FILLED      0x0100 /* OR this in with the above MODES_  */
#define MODE_XOR         0x0200 /* OR this in with the above MODES_  */

/* The following modes are used only by the input parsing mechanism */
#define MODE_MODE        0x000C	 /* = awaiting MODE code */
#define MODE_COMMAND     0x000D  /* = awaiting COMMAND code */
#define MODEC_SIZE       0x000E  /* = awaiting window size values */
#define MODEC_RGB	 0x000F  /* = awaiting RGB values */
#define MODEC_SYNCH      0x0010  /* = awaiting state/setup value(s) */
#define MODEC_SETCOLOR   0x0011  /* = awaiting color information */
#define MODEC_SENDSTRING 0x0012  /* = awaiting NULL-terminated string */
#define MODEC_SETRASTER	 0x0013  /* = awaiting bounding information */
#define FILE_END         0x0014  /* = end of input file */

/* COMMAND followed by any of these makes a command */
#define COMMAND_CLEAR       0x0015  /* Clear Screen--No parameters */
#define COMMAND_RGB         0x0016  /* Change color--Six words  rf, gf, bf, tb,gb, bb */
#define COMMAND_SIZE        0x0017  /* Change size---Two words: x, y */
#define COMMAND_LOCK	    0x0018  /* Disallow drawing */
#define COMMAND_UNLOCK      0x0019  /* Allow drawing */
#define COMMAND_SYNCH       0x001A  /* (Re)transmit state information */
#define COMMAND_SETCOLOR    0x001B  /* Set a color register to this color */
#define COMMAND_SENDPALETTE 0x001C  /* Request a transmit of palette information */
#define COMMAND_HELLO       0x001D  /* Recognize caller */
#define COMMAND_SENDSTRING  0x001E  /* Send szSendString */
#define COMMAND_SIZELOCK    0x001F  /* Puts receiver in "sizeme", passive state until resize command */
#define COMMAND_SIZEUNLOCK  0x0020  /* Undos the SIZELOCK command.  */
#define COMMAND_SIZEOK	    0x0021  /* Gives the go-ahead for a resize */
#define COMMAND_BEEP	    0x0022  /* Flashes the display--no parameters */
#define COMMAND_SETRASTER   0x0023  /* Sets up Raster window on remote display */
#define COMMAND_SENDSCREEN  0x0024  /* Requests full-screen transmission */
#define COMMAND_CLEARMAP    0x0025  /* Requests remote pen map to be cleared */

/* Flags to tell ReceiveString where to send the string */
#define STRING_USER		0x0026  /* Store for/send to user's ARexx program */
#define STRING_EASYREQ		0x0027  /* Send to EasyReqFromRemote */
#define STRING_EASYREQREP	0x0028  /* Reply of EasyReqFromRemote */
#define STRING_STRINGREQ	0x0029	/* Send to StringReqFromRemote */
#define STRING_STRINGREQREP	0x002A  /* Reply of StringReqFromRemote */
#define STRING_SETWINTITLE  	0x002B  /* Send to SetWindowTitle */
#define STRING_REXXCOMMAND      0x002C  /* Attempt to start a Rexx script */

/* Flag to tell OutputAction what context to use */
#define FROM_REXX           0x01  /* Send Rexx graphics */
#define FROM_IDCMP          0x02  /* Send User graphics */
#define FROM_REMOTE	    0x03  /* Saving Remote actions to local script */

