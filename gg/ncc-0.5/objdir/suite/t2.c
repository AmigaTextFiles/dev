
enum eerrror {
	a1, a2,
};

struct timerlist {
	struct timerlist *next, *prev;
};

/*
extern int inline bar (int x)
{
	return x*x;
}

int bar (int x)
{
	return 2*x*x;
}

int foo (struct timerlist *tl)
{
	((char*)tl) += 2;
	(char*)tl = bar(3);
	return 0;
}
*/
int zoo (int xx (int))
{
	return xx(32);
}
