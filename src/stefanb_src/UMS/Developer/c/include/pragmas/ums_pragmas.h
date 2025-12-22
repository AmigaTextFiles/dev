#ifndef PRAGMAS_UMS_PRAGMAS_H
#define PRAGMAS_UMS_PRAGMAS_H

/*
 * pragmas/ums_pragmas.h
 *
 * #pragmas for inline calls of ums.library functions
 *
 * $VER: ums_pragmas.h 11.5 (12.06.95)
 *
 */

#ifndef CLIB_UMS_PROTOS_H
#include <clib/ums_protos.h>
#endif

#pragma libcall UMSBase UMSLogin 1e 3202
#pragma libcall UMSBase UMSLogout 24 201
#pragma libcall UMSBase UMSErrNum 78 201
#pragma libcall UMSBase UMSErrTxt 7e 201
#pragma libcall UMSBase UMSDeleteMsg 84 3202
#pragma libcall UMSBase UMSExportedMsg ea 3202
#pragma libcall UMSBase UMSCannotExport f0 43203
#pragma libcall UMSBase UMSVLog f6 654204
#pragma libcall UMSBase UMSRLogin fc 43203
#pragma libcall UMSBase UMSWriteMsg 102 3202
#pragma libcall UMSBase UMSReadMsg 108 3202
#pragma libcall UMSBase UMSFreeMsg 10e 3202
#pragma libcall UMSBase UMSSelect 114 3202
#pragma libcall UMSBase UMSSearch 11a 3202
#pragma libcall UMSBase UMSReadConfig 120 3202
#pragma libcall UMSBase UMSFreeConfig 126 3202
#pragma libcall UMSBase UMSWriteConfig 12c 3202
#pragma libcall UMSBase UMSServerControl 138 3202
#pragma libcall UMSBase UMSMatchConfig 13e 3202
#pragma libcall UMSBase UMSErrTxtFromNum 144 201
#pragma libcall UMSBase UMSDupAccount 14a 201

#ifdef __SASC
#pragma tagcall UMSBase UMSLog f6 654204
#pragma tagcall UMSBase UMSWriteMsgTags 102 3202
#pragma tagcall UMSBase UMSReadMsgTags 108 3202
#pragma tagcall UMSBase UMSSelectTags 114 3202
#pragma tagcall UMSBase UMSSearchTags 11a 3202
#pragma tagcall UMSBase UMSReadConfigTags 120 3202
#pragma tagcall UMSBase UMSWriteConfigTags 12c 3202
#pragma tagcall UMSBase UMSMatchConfigTags 13e 3202
#endif

#endif
