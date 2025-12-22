#include <feelin/support/f_parse_values.h>

///f_parse_values
uint32 f_parse_values(STRPTR Source, f_parse_values_func Func, APTR UserData)
{
	uint32 n = 0;

	if (Source != NULL)
	{
		uint8 c = *Source;

		while (c != '\0')
		{
			if (c == ' ')
			{
				c = *(++Source);
			}
			else
			{
				STRPTR start = Source;

				bool32 in_parenthesis = FALSE;
				bool32 in_quote = FALSE;

				uint8 quote = 0;

				for (;;)
				{
					if (c == ' ')
					{
						if ((in_parenthesis == FALSE) && (in_quote == FALSE))
						{
							break;
						}
					}
					else
					{
						if (in_quote == FALSE)
						{
							if (c == '\'')
							{
								in_quote = TRUE;

								quote = c;
							}
							else if (c == '\"')
							{
								in_quote = TRUE;

								quote = c;
							}
		                    if (c == '(')
			                {
				                in_parenthesis = TRUE;
					        }
							else if (c == ')')
							{
								if (in_parenthesis == FALSE)
								{
									/* parenthesis error */

									return n;
								}

								c = *(++Source);

								break;
							}
						}
						else if (quote == c)
						{
							in_quote = FALSE;
						}
					}

					c = *(++Source);

					if (c == '\0')
					{
						break;
					}
				}

				if (Func != NULL)
				{
					if (Func(start, Source - start, UserData) == FALSE)
					{
						//IFEELIN F_Log(0, "returned false with [%-16.16s] (%ld)", start, Source - start);

						return n;
					}
				}

				n++;
			}
		}
	}

	return n;
}
//+

