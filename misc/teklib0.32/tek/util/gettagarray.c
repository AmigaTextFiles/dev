
#include "tek/util.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT TGetTagArray(TTAGITEM *taglist, TTAG *tagarray)
**
**	get tag array
**
*/

TUINT TGetTagArray(TTAGITEM *taglist, TTAG *tagarray)
{
	TUINT num = 0;
	if (taglist)
	{
		TTAGITEM *temp;
		while (*tagarray != TTAG_DONE)
		{
			temp = taglist;
			while (temp->tag != TTAG_DONE)
			{
				if (temp->tag == (TTAG) TTAG_MORE)
				{
					temp = (TTAGITEM *) temp->value;
				}
				else
				{
					if (temp->tag == *tagarray)
					{
						*((TTAG *) *(tagarray + 1)) = temp->value;
						num++;
						break;
					}
					temp++;
				}
			}
			tagarray += 2;
		}
	}
	return num;
}
