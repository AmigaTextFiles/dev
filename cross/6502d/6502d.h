/*****************************************************************************
* 6502D Version 0.1                                                          *
* Bart Trzynadlowski, 1999                                                   *
*                                                                            *
* Feel free to do whatever you wish with this source code provided that you  *
* understand it is provided "as is" and that the author will not be held     *
* responsible for anything that happens because of this software.            *
*                                                                            *
* 6502d.h: Contains all function prototypes.                                 *
*****************************************************************************/

/* function prototypes */
int findarg(int argc, char *argv[], const char *args);
int singlearg(int argc, char *argv[], const char *args);
int disasm(unsigned char opcode, int *p, FILE *infile);
