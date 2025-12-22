/*
 * TextField autoinit and autoterminate functions
 * for SAS/C 6.50 and up.
 *
 * If you just compile and link this into your application
 * then TextFieldBase and TextFieldClass will be
 * automatically initialized before main() is called.
 *
 * Your application will only need to use TextFieldClass
 * when calling NewObject() and include <proto/textfield.h>.
 *
 * This file uses the TEXTFIELD_NAME and TEXTFIELD_VER
 * defines from textfield.h.
 *
 * If the library fails to open, a warning is printed.
 */

#include <string.h>

#include <gadgets/textfield.h>

#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/textfield.h>

static void __regargs __tfopenfail(char *);

extern struct WBStartup *_WBenchMsg;
extern char __stdiowin[];

struct Library *TextFieldBase;
Class *TextFieldClass;

int _STI_200_TextFieldInit(void)
{
	TextFieldBase = OpenLibrary(TEXTFIELD_NAME, TEXTFIELD_VER);
	if (TextFieldBase == NULL)
	{
		__tfopenfail("textfield.gadget");
		return 1;
	}
	else
	{
		TextFieldClass = TEXTFIELD_GetClass();
		return 0;
	}
}

void _STD_200_TextFieldTerm(void)
{
	CloseLibrary(TextFieldBase);
	TextFieldClass = NULL;
	TextFieldBase = NULL;
}

// Modified from SAS/C's __autoopenfail()

static void __regargs __tfopenfail(char *lib)
{
	struct DOSBase *DOSBase;
	long fh;
   
	DOSBase = (struct DOSBase *)OpenLibrary("dos.library", 0);
	if (_WBenchMsg == NULL)
		fh = Output();
	else
		fh = Open(__stdiowin, MODE_NEWFILE);

	if (fh)
	{
		char buf[50];
		unsigned long libversion = TEXTFIELD_VER;
		RawDoFmt("Can't open version %ld of ",
			&libversion, (void (*))"\x16\xC0\x4E\x75", buf);
   
		Write(fh, buf, strlen(buf));
		Write(fh, lib, strlen(lib));
		Write(fh, ".\n", 2);
   
		if (_WBenchMsg)
		{
			Delay(200);
			Close(fh);
		}
	}   

	CloseLibrary((struct Library *)DOSBase);
	((struct Process *)FindTask(NULL))->pr_Result2 = 
				ERROR_INVALID_RESIDENT_LIBRARY;
}
