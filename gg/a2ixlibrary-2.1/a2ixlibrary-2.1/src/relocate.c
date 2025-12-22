typedef unsigned long ulong;

extern void  __link_data_hashes();
extern ulong __link_data_offsets[];
extern void  __link_text_hashes();
extern void  __link_text_offsets();

/* Relocate memory starting at BASE using relocation array F.
   HASHES contains the hash array containing symbolnames of this library.
   OFFSETS is the offset array containing the memory address of each
   object.
   
   If F is NULL, then nothing is done.

   The array OFFSETS ends with -1.
   
   The relocation array F has the following format:
   
   ulong hashes			The number of object references that have to
				be relocated

   ulong hash			The hash value of a symbolname
   short relocs			Number of addresses that have to be relocated
   ulong offsets[relocs]	Offsets from BASE
   ulong object_offsets[relocs] Relocate to address of object but add this offset too
   
   These last four entries are repeated HASHES times.
*/   

static int relocate(char *base, ulong *f, ulong *hashes, ulong *offsets)
{
  int cnt = (f ? *f++ : 0);
  int ind = 0;
  int i;

  /* For all object references */
  while (cnt--)
  {
    ulong hash = *f++;
    short relocs = *((short *)f)++;

    /* Search for this symbolname */
    while (offsets[ind] != -1 && hashes[ind] != hash)
      ind++;

    /* Not found, return an error */
    if (offsets[ind] == -1)
      return 0;
    i = relocs;
    
    /* Return success if the address is already correct. Apparently this
       memory area has already been relocated. */
    if (*((long *)(base + f[0])) == offsets[ind] + f[relocs])
      return 1;
    
    /* For all addresses */
    while (i--)
    {
      /* Relocate */
      *((long *)(base + f[0])) = offsets[ind] + f[relocs];
      f++;
    }
    f += relocs;
    ind++;
  }
  return 1;
}

int __LibRelocateInstance(char *stext, ulong *tf, ulong *td,
		  	  char *sdata, ulong *df, ulong *dd,
		  	  ulong *libdata)
{
  int cnt;
  int ind = 0;
  ulong *hashes, *offsets;

  /* Relocate the text-to-text references */
  if (!relocate(stext, tf, (ulong *)__link_text_hashes,
                           (ulong *)__link_text_offsets))
    return 0;

  /* Relocate the data-to-text references */
  if (!relocate(sdata, df, (ulong *)__link_text_hashes,
                           (ulong *)__link_text_offsets))
    return 0;

  /* Relocate the text-to-data references */
  if (!relocate(stext, td, (ulong *)__link_data_hashes,
                           (ulong *)__link_data_offsets))
    return 0;

  /* Relocate the data-to-data references */
  if (!relocate(sdata, dd, (ulong *)__link_data_hashes,
                           (ulong *)__link_data_offsets))
    return 0;

  /* Replace the hashvalues of symbolnames in the data hunk with
     the addresses of those objects. Used to implement data-to-data
     references between shared libraries. */

  hashes = (ulong *)__link_data_hashes;
  offsets = __link_data_offsets;
  cnt = (libdata ? *libdata++ : 0);

  while (cnt--)
  {
    ulong hash = *libdata;
    
    while (offsets[ind] != -1 && hashes[ind] != hash)
      ind++;
    if (offsets[ind] == -1)
      return 0;
    *libdata++ = offsets[ind++];
  }
  return 1;
}
