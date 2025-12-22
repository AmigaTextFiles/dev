#include "crc_table.h"

unsigned long crc32(unsigned char *buf, int len)
{
        unsigned char *p;
        unsigned long  crc;

        crc = 0xffffffff;       /* preload shift register, per CRC-32 spec */
        for (p = buf; len > 0; ++p, --len)
                crc = (crc << 8) ^ crc32_table[(crc >> 24) ^ *p];
        return ~crc;            /* transmit complement, per CRC-32 spec */
}

/* for null-terminated strings: */
unsigned long crc32_0(unsigned const char *buf)
{
        unsigned const char *p;
        unsigned long  crc;

        crc = 0xffffffff;       /* preload shift register, per CRC-32 spec */
        for (p = buf; *p; ++p)
                crc = (crc << 8) ^ crc32_table[(crc >> 24) ^ *p];
        return ~crc;            /* transmit complement, per CRC-32 spec */
}

