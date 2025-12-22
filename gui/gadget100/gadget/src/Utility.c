/*
**	Utility.c:	Utility-Routinen für 1.3
**
**	Falls OS 2 läuft, so werden die Utility.Library-Funktionen aufgerufen.
**
**	08.09.92 - 08.09.92
*/

#include <utility/hooks.h>
#include <utility/tagitem.h>
#include <pragma/utility_lib.h>
#include "utility.pro"

extern struct Library *UtilityBase;

extern ULONG MyCallHookPkt(struct Hook *hook, APTR object ,APTR message);
#pragma regcall(MyCallHookPkt(a0, a2, a1))

ULONG CallHookPkt13(struct Hook *hook, APTR object ,APTR message)
{
	ULONG ret;

	if(UtilityBase)
      ret = CallHookPkt(hook, object, message);
	else
      ret = MyCallHookPkt(hook, object, message);
	return(ret);
}

#asm
	public _MyCallHookPkt
_MyCallHookPkt:
	jmp		8(a0)
#endasm


struct TagItem *FindTagItem13(Tag tagValue, struct TagItem *tagList)
{
	struct TagItem *ret;

	if(UtilityBase)
		ret = FindTagItem(tagValue, tagList);
	else
	{
		while(ret = NextTagItem13(&tagList))
			if(ret->ti_Tag == tagValue)
				break;
	}
	return(ret);
}

ULONG GetTagData13(Tag tagValue, ULONG defaultVal, struct TagItem *tagList)
{
	ULONG ret;

	if(UtilityBase)
		ret =	GetTagData(tagValue, defaultVal, tagList);
	else
	{
		struct TagItem *tag;

		ret = defaultVal;
		while(tag = NextTagItem13(&tagList))
			if(tag->ti_Tag == tagValue)
			{
				ret = tag->ti_Data;
				break;
			}
	}
	return(ret);
}

struct TagItem *NextTagItem13(struct TagItem **tagItemPtr)
{
	struct TagItem *ret;

	if(UtilityBase)
		ret = NextTagItem(tagItemPtr);
	else
	{
		ret = NULL;
		if(tagItemPtr && *tagItemPtr)
		{
			FOREVER
			{
	         ret = (*tagItemPtr)++;
				switch(ret->ti_Tag)
				{
            	case TAG_DONE:		return(NULL);
											break;
					case TAG_IGNORE:  break;
					case TAG_MORE:		*tagItemPtr = (struct TagItem *)ret->ti_Data;
											break;
               case TAG_SKIP:		*tagItemPtr += ret->ti_Data;
											break;
               default:				return(ret);
											break;
				}
         }
      }
	}
	return(ret);
}

ULONG PackBoolTags13(ULONG initialFlags, struct TagItem *tagList, struct TagItem *boolMap)
{
	ULONG ret;

	if(UtilityBase)
      ret = PackBoolTags(initialFlags, tagList, boolMap);
	else
	{
      struct TagItem *tag;
      struct TagItem *bool;

		ret = initialFlags;
		while(tag = NextTagItem13(&tagList))
			if(bool = FindTagItem13(tag->ti_Tag, boolMap))
				if(tag->ti_Data)
            	ret |= bool->ti_Data;
				else
					ret &= ~(bool->ti_Data);
	}
	return(ret);
}

BOOL TagInArray13(Tag tagValue, Tag *tagArray)
{
	BOOL ret;

	if(UtilityBase)
		ret = TagInArray(tagValue, tagArray);
	else
	{
		ret = FALSE;
		if(tagArray)
      	while(*tagArray != TAG_DONE)
         	if(*tagArray++ == tagValue)
				{
					ret = TRUE;
					break;
				}
	}
	return(ret);
}
