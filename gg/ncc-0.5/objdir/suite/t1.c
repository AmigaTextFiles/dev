
#define T20
#define T19
#define T18
#define T17
#define T16
#define T15
#define T14
#define T13
#define T12
#define T11
#define T10
#define T9
#define T8
#define T7
#define T6
#define T5
#define T4
#define T3
#define T2
#define T1

#ifdef T1
int main ()
{
	int x, y;
	float f;

	x = y * f + y/x;
}
#endif

#ifdef T2
int foo ()
{
	int a [10][10], *b[10], **p;
	
	a [1][1] = b [1][1] + p [1][1];
}
#endif

#ifdef T3
int foo3 ()
{
	struct {
		float x;
		float a [10];
	} bar, *bp;

	bar.a [1] += bp->x;
}
#endif

#ifdef T4
int foo4 ()
{
	struct {
		struct {
			int x, y;
		} zoo;
		int x;
	} bar;
	
	bar.x += bar.zoo.y << bar.zoo.x;
}
#endif

#ifdef T5
int foo5 ()
{
	int *c, d;
	d = *(--c);
	d = ++*c;

}
#endif 

#ifdef T6
int foo6 ()
{
	int *c, d;
	d -= *c--;
	d += (*c)++;

}
#endif 

#ifdef T7
int foo7 ()
{
	int *p1, *p2, i;
	i = p1 - p2;
	p1 = p2 - 1;
	(i+1, i) = 3;
	i = (i+1, i+2) + 2;
}
#endif 

#ifdef T8
int foo8 ()
{
	int x, y;
	float f;
	
	f = x==0 || y>0 && y<=f;
	y = x==0 || 1 || x==2;
}
#endif

#ifdef T9
int foo9 ()
{
	struct {
		int x, y;
	} b1, b2, *bp;
	
	b1 = b2;
	b2 = *bp;
}
#endif

#ifdef T10
int foo10 ()
{
	int x, y[10];
	float f;
	
	bar10 (x + y [1] / f, x, f, f/3.12);
}
#endif

#ifdef T11
int foo11 ()
{
	struct codec {
		int x;
		char *name;
		float f;
	} *cp;
	char *nn;
	nn = "Stelios";
		
	cp->name = "Aplle Amination (LRE";
}
#endif

#ifdef T12
int foo12 ()
{
	void *p;
	p = &&labeladdr;
labeladdr:
}
#endif

#ifdef T13
int foo13 ()
{
	int a[12], i;
	short int x, y;
	
	i = sizeof a;
	i = sizeof (x+y);
}
#endif

#ifdef T14
int foo14 ()
{
	int x;
	x = 1 ? 2 : 3;
	x = 1 ?: 3;
	x = 0 ?: 4;
}
#endif

#ifdef T15
int foo15 ()
{
	struct foo {
		int x, y;
	} *fp;
	
	((char*) fp) += sizeof *fp;
}
#endif

#ifdef T16
int foo16 ()
{
	int i, j;

	i = 1 || i==0;	
	i = 0 || 0 || 1;
	i = 0 || 1112;
	i = 1 && 0;
	i = 1 && j==2;
}
#endif

#ifdef T17
int foo117 (float x, int y, void p [10]);
int foo17 ()
{
	int x;
	float y;
	int a[1], *p;
	
	foo117 (x + x, y + x, p-a);
}
#endif

#ifdef T18
int foo18 ()
{
	float x;
	int i;
	
//	i = (i) ? x : i;
//	i = (i) ? i : x;
//	i = (i) ?: x;
	i ? x : i;
	i ? i+i : x;
	i ?: x+1;
	i ? i + 1 : i + 2;
}
#endif

#ifdef T19
struct bbt
{
	int x:2, y:4, z:8;
} b;
int foo19 ()
{
	b.x + b.y;
}
#endif

#ifdef T20
int foo20 ()
{
	int x, y;
	
	x = x / y * ({
		__typeof__ (x+x) e;
		e;
		});
}
#endif

#ifdef T
int foo ()
{
}
#endif

#ifdef T
int foo ()
{
}
#endif

#ifdef T
int foo ()
{
}
#endif

#ifdef T
int foo ()
{
}
#endif
