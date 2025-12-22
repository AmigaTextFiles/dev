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
	    MDoMethod (MUIM_NList_GetEntry, pos, &entry);
	    return entry;
	}
	
	// This method is a convienient alternative to the Entries attribute
	
	LONG Length (void) const
	{
		return (LONG)MGetAttr (MUIA_NList_Entries);
	}
	
	// This method can be used to retrieve the number of selected entries
	// in a list
	
	ULONG NumSelected (void)
	{
		ULONG numSelected;
		MDoMethod (MUIM_NList_Select, MUIV_NList_Select_All, MUIV_NList_Select_Ask, &numSelected);
		return numSelected;
	}
	
	// These methods can be used as shortcuts for inserting objects into lists
	
	void MAddHead (APTR entry)
	{
		MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Top);
	}
	
	void MAddTail (APTR entry)
	{
		MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Bottom);
	}
	
	void InsertTop (APTR entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Top);
	}
	
	void InsertBottom (APTR entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Bottom);
	}
	
	void InsertSorted (APTR entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Sorted);
	}
	
	void InsertActive (APTR entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Active);
	}
	
	
	LONG Active (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Active);
	}

	void SetActive (LONG value)
	{
		 MSetAttr (MUIA_NList_Active, (ULONG)value);
	}

	void SetAutoCopyToClip (BOOL value)
	{
		 MSetAttr (MUIA_NList_AutoCopyToClip, (ULONG)value);
	}

	BOOL AutoVisible (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_AutoVisible);
	}

	void SetAutoVisible (BOOL value)
	{
		 MSetAttr (MUIA_NList_AutoVisible, (ULONG)value);
	}

	LONG ClickColumn (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_ClickColumn);
	}

	void SetCompareHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_CompareHook, (ULONG)value);
	}

	void SetConstructHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_ConstructHook, (ULONG)value);
	}

	void SetCopyColumnToClipHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_CopyColumnToClipHook, (ULONG)value);
	}

	void SetCopyEntryToClipHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_CopyEntryToClipHook, (ULONG)value);
	}

	void SetDefaultObjectOnClick (BOOL value)
	{
		 MSetAttr (MUIA_NList_DefaultObjectOnClick, (ULONG)value);
	}

	LONG DefClickColumn (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_DefClickColumn);
	}

	void SetDefClickColumn (LONG value)
	{
		 MSetAttr (MUIA_NList_DefClickColumn, (ULONG)value);
	}

	void SetDestructHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_DestructHook, (ULONG)value);
	}

	void SetDisplayHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_DisplayHook, (ULONG)value);
	}

	void SetDisplayRecall (BOOL value)
	{
		 MSetAttr (MUIA_NList_DisplayRecall, (ULONG)value);
	}

	BOOL MDoubleClick (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_DoubleClick);
	}

	BOOL DragSortable (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_DragSortable);
	}

	void SetDragSortable (BOOL value)
	{
		 MSetAttr (MUIA_NList_DragSortable, (ULONG)value);
	}

	LONG DragType (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_DragType);
	}

	void SetDragType (LONG value)
	{
		 MSetAttr (MUIA_NList_DragType, (ULONG)value);
	}

	LONG DropMark (void) const
	{
		 return (LONG)MGetAttr (MUIA_List_DropMark);
	}

	LONG Entries (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Entries);
	}

	BOOL EntryValueDependent (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_EntryValueDependent);
	}

	void SetEntryValueDependent (BOOL value)
	{
		 MSetAttr (MUIA_NList_EntryValueDependent, (ULONG)value);
	}

	LONG First (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_First);
	}

	void SetFirst (LONG value)
	{
		 MSetAttr (MUIA_NList_First, (ULONG)value);
	}

	STRPTR Format (void) const
	{
		 return (STRPTR)MGetAttr (MUIA_NList_Format);
	}

	void SetFormat (STRPTR value)
	{
		 MSetAttr (MUIA_NList_Format, (ULONG)value);
	}

	LONG HorizDeltaFactor (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_HorizDeltaFactor);
	}

	LONG Horiz_Entries (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Horiz_Entries);
	}

	LONG Horiz_First (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Horiz_First);
	}

	void SetHoriz_First (LONG value)
	{
		 MSetAttr (MUIA_NList_Horiz_First, (ULONG)value);
	}

	LONG Horiz_Visible (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Horiz_Visible);
	}

	BOOL MInput (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_Input);
	}

	void SetInput (BOOL value)
	{
		 MSetAttr (MUIA_NList_Input, (ULONG)value);
	}

	LONG InsertPosition (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_InsertPosition);
	}

	void SetKeepActive (Object * value)
	{
		 MSetAttr (MUIA_NList_KeepActive, (ULONG)value);
	}

	void SetMakeActive (Object * value)
	{
		 MSetAttr (MUIA_NList_MakeActive, (ULONG)value);
	}

	void SetMinLineHeight (LONG value)
	{
		 MSetAttr (MUIA_NList_MinLineHeight, (ULONG)value);
	}

	BOOL MultiClick (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_MultiClick);
	}

	void SetMultiTestHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_MultiTestHook, (ULONG)value);
	}

	APTR PrivateData (void) const
	{
		 return (APTR)MGetAttr (MUIA_NList_PrivateData);
	}

	void SetPrivateData (APTR value)
	{
		 MSetAttr (MUIA_NList_PrivateData, (ULONG)value);
	}

	LONG Prop_Entries (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Prop_Entries);
	}

	LONG Prop_First (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Prop_First);
	}

	void SetProp_First (LONG value)
	{
		 MSetAttr (MUIA_NList_Prop_First, (ULONG)value);
	}

	LONG Prop_Visible (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Prop_Visible);
	}

	void SetQuiet (BOOL value)
	{
		 MSetAttr (MUIA_NList_Quiet, (ULONG)value);
	}

	BOOL ShowDropMarks (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_ShowDropMarks);
	}

	void SetShowDropMarks (BOOL value)
	{
		 MSetAttr (MUIA_NList_ShowDropMarks, (ULONG)value);
	}

	char * SkipChars (void) const
	{
		 return (char *)MGetAttr (MUIA_NList_SkipChars);
	}

	void SetSkipChars (char * value)
	{
		 MSetAttr (MUIA_NList_SkipChars, (ULONG)value);
	}

	ULONG TabSize (void) const
	{
		 return (ULONG)MGetAttr (MUIA_NList_TabSize);
	}

	void SetTabSize (ULONG value)
	{
		 MSetAttr (MUIA_NList_TabSize, (ULONG)value);
	}

	char * Title (void) const
	{
		 return (char *)MGetAttr (MUIA_NList_Title);
	}

	void SetTitle (char * value)
	{
		 MSetAttr (MUIA_NList_Title, (ULONG)value);
	}

	BOOL TitleSeparator (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_TitleSeparator);
	}

	void SetTitleSeparator (BOOL value)
	{
		 MSetAttr (MUIA_NList_TitleSeparator, (ULONG)value);
	}

	void SetTypeSelect (LONG value)
	{
		 MSetAttr (MUIA_NList_TypeSelect, (ULONG)value);
	}

	LONG VertDeltaFactor (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_VertDeltaFactor);
	}

	LONG Visible (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Visible);
	}

	LONG TitleBackground (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_TitleBackground);
	}

	void SetTitleBackground (LONG value)
	{
		 MSetAttr (MUIA_NList_TitleBackground, (ULONG)value);
	}

	LONG TitlePen (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_TitlePen);
	}

	void SetTitlePen (LONG value)
	{
		 MSetAttr (MUIA_NList_TitlePen, (ULONG)value);
	}

	ULONG Clear (void)
	{
		return MDoMethod (MUIM_NList_Clear);
	}

	ULONG CopyToClip (LONG pos, ULONG clipnum)
	{
		return MDoMethod (MUIM_NList_CopyToClip, pos, clipnum);
	}

	ULONG CreateImage (Object * imgobj, ULONG flags)
	{
		return MDoMethod (MUIM_NList_CreateImage, imgobj, flags);
	}

	ULONG DeleteImage (APTR listimg)
	{
		return MDoMethod (MUIM_NList_DeleteImage, listimg);
	}

	ULONG Exchange (LONG pos1, LONG pos2)
	{
		return MDoMethod (MUIM_NList_Exchange, pos1, pos2);
	}

	ULONG GetEntry (LONG pos, APTR * entry)
	{
		return MDoMethod (MUIM_NList_GetEntry, pos, entry);
	}

	ULONG GetEntryInfo (struct MUI_NList_GetEntryInfo * res)
	{
		return MDoMethod (MUIM_NList_GetEntryInfo, res);
	}

	ULONG MInsert (APTR * entries, LONG count, LONG pos)
	{
		return MDoMethod (MUIM_NList_Insert, entries, count, pos);
	}

	ULONG InsertSingle (APTR entry, LONG pos)
	{
		return MDoMethod (MUIM_NList_InsertSingle, entry, pos);
	}

	ULONG InsertSingleWrap (void)
	{
		return MDoMethod (MUIM_NList_InsertSingleWrap);
	}

	ULONG InsertWrap (APTR * entries)
	{
		return MDoMethod (MUIM_NList_InsertWrap, entries);
	}

	ULONG Jump (LONG pos)
	{
		return MDoMethod (MUIM_NList_Jump, pos);
	}

	ULONG Move (LONG from, LONG to)
	{
		return MDoMethod (MUIM_NList_Move, from, to);
	}

	ULONG NextSelected (LONG * pos)
	{
		return MDoMethod (MUIM_NList_NextSelected, pos);
	}

	ULONG Redraw (LONG pos)
	{
		return MDoMethod (MUIM_NList_Redraw, pos);
	}

	ULONG MRemove (LONG pos)
	{
		return MDoMethod (MUIM_NList_Remove, pos);
	}

	ULONG ReplaceSingle (LONG pos, LONG seltype, LONG * state)
	{
		return MDoMethod (MUIM_NList_ReplaceSingle, pos, seltype, state);
	}

	ULONG Sort (void)
	{
		return MDoMethod (MUIM_NList_Sort);
	}

	ULONG TestPos (LONG x, LONG y, struct MUI_NList_TestPos_Result * res)
	{
		return MDoMethod (MUIM_NList_TestPos, x, y, res);
	}

	ULONG UseImage (Object * obj, ULONG imgnum, ULONG flags)
	{
		return MDoMethod (MUIM_NList_UseImage, obj, imgnum, flags);
	}

};
inline CMUI_NList (Tag tag, ...) : CMUI_Area ()
{
    va_list va;
    ULONG i;
    ULONG *array;
    ULONG Count;
    va_start(va,tag);
    Count=0;
    i=tag;
    while((i&&(i!=TAG_DONE))||(Count&1))
    {
         if ((i==TAG_MORE)&&((Count&1)==0))
         if (i==TAG_MORE)
         {
         	Count+=va_arg(va,ULONG)+1;
            i=0;
         }
         else
         {
         	i=va_arg(va,ULONG);
         	Count++;
         }
    }
    va_end(va);
    array=(ULONG *)AllocVecPooled(poolHeader,(sizeof(ULONG)*(Count+1)));
    object=NULL;
    if (array)
   {
      array[0]=tag;
      va_start(va,tag);
      for (i=1;i<=Count;i++)
      {
        array[i]=va_arg(va,ULONG);
      }
      va_end(va);

      object = MUI_NewObjectA (MUIC_NList, (struct TagItem *)array);
      FreeVecPooled(poolHeader,array);
   }
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_NList object\n");
#endif
}



class Custom_Class_NList  : public Custom_Object, public CMUI_NList
{

    public:
    Custom_Class_NList(const char *name): CMUI_NList ()
    {

         RegC=ClasesNameSpace->RegisterClass(name);
         if (RegC->NewClass)
         {
            NewClass=RegC->NewClass;

         }
         else
         {
            NewClass=MUI_CreateCustomClass (NULL, MUIC_NList,NULL,sizeof(InformationObject ),&GATE_CustomClass_Dispatcher);
            RegC->NewClass=NewClass;
         }
         mcc_Class=RegC->NewClass->mcc_Class;

    }
    virtual ~Custom_Class_NList()
    {

	}

    inline DECLARE_CCLASS(Custom_Class_NList)

};
inline BEGIN_DEF_CCLASS(Custom_Class_NList)
END_DEF_CCLASS
#ifdef MUIPP_TEMPLATES

/***************************************************************************
**                       CMUI_NList class definition
***************************************************************************/
extern "C++" {
template <class Type>
class CTMUI_NList : public CMUI_Area
{
public:
	CTMUI_NList (void)
	: CMUI_Area ()
	{
	}

	CTMUI_NList (Tag tag, ...);
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
	    MDoMethod (MUIM_NList_GetEntry, pos, &entry);
#ifdef MUIPP_DEBUG
		if (entry == NULL)
			_MUIPPError ("Index into CTMUI_NList is out of range:\n"
						 "Index = %d, length = %d\n",
						 (int)pos,
						 (int)MGetAttr(MUIA_NList_Entries));
#endif
	    return *entry;
	}

	// This method is a convienient alternative to the Entries attribute

	LONG Length (void) const
	{
		return (LONG)MGetAttr (MUIA_NList_Entries);
	}

	// This method can be used to retrieve the number of selected entries
	// in a list

	ULONG NumSelected (void)
	{
		ULONG numSelected;
		MDoMethod (MUIM_NList_Select, MUIV_NList_Select_All, MUIV_NList_Select_Ask, &numSelected);
		return numSelected;
	}

	// These methods can be used as shortcuts for inserting objects into lists

	void MAddHead (Type * entry)
	{
		MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Top);
	}

	void MAddHead (Type & entry)
	{
		MDoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Top);
	}

	void MAddTail (Type * entry)
	{
		MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Bottom);
	}

	void MAddTail (Type & entry)
	{
		MDoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Bottom);
	}

	void InsertTop (Type * entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Top);
	}

	void InsertTop (Type & entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Top);
	}

	void InsertBottom (Type * entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Bottom);
	}

	void InsertBottom (Type & entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Bottom);
	}

	void InsertSorted (Type * entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Sorted);
	}

	void InsertSorted (Type & entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Sorted);
	}

	void InsertActive (Type * entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Active);
	}

	void InsertActive (Type & entry)
	{
	    MDoMethod (MUIM_NList_InsertSingle, &entry, MUIV_NList_Insert_Active);
	}

	LONG Active (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Active);
	}

	void SetActive (LONG value)
	{
		 MSetAttr (MUIA_NList_Active, (ULONG)value);
	}

	void SetAutoCopyToClip (BOOL value)
	{
		 MSetAttr (MUIA_NList_AutoCopyToClip, (ULONG)value);
	}

	BOOL AutoVisible (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_AutoVisible);
	}

	void SetAutoVisible (BOOL value)
	{
		 MSetAttr (MUIA_NList_AutoVisible, (ULONG)value);
	}

	LONG ClickColumn (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_ClickColumn);
	}

	void SetCompareHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_CompareHook, (ULONG)value);
	}

	void SetConstructHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_ConstructHook, (ULONG)value);
	}

	void SetCopyColumnToClipHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_CopyColumnToClipHook, (ULONG)value);
	}

	void SetCopyEntryToClipHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_CopyEntryToClipHook, (ULONG)value);
	}

	void SetDefaultObjectOnClick (BOOL value)
	{
		 MSetAttr (MUIA_NList_DefaultObjectOnClick, (ULONG)value);
	}

	LONG DefClickColumn (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_DefClickColumn);
	}

	void SetDefClickColumn (LONG value)
	{
		 MSetAttr (MUIA_NList_DefClickColumn, (ULONG)value);
	}

	void SetDestructHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_DestructHook, (ULONG)value);
	}

	void SetDisplayHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_DisplayHook, (ULONG)value);
	}

	void SetDisplayRecall (BOOL value)
	{
		 MSetAttr (MUIA_NList_DisplayRecall, (ULONG)value);
	}

	BOOL MDoubleClick (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_DoubleClick);
	}

	BOOL DragSortable (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_DragSortable);
	}

	void SetDragSortable (BOOL value)
	{
		 MSetAttr (MUIA_NList_DragSortable, (ULONG)value);
	}

	LONG DragType (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_DragType);
	}

	void SetDragType (LONG value)
	{
		 MSetAttr (MUIA_NList_DragType, (ULONG)value);
	}

	LONG DropMark (void) const
	{
		 return (LONG)MGetAttr (MUIA_List_DropMark);
	}

	LONG Entries (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Entries);
	}

	BOOL EntryValueDependent (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_EntryValueDependent);
	}

	void SetEntryValueDependent (BOOL value)
	{
		 MSetAttr (MUIA_NList_EntryValueDependent, (ULONG)value);
	}

	LONG First (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_First);
	}

	void SetFirst (LONG value)
	{
		 MSetAttr (MUIA_NList_First, (ULONG)value);
	}

	STRPTR Format (void) const
	{
		 return (STRPTR)MGetAttr (MUIA_NList_Format);
	}

	void SetFormat (STRPTR value)
	{
		 MSetAttr (MUIA_NList_Format, (ULONG)value);
	}

	LONG HorizDeltaFactor (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_HorizDeltaFactor);
	}

	LONG Horiz_Entries (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Horiz_Entries);
	}

	LONG Horiz_First (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Horiz_First);
	}

	void SetHoriz_First (LONG value)
	{
		 MSetAttr (MUIA_NList_Horiz_First, (ULONG)value);
	}

	LONG Horiz_Visible (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Horiz_Visible);
	}

	BOOL Input (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_Input);
	}

	void SetInput (BOOL value)
	{
		 MSetAttr (MUIA_NList_Input, (ULONG)value);
	}

	LONG InsertPosition (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_InsertPosition);
	}

	void SetKeepActive (Object * value)
	{
		 MSetAttr (MUIA_NList_KeepActive, (ULONG)value);
	}

	void SetMakeActive (Object * value)
	{
		 MSetAttr (MUIA_NList_MakeActive, (ULONG)value);
	}

	void SetMinLineHeight (LONG value)
	{
		 MSetAttr (MUIA_NList_MinLineHeight, (ULONG)value);
	}

	BOOL MultiClick (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_MultiClick);
	}

	void SetMultiTestHook (struct Hook * value)
	{
		 MSetAttr (MUIA_NList_MultiTestHook, (ULONG)value);
	}

	APTR PrivateData (void) const
	{
		 return (APTR)MGetAttr (MUIA_NList_PrivateData);
	}

	void SetPrivateData (APTR value)
	{
		 MSetAttr (MUIA_NList_PrivateData, (ULONG)value);
	}

	LONG Prop_Entries (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Prop_Entries);
	}

	LONG Prop_First (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Prop_First);
	}

	void SetProp_First (LONG value)
	{
		 MSetAttr (MUIA_NList_Prop_First, (ULONG)value);
	}

	LONG Prop_Visible (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Prop_Visible);
	}

	void SetQuiet (BOOL value)
	{
		 SetAttr (MUIA_NList_Quiet, (ULONG)value);
	}

	BOOL ShowDropMarks (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_ShowDropMarks);
	}

	void SetShowDropMarks (BOOL value)
	{
		 MSetAttr (MUIA_NList_ShowDropMarks, (ULONG)value);
	}

	char * SkipChars (void) const
	{
		 return (char *)MGetAttr (MUIA_NList_SkipChars);
	}

	void SetSkipChars (char * value)
	{
		 MSetAttr (MUIA_NList_SkipChars, (ULONG)value);
	}

	ULONG TabSize (void) const
	{
		 return (ULONG)MGetAttr (MUIA_NList_TabSize);
	}

	void SetTabSize (ULONG value)
	{
		 MSetAttr (MUIA_NList_TabSize, (ULONG)value);
	}

	char * Title (void) const
	{
		 return (char *)MGetAttr (MUIA_NList_Title);
	}

	void SetTitle (char * value)
	{
		 MSetAttr (MUIA_NList_Title, (ULONG)value);
	}

	BOOL TitleSeparator (void) const
	{
		 return (BOOL)MGetAttr (MUIA_NList_TitleSeparator);
	}

	void SetTitleSeparator (BOOL value)
	{
		 MSetAttr (MUIA_NList_TitleSeparator, (ULONG)value);
	}

	void SetTypeSelect (LONG value)
	{
		 MSetAttr (MUIA_NList_TypeSelect, (ULONG)value);
	}

	LONG VertDeltaFactor (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_VertDeltaFactor);
	}

	LONG Visible (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_Visible);
	}

	LONG TitleBackground (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_TitleBackground);
	}

	void SetTitleBackground (LONG value)
	{
		 MSetAttr (MUIA_NList_TitleBackground, (ULONG)value);
	}

	LONG TitlePen (void) const
	{
		 return (LONG)MGetAttr (MUIA_NList_TitlePen);
	}

	void SetTitlePen (LONG value)
	{
		 MSetAttr (MUIA_NList_TitlePen, (ULONG)value);
	}

	ULONG Clear (void)
	{
		return MDoMethod (MUIM_NList_Clear);
	}

	ULONG CopyToClip (LONG pos, ULONG clipnum)
	{
		return MDoMethod (MUIM_NList_CopyToClip, pos, clipnum);
	}

	ULONG CreateImage (Object * imgobj, ULONG flags)
	{
		return MDoMethod (MUIM_NList_CreateImage, imgobj, flags);
	}

	ULONG DeleteImage (APTR listimg)
	{
		return MDoMethod (MUIM_NList_DeleteImage, listimg);
	}

	ULONG Exchange (LONG pos1, LONG pos2)
	{
		return MDoMethod (MUIM_NList_Exchange, pos1, pos2);
	}

	ULONG GetEntry (LONG pos, Type * * entry)
	{
		return MDoMethod (MUIM_NList_GetEntry, pos, entry);
	}

	ULONG GetEntryInfo (struct MUI_NList_GetEntryInfo * res)
	{
		return MDoMethod (MUIM_NList_GetEntryInfo, res);
	}

	ULONG MInsert (Type * * entries, LONG count, LONG pos)
	{
		return MDoMethod (MUIM_NList_Insert, entries, count, pos);
	}

	ULONG InsertSingle (Type * entry, LONG pos)
	{
		return MDoMethod (MUIM_NList_InsertSingle, entry, pos);
	}

	ULONG InsertSingleWrap (void)
	{
		return MDoMethod (MUIM_NList_InsertSingleWrap);
	}

	ULONG InsertWrap (Type * * entries)
	{
		return MDoMethod (MUIM_NList_InsertWrap, entries);
	}

	ULONG Jump (LONG pos)
	{
		return MDoMethod (MUIM_NList_Jump, pos);
	}

	ULONG Move (LONG from, LONG to)
	{
		return MDoMethod (MUIM_NList_Move, from, to);
	}

	ULONG NextSelected (LONG * pos)
	{
		return MDoMethod (MUIM_NList_NextSelected, pos);
	}

	ULONG Redraw (LONG pos)
	{
		return MDoMethod (MUIM_NList_Redraw, pos);
	}

	ULONG MRemove (LONG pos)
	{
		return MDoMethod (MUIM_NList_Remove, pos);
	}

	ULONG ReplaceSingle (LONG pos, LONG seltype, LONG * state)
	{
		return MDoMethod (MUIM_NList_ReplaceSingle, pos, seltype, state);
	}

	ULONG Sort (void)
	{
		return MDoMethod (MUIM_NList_Sort);
	}

	ULONG TestPos (LONG x, LONG y, struct MUI_NList_TestPos_Result * res)
	{
		return MDoMethod (MUIM_NList_TestPos, x, y, res);
	}

	ULONG UseImage (Object * obj, ULONG imgnum, ULONG flags)
	{
		return MDoMethod (MUIM_NList_UseImage, obj, imgnum, flags);
	}

};
template <class Type>
inline CTMUI_NList<Type>:: CTMUI_NList (Tag tag, ...): CMUI_Area ()
{
    va_list va;
    ULONG i;
    ULONG *array;
    ULONG Count;
    va_start(va,tag);
    Count=0;
    i=tag;
    while((i&&(i!=TAG_DONE))||(Count&1))
    {
         if ((i==TAG_MORE)&&((Count&1)==0))
         {
         	Count+=va_arg(va,ULONG)+1;
            i=0;
         }
         else
         {
         	i=va_arg(va,ULONG);
         	Count++;
         }
    }
    va_end(va);
    array=(ULONG *)AllocVecPooled(poolHeader,(sizeof(ULONG)*(Count+1)));
    object=NULL;
    if (array)
   {
      array[0]=tag;
      va_start(va,tag);
      for (i=1;i<=Count;i++)
      {
        array[i]=va_arg(va,ULONG);
      }
      va_end(va);

      object = MUI_NewObjectA (MUIC_NList, (struct TagItem *)array);
      FreeVecPooled(poolHeader,array);
   }
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CTMUI_NList object\n");
#endif
}
template <class Type>
class Custom_Class_TmpNList  : public Custom_Object, public CTMUI_NList<Type>
{

    public:
    Custom_Class_TmpNList(const char *name): CTMUI_NList<Type> ()
    {

         RegC=ClasesNameSpace->RegisterClass(name);
         if (RegC->NewClass)
         {
            NewClass=RegC->NewClass;

         }
         else
         {
            NewClass=MUI_CreateCustomClass (NULL, MUIC_NList,NULL,sizeof(InformationObject ),&GATE_CustomClass_Dispatcher);
            RegC->NewClass=NewClass;
         }
         mcc_Class=RegC->NewClass->mcc_Class;

    }
    virtual ~Custom_Class_TmpNList()
    {

	}

    //inline DECLARE_CCLASS(Custom_Class_TmpNList)

};
/*inline BEGIN_DEF_CCLASS(Custom_Class_TmpNList)
END_DEF_CCLASS
*/
}

#endif	/* MUIPP_TEMPLATES */
