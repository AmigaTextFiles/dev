#include <libraries/mui.hpp>
#include <mui/HTMLtext_mcc.h>

/***************************************************************************
**                      CMUI_HTMLtext class definition                      
***************************************************************************/

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

	CMUI_HTMLtext (Tag tag1, ...)
	: CMUI_Virtgroup ()
	{
		object = MUI_NewObjectA (MUIC_HTMLtext, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_HTMLtext object\n");
#endif
	}

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
		 return (char *)GetAttr (MUIA_HTMLtext_Block);
	}

	STRPTR Contents (void) const
	{
		 return (STRPTR)GetAttr (MUIA_HTMLtext_Contents);
	}

	void SetContents (STRPTR value)
	{
		 SetAttr (MUIA_HTMLtext_Contents, (ULONG)value);
	}

	BOOL DoubleClick (void) const
	{
		 return (BOOL)GetAttr (MUIA_HTMLtext_DoubleClick);
	}

	void SetLoadImages (BOOL value)
	{
		 SetAttr (MUIA_HTMLtext_LoadImages, (ULONG)value);
	}

	void SetOpenURLHook (struct Hook * value)
	{
		 SetAttr (MUIA_HTMLtext_OpenURLHook, (ULONG)value);
	}

	STRPTR Path (void) const
	{
		 return (STRPTR)GetAttr (MUIA_HTMLtext_Path);
	}

	void SetPath (STRPTR value)
	{
		 SetAttr (MUIA_HTMLtext_Path, (ULONG)value);
	}

	STRPTR Title (void) const
	{
		 return (STRPTR)GetAttr (MUIA_HTMLtext_Title);
	}

	STRPTR URL (void) const
	{
		 return (STRPTR)GetAttr (MUIA_HTMLtext_URL);
	}

	void SetURL (STRPTR value)
	{
		 SetAttr (MUIA_HTMLtext_URL, (ULONG)value);
	}

};

