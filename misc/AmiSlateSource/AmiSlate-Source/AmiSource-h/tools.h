/* tools.h -- drawing functions */
#ifndef TOOLS_H
#define TOOLS_H

void EraseChatLines(int nWidth, int nHeight);
void DrawChatLines(void);
void EnableDraw(BOOL BCanDraw);
void ResetPolygonTool(void);
void FixCoords(int *X, int *Y);
void UnFixCoords(int *X, int *Y);
void Ellipse(int x, int y, int rx, int ry, BOOL BFilled);
void DisplayKeyPress(char nChar, BOOL BEchoToRemote);
void DrawRasterChunk(UWORD uwPixels, UWORD uwColorCode, struct SlateRaster *srast, int *nOptPen);
void TransmitDrawCanvas(void);

int nGetDrawWindowBottom(void);

BOOL FixPos(int *X, int *Y);
BOOL ReSizeWindow(int nWidth, int nHeight, BOOL BCausedLocally);
BOOL DrawResizedWindow(int nWidth, int nHeight, BOOL BCausedLocally);

BOOL MouseUpAction(int nMode);
BOOL MouseDownAction(int nMode);
BOOL MouseMoveAction(int nMode);
BOOL BreakAction(int nMode);
BOOL ResumeAction(int nMode);

static BOOL Mode_Pen_MouseDown(void);
static BOOL Mode_Pen_MouseUp(void);
static BOOL Mode_Pen_MouseMove(void);
static BOOL Mode_Pen_Break(BOOL BResume);

static BOOL Mode_Dot_MouseDown(void);
static BOOL Mode_Dot_MouseUp(void);
static BOOL Mode_Dot_MouseMove(void);
static BOOL Mode_Dot_Break(BOOL BResume);

static BOOL Mode_Line_MouseDown(void);
static BOOL Mode_Line_MouseUp(void);
static BOOL Mode_Line_MouseMove(void);
static BOOL Mode_Line_Break(BOOL BResume);

static BOOL Mode_Circle_MouseDown(void);
static BOOL Mode_Circle_MouseUp(void);
static BOOL Mode_Circle_MouseMove(void);
static BOOL Mode_Circle_Break(BOOL BResume);

static BOOL Mode_Square_MouseDown(void);
static BOOL Mode_Square_MouseUp(void);
static BOOL Mode_Square_MouseMove(void);
static BOOL Mode_Square_Break(BOOL BResume);
void Rectangle(int x1, int y1, int x2, int y2, BOOL BFilled);

static BOOL Mode_Poly_MouseDown(void);
static BOOL Mode_Poly_MouseUp(void);
static BOOL Mode_Poly_MouseMove(void);
static BOOL Mode_Poly_Break(BOOL BResume);

static BOOL Mode_Flood_MouseDown(void);
static BOOL Mode_Flood_MouseUp(void);
static BOOL Mode_Flood_MouseMove(void);
static BOOL Mode_Flood_Break(BOOL BResume);

#endif
