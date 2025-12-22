#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/feelin.h>

#include <workbench/startup.h>
#include <libraries/feelin.h>
#include <feelin/xmlapplication.h>

#ifdef __amigaos4__
#define WBENCHMSG	WBenchMsg
#include <dos.h>
struct FeelinIFace *IFeelin;
#else
#define WBENCHMSG	_WBenchMsg
#endif
				 
struct FeelinBase *FeelinBase;
extern struct WBStartup *_WBenchMsg;

int main()
{
	if (F_FEELIN_OPEN)
	{
		STRPTR file;
   
		if (WBENCHMSG)
		{
			uint32 narg = WBENCHMSG -> sm_NumArgs;
			struct WBArg *arg = WBENCHMSG -> sm_ArgList;

			//IFEELIN F_Log(0,"WB 0x%08lx - Num %ld - List 0x%08lx",_WBenchMsg,narg,arg);

			if ((file = IFEELIN F_New(1024)) != NULL)
			{
				while (narg--)
				{
					IDOS_ NameFromLock(arg -> wa_Lock,file,1023);
					IDOS_ AddPart(file,arg -> wa_Name,1023);

					//IFEELIN F_Log(0,"WB (%s)(0x%08lx)",buf,arg -> wa_Lock);

					arg++;
				}
			}
		}
		else
		{
			uint32 args[] = { (uint32)("Hello.xml"), 0};
			APTR rdargs = IDOS_ ReadArgs("SRC=SOURCE",(int32 *)(&args),NULL);
		  
			if (rdargs)
			{
				IDOS_ FreeArgs(rdargs);
			}
			else
			{
				IDOS_ Printf("This program builds applications from XML sources. By default, it builds an application from 'Hello.xml' but you can supply any XML source.\n");
			}
		 
			file = IFEELIN F_StrNew(NULL,"%s",*args);
		}
		

		if (file)
		{
			FObject xapp = XMLApplicationObject,

				"Source", file,
				"SourceType", FV_Document_SourceType_File,

				End;
				
			if (xapp)
			{
			   IFEELIN F_Do(xapp,(uint32) "Run");
			   IFEELIN F_DisposeObj(xapp);
			}
		 
			IFEELIN F_Dispose(file);
		}
		
		F_FEELIN_CLOSE;
	}

	return 0;
}
 
