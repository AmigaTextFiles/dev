#ifndef CLIB_GAMESUPPORT_PROTOS_H
#define CLIB_GAMESUPPORT_PROTOS_H

void * GS_MemoryAlloc(ULONG);
void GS_MemoryFree(void *);
void * GS_MemoryRealloc(void *,ULONG);
ULONG GS_AllocateColors(struct Screen *,struct GS_ColorDef *,ULONG);
void GS_FreeColors(struct Screen *,struct GS_ColorDef *);
char * GS_FormatString(const char *,const void *,ULONG *,struct Locale *);
char * GS_FormatDate(const char *,ULONG,ULONG *,struct Locale *);
void GS_DrawString(const char *,void *,struct RastPort *,struct Locale *);
void GS_DrawDate(char *,ULONG,struct RastPort *,struct Locale *);
WORD GS_StringWidth(const char *,void *,struct RastPort *,struct Locale *);
WORD GS_DateWidth(char *,ULONG,struct RastPort *,struct Locale *);
struct GS_Sprites * GS_LoadSprites(const char *,struct Screen *);
void GS_FreeSprites(struct GS_Sprites *,struct Screen *);
ULONG GS_AllocateJoystick(struct MsgPort *,UBYTE);
void GS_SendJoystick(void);
void GS_FreeJoystick(void);
ULONG GS_HappyBlanker(void);
void GS_NoHappyBlanker(void);
void * GS_ObtainScoreHandle(const struct GS_ScoreDef *,const char *,const char *);
void GS_ReleaseScoreHandle(void *);
struct GS_ScoreList * GS_ObtainScores(void *,ULONG);
LONG GS_InsertScore(void *,struct GS_Score *);
void GS_ReleaseScores(void *,struct GS_ScoreList *);
ULONG GS_WindowSleep(struct Window *);
void GS_WindowWakeup(struct Window *);
ULONG GS_HappyBlanker(void);
void GS_NoHappyBlanker(void);
char * GS_TransformUsername(const char *,char *);

#endif  /* CLIB_GAMESUPPORT_PROTOS_H */
