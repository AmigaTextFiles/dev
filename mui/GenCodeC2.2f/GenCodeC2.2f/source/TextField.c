#include "TextField.h"
#include "Tools.h"

#define MUIA_Boopsi_Smart 0x8042b8d7 /* V9 i.. BOOL */

struct ObjTextField * CreateTextField( void )
{
	Class *TextFieldClass;
	struct ObjTextField * ObjectApp;

	TextFieldClass = TEXTFIELD_GetClass();

	if (!(ObjectApp = AllocMemory( sizeof( struct ObjTextField ),FALSE )))
		return( NULL );

  ObjectApp->textfield = HGroup,
    MUIA_Group_HorizSpacing, 0,
    Child, ObjectApp->text = BoopsiObject,
      InputListFrame,
      MUIA_Background, MUII_BACKGROUND,
      MUIA_Boopsi_Class, TextFieldClass,
      MUIA_Boopsi_Smart, TRUE,
      MUIA_Boopsi_MinWidth, 20,
      MUIA_Boopsi_MinHeight, 20,
      ICA_TARGET, ICTARGET_IDCMP,
      TEXTFIELD_Text,(ULONG)"",
    End,
    Child, ObjectApp->prop = ScrollbarObject, End,
  End;

  if (!(ObjectApp->textfield))
    {
      FreeMemory(ObjectApp);
      ObjectApp = NULL;
    }

  DoMethod(ObjectApp->text, MUIM_Notify, TEXTFIELD_Lines, MUIV_EveryTime,
      ObjectApp->prop, 3, MUIM_Set, MUIA_Prop_Entries, MUIV_TriggerValue);

  DoMethod(ObjectApp->text, MUIM_Notify, TEXTFIELD_Visible, MUIV_EveryTime,
      ObjectApp->prop, 3, MUIM_Set, MUIA_Prop_Visible, MUIV_TriggerValue);

  DoMethod(ObjectApp->text, MUIM_Notify, TEXTFIELD_Top, MUIV_EveryTime,
      ObjectApp->prop, 3, MUIM_NoNotifySet, MUIA_Prop_First, MUIV_TriggerValue);

  DoMethod(ObjectApp->prop, MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
      ObjectApp->text, 3, MUIM_Set, TEXTFIELD_Top, MUIV_TriggerValue);

  return( ObjectApp );
}

void DisposeTextField( struct ObjTextField * ObjectApp )
{
	if (ObjectApp != NULL)
	{
		if (ObjectApp->textfield != NULL)
			MUI_DisposeObject(ObjectApp->textfield);
		FreeMemory(ObjectApp);
	}
}
