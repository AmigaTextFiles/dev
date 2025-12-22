#include <libraries/mui.hpp>
#include <mui/HTMLtext_mcc.h>
#include <stdarg.h>
/***************************************************************************
**                      CMUI_HTMLtext class definition                      
***************************************************************************/
#if defined(__GNUC__)
//#pragma pack(2)
#endif
class CMUI_HTMLtext : public CMUI_Virtgroup
{
public:
	CMUI_HTMLtext (void)
	: CMUI_Virtgroup ()
	{
	}

	CMUI_HTMLtext (struct TagItem *tags)
	: CMUI_Virtgroup ()
	{
		object = MUI_NewObjectA (MUIC_HTMLtext, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_HTMLtext object\n");
#endif
	}

	CMUI_HTMLtext (/*ULONG zero,...*/Tag tag, ...);//__attribute__((varargs68k));

	CMUI_HTMLtext (Object * obj)
	: CMUI_Virtgroup ()
	{
		object = obj;
	}

	CMUI_HTMLtext & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	char * Block (void) const
	{
		 return (char *)MGetAttr (MUIA_HTMLtext_Block);
	}

	STRPTR Contents (void) const
	{
		 return (STRPTR)MGetAttr (MUIA_HTMLtext_Contents);
	}

	void SetContents (STRPTR value)
	{
		 MSetAttr (MUIA_HTMLtext_Contents, (ULONG)value);
	}

	BOOL MDoubleClick (void) const
	{
		 return (BOOL)MGetAttr (MUIA_HTMLtext_DoubleClick);
	}

	void SetLoadImages (BOOL value)
	{
		 MSetAttr (MUIA_HTMLtext_LoadImages, (ULONG)value);
	}

	void SetOpenURLHook (struct Hook * value)
	{
		 MSetAttr (MUIA_HTMLtext_OpenURLHook, (ULONG)value);
	}

	STRPTR Path (void) const
	{
		 return (STRPTR)MGetAttr (MUIA_HTMLtext_Path);
	}

	void SetPath (STRPTR value)
	{
		 MSetAttr (MUIA_HTMLtext_Path, (ULONG)value);
	}

	STRPTR Title (void) const
	{
		 return (STRPTR)MGetAttr (MUIA_HTMLtext_Title);
	}

	STRPTR URL (void) const
	{
		 return (STRPTR)MGetAttr (MUIA_HTMLtext_URL);
	}

	void SetURL (STRPTR value)
	{
		 MSetAttr (MUIA_HTMLtext_URL, (ULONG)value);
	}

};
inline CMUI_HTMLtext::CMUI_HTMLtext (/*ULONG zero,...*/Tag tag, ...): CMUI_Virtgroup ()
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
      object = MUI_NewObjectA (MUIC_HTMLtext,(struct TagItem *)array);//va->overflow_arg_area /*(struct TagItem *)&tag1*/);
      FreeVecPooled(poolHeader,array);
   }
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_HTMLtext object\n");
#endif
}

class Custom_Class_HTMLtext : public Custom_Object, public CMUI_HTMLtext
{

    public:


    Custom_Class_HTMLtext(const char *name): CMUI_HTMLtext ()
    {

         RegC=ClasesNameSpace->RegisterClass(name);
         if (RegC->NewClass)
         {
            NewClass=RegC->NewClass;

         }
         else
         {
            NewClass=MUI_CreateCustomClass (NULL, MUIC_HTMLtext,NULL,sizeof(InformationObject ),&GATE_CustomClass_Dispatcher);
            RegC->NewClass=NewClass;
         }
         mcc_Class=RegC->NewClass->mcc_Class;

    }
    virtual ~Custom_Class_HTMLtext()
    {

	}

    inline DECLARE_CCLASS(Custom_Class_HTMLtext)

};
inline BEGIN_DEF_CCLASS(Custom_Class_HTMLtext)
END_DEF_CCLASS


#if defined(__GNUC__)
//#pragma pack()
#endif

