/*
        radiadiallib.h

        © 1997 HAAGE & PARTNER Computer GmbH

        written by Jan-Claas Dirks

        This is the header file for the
        wizard_radiodial.library.
        The tags the gadget will listen to
        on funcztion calls like SetGadgetAttrs()
        are defined here.

        By using WEXTERNA_Data?, you can preset
        these tags in the StormWIZARD editor
        on the Attributes/Extern page -
        if they are number values.
*/

#ifndef RADIODIALLIB_H
#define RADIODIALLIB_H

#include <utility/tagitem.h>
#include <libraries/wizard.h>


// The lower limit of the range
// the numbers of this gadget may be in.
#define RADIODIAL_MinLimit      WEXTERNA_Data0              // ISG--

// The upper limit of the range
// the numbers of this gadget may be in.
#define RADIODIAL_MaxLimit      WEXTERNA_Data1              // ISG--

// The value that this gadget represents.
#define RADIODIAL_Value         WEXTERNA_Data2              // ISGN-

// The user can turn the dial RasterSteps times
// until the knob has turned 360 degrees.
#define RADIODIAL_RasterSteps   WEXTERNA_Data3              // I----

// The lower limit is represented at this
// RasterOffset. 0 is at 12 o'clock. Given
// 100 RasterSteps, -25 would be 9 o'clock.
#define RADIODIAL_RasterOffset  WEXTERNA_Data4              // I----

#endif

