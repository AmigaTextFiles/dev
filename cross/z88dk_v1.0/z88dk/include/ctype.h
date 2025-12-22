#ifndef CTYPE_H
#define CTYPE_H


/* HDRPRTYPE is a rather kludgey way to indicate to the compiler that these
 * functions are to be found in the library and not in other modules
 */

#pragma proto HDRPRTYPE 

extern isalpha(char);
extern isalnum(char);
extern isascii(char);
extern iscntrl(char);
extern isdigit(char);
extern isupper(char);
extern islower(char);
extern ispunct(char);
extern isspace(char);
extern isxdigit(char);
extern char toascii(char);
extern char toupper(char);
extern char tolower(char);

#pragma unproto HDRPRTYPE 


#endif
