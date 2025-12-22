#include <feelin/string.h>

long atol(const char *string)
{
	int32 val;

	f_stcd(string, &val);

	return val;
}
