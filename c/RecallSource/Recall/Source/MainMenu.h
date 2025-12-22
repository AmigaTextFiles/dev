/*
 *	File:					Menus.h
 *	Description:	Global menus
 *
 *	(C) 1994,1995, Ketil Hunn
 *
 */

#ifndef MENUS_H
#define MENUS_H

/*** DEFINES *************************************************************************/
#define	LOADERBASE					1000
#define	SAVERBASE						1500
#define	OPERATORBASE				2000
#define	DISPLAYERBASE				2500

#define	LOADERSDIR					"Loaders"
#define	SAVERSDIR						"Savers"
#define	OPERATORSDIR				"Operators"
#define	DISPLAYERSDIR				"Displayers"

/*** GLOBALS *************************************************************************/
extern struct Menu	*mainMenu;
extern struct List	*loaders, *savers, *displayers, *operators;

/*** PROTOTYPES **********************************************************************/
__stackext struct List *GetModules(STRPTR dir);
BYTE AllocMainMenu(void);
void FreeMainMenu(void);
void UpdateMainMenu(void);
void HandleMainMenu(struct egTask *task, UWORD menuNumber);
void UpdateMacroMenu(void);
void ShowHelp(UBYTE *topic);
void OpenCommandShell(void);

void Quit(void);

#endif
