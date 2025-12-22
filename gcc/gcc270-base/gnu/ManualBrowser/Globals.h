/************************************************************************/
/*									*/
/*  Copyright (C) 1994  Christian Stieber				*/
/*									*/
/* This program is free software; you can redistribute it and/or modify	*/
/* it under the terms of the GNU General Public License as published by	*/
/* the Free Software Foundation; either version 2 of the License, or	*/
/* (at your option) any later version.					*/
/*									*/
/* This program is distributed in the hope that it will be useful,	*/
/* but WITHOUT ANY WARRANTY; without even the implied warranty of	*/
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	*/
/* GNU General Public License for more details.				*/
/*									*/
/* You should have received a copy of the GNU General Public License	*/
/* along with this program; if not, write to the Free Software		*/
/* Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.		*/
/*									*/
/************************************************************************/
/*									*/
/* Author address:							*/
/*   Christian Stieber							*/
/*   Konradstraﬂe 41							*/
/*   D-85055 Ingolstadt							*/
/*   (Germany)								*/
/*   Phone: 0841-59896							*/
/*									*/
/************************************************************************/

#define PROGVERSION	"1.1"
#define PROGDATE	"11.11.94"

/************************************************************************/

#if defined(mc68060)
   #define CPU "68060"
#elif defined(mc68040)
   #define CPU "68040"
#elif defined(mc68030)
   #define CPU "68030"
#elif defined(mc68020)
   #define CPU "68020"
#elif defined(mc68000)
   #define CPU "68000"
#endif

/************************************************************************/

struct ActionNode
   {
      struct ActionNode *Next;
      char *Pattern;
      char Action[3];   /* '\0' for Action, char[2] for Pattern */
   };

/************************************************************************/

extern struct ExecBase *SysBase;

extern struct DosLibrary *DOSBase;
extern struct IntuitionBase *IntuitionBase;
extern struct Library *AmigaGuideBase;
extern struct Library *UtilityBase;

/************************************************************************/

extern struct ActionNode *ActionList;
extern BPTR ManDir;
extern long LineLength;
extern char DatabaseName[64];

/************************************************************************/

#ifdef __GNUC__
ULONG AmigaGuideHostDispatcher(Msg);
#else
ULONG __saveds __asm AmigaGuideHostDispatcher(register __a1 Msg);
#endif

/************************************************************************/

void exit(int);
char *Sprintf(char *, char *, ...);

#ifdef __GNUC__
ULONG HookEntryA1(Msg);
#endif

/************************************************************************/

void *Malloc(ULONG);
void Free(void *);

int ReadConfigFile(BPTR ConfigFile, struct ActionNode **ActionList);

/************************************************************************/

#ifdef __GNUC__

static __inline char *Stpcpy(char *Dest, char *Source)

{
   while ((*Dest=*Source))
      {
         Dest++;
         Source++;
      }
   return Dest;
}

#else

#define Stpcpy(a,b) stpcpy(a,b)

#endif
