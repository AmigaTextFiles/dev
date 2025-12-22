#ifndef PRAGMAS_TOOLMANAGER_PRAGMAS_H
#define PRAGMAS_TOOLMANAGER_PRAGMAS_H

/*
 * pragmas/toolmanager_pragmas.h  V3.1
 *
 * Inline declarations for toolmanager.library functions
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
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
