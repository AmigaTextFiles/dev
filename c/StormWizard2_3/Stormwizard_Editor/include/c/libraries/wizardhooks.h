#ifndef WIZARD_WIZARDHOOKS_H
#define WIZARD_WIZARDHOOKS_H

/*
**  $VER: wizardhooks.h 40.1 (29.01.2005)
**
**  © 1996-2005 HAAGE & PARTNER,  All Rights Reserved
**
*/

/****************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __GNUC__
   #ifdef __PPC__
    #pragma pack(2)
   #endif
#elif defined(__VBCC__)
   #pragma amiga-align
#endif

/****************************************************************************/

/*
** Public Hook-Methods
*/

#define WBUTTONM_INFO           0x100F00
#define WSLIDERM_RENDER         0x100F01


/*
** WBUTTONM_INFO:
**
** returnvalue is not defined.
**
** If the Hook doesn't handle this method, he can ignore it.
*/

struct WizardButtonInfo
{
    ULONG                       MethodID;
    struct WizardViewInfo       *wbp_State;
};



/*
** WSLIDERM_RENDER:
**
** returnvalue is not defined.
**
** If the Hook doesn't handle this method, he can ignore it.
*/

struct WizardSliderRender
{
    ULONG                       MethodID;
    struct RastPort             *wpsl_RastPort;
    struct IBox                 wpsl_Bounds;
    struct IBox                 wpsl_KnobBounds;
};

/****************************************************************************/

#ifdef __GNUC__
   #ifdef __PPC__
    #pragma pack()
   #endif
#elif defined(__VBCC__)
   #pragma default-align
#endif

#ifdef __cplusplus
}
#endif

/****************************************************************************/

#endif /* WIZARD_WIZARDHOOK_H */

