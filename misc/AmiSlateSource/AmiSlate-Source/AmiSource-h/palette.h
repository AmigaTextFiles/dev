/* palette.h */

void InitToolBox(void);
void DrawToolBox(void);
void EraseToolBox(int nWidth, int nHeight);
void HandleToolBox(int nForceIndex);
void SetFakeToolBoxClick(int nIndex, int * nX, int * nY);

BOOL DrawPaletteEntry(int nColor, BOOL BRev);
BOOL ChangeDepth(int nNewDepth);

int nGetGadgetHeight(void);
int nGetGadgetWidth(void);
int nGetToolBoxLeft(void);
int nGetToolBoxTop(void);

static void DrawPaletteSquare(int nX, int nY, int nHeight, int nWidth, int nColor, BOOL BRev);
static int nGetPaletteHeight(void);
static int nGetNumberOfColors(void);
static int nGetPaletteSquareHeight(void);
static int nGetPaletteSquareWidth(void);
