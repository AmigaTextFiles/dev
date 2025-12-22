/* Automatically generated header! Do not edit! */

#ifndef _VBCCINLINE_AO_H
#define _VBCCINLINE_AO_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EMUL_EMULREGS_H
#include <emul/emulregs.h>
#endif

ao_device * __ao_open_live(int , ao_sample_format *, ao_option *) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-52(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_open_live(__p0, __p1, __p2) __ao_open_live((__p0), (__p1), (__p2))

ao_device * __ao_open_file(int , const char *, int , ao_sample_format *, ao_option *) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-58(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_open_file(__p0, __p1, __p2, __p3, __p4) __ao_open_file((__p0), (__p1), (__p2), (__p3), (__p4))

void  __ao_initialize() =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-28(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_initialize() __ao_initialize()

ao_info ** __ao_driver_info_list(int *) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-94(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_driver_info_list(__p0) __ao_driver_info_list((__p0))

int  __ao_play(ao_device *, char *, uint_32 ) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-64(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_play(__p0, __p1, __p2) __ao_play((__p0), (__p1), (__p2))

int  __ao_close(ao_device *) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-70(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_close(__p0) __ao_close((__p0))

ao_info * __ao_driver_info(int ) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-88(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_driver_info(__p0) __ao_driver_info((__p0))

int  __ao_driver_id(const char *) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-76(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_driver_id(__p0) __ao_driver_id((__p0))

int  __ao_is_big_endian() =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-100(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_is_big_endian() __ao_is_big_endian()

int  __ao_default_driver_id() =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-82(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_default_driver_id() __ao_default_driver_id()

void  __ao_shutdown() =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-34(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_shutdown() __ao_shutdown()

void  __ao_free_options(ao_option *) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-46(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_free_options(__p0) __ao_free_options((__p0))

int  __ao_append_option(ao_option **, const char *, const char *) =
	"\tlis\t11,AOBase@ha\n"
	"\tlwz\t12,AOBase@l(11)\n"
	"\tlwz\t0,-40(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define ao_append_option(__p0, __p1, __p2) __ao_append_option((__p0), (__p1), (__p2))

#endif /* !_VBCCINLINE_AO_H */
