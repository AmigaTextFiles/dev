#include "write.h"

int sockprintf(int s, const char *fmt, ...)
{
    va_list args;
    char buf[16384];    /* Really huge, to try and avoid truncation */

    va_start(args, fmt);
    vsnprintf(buf, sizeof(buf), fmt, args);
    return write(s, buf, strlen(buf));
}
