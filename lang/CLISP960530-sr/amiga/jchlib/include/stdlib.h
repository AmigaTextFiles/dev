/* Tiny GCC Library
 * stdlib.h
 * Jörg Höhle, 11-Jun-96
 */

#ifndef _STDLIB_H_
#define _STDLIB_H_

typedef void exit_t (int);
extern volatile exit_t exit;
char *getenv(const char *);

#endif /* _STDLIB_H_ */
