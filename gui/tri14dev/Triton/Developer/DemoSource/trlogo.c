/*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1995
 *
 *  (c) 1993-1995 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 *  trLogo.c - The Triton logo
 *
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <libraries/triton.h>

#ifdef __GNUC__
#ifndef __OPTIMIZE__
#include <clib/triton_protos.h>
#else
#include <inline/triton.h>
#endif /* __OPTIMIZE__ */
#else
#include <proto/triton.h>
#endif /* __GNUC__ */


int main(void)
{
  if(TR_OpenTriton(TRITON11VERSION,TRCA_Name,"trLogo",TRCA_LongName,"trLogo",TRCA_Info,"The Triton Logo",TRCA_Version,"1.0",TAG_END))
  {
    if(TRIM_trLogo_Init())
    {
      TR_AutoRequestTags(Application,NULL,
        WindowID(1), WindowPosition(TRWP_CENTERDISPLAY),
        WindowTitle("trLogo"), WindowFlags(TRWF_NOMINTEXTWIDTH),
        BoopsiImageD(TRIM_trLogo,57,57),
        TAG_END);
      TRIM_trLogo_Free();
    }
    TR_CloseTriton();
    return 0;
  }

  puts("Can't open triton.library v2+.");
  return 20;
}
