/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * han_allocterm()
 * han_freeterm()
 *
*/

#include "../gid.h"



/*
 * Include this if you want to make your own read/write
 * implementation.
*/
#include "a-mem_xxxterm.h"



void writeterm(void *t, LONG x, LONG y, UBYTE *string)
{
  struct mem_act_data *ad = t;
  UBYTE *str = string;
  UQUAD *reg;
  UQUAD *end;


  x--;

  if (QDEV_HLP_ABS(x) >= ad->ad_cols)
  {
    x = (ad->ad_cols - 1);
  }

  y--;

  if (QDEV_HLP_ABS(y) >= ad->ad_rows)
  {
    y = (ad->ad_rows - 1);
  }

  reg = (UQUAD *)ad->ad_buf;

  reg += (ad->ad_cols * y) + x;

  end = (UQUAD *)ad->ad_buf;

  end += ad->ad_bytes;

  while ((*str) && (reg < end))
  {
    *reg &=
       ~(QDEV_MEM_PRV_CHARMASK | QDEV_MEM_PRV_FNOCHAR);

    *reg++ |= *str++;
  }
}

void readterm(void *t, LONG x, LONG y, LONG size)
{
  struct mem_act_data *ad = t;
  LONG chr;
  UQUAD *reg;
  UQUAD *end;
  UQUAD *cmp;


  x--;

  if (QDEV_HLP_ABS(x) >= ad->ad_cols)
  {
    x = (ad->ad_cols - 1);
  }

  y--;

  if (QDEV_HLP_ABS(y) >= ad->ad_rows)
  {
    y = (ad->ad_rows - 1);
  }

  reg = (UQUAD *)ad->ad_buf;

  reg += (ad->ad_cols * y) + x;

  end = reg;

  end += size;

  cmp = (UQUAD *)ad->ad_buf;

  cmp += ad->ad_bytes;

  if (end > cmp)
  {
    end = cmp;
  }

  while (reg < end)
  {
    if (!(*reg & QDEV_MEM_PRV_FNOCHAR))
    {
      chr = (LONG)(*reg & QDEV_MEM_PRV_CHARMASK);

      chr <<= 24;

      Write(Output(), (void *)&chr, 1);
    }

    reg++;
  }
}

int GID_main(void)
{
  void *term;


  if ((term = mem_allocterm(80, 25, -1)))
  {
    writeterm(term, 10, 10, "Simple Test\n");

    readterm(term, 17, 10, 5);

    mem_freeterm(term);
  }

  return 0;
}
