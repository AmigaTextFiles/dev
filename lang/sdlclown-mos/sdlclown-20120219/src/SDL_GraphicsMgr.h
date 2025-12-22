#ifndef _SDL_GRAPHICSMGR_H
#define _SDL_GRAPHICSMGR_H

#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

int StartGraphicsManager(void);
void CloseGraphicsManager(void);
void GMDrawRect(int x, int y, int w, int h, int r, int g, int b);
int GMManageEvents(void);
int GetMouseX(void);
int GetMouseY(void);
void FlipVideo(void);
#endif
