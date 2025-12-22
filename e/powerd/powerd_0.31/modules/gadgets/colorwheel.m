OBJECT ColorWheelHSB
  cw_Hue:ULONG,
  cw_Saturation:ULONG,
  cw_Brightness:ULONG

OBJECT ColorWheelRGB
  cw_Red:ULONG,
  cw_Green:ULONG,
  cw_Blue:ULONG

CONST WHEEL_Dummy=$84000000,
    WHEEL_Hue=$84000001,
    WHEEL_Saturation=$84000002,
    WHEEL_Brightness=$84000003,
    WHEEL_HSB=$84000004,
    WHEEL_Red=$84000005,
    WHEEL_Green=$84000006,
    WHEEL_Blue=$84000007,
    WHEEL_RGB=$84000008,
    WHEEL_Screen=$84000009,
    WHEEL_ABBRV=$8400000A,
    WHEEL_Donation=$8400000B,
    WHEEL_BevelBox=$8400000C,
    WHEEL_GradientSlider=$8400000D,
    WHEEL_MaxPens=$8400000E
