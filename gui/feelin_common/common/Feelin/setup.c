/*
	Feelin installer

	2000-2005 © Olivier LAVIALE <gofromiel@gofromiel.com>

*************************************************************************************************

$VER: (01.10) 2006/12/10

	The assignation path is now enclosed with quotes, allowing spaces in the
	path (e.g. "RAM DISK:").

	All references to the "Fonts" folder are disabled for now on.

*/

/************************************************************************************************
*** Includes ************************************************************************************
************************************************************************************************/

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/feelin.h>
		
#include <dos/dostags.h>
#include <libraries/feelin.h>

struct  FeelinBase                 *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace                 *IFeelin;
#else
#define UtilityBase                 FeelinBase->Utility
#endif

/************************************************************************************************
**** Configuration ******************************************************************************
************************************************************************************************/

//#define DB_INIT
//#define DB_COPY
//#define DB_RESUME
//#define DB_GO
//#define F_ENABLE_FORCE_THEME
//#define F_ENABLE_FORCE_DEFAULT
//#define F_ENABLE_GO_DELAY
//#define F_ENABLE_FEELIN_FONTS

#define F_ENABLE_LICENCE
#define F_ENABLE_PREFERENCES
#define F_ENABLE_STARTUP

/************************************************************************************************
**** ********************************************************************************************
************************************************************************************************/

BPTR lock_feelin_previous = 0;
BPTR lock_feelin_new = 0;
BPTR lock_feelin_libs = 0;
BPTR lock_feelin_locale = 0;
#ifdef F_ENABLE_FEELIN_FONTS
BPTR lock_feelin_fonts = 0;
#endif
uint32 assign_feelin_new = 0;
uint32 assign_feelin_libs = 0;
uint32 assign_feelin_locale = 0;
#ifdef F_ENABLE_FEELIN_FONTS
uint32 assign_feelin_fonts = 0;
#endif
uint32 launch_preference_editor = FALSE;

///typedefs

enum    {

		FV_ATTRIBUTE_ACTIVEPAGE,
		FV_ATTRIBUTE_THEME,
		FV_ATTRIBUTE_SUCCESS
 
		};
		
enum    {

		FV_METHOD_COPY,
		FV_METHOD_GO

		};

enum    {
	
		FV_Installer_ActivePage_Prev = -2,
		FV_Installer_ActivePage_Next

		};

enum    {
	
		FV_PAGE_WELCOME,
		#ifdef F_ENABLE_LICENCE
		FV_PAGE_LICENCE,
		#endif
		#ifdef F_ENABLE_PREFERENCES
		FV_PAGE_PREFERENCES,
		#endif
		#ifdef F_ENABLE_STARTUP
		FV_PAGE_STARTUP,
		#endif
		FV_PAGE_RESUME,
		FV_PAGE_PROGRESS,
		FV_PAGE_DONE,
		
		FV_PAGE_COUNT

		};
		
enum    {

		FV_INSTALLER_THEME_CURRENT,
		FV_INSTALLER_THEME_AQUA,
		FV_INSTALLER_THEME_CRYSTAL,
		FV_INSTALLER_THEME_UNITY

		};

struct FS_Installer_Go                          { uint32 Step; };

enum    {

		FV_INSTALLER_STEP_BEGIN,
		FV_INSTALLER_STEP_PREFERENCES,
		FV_INSTALLER_STEP_STARTUP,
		FV_INSTALLER_STEP_FINISH

		};

#define FV_BUFFER_SIZE                          8192

struct LocalObjectData
{
	#ifdef F_NEW_GLOBALCONNECT
	F_MEMBER_ELEMENT_PUBLIC;
	#else
	FObject                         application;
	#endif
	
	FObject                         xmlobject;
	struct TagItem                 *xmltags;
					
	FObject                         pages[FV_PAGE_COUNT];
	uint16                          active;
	uint16                          success;
	
	STRPTR                          string_title;
	STRPTR                          string_banner;
	STRPTR                          string_resume_theme;
 
	FObject                         root;
	FObject                         master;
	FObject                         btn_group;
	FObject                         next;
	FObject                         prev;
	FObject                         bar;
	
	FObject                         banner;
	FObject                         banner_text;
	
	FObject                         progress_text;
	FObject                         progress_gauge;

/** vars **/
	
	FObject                         preferences_theme;
	FObject                         preferences_editor;
	FObject                         startup_modify;
			
/** resume **/
 
	FObject                         resume_theme;
	FObject                         resume_editor;
	FObject                         resume_startup;
};

/* WARNING ! 'active' origin is 1 not 0 !! 'active' equals 0 when  there  is
not active page (the master group is empty) */
 
//+
///strings
#define F_THEMES_PATH                           "feelin:resources/themes"
#define F_THEME_DEFAULT                         "Unity"
#define F_THEME_BACKUP                          "ENV:Feelin/global.bak"

#define F_STR_WELCOME_TITLE                     "Feelin installation"
#define F_STR_WELCOME                           "<align=center>"\
												"<font size='200%'><b>Feelin - Welcome</b></font><br>" \
												"<br>" \
												"You are about to install <b>Feelin</b> on your system.<br><br>" \
												"<align=justify>"\
												"Click on the \"Next\" button to proceed with the installation.<br>" \
												"You can click the \"Cancel\" button at any time to stop the<br>" \
												"installation process. No file will be added to your system,<br>"\
												"and nothing will be modified until your reach the end of the<br>"\
												"<align=left>installation.<br><br>"\
												"<align=right>Have fun ! Olivier Laviale"

#define F_STR_LICENCE_TITLE                     "Licence & Terms"
#define F_STR_LICENCE_BANNER                    "Licence agreement and terms of use"
#define F_STR_LICENCE_BODY                      "<align=center><b>Feelin</b> is an open-source OOS created by Olivier LAVIALE<br><br>"\
												"<align=justify>Using <b>Feelin</b> you promise to eat <u>only</u> vegetables<br>"\
												"a day per week (or more if you want to be healty). You promise to<br>"\
												"help or talk to people in need (old people count). You promise to<br>"\
												"respect people different then you or the idiom of the country in<br>"\
												"which you live. You promise to watch TV with criticism and get<br>"\
												"involved in politic with \"I want  better, not more\" in mind.<br>"\
												"You promise to recycle your trash (especialy plastic, glass and<br>"\
												"paper). You promise to be safe (especially with sex). You promise<br>"\
												"to let people live the way they are pleased, and try to understand<br>"\
												"instead of rejecting. You may not invade any foreign countries like<br>"\
												"you were the king of the world. And finaly, you promise to walk<br>"\
												"<align=left>peacefully among the things (or a least to try to :-).<br><br>"\
												"<align=center>The complete licence is available at:<br><br>"\
												"http://www.gofromiel.com/feelin/"

#define F_STR_PREFERENCES_TITLE                 "Choose a theme to start with"
#define F_STR_PREFERENCES_BANNER                "Customize Feelin to your taste and needs"
#define F_STR_PREFERENCES_CHOOSE                "Choose a theme <font size=80%>(more are available in \"/resources/themes\")</font>"

#define F_STR_STARTUP_TITLE                     "Adding assigns and path"
#define F_STR_STARTUP_BANNER                    "Have Feelin ready at each startup"
#define F_STR_STARTUP_BODY                      "<align=justify>With the assigns and the path added to your user-startup, <b>Feelin</b> will be ready at each startup.<br>"\
												"Thus, you'll be able to use it easily, write a lot of wonderful applications and use Feelin's<br>"\
												"<align=left>support and debugging tools.<br>"\
												"<br>"\
												"Would you like to add the assigns and the path to your user-startup ?"
												
#define F_STR_STARTUP_NO                        "No thanks. I'm just curious"
#define F_STR_STARTUP_YES                       "Absolutely, <b>Feelin</b> looks amazing !"

#define F_STR_RESUME_TITLE                      "Résumé"
#define F_STR_RESUME_BANNER                     "Ready to begin the installation of Feelin"
#define F_STR_RESUME_BODY                       "Click the \"Next\" button to complete the installation"
#define F_STR_RESUME_THEME_YES                  "You choosed the \"%s\" theme"
#define F_STR_RESUME_THEME_NO                   "You didn't choosed a theme"
#define F_STR_RESUME_EDITOR_YES                 "The preference editor will be launched once the installation is complete"
#define F_STR_RESUME_EDITOR_NO                  "The preference editor will <b>not</b> be launched once the installation is complete"
#define F_STR_RESUME_STARTUP_YES                "Your user-startup will be modified"
#define F_STR_RESUME_STARTUP_NO                 "Your user-startup will <b>not</b> be modified"

#define F_STR_PROGRESS_TITLE                    "Progress"
#define F_STR_PROGRESS_BANNER                   "Installation progress"
#define F_STR_PROGRESS_PREFERENCES              "Copying preferences"
#define F_STR_PROGRESS_STARTUP                  "Modifying user-startup"

#define F_STR_DONE_TITLE                        "Done"
#define F_STR_DONE_BANNER                       "The installation was a success"
#define F_STR_DONE_BODY                         "<align=center><font size=200%>Congratulations !</font><br>"\
												"<br>"\
												"<b>Feelin</b> has been successfully installed on your system.<br>"\
												"<br>"\
												"<font size=120%>Have Fun !"
//+
 
/************************************************************************************************
*** Private *************************************************************************************
************************************************************************************************/

///dos_file_copy
STATIC uint32 dos_file_copy(STRPTR Source, STRPTR Destination)
{
	uint32 rc = 0;

	APTR buffer = IEXEC AllocMem(FV_BUFFER_SIZE, 0);

	#ifdef DB_COPY
	IDOS_ Printf("(%s) to (%s)\n",Source, Destination);
	#endif

	if (buffer != NULL)
	{
		BPTR s = IDOS_ Open(Source, MODE_OLDFILE);

		if (s != 0)
		{
			BPTR d = IDOS_ Open(Destination, MODE_NEWFILE);

			if (d != 0)
			{
				uint32 read;

				while ((read = IDOS_ Read(s, buffer, FV_BUFFER_SIZE)) != 0)
				{
					rc += IDOS_ Write(d, buffer, read);
				}

				IDOS_ Close(d);
			}
			else
			{
				IDOS_ Printf("Unable to open (%s) for output\n", (int32) Destination);
			}

			IDOS_ Close(s);
		}
		else
		{
			IDOS_ Printf("Unable to open (%s) for input\n", (int32) Source);
		}

		IEXEC FreeMem(buffer, FV_BUFFER_SIZE);
	}

	return rc;
}
//+
///installer_build_resume
STATIC void installer_build_resume(FClass *Class,FObject Obj)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	
	uint32 v;
	STRPTR theme = NULL;
	
	/* theme */
	
	v = IFEELIN F_Get(LOD->preferences_theme, (uint32) "FA_Radio_Active");
	
	switch (v)
	{
		case FV_INSTALLER_THEME_AQUA:     theme = "Aqua"; break;
		case FV_INSTALLER_THEME_CRYSTAL:  theme = "Crystal"; break;
		case FV_INSTALLER_THEME_UNITY:    theme = "uNiTy"; break;
	}
	
	#ifdef DB_RESUME
	IFEELIN F_Log(0,"theme (%ld)(%s)",v,theme);
	#endif
 
	if (theme)
	{
		IFEELIN F_Dispose(LOD->string_resume_theme);
		LOD->string_resume_theme = IFEELIN F_StrNew(NULL, F_STR_RESUME_THEME_YES, theme);
		
		IFEELIN F_Set(LOD->resume_theme, FA_Text_Contents, (uint32) LOD->string_resume_theme);
	}
	else
	{
		IFEELIN F_Set(LOD->resume_theme, FA_Text_Contents, (uint32) F_STR_RESUME_THEME_NO);
	}

	/* editor */
	
	v = IFEELIN F_Get(LOD->preferences_editor, FA_Widget_Selected);
 
	#ifdef DB_RESUME
	IFEELIN F_Log(0,"editor (0x%08lx)(%ld)",LOD->preferences_editor,v);
	#endif 
	
	IFEELIN F_Set(LOD->resume_editor, FA_Text_Contents, v ? (uint32) F_STR_RESUME_EDITOR_YES : (uint32) F_STR_RESUME_EDITOR_NO);

	/* startup */
	
	v = IFEELIN F_Get(LOD->startup_modify, (uint32) "FA_Radio_Active");
									
	#ifdef DB_RESUME
	IFEELIN F_Log(0,"modify (0x%08lx)(%ld)",LOD->startup_modify,v);
	#endif
   
	IFEELIN F_Set(LOD->resume_startup, FA_Text_Contents, v ? (uint32) F_STR_RESUME_STARTUP_YES : (uint32) F_STR_RESUME_STARTUP_NO);
}
//+
///installer_update_title
STATIC void installer_update_title(FClass *Class, FObject *Obj, uint32 Active)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
 
	STRPTR add = NULL;
	STRPTR ban = NULL;
	STRPTR str;

	switch (Active)
	{
		#ifdef F_ENABLE_LICENCE
		case FV_PAGE_LICENCE:
		{
			add = F_STR_LICENCE_TITLE;
			ban = F_STR_LICENCE_BANNER;
		}
		break;
		#endif

		#ifdef F_ENABLE_STARTUP
		case FV_PAGE_STARTUP:
		{
			add = F_STR_STARTUP_TITLE;
			ban = F_STR_STARTUP_BANNER;
		}
		break;
		#endif

		#ifdef F_ENABLE_PREFERENCES
		case FV_PAGE_PREFERENCES:
		{
			add = F_STR_PREFERENCES_TITLE;
			ban = F_STR_PREFERENCES_BANNER;
		}
		break;
		#endif

		case FV_PAGE_RESUME:
		{
			add = F_STR_RESUME_TITLE;
			ban = F_STR_RESUME_BANNER;

			installer_build_resume(Class,Obj);
		}
		break;

		case FV_PAGE_PROGRESS:
		{
			add = F_STR_PROGRESS_TITLE;
			ban = F_STR_PROGRESS_BANNER;

			IFEELIN F_Do
			(
				#ifdef F_NEW_GLOBALCONNECT
				_element_application, FM_Application_PushMethod,
				#else
				LOD->application, FM_Application_PushMethod,
				#endif

				Obj, F_METHOD_ID(GO), 1, FV_INSTALLER_STEP_BEGIN
			);
		}
		break;

		case FV_PAGE_DONE:
		{
			add = F_STR_DONE_TITLE;
			ban = F_STR_DONE_BANNER;
		}
		break;
	}

	/* window's title */

	IFEELIN F_Dispose(LOD->string_title);

	if (add)
	{
		str = IFEELIN F_StrNew(NULL, "%s -- %s", F_STR_WELCOME_TITLE, add);
	}
	else
	{
		str = IFEELIN F_StrNew(NULL, F_STR_WELCOME_TITLE);
	}

	LOD->string_title = str;

	IFEELIN F_Set(Obj, FA_Window_Title, (uint32) LOD->string_title);

	/* banner title */

	if (add && ban)
	{
		IFEELIN F_Dispose(LOD->string_banner);
		
		LOD->string_banner = IFEELIN F_StrNew(NULL, "<b>%s</b><br>    %s",add,ban);

		IFEELIN F_Set(LOD->banner_text, FA_Text_Contents, (uint32) LOD->string_banner);
	}
}
//+
///installer_modify_startup

#define F_TEMP_STARTUP                          "t:feelin-user-startup"
#define F_USER_STARTUP                          "s:user-startup"
#define F_STARTUP_MARKUP_BEGIN                  ";BEGIN FEELIN"
#define FV_STARTUP_MARKUP_BEGIN_LENGTH          13
#define F_STARTUP_MARKUP_END                    ";END FEELIN"
#define FV_STARTUP_MARKUP_END_LENGTH            11
 
STATIC void installer_modify_startup(void)
{
	STRPTR buf = IFEELIN F_New(1024);

	if (buf)
	{
		BPTR in = IDOS_ Open(F_USER_STARTUP, MODE_OLDFILE);
		
		if (in)
		{
			BPTR out = IDOS_ Open(F_TEMP_STARTUP, MODE_NEWFILE);
			
			if (out)
			{
				int32 begin = FALSE;
				int32 end = FALSE;
 
				while (IDOS_ FGets(in, buf, 1024))
				{
					if (IUTILITY Strnicmp(F_STARTUP_MARKUP_BEGIN, buf, FV_STARTUP_MARKUP_BEGIN_LENGTH) == 0)
					{
						begin = TRUE; continue;
					}
					else if (IUTILITY Strnicmp(F_STARTUP_MARKUP_END, buf, FV_STARTUP_MARKUP_END_LENGTH) == 0)
					{
						end = TRUE; continue;
					}
					
					if ((begin == FALSE) || ((begin == TRUE) && (end == TRUE)))
					{
						IDOS_ FPuts(out, buf);
					}
				}
				
				if (begin == TRUE && end != TRUE)
				{
					IDOS_ Printf("The Feelin block in your user-startup was malformed. Please check the file later\n");

					/* startup block was malformed ! we will have to  append
					Feelin block, ignoring possible errors :-( */
					
					IDOS_ Close(out);
					
					out = IDOS_ Open(F_TEMP_STARTUP, MODE_NEWFILE);
					
					if (out)
					{
						IDOS_ Seek(in, 0, OFFSET_BEGINNING);
 
						while (IDOS_ FGets(in, buf, 1024))
						{
							IDOS_ FPuts(out, buf);
						}
					}
 
				}
			
				if (out)
				{
					IDOS_ NameFromLock(lock_feelin_new, buf, 1024);

					IDOS_ FPrintf(out, "\n" F_STARTUP_MARKUP_BEGIN "\n");

					IDOS_ FPrintf(out, "Assign >NIL: Feelin: \"%s\"\n", (int32) buf);
					IDOS_ FPrintf(out, "Assign >NIL: LIBS: ADD Feelin:LIBS\n");
					IDOS_ FPrintf(out, "Assign >NIL: Locale: ADD Feelin:Locale\n");

					#ifdef F_ENABLE_FEELIN_FONTS
					IDOS_ FPrintf(out, "Assign >NIL: FONTS: ADD Feelin:Fonts\n");
					#endif

					IDOS_ FPrintf(out, "Path ADD Feelin:Tools\n");
					IDOS_ FPrintf(out, F_STARTUP_MARKUP_END "\n");

					IDOS_ Close(out);
				
					/* we close "in" file to be able to overwrite it */
					
					IDOS_ Close(in); in = NULL;
 
					dos_file_copy(F_TEMP_STARTUP, F_USER_STARTUP);
				}

				IDOS_ DeleteFile(F_TEMP_STARTUP);
			}

			if (in)
			{
				IDOS_ Close(in);
			}
		}
	
		IFEELIN F_Dispose(buf);
	}
}
//+

/************************************************************************************************
*** Methods *************************************************************************************
************************************************************************************************/

///Installer_New
F_METHOD(FObject,Installer_New)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	
	FObject cancel;

	STATIC F_ENTITIES_ARRAY =
	{
		F_ENTITIES_ADD("themes-path",               F_THEMES_PATH),
		
		F_ENTITIES_ADD("locale.welcome.body",       F_STR_WELCOME),
		F_ENTITIES_ADD("locale.licence.body",       F_STR_LICENCE_BODY),
		
		F_ENTITIES_ADD("locale.startup.body",       F_STR_STARTUP_BODY),
		F_ENTITIES_ADD("locale.startup.no",         F_STR_STARTUP_NO),
		F_ENTITIES_ADD("locale.startup.yes",        F_STR_STARTUP_YES),
		
		F_ENTITIES_ADD("locale.preference.choose",  F_STR_PREFERENCES_CHOOSE),
		
		F_ENTITIES_ADD("locale.resume.body",        F_STR_RESUME_BODY),
		F_ENTITIES_ADD("locale.done.body",          F_STR_DONE_BODY),
		
		F_ARRAY_END
	};

	#ifdef F_NEW_GLOBALCONNECT
	F_SAVE_ELEMENT_PUBLIC;
	#endif
 
	LOD->xmlobject = XMLObjectObject,
	
		"Source", "feelin:resources/install/pages.xml",
		"SourceType", FV_Document_SourceType_File,
		"Entities", F_ENTITIES_PTR,
		
		End;

	LOD->xmltags = (struct TagItem *) IFEELIN F_Get(LOD->xmlobject,(uint32) "Tags");
 
	if ((LOD->xmlobject == NULL) || (LOD->xmltags == NULL))
	{
		return NULL;
	}

	#ifdef F_NEW_GETELEMENTBYID
	{
		struct element_item
		{
			STRPTR Id;
			FObject *ObjectPtr;
		};

		struct element_item ar[] =
		{
			{ "banner",						  &LOD->banner },
			{ "banner.text",                  &LOD->banner_text },
			{ "pages.welcome",                &LOD->pages[FV_PAGE_WELCOME] },

			#ifdef F_ENABLE_LICENCE
			{ "pages.licence",				  &LOD->pages[FV_PAGE_LICENCE] },
			#endif

			#ifdef F_ENABLE_PREFERENCES
			{ "pages.preferences",            &LOD->pages[FV_PAGE_PREFERENCES] },
			#endif

			{ "pages.preferences.theme",	  &LOD->preferences_theme },
			{ "pages.preferences.editor",	  &LOD->preferences_editor },

			#ifdef F_ENABLE_STARTUP
			{ "pages.startup",				  &LOD->pages[FV_PAGE_STARTUP] },
			#endif

			{ "pages.startup.modify",		  &LOD->startup_modify },
			{ "pages.resume",				  &LOD->pages[FV_PAGE_RESUME] },
			{ "pages.resume.theme",			  &LOD->resume_theme },
			{ "pages.resume.editor",          &LOD->resume_editor },
			{ "pages.resume.startup",         &LOD->resume_startup },
			{ "pages.progress",               &LOD->pages[FV_PAGE_PROGRESS] },
			{ "pages.progress.text", 		  &LOD->progress_text },
			{ "pages.progress.gauge",         &LOD->progress_gauge },
			{ "pages.done",					  &LOD->pages[FV_PAGE_DONE] },

			F_ARRAY_END
		};

		struct element_item *item;

		for ( item = ar ; item->Id ; item++)
		{
			*item->ObjectPtr = (FObject) IFEELIN F_Do(LOD->xmlobject, FM_GetElementById, item->Id);
		}
	}
	#else

	IFEELIN F_Do(LOD->xmlobject, (uint32) "GetObjects",

		"banner",						&LOD->banner,
		"banner.text",                  &LOD->banner_text,
		"pages.welcome",                &LOD->pages[FV_PAGE_WELCOME],

		#ifdef F_ENABLE_LICENCE
		"pages.licence",				&LOD->pages[FV_PAGE_LICENCE],
		#endif

		#ifdef F_ENABLE_PREFERENCES
		"pages.preferences",            &LOD->pages[FV_PAGE_PREFERENCES],
		#endif

		"pages.preferences.theme",		&LOD->preferences_theme,
		"pages.preferences.editor",		&LOD->preferences_editor,
		
		#ifdef F_ENABLE_STARTUP
		"pages.startup",				&LOD->pages[FV_PAGE_STARTUP],
		#endif
		
		"pages.startup.modify",			&LOD->startup_modify,
		"pages.resume",					&LOD->pages[FV_PAGE_RESUME],
		"pages.resume.theme",			&LOD->resume_theme,
		"pages.resume.editor",          &LOD->resume_editor,
		"pages.resume.startup",         &LOD->resume_startup,
		"pages.progress",               &LOD->pages[FV_PAGE_PROGRESS],
		"pages.progress.text", 			&LOD->progress_text,
		"pages.progress.gauge",         &LOD->progress_gauge,
		"pages.done",					&LOD->pages[FV_PAGE_DONE],

		NULL);

	#endif

	if (IFEELIN F_SuperDo(Class,Obj,Method,
		
		FA_Element_Style, "border-frame: none; padding: 0px; background: url(feelin:resources/install/back.png) bottom right fill no-repeat",
//		  FA_Element_Style, "border-frame: none; padding: 0px;",
//		  FA_Area_Bufferize, TRUE,
	
		Child, LOD->root = VGroup,
			
			Child, LOD->master = VGroup,
				
			End,
			   
			Child, LOD->bar = BarObject, End,

			Child, LOD->btn_group = HGroup,
				
				FA_Element_Style, "padding: 5px; height: auto",
				
				Child, LOD->prev = Button("_< Previous"),
				Child, LOD->next = Button("Next _>"),
				   
				Child, BarObject, End,
				   
				Child, cancel = Button("Cancel"),
			End,
		End,
		   
		TAG_MORE, Msg))
	{

		#ifdef F_ENABLE_FORCE_DEFAULT
			
		IFEELIN F_Set(LOD->preferences_theme, (uint32) "FA_Radio_Active", FV_INSTALLER_THEME_UNITY);
		IFEELIN F_Set(LOD->preferences_editor, FA_Widget_Selected, TRUE);
		IFEELIN F_Set(LOD->startup_modify, (uint32) "FA_Radio_Active", 1);
   
		#endif

		IFEELIN F_Do
		(
			LOD->progress_gauge, FM_Set,

			"Max",  FV_INSTALLER_STEP_FINISH,
			"Min",  FV_INSTALLER_STEP_BEGIN,
			
			TAG_DONE
		);

		IFEELIN F_Set(Obj, FA_Window_ActiveObject, (uint32) LOD->next);

/*** self **************************************************************************************/

		IFEELIN F_Do
		(
			Obj, FM_Notify,
			
			FA_Window_CloseRequest, TRUE,
			
			FV_Notify_Application, FM_Application_Shutdown, 0
		);
 
/*** buttons ***********************************************************************************/
		
		IFEELIN F_Do
		(
			LOD->prev, FM_Notify,
			
			FA_Widget_Pressed, FALSE,
			
			Obj, FM_Set, 2, F_ATTRIBUTE_ID(ACTIVEPAGE), FV_Installer_ActivePage_Prev
		);
		
		IFEELIN F_Do
		(
			LOD->next, FM_Notify,

			FA_Widget_Pressed, FALSE,

			Obj, FM_Set, 2, F_ATTRIBUTE_ID(ACTIVEPAGE), FV_Installer_ActivePage_Next
		);
 
		IFEELIN F_Do
		(
			cancel, FM_Notify,
			
			FA_Widget_Pressed, FALSE,
			
			Obj, FM_Set, 2, FA_Window_CloseRequest, TRUE
		);
		
/*** specials **********************************************************************************/
				
		IFEELIN F_Do
		(
			LOD->preferences_theme, FM_Notify,
			
			"FA_Radio_Active", FV_Notify_Always,
			
			Obj, FM_Set, 2, F_ATTRIBUTE_ID(THEME), FV_Notify_Value
		);

		//
		// init
		//

		IFEELIN F_Set(Obj, F_ATTRIBUTE_ID(ACTIVEPAGE), 1);

		return Obj;
	}
	return NULL;
}
//+
///Installer_Dispose
F_METHOD(uint32,Installer_Dispose)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	struct TagItem *tags = LOD->xmltags,*item;

	IFEELIN F_Set(Obj, F_ATTRIBUTE_ID(ACTIVEPAGE), 0);
 
	while ((item = IUTILITY NextTagItem(&tags)) != NULL)
	{
		if (item->ti_Tag == FA_Child)
		{
			IFEELIN F_DisposeObj((FObject) item->ti_Data);
		}
	}
		
	IFEELIN F_DisposeObj(LOD->xmlobject); LOD->xmlobject = NULL;
	
	IFEELIN F_Dispose(LOD->string_title);
	IFEELIN F_Dispose(LOD->string_banner);
	IFEELIN F_Dispose(LOD->string_resume_theme);
 
	return F_SUPERDO();
}
//+
///Installer_Set
F_METHOD(uint32,Installer_Set)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	struct TagItem *Tags = Msg,*real,item;
	
	while  ((real = IFEELIN F_DynamicNTI(&Tags,&item,Class)) != NULL)
	switch (item.ti_Tag)
	{
///ActivePage
		case FV_ATTRIBUTE_ACTIVEPAGE:
		{
			int32 n = item.ti_Data;

			switch (item.ti_Data)
			{
				case FV_Installer_ActivePage_Prev:
				{
					n = LOD->active;

					if (n > 1)
					{
						n--;
					}
				}
				break;
				
				case FV_Installer_ActivePage_Next:
				{
					n = LOD->active;

					if (n < FV_PAGE_COUNT)
					{
						n++;
					}
				}
				break;
			}
			
//            IFEELIN F_Log(0,"active (%ld) new (%ld) count (%ld)",LOD->active, n, FV_PAGE_COUNT);
			
			/*** clamp ***/
 
			if (n < 0)
			{
				n = 0;
			}
			else if (n > FV_PAGE_COUNT)
			{
				n = FV_PAGE_COUNT;
			}
		
			/*** ***/
		
			if (n != LOD->active)
			{
				IFEELIN F_Set(LOD->master, FA_Group_Quiet, TRUE);
				
				if (LOD->active)
				{
					#ifdef DB_SET
					IFEELIN F_Log(0,"remmember %s{%08lx}",_classname(LOD->pages[LOD->active - 1]), LOD->pages[LOD->active - 1]);
					#endif
					IFEELIN F_Do(LOD->master, FM_RemMember, LOD->pages[LOD->active - 1]);
				}
			
/*** update window's title and banner's contents ***********************************************/
					
				installer_update_title(Class,Obj,n - 1);
 
/*** remove/add banner *************************************************************************/
 
				if (n < 2)
				{
					if (IFEELIN F_Get(LOD->banner, FA_Element_Parent))
					{
						IFEELIN F_Do(LOD->master, FM_RemMember, LOD->banner);
					}
				}
				else if (IFEELIN F_Get(LOD->banner, FA_Element_Parent) == 0)
				{
					IFEELIN F_Do(LOD->master, FM_AddMember, LOD->banner, FV_AddMember_Tail);
				}
				
				if (n)
				{
					#ifdef DB_SET
					IFEELIN F_Log(0,"addmember %s{%08lx}",_classname(LOD->pages[n - 1]), LOD->pages[n - 1]);
					#endif
					IFEELIN F_Do(LOD->master, FM_AddMember, LOD->pages[n - 1], FV_AddMember_Tail);
				}

				IFEELIN F_Set(LOD->prev, FA_Widget_Hidden, FF_Hidden_Check | (n == 1 ? TRUE : FALSE));
				IFEELIN F_Set(LOD->next, FA_Widget_Hidden, FF_Hidden_Check | (n == FV_PAGE_COUNT ? TRUE : FALSE));

/*** activate 'next' or 'previous' button ******************************************************/
 
				#if 0
				 
				if (n < FV_PAGE_COUNT)
				{
					IFEELIN F_Set(Obj, FA_Window_ActiveObject, (uint32) LOD->next);
				}
				else if (n > 1)
				{
					IFEELIN F_Set(Obj, FA_Window_ActiveObject, (uint32) LOD->prev);
				}
			
				#endif
 
				real->ti_Data = LOD->active = n;
 
				IFEELIN F_Set(LOD->master, FA_Group_Quiet, FALSE);
			}
		}
		break;
//+
///Theme
		case FV_ATTRIBUTE_THEME:
		{
			STRPTR name = NULL;;
				 
			switch (item.ti_Data)
			{
				case FV_INSTALLER_THEME_CURRENT:
				{
					IFEELIN F_Do(Obj, F_METHOD_ID(COPY), F_THEME_BACKUP, "ENV:Feelin/global.css");
				}
				break;

				case FV_INSTALLER_THEME_AQUA:     name = "aqua"; break;
				case FV_INSTALLER_THEME_CRYSTAL:  name = "crystal"; break;
				case FV_INSTALLER_THEME_UNITY:    name = "unity"; break;
			}
		
			if (name)
			{
				name = IFEELIN F_StrNew(NULL, F_THEMES_PATH "/%s.css", name);
				
				if (name)
				{
					IFEELIN F_Do(Obj, F_METHOD_ID(COPY), name, "ENV:Feelin/global.css");
					
					IFEELIN F_Dispose(name);
				}
			}
		}
		break;
//+
	}
	
	return F_SUPERDO();
}
//+
///Installer_Get
F_METHOD(uint32,Installer_Get)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	struct TagItem *Tags = Msg,item;

	while (IFEELIN F_DynamicNTI(&Tags,&item,Class))
	switch (item.ti_Tag)
	{
		case FV_ATTRIBUTE_SUCCESS:
		{
			F_STORE(LOD->success);
		}
		break;
	}

	return F_SUPERDO();
}
//+
#ifndef F_NEW_GLOBALCONNECT
///Installer_Connect
F_METHODM(uint32,Installer_Connect,FS_Connect)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	
	LOD->application = Msg->Parent;
	
	return F_SUPERDO();
}
//+
///Installer_Disconnect
F_METHOD(uint32,Installer_Disconnect)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	LOD->application = NULL;

	return F_SUPERDO();
}
//+
#endif
	
///Installer_Copy

struct  FS_Installer_Copy                         { STRPTR Source; STRPTR Destination; };
												
F_METHODM(uint32,Installer_Copy,FS_Installer_Copy)
{
	uint32 rc = 0;
	
	APTR buffer = IFEELIN F_New(FV_BUFFER_SIZE);

	#ifdef DB_COPY
	IFEELIN F_Log(0,"(%s) to (%s)",Msg->Source, Msg->Destination);
	#endif 
 
	if (buffer)
	{
		BPTR s = IDOS_ Open(Msg->Source, MODE_OLDFILE);
		
		if (s)
		{
			BPTR d = IDOS_ Open(Msg->Destination, MODE_NEWFILE);
			
			if (d)
			{
				uint32 read;
				
				while ((read = IDOS_ Read(s, buffer, FV_BUFFER_SIZE)) != 0)
				{
					rc += IDOS_ Write(d, buffer, read);
				}
				
				IDOS_ Close(d);
			}
			else
			{
				IFEELIN F_Log(0,"Unable to open (%s)", Msg->Destination);
			}
		
			IDOS_ Close(s);
		}
		else
		{
			IFEELIN F_Log(0,"Unable to open (%s)", Msg->Source);
		}
		
		IFEELIN F_Dispose(buffer);
	}

	return rc;
}
//+
///Installer_Go
F_METHODM(void,Installer_Go,FS_Installer_Go)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
				
	IFEELIN F_Set(LOD->progress_gauge, (uint32) "Value", Msg->Step);
 
	switch (Msg->Step)
	{
		case FV_INSTALLER_STEP_BEGIN:
		{
			FObject btn_done = NULL;

			#ifdef F_NEW_GETELEMENTBYID

			btn_done = (FObject) IFEELIN F_Do(LOD->xmlobject, FM_GetElementById, "done.ok");

			#else

			IFEELIN F_Do(LOD->xmlobject, (uint32) "GetObjects", "done.ok", &btn_done, NULL);

			#endif
 
			#ifdef DB_GO
			IFEELIN F_Log(0,"step: begin. btn_done (0x%08lx)", btn_done);
			#endif
			
			/* we remove all deprecated buttons */
 
			IFEELIN F_Set(LOD->root, FA_Group_Quiet, TRUE);
 
			IFEELIN F_DisposeObj(LOD->bar); 
			IFEELIN F_DisposeObj(LOD->btn_group);
			
			LOD->bar = NULL;
			LOD->btn_group = NULL;
			LOD->next = NULL;
			LOD->prev = NULL;
 
			IFEELIN F_Set(LOD->root, FA_Group_Quiet, FALSE);
			
			/* set notification upon the "Done" button */
				
			IFEELIN F_Do
			(
				btn_done, FM_Notify,
				
				FA_Widget_Pressed, FALSE,

				#ifdef F_NEW_GLOBALCONNECT
				_element_application, FM_Application_Shutdown, 0
				#else
				LOD->application, FM_Application_Shutdown, 0
				#endif
			);
			
			/* set the launch_preference_editor variable */
			
			launch_preference_editor = IFEELIN F_Get(LOD->preferences_editor, FA_Widget_Selected);
		}
		break;

		case FV_INSTALLER_STEP_PREFERENCES:
		{
			uint32 v;
			STRPTR theme = NULL;
			
			v = IFEELIN F_Get(LOD->preferences_theme, (uint32) "FA_Radio_Active");

			switch (v)
			{
				case FV_INSTALLER_THEME_AQUA:     theme = "Aqua"; break;
				case FV_INSTALLER_THEME_CRYSTAL:  theme = "Crystal"; break;
				case FV_INSTALLER_THEME_UNITY:    theme = "uNiTy"; break;
			}

			#ifdef DB_GO
			IFEELIN F_Log(0,"step: theme (%ld)(%s)",v,theme);
			#endif

			if (theme)
			{
				STRPTR str = IFEELIN F_StrNew(NULL, F_THEMES_PATH "/%s.css", theme);
			
				IFEELIN F_Set(LOD->progress_text, FA_Text_Contents, (uint32) F_STR_PROGRESS_PREFERENCES);
 
				if (str)
				{
					#ifdef DB_GO
					IFEELIN F_Log(0,"source (%s)",str);
					#endif 
					
					#ifndef F_ENABLE_PREFERENCES
					IFEELIN F_Do(Obj, F_METHOD_ID(COPY), str, "ENV:Feelin/global.css");
					#endif
					
					IFEELIN F_Do(Obj, F_METHOD_ID(COPY), str, "ENVARC:Feelin/global.css");
					
					IFEELIN F_Dispose(str);
				}
			}
		}
		break;
		
		case FV_INSTALLER_STEP_STARTUP:
		{
			uint32 v = IFEELIN F_Get(LOD->startup_modify, (uint32) "FA_Radio_Active");
			
			#ifdef DB_GO
			IFEELIN F_Log(0,"step: startup");
			#endif
 
			if (v == 1)
			{
				IFEELIN F_Set(LOD->progress_text, FA_Text_Contents, (uint32) F_STR_PROGRESS_STARTUP);
				
				installer_modify_startup();
			}
		}
		break;
 
		case FV_INSTALLER_STEP_FINISH:
		{
			#ifdef DB_GO
			IFEELIN F_Log(0,"step: finish");
			#endif
			
			LOD->success = TRUE;
 
			IFEELIN F_Set(Obj, F_ATTRIBUTE_ID(ACTIVEPAGE), FV_Installer_ActivePage_Next);
		}
		return;
	}
	
	IFEELIN F_Do
	(
		#ifdef F_NEW_GLOBALCONNECT
		_element_application, FM_Application_PushMethod,
		#else
		LOD->application, FM_Application_PushMethod,
		#endif
		
		Obj, F_METHOD_ID(GO), 1, Msg->Step + 1
	);
	
	#ifdef F_ENABLE_GO_DELAY
	IDOS_ Delay(20);
	#endif
}
//+
	
/************************************************************************************************
**** Main ***************************************************************************************
************************************************************************************************/

///main
int main(void)
{
	BPTR lock;
	
/** env directories *****************************************************************************
				
	If it doesn't exists, we create the "Feelin" directory in both ENV:  and
	ENVARC:.

*/

	lock = IDOS_ Lock("ENV:Feelin", SHARED_LOCK);

	if (lock)
	{
		IDOS_ UnLock(lock);
	}
	else
	{
		lock = IDOS_ CreateDir("ENV:Feelin");

		if (lock)
		{
			IDOS_ UnLock(lock);
		}
		else
		{
			IDOS_ Printf("Unable to create the 'ENV:Feelin' directory\n");
		}
	}
 

	lock = IDOS_ Lock("ENVARC:Feelin", SHARED_LOCK);

	if (lock)
	{
		IDOS_ UnLock(lock);
	}
	else
	{
		lock = IDOS_ CreateDir("ENVARC:Feelin");

		if (lock)
		{
			IDOS_ UnLock(lock);
		}
		else
		{
			IDOS_ Printf("Unable to create the 'ENVARC:Feelin' directory\n");
		}
	}
 
/** remove "Feelin:" ****************************************************************************

	If Feelin is already installed or active,  we  have  to  remove  various
	assigns  before  we  may  continue.  If  we  fail  to  do so, we may use
	deprecated resources... which is not a good idea ;-)

	Note: We keep the lock of the previous path until the application quits.
	It might be used to rename the previous location and copy new files in a
	'Feelin' directory in the same parent folder.
 
*/
 
	lock_feelin_previous = IDOS_ Lock("Feelin:", SHARED_LOCK);
	lock_feelin_new = IDOS_ GetProgramDir();

	if (lock_feelin_new)
	{
		lock_feelin_new = IDOS_ DupLock(lock_feelin_new);
	}
	else
	{
		return 0;
	}
 
	if (lock_feelin_previous)
	{
		#ifdef DB_INIT
		
		uint32 rc;
 
		IDOS_ Printf("'Feelin:' already exists\n");
		
		#endif
				
		/* remove 'Feelin:LIBS' from 'LIBS:' */
		
		lock = IDOS_ Lock("Feelin:LIBS", SHARED_LOCK);
		
		if (lock)
		{
			#ifdef DB_INIT
			
			rc = IDOS_ RemAssignList("LIBS", lock);
			
			IDOS_ Printf("remove 'Feelin:LIBS' (%ld)\n",rc);
			
			#else
			
			IDOS_ RemAssignList("LIBS", lock);
			
			#endif
		}
	
		/* remove 'Feelin:Locale' from 'Locale:' */
		
		lock = IDOS_ Lock("Feelin:Locale", SHARED_LOCK);
		
		if (lock)
		{
			#ifdef DB_INIT
			
			rc = IDOS_ RemAssignList("Locale", lock);
			
			IDOS_ Printf("remove 'Feelin:Locale' (%ld)\n",rc);
			
			#else
			
			IDOS_ RemAssignList("Locale", lock);
			 
			#endif
		}
	
		#ifdef F_ENABLE_FEELIN_FONTS

		/* remove 'Feelin:Fonts' from 'FONTS:' */
		
		lock = IDOS_ Lock("Feelin:Fonts", SHARED_LOCK);
		
		if (lock)
		{
			#ifdef DB_INIT
			
			rc = IDOS_ RemAssignList("FONTS", lock);
			
			IDOS_ Printf("remove 'Feelin:Fonts' (%ld)\n",rc);
			
			#else
			
			IDOS_ RemAssignList("FONTS", lock);
 
			#endif
		}
		
		#endif
		
		/* finaly remove 'Feelin:' */
 
		#ifdef DB_INIT

		rc = IDOS_ RemAssignList("Feelin", lock_feelin_previous);
		
		IDOS_ Printf("remove 'Feelin:' %ld\n",rc);
		
		#else
		
		IDOS_ RemAssignList("Feelin", lock_feelin_previous);
 
		#endif
	}

/** add temporaty assigns ***********************************************************************

	Now that previous assigns are removed, we can add new ones.  Their  lock
	is  kept  until the application quits, thus they can be used to retreive
	the path to use to add assigns to user-startup. The locks are only freed
	if  the  assigns  didn't  succeed. Remember that the lock is part of the
	assign !
 
*/

	if (lock_feelin_new)
	{
		assign_feelin_new = IDOS_ AssignLock("Feelin", lock_feelin_new);
		
		if (assign_feelin_new)
		{
			lock_feelin_libs = IDOS_ Lock("Feelin:LIBS", SHARED_LOCK);
			
			if (lock_feelin_libs)
			{
				assign_feelin_libs = IDOS_ AssignAdd("LIBS", lock_feelin_libs);
			}
		
			lock_feelin_locale = IDOS_ Lock("Feelin:Locale", SHARED_LOCK);
			
			if (lock_feelin_locale)
			{
				assign_feelin_locale = IDOS_ AssignAdd("Locale", lock_feelin_locale);
			}

			#ifdef F_ENABLE_FEELIN_FONTS

			lock_feelin_fonts = IDOS_ Lock("Feelin:Fonts", SHARED_LOCK);
			
			if (lock_feelin_fonts)
			{
				assign_feelin_fonts = IDOS_ AssignAdd("FONTS", lock_feelin_fonts);
			}

			#endif
		}
	}

/** preferences *********************************************************************************

	We need to create a "Feelin" folder in both ENV: and ENVARC: to copy the
	default  configuration  file  inside.  If  a  configuration file already
	exists we don't erase it to copy the new one.
 
*/
		
	#if 0
 
/** envarc **/

	lock = IDOS_ Lock("ENVARC:Feelin", SHARED_LOCK);
	
	if (lock == NULL)
	{
		lock = IDOS_ CreateDir("ENVARC:Feelin");
	}

	if (lock)
	{
		IDOS_ UnLock(lock);
		
		lock = IDOS_ Lock("ENVARC:Feelin/global.css", SHARED_LOCK);
		
		if (lock == NULL)
		{
			dos_file_copy("Feelin:resources/themes/" F_THEME_DEFAULT ".css", "ENVARC:Feelin:global.css");
		}
		else
		{
			IDOS_ UnLock(lock);
		}
	}

	#endif

/** env **/

	lock = IDOS_ Lock("ENV:Feelin", SHARED_LOCK);

	if (lock == NULL)
	{
		lock = IDOS_ CreateDir("ENV:Feelin");
	}

	if (lock)
	{
		IDOS_ UnLock(lock);
		
		#ifdef F_ENABLE_FORCE_THEME

		dos_file_copy(F_THEMES_PATH "/" F_THEME_DEFAULT ".css", "ENV:Feelin/global.css");

		#else
 
		lock = IDOS_ Lock("ENV:Feelin/global.css", SHARED_LOCK);

		if (lock == NULL)
		{
			dos_file_copy(F_THEMES_PATH "/" F_THEME_DEFAULT ".css", "ENV:Feelin/global.css");
		}
		else
		{
			IDOS_ UnLock(lock);
		}
	
		#endif
	
		/* backup global.css, which is  overwritten  when  the  user  select
		themes.  The  backup is used when the user select "Current" theme or
		when he cancel the installation */
		
		dos_file_copy("ENV:Feelin/global.css", F_THEME_BACKUP);
	}

/** application *********************************************************************************

	Now that everything is setuped (or should be  :-),  we  can  create  our
	application and launch it.
	
*/
 
	if (F_FEELIN_OPEN)
	{
		FClass *cc;

		STATIC F_ATTRIBUTES_ARRAY =
		{
			F_ATTRIBUTES_ADD("ActivePage", FV_TYPE_INTEGER),
			F_ATTRIBUTES_ADD("Theme", FV_TYPE_INTEGER),
			F_ATTRIBUTES_ADD("Success", FV_TYPE_BOOLEAN),

			F_ARRAY_END
		};
 
		STATIC F_METHODS_ARRAY =
		{
			F_METHODS_ADD(Installer_Copy, "Copy"),
			F_METHODS_ADD(Installer_Go, "Go"),
			
			F_METHODS_OVERRIDE_STATIC(Installer_New, FM_New),
			F_METHODS_OVERRIDE_STATIC(Installer_Dispose, FM_Dispose),
			F_METHODS_OVERRIDE_STATIC(Installer_Set, FM_Set),
			F_METHODS_OVERRIDE_STATIC(Installer_Get, FM_Get),
			#ifndef F_NEW_GLOBALCONNECT
			F_METHODS_OVERRIDE_STATIC(Installer_Connect, FM_Connect),
			F_METHODS_OVERRIDE_STATIC(Installer_Disconnect, FM_Disconnect),
			#endif
			
			F_ARRAY_END
		};
			
		STATIC F_TAGS_ARRAY =
		{
			F_TAGS_ADD_SUPER(Window),
			F_TAGS_ADD_LOD,
			F_TAGS_ADD_ATTRIBUTES,
			F_TAGS_ADD_METHODS,
			
			F_ARRAY_END
		};

		if ((cc = IFEELIN F_CreateClassA(NULL, F_TAGS_PTR)) != NULL)
		{
			FObject app,win;

			app = ApplicationObject,
				
				FA_Application_Title, "FInstaller",
				FA_Application_Version, "$VER: FInstaller 01.00 (2006/01/04)",
				FA_Application_Copyright, "© 2001-2006 Olivier LAVIALE",
				FA_Application_Author, "Olivier LAVIALE - gofromiel@gofromiel.com",
				FA_Application_Description, "Setup Feelin",
				//FA_Application_Base, "FINSTALLER",
				
				Child, win = IFEELIN F_NewObj(cc->Name,
				
					FA_Window_Open, TRUE,
					
					TAG_DONE),
			End;
			
			if (app)
			{
				IFEELIN F_Do(app,FM_Application_Run);
										
				if (IFEELIN F_Get(win, cc->Attributes[FV_ATTRIBUTE_SUCCESS].ID) == FALSE)
				{
					launch_preference_editor = FALSE;
					
					dos_file_copy("ENV:Feelin/global.bak", "ENV:Feelin/global.css");
				}
			
				/* vanish the application */
 
				IFEELIN F_DisposeObj(app);
			}
		
			IFEELIN F_DeleteClass(cc);
		}
		
		F_FEELIN_CLOSE;
	}
	else
	{
		IDOS_ Printf("unable to open %s v%ld\n", (int32) "feelin.library", FV_FEELIN_VERSION);
	}
	
/** free resources *****************************************************************************/
 
	if (lock_feelin_previous)
	{
		IDOS_ UnLock(lock_feelin_previous);
	}

	if (assign_feelin_new == 0 && lock_feelin_new != NULL)
	{
		IDOS_ UnLock(lock_feelin_new);
	}

	if (assign_feelin_libs == 0 && lock_feelin_libs != NULL)
	{
		IDOS_ UnLock(lock_feelin_libs);
	}

	if (assign_feelin_locale == 0 && lock_feelin_locale != NULL)
	{
		IDOS_ UnLock(lock_feelin_locale);
	}

	#ifdef F_ENABLE_FEELIN_FONTS

	if (assign_feelin_fonts == 0 && lock_feelin_fonts != NULL)
	{
		IDOS_ UnLock(lock_feelin_fonts);
	}

	#endif

	IDOS_ DeleteFile("ENV:Feelin/global.bak");
 
/** preference editor **************************************************************************/
						
	if (launch_preference_editor)
	{
		IDOS_ SystemTags("run >NIL: prefs", NP_StackSize, 16384, TAG_DONE);
	}
	
	return 0;
}
//+

