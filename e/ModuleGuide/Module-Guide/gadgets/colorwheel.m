@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "gadgets/colorwheel.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT colorwheelrgb
@{fg shine}(   0)@{fg text}   red:LONG
@{fg shine}(   4)@{fg text}   green:LONG
@{fg shine}(   8)@{fg text}   blue:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT colorwheelhsb
@{fg shine}(   0)@{fg text}   hue:LONG
@{fg shine}(   4)@{fg text}   saturation:LONG
@{fg shine}(   8)@{fg text}   brightness:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST WHEEL_DUMMY=$84000000,
      WHEEL_SCREEN=$84000009,
      WHEEL_GREEN=$84000006,
      WHEEL_DONATION=$8400000B,
      WHEEL_SATURATION=$84000002,
      WHEEL_BLUE=$84000007,
      WHEEL_ABBRV=$8400000A,
      WHEEL_HSB=$84000004,
      WHEEL_BRIGHTNESS=$84000003,
      WHEEL_BEVELBOX=$8400000C,
      WHEEL_RED=$84000005,
      WHEEL_HUE=$84000001,
      WHEEL_RGB=$84000008,
      WHEEL_MAXPENS=$8400000E,
      WHEEL_GRADIENTSLIDER=$8400000D
@endnode
