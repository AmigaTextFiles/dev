struct ProducerNode
{
	struct MinList     WindowList;
	struct MinList     MenuList;
	struct MinList     ImageList;
	struct MinList     ScreenList;
	
	struct MinList     LocaleList;
	long               LocaleCount;
	char             * BaseName;
	char             * GetString;
	char             * BuiltInLanguage;
	long               LocaleVersion;
	
	UBYTE             ProcedureOptions[50];
	UBYTE             CodeOptions[20];
	UBYTE             OpenLibs[30];
	long              VersionLibs[30];
	UBYTE             AbortOnFailLibs[30];
	char            * pn_Includes;
	
	
	char              IncludeExtra[256];
	long              FileVersion;

#ifdef INTERNAL
	long WriteAllMain;
	long WriteNoMain;
	struct Window *Win;
	struct Gadget *WinGList;
	struct Gadget *WinGadgets[10];
	struct DrawInfo *WinDrawInfo;
	APTR   WinVisualInfo;
	long   MemCount;
	char   basenamestr[75];
	char   builtinlang[75];
	long   localeversion;
	char   getstringstr[75]; 
#ifdef DEBUG
	BPTR debug;
#endif  
#endif
};

