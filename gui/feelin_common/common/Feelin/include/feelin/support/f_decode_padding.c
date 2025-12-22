#include <stdlib.h>

///f_decode_padding
void f_decode_padding(STRPTR Spec, FPadding *Padding)
{
	STRPTR pad[] = { NULL, NULL, NULL, NULL };

	if (Spec != NULL)
	{
		uint8 c;
		uint8 n = 0;

		while (((c = *Spec) != '\0') && (n < 4))
		{
			if (c == ' ')
			{
				Spec++;
			}
			else
			{
				STRPTR start = Spec++;

				while ((c = *Spec) != '\0')
				{
					if (c != ' ')
					{
						Spec++;
					}
					else break;
				}

				pad[n++] = start;
			}
		}

		/* If there are four values, they apply to the top,  right,  bottom  and
		left, repectively */

		if (pad[3] != NULL)
		{
			Padding->t = atol(pad[0]);
			Padding->r = atol(pad[1]);
			Padding->b = atol(pad[2]);
			Padding->l = atol(pad[3]);
		}

		/* If there are three values, the top is set to  the  first  value,  the
		left and right are set to the second value, and the bottom is set to the
		third. */

		else if (pad[2] != NULL)
		{
			Padding->t = atol(pad[0]);
			Padding->l = Padding->r = atol(pad[1]);
			Padding->b = atol(pad[2]);
		}

		/* If there are two values, the top and bottom paddins are  set  to  the
		first value and the rights and left paddings are set to the second. */

		else if (pad[1] != NULL)
		{
			Padding->t = Padding->b = atol(pad[0]);
			Padding->l = Padding->r = atol(pad[1]);
		}

		/* if there is only one value, it applies to all sides. */

		else if (pad[0] != NULL)
		{
			Padding->t = Padding->b = Padding->l = Padding->r = atol(pad[0]);
		}
		else
		{
			Padding->t = Padding->b = Padding->l = Padding->r = 0;
		}
	}
	else
	{
		Padding->l = Padding->r = Padding->t = Padding->b = 0;
	}

	#ifdef DB_SUPPORT_PADDING_DECODE

	IFEELIN F_Log(0,"padding: %ld (0x%08lx) %ld (0x%08lx) %ld (0x%08lx) %ld (0x%08lx);",
		
		Padding->t,
		pad[0],
		Padding->r,
		pad[1],
		Padding->b,
		pad[2],
		Padding->l,
		pad[3]);

	#endif
}
//+

