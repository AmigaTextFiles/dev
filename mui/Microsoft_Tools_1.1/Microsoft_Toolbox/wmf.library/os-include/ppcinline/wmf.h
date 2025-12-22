/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_WMF_H
#define _PPCINLINE_WMF_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef WMF_BASE_NAME
#define WMF_BASE_NAME WmfBase
#endif /* !WMF_BASE_NAME */

#define Wmf_Load_path(__p0) \
	LP1(42, ULONG , Wmf_Load_path, \
		char *, __p0, a0, \
		, WMF_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Wmf_Load_mem(__p0) \
	LP1(72, ULONG , Wmf_Load_mem, \
		struct data_out *, __p0, a0, \
		, WMF_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Wmf_get_width() \
	LP0(60, ULONG , Wmf_get_width, \
		, WMF_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Wmf_get_image() \
	LP0(48, char *, Wmf_get_image, \
		, WMF_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Wmf_exit(__p0) \
	LP1NR(36, Wmf_exit, \
		ULONG , __p0, a0, \
		, WMF_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Wmf_init() \
	LP0(30, ULONG , Wmf_init, \
		, WMF_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Wmf_max_size(__p0) \
	LP1NR(54, Wmf_max_size, \
		ULONG , __p0, a0, \
		, WMF_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Wmf_get_height() \
	LP0(66, ULONG , Wmf_get_height, \
		, WMF_BASE_NAME, 0, 0, 0, 0, 0, 0)

#endif /* !_PPCINLINE_WMF_H */
