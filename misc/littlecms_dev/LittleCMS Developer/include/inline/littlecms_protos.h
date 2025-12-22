/* Automatically generated header! Do not edit! */

#ifndef _VBCCINLINE_LITTLECMS_H
#define _VBCCINLINE_LITTLECMS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EMUL_EMULREGS_H
#include <emul/emulregs.h>
#endif

gBOOL  __cmsBuildRGB2XYZtransferMatrix(LPMAT3 , LPcmsCIExyY , LPcmsCIExyYTRIPLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-202(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsBuildRGB2XYZtransferMatrix(__p0, __p1, __p2) __cmsBuildRGB2XYZtransferMatrix((__p0), (__p1), (__p2))

gBOOL  __cmsTakeCreationDateTime(struct tm *, cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-418(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeCreationDateTime(__p0, __p1) __cmsTakeCreationDateTime((__p0), (__p1))

gBOOL  __cmsCloseProfile(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-52(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCloseProfile(__p0) __cmsCloseProfile((__p0))

int  __cmsErrorAction(int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-664(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsErrorAction(__p0) __cmsErrorAction((__p0))

void  __cmsCIECAM97sDone(LCMSHANDLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-214(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIECAM97sDone(__p0) __cmsCIECAM97sDone((__p0))

cmsHPROFILE  __cmsCreateLinearizationDeviceLink(icColorSpaceSignature , LPGAMMATABLE *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-70(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateLinearizationDeviceLink(__p0, __p1) __cmsCreateLinearizationDeviceLink((__p0), (__p1))

void  __cmsLab2XYZ(LPcmsCIEXYZ , LPcmsCIEXYZ , const cmsCIELab *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-136(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsLab2XYZ(__p0, __p1, __p2) __cmsLab2XYZ((__p0), (__p1), (__p2))

void  __cmsXYZ2Lab(LPcmsCIEXYZ , LPcmsCIELab , const cmsCIEXYZ *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-130(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsXYZ2Lab(__p0, __p1, __p2) __cmsXYZ2Lab((__p0), (__p1), (__p2))

void  __cmsDoTransform(cmsHTRANSFORM , LPVOID , LPVOID , unsigned int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-574(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsDoTransform(__p0, __p1, __p2, __p3) __cmsDoTransform((__p0), (__p1), (__p2), (__p3))

const char * __cmsIT8GetSheetType(LCMSHANDLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-790(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetSheetType(__p0) __cmsIT8GetSheetType((__p0))

void  ___cmsSetLUTdepth(cmsHPROFILE , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-628(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define _cmsSetLUTdepth(__p0, __p1) ___cmsSetLUTdepth((__p0), (__p1))

int  __cmsTakeRenderingIntent(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-436(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeRenderingIntent(__p0) __cmsTakeRenderingIntent((__p0))

gBOOL  __cmsWhitePointFromTemp(int , LPcmsCIExyY ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-190(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsWhitePointFromTemp(__p0, __p1) __cmsWhitePointFromTemp((__p0), (__p1))

gBOOL  __cmsIsTag(cmsHPROFILE , icTagSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-430(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIsTag(__p0, __p1) __cmsIsTag((__p0), (__p1))

LCMSHANDLE  __cmsCIECAM97sInit(LPcmsViewingConditions ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-208(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIECAM97sInit(__p0) __cmsCIECAM97sInit((__p0))

void  __cmsChangeBuffersFormat(cmsHTRANSFORM , DWORD , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-580(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsChangeBuffersFormat(__p0, __p1, __p2) __cmsChangeBuffersFormat((__p0), (__p1), (__p2))

double  __cmsEstimateGamma(LPGAMMATABLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-316(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsEstimateGamma(__p0) __cmsEstimateGamma((__p0))

LCMSHANDLE  __cmsIT8Alloc() =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-748(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8Alloc() __cmsIT8Alloc()

LPLUT  __cmsAllocLUT() =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-676(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsAllocLUT() __cmsAllocLUT()

int  ___cmsChannelsOf(icColorSpaceSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-472(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define _cmsChannelsOf(__p0) ___cmsChannelsOf((__p0))

icInt32Number  __cmsGetTagCount(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-952(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetTagCount(__p0) __cmsGetTagCount((__p0))

const char * __cmsIT8GetPatchName(LCMSHANDLE , int , char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-916(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetPatchName(__p0, __p1, __p2) __cmsIT8GetPatchName((__p0), (__p1), (__p2))

void  __cmsGetUserFormatters(cmsHTRANSFORM , LPDWORD , cmsFORMATTER *, LPDWORD , cmsFORMATTER *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-742(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetUserFormatters(__p0, __p1, __p2, __p3, __p4) __cmsGetUserFormatters((__p0), (__p1), (__p2), (__p3), (__p4))

icProfileClassSignature  __cmsGetDeviceClass(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-496(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetDeviceClass(__p0) __cmsGetDeviceClass((__p0))

LPLUT  __cmsSetMatrixLUT4(LPLUT , LPMAT3 , LPVEC3 , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-700(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetMatrixLUT4(__p0, __p1, __p2, __p3) __cmsSetMatrixLUT4((__p0), (__p1), (__p2), (__p3))

gBOOL  __cmsIT8SetPropertyHex(LCMSHANDLE , const char *, int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-820(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetPropertyHex(__p0, __p1, __p2) __cmsIT8SetPropertyHex((__p0), (__p1), (__p2))

double  __cmsIT8GetPropertyDbl(LCMSHANDLE , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-838(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetPropertyDbl(__p0, __p1) __cmsIT8GetPropertyDbl((__p0), (__p1))

int  __cmsIT8EnumDataFormat(LCMSHANDLE , char ***) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-910(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8EnumDataFormat(__p0, __p1) __cmsIT8EnumDataFormat((__p0), (__p1))

gBOOL  __cmsIT8SetDataDbl(LCMSHANDLE , const char *, const char *, double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-892(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetDataDbl(__p0, __p1, __p2, __p3) __cmsIT8SetDataDbl((__p0), (__p1), (__p2), (__p3))

int  __cmsNamedColorCount(cmsHTRANSFORM ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-598(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsNamedColorCount(__p0) __cmsNamedColorCount((__p0))

LPGAMMATABLE  __cmsReadICCGamma(cmsHPROFILE , icTagSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-328(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsReadICCGamma(__p0, __p1) __cmsReadICCGamma((__p0), (__p1))

int  __cmsReadICCText(cmsHPROFILE , icTagSignature , char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-448(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsReadICCText(__p0, __p1, __p2) __cmsReadICCText((__p0), (__p1), (__p2))

const char * __cmsTakeProductInfo(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-388(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeProductInfo(__p0) __cmsTakeProductInfo((__p0))

void  __cmsSetPCS(cmsHPROFILE , icColorSpaceSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-526(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetPCS(__p0, __p1) __cmsSetPCS((__p0), (__p1))

void  __cmsSetUserFormatters(cmsHTRANSFORM , DWORD , cmsFORMATTER , DWORD , cmsFORMATTER ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-736(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetUserFormatters(__p0, __p1, __p2, __p3, __p4) __cmsSetUserFormatters((__p0), (__p1), (__p2), (__p3), (__p4))

LPcmsCIEXYZ  __cmsD50_XYZ() =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-28(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsD50_XYZ() __cmsD50_XYZ()

gBOOL  ___cmsIsMatrixShaper(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-970(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define _cmsIsMatrixShaper(__p0) ___cmsIsMatrixShaper((__p0))

gBOOL  __cmsIsIntentSupported(cmsHPROFILE , int , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-478(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIsIntentSupported(__p0, __p1, __p2) __cmsIsIntentSupported((__p0), (__p1), (__p2))

DWORD  __cmsGetPostScriptCRD(cmsHPROFILE , int , LPVOID , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-652(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetPostScriptCRD(__p0, __p1, __p2, __p3) __cmsGetPostScriptCRD((__p0), (__p1), (__p2), (__p3))

gBOOL  __cmsIT8SetComment(LCMSHANDLE , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-802(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetComment(__p0, __p1) __cmsIT8SetComment((__p0), (__p1))

DWORD  __cmsTakeHeaderAttributes(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-946(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeHeaderAttributes(__p0) __cmsTakeHeaderAttributes((__p0))

void  __cmsIT8Free(LCMSHANDLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-754(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8Free(__p0) __cmsIT8Free((__p0))

void  __cmsLCh2Lab(LPcmsCIELab , const cmsCIELCh *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-148(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsLCh2Lab(__p0, __p1) __cmsLCh2Lab((__p0), (__p1))

void  __cmsLab2LCh(LPcmsCIELCh , const cmsCIELab *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-142(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsLab2LCh(__p0, __p1) __cmsLab2LCh((__p0), (__p1))

void  __cmsCIECAM02Forward(LCMSHANDLE , LPcmsCIEXYZ , LPcmsJCh ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-244(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIECAM02Forward(__p0, __p1, __p2) __cmsCIECAM02Forward((__p0), (__p1), (__p2))

double  __cmsEvalLUTreverse(LPLUT , gWORD *, gWORD *, LPWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-988(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsEvalLUTreverse(__p0, __p1, __p2, __p3) __cmsEvalLUTreverse((__p0), (__p1), (__p2), (__p3))

void  __cmsGetAlarmCodes(int *, int *, int *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-592(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetAlarmCodes(__p0, __p1, __p2) __cmsGetAlarmCodes((__p0), (__p1), (__p2))

double  __cmsCIE2000DeltaE(LPcmsCIELab , LPcmsCIELab , double , double , double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-178(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIE2000DeltaE(__p0, __p1, __p2, __p3, __p4) __cmsCIE2000DeltaE((__p0), (__p1), (__p2), (__p3), (__p4))

gBOOL  __cmsIT8SetDataRowColDbl(LCMSHANDLE , int , int , double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-868(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetDataRowColDbl(__p0, __p1, __p2, __p3) __cmsIT8SetDataRowColDbl((__p0), (__p1), (__p2), (__p3))

const gBYTE * __cmsTakeProfileID(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-412(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeProfileID(__p0) __cmsTakeProfileID((__p0))

gBOOL  __cmsAddTag(cmsHPROFILE , icTagSignature , void *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-616(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsAddTag(__p0, __p1, __p2) __cmsAddTag((__p0), (__p1), (__p2))

void  __cmsSetAlarmCodes(int , int , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-586(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetAlarmCodes(__p0, __p1, __p2) __cmsSetAlarmCodes((__p0), (__p1), (__p2))

void  __cmsXYZ2xyY(LPcmsCIExyY , const cmsCIEXYZ *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-118(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsXYZ2xyY(__p0, __p1) __cmsXYZ2xyY((__p0), (__p1))

void  __cmsCIECAM02Done(LCMSHANDLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-238(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIECAM02Done(__p0) __cmsCIECAM02Done((__p0))

cmsHPROFILE  __cmsTransform2DeviceLink(cmsHTRANSFORM , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-622(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTransform2DeviceLink(__p0, __p1) __cmsTransform2DeviceLink((__p0), (__p1))

LPGAMMATABLE  __cmsReadICCGammaReversed(cmsHPROFILE , icTagSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-334(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsReadICCGammaReversed(__p0, __p1) __cmsReadICCGammaReversed((__p0), (__p1))

gBOOL  __cmsNamedColorInfo(cmsHTRANSFORM , int , char *, char *, char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-604(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsNamedColorInfo(__p0, __p1, __p2, __p3, __p4) __cmsNamedColorInfo((__p0), (__p1), (__p2), (__p3), (__p4))

cmsHTRANSFORM  __cmsCreateTransform(cmsHPROFILE , DWORD , cmsHPROFILE , DWORD , int , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-550(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateTransform(__p0, __p1, __p2, __p3, __p4, __p5) __cmsCreateTransform((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

cmsHPROFILE  __cmsCreateBCHSWabstractProfile(int , double , double , double , double , int , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-106(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateBCHSWabstractProfile(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __cmsCreateBCHSWabstractProfile((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

DWORD  __cmsGetPostScriptCRDEx(cmsHPROFILE , int , DWORD , LPVOID , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-658(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetPostScriptCRDEx(__p0, __p1, __p2, __p3, __p4) __cmsGetPostScriptCRDEx((__p0), (__p1), (__p2), (__p3), (__p4))

DWORD  __cmsGetPostScriptCSA(cmsHPROFILE , int , LPVOID , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-646(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetPostScriptCSA(__p0, __p1, __p2, __p3) __cmsGetPostScriptCSA((__p0), (__p1), (__p2), (__p3))

cmsHPROFILE  __cmsCreateLabProfile(LPcmsCIExyY ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-82(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateLabProfile(__p0) __cmsCreateLabProfile((__p0))

cmsHPROFILE  __cmsCreateGrayProfile(LPcmsCIExyY , LPGAMMATABLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-64(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateGrayProfile(__p0, __p1) __cmsCreateGrayProfile((__p0), (__p1))

LCMSHANDLE  __cmsCIECAM02Init(LPcmsViewingConditions ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-232(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIECAM02Init(__p0) __cmsCIECAM02Init((__p0))

gBOOL  __cmsTakeColorants(LPcmsCIEXYZTRIPLE , cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-358(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeColorants(__p0, __p1) __cmsTakeColorants((__p0), (__p1))

void  __cmsCIECAM97sForward(LCMSHANDLE , LPcmsCIEXYZ , LPcmsJCh ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-220(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIECAM97sForward(__p0, __p1, __p2) __cmsCIECAM97sForward((__p0), (__p1), (__p2))

int  __cmsNamedColorIndex(cmsHTRANSFORM , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-610(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsNamedColorIndex(__p0, __p1) __cmsNamedColorIndex((__p0), (__p1))

gBOOL  __cmsSmoothGamma(LPGAMMATABLE , double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-310(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSmoothGamma(__p0, __p1) __cmsSmoothGamma((__p0), (__p1))

const char * __cmsTakeCopyright(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-406(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeCopyright(__p0) __cmsTakeCopyright((__p0))

gBOOL  ___cmsSaveProfileToMem(cmsHPROFILE , void *, size_t *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-640(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define _cmsSaveProfileToMem(__p0, __p1, __p2) ___cmsSaveProfileToMem((__p0), (__p1), (__p2))

double  __cmsCMCdeltaE(LPcmsCIELab , LPcmsCIELab ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-172(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCMCdeltaE(__p0, __p1) __cmsCMCdeltaE((__p0), (__p1))

int  __cmsIT8SetTableByLabel(LCMSHANDLE , const char *, const char *, const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-922(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetTableByLabel(__p0, __p1, __p2, __p3) __cmsIT8SetTableByLabel((__p0), (__p1), (__p2), (__p3))

const char * __cmsIT8GetDataRowCol(LCMSHANDLE , int , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-850(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetDataRowCol(__p0, __p1, __p2) __cmsIT8GetDataRowCol((__p0), (__p1), (__p2))

icColorSpaceSignature  __cmsGetColorSpace(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-490(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetColorSpace(__p0) __cmsGetColorSpace((__p0))

gBOOL  __cmsIT8SetDataRowCol(LCMSHANDLE , int , int , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-862(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetDataRowCol(__p0, __p1, __p2, __p3) __cmsIT8SetDataRowCol((__p0), (__p1), (__p2), (__p3))

const char * __cmsTakeManufacturer(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-394(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeManufacturer(__p0) __cmsTakeManufacturer((__p0))

LPcmsCIExyY  __cmsD50_xyY() =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-34(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsD50_xyY() __cmsD50_xyY()

void  __cmsSetProfileICCversion(cmsHPROFILE , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-508(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetProfileICCversion(__p0, __p1) __cmsSetProfileICCversion((__p0), (__p1))

const char * __cmsTakeModel(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-400(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeModel(__p0) __cmsTakeModel((__p0))

void  __cmsSetColorSpace(cmsHPROFILE , icColorSpaceSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-520(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetColorSpace(__p0, __p1) __cmsSetColorSpace((__p0), (__p1))

void  __cmsFreeLUT(LPLUT ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-706(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsFreeLUT(__p0) __cmsFreeLUT((__p0))

int  ___cmsLCMScolorSpace(icColorSpaceSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-466(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define _cmsLCMScolorSpace(__p0) ___cmsLCMScolorSpace((__p0))

gBOOL  __cmsTakeCalibrationDateTime(struct tm *, cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-424(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeCalibrationDateTime(__p0, __p1) __cmsTakeCalibrationDateTime((__p0), (__p1))

void  __cmsClampLab(LPcmsCIELab , double , double , double , double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-184(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsClampLab(__p0, __p1, __p2, __p3, __p4) __cmsClampLab((__p0), (__p1), (__p2), (__p3), (__p4))

gBOOL  __cmsIT8SetPropertyUncooked(LCMSHANDLE , const char *, const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-826(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetPropertyUncooked(__p0, __p1, __p2) __cmsIT8SetPropertyUncooked((__p0), (__p1), (__p2))

LPGAMMATABLE  __cmsReverseGamma(int , LPGAMMATABLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-292(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsReverseGamma(__p0, __p1) __cmsReverseGamma((__p0), (__p1))

LPcmsNAMEDCOLORLIST  __cmsReadColorantTable(cmsHPROFILE , icTagSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-994(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsReadColorantTable(__p0, __p1) __cmsReadColorantTable((__p0), (__p1))

gBOOL  __cmsIT8SaveToFile(LCMSHANDLE , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-784(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SaveToFile(__p0, __p1) __cmsIT8SaveToFile((__p0), (__p1))

gBOOL  __cmsAdaptToIlluminant(LPcmsCIEXYZ , LPcmsCIEXYZ , LPcmsCIEXYZ , LPcmsCIEXYZ ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-196(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsAdaptToIlluminant(__p0, __p1, __p2, __p3) __cmsAdaptToIlluminant((__p0), (__p1), (__p2), (__p3))

cmsHTRANSFORM  __cmsCreateMultiprofileTransform(cmsHPROFILE *, int , DWORD , DWORD , int , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-562(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateMultiprofileTransform(__p0, __p1, __p2, __p3, __p4, __p5) __cmsCreateMultiprofileTransform((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

double  __cmsCIE94DeltaE(LPcmsCIELab , LPcmsCIELab ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-160(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIE94DeltaE(__p0, __p1) __cmsCIE94DeltaE((__p0), (__p1))

icTagSignature  __cmsGetTagSignature(cmsHPROFILE , icInt32Number ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-958(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetTagSignature(__p0, __p1) __cmsGetTagSignature((__p0), (__p1))

const char * __cmsIT8GetData(LCMSHANDLE , const char *, const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-874(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetData(__p0, __p1, __p2) __cmsIT8GetData((__p0), (__p1), (__p2))

LPGAMMATABLE  __cmsBuildGamma(int , double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-256(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsBuildGamma(__p0, __p1) __cmsBuildGamma((__p0), (__p1))

void  __cmsFreeGammaTriple(LPGAMMATABLE *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-280(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsFreeGammaTriple(__p0) __cmsFreeGammaTriple((__p0))

gBOOL  __cmsTakeIluminant(LPcmsCIEXYZ , cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-352(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeIluminant(__p0, __p1) __cmsTakeIluminant((__p0), (__p1))

cmsHPROFILE  __cmsOpenProfileFromFile(const char *, const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-40(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsOpenProfileFromFile(__p0, __p1) __cmsOpenProfileFromFile((__p0), (__p1))

icColorSpaceSignature  ___cmsICCcolorSpace(int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-460(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define _cmsICCcolorSpace(__p0) ___cmsICCcolorSpace((__p0))

gBOOL  __cmsIT8SetData(LCMSHANDLE , const char *, const char *, const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-886(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetData(__p0, __p1, __p2, __p3) __cmsIT8SetData((__p0), (__p1), (__p2), (__p3))

LPGAMMATABLE  __cmsBuildParametricGamma(int , int , double *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-262(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsBuildParametricGamma(__p0, __p1, __p2) __cmsBuildParametricGamma((__p0), (__p1), (__p2))

gBOOL  __cmsIT8SetSheetType(LCMSHANDLE , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-796(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetSheetType(__p0, __p1) __cmsIT8SetSheetType((__p0), (__p1))

LPLUT  __cmsDupLUT(LPLUT ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-724(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsDupLUT(__p0) __cmsDupLUT((__p0))

void  __cmsCIECAM02Reverse(LCMSHANDLE , LPcmsJCh , LPcmsCIEXYZ ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-250(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIECAM02Reverse(__p0, __p1, __p2) __cmsCIECAM02Reverse((__p0), (__p1), (__p2))

double  __cmsIT8GetDataDbl(LCMSHANDLE , const char *, const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-880(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetDataDbl(__p0, __p1, __p2) __cmsIT8GetDataDbl((__p0), (__p1), (__p2))

const char * __cmsTakeProductDesc(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-382(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeProductDesc(__p0) __cmsTakeProductDesc((__p0))

icColorSpaceSignature  __cmsGetPCS(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-484(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetPCS(__p0) __cmsGetPCS((__p0))

const char * __cmsTakeProductName(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-376(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeProductName(__p0) __cmsTakeProductName((__p0))

int  __cmsIT8SetTable(LCMSHANDLE , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-766(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetTable(__p0, __p1) __cmsIT8SetTable((__p0), (__p1))

void  __cmsSetProfileID(cmsHPROFILE , LPBYTE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-544(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetProfileID(__p0, __p1) __cmsSetProfileID((__p0), (__p1))

LPGAMMATABLE  __cmsDupGamma(LPGAMMATABLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-286(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsDupGamma(__p0) __cmsDupGamma((__p0))

LPGAMMATABLE  __cmsAllocGamma(int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-268(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsAllocGamma(__p0) __cmsAllocGamma((__p0))

LPLUT  __cmsAllocLinearTable(LPLUT , LPGAMMATABLE *, int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-682(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsAllocLinearTable(__p0, __p1, __p2) __cmsAllocLinearTable((__p0), (__p1), (__p2))

double  __cmsDeltaE(LPcmsCIELab , LPcmsCIELab ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-154(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsDeltaE(__p0, __p1) __cmsDeltaE((__p0), (__p1))

LPGAMMATABLE  __cmsJoinGammaEx(LPGAMMATABLE , LPGAMMATABLE , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-304(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsJoinGammaEx(__p0, __p1, __p2) __cmsJoinGammaEx((__p0), (__p1), (__p2))

gBOOL  __cmsTakeMediaWhitePoint(LPcmsCIEXYZ , cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-340(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeMediaWhitePoint(__p0, __p1) __cmsTakeMediaWhitePoint((__p0), (__p1))

void  __cmsSetDeviceClass(cmsHPROFILE , icProfileClassSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-514(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetDeviceClass(__p0, __p1) __cmsSetDeviceClass((__p0), (__p1))

cmsHTRANSFORM  __cmsCreateProofingTransform(cmsHPROFILE , DWORD , cmsHPROFILE , DWORD , cmsHPROFILE , int , int , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-556(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateProofingTransform(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7) __cmsCreateProofingTransform((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6), (__p7))

void  __cmsSetErrorHandler(cmsErrorHandlerFunction ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-670(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetErrorHandler(__p0) __cmsSetErrorHandler((__p0))

double  __cmsIT8GetDataRowColDbl(LCMSHANDLE , int , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-856(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetDataRowColDbl(__p0, __p1, __p2) __cmsIT8GetDataRowColDbl((__p0), (__p1), (__p2))

gBOOL  __cmsIT8SetPropertyDbl(LCMSHANDLE , const char *, double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-814(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetPropertyDbl(__p0, __p1, __p2) __cmsIT8SetPropertyDbl((__p0), (__p1), (__p2))

DWORD  __cmsTakeHeaderFlags(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-364(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeHeaderFlags(__p0) __cmsTakeHeaderFlags((__p0))

void  __cmsSetRenderingIntent(cmsHPROFILE , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-532(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetRenderingIntent(__p0, __p1) __cmsSetRenderingIntent((__p0), (__p1))

void  __cmsSetHeaderAttributes(cmsHPROFILE , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-940(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetHeaderAttributes(__p0, __p1) __cmsSetHeaderAttributes((__p0), (__p1))

gBOOL  ___cmsSaveProfile(cmsHPROFILE , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-634(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define _cmsSaveProfile(__p0, __p1) ___cmsSaveProfile((__p0), (__p1))

cmsHPROFILE  __cmsCreateNULLProfile() =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-112(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateNULLProfile() __cmsCreateNULLProfile()

void  __cmsCIECAM97sReverse(LCMSHANDLE , LPcmsJCh , LPcmsCIEXYZ ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-226(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCIECAM97sReverse(__p0, __p1, __p2) __cmsCIECAM97sReverse((__p0), (__p1), (__p2))

gBOOL  __cmsTakeCharTargetData(cmsHPROFILE , char **, size_t *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-442(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeCharTargetData(__p0, __p1, __p2) __cmsTakeCharTargetData((__p0), (__p1), (__p2))

void  __cmsFreeGamma(LPGAMMATABLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-274(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsFreeGamma(__p0) __cmsFreeGamma((__p0))

int  __cmsIT8TableCount(LCMSHANDLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-760(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8TableCount(__p0) __cmsIT8TableCount((__p0))

gBOOL  __cmsIT8SaveToMem(LCMSHANDLE , void *, size_t *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-964(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SaveToMem(__p0, __p1, __p2) __cmsIT8SaveToMem((__p0), (__p1), (__p2))

void  __cmsxyY2XYZ(LPcmsCIEXYZ , const cmsCIExyY *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-124(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsxyY2XYZ(__p0, __p1) __cmsxyY2XYZ((__p0), (__p1))

cmsHPROFILE  __cmsCreateLab4Profile(LPcmsCIExyY ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-88(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateLab4Profile(__p0) __cmsCreateLab4Profile((__p0))

LPcmsSEQ  __cmsReadProfileSequenceDescription(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-454(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsReadProfileSequenceDescription(__p0) __cmsReadProfileSequenceDescription((__p0))

cmsHPROFILE  __cmsCreateXYZProfile() =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-94(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateXYZProfile() __cmsCreateXYZProfile()

cmsHPROFILE  __cmsCreateInkLimitingDeviceLink(icColorSpaceSignature , double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-76(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateInkLimitingDeviceLink(__p0, __p1) __cmsCreateInkLimitingDeviceLink((__p0), (__p1))

cmsHPROFILE  __cmsCreate_sRGBProfile() =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-100(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreate_sRGBProfile() __cmsCreate_sRGBProfile()

LPGAMMATABLE  __cmsJoinGamma(LPGAMMATABLE , LPGAMMATABLE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-298(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsJoinGamma(__p0, __p1) __cmsJoinGamma((__p0), (__p1))

LPLUT  __cmsSetMatrixLUT(LPLUT , LPMAT3 ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-694(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetMatrixLUT(__p0, __p1) __cmsSetMatrixLUT((__p0), (__p1))

cmsHPROFILE  __cmsOpenProfileFromMem(LPVOID , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-46(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsOpenProfileFromMem(__p0, __p1) __cmsOpenProfileFromMem((__p0), (__p1))

int  __cmsIT8GetDataFormat(LCMSHANDLE , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-898(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetDataFormat(__p0, __p1) __cmsIT8GetDataFormat((__p0), (__p1))

void  __cmsIT8DefineDblFormat(LCMSHANDLE , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-928(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8DefineDblFormat(__p0, __p1) __cmsIT8DefineDblFormat((__p0), (__p1))

void  __cmsEvalLUT(LPLUT , gWORD *, gWORD *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-712(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsEvalLUT(__p0, __p1, __p2) __cmsEvalLUT((__p0), (__p1), (__p2))

int  __cmsSample3DGrid(LPLUT , _cmsSAMPLER , LPVOID , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-730(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSample3DGrid(__p0, __p1, __p2, __p3) __cmsSample3DGrid((__p0), (__p1), (__p2), (__p3))

gBOOL  __cmsIT8SetPropertyStr(LCMSHANDLE , const char *, const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-808(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetPropertyStr(__p0, __p1, __p2) __cmsIT8SetPropertyStr((__p0), (__p1), (__p2))

LPLUT  __cmsReadICCLut(cmsHPROFILE , icTagSignature ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-718(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsReadICCLut(__p0, __p1) __cmsReadICCLut((__p0), (__p1))

cmsHPROFILE  __cmsCreateRGBProfile(LPcmsCIExyY , LPcmsCIExyYTRIPLE , LPGAMMATABLE *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-58(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsCreateRGBProfile(__p0, __p1, __p2) __cmsCreateRGBProfile((__p0), (__p1), (__p2))

void  __cmsSetHeaderFlags(cmsHPROFILE , DWORD ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-538(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetHeaderFlags(__p0, __p1) __cmsSetHeaderFlags((__p0), (__p1))

gBOOL  __cmsIT8SetDataFormat(LCMSHANDLE , int , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-904(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8SetDataFormat(__p0, __p1, __p2) __cmsIT8SetDataFormat((__p0), (__p1), (__p2))

DWORD  __cmsGetProfileICCversion(cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-502(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsGetProfileICCversion(__p0) __cmsGetProfileICCversion((__p0))

LPLUT  __cmsAlloc3DGrid(LPLUT , int , int , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-688(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsAlloc3DGrid(__p0, __p1, __p2, __p3) __cmsAlloc3DGrid((__p0), (__p1), (__p2), (__p3))

LCMSHANDLE  __cmsIT8LoadFromMem(void *, size_t ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-778(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8LoadFromMem(__p0, __p1) __cmsIT8LoadFromMem((__p0), (__p1))

LCMSHANDLE  __cmsIT8LoadFromFile(const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-772(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8LoadFromFile(__p0) __cmsIT8LoadFromFile((__p0))

LPcmsGAMUTEX  __cmsReadExtendedGamut(cmsHPROFILE , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-1000(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsReadExtendedGamut(__p0, __p1) __cmsReadExtendedGamut((__p0), (__p1))

gBOOL  __cmsTakeMediaBlackPoint(LPcmsCIEXYZ , cmsHPROFILE ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-346(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsTakeMediaBlackPoint(__p0, __p1) __cmsTakeMediaBlackPoint((__p0), (__p1))

void  __cmsDeleteTransform(cmsHTRANSFORM ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-568(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsDeleteTransform(__p0) __cmsDeleteTransform((__p0))

void  __cmsSetLanguage(int , int ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-370(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetLanguage(__p0, __p1) __cmsSetLanguage((__p0), (__p1))

void  __cmsFreeExtendedGamut(LPcmsGAMUTEX ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-1006(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsFreeExtendedGamut(__p0) __cmsFreeExtendedGamut((__p0))

double  __cmsSetAdaptationState(double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-934(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsSetAdaptationState(__p0) __cmsSetAdaptationState((__p0))

int  __cmsIT8EnumProperties(LCMSHANDLE , char ***) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-844(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8EnumProperties(__p0, __p1) __cmsIT8EnumProperties((__p0), (__p1))

const char * __cmsIT8GetProperty(LCMSHANDLE , const char *) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-832(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsIT8GetProperty(__p0, __p1) __cmsIT8GetProperty((__p0), (__p1))

double  __cmsBFDdeltaE(LPcmsCIELab , LPcmsCIELab ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-166(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsBFDdeltaE(__p0, __p1) __cmsBFDdeltaE((__p0), (__p1))

double  __cmsEstimateGammaEx(LPWORD , int , double ) =
	"\tlis\t11,LittleCMSBase@ha\n"
	"\tlwz\t12,LittleCMSBase@l(11)\n"
	"\tlwz\t0,-322(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define cmsEstimateGammaEx(__p0, __p1, __p2) __cmsEstimateGammaEx((__p0), (__p1), (__p2))

#endif /* !_VBCCINLINE_LITTLECMS_H */
