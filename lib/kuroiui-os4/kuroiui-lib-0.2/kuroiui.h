/* kuroiUI 0.1 - by Sairyx.
 * This software is released under the GPL -
 * you may modify it and redistribute under
 * the terms specified in the file LICENSE.
 */

#ifndef __KUROIUI_H__
#define __KUROIUI_H__

#include <stdio.h>
#include <string.h>

#include <SDL/SDL.h>
#include <SDL/SDL_main.h>
#include <SDL/SDL_image.h>
#include <SDL/SDL_gfxPrimitives.h>

#include "xarray.cc"

#define IMPLEMENT_GET_COOR SDL_Rect *getCoor() { return this->coor; }

extern bool captureKeys;
extern bool captureClicks;

/* Class definitions. */
/* Class "kuroi_Object": the base class for kuroiUI. */
class kuroi_Object
{
public:
	kuroi_Object() { }
	virtual ~kuroi_Object() { }

	virtual void draw() { } 		// virtual, okay to fall back.
	virtual void updateValues() { }		// virtual, okay to fall back.
	virtual SDL_Rect *getCoor() { return (SDL_Rect *)0; } 		// virtual, okay to fall back.

	void *drawTo;

	// Events.
	void (*onClick) (kuroi_Object *, int, int, int);
};

/* Class "kuroi_Character": contains a single character in a font. */
class kuroi_Character : public kuroi_Object
{
public:
	kuroi_Character();
	~kuroi_Character();

	void draw() { }			// override

	int width;
	bool *data;
};

/* Class "kuroi_Font": contains a font set for use with kuroiUI. */
class kuroi_Font : public kuroi_Object
{
public:
	kuroi_Font(char *readInPath);
	~kuroi_Font();

	void draw() { }			// override

	char *characterSet; int height;
	kuroi_Character *characters;
};

/* Class "kuroi_String": contains a renderable string with font reference. */
class kuroi_String : public kuroi_Object
{
public:
	kuroi_String(void *drawingContext, char *text, kuroi_Font *font, int x, int y, int r, int g, int b, int a);
	~kuroi_String();

	void draw();			// override
	void updateValues();		// override
	IMPLEMENT_GET_COOR		// override
	int getPixelLength();

	SDL_Rect *coor;
	int r, g, b, a;
	char *text;
	kuroi_Font *font;

	bool drawBackground, shadeBorder;
};

/* Class "kuroi_Container": a container of kuroi_Objects. */
class kuroi_Container : public kuroi_Object
{
public:
	kuroi_Container();
	~kuroi_Container();

	void draw();			// override

	XArray <kuroi_Object> *objects;
};

/* Class "kuroi_Window": represents a graphical window. */
class kuroi_Window : public kuroi_Object
{
public:
	kuroi_Window(SDL_Surface *drawingContext, int x, int y, int w, int h, int r, int g, int b, kuroi_String *title);
	~kuroi_Window();

	void draw();			// override
	IMPLEMENT_GET_COOR		// override
	bool coordInside(int x, int y);
	bool handleEvents(SDL_Event event);

	kuroi_Container *components;
	SDL_Color *color;
	SDL_Rect *coor;
	int borderSize;
	kuroi_String *title;
};

/* Class "kuroi_PushButton": represents a push button. */
class kuroi_PushButton : public kuroi_Object
{
public:
	kuroi_PushButton(kuroi_Window *drawingContext, int x, int y, int w, int h, int r, int g, int b, kuroi_String *text);
	~kuroi_PushButton();

	void draw();			// override
	IMPLEMENT_GET_COOR		// override

	SDL_Rect *coor;
	SDL_Color *color;
	kuroi_String *text;
};

class kuroi_CheckBox : public kuroi_Object
{
public:
	kuroi_CheckBox(kuroi_Window *drawingContext, int x, int y, int r, int g, int b, kuroi_String *text);
	~kuroi_CheckBox();

	void draw();			// override
	IMPLEMENT_GET_COOR		// override

	SDL_Rect *coor;
	SDL_Color *color;
	kuroi_String *text;

	bool checked;
};

#endif
