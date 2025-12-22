/* BINTAP version 1.0 */
/* By the infamous BLOOD! */
/* (C)1996 Cheese Freak Software */
/* This prog is most definitely FREEWARE! */
/* But please don't distribute updated versions without asking first...! */


typedef unsigned char BYTE;

void getheader(BYTE header[21], char *filename, char *length, unsigned int fl);
void conv(BYTE *high, BYTE *low, unsigned int number);
unsigned int getsize(FILE *fp);

