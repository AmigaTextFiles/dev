#ifndef _TEXTBOX_H_
#define _TEXTBOX_H_

/* TestBox.h
 *
 * Headerfile for function to show a message to the user.
 * Using MsgBox() on Windoof systems.
 * Using EasyRequest()or AutoRequest()  on Amiga systems.
 */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifdef _AMIGA

#ifndef EXEC_ALERTS_H
#include <exec/Alerts.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#endif		/* _AMIGA */

/* --- Defines  ------------------------------------------------------------- */

/* error type specifier */
#define MSG_INFO	0x0000	/* only informs the user about the state of the application */
#define MSG_WARN	0x0001	/* Warns the user, that the system has a problem */
#define MSG_ASK	0x0002	/* Ask the user to make a decision (no problem) */
#define MSG_STOP	0x0003	/* serious system-related problem, application will terminate */

/* Bitmask to mask out the type-specifier */
#define MSF_TYPE	0x000F	/* NOTE: the values 0x0004 - 0x000F are reserved for future use */

/* Button type specifier */
#define MSG_OK					0x0000	/* default */
#define MSG_ABORT				0x0010	/* single "Abort"-button is not supported by Windoof,
												 * Windoof will display a single "Ok"-button */
#define MSG_OKCANCEL				0x0020	/* "Ok" and "Cancel" buttons */
#define MSG_RETRYCANCEL			0x0030	/* "Retry" and "Cancel" buttons */
#define MSG_YESNO					0x0040	/* "Yes" and "No"-buttons */
#define MSG_YESNOCANCEL			0x0050	/* "Yes", "No", and "Cancel"-buttons */
#define MSG_ABORTRETRYIGNORE	0x0060	/* "Abort", "Retry", and "Ignore"-buttons */

/* Bitmask to mask out the button-specifier */
#define MSF_BUTTONS 0x00F0	/* NOTE: the values 0x0070 - 0x00F0 are reserved for future use */

/* The flags 0x0100 to 0x8000 are not defined */

#endif			/* _TEXTBOX_H_ */
