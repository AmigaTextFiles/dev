/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_DOC_H
#define _PPCINLINE_DOC_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef DOC_BASE_NAME
#define DOC_BASE_NAME DocBase
#endif /* !DOC_BASE_NAME */

#define Doc_exit(__p0) \
	LP1NR(42, Doc_exit, \
		ULONG , __p0, a0, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_load(__p0) \
	LP1(48, ULONG , Doc_load, \
		char *, __p0, a0, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_subject() \
	LP0(72, char *, Doc_get_subject, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_language() \
	LP0(102, char *, Doc_get_language, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_init() \
	LP0(36, ULONG , Doc_init, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_page(__p0) \
	LP1(30, char *, Doc_get_page, \
		ULONG , __p0, a0, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_author() \
	LP0(78, char *, Doc_get_author, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_appname() \
	LP0(90, char *, Doc_get_appname, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_comments() \
	LP0(114, char *, Doc_get_comments, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_title() \
	LP0(66, char *, Doc_get_title, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_max_pages() \
	LP0(60, ULONG , Doc_get_max_pages, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_company() \
	LP0(84, char *, Doc_get_company, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_keywords() \
	LP0(108, char *, Doc_get_keywords, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_export_pdf(__p0) \
	LP1(54, ULONG , Doc_export_pdf, \
		char *, __p0, a0, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define Doc_get_manager() \
	LP0(96, char *, Doc_get_manager, \
		, DOC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#endif /* !_PPCINLINE_DOC_H */
