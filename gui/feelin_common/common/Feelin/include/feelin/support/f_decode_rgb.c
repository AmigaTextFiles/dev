#ifndef FEELIN_SUPPORT_F_DECODE_RGB_C
#define FEELIN_SUPPORT_F_DECODE_RGB_H

#include <feelin/string.h>
#include <feelin/support/f_decode_rgb.h>

///f_decode_rgb
bool32 f_decode_rgb(STRPTR Spec, uint32 *ValuePtr)
{
	STRPTR rgb[] = { NULL, NULL, NULL };

	if (Spec != NULL)
	{
		uint8 c;
		uint8 n = 0;

		while (((c = *Spec) != '\0') && (n < 3))
		{
			if (c == ' ')
			{
				Spec++;
			}
			else
			{
				STRPTR start = Spec++;

				while (((c = *Spec) != 0) && (c != ' ') && (c != ',')) Spec++;

				rgb[n++] = start;

				while (((c = *Spec) != 0) && (c == ' ')) Spec++;

				if (c == ',')
				{
					*Spec++;
				}
				else break;
			}
		}
	}

	if ((rgb[0] != NULL) && (rgb[1] != NULL) && (rgb[2] != NULL))
	{
		uint32 r = 0;
		uint32 r_len;
		uint32 g = 0;
		uint32 g_len;
		uint32 b = 0;
		uint32 b_len;

		r_len = f_stcd(rgb[0], (int32 *) &r);
		g_len = f_stcd(rgb[1], (int32 *) &g);
		b_len = f_stcd(rgb[2], (int32 *) &b);

		if (r_len && g_len && b_len)
		{
			if (*((uint8 *)((uint32)(rgb[0]) + r_len)) == '%')
			{
				r = MIN(r, 100);
				r = r * 255 / 100;
			}
			else
			{
				r = MIN(r, 255);
			}

			if (*((uint8 *)((uint32)(rgb[1]) + g_len)) == '%')
			{
				g = MIN(g, 100);
				g = g * 255 / 100;
			}
			else
			{
				g = MIN(g, 255);
			}

			if (*((uint8 *)((uint32)(rgb[2]) + b_len)) == '%')
			{
				b = MIN(b, 100);
				b = b * 255 / 100;
			}
			else
			{
				b = MIN(b, 255);
			}

			#ifdef DB_SUPPORT_RGB_DECODE

			IFEELIN F_Log
			(
				0, "r (%ld) g (%ld) b (%ld) >> (0x%08lx)",

					r, g, b,
					(r << 16) | (g << 8) | b

					);

			#endif

			if (ValuePtr)
			{
				*ValuePtr = (r << 16) | (g << 8) | b;
			}

			return TRUE;
		}
	}

	if (ValuePtr)
	{
		*ValuePtr = 0;
	}

	return FALSE;
}
//+

#endif
