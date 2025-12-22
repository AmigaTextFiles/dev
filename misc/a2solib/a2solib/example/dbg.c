#include <stdio.h>
#include <stdarg.h>

int debuglevel = 0;

int dprintf(int level, char *format, ...)
{
	va_list args;
	int r = 0;

	if (level <= debuglevel)
	{
		va_start(args, format);
		r = vfprintf(stderr, format, args);
		va_end(args);
	}
	
	return r;
}

void set_debug_level(int level)
{
	debuglevel = level;
}
