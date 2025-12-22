/*
 * NAME
 *   Envelope_mcc.h - 22-Nov-1998
 *
 * AUTHOR
 *   Jon Rocatis, (c) Copyright 1999
 *
 * DESCRIPTION
 *   Registered class of the Magic User Interface
 *
 */

/*** Include stuff ***/

#ifndef _ENVELOPE_MCC_H_
#define _ENVELOPE_MCC_H_

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif

#define MUI_ENVELOPE_TAGBASE      ((TAG_USER | (307 << 16)) | 0x1000)

/*** MUI Defines ***/

#define MUIC_Envelope  "Envelope.mcc"

#define EnvelopeObject MUI_NewObject(MUIC_Envelope

/*** Methods ***/

#define MUIM_Envelope_SetKnobs           (MUI_ENVELOPE_TAGBASE | 0)

/*** Method structs ***/

/*** Special method values ***/

/*** Special method flags ***/

/*** Attributes ***/

#define MUIA_Envelope_Text               (MUI_ENVELOPE_TAGBASE | 100)
#define MUIA_Envelope_NoL4               (MUI_ENVELOPE_TAGBASE | 101)
#define MUIA_Envelope_ZeroLine           (MUI_ENVELOPE_TAGBASE | 102)
#define MUIA_Envelope_Func               (MUI_ENVELOPE_TAGBASE | 103)
#define MUIA_Envelope_StartAtBottom      (MUI_ENVELOPE_TAGBASE | 104)
#define MUIA_Envelope_EndLine            (MUI_ENVELOPE_TAGBASE | 105)
#define MUIA_Envelope_BackPen            (MUI_ENVELOPE_TAGBASE | 106)
#define MUIA_Envelope_FrontPen           (MUI_ENVELOPE_TAGBASE | 107)
#define MUIA_Envelope_TextAdjust         (MUI_ENVELOPE_TAGBASE | 108)
#define MUIA_Envelope_MinLevel           (MUI_ENVELOPE_TAGBASE | 109)
#define MUIA_Envelope_DisplayLevelAdjust (MUI_ENVELOPE_TAGBASE | 110)

/*** Special attribute values ***/

/*** Structures, Flags & Values ***/

typedef struct
{
  LONG nTime;
  LONG nLevel;
  
} EnvelopeKnob_t;


typedef struct 
{
  EnvelopeKnob_t atKnobs[4];

} EnvelopeUpdateData_t;

typedef EnvelopeUpdateData_t* EnvelopeUpdateData_pt;


struct EnvelopeCallbackData
{
  EnvelopeKnob_t atKnobs[4];
  UBYTE nKnob;                // The knob number the user is playing with [0;3]
};

/*** Configs ***/

#endif /* ENVELOPE_MCC_H */

