#include <libraries/mui.hpp>
#include <mui/NList_mcc.h>

/***************************************************************************
**                       CMUI_NList class definition                        
***************************************************************************/

class CMUI_NList : public CMUI_Area
{
public:
	CMUI_NList (void)
	: CMUI_Area ()
	{
	}

	CMUI_NList (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_NList, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_NList object\n");
#endif
	}

	CMUI_NList (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_NList, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_NList object\n");
#endif
	}

	CMUI_NList (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_NList & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	// By overloading the [] operator you can treat lists like arrays
	
	APTR operator [] (LONG pos)
	{
	    APTR entry;
	    DoMethod (MUIM_NList_GetEntry, pos, &entry);
	    return entry;
	}
	
	// This method is a convienient alternative to the Entries attribute
	
	LONG Length (void) const
	{
		return (LONG)GetAttr (MUIA_NList_Entries);
	}
	
	// This method can be used to retrieve the number of selected entries
	// in a list
	
	ULONG NumSelected (void)
	{
		ULONG numSelected;
		DoMethod (MUIM_NList_Select, MUIV_NList_Select_All, MUIV_NList_Select_Ask, &numSelected);
		return numSelected;
	}
	
	// These methods can be used as shortcuts for inserting objects into lists
	
	void AddHead (APTR entry)
	{
		DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Top);
	}
	
	void AddTail (APTR entry)
	{
		DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Bottom);
	}
	
	void InsertTop (APTR entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Top);
	}
	
	void InsertBottom (APTR entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Bottom);
	}
	
	void InsertSorted (APTR entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Sorted);
	}
	
	void InsertActive (APTR entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Active);
	}
	
	
	LONG Active (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Active);
	}

	void SetActive (LONG value)
	{
		 SetAttr (MUIA_NList_Active, (ULONG)value);
	}

	void SetAutoCopyToClip (BOOL value)
	{
		 SetAttr (MUIA_NList_AutoCopyToClip, (ULONG)value);
	}

	BOOL AutoVisible (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_AutoVisible);
	}

	void SetAutoVisible (BOOL value)
	{
		 SetAttr (MUIA_NList_AutoVisible, (ULONG)value);
	}

	LONG ClickColumn (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_ClickColumn);
	}

	void SetCompareHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_CompareHook, (ULONG)value);
	}

	void SetConstructHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_ConstructHook, (ULONG)value);
	}

	void SetCopyColumnToClipHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_CopyColumnToClipHook, (ULONG)value);
	}

	void SetCopyEntryToClipHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_CopyEntryToClipHook, (ULONG)value);
	}

	void SetDefaultObjectOnClick (BOOL value)
	{
		 SetAttr (MUIA_NList_DefaultObjectOnClick, (ULONG)value);
	}

	LONG DefClickColumn (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_DefClickColumn);
	}

	void SetDefClickColumn (LONG value)
	{
		 SetAttr (MUIA_NList_DefClickColumn, (ULONG)value);
	}

	void SetDestructHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_DestructHook, (ULONG)value);
	}

	void SetDisplayHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_DisplayHook, (ULONG)value);
	}

	void SetDisplayRecall (BOOL value)
	{
		 SetAttr (MUIA_NList_DisplayRecall, (ULONG)value);
	}

	BOOL DoubleClick (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_DoubleClick);
	}

	BOOL DragSortable (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_DragSortable);
	}

	void SetDragSortable (BOOL value)
	{
		 SetAttr (MUIA_NList_DragSortable, (ULONG)value);
	}

	LONG DragType (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_DragType);
	}

	void SetDragType (LONG value)
	{
		 SetAttr (MUIA_NList_DragType, (ULONG)value);
	}

	LONG DropMark (void) const
	{
		 return (LONG)GetAttr (MUIA_List_DropMark);
	}

	LONG Entries (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Entries);
	}

	BOOL EntryValueDependent (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_EntryValueDependent);
	}

	void SetEntryValueDependent (BOOL value)
	{
		 SetAttr (MUIA_NList_EntryValueDependent, (ULONG)value);
	}

	LONG First (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_First);
	}

	void SetFirst (LONG value)
	{
		 SetAttr (MUIA_NList_First, (ULONG)value);
	}

	STRPTR Format (void) const
	{
		 return (STRPTR)GetAttr (MUIA_NList_Format);
	}

	void SetFormat (STRPTR value)
	{
		 SetAttr (MUIA_NList_Format, (ULONG)value);
	}

	LONG HorizDeltaFactor (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_HorizDeltaFactor);
	}

	LONG Horiz_Entries (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Horiz_Entries);
	}

	LONG Horiz_First (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Horiz_First);
	}

	void SetHoriz_First (LONG value)
	{
		 SetAttr (MUIA_NList_Horiz_First, (ULONG)value);
	}

	LONG Horiz_Visible (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Horiz_Visible);
	}

	BOOL Input (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_Input);
	}

	void SetInput (BOOL value)
	{
		 SetAttr (MUIA_NList_Input, (ULONG)value);
	}

	LONG InsertPosition (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_InsertPosition);
	}

	void SetKeepActive (Object * value)
	{
		 SetAttr (MUIA_NList_KeepActive, (ULONG)value);
	}

	void SetMakeActive (Object * value)
	{
		 SetAttr (MUIA_NList_MakeActive, (ULONG)value);
	}

	void SetMinLineHeight (LONG value)
	{
		 SetAttr (MUIA_NList_MinLineHeight, (ULONG)value);
	}

	BOOL MultiClick (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_MultiClick);
	}

	void SetMultiTestHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_MultiTestHook, (ULONG)value);
	}

	APTR PrivateData (void) const
	{
		 return (APTR)GetAttr (MUIA_NList_PrivateData);
	}

	void SetPrivateData (APTR value)
	{
		 SetAttr (MUIA_NList_PrivateData, (ULONG)value);
	}

	LONG Prop_Entries (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Prop_Entries);
	}

	LONG Prop_First (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Prop_First);
	}

	void SetProp_First (LONG value)
	{
		 SetAttr (MUIA_NList_Prop_First, (ULONG)value);
	}

	LONG Prop_Visible (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Prop_Visible);
	}

	void SetQuiet (BOOL value)
	{
		 SetAttr (MUIA_NList_Quiet, (ULONG)value);
	}

	BOOL ShowDropMarks (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_ShowDropMarks);
	}

	void SetShowDropMarks (BOOL value)
	{
		 SetAttr (MUIA_NList_ShowDropMarks, (ULONG)value);
	}

	char * SkipChars (void) const
	{
		 return (char *)GetAttr (MUIA_NList_SkipChars);
	}

	void SetSkipChars (char * value)
	{
		 SetAttr (MUIA_NList_SkipChars, (ULONG)value);
	}

	ULONG TabSize (void) const
	{
		 return (ULONG)GetAttr (MUIA_NList_TabSize);
	}

	void SetTabSize (ULONG value)
	{
		 SetAttr (MUIA_NList_TabSize, (ULONG)value);
	}

	char * Title (void) const
	{
		 return (char *)GetAttr (MUIA_NList_Title);
	}

	void SetTitle (char * value)
	{
		 SetAttr (MUIA_NList_Title, (ULONG)value);
	}

	BOOL TitleSeparator (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_TitleSeparator);
	}

	void SetTitleSeparator (BOOL value)
	{
		 SetAttr (MUIA_NList_TitleSeparator, (ULONG)value);
	}

	void SetTypeSelect (LONG value)
	{
		 SetAttr (MUIA_NList_TypeSelect, (ULONG)value);
	}

	LONG VertDeltaFactor (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_VertDeltaFactor);
	}

	LONG Visible (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Visible);
	}

	LONG TitleBackground (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_TitleBackground);
	}

	void SetTitleBackground (LONG value)
	{
		 SetAttr (MUIA_NList_TitleBackground, (ULONG)value);
	}

	LONG TitlePen (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_TitlePen);
	}

	void SetTitlePen (LONG value)
	{
		 SetAttr (MUIA_NList_TitlePen, (ULONG)value);
	}

	ULONG Clear (void)
	{
		return DoMethod (MUIM_NList_Clear);
	}

	ULONG CopyToClip (LONG pos, ULONG clipnum)
	{
		return DoMethod (MUIM_NList_CopyToClip, pos, clipnum);
	}

	ULONG CreateImage (Object * imgobj, ULONG flags)
	{
		return DoMethod (MUIM_NList_CreateImage, imgobj, flags);
	}

	ULONG DeleteImage (APTR listimg)
	{
		return DoMethod (MUIM_NList_DeleteImage, listimg);
	}

	ULONG Exchange (LONG pos1, LONG pos2)
	{
		return DoMethod (MUIM_NList_Exchange, pos1, pos2);
	}

	ULONG GetEntry (LONG pos, APTR * entry)
	{
		return DoMethod (MUIM_NList_GetEntry, pos, entry);
	}

	ULONG GetEntryInfo (struct MUI_NList_GetEntryInfo * res)
	{
		return DoMethod (MUIM_NList_GetEntryInfo, res);
	}

	ULONG Insert (APTR * entries, LONG count, LONG pos)
	{
		return DoMethod (MUIM_NList_Insert, entries, count, pos);
	}

	ULONG InsertSingle (APTR entry, LONG pos)
	{
		return DoMethod (MUIM_NList_InsertSingle, entry, pos);
	}

	ULONG InsertSingleWrap (void)
	{
		return DoMethod (MUIM_NList_InsertSingleWrap);
	}

	ULONG InsertWrap (APTR * entries)
	{
		return DoMethod (MUIM_NList_InsertWrap, entries);
	}

	ULONG Jump (LONG pos)
	{
		return DoMethod (MUIM_NList_Jump, pos);
	}

	ULONG Move (LONG from, LONG to)
	{
		return DoMethod (MUIM_NList_Move, from, to);
	}

	ULONG NextSelected (LONG * pos)
	{
		return DoMethod (MUIM_NList_NextSelected, pos);
	}

	ULONG Redraw (LONG pos)
	{
		return DoMethod (MUIM_NList_Redraw, pos);
	}

	ULONG Remove (LONG pos)
	{
		return DoMethod (MUIM_NList_Remove, pos);
	}

	ULONG ReplaceSingle (LONG pos, LONG seltype, LONG * state)
	{
		return DoMethod (MUIM_NList_ReplaceSingle, pos, seltype, state);
	}

	ULONG Sort (void)
	{
		return DoMethod (MUIM_NList_Sort);
	}

	ULONG TestPos (LONG x, LONG y, struct MUI_NList_TestPos_Result * res)
	{
		return DoMethod (MUIM_NList_TestPos, x, y, res);
	}

	ULONG UseImage (Object * obj, ULONG imgnum, ULONG flags)
	{
		return DoMethod (MUIM_NList_UseImage, obj, imgnum, flags);
	}

};

#ifdef MUIPP_TEMPLATES

/***************************************************************************
**                       CMUI_NList class definition
***************************************************************************/

template <class Type>
class CTMUI_NList : public CMUI_Area
{
public:
	CTMUI_NList (void)
	: CMUI_Area ()
	{
	}

	CTMUI_NList (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_NList, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CTMUI_NList object\n");
#endif
	}

	CTMUI_NList (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CTMUI_NList & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	// By overloading the [] operator you can treat lists like arrays

	Type & operator [] (LONG pos)
	{
	    Type * entry;
	    DoMethod (MUIM_NList_GetEntry, pos, &entry);
#ifdef MUIPP_DEBUG
		if (entry == NULL)
			_MUIPPError ("Index into CTMUI_NList is out of range:\n"
						 "Index = %d, length = %d\n",
						 (int)pos,
						 (int)GetAttr(MUIA_NList_Entries));
#endif
	    return *entry;
	}

	// This method is a convienient alternative to the Entries attribute

	LONG Length (void) const
	{
		return (LONG)GetAttr (MUIA_NList_Entries);
	}

	// This method can be used to retrieve the number of selected entries
	// in a list

	ULONG NumSelected (void)
	{
		ULONG numSelected;
		DoMethod (MUIM_NList_Select, MUIV_NList_Select_All, MUIV_NList_Select_Ask, &numSelected);
		return numSelected;
	}

	// These methods can be used as shortcuts for inserting objects into lists

	void AddHead (Type * entry)
	{
		DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Top);
	}

	void AddHead (Type & entry)
	{
		DoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Top);
	}

	void AddTail (Type * entry)
	{
		DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Bottom);
	}

	void AddTail (Type & entry)
	{
		DoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Bottom);
	}

	void InsertTop (Type * entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Top);
	}

	void InsertTop (Type & entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Top);
	}

	void InsertBottom (Type * entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Bottom);
	}

	void InsertBottom (Type & entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Bottom);
	}

	void InsertSorted (Type * entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Sorted);
	}

	void InsertSorted (Type & entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Sorted);
	}

	void InsertActive (Type * entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Active);
	}

	void InsertActive (Type & entry)
	{
	    DoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Active);
	}

	LONG Active (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Active);
	}

	void SetActive (LONG value)
	{
		 SetAttr (MUIA_NList_Active, (ULONG)value);
	}

	void SetAutoCopyToClip (BOOL value)
	{
		 SetAttr (MUIA_NList_AutoCopyToClip, (ULONG)value);
	}

	BOOL AutoVisible (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_AutoVisible);
	}

	void SetAutoVisible (BOOL value)
	{
		 SetAttr (MUIA_NList_AutoVisible, (ULONG)value);
	}

	LONG ClickColumn (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_ClickColumn);
	}

	void SetCompareHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_CompareHook, (ULONG)value);
	}

	void SetConstructHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_ConstructHook, (ULONG)value);
	}

	void SetCopyColumnToClipHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_CopyColumnToClipHook, (ULONG)value);
	}

	void SetCopyEntryToClipHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_CopyEntryToClipHook, (ULONG)value);
	}

	void SetDefaultObjectOnClick (BOOL value)
	{
		 SetAttr (MUIA_NList_DefaultObjectOnClick, (ULONG)value);
	}

	LONG DefClickColumn (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_DefClickColumn);
	}

	void SetDefClickColumn (LONG value)
	{
		 SetAttr (MUIA_NList_DefClickColumn, (ULONG)value);
	}

	void SetDestructHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_DestructHook, (ULONG)value);
	}

	void SetDisplayHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_DisplayHook, (ULONG)value);
	}

	void SetDisplayRecall (BOOL value)
	{
		 SetAttr (MUIA_NList_DisplayRecall, (ULONG)value);
	}

	BOOL DoubleClick (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_DoubleClick);
	}

	BOOL DragSortable (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_DragSortable);
	}

	void SetDragSortable (BOOL value)
	{
		 SetAttr (MUIA_NList_DragSortable, (ULONG)value);
	}

	LONG DragType (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_DragType);
	}

	void SetDragType (LONG value)
	{
		 SetAttr (MUIA_NList_DragType, (ULONG)value);
	}

	LONG DropMark (void) const
	{
		 return (LONG)GetAttr (MUIA_List_DropMark);
	}

	LONG Entries (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Entries);
	}

	BOOL EntryValueDependent (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_EntryValueDependent);
	}

	void SetEntryValueDependent (BOOL value)
	{
		 SetAttr (MUIA_NList_EntryValueDependent, (ULONG)value);
	}

	LONG First (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_First);
	}

	void SetFirst (LONG value)
	{
		 SetAttr (MUIA_NList_First, (ULONG)value);
	}

	STRPTR Format (void) const
	{
		 return (STRPTR)GetAttr (MUIA_NList_Format);
	}

	void SetFormat (STRPTR value)
	{
		 SetAttr (MUIA_NList_Format, (ULONG)value);
	}

	LONG HorizDeltaFactor (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_HorizDeltaFactor);
	}

	LONG Horiz_Entries (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Horiz_Entries);
	}

	LONG Horiz_First (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Horiz_First);
	}

	void SetHoriz_First (LONG value)
	{
		 SetAttr (MUIA_NList_Horiz_First, (ULONG)value);
	}

	LONG Horiz_Visible (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Horiz_Visible);
	}

	BOOL Input (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_Input);
	}

	void SetInput (BOOL value)
	{
		 SetAttr (MUIA_NList_Input, (ULONG)value);
	}

	LONG InsertPosition (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_InsertPosition);
	}

	void SetKeepActive (Object * value)
	{
		 SetAttr (MUIA_NList_KeepActive, (ULONG)value);
	}

	void SetMakeActive (Object * value)
	{
		 SetAttr (MUIA_NList_MakeActive, (ULONG)value);
	}

	void SetMinLineHeight (LONG value)
	{
		 SetAttr (MUIA_NList_MinLineHeight, (ULONG)value);
	}

	BOOL MultiClick (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_MultiClick);
	}

	void SetMultiTestHook (struct Hook * value)
	{
		 SetAttr (MUIA_NList_MultiTestHook, (ULONG)value);
	}

	APTR PrivateData (void) const
	{
		 return (APTR)GetAttr (MUIA_NList_PrivateData);
	}

	void SetPrivateData (APTR value)
	{
		 SetAttr (MUIA_NList_PrivateData, (ULONG)value);
	}

	LONG Prop_Entries (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Prop_Entries);
	}

	LONG Prop_First (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Prop_First);
	}

	void SetProp_First (LONG value)
	{
		 SetAttr (MUIA_NList_Prop_First, (ULONG)value);
	}

	LONG Prop_Visible (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Prop_Visible);
	}

	void SetQuiet (BOOL value)
	{
		 SetAttr (MUIA_NList_Quiet, (ULONG)value);
	}

	BOOL ShowDropMarks (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_ShowDropMarks);
	}

	void SetShowDropMarks (BOOL value)
	{
		 SetAttr (MUIA_NList_ShowDropMarks, (ULONG)value);
	}

	char * SkipChars (void) const
	{
		 return (char *)GetAttr (MUIA_NList_SkipChars);
	}

	void SetSkipChars (char * value)
	{
		 SetAttr (MUIA_NList_SkipChars, (ULONG)value);
	}

	ULONG TabSize (void) const
	{
		 return (ULONG)GetAttr (MUIA_NList_TabSize);
	}

	void SetTabSize (ULONG value)
	{
		 SetAttr (MUIA_NList_TabSize, (ULONG)value);
	}

	char * Title (void) const
	{
		 return (char *)GetAttr (MUIA_NList_Title);
	}

	void SetTitle (char * value)
	{
		 SetAttr (MUIA_NList_Title, (ULONG)value);
	}

	BOOL TitleSeparator (void) const
	{
		 return (BOOL)GetAttr (MUIA_NList_TitleSeparator);
	}

	void SetTitleSeparator (BOOL value)
	{
		 SetAttr (MUIA_NList_TitleSeparator, (ULONG)value);
	}

	void SetTypeSelect (LONG value)
	{
		 SetAttr (MUIA_NList_TypeSelect, (ULONG)value);
	}

	LONG VertDeltaFactor (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_VertDeltaFactor);
	}

	LONG Visible (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_Visible);
	}

	LONG TitleBackground (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_TitleBackground);
	}

	void SetTitleBackground (LONG value)
	{
		 SetAttr (MUIA_NList_TitleBackground, (ULONG)value);
	}

	LONG TitlePen (void) const
	{
		 return (LONG)GetAttr (MUIA_NList_TitlePen);
	}

	void SetTitlePen (LONG value)
	{
		 SetAttr (MUIA_NList_TitlePen, (ULONG)value);
	}

	ULONG Clear (void)
	{
		return DoMethod (MUIM_NList_Clear);
	}

	ULONG CopyToClip (LONG pos, ULONG clipnum)
	{
		return DoMethod (MUIM_NList_CopyToClip, pos, clipnum);
	}

	ULONG CreateImage (Object * imgobj, ULONG flags)
	{
		return DoMethod (MUIM_NList_CreateImage, imgobj, flags);
	}

	ULONG DeleteImage (APTR listimg)
	{
		return DoMethod (MUIM_NList_DeleteImage, listimg);
	}

	ULONG Exchange (LONG pos1, LONG pos2)
	{
		return DoMethod (MUIM_NList_Exchange, pos1, pos2);
	}

	ULONG GetEntry (LONG pos, Type * * entry)
	{
		return DoMethod (MUIM_NList_GetEntry, pos, entry);
	}

	ULONG GetEntryInfo (struct MUI_NList_GetEntryInfo * res)
	{
		return DoMethod (MUIM_NList_GetEntryInfo, res);
	}

	ULONG Insert (Type * * entries, LONG count, LONG pos)
	{
		return DoMethod (MUIM_NList_Insert, entries, count, pos);
	}

	ULONG InsertSingle (Type * entry, LONG pos)
	{
		return DoMethod (MUIM_NList_InsertSingle, entry, pos);
	}

	ULONG InsertSingleWrap (void)
	{
		return DoMethod (MUIM_NList_InsertSingleWrap);
	}

	ULONG InsertWrap (Type * * entries)
	{
		return DoMethod (MUIM_NList_InsertWrap, entries);
	}

	ULONG Jump (LONG pos)
	{
		return DoMethod (MUIM_NList_Jump, pos);
	}

	ULONG Move (LONG from, LONG to)
	{
		return DoMethod (MUIM_NList_Move, from, to);
	}

	ULONG NextSelected (LONG * pos)
	{
		return DoMethod (MUIM_NList_NextSelected, pos);
	}

	ULONG Redraw (LONG pos)
	{
		return DoMethod (MUIM_NList_Redraw, pos);
	}

	ULONG Remove (LONG pos)
	{
		return DoMethod (MUIM_NList_Remove, pos);
	}

	ULONG ReplaceSingle (LONG pos, LONG seltype, LONG * state)
	{
		return DoMethod (MUIM_NList_ReplaceSingle, pos, seltype, state);
	}

	ULONG Sort (void)
	{
		return DoMethod (MUIM_NList_Sort);
	}

	ULONG TestPos (LONG x, LONG y, struct MUI_NList_TestPos_Result * res)
	{
		return DoMethod (MUIM_NList_TestPos, x, y, res);
	}

	ULONG UseImage (Object * obj, ULONG imgnum, ULONG flags)
	{
		return DoMethod (MUIM_NList_UseImage, obj, imgnum, flags);
	}

};

#endif	/* MUIPP_TEMPLATES */
