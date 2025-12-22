/* Parse Command Line */

#ifndef MIPARSE
#define MIPARSE  


int ParseCmdLine(int argc, char* argv[]);

int GetAddress(char *Str, WORD *WordPtr);
int GetString(char *Str, char *DestStrPtr);


#endif


