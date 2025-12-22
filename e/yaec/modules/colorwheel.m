OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V39 or higher (Release 3) ---
-> 
->  Public entries
-> 
MACRO ConvertHSBToRGB(hsb,rgb) IS Stores(colorwheelbase,hsb,rgb) BUT Loads(A6,A0,A1) BUT ASM ' jsr -30(a6)'
MACRO ConvertRGBToHSB(rgb,hsb) IS Stores(colorwheelbase,rgb,hsb) BUT Loads(A6,A0,A1) BUT ASM ' jsr -36(a6)'
