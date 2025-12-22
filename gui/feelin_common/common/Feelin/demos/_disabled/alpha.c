#include <libraries/feelin.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/feelin.h>

struct FeelinBase *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace *IFeelin;
#endif

#define SOURCE                                  "feelin:resources/images/feelin.png"
#define BACK                                    "#B8F0F8 #000000 #002080"

int main(void)
{
	FObject app,win,/*img,*/txt,src;

	if (F_FEELIN_OPEN)
	{
		app = AppObject,
			Child, win = WindowObject,
				FA_Window_Title,  "Feelin : Alpha",
				FA_Window_Open,   TRUE,
				
				//FA_Area_Width,   "200",
				//FA_Area_Height,  "200",

				Child, HGroup,
					Child, VGroup,
						Child, txt = ImageObject,
							FA_Element_Style, "frame-id: 18; padding: 10; back: " BACK ";",

							FA_Area_Bufferize, TRUE,
							FA_Widget_Chainable, FALSE,
								
							"FA_Image_Spec", "url(" SOURCE "')",
						End,
					
						Child, src = PopFileObject, "FA_PopFile_Contents", SOURCE, End,
					End,
					
					Child, BalanceObject, End,
					
//					  Child, img = AdjustImageObject, "Spec", BACK, "Preview",FALSE, End,
				End,
			End,
		End;

		if (app)
		{
			IFEELIN F_Do(win,FM_Notify,FA_Window_CloseRequest,TRUE, app,FM_Application_Shutdown,0);

			//IFEELIN F_Do(img,FM_Notify, "Spec",FV_Notify_Always, txt,FM_Set,2, FA_Back,FV_Notify_Value);
			IFEELIN F_Do(src,FM_Notify, "FA_PopFile_Contents",FV_Notify_Always, txt,FM_SetAs,4, FV_SetAs_String,"FA_Image_Spec","url(%s)",FV_Notify_Value);
 
			IFEELIN F_Do(app,FM_Application_Run);
			IFEELIN F_DisposeObj(app);
		}
		else
		{
			IDOS_ Printf("Unable to create application\n");
		}

		F_FEELIN_CLOSE;
	}

	return 0;
}

