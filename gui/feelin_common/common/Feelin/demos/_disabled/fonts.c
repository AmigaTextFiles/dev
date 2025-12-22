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

///new_title
FObject new_title(STRPTR Title)
{
   return   TextObject,

			FA_Element_Class, 		"textinfo",

			FA_Widget_Chainable,	FALSE,
			FA_Widget_Weight, 		10,

			FA_Text_Contents,          		Title,
			FA_Text_PreParse, 		"<align=center><pens style=emboss>",
			FA_Text_VCenter,  		TRUE,
			
			End;
}
//+

int main(void)
{
   FObject app,win,pop_1,pop_2,pop_3;

   if (F_FEELIN_OPEN)
   {
	  app = AppObject,

		 Child, win = WindowObject,

			FA_Window_Title, "Feelin : Fonts",
			FA_Window_Open,   TRUE,

			Child, VGroup,
			   Child, TextObject,
				  FA_Widget_Chainable,  FALSE,
				  FA_Text_Contents, "<align=center><color=halfdark><pens shadow=halfshadow>The layout adapts itself<br>to font changes.<br>Try <b><font face=topaz size=8>topaz/8</font></b> to see...",
				  FA_Widget_SetMax, FV_Widget_SetHeight,
				  End,

			   Child, VGroup, FA_Group_Rows, 3,
				  Child, new_title("Icons"),   Child, pop_1 = PopFontObject, End,
				  Child, new_title("Default"), Child, pop_2 = PopFontObject, End,
				  Child, new_title("Screen"),  Child, pop_3 = PopFontObject, End,
			   End,

			   Child, BarObject, End,

			   Child, HGroup, FA_Group_SameSize,TRUE,
				  Child, Button("<b>Save</b>"),
				  Child, Button("<color=halfdark>Use"),
				  Child, Button("<color=highligth>Cancel"),
			   End,
			End,
		 End,
	  End;

	  if (app)
	  {
		 IFEELIN F_Do(pop_1,FM_Notify,"Contents",FV_Notify_Always,FV_Notify_Self,FM_Set,2,FA_Area_Font,FV_Notify_Value);
		 IFEELIN F_Do(pop_2,FM_Notify,"Contents",FV_Notify_Always,FV_Notify_Self,FM_Set,2,FA_Area_Font,FV_Notify_Value);
		 IFEELIN F_Do(pop_3,FM_Notify,"Contents",FV_Notify_Always,FV_Notify_Self,FM_Set,2,FA_Area_Font,FV_Notify_Value);

		 IFEELIN F_Set(pop_1,(ULONG) "Contents",(ULONG) "Helvetica/9");
		 IFEELIN F_Set(pop_2,(ULONG) "Contents",(ULONG) "Helvetica/11");
		 IFEELIN F_Set(pop_3,(ULONG) "Contents",(ULONG) "Helvetica/13");

		 IFEELIN F_Do(win,FM_Notify,FA_Window_CloseRequest,TRUE,app,FM_Application_Shutdown,0);
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

