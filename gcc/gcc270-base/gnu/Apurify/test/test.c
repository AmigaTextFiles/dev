#include <stdio.h>

int static_var;

static read_shifted(a)
	int *a;
	{
	int i;
	++(short*)a;
	i=a[0];
	}

static read_long(p)
	int *p;
	{
	int z = *p;
	}

static free_arg(a)
	int *a;
	{
	free(a);
	}

static read_page_zero()
	{
	register long *b;
	b = (long*)4;
	b = (long*)*b;
	}

main()
	{
	register int *a,*b;
	int c;
	extern int *malloc();
	AP_Init();
	a=malloc(4),malloc(400),malloc(12000),malloc(40000);
	if(a)
		{
		if(b=malloc(15)) {a[0]=b[-10];c=b[0];free(b);}
		if(a[1] == 0) c=32;
		read_long(&c);b=&c;*b=0;
		b = &static_var;
		*b = 15;
		read_shifted(a);
		free_arg(a);
		read_long(a);
		read_page_zero();
		}
	return 0;
	}
