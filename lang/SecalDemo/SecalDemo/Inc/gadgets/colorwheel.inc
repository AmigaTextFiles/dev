include "inc/utility/tagitem.inc";

struct ColorWheelHSB is
  cw_Hue:ulong;
  cw_Saturation:ulong;
  cw_Brightness:ulong;
;

struct ColorWheelRGB is
  cw_Red:ulong;
  cw_Green:ulong;
  cw_Blue:ulong;
;

def WHEEL_Dummy = (TAG_USER+$04000000);

def WHEEL_Hue = (WHEEL_Dummy+1);
def WHEEL_Saturation = (WHEEL_Dummy+2);
def WHEEL_Brightness = (WHEEL_Dummy+3);
def WHEEL_HSB = (WHEEL_Dummy+4);
def WHEEL_Red = (WHEEL_Dummy+5);
def WHEEL_Green = (WHEEL_Dummy+6);
def WHEEL_Blue = (WHEEL_Dummy+7);
def WHEEL_RGB = (WHEEL_Dummy+8);
def WHEEL_Screen = (WHEEL_Dummy+9);
def WHEEL_Abbrv = (WHEEL_Dummy+10);
def WHEEL_Donation = (WHEEL_Dummy+11);
def WHEEL_BevelBox = (WHEEL_Dummy+12);
def WHEEL_GradientSlider = (WHEEL_Dummy+13);
def WHEEL_MaxPens = (WHEEL_Dummy+14);

