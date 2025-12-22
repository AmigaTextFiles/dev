/* $VER: identify_protos.h 11.0 (23.4.99) */
OPT NATIVE
PUBLIC MODULE 'target/libraries/identify'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/types', 'target/utility/tagitem'
{
#include <proto/identify.h>
}
{
struct Library* IdentifyBase = NULL;
struct IdentifyIFace* IIdentify = NULL;
}
NATIVE {CLIB_IDENTIFY_PROTOS_H} CONST
NATIVE {PROTO_IDENTIFY_H} CONST
NATIVE {INLINE4_IDENTIFY_H} CONST
NATIVE {IDENTIFY_INTERFACE_DEF_H} CONST

NATIVE {IdentifyBase} DEF identifybase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IIdentify} DEF

PROC new()
	InitLibrary('identify.library', NATIVE {(struct Interface **) &IIdentify} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

NATIVE {IdAlert} PROC
PROC IdAlert(param1:ULONG, param2:ARRAY OF tagitem) IS NATIVE {IIdentify->IdAlert(} param1 {,} param2 {)} ENDNATIVE !!VALUE
->NATIVE {IdAlertTags} PROC
->PROC IdAlertTags(param1:ULONG, param2:ULONG,param22=0:ULONG, ...) IS NATIVE {IIdentify->IdAlertTags(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {IdEstimateFormatSize} PROC
PROC IdEstimateFormatSize(param1:/*STRPTR*/ ARRAY OF CHAR, param2:ARRAY OF tagitem) IS NATIVE {IIdentify->IdEstimateFormatSize(} param1 {,} param2 {)} ENDNATIVE !!ULONG
->NATIVE {IdEstimateFormatSizeTags} PROC
->PROC IdEstimateFormatSizeTags(param1:/*STRPTR*/ ARRAY OF CHAR, param2:ULONG,param22=0:ULONG, ...) IS NATIVE {IIdentify->IdEstimateFormatSizeTags(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {IdExpansion} PROC
PROC IdExpansion(param1:ARRAY OF tagitem) IS NATIVE {IIdentify->IdExpansion(} param1 {)} ENDNATIVE !!VALUE
->NATIVE {IdExpansionTags} PROC
->PROC IdExpansionTags(param1:ULONG,param12=0:ULONG, ...) IS NATIVE {IIdentify->IdExpansionTags(} param1 {,} param12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {IdFormatString} PROC
PROC IdFormatString(param1:/*STRPTR*/ ARRAY OF CHAR, param2:/*STRPTR*/ ARRAY OF CHAR, param3:ULONG, param4:ARRAY OF tagitem) IS NATIVE {IIdentify->IdFormatString(} param1 {,} param2 {,} param3 {,} param4 {)} ENDNATIVE !!ULONG
->NATIVE {IdFormatStringTags} PROC
->PROC IdFormatStringTags(param1:/*STRPTR*/ ARRAY OF CHAR, param2:/*STRPTR*/ ARRAY OF CHAR, param3:ULONG, param32=0:ULONG, ...) IS NATIVE {IIdentify->IdFormatStringTags(} param1 {,} param2 {,} param3 {,} param32 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {IdFunction} PROC
PROC IdFunction(param1:/*STRPTR*/ ARRAY OF CHAR, param2:VALUE, param3:ARRAY OF tagitem) IS NATIVE {IIdentify->IdFunction(} param1 {,} param2 {,} param3 {)} ENDNATIVE !!VALUE
->NATIVE {IdFunctionTags} PROC
->PROC IdFunctionTags(param1:/*STRPTR*/ ARRAY OF CHAR, param2:VALUE, param3:ULONG,param32=0:ULONG, ...) IS NATIVE {IIdentify->IdFunctionTags(} param1 {,} param2 {,} param3 {,} param32 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {IdHardware} PROC
PROC IdHardware(param1:ULONG, param2:ARRAY OF tagitem) IS NATIVE {IIdentify->IdHardware(} param1 {,} param2 {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {IdHardwareTags} PROC
->PROC IdHardwareTags(param1:ULONG, param2:ULONG,param22=0:ULONG, ...) IS NATIVE {IIdentify->IdHardwareTags(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
->NATIVE {IdHardwareNum} PROC
PROC IdHardwareNum(param1:ULONG, param2:ARRAY OF tagitem) IS NATIVE {IIdentify->IdHardwareNum(} param1 {,} param2 {)} ENDNATIVE !!ULONG
->NATIVE {IdHardwareNumTags} PROC
->PROC IdHardwareNumTags(param1:ULONG, param2:ULONG,param22=0:ULONG, ...) IS NATIVE {IIdentify->IdHardwareNumTags(} param1 {,} param2 {,} param22 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {IdHardwareUpdate} PROC
PROC IdHardwareUpdate() IS NATIVE {IIdentify->IdHardwareUpdate()} ENDNATIVE
