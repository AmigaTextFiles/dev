// Wangi library... The C part of WangiPad...
// Lee Kindess 1995
// For SAS/C 5.5x
//
// ***********************************************************************

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>

#include <exec/types.h>
#include <intuition/intuition.h>

// ***********************************************************************

LONG b = 0;

struct EasyStruct ez = {
	sizeof (struct EasyStruct),
	0,
	"Wangi Library",
	"The function \"%s\" has been called from wangi.library.\n"
	"The value of a is: %ld\n"
	"The value of b is: %ld\n",
	"Ok",
};


// ***********************************************************************

LONG __asm __saveds __UserLibInit(register __a6 struct MyLibrary *libbase)
{
	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",37L);
	DOSBase       = (struct DosLibrary *)OpenLibrary("dos.library",37L);
	if (IntuitionBase && DOSBase) {
		EasyRequest(NULL, &ez, NULL, "Init", -99L, b);
		return(0L); // Continue...
		}
	else
		return(1L); // Fail...
}

// ***********************************************************************

void __saveds __asm __UserLibCleanup(register __a6 struct MyLibrary *libbase)
{
	EasyRequest(NULL, &ez, NULL, "Cleanup", -99L, b);
	if (IntuitionBase)
		CloseLibrary(( struct Library *)IntuitionBase);
	if (DOSBase)
		CloseLibrary(( struct Library *)DOSBase);
}

// ***********************************************************************

LONG __asm __saveds LIBwangi1(void)
{
	// DisplayBeep(NULL);
	EasyRequest(NULL, &ez, NULL, "Wangi1", -99L, b);
	// DisplayBeep(NULL);
	return(b);  
}

// ***********************************************************************

LONG __asm __saveds LIBwangi2(register __d1 LONG a)
{
	b = a;
	EasyRequest(NULL, &ez, NULL, "Wangi2", a, b);
	return(b);
}

// ***********************************************************************

LONG __asm __saveds LIBwangi3(register __d1 LONG a)
{
	b += a;
	EasyRequest(NULL, &ez, NULL, "Wangi3", a, b);
	return(b);
}

// ***********************************************************************

