/* $VER: identify_protos.h 11.0 (23.4.99) */
OPT NATIVE
PUBLIC MODULE 'target/libraries/identify'
MODULE 'target/exec/libraries', 'target/exec/types', 'target/utility/tagitem'
{MODULE 'identify'}

NATIVE {identifybase} DEF identifybase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {IdAlert} PROC
PROC IdAlert(param1:ULONG, param2:ARRAY OF tagitem) IS NATIVE {IdAlert(} param1 {,} param2 {)} ENDNATIVE !!VALUE
->NATIVE {IdAlertTags} PROC
->PROC IdAlertTags(param1:ULONG, param2:ULONG,param22=0:ULONG, param23=0:ULONG, param24=0:ULONG, param25=0:ULONG, param26=0:ULONG, param27=0:ULONG, param28=0:ULONG) IS NATIVE {IdAlertTags(} param1 {,} param2 {,} param22 {,} param23 {,} param24 {,} param25 {,} param26 {,} param27 {,} param28 {)} ENDNATIVE !!VALUE
NATIVE {IdEstimateFormatSize} PROC
PROC IdEstimateFormatSize(param1:/*STRPTR*/ ARRAY OF CHAR, param2:ARRAY OF tagitem) IS NATIVE {IdEstimateFormatSize(} param1 {,} param2 {)} ENDNATIVE !!ULONG
->NATIVE {IdEstimateFormatSizeTags} PROC
->PROC IdEstimateFormatSizeTags(param1:/*STRPTR*/ ARRAY OF CHAR, param2:ULONG,param22=0:ULONG, param23=0:ULONG, param24=0:ULONG, param25=0:ULONG, param26=0:ULONG, param27=0:ULONG, param28=0:ULONG) IS NATIVE {IdEstimateFormatSizeTags(} param1 {,} param2 {,} param22 {,} param23 {,} param24 {,} param25 {,} param26 {,} param27 {,} param28 {)} ENDNATIVE !!ULONG
NATIVE {IdExpansion} PROC
PROC IdExpansion(param1:ARRAY OF tagitem) IS NATIVE {IdExpansion(} param1 {)} ENDNATIVE !!VALUE
->NATIVE {IdExpansionTags} PROC
->PROC IdExpansionTags(param1:ULONG,param12=0:ULONG, param13=0:ULONG, param14=0:ULONG, param15=0:ULONG, param16=0:ULONG, param17=0:ULONG, param18=0:ULONG) IS NATIVE {IdExpansionTags(} param1 {,} param12 {,} param13 {,} param14 {,} param15 {,} param16 {,} param17 {,} param18 {)} ENDNATIVE !!VALUE
NATIVE {IdFormatString} PROC
PROC IdFormatString(param1:/*STRPTR*/ ARRAY OF CHAR, param2:/*STRPTR*/ ARRAY OF CHAR, param3:ULONG, param4:ARRAY OF tagitem) IS NATIVE {IdFormatString(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!ULONG
->NATIVE {IdFormatStringTags} PROC
->PROC IdFormatStringTags(param1:/*STRPTR*/ ARRAY OF CHAR, param2:/*STRPTR*/ ARRAY OF CHAR, param3:ULONG, param32=0:ULONG, param33=0:ULONG, param34=0:ULONG, param35=0:ULONG, param36=0:ULONG, param37=0:ULONG, param38=0:ULONG) IS NATIVE {IdFormatStringTags(} param1 {,} param2 {,} param3 {,} param32 {,} param33 {,} param34 {,} param35 {,} param36 {,} param37 {,} param38 {)} ENDNATIVE !!ULONG
NATIVE {IdFunction} PROC
PROC IdFunction(param1:/*STRPTR*/ ARRAY OF CHAR, param2:VALUE, param3:ARRAY OF tagitem) IS NATIVE {IdFunction(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!VALUE
->NATIVE {IdFunctionTags} PROC
->PROC IdFunctionTags(param1:/*STRPTR*/ ARRAY OF CHAR, param2:VALUE, param3:ULONG,param32=0:ULONG, param33=0:ULONG, param34=0:ULONG, param35=0:ULONG, param36=0:ULONG, param37=0:ULONG, param38=0:ULONG) IS NATIVE {IdFunctionTags(} param1 {,} param2 {,} param3 {,} param32 {,} param33 {,} param34 {,} param35 {,} param36 {,} param37 {,} param38 {)} ENDNATIVE !!VALUE
NATIVE {IdHardware} PROC
PROC IdHardware(param1:ULONG, param2:ARRAY OF tagitem) IS NATIVE {IdHardware(} param1 {,} param2 {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {IdHardwareTags} PROC
->PROC IdHardwareTags(param1:ULONG, param2:ULONG,param22=0:ULONG, param23=0:ULONG, param24=0:ULONG, param25=0:ULONG, param26=0:ULONG, param27=0:ULONG, param28=0:ULONG) IS NATIVE {IdHardwareTags(} param1 {,} param2 {,} param22 {,} param23 {,} param24 {,} param25 {,} param26 {,} param27 {,} param28 {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {IdHardwareNum} PROC
PROC IdHardwareNum(param1:ULONG, param2:ARRAY OF tagitem) IS NATIVE {IdHardwareNum(} param1 {,} param2 {)} ENDNATIVE !!ULONG
->NATIVE {IdHardwareNumTags} PROC
->PROC IdHardwareNumTags(param1:ULONG, param2:ULONG,param22=0:ULONG, param23=0:ULONG, param24=0:ULONG, param25=0:ULONG, param26=0:ULONG, param27=0:ULONG, param28=0:ULONG) IS NATIVE {IdHardwareNumTags(} param1 {,} param2 {,} param22 {,} param23 {,} param24 {,} param25 {,} param26 {,} param27 {,} param28 {)} ENDNATIVE !!ULONG
NATIVE {IdHardwareUpdate} PROC
PROC IdHardwareUpdate() IS NATIVE {IdHardwareUpdate()} ENDNATIVE
