/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_string.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_string.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_string.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"



/* 
 * Convert hexidecimal to string
 */
extern char *
hex2str(u_int16_t hex) {
  char *buffer = malloc(sizeof(char)*10);
  sprintf(buffer,"0x%x", hex);
  return buffer;
}


/* 
 * Convert int to string, return "infinite" if num is 0 (For output only) 
 */
extern char *
int2str(int num) {
  char *buffer = malloc(sizeof(char)*10);
  if(num == -1) { free(buffer); return "infinite"; }
  sprintf(buffer,"%d", num);
  return buffer;
};


/* 
 * Convert int to string 
 */
extern char *
itoa(int num) {
 char *buffer = malloc(sizeof(char)*7);
 sprintf(buffer,"%d", num);
 buffer[strlen(buffer)] = '\0';
 return buffer;
}


/* 
 * Convert string to hex 
 */
extern unsigned int
atohex(char *str) {
  unsigned int hexnum;

  sscanf(str,"0x%x", &hexnum);

  return hexnum;
}


/* 
 * Convert int to char 
 */
extern int
ctoi(char c) {
  switch(c) {
    case '0': return 0;
    case '1': return 1;
    case '2': return 2;
    case '3': return 3;
    case '4': return 4;
    case '5': return 5;
    case '6': return 6;
    case '7': return 7;
    case '8': return 8;
    case '9': return 9;
  }
  return (int)c; /* default */
}


/* 
 * strip leading '-' symbols off string, for writeconf() 
 */
extern char *
strip_leading_dashes(char *str) {
  char *buffer = malloc(sizeof(char)*256);
  int i = 0, j = 0; /* counters */
  
  do { i++; } while(str[i] == '-'); /* go to non '-' offset */
  while(str[i]) { buffer[j] = str[i]; j++; i++; }

  return buffer;
}


/* 
 * Chop \n character off end of string 
 */
extern char *
chop(char *str) {
  int i = 0;
  while(str[i]) {
    if(str[i] == '\n') str[i] = '\0';
    i++;
  }
  return str;
}
