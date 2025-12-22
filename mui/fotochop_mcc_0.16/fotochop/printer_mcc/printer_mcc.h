


/*** Include stuff ***/

#ifndef PRINTER_MCC_H
#define PRINTER_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif


/*** MUI Defines ***/

#define MUIC_Printer "printer.mcc"
#define PrinterObject MUI_NewObject(MUIC_Printer


/*** Method structs ***/

struct MUIP_PRINTER_String { ULONG MessageID; STRPTR String; };
struct MUIP_PRINTER_Number { ULONG MessageID; ULONG Number; };
struct MUIP_PRINTER_Object { ULONG MessageID; Object *obj; };


/*** Methods ***/

#define MUISERIALNO_CARSTEN 0xfed6


#define MUIA_PRINTER_ED MUISERIALNO_CARSTEN + 130

#define MUIM_PRINTER_PRINT_PAGE MUISERIALNO_CARSTEN + 131
#define MUIM_PRINTER_PRINT_ALL MUISERIALNO_CARSTEN + 132

#define MUIA_PRINTER_OUT MUISERIALNO_CARSTEN + 133
#define MUIA_PRINTER_DEVICE MUISERIALNO_CARSTEN + 134
#define MUIA_PRINTER_UNIT MUISERIALNO_CARSTEN + 135
#define MUIA_PRINTER_PATH MUISERIALNO_CARSTEN + 136
#define MUIA_PRINTER_PS_LEVEL MUISERIALNO_CARSTEN + 137
#define MUIA_PRINTER_PDF_LEVEL MUISERIALNO_CARSTEN + 138















#endif /* PRINTER_MCC_H */


