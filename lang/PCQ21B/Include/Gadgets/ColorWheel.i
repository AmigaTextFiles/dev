   {   Definitions for the colorwheel BOOPSI class     }

{***************************************************************************}

{$I "Include:Utility/TagItem.i"}

{***************************************************************************}

Type
{ For use with the WHEEL_HSB tag }
 ColorWheelHSB = Record
    cw_Hue,
    cw_Saturation,
    cw_Brightness  : Integer;
 end;
 ColorWheelHSBPtr = ^ColorWheelHSB;

{ For use with the WHEEL_RGB tag }
 ColorWheelRGB = Record
    cw_Red,
    cw_Green,
    cw_Blue  : Integer;
 end;
 ColorWheelRGBPtr = ^ColorWheelRGB;


{***************************************************************************}

const
    WHEEL_Dummy          = (TAG_USER+$04000000);
    WHEEL_Hue            = (WHEEL_Dummy+1) ;  { set/get Hue              }
    WHEEL_Saturation     = (WHEEL_Dummy+2) ;  { set/get Saturation        }
    WHEEL_Brightness     = (WHEEL_Dummy+3) ;  { set/get Brightness        }
    WHEEL_HSB            = (WHEEL_Dummy+4) ;  { set/get ColorWheelHSB     }
    WHEEL_Red            = (WHEEL_Dummy+5) ;  { set/get Red               }
    WHEEL_Green          = (WHEEL_Dummy+6) ;  { set/get Green     }
    WHEEL_Blue           = (WHEEL_Dummy+7) ;  { set/get Blue              }
    WHEEL_RGB            = (WHEEL_Dummy+8) ;  { set/get ColorWheelRGB     }
    WHEEL_Screen         = (WHEEL_Dummy+9) ;  { init screen/enviroment    }
    WHEEL_Abbrv          = (WHEEL_Dummy+10);  { "GCBMRY" if English       }
    WHEEL_Donation       = (WHEEL_Dummy+11);  { colors donated by app     }
    WHEEL_BevelBox       = (WHEEL_Dummy+12);  { inside a bevel box        }
    WHEEL_GradientSlider = (WHEEL_Dummy+13);  { attached gradient slider  }
    WHEEL_MaxPens        = (WHEEL_Dummy+14);  { max # of pens to allocate }


{***************************************************************************}

{--- functions in V39 or higher (Release 3) ---}

PROCEDURE ConvertHSBToRGB(hsb : ColorWheelHSBPtr; rgb : ColorWheelRGBPtr);
    External;

PROCEDURE ConvertRGBToHSB(rgb : ColorWheelRGBPtr; hsb : ColorWheelHSBPtr);
    External;



