/*

   This example shows how font changes are dynamic handled

*/

#include <libraries/feelin.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/feelin.h>

struct FeelinBase                  *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace                 *IFeelin;
#endif

int main(void)
{
   FObject app,win;

   if (F_FEELIN_OPEN)
   {
	  app = AppObject,
		 Child, DialogObject,
			FA_Window_Left,             "10%",
			FA_Window_Top,              "10%",
 
			FA_Window_Title,     "Boolean",
		   "FA_Dialog_Buttons",  "boolean",
		 End,

		 Child, DialogObject,
			FA_Window_Left,             "40%",
			FA_Window_Top,              "20%",

			FA_Window_Title,     "Confirm",
		   "FA_Dialog_Buttons",  "confirm",
//            FA_Window_Activable,    FALSE,
		 End,

		 Child, DialogObject,
			FA_Window_Left,             "10%",
			FA_Window_Top,              "70%",

			FA_Window_Title,     "Always",
		   "FA_Dialog_Buttons",  "always",
		 End,

		 Child, DialogObject,
			FA_Window_Left,             "80%",
			FA_Window_Top,              "10%",

			FA_Window_Title,     "Preference",
		   "FA_Dialog_Buttons",  "preference",
//            FA_Window_Activable,    FALSE,
		 End,

		 Child, DialogObject,
			FA_Window_Left,             "80%",
			FA_Window_Top,              "60%",

			FA_Window_Title,     "PreferenceTest",
		   "FA_Dialog_Buttons",  "preference-test",
		 End,
		 
		 Child, win = DialogObject,
			FA_Window_Title,     "Ok",
		   "FA_Dialog_Buttons",  "ok",
		 End,
	  End;

	  if (app)
	  {
		 IFEELIN F_Do(win,FM_Notify,"FA_Dialog_Response",FV_Dialog_Response_Ok,app,FM_Application_Shutdown,0);
		 IFEELIN F_Do(app,FM_Application_Run);
		 IFEELIN F_DisposeObj(app);
	  }
	  
	  F_FEELIN_CLOSE;
   }
   else
   {
	  IDOS_ Printf("Unable to open feelin.library v%ld\n",FV_FEELIN_VERSION);
   }
   return 0;
}

