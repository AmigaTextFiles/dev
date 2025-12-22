/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_allocarray()
 * mem_freearray()
 * mem_accessarray()
 *
*/

#include "../gid.h"

/*
 * Dont forget that this gets multiplied by sizeof(QUAD),
 * which grows it 8 times!
*/
#define ARRAYSIZE    16384

#define BLOCKSIZE     4096
#define LINESIZE      1024
#define DATAFILE     "CrippledHubList.config"



struct mydata
{
  void *md_array;
  LONG *md_index;
  LONG  md_elnum;
};



LONG hashwordscb(struct mem_lbl_cb *lc)
{
  struct mydata *md = lc->lc_userdata;
  UBYTE *ptr;
  LONG addr;
  LONG old;
  ULONG hash;
  QUAD *index;


  if (lc->lc_linenum > 0)
  {
    /*
     * Convert non-alphanumeric characters to spaces.
    */
    ptr = lc->lc_lineptr;

    while (*ptr)
    {
      *ptr = QDEV_HLP_EQUALIZELC(*ptr);

      if (!(((*ptr >= 'a')    &&
           (*ptr <= 'z'))     ||
          ((*ptr >= '0')      &&
           (*ptr <= '9'))     ||
          ((*ptr >= 0xE0)     &&
           (*ptr <= 0xFE)     &&
           (*ptr != 0xF7))))
      {
        *ptr = ' ';
      }

      ptr++;
    }

    /*
     * Tokenify all words, so that we can hash each &
     * assign it a line.
    */
    addr = (LONG)lc->lc_lineptr;

    while ((ptr =
                 txt_tokenify((UBYTE *)addr, &addr, ' ')))
    {
      /*
       * Only attempt to extract and hash if the array
       * can still hold it!
      */
      if (md->md_elnum < ARRAYSIZE)
      {
        QDEV_TXT_TOKENSET(old, addr);

        hash = QDEV_HLP_FNV32IHASH(ptr);

        QDEV_TXT_TOKENCLR(old, addr);

        /*
         * Now obtain element address of the array and
         * stuff the hash in first 32 bits.
        */
        index = (QUAD *)mem_accessarray(
                md->md_array, sizeof(QUAD), md->md_elnum);

        *index = hash;

        *index <<= 32;

        /*
         * Then stuff a line num. in the rest 32 bits.
        */
        *index |= lc->lc_linenum;

        md->md_elnum++;
      }
      else
      {
        return 0;
      }
    }
  }

  return -1;
}

int GID_main(void)
{
  struct mydata md;
  UBYTE buf[128];
  UBYTE *ptr;
  ULONG hash;
  LONG elnum;
  LONG fd;
  QUAD *index;


  /*
   * Why is this thing better than declaring ARRAYSIZE
   * normally(QUAD array[ARRAYSIZE];)? Mainly because
   * there is no need for a large memory block so that
   * even heavily fragmented memory is not an issue.
  */
  if ((md.md_array = mem_allocarray(BLOCKSIZE,
                   sizeof(QUAD), ARRAYSIZE, MEMF_PUBLIC)))
  {
    /*
     * So there you go instead of 128 kilos in one big
     * memory block we use a table of ARRAYSIZE /
     * BLOCKSIZE + 1 * sizeof(LONG) to hold all memory
     * allocs where each of which is BLOCKSIZE big.
     * Let's now do some magic trick.
    */
    if ((fd = Open(DATAFILE, MODE_OLDFILE)))
    {
      md.md_elnum = 0;

      mem_scanlbl(LINESIZE, fd, 0, &md, hashwordscb);

      if (md.md_elnum)
      {
        FPrintf(Output(),
                      "Hashed %ld words.\n", md.md_elnum);

        while(1)
        {
          FPrintf(Output(),
           "\nEnter a word to locate and press Return: ");

          Flush(Output());

          Flush(Input());

          if (FGets(Input(), buf, sizeof(buf) - 1))
          {
            /*
             * Pressing just the Return key terminates
             * the program.
            */
            if(buf[0] != '\n')
            {
              if ((ptr = txt_strchr(buf, '\n')))
              {
                *ptr = '\0';
              }

              hash = QDEV_HLP_FNV32IHASH(buf);

              /*
               * Lets try to locate that word. Results
               * are line numbers.
              */
              FPrintf(Output(),
       "Word '%s' can be found at line(s):\n", (LONG)buf);

              for (
                  elnum = 0; elnum < md.md_elnum; elnum++)
              {
                index = (QUAD *)mem_accessarray(
                        md.md_array, sizeof(QUAD), elnum);              

                if ((ULONG)(*index >> 32) == hash)
                {
                  FPrintf(Output(),
                  "  %ld\n", (LONG)(*index & 0xFFFFFFFF));
                }
              }
            }
            else
            {
              break;
            }
          }
          else
          {
            break;
          }
        }                                    
      }

      Close(fd);
    }

    mem_freearray(md.md_array);
  }

  return 0;
}
