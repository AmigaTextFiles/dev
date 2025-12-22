
#include "tek/util.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TTAG TGetTagValue(TTAG tag, TTAG defaultvalue, TTAGITEM *taglist)
**
**	get single tag value
**
*/

TTAG TGetTagValue(TTAG tag, TTAG defaultvalue, TTAGITEM *taglist)
{
	if (taglist)
	{
		while (taglist->tag != TTAG_DONE)
		{
			if (taglist->tag == (TTAG) TTAG_MORE)
			{
				taglist = (TTAGITEM *) taglist->value;
			}
			else
			{
				if (taglist->tag == tag)
				{
					return taglist->value;
				}
				taglist++;
			}
		}
	}

	return defaultvalue;
}
