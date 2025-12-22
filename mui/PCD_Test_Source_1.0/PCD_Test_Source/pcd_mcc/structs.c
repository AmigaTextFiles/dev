/* structs */

#include "main.h"














/*-----------------------------------------------------------------------------*/




struct Data
{
 Object *app;	
 char _dir[150];
 char _file[150];
 char path[150];
 Object *ed;
 unsigned char *img;
 ULONG width;
 ULONG height;	
 int size_nr;	
 };



struct data_out
{
char *data;
ULONG size;
};




