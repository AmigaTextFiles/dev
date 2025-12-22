#include <exec/types.h>

struct LocText {
  ULONG id;
  char *text;
};

#ifdef LOCALE_TEXT

#define LOCALE_START
/*
	CATALOG	 test
	VERSION  38.1
	CATDATE  xx.xx.xx
*/

struct LocText FirstText={0,"This is the first text"};
/*
	D	"Dieses ist der erste Text"
*/

struct LocText SecondText={1,"This is the second text"};
/*
	D	"Dieses ist der zweite Text"
*/

struct LocText Bye={2,"Bye Bye"};
/*
	D	"Tschüß"
*/

#define LOCALE_END
#endif
