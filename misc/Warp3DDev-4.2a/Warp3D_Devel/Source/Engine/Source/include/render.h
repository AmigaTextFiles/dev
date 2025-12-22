#ifndef __RENDER_H
#define __RENDER_H

#define BUFFY(y) ((DoMultiBuffer == FALSE) * (1-bufnum) * s.height+(y))

void RENDER_Tick(void);
void RENDER_DrawLevel(W3D_Context* context);
void RENDER_SetCamera(float gx, float gy, float gz, float el, float az);
void RENDER_MoveCamera(float delta);
void RENDER_TurnCamera(float delta_el, float delta_az);
void RENDER_SetWindow(int bx, int by, int width, int height);
void RENDER_DrawScreen(void);
void RENDER_SwitchBuffer(void);
void RENDER_Print(char *string);

#endif
