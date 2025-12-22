/*
	$VER: F_TPG 1.00 (2004/12/18) by Olivier LAVIALE (gofromiel@gofromiel.com)
	__________________________________________________________________________

	This little tool is very useful to quickly test the look of a preference
	group.  Instead  of  launching  the  preference  editor,  the  requested
	preference group is created in a simple window. Since preference  groups
	are defined in libraries, name is case-sensitive.

*/

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/feelin.h>
#include <proto/feelinclass.h>

#include <libraries/feelin.h>

struct FeelinBase *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace *IFeelin;
#endif

int main()
{
	if (F_FEELIN_OPEN)
	{
		int32 args[] = { (int32) "Area", 0 };
		APTR rdargs;

		if ((rdargs = IDOS_ ReadArgs("CLASS/A",args,NULL)) != NULL)
		{
			STRPTR name = IFEELIN F_StrNew(NULL,"LIBS:Feelin/%s.fc",args[0]);

			if (name)
			{
				struct Library *FeelinClassBase = IEXEC OpenLibrary(name,0);
				
				if (FeelinClassBase)
				{
					struct TagItem *tags = IFEELIN F_Query(FV_Query_PrefsTags, FeelinBase);

					if (tags)
					{
						FClass *cc = IFEELIN F_CreateClassA(NULL, tags);

						if (cc)
						{
							STRPTR win_name = IFEELIN F_StrNew(NULL,"PreferenceGroup : %s",args[0]);

							if (win_name)
							{
								FObject app,win,grp;

								app = AppObject,
									Child, win = WindowObject,
										FA_Window_Title,  win_name,
										FA_Window_Open,   TRUE,
										FA_Window_Width, "60%",
										FA_Window_Height, "40%",

										Child, grp = IFEELIN F_NewObj(cc->Name, TAG_DONE),
									End,
								End;

								if (app)
								{
									FObject prefs = (FObject) IFEELIN F_Get(app,FA_Application_Preference);
									
									if (prefs)
									{
										IFEELIN F_Do(grp, (uint32) "FM_PreferenceGroup_Load", prefs, IFEELIN F_DynamicFindID("FM_CSSDocument_GetProperty"));
									}
	 
									IFEELIN F_Do(win,FM_Notify,FA_Window_CloseRequest,TRUE,app,FM_Application_Shutdown,0);
									IFEELIN F_Do(app,FM_Application_Run);
									IFEELIN F_DisposeObj(app);
								}

								IFEELIN F_Dispose(win_name);
							}
							
							IFEELIN F_DeleteClass(cc);
						}
					}
					else
					{
						IDOS_ Printf("\"%s\" doesn't feature a preference editor\n", args[0]);
					}
					
					CloseLibrary(FeelinClassBase);
				}
				else
				{
					IDOS_ Printf("Unable to open %s\n", (int32) name);
				}

				IFEELIN F_Dispose(name);
			}

			IDOS_ FreeArgs(rdargs);
		}
		else
		{
			IDOS_ PrintFault(IDOS_ IoErr(),NULL);
		}

		F_FEELIN_CLOSE;
	}
	else
	{
		IDOS_ Printf("Unable to open %s %ld\n", (int32) "feelin.library", FV_FEELIN_VERSION);
	}

	return 0;
}
