#include "demo.h"


/*
** We want our images displayed in a group with five columns.
*/

#define cols 4
#define startimg 11

/*
** This is a image object at its standard size.
*/

#define FixedImg(x) ImageObject,\
	ButtonFrame,\
	MUIA_InputMode, MUIV_InputMode_RelVerify,\
	MUIA_Image_FreeHoriz, FALSE,\
	MUIA_Image_FreeVert, FALSE,\
	MUIA_Image_Spec, x,\
	MUIA_Background, MUII_BACKGROUND,\
	End


/*
** This is a resizable image.
** Since the user might have configured a fixed size image,
** we need to enclose our image in groups of spacing objects
** to make it centered. The spacing objects have a very little
** weight, so the images will get every pixel they want.
*/

#define sp            RectangleObject, MUIA_Weight, 1, End
#define hcenter(obj)  HGroup, Child, sp, Child, obj, Child, sp, End
#define vcenter(obj)  VGroup, Child, sp, Child, obj, Child, sp, End
#define hvcenter(obj) hcenter(vcenter(obj))

#define FreeImg(x) hcenter(vcenter(xFreeImg(x)))

#define xFreeImg(x) ImageObject,\
	ButtonFrame,\
	MUIA_InputMode, MUIV_InputMode_RelVerify,\
	MUIA_Image_FreeHoriz, TRUE,\
	MUIA_Image_FreeVert, TRUE,\
	MUIA_Image_Spec, x,\
	MUIA_Background, MUII_BACKGROUND,\
	End




int main(int argc,char *argv[])
{
	ULONG signal;
	APTR App,WI_Master;
	APTR FixGroup,FreeGroup;
	int i;

	init();


	/*
	** Create the application.
	** Note that we generate two empty groups without children.
	** These children will be added later with OM_ADDMEMBER.
	*/

	App = ApplicationObject,
		MUIA_Application_Title      , "ShowImg",
		MUIA_Application_Version    , "$VER: ShowImg 7.35 (10.02.94)",
		MUIA_Application_Copyright  , "©1992/93, Stefan Stuntz",
		MUIA_Application_Author     , "Stefan Stuntz",
		MUIA_Application_Description, "Show MUI standard images",
		MUIA_Application_Base       , "SHOWIMG",

		SubWindow, WI_Master = WindowObject,
			MUIA_Window_ID, MAKE_ID('M','A','I','N'),
			MUIA_Window_Title, "MUI Standard Images",

			WindowContents, HGroup,

				Child, VGroup,
					Child, VSpace(0),
					Child, FixGroup = ColGroup(cols), GroupFrameT("Minimum Size"), End,
					Child, VSpace(0),
					End,

				Child, FreeGroup = ColGroup(cols), GroupFrameT("Free Size"), End,

				End,
			End,
		End;

	if (!App) fail(App,"Failed to create Application.");


	/*
	** No we insert the image elements in our groups.
	*/

	for (i=0;i<MUII_Count-startimg;i++)
	{
		DoMethod(FixGroup,OM_ADDMEMBER,FixedImg(i+startimg));
		DoMethod(FreeGroup,OM_ADDMEMBER,FreeImg(i+startimg));
	}


	/*
	** Append some empty objects to make our columnized
   ** group contain exactly cols*rows elements.
	*/

	while (i % cols)
	{
		DoMethod(FixGroup,OM_ADDMEMBER,HVSpace);
		DoMethod(FreeGroup,OM_ADDMEMBER,HVSpace);
		i++;
	}


	/*
	** Simplest possible MUI input loop.
	*/

	DoMethod(WI_Master,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,App,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
	set(WI_Master,MUIA_Window_Open,TRUE);

	while (DoMethod(App,MUIM_Application_Input,&signal) != MUIV_Application_ReturnID_Quit)
		if (signal)
			Wait(signal);

	set(WI_Master,MUIA_Window_Open,FALSE);

	fail(App,NULL);
}
