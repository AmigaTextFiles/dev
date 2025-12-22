/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/RawKeyDecoder.cxx,v $
 **   $Revision: 1.7 $
 **   $Date: 1994/07/31 13:31:33 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <inline/keymap.h>
#endif

#ifdef __SASC
#include <proto/keymap.h>
#endif

#include <devices/inputevent.h>
#include <devices/keymap.h>
}
#include <APlusPlus/intuition/RawKeyDecoder.h>
#include <APlusPlus/intuition/IntuiMessageC.h>


static const char rcs_id[] = "$Id: RawKeyDecoder.cxx,v 1.7 1994/07/31 13:31:33 Armin_Vogt Exp Armin_Vogt $";


RawKeyDecoder::RawKeyDecoder()
{
   clear();
}

RawKeyDecoder::RawKeyDecoder(const IntuiMessageC *imsg)
{
   decode(imsg);
}

void RawKeyDecoder::decode(const IntuiMessageC *imsg)
{
   #define RKD_MAX_INPUT_LEN 10
   UBYTE inputBuffer[RKD_MAX_INPUT_LEN+1];

   struct InputEvent inputEvent = { 0,IECLASS_RAWKEY,0,0,0 };
   inputEvent.ie_Code      = imsg->Code;
   inputEvent.ie_Qualifier = imsg->Qualifier;
   inputEvent.ie_EventAddress = (APTR)((struct IntuiMessage*)imsg)->IAddress;

   (void) MapRawKey(&inputEvent,(char*)inputBuffer,RKD_MAX_INPUT_LEN,NULL);

   keyQualifier = (RKD_IEQualifier)imsg->Qualifier;

   UBYTE *bufferPtr = inputBuffer;
   if (*bufferPtr==0x9b)
   {
      keycode = (RKD_KeyCode)*++bufferPtr;
      if (keycode==' ')
      {
         switch (keycode = (RKD_KeyCode)*++bufferPtr)
         {
            // rewrite SHIFTED cursor keys to non-shifted with qualifier
            case 'T' : keycode = CURSOR_UP; break;
            case 'S' : keycode = CURSOR_DOWN; break;
            case '@' : keycode = CURSOR_RIGHT; break;
            case 'A' : keycode = CURSOR_LEFT; break;
         }
      }
   }
   else keycode = (RKD_KeyCode)*bufferPtr;
}
