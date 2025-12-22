#include <libraries/mui.hpp>
#include <mui/NList_mcc.hpp>
#include <mui/NListview_mcc.h>
#include <cstdarg>
using namespace std;

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

	CMUI_NListview (Tag tag, ...);

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
		 return (LONG)MGetAttr (MUIA_Group_ActivePage);
	}

	void SetActivePage (LONG value)
	{
		 MSetAttr (MUIA_Group_ActivePage, (ULONG)value);
	}

	struct List * ChildList (void) const
	{
		 return (struct List *)MGetAttr (MUIA_Group_ChildList);
	}

	void SetColumns (LONG value)
	{
		 MSetAttr (MUIA_Group_Columns, (ULONG)value);
	}

	LONG HorizSpacing (void) const
	{
		 return (LONG)MGetAttr (MUIA_Group_HorizSpacing);
	}

	void SetHorizSpacing (LONG value)
	{
		 MSetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
	}

	void SetRows (LONG value)
	{
		 MSetAttr (MUIA_Group_Rows, (ULONG)value);
	}

	void SetSpacing (LONG value)
	{
		 MSetAttr (MUIA_Group_Spacing, (ULONG)value);
	}

	LONG VertSpacing (void) const
	{
		 return (LONG)MGetAttr (MUIA_Group_VertSpacing);
	}

	void SetVertSpacing (LONG value)
	{
		 MSetAttr (MUIA_Group_VertSpacing, (ULONG)value);
	}

	ULONG ExitChange (void)
	{
		return MDoMethod (MUIM_Group_ExitChange);
	}

	ULONG InitChange (void)
	{
		return MDoMethod (MUIM_Group_InitChange);
	}

	ULONG Sort (StartVarArgs sva, Object * obj, ...)
	{
		sva.methodID = MUIM_Group_Sort;
		return MDoMethodA ((Msg)&sva);
	}

	Object * Horiz_ScrollBar (void) const
	{
		 return (Object *)MGetAttr (MUIA_NListview_Horiz_ScrollBar);
	}

	void SetHoriz_ScrollBar (Object * value)
	{
		 MSetAttr (MUIA_NListview_Horiz_ScrollBar, (ULONG)value);
	}

	Object * NList (void) const
	{
		 return (Object *)MGetAttr (MUIA_NListview_NList);
	}

	Object * Vert_ScrollBar (void) const
	{
		 return (Object *)MGetAttr (MUIA_NListview_Vert_ScrollBar);
	}

	void SetVert_ScrollBar (Object * value)
	{
		 MSetAttr (MUIA_NListview_Vert_ScrollBar, (ULONG)value);
	}

};

inline CMUI_NListview::CMUI_NListview (Tag tag, ...)
	: CMUI_NList ()
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

      object = MUI_NewObjectA (MUIC_NListview, (struct TagItem *)array/*(struct TagItem *)&tag1*/);
      FreeVecPooled(poolHeader,array);
   }
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_NListview object\n");
#endif
}

class Custom_Class_NListview  : public Custom_Object, public CMUI_NListview
{

    public:
    Custom_Class_NListview(const char *name): CMUI_NListview ()
    {

         RegC=ClasesNameSpace->RegisterClass(name);
         if (RegC->NewClass)
         {
            NewClass=RegC->NewClass;

         }
         else
         {
            NewClass=MUI_CreateCustomClass (NULL, MUIC_NListview,NULL,sizeof(InformationObject ),&GATE_CustomClass_Dispatcher);
            RegC->NewClass=NewClass;
         }
         mcc_Class=RegC->NewClass->mcc_Class;

    }
    virtual ~Custom_Class_NListview()
    {

	}

    inline DECLARE_CCLASS(Custom_Class_NListview)

};
inline BEGIN_DEF_CCLASS(Custom_Class_NListview)
END_DEF_CCLASS


#ifdef MUIPP_TEMPLATES

/***************************************************************************
**                     CTMUI_NListview class definition
***************************************************************************/
extern "C++" {
template <class Type>
class CTMUI_NListview : public CTMUI_NList<Type>
{
public:
	CTMUI_NListview (void)
	: CTMUI_NList<Type> ()
	{
	}

	CTMUI_NListview (/*Tag tag1,*/ULONG zero, ...)__attribute__((varargs68k));
	
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
		 return (LONG)MGetAttr (MUIA_Group_ActivePage);
	}

	void SetActivePage (LONG value)
	{
		 MSetAttr (MUIA_Group_ActivePage, (ULONG)value);
	}

	struct List * ChildList (void) const
	{
		 return (struct List *)MGetAttr (MUIA_Group_ChildList);
	}

	void SetColumns (LONG value)
	{
		 MSetAttr (MUIA_Group_Columns, (ULONG)value);
	}

	LONG HorizSpacing (void) const
	{
		 return (LONG)MGetAttr (MUIA_Group_HorizSpacing);
	}

	void SetHorizSpacing (LONG value)
	{
		 MSetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
	}

	void SetRows (LONG value)
	{
		 MSetAttr (MUIA_Group_Rows, (ULONG)value);
	}

	void SetSpacing (LONG value)
	{
		 MSetAttr (MUIA_Group_Spacing, (ULONG)value);
	}

	LONG VertSpacing (void) const
	{
		 return (LONG)MGetAttr (MUIA_Group_VertSpacing);
	}

	void SetVertSpacing (LONG value)
	{
		 MSetAttr (MUIA_Group_VertSpacing, (ULONG)value);
	}

	ULONG ExitChange (void)
	{
		return MDoMethod (MUIM_Group_ExitChange);
	}

	ULONG InitChange (void)
	{
		return MDoMethod (MUIM_Group_InitChange);
	}

	ULONG Sort (StartVarArgs sva, Object * obj, ...)
	{
		sva.methodID = MUIM_Group_Sort;
		return MDoMethodA ((Msg)&sva);
	}

	Object * Horiz_ScrollBar (void) const
	{
		 return (Object *)MGetAttr (MUIA_NListview_Horiz_ScrollBar);
	}

	void SetHoriz_ScrollBar (Object * value)
	{
		 MSetAttr (MUIA_NListview_Horiz_ScrollBar, (ULONG)value);
	}

	Object * NList (void) const
	{
		 return (Object *)MGetAttr (MUIA_NListview_NList);
	}

	Object * Vert_ScrollBar (void) const
	{
		 return (Object *)MGetAttr (MUIA_NListview_Vert_ScrollBar);
	}

	void SetVert_ScrollBar (Object * value)
	{
		 MSetAttr (MUIA_NListview_Vert_ScrollBar, (ULONG)value);
	}
};
template <class Type>
inline CTMUI_NListview<Type>::CTMUI_NListview (Tag tag, ...)
	: CTMUI_NList<Type> ()
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
      object = MUI_NewObjectA (MUIC_NListview,(struct TagItem *)array);
      FreeVecPooled(poolHeader,array);
   }
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CTMUI_NListview object\n");
#endif
}
template <class Type>
class Custom_Class_TmpNListview  : public Custom_Object, public CTMUI_NListview<Type>
{

    public:
    Custom_Class_TmpNListview(const char *name): CTMUI_NListview<Type> ()
    {

         RegC=ClasesNameSpace->RegisterClass(name);
         if (RegC->NewClass)
         {
            NewClass=RegC->NewClass;

         }
         else
         {
            NewClass=MUI_CreateCustomClass (NULL, MUIC_NListview,NULL,sizeof(InformationObject ),&GATE_CustomClass_Dispatcher);
            RegC->NewClass=NewClass;
         }
         mcc_Class=RegC->NewClass->mcc_Class;

    }
    virtual ~Custom_Class_TmpNListview()
    {

	}

   // inline DECLARE_CCLASS(Custom_Class_TmpListview)

};
/*inline BEGIN_DEF_CCLASS(Custom_Class_TmpListview)
END_DEF_CCLASS  */
}
#endif
