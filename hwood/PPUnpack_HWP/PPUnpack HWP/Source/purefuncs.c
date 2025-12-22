#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#include <hollywood/plugin.h>

extern hwPluginAPI *hwcl;

int pure_printf(const char *format, ...)
{
	va_list args;
	int r;

	va_start(args, format);
	r = hwcl->CRTBase->vprintf(format, args);
	va_end(args);

	return r;
}

int pure_sscanf(const char *str, const char *ctrl, ...)
{
	va_list args;
	int r;

	va_start(args, ctrl);
	r = hwcl->CRTBase->vsscanf(str, ctrl, args);
	va_end(args);

	return r;
}

int pure_vsnprintf(char *buffer, size_t count, const char *format, va_list argptr)
{
	return hwcl->CRTBase->vsnprintf(buffer, count, format, argptr);
}

int pure_snprintf(char *buffer, size_t count, const char *format, ...)
{
	va_list args;
	int r;

	va_start(args, format);
	r = pure_vsnprintf(buffer, count, format, args);
	va_end(args);

	return r;
}

