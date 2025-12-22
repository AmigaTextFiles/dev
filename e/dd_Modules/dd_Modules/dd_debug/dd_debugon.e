-> dd_debugon.e - © 1994-1995 by Digital Disturbance. Freeware.
-> Porgrammed by Leon Woestenberg (Email: leon@stack.urc.tue.nl)

OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'tools/debug'

#define DEBUG

#define KPUTSTR(string) kputstr(string)
#define KPUTFMT(string,datastream) kputfmt(string,datastream)
#define KPUTCHAR(character) kputchar(character)
#define KGETCHAR kgetchar()
#define KRESET kputchar(12)

