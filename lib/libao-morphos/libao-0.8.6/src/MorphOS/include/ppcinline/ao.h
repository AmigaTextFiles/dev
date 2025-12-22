/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_AO_H
#define _PPCINLINE_AO_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef AO_BASE_NAME
#define AO_BASE_NAME AOBase
#endif /* !AO_BASE_NAME */

#define ao_open_live(__p0, __p1, __p2) \
	({ \
		int  __t__p0 = __p0;\
		ao_sample_format * __t__p1 = __p1;\
		ao_option * __t__p2 = __p2;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((ao_device *(*)(int , ao_sample_format *, ao_option *))*(void**)(__base - 52))(__t__p0, __t__p1, __t__p2));\
	})

#define ao_open_file(__p0, __p1, __p2, __p3, __p4) \
	({ \
		int  __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		ao_sample_format * __t__p3 = __p3;\
		ao_option * __t__p4 = __p4;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((ao_device *(*)(int , const char *, int , ao_sample_format *, ao_option *))*(void**)(__base - 58))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define ao_initialize() \
	({ \
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)())*(void**)(__base - 28))());\
	})

#define ao_driver_info_list(__p0) \
	({ \
		int * __t__p0 = __p0;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((ao_info **(*)(int *))*(void**)(__base - 94))(__t__p0));\
	})

#define ao_play(__p0, __p1, __p2) \
	({ \
		ao_device * __t__p0 = __p0;\
		char * __t__p1 = __p1;\
		uint_32  __t__p2 = __p2;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(ao_device *, char *, uint_32 ))*(void**)(__base - 64))(__t__p0, __t__p1, __t__p2));\
	})

#define ao_close(__p0) \
	({ \
		ao_device * __t__p0 = __p0;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(ao_device *))*(void**)(__base - 70))(__t__p0));\
	})

#define ao_driver_info(__p0) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((ao_info *(*)(int ))*(void**)(__base - 88))(__t__p0));\
	})

#define ao_driver_id(__p0) \
	({ \
		const char * __t__p0 = __p0;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(const char *))*(void**)(__base - 76))(__t__p0));\
	})

#define ao_is_big_endian() \
	({ \
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)())*(void**)(__base - 100))());\
	})

#define ao_default_driver_id() \
	({ \
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)())*(void**)(__base - 82))());\
	})

#define ao_shutdown() \
	({ \
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)())*(void**)(__base - 34))());\
	})

#define ao_free_options(__p0) \
	({ \
		ao_option * __t__p0 = __p0;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(ao_option *))*(void**)(__base - 46))(__t__p0));\
	})

#define ao_append_option(__p0, __p1, __p2) \
	({ \
		ao_option ** __t__p0 = __p0;\
		const char * __t__p1 = __p1;\
		const char * __t__p2 = __p2;\
		long __base = (long)(AO_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(ao_option **, const char *, const char *))*(void**)(__base - 40))(__t__p0, __t__p1, __t__p2));\
	})

#endif /* !_PPCINLINE_AO_H */
