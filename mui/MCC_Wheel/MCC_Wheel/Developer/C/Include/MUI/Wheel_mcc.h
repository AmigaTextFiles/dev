/*
**
** $VER: Wheel_mcc.h V19.0 (02.02.2000)
** Copyright © 2000 Henning Thielemann. All rights reserved.
**
** I've never used this file
**
*/

#ifndef   WHEEL_MCC_H
#define   WHEEL_MCC_H

#ifndef   EXEC_TYPES_H
#include  <exec/types.h>
#endif

#define   MUIC_Wheel     "Wheel.mcc"
#define   WheelObject    MUI_NewObject(MUIC_Wheel

#define   Wheel_Dummy   (0xf9f80200)

#define   MUIA_Wheel_BackgroundPenSpec (Wheel_Dummy + 0x06)  /*  V1 isg  * PenSpec       background pen for the wheel */
#define   MUIA_Wheel_BounceBack        (Wheel_Dummy + 0x05)  /*  V1 isg  BOOL            bounce back if the user release the wheel */
#define   MUIA_Wheel_Buffered          (Wheel_Dummy + 0x0d)  /*  V1 isg  BOOL            buffered display (less flickering) */
#define   MUIA_Wheel_EventPri          (Wheel_Dummy + 0x0c)  /*  V1 i.g  LONG            priority of the wheel's event handler (important for key redefinement) */
#define   MUIA_Wheel_HalfTurns         (Wheel_Dummy + 0x0a)  /*  V1 i.g  ULONG           number of half turns to get from numericMin to numericMax */
#define   MUIA_Wheel_Hollow            (Wheel_Dummy + 0x04)  /*  V1 i.g  BOOL            show a hollow at zero position */
#define   MUIA_Wheel_Horiz             (Wheel_Dummy + 0x00)  /*  V1 i.g  BOOL            horizontal or vertical direction */
#define   MUIA_Wheel_Infinit           (Wheel_Dummy + 0x0b)  /*  V1 i.g  BOOL            jump to numericMin when reaching numericMax and vice versa */
#define   MUIA_Wheel_Notches           (Wheel_Dummy + 0x01)  /*  V1 isg  ULONG           number of visible notches */
#define   MUIA_Wheel_NotchPenSpec      (Wheel_Dummy + 0x09)  /*  V1 isg  * PenSpec       pen for the notch tops */
#define   MUIA_Wheel_NotchWidth        (Wheel_Dummy + 0x02)  /*  V1 isg  ULONG           width of a notch as fraction of the space left by the slants, $10000 = 1.0 */
#define   MUIA_Wheel_ShadowPenSpec     (Wheel_Dummy + 0x08)  /*  V1 isg  * PenSpec       shadow pen for the notches */
#define   MUIA_Wheel_ShinePenSpec      (Wheel_Dummy + 0x07)  /*  V1 isg  * PenSpec       shine pen for the notches */
#define   MUIA_Wheel_SlantWidth        (Wheel_Dummy + 0x03)  /*  V1 isg  ULONG           width of both notch slants as fraction of one notch pattern, $10000 = 1.0 */


#endif /* WHEEL_MCC_H */

