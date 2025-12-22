#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <time.h>
#include "bitmask.h"

void printmask(bitmask_t *m)
{
  int x, y;
  for (y = 0; y < m->h; y++)
    {
      for (x = 0; x < m->w; x++)
	if (bitmask_getbit(m,x,y))
	  printf("O");
	else
	  printf(" ");
      printf("|\n");
    }
}

int main(int argc, char *argv[])
{
  int x, y, i, j, nbench = 1000;
  long long int count, count2;
  bitmask_t *mask1, *mask2, *mask3;
  printf("Testing bitmask library with %i bit wide stripes.\n",BITW_LEN);
  mask1 = bitmask_create(70,50);
  assert(mask1 != NULL);

  /* Test overlap pos */
  bitmask_setbit(mask1,12,17);
  assert(bitmask_overlap_pos(mask1,mask1,0,0,&x,&y));
  assert(x == 12 && y == 17);

  printf("ok ");
  fflush(stdout);

  /* Test area with a filled mask */
  for (y = 0; y < mask1->h; y++)
    for (x = 0; x < mask1->w; x++)
      bitmask_setbit(mask1, x, y);

  assert(bitmask_overlap_area(mask1,mask1,0,0) == mask1->w*mask1->h);
  assert(bitmask_overlap_area(mask1,mask1,1,1) == (mask1->w - 1)*(mask1->h - 1));

  printf("ok ");
  fflush(stdout);

  /* Using bitmask_fill should give the same results */
  bitmask_fill(mask1);
  assert(bitmask_overlap_area(mask1,mask1,0,0) == mask1->w*mask1->h);
  assert(bitmask_overlap_area(mask1,mask1,1,1) == (mask1->w - 1)*(mask1->h - 1));
  assert(bitmask_overlap_area(mask1,mask1,-1,0) == (mask1->w - 1)*mask1->h);

  printf("ok ");
  fflush(stdout);

  /* Fill in some more interesting bits */
  bitmask_clear(mask1);
  count = 0;
  for (y = 0; y < mask1->h; y++)
    for (x = 0; x < mask1->w; x++)
      if (x > y)
	bitmask_setbit(mask1, x, y);
  /* Test overlap area for the mask itself */
  count = 0;
  for (y = 0; y < mask1->h; y++)
    for (x = 0; x < mask1->w; x++)
      if (bitmask_getbit(mask1,x,y))
	count++;
  assert(count == bitmask_overlap_area(mask1,mask1,0,0));

  printf("ok ");
  fflush(stdout);

  /* Create a new mask with another pattern */
  mask2 = bitmask_create(32,100);
  assert(mask2 != NULL);
  for (y = 0; y < mask2->h; y++)
    for (x = 0; x < mask2->w; x++)
      if ((x ^ y) & 1)
	bitmask_setbit(mask2, x, y);

  /* Test overlap between two masks in a convolution, so that each
     pixel in mask1 overlaps each pixel in mask2 exactly once. 
     Also check that all the bitmask_overlap* functions are in agreement.*/

  count = 0;
  for (y = -mask2->h; y <= mask1->h; y++)
    for (x = -mask2->w; x <= mask1->w; x++)
      {
	i = bitmask_overlap_area(mask1,mask2,x,y);
	count += i;
	if (i > 0)
	  {
	    assert(bitmask_overlap(mask1,mask2,x,y));
	    assert(bitmask_overlap_pos(mask1,mask2,x,y,&i,&j));
	  }
	else
	  {
	    assert(!bitmask_overlap(mask1,mask2,x,y));
	    assert(!bitmask_overlap_pos(mask1,mask2,x,y,&i,&j));
	  }
      }

  printf("ok ");
  fflush(stdout);

  count2 = 0;
  for (y = -mask1->h; y <= mask2->h; y++)
    for (x = -mask1->w; x <= mask2->w; x++)
      count2 += bitmask_overlap_area(mask2,mask1,x,y);

  assert(count == bitmask_overlap_area(mask1,mask1,0,0)*bitmask_overlap_area(mask2,mask2,0,0));
  assert(count == count2);

  printf("ok ");
  fflush(stdout);

  /* Test the draw function */

  mask3 = bitmask_create(mask1->w+mask2->w, mask1->h+mask2->h);
  bitmask_draw(mask3,mask1,0,0);
  bitmask_draw(mask3,mask2,10,7);
  assert(bitmask_overlap_area(mask3,mask3,0,0) ==
	 bitmask_overlap_area(mask1,mask1,0,0) +
	 bitmask_overlap_area(mask2,mask2,0,0) -
	 bitmask_overlap_area(mask1,mask2,10,7));

  printf("ok ");
  fflush(stdout);

  /* Test the erase function */
  
  bitmask_erase(mask3,mask2,10,7);

  assert(bitmask_overlap_area(mask3,mask3,0,0) ==
	 bitmask_overlap_area(mask1,mask1,0,0) -
	 bitmask_overlap_area(mask1,mask2,10,7));

  printf("ok ");
  fflush(stdout);

  bitmask_free(mask3);

  /* Test so that we don't draw out of bounds */
  mask3 = bitmask_create(10,10);
  bitmask_draw(mask3,mask1,mask3->w-1,0);
  for (y=0;y<mask3->h;y++)
    bitmask_clearbit(mask3,mask3->w-1,y);
  assert(!bitmask_overlap(mask3,mask1,mask3->w-1,0));
  
  printf("ok ");
  fflush(stdout);

  printf("\nAll tests finished ok.\n");

  /* Get an estimate for the quality of the scaling function */
  mask3 = bitmask_scale(mask1,mask1->w*2,mask1->h/2);
  printf("Scaling quality (should be about 1.0): %lf\n",
	 bitmask_overlap_area(mask3,mask3,0,0)/(1.0*bitmask_overlap_area(mask1,mask1,0,0)));
  bitmask_free(mask3);

  mask3 = bitmask_scale(mask1,mask1->w*1.6,mask1->h*3.14);
  printf("Scaling quality (should be about 1.0): %lf\n",
	 bitmask_overlap_area(mask3,mask3,0,0)/(1.6*3.14*bitmask_overlap_area(mask1,mask1,0,0)));
  bitmask_free(mask3);

  if (argc > 1)
    {
      if (strcmp(argv[1],"-b") == 0)
	{
	  clock_t t = clock();
	  printf("Benchmarking %i convolutions\n",nbench);
	  count = count2 = 0;
	  while (nbench)
	    {
	      nbench--;
	      for (y = -mask2->h; y <= mask1->h; y++)
		for (x = -mask2->w; x <= mask1->w; x++)
		  count += bitmask_overlap_area(mask1,mask2,x,y);
	      for (y = -mask1->h; y <= mask2->h; y++)
		for (x = -mask1->w; x <= mask2->w; x++)
		  count2 += bitmask_overlap_area(mask2,mask1,x,y);	  
	    }      
	  printf("Counted %lli set bits in total, %lli/second\n",count+count2,
		 (CLOCKS_PER_SEC*(count+count2))/(clock() - t));	  
	  printf("As compared to a p4 2.8 GHz, gcc 3.3.4, bitmask 1.4: 421301775/second\n");
	}
      else
	{
	  printf("Run the test program with -b flag to run a small benchmark.\n");
	}
    }

  return EXIT_SUCCESS;
}

