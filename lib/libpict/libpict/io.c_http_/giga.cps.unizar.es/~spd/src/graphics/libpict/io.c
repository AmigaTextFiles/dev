#include "io.h"

short pict_get_short(FILE *f)
{
	uint8_t  h,l;
	uint16_t s;

	h = getc(f);
	l = getc(f);
	s = (h<<8)|l;

	return s;
}

int pict_get_int(FILE *f)
{
	uint8_t  a,b,c,d;
	uint32_t i;

	a = getc(f);
	b = getc(f);
	c = getc(f);
	d = getc(f);
	i = (a<<24)|(b<<16)|(c<<8)|d;

	return i;
}

fixed pict_get_fixed(FILE *f)
{
	fixed fx;
	fx.i = pict_get_short(f);
	fx.f = pict_get_short(f);

	return fx;
}

rect pict_get_rect(FILE *f)
{
	rect r;
	r.top = pict_get_short(f);
	r.left = pict_get_short(f);
	r.bottom = pict_get_short(f);
	r.right = pict_get_short(f);

	return r;
}

void pict_put_short(short s,FILE *f)
{
	int	h,l;

	h = s>>8; l = s&0xFF;
	putc(h,f);
	putc(l,f);
}

void pict_put_int(int i,FILE *f)
{
	int	a,b,c,d;

	a = (i>>24);
	b = (i>>16)&0xFF;
	c = (i>> 8)&0xFF;
	d = (i    )&0xFF;
	putc(a,f);
	putc(b,f);
	putc(c,f);
	putc(d,f);
}

void pict_put_fixed(fixed fx,FILE *f)
{
	pict_put_short(fx.i,f);
	pict_put_short(fx.f,f);
}

void pict_put_rect(rect r,FILE *f)
{
	pict_put_short(r.top,f);
	pict_put_short(r.left,f);
	pict_put_short(r.bottom,f);
	pict_put_short(r.right,f);
}

void    pict_log_short(char* name,short x)
{
#ifdef DEBUG
	printf("S <%s> %u\n",name,x);
#endif
}

void    pict_log_xshort(char* name,short x)
{
#ifdef DEBUG
	printf("S <%s> 0x%0.4hX\n",name,x);
#endif
}

void    pict_log_int(char* name,int x)
{
#ifdef DEBUG
	printf("L <%s> %d\n",name,x);
#endif
}

void    pict_log_xint(char* name,int x)
{
#ifdef DEBUG
	printf("L <%s> 0x%0.8X\n",name,x);
#endif
}

void    pict_log_fixed(char* name,fixed x)
{
#ifdef DEBUG
	printf("F <%s> %u.%u\n",name,x.i,x.f);
#endif
}

void    pict_log_rect(char* name,rect x)
{
#ifdef DEBUG
	printf("R <%s> [l,r,t,b]=[%u,%u,%u,%u]\n",
			name,x.left,x.right,x.top,x.bottom);
#endif
}

