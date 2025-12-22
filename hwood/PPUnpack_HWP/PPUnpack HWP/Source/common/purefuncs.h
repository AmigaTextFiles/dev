#include <stdio.h>
#include <stddef.h>
#include <stdarg.h>

int pure_printf(const char *format, ...);
int pure_sscanf(const char *str, const char *ctrl, ...);
int pure_vsnprintf(char *buffer, size_t count, const char *format, va_list argptr);
int pure_snprintf(char *buffer, size_t count, const char *format, ...);

