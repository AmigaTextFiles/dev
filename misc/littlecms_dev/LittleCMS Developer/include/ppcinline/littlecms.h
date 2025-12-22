/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_LITTLECMS_H
#define _PPCINLINE_LITTLECMS_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef LITTLECMS_BASE_NAME
#define LITTLECMS_BASE_NAME LittleCMSBase
#endif /* !LITTLECMS_BASE_NAME */

#define cmsBuildRGB2XYZtransferMatrix(__p0, __p1, __p2) \
	({ \
		LPMAT3  __t__p0 = __p0;\
		LPcmsCIExyY  __t__p1 = __p1;\
		LPcmsCIExyYTRIPLE  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LPMAT3 , LPcmsCIExyY , LPcmsCIExyYTRIPLE ))*(void**)(__base - 202))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsTakeCreationDateTime(__p0, __p1) \
	({ \
		struct tm * __t__p0 = __p0;\
		cmsHPROFILE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(struct tm *, cmsHPROFILE ))*(void**)(__base - 418))(__t__p0, __t__p1));\
	})

#define cmsCloseProfile(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHPROFILE ))*(void**)(__base - 52))(__t__p0));\
	})

#define cmsErrorAction(__p0) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(int ))*(void**)(__base - 664))(__t__p0));\
	})

#define cmsCIECAM97sDone(__p0) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LCMSHANDLE ))*(void**)(__base - 214))(__t__p0));\
	})

#define cmsCreateLinearizationDeviceLink(__p0, __p1) \
	({ \
		icColorSpaceSignature  __t__p0 = __p0;\
		LPGAMMATABLE * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(icColorSpaceSignature , LPGAMMATABLE *))*(void**)(__base - 70))(__t__p0, __t__p1));\
	})

#define cmsLab2XYZ(__p0, __p1, __p2) \
	({ \
		LPcmsCIEXYZ  __t__p0 = __p0;\
		LPcmsCIEXYZ  __t__p1 = __p1;\
		const cmsCIELab * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPcmsCIEXYZ , LPcmsCIEXYZ , const cmsCIELab *))*(void**)(__base - 136))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsXYZ2Lab(__p0, __p1, __p2) \
	({ \
		LPcmsCIEXYZ  __t__p0 = __p0;\
		LPcmsCIELab  __t__p1 = __p1;\
		const cmsCIEXYZ * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPcmsCIEXYZ , LPcmsCIELab , const cmsCIEXYZ *))*(void**)(__base - 130))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsDoTransform(__p0, __p1, __p2, __p3) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		LPVOID  __t__p1 = __p1;\
		LPVOID  __t__p2 = __p2;\
		unsigned int  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHTRANSFORM , LPVOID , LPVOID , unsigned int ))*(void**)(__base - 574))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsIT8GetSheetType(__p0) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(LCMSHANDLE ))*(void**)(__base - 790))(__t__p0));\
	})

#define _cmsSetLUTdepth(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , int ))*(void**)(__base - 628))(__t__p0, __t__p1));\
	})

#define cmsTakeRenderingIntent(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(cmsHPROFILE ))*(void**)(__base - 436))(__t__p0));\
	})

#define cmsWhitePointFromTemp(__p0, __p1) \
	({ \
		int  __t__p0 = __p0;\
		LPcmsCIExyY  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(int , LPcmsCIExyY ))*(void**)(__base - 190))(__t__p0, __t__p1));\
	})

#define cmsIsTag(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icTagSignature  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHPROFILE , icTagSignature ))*(void**)(__base - 430))(__t__p0, __t__p1));\
	})

#define cmsCIECAM97sInit(__p0) \
	({ \
		LPcmsViewingConditions  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LCMSHANDLE (*)(LPcmsViewingConditions ))*(void**)(__base - 208))(__t__p0));\
	})

#define cmsChangeBuffersFormat(__p0, __p1, __p2) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		DWORD  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHTRANSFORM , DWORD , DWORD ))*(void**)(__base - 580))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsEstimateGamma(__p0) \
	({ \
		LPGAMMATABLE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LPGAMMATABLE ))*(void**)(__base - 316))(__t__p0));\
	})

#define cmsIT8Alloc() \
	({ \
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LCMSHANDLE (*)())*(void**)(__base - 748))());\
	})

#define cmsAllocLUT() \
	({ \
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPLUT (*)())*(void**)(__base - 676))());\
	})

#define _cmsChannelsOf(__p0) \
	({ \
		icColorSpaceSignature  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(icColorSpaceSignature ))*(void**)(__base - 472))(__t__p0));\
	})

#define cmsGetTagCount(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((icInt32Number (*)(cmsHPROFILE ))*(void**)(__base - 952))(__t__p0));\
	})

#define cmsIT8GetPatchName(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		char * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(LCMSHANDLE , int , char *))*(void**)(__base - 916))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsGetUserFormatters(__p0, __p1, __p2, __p3, __p4) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		LPDWORD  __t__p1 = __p1;\
		cmsFORMATTER * __t__p2 = __p2;\
		LPDWORD  __t__p3 = __p3;\
		cmsFORMATTER * __t__p4 = __p4;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHTRANSFORM , LPDWORD , cmsFORMATTER *, LPDWORD , cmsFORMATTER *))*(void**)(__base - 742))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define cmsGetDeviceClass(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((icProfileClassSignature (*)(cmsHPROFILE ))*(void**)(__base - 496))(__t__p0));\
	})

#define cmsSetMatrixLUT4(__p0, __p1, __p2, __p3) \
	({ \
		LPLUT  __t__p0 = __p0;\
		LPMAT3  __t__p1 = __p1;\
		LPVEC3  __t__p2 = __p2;\
		DWORD  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPLUT (*)(LPLUT , LPMAT3 , LPVEC3 , DWORD ))*(void**)(__base - 700))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsIT8SetPropertyHex(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *, int ))*(void**)(__base - 820))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsIT8GetPropertyDbl(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LCMSHANDLE , const char *))*(void**)(__base - 838))(__t__p0, __t__p1));\
	})

#define cmsIT8EnumDataFormat(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		char *** __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(LCMSHANDLE , char ***))*(void**)(__base - 910))(__t__p0, __t__p1));\
	})

#define cmsIT8SetDataDbl(__p0, __p1, __p2, __p3) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		double  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *, const char *, double ))*(void**)(__base - 892))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsNamedColorCount(__p0) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(cmsHTRANSFORM ))*(void**)(__base - 598))(__t__p0));\
	})

#define cmsReadICCGamma(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icTagSignature  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(cmsHPROFILE , icTagSignature ))*(void**)(__base - 328))(__t__p0, __t__p1));\
	})

#define cmsReadICCText(__p0, __p1, __p2) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icTagSignature  __t__p1 = __p1;\
		char * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(cmsHPROFILE , icTagSignature , char *))*(void**)(__base - 448))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsTakeProductInfo(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(cmsHPROFILE ))*(void**)(__base - 388))(__t__p0));\
	})

#define cmsSetPCS(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icColorSpaceSignature  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , icColorSpaceSignature ))*(void**)(__base - 526))(__t__p0, __t__p1));\
	})

#define cmsSetUserFormatters(__p0, __p1, __p2, __p3, __p4) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		cmsFORMATTER  __t__p2 = __p2;\
		DWORD  __t__p3 = __p3;\
		cmsFORMATTER  __t__p4 = __p4;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHTRANSFORM , DWORD , cmsFORMATTER , DWORD , cmsFORMATTER ))*(void**)(__base - 736))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define cmsD50_XYZ() \
	({ \
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPcmsCIEXYZ (*)())*(void**)(__base - 28))());\
	})

#define _cmsIsMatrixShaper(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHPROFILE ))*(void**)(__base - 970))(__t__p0));\
	})

#define cmsIsIntentSupported(__p0, __p1, __p2) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHPROFILE , int , int ))*(void**)(__base - 478))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsGetPostScriptCRD(__p0, __p1, __p2, __p3) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		LPVOID  __t__p2 = __p2;\
		DWORD  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((DWORD (*)(cmsHPROFILE , int , LPVOID , DWORD ))*(void**)(__base - 652))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsIT8SetComment(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *))*(void**)(__base - 802))(__t__p0, __t__p1));\
	})

#define cmsTakeHeaderAttributes(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((DWORD (*)(cmsHPROFILE ))*(void**)(__base - 946))(__t__p0));\
	})

#define cmsIT8Free(__p0) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LCMSHANDLE ))*(void**)(__base - 754))(__t__p0));\
	})

#define cmsLCh2Lab(__p0, __p1) \
	({ \
		LPcmsCIELab  __t__p0 = __p0;\
		const cmsCIELCh * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPcmsCIELab , const cmsCIELCh *))*(void**)(__base - 148))(__t__p0, __t__p1));\
	})

#define cmsLab2LCh(__p0, __p1) \
	({ \
		LPcmsCIELCh  __t__p0 = __p0;\
		const cmsCIELab * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPcmsCIELCh , const cmsCIELab *))*(void**)(__base - 142))(__t__p0, __t__p1));\
	})

#define cmsCIECAM02Forward(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		LPcmsCIEXYZ  __t__p1 = __p1;\
		LPcmsJCh  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LCMSHANDLE , LPcmsCIEXYZ , LPcmsJCh ))*(void**)(__base - 244))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsEvalLUTreverse(__p0, __p1, __p2, __p3) \
	({ \
		LPLUT  __t__p0 = __p0;\
		gWORD * __t__p1 = __p1;\
		gWORD * __t__p2 = __p2;\
		LPWORD  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LPLUT , gWORD *, gWORD *, LPWORD ))*(void**)(__base - 988))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsGetAlarmCodes(__p0, __p1, __p2) \
	({ \
		int * __t__p0 = __p0;\
		int * __t__p1 = __p1;\
		int * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(int *, int *, int *))*(void**)(__base - 592))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsCIE2000DeltaE(__p0, __p1, __p2, __p3, __p4) \
	({ \
		LPcmsCIELab  __t__p0 = __p0;\
		LPcmsCIELab  __t__p1 = __p1;\
		double  __t__p2 = __p2;\
		double  __t__p3 = __p3;\
		double  __t__p4 = __p4;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LPcmsCIELab , LPcmsCIELab , double , double , double ))*(void**)(__base - 178))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define cmsIT8SetDataRowColDbl(__p0, __p1, __p2, __p3) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		double  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , int , int , double ))*(void**)(__base - 868))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsTakeProfileID(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const gBYTE *(*)(cmsHPROFILE ))*(void**)(__base - 412))(__t__p0));\
	})

#define cmsAddTag(__p0, __p1, __p2) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icTagSignature  __t__p1 = __p1;\
		void * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHPROFILE , icTagSignature , void *))*(void**)(__base - 616))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsSetAlarmCodes(__p0, __p1, __p2) \
	({ \
		int  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(int , int , int ))*(void**)(__base - 586))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsXYZ2xyY(__p0, __p1) \
	({ \
		LPcmsCIExyY  __t__p0 = __p0;\
		const cmsCIEXYZ * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPcmsCIExyY , const cmsCIEXYZ *))*(void**)(__base - 118))(__t__p0, __t__p1));\
	})

#define cmsCIECAM02Done(__p0) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LCMSHANDLE ))*(void**)(__base - 238))(__t__p0));\
	})

#define cmsTransform2DeviceLink(__p0, __p1) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(cmsHTRANSFORM , DWORD ))*(void**)(__base - 622))(__t__p0, __t__p1));\
	})

#define cmsReadICCGammaReversed(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icTagSignature  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(cmsHPROFILE , icTagSignature ))*(void**)(__base - 334))(__t__p0, __t__p1));\
	})

#define cmsNamedColorInfo(__p0, __p1, __p2, __p3, __p4) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		char * __t__p2 = __p2;\
		char * __t__p3 = __p3;\
		char * __t__p4 = __p4;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHTRANSFORM , int , char *, char *, char *))*(void**)(__base - 604))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define cmsCreateTransform(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		cmsHPROFILE  __t__p2 = __p2;\
		DWORD  __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		DWORD  __t__p5 = __p5;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHTRANSFORM (*)(cmsHPROFILE , DWORD , cmsHPROFILE , DWORD , int , DWORD ))*(void**)(__base - 550))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define cmsCreateBCHSWabstractProfile(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		int  __t__p0 = __p0;\
		double  __t__p1 = __p1;\
		double  __t__p2 = __p2;\
		double  __t__p3 = __p3;\
		double  __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		int  __t__p6 = __p6;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(int , double , double , double , double , int , int ))*(void**)(__base - 106))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define cmsGetPostScriptCRDEx(__p0, __p1, __p2, __p3, __p4) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		DWORD  __t__p2 = __p2;\
		LPVOID  __t__p3 = __p3;\
		DWORD  __t__p4 = __p4;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((DWORD (*)(cmsHPROFILE , int , DWORD , LPVOID , DWORD ))*(void**)(__base - 658))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define cmsGetPostScriptCSA(__p0, __p1, __p2, __p3) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		LPVOID  __t__p2 = __p2;\
		DWORD  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((DWORD (*)(cmsHPROFILE , int , LPVOID , DWORD ))*(void**)(__base - 646))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsCreateLabProfile(__p0) \
	({ \
		LPcmsCIExyY  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(LPcmsCIExyY ))*(void**)(__base - 82))(__t__p0));\
	})

#define cmsCreateGrayProfile(__p0, __p1) \
	({ \
		LPcmsCIExyY  __t__p0 = __p0;\
		LPGAMMATABLE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(LPcmsCIExyY , LPGAMMATABLE ))*(void**)(__base - 64))(__t__p0, __t__p1));\
	})

#define cmsCIECAM02Init(__p0) \
	({ \
		LPcmsViewingConditions  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LCMSHANDLE (*)(LPcmsViewingConditions ))*(void**)(__base - 232))(__t__p0));\
	})

#define cmsTakeColorants(__p0, __p1) \
	({ \
		LPcmsCIEXYZTRIPLE  __t__p0 = __p0;\
		cmsHPROFILE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LPcmsCIEXYZTRIPLE , cmsHPROFILE ))*(void**)(__base - 358))(__t__p0, __t__p1));\
	})

#define cmsCIECAM97sForward(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		LPcmsCIEXYZ  __t__p1 = __p1;\
		LPcmsJCh  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LCMSHANDLE , LPcmsCIEXYZ , LPcmsJCh ))*(void**)(__base - 220))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsNamedColorIndex(__p0, __p1) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(cmsHTRANSFORM , const char *))*(void**)(__base - 610))(__t__p0, __t__p1));\
	})

#define cmsSmoothGamma(__p0, __p1) \
	({ \
		LPGAMMATABLE  __t__p0 = __p0;\
		double  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LPGAMMATABLE , double ))*(void**)(__base - 310))(__t__p0, __t__p1));\
	})

#define cmsTakeCopyright(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(cmsHPROFILE ))*(void**)(__base - 406))(__t__p0));\
	})

#define _cmsSaveProfileToMem(__p0, __p1, __p2) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		void * __t__p1 = __p1;\
		size_t * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHPROFILE , void *, size_t *))*(void**)(__base - 640))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsCMCdeltaE(__p0, __p1) \
	({ \
		LPcmsCIELab  __t__p0 = __p0;\
		LPcmsCIELab  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LPcmsCIELab , LPcmsCIELab ))*(void**)(__base - 172))(__t__p0, __t__p1));\
	})

#define cmsIT8SetTableByLabel(__p0, __p1, __p2, __p3) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		const char * __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(LCMSHANDLE , const char *, const char *, const char *))*(void**)(__base - 922))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsIT8GetDataRowCol(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(LCMSHANDLE , int , int ))*(void**)(__base - 850))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsGetColorSpace(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((icColorSpaceSignature (*)(cmsHPROFILE ))*(void**)(__base - 490))(__t__p0));\
	})

#define cmsIT8SetDataRowCol(__p0, __p1, __p2, __p3) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		const char * __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , int , int , const char *))*(void**)(__base - 862))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsTakeManufacturer(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(cmsHPROFILE ))*(void**)(__base - 394))(__t__p0));\
	})

#define cmsD50_xyY() \
	({ \
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPcmsCIExyY (*)())*(void**)(__base - 34))());\
	})

#define cmsSetProfileICCversion(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , DWORD ))*(void**)(__base - 508))(__t__p0, __t__p1));\
	})

#define cmsTakeModel(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(cmsHPROFILE ))*(void**)(__base - 400))(__t__p0));\
	})

#define cmsSetColorSpace(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icColorSpaceSignature  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , icColorSpaceSignature ))*(void**)(__base - 520))(__t__p0, __t__p1));\
	})

#define cmsFreeLUT(__p0) \
	({ \
		LPLUT  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPLUT ))*(void**)(__base - 706))(__t__p0));\
	})

#define _cmsLCMScolorSpace(__p0) \
	({ \
		icColorSpaceSignature  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(icColorSpaceSignature ))*(void**)(__base - 466))(__t__p0));\
	})

#define cmsTakeCalibrationDateTime(__p0, __p1) \
	({ \
		struct tm * __t__p0 = __p0;\
		cmsHPROFILE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(struct tm *, cmsHPROFILE ))*(void**)(__base - 424))(__t__p0, __t__p1));\
	})

#define cmsClampLab(__p0, __p1, __p2, __p3, __p4) \
	({ \
		LPcmsCIELab  __t__p0 = __p0;\
		double  __t__p1 = __p1;\
		double  __t__p2 = __p2;\
		double  __t__p3 = __p3;\
		double  __t__p4 = __p4;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPcmsCIELab , double , double , double , double ))*(void**)(__base - 184))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define cmsIT8SetPropertyUncooked(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *, const char *))*(void**)(__base - 826))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsReverseGamma(__p0, __p1) \
	({ \
		int  __t__p0 = __p0;\
		LPGAMMATABLE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(int , LPGAMMATABLE ))*(void**)(__base - 292))(__t__p0, __t__p1));\
	})

#define cmsReadColorantTable(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icTagSignature  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPcmsNAMEDCOLORLIST (*)(cmsHPROFILE , icTagSignature ))*(void**)(__base - 994))(__t__p0, __t__p1));\
	})

#define cmsIT8SaveToFile(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *))*(void**)(__base - 784))(__t__p0, __t__p1));\
	})

#define cmsAdaptToIlluminant(__p0, __p1, __p2, __p3) \
	({ \
		LPcmsCIEXYZ  __t__p0 = __p0;\
		LPcmsCIEXYZ  __t__p1 = __p1;\
		LPcmsCIEXYZ  __t__p2 = __p2;\
		LPcmsCIEXYZ  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LPcmsCIEXYZ , LPcmsCIEXYZ , LPcmsCIEXYZ , LPcmsCIEXYZ ))*(void**)(__base - 196))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsCreateMultiprofileTransform(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		cmsHPROFILE * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		DWORD  __t__p2 = __p2;\
		DWORD  __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		DWORD  __t__p5 = __p5;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHTRANSFORM (*)(cmsHPROFILE *, int , DWORD , DWORD , int , DWORD ))*(void**)(__base - 562))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define cmsCIE94DeltaE(__p0, __p1) \
	({ \
		LPcmsCIELab  __t__p0 = __p0;\
		LPcmsCIELab  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LPcmsCIELab , LPcmsCIELab ))*(void**)(__base - 160))(__t__p0, __t__p1));\
	})

#define cmsGetTagSignature(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icInt32Number  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((icTagSignature (*)(cmsHPROFILE , icInt32Number ))*(void**)(__base - 958))(__t__p0, __t__p1));\
	})

#define cmsIT8GetData(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(LCMSHANDLE , const char *, const char *))*(void**)(__base - 874))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsBuildGamma(__p0, __p1) \
	({ \
		int  __t__p0 = __p0;\
		double  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(int , double ))*(void**)(__base - 256))(__t__p0, __t__p1));\
	})

#define cmsFreeGammaTriple(__p0) \
	({ \
		LPGAMMATABLE * __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPGAMMATABLE *))*(void**)(__base - 280))(__t__p0));\
	})

#define cmsTakeIluminant(__p0, __p1) \
	({ \
		LPcmsCIEXYZ  __t__p0 = __p0;\
		cmsHPROFILE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LPcmsCIEXYZ , cmsHPROFILE ))*(void**)(__base - 352))(__t__p0, __t__p1));\
	})

#define cmsOpenProfileFromFile(__p0, __p1) \
	({ \
		const char * __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(const char *, const char *))*(void**)(__base - 40))(__t__p0, __t__p1));\
	})

#define _cmsICCcolorSpace(__p0) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((icColorSpaceSignature (*)(int ))*(void**)(__base - 460))(__t__p0));\
	})

#define cmsIT8SetData(__p0, __p1, __p2, __p3) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		const char * __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *, const char *, const char *))*(void**)(__base - 886))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsBuildParametricGamma(__p0, __p1, __p2) \
	({ \
		int  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		double * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(int , int , double *))*(void**)(__base - 262))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsIT8SetSheetType(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *))*(void**)(__base - 796))(__t__p0, __t__p1));\
	})

#define cmsDupLUT(__p0) \
	({ \
		LPLUT  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPLUT (*)(LPLUT ))*(void**)(__base - 724))(__t__p0));\
	})

#define cmsCIECAM02Reverse(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		LPcmsJCh  __t__p1 = __p1;\
		LPcmsCIEXYZ  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LCMSHANDLE , LPcmsJCh , LPcmsCIEXYZ ))*(void**)(__base - 250))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsIT8GetDataDbl(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LCMSHANDLE , const char *, const char *))*(void**)(__base - 880))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsTakeProductDesc(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(cmsHPROFILE ))*(void**)(__base - 382))(__t__p0));\
	})

#define cmsGetPCS(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((icColorSpaceSignature (*)(cmsHPROFILE ))*(void**)(__base - 484))(__t__p0));\
	})

#define cmsTakeProductName(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(cmsHPROFILE ))*(void**)(__base - 376))(__t__p0));\
	})

#define cmsIT8SetTable(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(LCMSHANDLE , int ))*(void**)(__base - 766))(__t__p0, __t__p1));\
	})

#define cmsSetProfileID(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		LPBYTE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , LPBYTE ))*(void**)(__base - 544))(__t__p0, __t__p1));\
	})

#define cmsDupGamma(__p0) \
	({ \
		LPGAMMATABLE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(LPGAMMATABLE ))*(void**)(__base - 286))(__t__p0));\
	})

#define cmsAllocGamma(__p0) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(int ))*(void**)(__base - 268))(__t__p0));\
	})

#define cmsAllocLinearTable(__p0, __p1, __p2) \
	({ \
		LPLUT  __t__p0 = __p0;\
		LPGAMMATABLE * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPLUT (*)(LPLUT , LPGAMMATABLE *, int ))*(void**)(__base - 682))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsDeltaE(__p0, __p1) \
	({ \
		LPcmsCIELab  __t__p0 = __p0;\
		LPcmsCIELab  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LPcmsCIELab , LPcmsCIELab ))*(void**)(__base - 154))(__t__p0, __t__p1));\
	})

#define cmsJoinGammaEx(__p0, __p1, __p2) \
	({ \
		LPGAMMATABLE  __t__p0 = __p0;\
		LPGAMMATABLE  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(LPGAMMATABLE , LPGAMMATABLE , int ))*(void**)(__base - 304))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsTakeMediaWhitePoint(__p0, __p1) \
	({ \
		LPcmsCIEXYZ  __t__p0 = __p0;\
		cmsHPROFILE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LPcmsCIEXYZ , cmsHPROFILE ))*(void**)(__base - 340))(__t__p0, __t__p1));\
	})

#define cmsSetDeviceClass(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icProfileClassSignature  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , icProfileClassSignature ))*(void**)(__base - 514))(__t__p0, __t__p1));\
	})

#define cmsCreateProofingTransform(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		cmsHPROFILE  __t__p2 = __p2;\
		DWORD  __t__p3 = __p3;\
		cmsHPROFILE  __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		int  __t__p6 = __p6;\
		DWORD  __t__p7 = __p7;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHTRANSFORM (*)(cmsHPROFILE , DWORD , cmsHPROFILE , DWORD , cmsHPROFILE , int , int , DWORD ))*(void**)(__base - 556))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6, __t__p7));\
	})

#define cmsSetErrorHandler(__p0) \
	({ \
		cmsErrorHandlerFunction  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsErrorHandlerFunction ))*(void**)(__base - 670))(__t__p0));\
	})

#define cmsIT8GetDataRowColDbl(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LCMSHANDLE , int , int ))*(void**)(__base - 856))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsIT8SetPropertyDbl(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		double  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *, double ))*(void**)(__base - 814))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsTakeHeaderFlags(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((DWORD (*)(cmsHPROFILE ))*(void**)(__base - 364))(__t__p0));\
	})

#define cmsSetRenderingIntent(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , int ))*(void**)(__base - 532))(__t__p0, __t__p1));\
	})

#define cmsSetHeaderAttributes(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , DWORD ))*(void**)(__base - 940))(__t__p0, __t__p1));\
	})

#define _cmsSaveProfile(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHPROFILE , const char *))*(void**)(__base - 634))(__t__p0, __t__p1));\
	})

#define cmsCreateNULLProfile() \
	({ \
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)())*(void**)(__base - 112))());\
	})

#define cmsCIECAM97sReverse(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		LPcmsJCh  __t__p1 = __p1;\
		LPcmsCIEXYZ  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LCMSHANDLE , LPcmsJCh , LPcmsCIEXYZ ))*(void**)(__base - 226))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsTakeCharTargetData(__p0, __p1, __p2) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		char ** __t__p1 = __p1;\
		size_t * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(cmsHPROFILE , char **, size_t *))*(void**)(__base - 442))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsFreeGamma(__p0) \
	({ \
		LPGAMMATABLE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPGAMMATABLE ))*(void**)(__base - 274))(__t__p0));\
	})

#define cmsIT8TableCount(__p0) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(LCMSHANDLE ))*(void**)(__base - 760))(__t__p0));\
	})

#define cmsIT8SaveToMem(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		void * __t__p1 = __p1;\
		size_t * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , void *, size_t *))*(void**)(__base - 964))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsxyY2XYZ(__p0, __p1) \
	({ \
		LPcmsCIEXYZ  __t__p0 = __p0;\
		const cmsCIExyY * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPcmsCIEXYZ , const cmsCIExyY *))*(void**)(__base - 124))(__t__p0, __t__p1));\
	})

#define cmsCreateLab4Profile(__p0) \
	({ \
		LPcmsCIExyY  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(LPcmsCIExyY ))*(void**)(__base - 88))(__t__p0));\
	})

#define cmsReadProfileSequenceDescription(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPcmsSEQ (*)(cmsHPROFILE ))*(void**)(__base - 454))(__t__p0));\
	})

#define cmsCreateXYZProfile() \
	({ \
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)())*(void**)(__base - 94))());\
	})

#define cmsCreateInkLimitingDeviceLink(__p0, __p1) \
	({ \
		icColorSpaceSignature  __t__p0 = __p0;\
		double  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(icColorSpaceSignature , double ))*(void**)(__base - 76))(__t__p0, __t__p1));\
	})

#define cmsCreate_sRGBProfile() \
	({ \
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)())*(void**)(__base - 100))());\
	})

#define cmsJoinGamma(__p0, __p1) \
	({ \
		LPGAMMATABLE  __t__p0 = __p0;\
		LPGAMMATABLE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPGAMMATABLE (*)(LPGAMMATABLE , LPGAMMATABLE ))*(void**)(__base - 298))(__t__p0, __t__p1));\
	})

#define cmsSetMatrixLUT(__p0, __p1) \
	({ \
		LPLUT  __t__p0 = __p0;\
		LPMAT3  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPLUT (*)(LPLUT , LPMAT3 ))*(void**)(__base - 694))(__t__p0, __t__p1));\
	})

#define cmsOpenProfileFromMem(__p0, __p1) \
	({ \
		LPVOID  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(LPVOID , DWORD ))*(void**)(__base - 46))(__t__p0, __t__p1));\
	})

#define cmsIT8GetDataFormat(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(LCMSHANDLE , const char *))*(void**)(__base - 898))(__t__p0, __t__p1));\
	})

#define cmsIT8DefineDblFormat(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LCMSHANDLE , const char *))*(void**)(__base - 928))(__t__p0, __t__p1));\
	})

#define cmsEvalLUT(__p0, __p1, __p2) \
	({ \
		LPLUT  __t__p0 = __p0;\
		gWORD * __t__p1 = __p1;\
		gWORD * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPLUT , gWORD *, gWORD *))*(void**)(__base - 712))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsSample3DGrid(__p0, __p1, __p2, __p3) \
	({ \
		LPLUT  __t__p0 = __p0;\
		_cmsSAMPLER  __t__p1 = __p1;\
		LPVOID  __t__p2 = __p2;\
		DWORD  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(LPLUT , _cmsSAMPLER , LPVOID , DWORD ))*(void**)(__base - 730))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsIT8SetPropertyStr(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , const char *, const char *))*(void**)(__base - 808))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsReadICCLut(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		icTagSignature  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPLUT (*)(cmsHPROFILE , icTagSignature ))*(void**)(__base - 718))(__t__p0, __t__p1));\
	})

#define cmsCreateRGBProfile(__p0, __p1, __p2) \
	({ \
		LPcmsCIExyY  __t__p0 = __p0;\
		LPcmsCIExyYTRIPLE  __t__p1 = __p1;\
		LPGAMMATABLE * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((cmsHPROFILE (*)(LPcmsCIExyY , LPcmsCIExyYTRIPLE , LPGAMMATABLE *))*(void**)(__base - 58))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsSetHeaderFlags(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		DWORD  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHPROFILE , DWORD ))*(void**)(__base - 538))(__t__p0, __t__p1));\
	})

#define cmsIT8SetDataFormat(__p0, __p1, __p2) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LCMSHANDLE , int , const char *))*(void**)(__base - 904))(__t__p0, __t__p1, __t__p2));\
	})

#define cmsGetProfileICCversion(__p0) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((DWORD (*)(cmsHPROFILE ))*(void**)(__base - 502))(__t__p0));\
	})

#define cmsAlloc3DGrid(__p0, __p1, __p2, __p3) \
	({ \
		LPLUT  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPLUT (*)(LPLUT , int , int , int ))*(void**)(__base - 688))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define cmsIT8LoadFromMem(__p0, __p1) \
	({ \
		void * __t__p0 = __p0;\
		size_t  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LCMSHANDLE (*)(void *, size_t ))*(void**)(__base - 778))(__t__p0, __t__p1));\
	})

#define cmsIT8LoadFromFile(__p0) \
	({ \
		const char * __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LCMSHANDLE (*)(const char *))*(void**)(__base - 772))(__t__p0));\
	})

#define cmsReadExtendedGamut(__p0, __p1) \
	({ \
		cmsHPROFILE  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((LPcmsGAMUTEX (*)(cmsHPROFILE , int ))*(void**)(__base - 1000))(__t__p0, __t__p1));\
	})

#define cmsTakeMediaBlackPoint(__p0, __p1) \
	({ \
		LPcmsCIEXYZ  __t__p0 = __p0;\
		cmsHPROFILE  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((gBOOL (*)(LPcmsCIEXYZ , cmsHPROFILE ))*(void**)(__base - 346))(__t__p0, __t__p1));\
	})

#define cmsDeleteTransform(__p0) \
	({ \
		cmsHTRANSFORM  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(cmsHTRANSFORM ))*(void**)(__base - 568))(__t__p0));\
	})

#define cmsSetLanguage(__p0, __p1) \
	({ \
		int  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(int , int ))*(void**)(__base - 370))(__t__p0, __t__p1));\
	})

#define cmsFreeExtendedGamut(__p0) \
	({ \
		LPcmsGAMUTEX  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(LPcmsGAMUTEX ))*(void**)(__base - 1006))(__t__p0));\
	})

#define cmsSetAdaptationState(__p0) \
	({ \
		double  __t__p0 = __p0;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(double ))*(void**)(__base - 934))(__t__p0));\
	})

#define cmsIT8EnumProperties(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		char *** __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(LCMSHANDLE , char ***))*(void**)(__base - 844))(__t__p0, __t__p1));\
	})

#define cmsIT8GetProperty(__p0, __p1) \
	({ \
		LCMSHANDLE  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const char *(*)(LCMSHANDLE , const char *))*(void**)(__base - 832))(__t__p0, __t__p1));\
	})

#define cmsBFDdeltaE(__p0, __p1) \
	({ \
		LPcmsCIELab  __t__p0 = __p0;\
		LPcmsCIELab  __t__p1 = __p1;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LPcmsCIELab , LPcmsCIELab ))*(void**)(__base - 166))(__t__p0, __t__p1));\
	})

#define cmsEstimateGammaEx(__p0, __p1, __p2) \
	({ \
		LPWORD  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		double  __t__p2 = __p2;\
		long __base = (long)(LITTLECMS_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(LPWORD , int , double ))*(void**)(__base - 322))(__t__p0, __t__p1, __t__p2));\
	})

#endif /* !_PPCINLINE_LITTLECMS_H */
