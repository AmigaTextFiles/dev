#include <libraries/mui.hpp>
#include <mui/NList_mcc.hpp>
#include <mui/NListview_mcc.h>

/***************************************************************************
**                     CMUI_NListview class definition                      
***************************************************************************/

class CMUI_NListview : public CMUI_NList
{
public:
	CMUI_NListview (void)
	: CMUI_NList ()
	{
	}

	CMUI_NListview (struct TagItem *tags)
	: CMUI_NList ()
	{
		object = MUI_NewObjectA (MUIC_NListview, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_NListview object\n");
#endif
	}

	CMUI_NListview (Tag tag1, ...)
	: CMUI_NList ()
	{
		object = MUI_NewObjectA (MUIC_NListview, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_NListview object\n");
#endif
	}

	CMUI_NListview (Object * obj)
	: CMUI_NList ()
	{
		object = obj;
	}

	CMUI_NListview & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	LONG ActivePage (void) const
	{
		 return (LONG)GetAttr (MUIA_Group_ActivePage);
	}

	void SetActivePage (LONG value)
	{
		 SetAttr (MUIA_Group_ActivePage, (ULONG)value);
	}

	struct List * ChildList (void) const
	{
		 return (struct List *)GetAttr (MUIA_Group_ChildList);
	}

	void SetColumns (LONG value)
	{
		 SetAttr (MUIA_Group_Columns, (ULONG)value);
	}

	LONG HorizSpacing (void) const
	{
		 return (LONG)GetAttr (MUIA_Group_HorizSpacing);
	}

	void SetHorizSpacing (LONG value)
	{
		 SetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
	}

	void SetRows (LONG value)
	{
		 SetAttr (MUIA_Group_Rows, (ULONG)value);
	}

	void SetSpacing (LONG value)
	{
		 SetAttr (MUIA_Group_Spacing, (ULONG)value);
	}

	LONG VertSpacing (void) const
	{
		 return (LONG)GetAttr (MUIA_Group_VertSpacing);
	}

	void SetVertSpacing (LONG value)
	{
		 SetAttr (MUIA_Group_VertSpacing, (ULONG)value);
	}

	ULONG ExitChange (void)
	{
		return DoMethod (MUIM_Group_ExitChange);
	}

	ULONG InitChange (void)
	{
		return DoMethod (MUIM_Group_InitChange);
	}

	ULONG Sort (StartVarArgs sva, Object * obj, ...)
	{
		sva.methodID = MUIM_Group_Sort;
		return DoMethodA ((Msg)&sva);
	}

	Object * Horiz_ScrollBar (void) const
	{
		 return (Object *)GetAttr (MUIA_NListview_Horiz_ScrollBar);
	}

	void SetHoriz_ScrollBar (Object * value)
	{
		 SetAttr (MUIA_NListview_Horiz_ScrollBar, (ULONG)value);
	}

	Object * NList (void) const
	{
		 return (Object *)GetAttr (MUIA_NListview_NList);
	}

	Object * Vert_ScrollBar (void) const
	{
		 return (Object *)GetAttr (MUIA_NListview_Vert_ScrollBar);
	}

	void SetVert_ScrollBar (Object * value)
	{
		 SetAttr (MUIA_NListview_Vert_ScrollBar, (ULONG)value);
	}

};

#ifdef MUIPP_TEMPLATES

/***************************************************************************
**                     CTMUI_NListview class definition
***************************************************************************/

template <class Type>
class CTMUI_NListview : public CTMUI_NList<Type>
{
public:
	CTMUI_NListview (void)
	: CTMUI_NList<Type> ()
	{
	}

	CTMUI_NListview (Tag tag1, ...)
	: CTMUI_NList<Type> ()
	{
		object = MUI_NewObjectA (MUIC_NListview, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CTMUI_NListview object\n");
#endif
	}

	CTMUI_NListview (Object * obj)
	: CTMUI_NList<Type> ()
	{
		object = obj;
	}

	CTMUI_NListview & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	LONG ActivePage (void) const
	{
		 return (LONG)GetAttr (MUIA_Group_ActivePage);
	}

	void SetActivePage (LONG value)
	{
		 SetAttr (MUIA_Group_ActivePage, (ULONG)value);
	}

	struct List * ChildList (void) const
	{
		 return (struct List *)GetAttr (MUIA_Group_ChildList);
	}

	void SetColumns (LONG value)
	{
		 SetAttr (MUIA_Group_Columns, (ULONG)value);
	}

	LONG HorizSpacing (void) const
	{
		 return (LONG)GetAttr (MUIA_Group_HorizSpacing);
	}

	void SetHorizSpacing (LONG value)
	{
		 SetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
	}

	void SetRows (LONG value)
	{
		 SetAttr (MUIA_Group_Rows, (ULONG)value);
	}

	void SetSpacing (LONG value)
	{
		 SetAttr (MUIA_Group_Spacing, (ULONG)value);
	}

	LONG VertSpacing (void) const
	{
		 return (LONG)GetAttr (MUIA_Group_VertSpacing);
	}

	void SetVertSpacing (LONG value)
	{
		 SetAttr (MUIA_Group_VertSpacing, (ULONG)value);
	}

	ULONG ExitChange (void)
	{
		return DoMethod (MUIM_Group_ExitChange);
	}

	ULONG InitChange (void)
	{
		return DoMethod (MUIM_Group_InitChange);
	}

	ULONG Sort (StartVarArgs sva, Object * obj, ...)
	{
		sva.methodID = MUIM_Group_Sort;
		return DoMethodA ((Msg)&sva);
	}

	Object * Horiz_ScrollBar (void) const
	{
		 return (Object *)GetAttr (MUIA_NListview_Horiz_ScrollBar);
	}

	void SetHoriz_ScrollBar (Object * value)
	{
		 SetAttr (MUIA_NListview_Horiz_ScrollBar, (ULONG)value);
	}

	Object * NList (void) const
	{
		 return (Object *)GetAttr (MUIA_NListview_NList);
	}

	Object * Vert_ScrollBar (void) const
	{
		 return (Object *)GetAttr (MUIA_NListview_Vert_ScrollBar);
	}

	void SetVert_ScrollBar (Object * value)
	{
		 SetAttr (MUIA_NListview_Vert_ScrollBar, (ULONG)value);
	}
};

#endif
