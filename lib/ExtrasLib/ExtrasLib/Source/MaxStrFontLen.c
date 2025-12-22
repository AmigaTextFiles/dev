#include <extras/math.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <extras/ext_text.h>
#include <clib/extras_protos.h>
#include <string.h>
#include <math.h>

/****** extras.lib/gui_MaxStrFontLen ******************************************
*
*   NAME
*       gui_MaxStrFontLen - get the maximum pixel length of a
*       string containg N characters. 
*
*   SYNOPSIS
*       length=gui_MaxStrFontLen(Font, Chars, LowChar, HighChar)
*
*       LONG gui_MaxStrFontLen(struct TextFont *, ULONG, UBYTE, UBYTE);
*
*   FUNCTION
*       This function returns the maximum number of pixels
*       a string with a certain number of characters could
*       occupy.
*
*   INPUTS
*       Font - struct TextFont * previously opened by 
*              OpenFont() or OpenDiskFont().
*       Chars - the max number characters in a string.
*       LowChar - the ASCII number of lowest character
*                 that could be in a string.
*       HighChar - the ASCII number of the highest character
*                  that could be in a string.
*
*   EXAMPLE
*        find the longest pixel length of a number 
*        upto 3 digits 
*       long maxnumberlen;
*       struct TextFont *tf;
*
*       maxnumberlen=gui_MaxStrFontLen(tf,3,'0','9');
*
*   RESULT
*       the pixel length or 0 if the Font parameter
*       is NULL.
*
******************************************************************************
*
*/

ULONG gui_MaxStrFontLen(struct TextFont *Font, ULONG Chars, UBYTE LowChar, UBYTE HighChar)
{
  LONG l, maxcharlen=0,kern=0;
  UBYTE c;

  if(!Font || !Chars)
    return(NULL);
    
  if(Font->tf_Flags & FPF_PROPORTIONAL)
  {
    UBYTE s,lo,hi;
    lo=Font->tf_LoChar;
    hi=Font->tf_HiChar;

    for(c=LowChar; c<=HighChar; c++)
    {
      s=c;
      if(s>=lo && s<=hi)
        s-=lo;
      else
        s=hi-lo+1;
        
      l=((WORD *)Font->tf_CharSpace)[s]+((WORD *)Font->tf_CharKern)[s];
      if(l>maxcharlen)
      {
        maxcharlen=l;
        kern=((WORD *)Font->tf_CharKern)[s];
      }
    }
  }
  else
  {
    maxcharlen=Font->tf_XSize;
  } 
  
  return(maxcharlen * Chars - kern);
}
