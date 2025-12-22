/*
 * This code is derived from the GNU heapsort function
 * Jorrit Tyberghein
 */

typedef unsigned int size_t;

/*
 * Swap two areas of size number of bytes.  Although qsort(3) permits random
 * blocks of memory to be sorted, sorting pointers is almost certainly the
 * common case (and, were it not, could easily be made so).  Regardless, it
 * isn't worth optimizing; the SWAP's get sped up by the cache, and pointer
 * arithmetic gets lost in the time required for comparison function calls.
 */
#define	SWAP(a, b) { \
	cnt = size; \
	do { \
		ch = *a; \
		*a++ = *b; \
		*b++ = ch; \
	} while (--cnt); \
}

/*
 * Build the list into a heap, where a heap is defined such that for
 * the records K1 ... KN, Kj/2 >= Kj for 1 <= j/2 <= j <= N.
 *
 * There two cases.  If j == nmemb, select largest of Ki and Kj.  If
 * j < nmemb, select largest of Ki, Kj and Kj+1.
 *
 * The initial value depends on if we're building the initial heap or
 * reconstructing it after saving a value.
 */
#define	HEAP(initval) { \
	for (i = initval; (j = i * 2) <= nmemb; i = j) { \
		p = bot + j * size; \
		if (j < nmemb && compar(p, p + size) < 0) { \
			p += size; \
			++j; \
		} \
		t = bot + i * size; \
		if (compar(p, t) <= 0) \
			break; \
		SWAP(t, p); \
	} \
}


void start (void)
{
	int cmp ();
	long buf[6];

	buf[0] = 5;
	buf[1] = 3;
	buf[2] = 4;
	buf[3] = 2;
	buf[4] = 1;

	heapsort (buf,5,4,cmp);

}



int cmp (int *a, int *b)
{
	if ((*a)<(*b)) return -1;
	return (*a)>(*b);
}




int __mulsi3 (int a, int b)
{
	return (3);
}


int _CXM33 (int a, int b)
{
	return (33);
}

int _CXM22 (int a, int b)
{
	return (22);
}





/*
 * Heapsort -- Knuth, Vol. 3, page 145.  Runs in O (N lg N), both average
 * and worst.  While heapsort is faster than the worst case of quicksort,
 * the BSD quicksort does median selection so that the chance of finding
 * a data set that will trigger the worst case is nonexistent.  Heapsort's
 * only advantage over quicksort is that it requires no additional memory.
 */
heapsort(bot, nmemb, size, compar)
	register unsigned char *bot;	/* Was 'void' */
	register size_t nmemb, size;
	int (*compar)();
{
	register char *p, *t, ch;
	register int cnt, i, j, l;

	if (nmemb <= 1)
		return (0);
	if (!size) {
		return (-1);
	}
	/*
	 * Items are numbered from 1 to nmemb, so offset from size bytes
	 * below the starting address.
	 */
	bot -= size;

	for (l = nmemb / 2 + 1; --l;)
		HEAP(l);

	/*
	 * For each element of the heap, save the largest element into its
	 * final slot, then recreate the heap.
	 */
	while (nmemb > 1) {
		p = bot + size;
		t = bot + nmemb * size;
		SWAP(p, t);
		--nmemb;
		HEAP(1);
	}
	return (0);
}

int theend (void)
{
	return (0x12345678);
}
