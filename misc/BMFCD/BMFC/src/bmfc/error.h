/**************************************/
/* error.h                            */
/* for BMFC 0.00                      */
/* Copyright 1992 by Adam M. Costello */
/**************************************/


extern const char *const outofmem;  /* A common error message. */


void warnf(const char *format, ...);

/* warnf() is like printf(), but uses  */
/* stderr instead of stdout, and       */
/* flushes stderr.                     */


void failf(const char *format, ...);

/* failf() is like warnf(), but always */
/* prefixes the output with "Error: ", */
/* and calls exit(EXIT_FAILURE).       */


void parsefailf(const char *format, ...);

/* parsefailf() is like failf(), but   */
/* the prefix is                       */
/* "Error in line  <n> pos <p>: ",     */
/* where <n> and <p> are the results   */
/* of the functions linenum() and      */
/* position(), respectively, from      */
/* parse.h.                            */
