/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mem_findinfile.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * Following  contents covered by the  BSIPM  license not to be used in
 * commercial products nor redistributed separately nor modified by the
 * 3-rd parties other than mentioned in the license and under the terms
 * prior to recipient status.
 *
 * A  copy  of  the  BSIPM  document  and/or  source  code  along  with
 * commented modifications and/or separate changelog should be included
 * in this archive.
 *
 * NO WARRANTY OF ANY KIND APPLIES. ALL THE RISK AS TO THE QUALITY  AND
 * PERFORMANCE  OF  THIS  SOFTWARE  IS  WITH  YOU. SEE THE 'BLACK SALLY
 * IMITABLE PACKAGE MARK' DOCUMENT FOR MORE DETAILS.
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: p-mem_findinfile.h 1.01 (31/03/2011)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___FINDINFILE_H_INCLUDED___
#define ___FINDINFILE_H_INCLUDED___

struct mem_fif_user
{
  UBYTE *fu_data;         /* Data to be seek for                            */
  LONG   fu_datalen;      /* Length of that data                            */
  LONG   fu_hits;         /* Number of hits to reach                        */
  LONG   fu_count;        /* Hits so far                                    */
  LONG   fu_cont;         /* Continue value added to the pointer            */
  LONG   fu_gpos;         /* Global file position set upon hit              */
  UBYTE *fu_optr;         /* Binary data distance pointer                   */
  UBYTE *fu_bptr;         /* Binary data looping pointer                    */
  LONG   fu_blen;         /* Binary data looping length                     */
  LONG   fu_cpos;         /* Cur. pos. past the data(relative)              */
  UBYTE *(*fu_cmp)
         (const UBYTE *dat1, LONG len1,
          const UBYTE *dat2, LONG len2);
                          /* Compare func., 'txt_datdat()' def.             */
};

#endif /* ___FINDINFILE_H_INCLUDED___ */
