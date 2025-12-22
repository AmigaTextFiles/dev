#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <cybergraphx/cybergraphics.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <proto/cybergraphics.h>
#include <proto/Warp3D.h>
#include <3d.h>
#include <vecmat.h>
#include <def.h>
#include <render.h>
#include <readlevel.h>
#include <text.h>
#include <libutil.h>
#include <textures.h>

extern struct Library *Warp3DBase;
extern struct GfxBase *GfxBase;

int FrameCtr = -1;
ULONG lasterr;
int bufnum = 1;
W3D_Scissor s = {0,0, 640, 480};

BOOL CursorIdle = TRUE;

extern struct Screen * screen;
extern struct Window * window;
extern W3D_Context   * context;
extern struct BitMap * bm;
extern BMFont        * font;
extern int             MouseX, MouseY, LMB;

extern struct ScreenBuffer *Buf1, *Buf2;
extern BOOL DoMultiBuffer;

float el = 0.f, az = 0.f;
float gx = 32.0, gy = 32.0, gz = 32.0;

int max_recurse = 15;

char line1[50];
char line2[50];
char line3[50];
char line4[50];

char *lines[4] = {
	line1,
	line2,
	line3,
	line4
};

char *menu[] = {
	"FILE",
	"OPTION",
	NULL
};

char* file[] = {
	"ABOUT",
	"QUIT",
	NULL
};

char *option[] = {
	"PERSPECT",
	"LIGHT",
	"FPS",
	"FILTER",
	"WINCOL",
	NULL
};

char **sub[] = {
	file,
	option,
	NULL
};

int wincol = 0;
UWORD WindowColors[] = {
	0xafa0,
	0xa00F,
	0xafff,
	0x4fff,
	0xa0ff,
	0xaaaa,
	0xaf00,
	0x3f00,
	0x0001,
	0xf000,
	0
};

int active_menu=-1;
int active_item=-1;

/*
** Increase the frame counter by one. In case of an overrun,
** i.e. when the framectr gets zero, clear the projected/rotated
** flags "manually"
*/
__inline
void RENDER_Tick(void)
{
	FrameCtr++;
	if (FrameCtr == 0) {
		// We wrapped!
		bzero(projected, sizeof(short)*MAX_POINTS);
		//bzero(rotated, sizeof(short)*MAX_NORMALS);
		FrameCtr++;
	}
}

#ifndef NDEBUG
/*
** Draw a triangle/trifan for outline mode
*/
void RENDER_DrawTri(float x1, float y1, float x2, float y2, float x3, float y3)
{
	Move(window->RPort, (LONG)x1, BUFFY((LONG)y1));
	Draw(window->RPort, (LONG)x2, BUFFY((LONG)y2));
	Draw(window->RPort, (LONG)x3, BUFFY((LONG)y3));
	Draw(window->RPort, (LONG)x1, BUFFY((LONG)y1));
}

void RENDER_DrawTriFan(W3D_Triangles* triangles)
{
	int i;
	for (i=1; i<triangles->vertexcount-1; i++) {
		RENDER_DrawTri(triangles->v[0].x, triangles->v[0].y,
			triangles->v[i].x, triangles->v[i].y,
			triangles->v[i+1].x, triangles->v[i+1].y);
	}
}
#endif

/*
** Render one polygon
** This call does the following
** - Check visibility of this polygon via normal (early termination)
** - Check if all points are transformed (and transform if needed)
** - Clip the polygon to the screen (terminated if completely clipped)
** - Draw the polyong
**
** IMPLEMENTATION NOTES
** --------------------
** Points get transformed as we go. This has two advantages:
** 1) Points are transformed if and only if they are needed
** 2) We can do stuff while the triangle rendered draws the polygon
**
*/
void RENDER_DrawPoly(W3D_Context* context, int polynum)
{
	int normal = faces[polynum].normal;
	int pt     = faces[polynum].points[0];
	int n,i,j;
	int *temp_pts;
	UBYTE codes_and=0xff, codes_or=0;

	static W3D_Triangles trifan;
	static W3D_Vertex verts[MAX_EDGES];

	extern BOOL DoLight;
	extern BOOL OutlineMode;

	// Check if we can see the polygon
	if (l3_check_visible(&points[pt], &normals[normal]) == FALSE) return;

	// Make sure the polygon is completely projected
	for (i=0; i < faces[polynum].numedges; i++) {
		j=faces[polynum].points[i];
		if (projected[j] != FrameCtr) {
			// Point has not been transformed this frame yet
			l3_transform_point(&vertices[j].vec, &points[j]);
			l3_project_vertex(&vertices[j]);
			projected[j] = FrameCtr;    // Mark as finished
		}
		if (faces[polynum].type == POLYTYPE_Flat) {
			if (DoLight) {
				vertices[j].tcolor.x = light[j].x * faces[polynum].render.color.x;
				vertices[j].tcolor.y = light[j].y * faces[polynum].render.color.y;
				vertices[j].tcolor.z = light[j].z * faces[polynum].render.color.z;
			} else {
				vertices[j].tcolor.x = faces[polynum].render.color.x;
				vertices[j].tcolor.y = faces[polynum].render.color.y;
				vertices[j].tcolor.z = faces[polynum].render.color.z;
			}
		} else {
			if (DoLight) {
				vertices[j].tcolor.x = light[j].x;
				vertices[j].tcolor.y = light[j].y;
				vertices[j].tcolor.z = light[j].z;
			} else {
				vertices[j].tcolor.x = 1.0;
				vertices[j].tcolor.y = 1.0;
				vertices[j].tcolor.z = 1.0;
			}
			vertices[j].tu = faces[polynum].render.texinfo.u[i];
			vertices[j].tv = faces[polynum].render.texinfo.v[i];
		}
		codes_or    |= vertices[j].ccodes;
		codes_and   &= vertices[j].ccodes;
	}

	if (codes_and)      return;     // Trivially reject polygon

	// Clip the polygon
	if (codes_or) {
		n = l3_clip_polygon(&temp_pts, polynum, codes_or);
	} else {
		temp_pts = &(faces[polynum].points[0]);
		n = faces[polynum].numedges;
	}


	if (faces[polynum].type == POLYTYPE_Flat) {
		W3D_SetState(context, W3D_TEXMAPPING, W3D_DISABLE);
		trifan.tex          = NULL;
		trifan.vertexcount  = n;
		trifan.v            = verts;

		for (i=0; i<n; i++) {
			j = *(temp_pts+i);
			verts[i].x = (W3D_Float)vertices[j].sx;
			verts[i].y = (W3D_Float)vertices[j].sy;
			verts[i].z = (W3D_Float)0.f; // Normalized Z here
			verts[i].u = verts[i].v = verts[i].w = 0.f;

			if (verts[i].x > (float)s.width - 1) verts[i].x = (float)s.width-1;
			if (verts[i].y > (float)s.height- 1) verts[i].y = (float)s.height-1;

			verts[i].color.r = (W3D_Float)vertices[j].tcolor.x;
			verts[i].color.g = (W3D_Float)vertices[j].tcolor.y;
			verts[i].color.b = (W3D_Float)vertices[j].tcolor.z;
			verts[i].color.a = (W3D_Float)1.0;
		}

		lasterr = W3D_DrawTriFan(context, &trifan);
		if (lasterr != W3D_SUCCESS) return;
		#ifndef NDEBUG
		if (OutlineMode == TRUE) RENDER_DrawTriFan(&trifan);
		#endif
	} else {
		W3D_SetState(context, W3D_TEXMAPPING, W3D_ENABLE);
		trifan.tex          = (W3D_Texture*)textures[faces[polynum].render.texinfo.texture];
		trifan.vertexcount  = n;
		trifan.v            = verts;

		for (i=0; i<n; i++) {
			j = *(temp_pts+i);
			verts[i].x = (W3D_Float)vertices[j].sx;
			verts[i].y = (W3D_Float)vertices[j].sy;
			verts[i].z = (W3D_Float)0.f; // Normalized Z here
			verts[i].u = (W3D_Float)vertices[j].tu;
			verts[i].v = (W3D_Float)vertices[j].tv;
			if (vertices[j].vec.z != 0.0) {
				verts[i].w = (W3D_Float)(10.0/vertices[j].vec.z);
			} else {
				verts[i].w = (W3D_Float)0.0;
			}

			if (verts[i].x > (float)s.width - 1) verts[i].x = (float)s.width-1;
			if (verts[i].y > (float)s.height- 1) verts[i].y = (float)s.height-1;

			verts[i].color.r = (W3D_Float)vertices[j].tcolor.x;
			verts[i].color.g = (W3D_Float)vertices[j].tcolor.y;
			verts[i].color.b = (W3D_Float)vertices[j].tcolor.z;
			verts[i].color.a = (W3D_Float)1.0;
		}

		lasterr = W3D_DrawTriFan(context, &trifan);
		if (lasterr != W3D_SUCCESS) return;
		#ifndef NDEBUG
		if (OutlineMode == TRUE) RENDER_DrawTriFan(&trifan);
		#endif
	}

}

/*
** Render one cell
** This takes the pointer to one cell and completely renders it
**
** Essentially, this just renders each and every polygon in the cell
** those that are invisible are backface-culled or clipped away.
*/
void RENDER_DrawCell(W3D_Context* context, cell* here)
{
	int i = here->numpoly;
	int j = here->firstpoly;

	while (i) {
		RENDER_DrawPoly(context, j);
		j++;
		i--;
	}
}

/*
** Set the camera position and orientation
*/
void RENDER_SetCamera(float xgx, float xgy, float xgz, float xel, float xaz)
{
	gx = xgx;
	gy = xgy;
	gz = xgz;
	el = xel;
	az = xaz;
	l3_set_camera(gx, gy, gz, el, az);
}

/*
** Turn the camera by delta_el and delta_az
*/
void RENDER_TurnCamera(float delta_el, float delta_az)
{
	el += delta_el;
	az += delta_az;
	if (az < 0.f)   az = 359.f;
	if (az > 359.f) az = 0.f;
	if (el < 0.f)   el = 359.f;
	if (el > 359.f) el = 0.f;
	l3_set_camera(gx, gy, gz, el, az);
}

/*
** Move the player/camera delta units in the current facing direction
*/
void RENDER_MoveCamera(float delta)
{
	float c_az = (float)(az/180.f*M_PI);
	float delta_x = delta * (float)sin((double)c_az);
	float delta_z = delta * (float)cos((double)c_az);

	gx += delta_x;
	gz += delta_z;

	l3_set_camera_pos(gx, gy, gz);

}

/*
** Set the render Window
*/
void RENDER_SetWindow(int bx, int by, int width, int height)
{
	l3_set_window((float)bx, (float)by, (float)width, (float)height, 0.0002f);
	printf("Render window set to (%d,%d)-(%d,%d)\n", bx, by, width, height);
}

/*
** Recursive level draw
**
** This routine "flood-fills" the level, marking away cells to
** be drawn. Visibility is decided by comparing the relative
** position towards the camera with the view vector.
** Invisible cells are not marked.
** Upon completion of recursive descent, the cells
** are drawn. This ensures that cells are drawn back-to-front.
**
** Of course, this is utter bullsh*t. The level has to be drawn in breadth-
** first order, otherwise the recursion might "loop back" onto the viewer,
** resulting in a completely screwed-up drawing order (there are actually a
** few places where this is visible). Thus, you would need a queue, not a stack,
** to implement this.
** Most likely, this will never be done...
*/

vm_vector view;

#if 1
void RENDER_RecursiveDrawLevel(int level, int x, int y, vm_vector* view, int mask)
{
	cell* here;
	vm_vector P;
	mapcell* metoo;

	// Step one: Check if this cell is visible
	// If not, stop descent

	P.x = (float)x*64.f + 32.f;
	P.y = 0;
	P.z = (float)y*64.f + 32.f;
	if (l3_check_cell(&P,view) == FALSE) return;

	// Step two: Mark this
	metoo = LEVEL_GetMapCell(x,y);
	if (metoo->mark == FrameCtr) return;    // We are already painted
	here = metoo->here;
	metoo->mark = FrameCtr;

	// Step three: Examine the neigbourhood and descent
	if ((here->openvec & COPEN_NORTH & mask) && level < max_recurse)
		RENDER_RecursiveDrawLevel(level+1, x, y+1, view, ~COPEN_SOUTH);
	if ((here->openvec & COPEN_EAST  & mask) && level < max_recurse)
		RENDER_RecursiveDrawLevel(level+1, x+1, y, view, ~COPEN_WEST);
	if ((here->openvec & COPEN_SOUTH & mask) && level < max_recurse)
		RENDER_RecursiveDrawLevel(level+1, x, y-1, view, ~COPEN_NORTH);
	if ((here->openvec & COPEN_WEST  & mask) && level < max_recurse)
		RENDER_RecursiveDrawLevel(level+1, x-1, y, view, ~COPEN_EAST);

	RENDER_DrawCell(context, here);
	return;
}
#endif

/*
** Render the complete level
** This starts to descent fron the current cell and spreads
** out flood-fill-like in the viewing direction, until the
** cell leaves the viewing pyramid or a certain distance
** from the viewer is reached.
**
** Currently, renders two cells at 0,2 and 1,2
*/
void RENDER_DrawLevel(W3D_Context* context)
{
	int x,y;

	RENDER_Tick();

	view.x = 1.0;
	view.y = 0.0;
	view.z = 0.0;
	l3_rot_y(&view, az);    // Make a direction vector projected to floor plane

	x=(int)(gx/64.f);
	y=(int)(gz/64.f);
	if (x<0 || x > CurrentLevel->sizex) return;
	if (y<0 || y > CurrentLevel->sizey) return;


	W3D_LockHardware(context);
	RENDER_RecursiveDrawLevel(0,x,y,&view, 0xff);
	W3D_UnLockHardware(context);
	return;
}

/*
** Switch the rendering buffers
*/
void RENDER_SwitchBufferOld(void)
{
	struct ViewPort *vp = &(screen->ViewPort);

	if (bufnum == 0) {
		W3D_SetDrawRegion(context, bm, 0, &s);
		vp->RasInfo->RyOffset = s.height;
		ScrollVPort(vp);
		WaitBOVP(vp);
		bufnum = 1;
	} else {
		W3D_SetDrawRegion(context, bm, s.height, &s);
		vp->RasInfo->RyOffset = 0;
		ScrollVPort(vp);
		WaitBOVP(vp);
		bufnum = 0;
	}
}


void RENDER_SwitchBufferNew(void)
{
	void* handle;
	extern UWORD *DisplayBase;
	extern ULONG BytesPerRow;

	if (bufnum == 0) {
		bm = Buf2->sb_BitMap;
		W3D_SetDrawRegion(context, bm, 0, &s);
		Buf1->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort = NULL;
		while (!ChangeScreenBuffer(screen, Buf1));
		WaitTOF();
		bufnum = 1;
	} else {
		bm = Buf1->sb_BitMap;
		W3D_SetDrawRegion(context, bm, 0, &s);
		Buf2->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort = NULL;
		while (!ChangeScreenBuffer(screen, Buf2));
		WaitTOF();
		bufnum = 0;
	}
	Forbid();
	handle = LockBitMapTags(bm,
		LBMI_BASEADDRESS, &DisplayBase,
		LBMI_BYTESPERROW, &BytesPerRow,
	TAG_DONE);
	UnLockBitMap(handle);
	Permit();
}

void RENDER_SwitchBuffer(void)
{
	if (DoMultiBuffer) RENDER_SwitchBufferNew();
	else               RENDER_SwitchBufferOld();
}

/*
** Scroll the lower text display by
** cycling the array
*/
void RENDER_ScrollTextDisplay(void)
{
	char *l=lines[0];
	lines[0] = lines[1];
	lines[1] = lines[2];
	lines[2] = lines[3];
	lines[3] = l;
	*(lines[3]) = 0;
}

/*
** Add a line to the display
*/
void RENDER_Print(char *string)
{
	RENDER_ScrollTextDisplay();
	strcpy(lines[3],string);
}



/*
** Draws the text display
*/
static void RENDER_DrawTextDisplay(void)
{
	static float old_time=0.f;
	static int cursorstate=0;
	int top = s.height - font->GlyphHeight*5 - 5;

	TEXT_SetColor(30,255,30);

	if (*(lines[0])) TEXT_PrintString(3,top, lines[0]);
	top+=font->GlyphHeight+1;
	if (*(lines[1])) TEXT_PrintString(3,top, lines[1]);
	top+=font->GlyphHeight+1;
	if (*(lines[2])) TEXT_PrintString(3,top, lines[2]);
	top+=font->GlyphHeight+1;
	if (*(lines[3])) TEXT_PrintString(3,top, lines[3]);
	top+=font->GlyphHeight+1;
	if (CursorIdle)
	{
		float time = TIMER_GetSeconds();
		if (cursorstate) TEXT_PrintString(3,top, "_");

		if (time-old_time > 0.5) {
			cursorstate=1-cursorstate;
			old_time = time;
		}
	}
}

/*
** Draw the menu itself
*/
void RENDER_DoSubMenu(int p, char *titles[])
{
	static char buffer[50];
	int i=0;
	int y = 20;
	BOOL o;
	active_item = -1;
	TEXT_SetColor(255, 200, 0);

	o = (LMB==1 && MouseX >= p*40 && MouseY <= (p+1)*40);
	while (titles[i]) {
		if (o && MouseY >= y && MouseY <= y+font->GlyphHeight+2) {
			strcpy(buffer, "&i");
			strcat(buffer, titles[i]);
			strcat(buffer, "&p");
			active_item = i;
		} else {
			strcpy(buffer, titles[i]);
		}
		TEXT_PrintString(p*40, y, buffer);
		y+=font->GlyphHeight+3;
		i++;
	}
}

/*
** Draw the menu strip
*/
void RENDER_DoMenuStrip(void)
{
	static char buffer[50];
	static int posted = -1;
	int i;

	active_menu = -1;

	if (!LMB) posted = -1;
	if (MouseY > 10 && posted==-1) return;
	if (MouseX < 40) active_menu=0;
	if (MouseX > 40 && MouseX < 80) active_menu=1;

	i=0;
	while (menu[i]) {
		if (i==active_menu) {
			posted = i;
			strcpy(buffer, "&i");
			strcat(buffer, menu[i]);
			strcat(buffer, "&p");
			if (LMB) RENDER_DoSubMenu(i,sub[i]);
		} else {
			strcpy(buffer, menu[i]);
		}
		TEXT_SetColor(0,0,255);
		TEXT_PrintString(i*40, 3, buffer);
		i++;
	}
	if (active_menu == -1) posted=-1;
}

void RENDER_HandleMenuUp(void)
{
	extern BOOL DoFPS, DoLight, running, DoFilter;
	switch(active_menu) {
	case 0:
		if (active_item == 1) running=FALSE;
		else {
			RENDER_Print("Engine V1.0");
			RENDER_Print("(C) 1998 Hans-Joerg Frieden");
			RENDER_Print("Part of Warp3D");
			RENDER_Print(" ");
		}
		break;
	case 1:
		switch(active_item) {
		case 0:
			if (W3D_GetState(context, W3D_PERSPECTIVE) == W3D_ENABLED) {
				W3D_SetState(context, W3D_PERSPECTIVE, W3D_DISABLE);
				RENDER_Print("Perspective off");
			} else {
				W3D_SetState(context, W3D_PERSPECTIVE, W3D_ENABLE);
				RENDER_Print("Perspective on");
			}
			break;
		case 1:
			if (DoLight == FALSE) DoLight = TRUE;
			else                  DoLight = FALSE;
			if (DoLight) RENDER_Print("Lighting on");
			else         RENDER_Print("Lighting off");
			break;
		case 2:
			if (DoFPS == FALSE) DoFPS = TRUE;
			else                DoFPS = FALSE;
			break;
		case 3:
			if (DoFilter == TRUE)
				DoFilter = FALSE;
			else
				DoFilter = TRUE;
			TEXTURE_SetFilter(DoFilter);
			break;
		case 4:
			wincol++; if (WindowColors[wincol] == 0) wincol=0;
			TEXTURE_FlipWindowColor(WindowColors[wincol]);
			break;
		}
		break;
	}

}

/*
** Do light effects
*/
void RENDER_DoLights(void)
{
#define LIGHT_STEP 0.05

	static float old_time = 0.f;
	float now = TIMER_GetSeconds();

	light[34].x -= LIGHT_STEP; if (light[34].x < 0.f) light[34].x = 0.f;
	light[34].y -= LIGHT_STEP; if (light[34].y < 0.f) light[34].y = 0.f;
	light[34].z -= LIGHT_STEP; if (light[34].z < 0.f) light[34].z = 0.f;
	light[35].x -= LIGHT_STEP; if (light[35].x < 0.f) light[35].x = 0.f;
	light[35].y -= LIGHT_STEP; if (light[35].y < 0.f) light[35].y = 0.f;
	light[35].z -= LIGHT_STEP; if (light[35].z < 0.f) light[35].z = 0.f;


	if (now-old_time >= 1.0) {
		light[34].x = 1.0;
		light[34].y = 0.0;
		light[34].z = 0.0;
		light[35].x = 1.0;
		light[35].y = 0.0;
		light[35].z = 0.0;
		old_time = now;
	}

}

/*
** Draw the game screen
*/
void RENDER_DrawScreen(void)
{
	static float old_time = 0.f;
	static char buffer[40];
	static int FCount = 0;
	extern BOOL DoFPS;

	EraseRect(window->RPort,
		s.left, BUFFY(s.top),
		s.left+s.width, BUFFY(s.top+s.height));

	RENDER_DrawLevel(context);

	W3D_WaitIdle(context);
	RENDER_DrawTextDisplay();
	FCount++;

	/* Do the menu strip */
	RENDER_DoMenuStrip();

	/* Do lights */
	RENDER_DoLights();

	if (DoFPS) {
		float time = TIMER_GetSeconds();
		float fps;
		if (time-old_time > 5.0) {
			fps = (float)FCount/(time-old_time);
			old_time = time;
			sprintf(buffer, "FPS: %5.2f\0", fps);
			RENDER_Print(buffer);
			FCount = 0;
		}
	}

	RENDER_SwitchBuffer();
}


