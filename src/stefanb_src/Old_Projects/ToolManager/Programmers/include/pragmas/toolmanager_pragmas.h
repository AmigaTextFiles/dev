#ifndef PRAGMAS_TOOLMANAGER_PRAGMAS_H
#define PRAGMAS_TOOLMANAGER_PRAGMAS_H

/*
 * toolmanager_pragmas.h  V2.1
 *
 * Inline library calls for toolmanager.library functions
 *
 * (c) 1990-1993 Stefan Becker
 */

#pragma libcall ToolManagerBase QuitToolManager 24 00
#pragma libcall ToolManagerBase AllocTMHandle 2A 00
#pragma libcall ToolManagerBase FreeTMHandle 30 801
#pragma libcall ToolManagerBase CreateTMObjectTagList 36 A09804
#ifdef __SASC_60
#pragma tagcall ToolManagerBase CreateTMObjectTags 36 A09804
#endif
#pragma libcall ToolManagerBase DeleteTMObject 3C 9802
#pragma libcall ToolManagerBase ChangeTMObjectTagList 42 A9803
#ifdef __SASC_60
#pragma tagcall ToolManagerBase ChangeTMObjectTags 42 A9803
#endif

#endif /* PRAGMAS_TOOLMANAGER_PRAGMAS_H */
