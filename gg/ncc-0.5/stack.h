//--------------------------------------------------------------------------
//
//	arrays of automatically increasing size.
//
//	earray<X>	for few elements, reallocation + memcpy every 64
//	stack<X>	for up to a LOT of elements (64*128*256)
//
//-------------------------------------------------------------------------

#ifndef STACK_INCLUDED
#define STACK_INCLUDED

#define TX template<class X>

TX class stack
{
#define PSEG 256
#define NSEG 128
#define TSEG 64
	X ***p;
	int sp;
   public:
	stack ();
	int	alloc ();
inline	X	&operator [] (int);
	void	pop ();
	int	nr ()	{ return sp; }
	void	copy (X**);
	void	destroy ();
};

#define I1A(x) (x / (PSEG*NSEG))
#define I2A(x) ((x % (PSEG*NSEG)) / PSEG)
#define I3A(x) ((x % (PSEG*NSEG)) % PSEG)

TX stack<X>::stack ()
{
	sp = 0;
	p = new X** [TSEG];
}

TX int stack<X>::alloc ()
{
	if (sp % (PSEG*NSEG) == 0)
		p [I1A (sp)] = new X* [NSEG];
	if (sp % PSEG == 0) {
		p [I1A (sp)] [I2A (sp)] = new X [PSEG];
		memset (p [I1A (sp)] [I2A (sp)], 0, PSEG * sizeof (X));
	}
	return sp++;
}

TX X &stack<X>::operator [] (int i)
{
	return p [I1A (i)] [I2A (i)] [I3A (i)];
}

TX void stack<X>::pop ()
{
	if (sp) sp--;
}

TX void stack<X>::copy (X **di)
{
	int i;
	X *d;
	if (sp == 0) return;
	if (*di == NULL) *di = new X [sp];
	d = *di;
	for (i = 0; i + PSEG < sp; i += PSEG)
		memcpy (&d [i], p [I1A(i)][I2A(i)], PSEG * sizeof (X));
	memcpy (&d [i], p [I1A(i)][I2A(i)], (sp - i) * sizeof (X));
}

TX void stack<X>::destroy ()
{
	int i;
	for (i = 0; i < sp; i += PSEG)
		delete [] p [I1A (i)] [I2A (i)];
	for (i = 0; i < sp; i += PSEG*NSEG)
		delete [] p [I1A (i)];
	delete [] p;
}

TX class earray
{
#define	SSEG 64
	int ms;
	X *Realloc (int);
   public:
	int nr;
	X *x;
	earray ();
inline	int alloc ();
	void freeze ();
	void erase ();
};

TX earray<X>::earray ()
{
	ms = nr = 0;
	x = NULL;
}

TX X *earray<X>::Realloc (int s)
{
	X *r = new X [s];
	if (x) {
		memcpy (r, x, nr * sizeof (X));
		delete [] x;
	}
	return x = r;
}

TX int earray<X>::alloc ()
{
	if (ms == nr)
		x = Realloc (ms += SSEG);
	return nr++;
}

TX void earray<X>::freeze ()
{
	if (nr) x = Realloc (ms = nr);
}

TX void earray<X>::erase ()
{
	if (x) delete [] x;
	x = NULL;
	ms = nr = 0;
}
#endif
