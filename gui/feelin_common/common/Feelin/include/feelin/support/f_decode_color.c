#ifndef FEELIN_SUPPORT_DECODE_COLOR_C
#define FEELIN_SUPPORT_DECODE_COLOR_C

#include <feelin/string.h>

#include <feelin/support/f_decode_rgb.h>
#include <feelin/support/f_decode_rgb.c>

#include <feelin/support/f_decode_color.h>

///f_decode_color
uint32 f_decode_color(STRPTR Spec, uint32 Length, uint32 *ValuePtr)
{
	uint32 value = 0;
	uint32 type = 0;

	if (Spec != NULL)
	{
		if (*Spec == '#')
		{
			uint32 len = f_stch(Spec + 1, (int32 *) &value);

			if (len != 0)
			{
				type = FV_COLORTYPE_RGB;

				if (len == 3)
				{
					value = ((0x00000F00 & value) << 12) | ((0x00000F00 & value) << 8) |
							((0x000000F0 & value) <<  8) | ((0x000000F0 & value) << 4) |
							((0x0000000F & value) <<  4) | (0x0000000F & value);
				}
			}
		}
		else if ((*Spec == '-') || ((*Spec >= '0') && (*Spec <= '9')))
		{
			if (f_stcd(Spec, (int32 *) &value) != 0)
			{
				type = FV_COLORTYPE_PEN;
			}
		}
		else
		{
			if (Length == ALL)
			{
				Length = IFEELIN F_StrLen(Spec);
			}

			switch (Length)
			{
				case 3:
				{
					if (IUTILITY Strnicmp(Spec, "red", 3) == 0)
					{
						value = 0xFF0000;
						type = FV_COLORTYPE_RGB;
					}
				}
				break;

				case 4:
				{
					if (IUTILITY Strnicmp(Spec, "text", 4) == 0)
					{
						value = FV_Pen_Text;
						type = FV_COLORTYPE_PALETTE;
					}
					else if (IUTILITY Strnicmp(Spec, "fill", 4) == 0)
					{
						value = FV_Pen_Fill;
						type = FV_COLORTYPE_PALETTE;
					}
					else if (IUTILITY Strnicmp(Spec, "dark", 4) == 0)
					{
						value = FV_Pen_Dark;
						type = FV_COLORTYPE_PALETTE;
					}
					else if (IUTILITY Strnicmp(Spec, "gray", 4) == 0)
					{
						value = 0x808080;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "lime", 4) == 0)
					{
						value = 0x00FF00;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "blue", 4) == 0)
					{
						value = 0x0000FF;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "navy", 4) == 0)
					{
						value = 0x000080;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "teal", 4) == 0)
					{
						value = 0x008080;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "aqua", 4) == 0)
					{
						value = 0x00FFFF;
						type = FV_COLORTYPE_RGB;
					}
				}
				break;

				case 5:
				{
					if (IUTILITY Strnicmp(Spec, "shine", 5) == 0)
					{
						value = FV_Pen_Shine;
						type = FV_COLORTYPE_PALETTE;
					}
					else if (IUTILITY Strnicmp(Spec, "black", 5) == 0)
					{
						value = 0x000000;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "white", 5) == 0)
					{
						value = 0xFFFFFF;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "green", 5) == 0)
					{
						value = 0x008000;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "olive", 5) == 0)
					{
						value = 0x808000;
						type = FV_COLORTYPE_RGB;
					}
				}
				break;

				case 6:
				{
					if (IUTILITY Strnicmp(Spec, "shadow", 6) == 0)
					{
						value = FV_Pen_Shadow;
						type = FV_COLORTYPE_PALETTE;
					}
					else if (IUTILITY Strnicmp(Spec, "silver", 6) == 0)
					{
						value = 0x00C0C0;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "maroon", 6) == 0)
					{
						value = 0x800000;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "purple", 6) == 0)
					{
						value = 0x800080;
						type = FV_COLORTYPE_RGB;
					}
					else if (IUTILITY Strnicmp(Spec, "yellow", 6) == 0)
					{
						value = 0xFFFF00;
						type = FV_COLORTYPE_RGB;
					}
				}
				break;

				case 7:
				{
					if (IUTILITY Strnicmp(Spec, "fuchsia", 7) == 0)
					{
						value = 0xFF00FF;
						type = FV_COLORTYPE_RGB;
					}
				}
				break;

				case 8:
				{
					if (IUTILITY Strnicmp(Spec, "halfdark", 8) == 0)
					{
						value = FV_Pen_HalfDark;
						type = FV_COLORTYPE_PALETTE;
					}
				}
				break;

				case 9:
				{
					if (IUTILITY Strnicmp(Spec, "halfshine", 9) == 0)
					{
						value = FV_Pen_HalfShine;
						type = FV_COLORTYPE_PALETTE;
					}
					else if (IUTILITY Strnicmp(Spec, "highlight", 9) == 0)
					{
						value = FV_Pen_Highlight;
						type = FV_COLORTYPE_PALETTE;
					}
				}
				break;

				case 10:
				{
					if (IUTILITY Strnicmp(Spec, "halfshadow", 10) == 0)
					{
						value = FV_Pen_HalfShadow;
						type = FV_COLORTYPE_PALETTE;
					}
				}
				break;
			}

			if ((type == FV_COLORTYPE_NONE) && (Length > 10))
			{
				if ((Spec[0] == 'r') && (Spec[1] == 'g') && (Spec[2] == 'b') && (Spec[3] == '(') && (Spec[Length - 1] == ')'))
				{
					if (f_decode_rgb(Spec + 4, &value))
					{
						type = FV_COLORTYPE_RGB;
					}
				}
			}
		}
	}

	#ifdef DB_SUPPORT_COLOR_DECODE

	switch (type)
	{
		case FV_SUPPORT_COLOR_TYPE_NONE:
		{
			if (Spec != NULL)
			{
				IFEELIN F_Log(0, "unable to decode (%s)", Spec);
			}
			else
			{
				IFEELIN F_Log(0, "spec is NULL");
			}
		}
		break;

		case FV_COLORTYPE_RGB:
		{
			IFEELIN F_Log(0,"Spec (%s) rrggbb (0x%06lx)", Spec, value);
		}
		break;

		case FV_COLORTYPE_PALETTE:
		{
			IFEELIN F_Log(0,"Spec (%s) entry (%ld)", Spec, value);
		}
		break;

		case FV_COLORTYPE_PEN:
		{
			IFEELIN F_Log(0,"Spec (%s) pen (%ld)", Spec, value);
		}
		break;
	}

	#endif

	if (ValuePtr != NULL)
	{
		*ValuePtr = value;
	}

	return type;
}
//+

#endif
