//===============================================//
// Layout manager classes                        //
// General header file                           //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_H
#define LAYOUT_H 1

inline int max (int a, int b)
{
	return a > b ? a : b;
}

inline int min (int a, int b)
{
	return a < b ? a : b;
}

typedef int boolean;

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE 1
#endif

class D
{
	char buf[255];
	static boolean debug;
	static int ind;
	static char prefix[255];
	static int prefix_len;

public:
	D ();
	D (char *a);
	D (char *a, char *b);
	D (char *a, char *b, char *c);
	D (char *a, char *b, char *c, char *d);
	D (char *a, int b);
	D (char *a, int b, int c);
	D (char *a, int b, int c, int d);
	D (char *a, int b, char *c);
	D (char *a, int b, char *c, int d);
	D (char *a, char *b, char *c, int d);
	D (char *a, char *b, int c);
	D (char *a, char *b, int c, int d);
	D (char *a, char *b, int c, int d, int e);
	D (char *a, char *b, int c, int d, int e, int f);
	~D ();
	static void set_debug (boolean db) { debug = db; prefix[0] = 0; }
	static void set_debug (char* p);

private:
	void show ();
};

#if 0

#define DB(x) D db##x

#else

#define DB(x)

#endif


#endif
