#include <stdio.h>

extern char *_mymalloc ();
#define malloc(SZ) _mymalloc( SZ, __FILE__, __LINE__ )
#define	free(PTR) _myfree( PTR, __FILE__, __LINE__ )

#define AREA1 (15)
#define AREA2 (64)
#define AREA3 (67)

main ()
{
    register char *area1;
    register char *area2;
    register char *area3;

    area1 = malloc (AREA1);
    area2 = malloc (AREA2);
    * (area1 + AREA1) = 0;
    area3 = malloc (AREA3);
    * (area2 - 1) = 0;
    free (area1);
    free (area1);
}
