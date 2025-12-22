
/*

This file will be compiled every make because the revision is bumped
every make and changes the header file. Putting the vstring into an
extra source helps to compile fast. But look into the main source
for a note about StormLink...

*/

#include "StormScreenManager_rev.h"
unsigned char vstring[] = VERSTAG;
