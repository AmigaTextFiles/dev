#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int x [] [10];

int x [30] [10];

int y [][2][] = { {{1,1},{1,1}}, {{1,1},{1,1}}};
struct foo { } bar [ ] = { {}, {},  {} };

union uu {
	int x:1, y:16, z:16, e:16, d:16;
}
uuu;


int main ()
{
	unsigned int i = 1/0;
	int j;
	
	j = -1;
	i = 100 * j;
	printf ("%u\n", i);
	return 0;
}

