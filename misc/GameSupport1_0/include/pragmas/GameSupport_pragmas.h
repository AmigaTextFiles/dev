#ifndef PRAGMA_GAMESUPPORT_PRAGMAS_H
#define PRAGMA_GAMESUPPORT_PRAGMAS_H

#pragma libcall GameSupportBase GS_MemoryAlloc 1E 001
#pragma libcall GameSupportBase GS_MemoryFree 24 801
#pragma libcall GameSupportBase GS_MemoryRealloc 2A 0802
#pragma libcall GameSupportBase GS_AllocateColors 30 09803
#pragma libcall GameSupportBase GS_FreeColors 36 9802
#pragma libcall GameSupportBase GS_FormatString 3C BA9804
#pragma libcall GameSupportBase GS_FormatDate 42 A90804
#pragma libcall GameSupportBase GS_DrawString 48 BA9804
#pragma libcall GameSupportBase GS_DrawDate 4E A90804
#pragma libcall GameSupportBase GS_StringWidth 54 BA9804
#pragma libcall GameSupportBase GS_DateWidth 5A A90804
#pragma libcall GameSupportBase GS_LoadSprites 60 9802
#pragma libcall GameSupportBase GS_FreeSprites 66 9802
#pragma libcall GameSupportBase GS_AllocateJoystick 6C 0802
#pragma libcall GameSupportBase GS_SendJoystick 72 00
#pragma libcall GameSupportBase GS_FreeJoystick 78 00
#pragma libcall GameSupportBase GS_HappyBlanker 7E 00
#pragma libcall GameSupportBase GS_NoHappyBlanker 84 00
#pragma libcall GameSupportBase GS_ObtainScoreHandle 8A A9803
#pragma libcall GameSupportBase GS_ReleaseScoreHandle 90 801
#pragma libcall GameSupportBase GS_ObtainScores 96 0802
#pragma libcall GameSupportBase GS_InsertScore 9C 9802
#pragma libcall GameSupportBase GS_ReleaseScores A2 9802
#pragma libcall GameSupportBase GS_WindowSleep A8 801
#pragma libcall GameSupportBase GS_WindowWakeup AE 801
#pragma libcall GameSupportBase GS_HappyBlanker B4 00
#pragma libcall GameSupportBase GS_NoHappyBlanker BA 00
#pragma libcall GameSupportBase GS_TransformUsername C0 9802

#endif  /* PRAGMA_GAMESUPPORT_PRAGMAS_H */
