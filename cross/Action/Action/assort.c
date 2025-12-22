/*-> (C) 1990 Allen I. Holub                                                */
   /* ASSORT.C		A version of ssort optimized for arrays of pointers. */

void assort(void **base, int nel,int(*cmp)(void **,void **) )
{
    int	    i, j, gap;
    void    *tmp, **p1, **p2;

    for( gap=1; gap <= nel; gap = 3*gap + 1 )
	;

    for( gap /= 3;  gap > 0  ; gap /= 3 )
	for( i = gap; i < nel; i++ )
	    for( j = i-gap; j >= 0 ; j -= gap )
	    {
		p1 = base + ( j      );
		p2 = base + ((j+gap) );

		if( (*cmp)( p1, p2 ) <= 0 )
		    break;

		tmp = *p1;
		*p1 = *p2;
	        *p2 = tmp;
	    }
}
