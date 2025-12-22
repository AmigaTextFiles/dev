#ifdef __PPC__
#include <ppcpragmas/listview_pragmas.h>
#else
#pragma libcall ListViewBase GetListViewClass 1e 0
#pragma libcall ListViewBase Tree_NewList 24 801
#pragma libcall ListViewBase Tree_AddTail 2a 9802
#pragma libcall ListViewBase Tree_AddHead 30 9802
#pragma libcall ListViewBase Tree_AddSubTail 36 A9803
#pragma libcall ListViewBase Tree_NextNode 3c 801
#pragma libcall ListViewBase Tree_AddSubHead 42 A9803
#pragma libcall ListViewBase Tree_RemTail 48 801
#pragma libcall ListViewBase Tree_RemHead 4e 801
#pragma libcall ListViewBase Tree_Remove 54 801
#pragma libcall ListViewBase Tree_RemSubTail 5a 801
#pragma libcall ListViewBase Tree_RemSubHead 60 801
#pragma libcall ListViewBase Tree_Insert 66 A9803
#pragma libcall ListViewBase Tree_NextSubNode 6c 801
#endif
