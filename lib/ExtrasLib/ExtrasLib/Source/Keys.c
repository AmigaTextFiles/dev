#include <proto/keymap.h>
#include <devices/inputevent.h>
#include <clib/extras_protos.h>
#include <stdio.h>

LONG MapCharToIE(UBYTE C, struct InputEvent *IE);

LONG MapCharToIE(UBYTE C, struct InputEvent *IE)
{
  UBYTE c2;
  UBYTE buffer[6],*b;

  IE->ie_Class=IECLASS_RAWKEY;
  b=buffer;
  c2=C;
  
  switch(MapANSI(&c2,1,buffer,3,0))
  {
    case 3:
      IE->ie_Prev2DownCode=*b++;
      IE->ie_Prev2DownQual=*b++;
    case 2:
      IE->ie_Prev2DownCode=*b++;
      IE->ie_Prev2DownQual=*b++;
    case 1:
      IE->ie_Code      =*b++;
      IE->ie_Qualifier =*b;
      break;
    default:
      return(0);
  
  }
  return(1);

}

/****** extras.lib/key_Unshifted ******************************************
*
*   NAME
*       key_Unshifted -- Get unshifted character of suppied character
*
*   SYNOPSIS
*       unshiftedchar = key_Unshifted(character)
*
*       ULONG key_Unshifted(char);
*
*   FUNCTION
*       Returns the unshifted character for the supplied character.
*       For example (on the USA keymap) 
*         key_Unshifted('#') = '3' 
*         key_Unshifted('3') = '3'
*
*   NOTE
*       This function was previously KeyUnshifted()
*
*   SEE ALSO
*       KeyShifted()
*
******************************************************************************
*
*/


LONG key_Unshifted(UBYTE C)
{
  UBYTE buffer[2];
  struct InputEvent ie={0};

  if(MapCharToIE(C,&ie))
  {
    ie.ie_Qualifier&=~(IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT);
    MapRawKey(&ie,buffer,2,0);
//    printf("key_Unshifted(%c) = %c\n",C,buffer[0]);
    return(buffer[0]);
  }
  return(-1);
}

/****** extras.lib/key_Shifted ******************************************
*
*   NAME
*       key_Shifted -- Get shifted character of suppied character
*
*   SYNOPSIS
*       shiftedchar = key_Shifted(character)
*
*       ULONG key_Shifted(char);
*
*   FUNCTION
*       Returns the shifted character for the supplied character.
*       For example (on the USA keymap) 
*         key_Shifted('#') = '#' 
*         key_Shifted('3') = '#'
*
*   NOTE
*       This function was previously KeyShifted()
*
*   SEE ALSO
*       Key_Unshifted()
*
******************************************************************************
*
*/

LONG key_Shifted(UBYTE C)
{
  UBYTE buffer[2];
  struct InputEvent ie={0};
  
  if(MapCharToIE(C,&ie))
  {
    ie.ie_Qualifier|=(IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT);
    MapRawKey(&ie,buffer,2,0);
//        printf("key_Shifted(%c) = %c\n",C,buffer[0]);
    return(buffer[0]);
  }
  return(-1);
}

