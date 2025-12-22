/* kuroiUI 0.1 - by Sairyx.
 * This software is released under the GPL -
 * you may modify it and redistribute under
 * the terms specified in the file LICENSE.
 */

#include "kuroiui.h"

bool captureKeys = true, captureClicks = true;

// For dragging windows around.
int beginDragX = -1, beginDragY = -1; bool dragging = false;
// Offsets from `coor' variable.
int beginDragXO = -1, beginDragYO = -1;

void readLine(FILE *file, char *string)
{
	do
	{
		fgets(string, 1024, file);
	}
		while (
		((string[0] == ';') || 
			(string[0] == '\n') || 
			(string[0] == 9) || 
			(string[0] == 10) || 
			(string[0] == 13)) &&
		!feof(file));
}

kuroi_Character::kuroi_Character()
{
	this->data = NULL;
}

kuroi_Character::~kuroi_Character()
{
	if (this->data != NULL);
		delete [] this->data;
}

kuroi_Font::kuroi_Font(char *readInPath)
{
	FILE *readIn = fopen(readInPath, "r");

	char *fontVer = new char[10];
	bool *inData; char *inqData;
	
	fscanf(readIn, "kuroi_Font: %s", fontVer);
	if (strcmp(fontVer, "1.0") != 0)
	{
		fprintf(stderr, "Warning: font read in failed. (got ver %s, expecting 1.0)\n", fontVer);
	}
	else
	{
		char *lineData = new char[1025]; char tc;
		int cw = 0;
		this->characterSet = new char[257];

		while (!feof(readIn))
		{
			readLine(readIn, lineData);

			if (sscanf(lineData, "Height: %d", &this->height));
			// Nothing special to do here.
				
			if (sscanf(lineData, "Characterset: %s", this->characterSet))
			{
				// To account for spaces in the string itself.
				strcpy(characterSet, strchr(lineData, ' ') + 1);
				// "Characterset:" from the string.
				this->characters = new kuroi_Character[strlen(characterSet)];
			}
		
			if (sscanf(lineData, "Character \"%c\": %d %s", &tc, &cw, inqData) || sscanf(lineData, "DoubleQuoteCharacter: %d %s", &cw, inqData))
			{
				inData = new bool[cw * this->height];
				for (int x = 0; x < (int)strlen(inqData); x++)
					if (inqData[x] == '1')
						inData[x] = true;
					else
						inData[x] = false;
				if (strncmp(lineData, "Double", 6) == 0)
					tc = '"';
				this->characters[strlen(this->characterSet) - strlen(strchr(this->characterSet, tc))].data = inData;
				this->characters[strlen(this->characterSet) - strlen(strchr(this->characterSet, tc))].width = cw;
			}
		}

		delete [] lineData;
	}

	delete [] fontVer;
	
	fclose(readIn);
}

kuroi_Font::~kuroi_Font()
{
	delete [] this->characters;
	delete [] this->characterSet;
}

kuroi_String::kuroi_String(void *drawingContext, char *text, kuroi_Font *font, int x, int y, int r, int g, int b, int a)
{
	this->drawTo = drawingContext;
	this->text = text;
	this->font = font;
	this->coor = new SDL_Rect();
	this->coor->x = x; this->coor->y = y;
	this->r = r; this->g = g; this->b = b; this->a = a;

	this->drawBackground = true; this->shadeBorder = true;
}

kuroi_String::~kuroi_String()
{
	delete this->coor;
}

void kuroi_String::draw()
{
	kuroi_Character *useData; int relx = 0, reld;
	int totalWidth = this->getPixelLength();
	SDL_Surface *ds = (SDL_Surface *)(((kuroi_Window *)this->drawTo)->drawTo);
	
	if (this->drawBackground)
		boxRGBA(ds, this->coor->x - 2, this->coor->y - 2, this->coor->x + totalWidth, this->coor->y + this->font->height + 1, 0, 0, 0, 127);
	
	for (int i = 0; i < (int)strlen(this->text); i++)
	{
		useData = &this->font->characters[strlen(this->font->characterSet) - strlen(strchr(this->font->characterSet, (int)this->text[i]))];
		
		reld = -1;
		for (int y = 0; y < this->font->height; y++)
			for (int x = 0; x < useData->width; x++)
			{
				reld++;
				if (useData->data[reld])
					pixelRGBA(ds, this->coor->x + relx + x, this->coor->y + y, this->r, this->g, this->b, this->a);
				else if (this->drawBackground)
					pixelRGBA(ds, this->coor->x + relx + x, this->coor->y + y, 0, 0, 0, 255);
			}
		
		relx += useData->width + 1;
	}

	if (this->shadeBorder)
	{
		lineRGBA(ds, this->coor->x - 1, this->coor->y - 1, this->coor->x + relx, this->coor->y - 1, 0, 0, 0, 127);
		lineRGBA(ds, this->coor->x - 1, this->coor->y, this->coor->x - 1, this->coor->y + this->font->height - 1, 0, 0, 0, 127);
		lineRGBA(ds, this->coor->x - 1, this->coor->y + this->font->height, this->coor->x + relx, this->coor->y + this->font->height, 0, 0, 0, 127);
		lineRGBA(ds, this->coor->x + relx, this->coor->y, this->coor->x + relx, this->coor->y + this->font->height - 1, 0, 0, 0, 127);
	}

}

void kuroi_String::updateValues()
{
	this->coor->w = this->getPixelLength();
	this->coor->h = this->font->height;
}

int kuroi_String::getPixelLength()
{
	int totalWidth = 0;
	
	for (int i = 0; i < (int)strlen(this->text); i++)
		totalWidth += this->font->characters[strlen(this->font->characterSet) - strlen(strchr(this->font->characterSet, (int)this->text[i]))].width + 1;
	
	return totalWidth;
}

kuroi_Container::kuroi_Container()
{
	this->objects = new XArray <kuroi_Object> ();
}

kuroi_Container::~kuroi_Container()
{
	delete this->objects;
}

void kuroi_Container::draw()
{
	for (int i = 0; i < this->objects->GetSize(); i++)
		if (this->objects->IndexUsed(i))
			this->objects->GetData(i)->draw();
			
}

kuroi_Window::kuroi_Window(SDL_Surface *drawingContext, int x, int y, int w, int h, int r, int g, int b, kuroi_String *title)
{
	this->drawTo = drawingContext;
	this->coor = new SDL_Rect();
	this->coor->x = x;
	this->coor->y = y;
	this->coor->w = w;
	this->coor->h = h;

	this->color = new SDL_Color();
	this->color->r = r;
	this->color->g = g;
	this->color->b = b;

	this->title = title;
	this->title->drawTo = this;

	this->borderSize = 10;
	this->components = new kuroi_Container();
}

kuroi_Window::~kuroi_Window()
{
	delete this->coor;
	delete this->color;
	delete this->components;
}

bool kuroi_Window::coordInside(int x, int y)
{
	int relx, rely;
	
	// Get the complements of the co-ordinates.
	relx = x - this->coor->x; rely = y - this->coor->y;
	
	if ((relx + rely) < this->borderSize)
		return false;
	if (((this->coor->w - relx) + (this->coor->h - rely)) < this->borderSize)
		return false;
	if ((relx + (this->coor->h - rely)) < this->borderSize)
		return false;
	if (((this->coor->w - relx) + rely) < this->borderSize)
		return false;

	return true;
}

void kuroi_Window::draw()
{
	int r = this->color->r, g = this->color->g, b = this->color->b;
	int x1, y1, x2, y2;

	/* Step 1: draw the box outline. */

	x1 = this->coor->x + this->borderSize; y1 = this->coor->y; x2 = this->coor->x + this->coor->w - this->borderSize; y2 = this->coor->y;
	lineRGBA((SDL_Surface *)this->drawTo, x1, y1, x2, y2, r, g, b, 255);

	x1 = x2; y1 = y2; x2 += this->borderSize; y2 += this->borderSize;
	lineRGBA((SDL_Surface *)this->drawTo, x1, y1, x2, y2, r, g, b, 255);

	x1 = x2; y1 = y2; y2 += this->coor->h - (2 * this->borderSize);
	lineRGBA((SDL_Surface *)this->drawTo, x1, y1, x2, y2, r, g, b, 255);

	x1 = x2; y1 = y2; x2 -= this->borderSize; y2 += this->borderSize;
	lineRGBA((SDL_Surface *)this->drawTo, x1, y1, x2, y2, r, g, b, 255);

	x1 = x2; y1 = y2; x2 -= this->coor->w - (2 * this->borderSize);
	lineRGBA((SDL_Surface *)this->drawTo, x1, y1, x2, y2, r, g, b, 255);
	
	x1 = x2; y1 = y2; x2 -= this->borderSize; y2 -= this->borderSize;
	lineRGBA((SDL_Surface *)this->drawTo, x1, y1, x2, y2, r, g, b, 255);

	x1 = x2; y1 = y2; y2 -= this->coor->h - (2 * this->borderSize);
	lineRGBA((SDL_Surface *)this->drawTo, x1, y1, x2, y2, r, g, b, 255);

	x1 = x2; y1 = y2; x2 += this->borderSize; y2 -= this->borderSize;
	lineRGBA((SDL_Surface *)this->drawTo, x1, y1, x2, y2, r, g, b, 255);

	/* Step 2: shade the inside of the box with neat ness.. */
	for (int y = this->coor->y; y < this->coor->h + this->coor->y; y++)
		for (int x = this->coor->x; x < this->coor->w + this->coor->x; x++)
			if (this->coordInside(x, y))
				pixelRGBA((SDL_Surface *)this->drawTo, x, y, r, g, b, 95);
	
	/* Step 3: draw title. */
	this->title->coor->x = this->coor->x + this->borderSize + 5;
	this->title->coor->y = this->coor->y - (this->title->font->height / 2);
	this->title->draw();

	/* Step 4: draw contained objects. */
	this->components->draw();
}

bool kuroi_Window::handleEvents(SDL_Event event)
{
	switch (event.type)
	{
		case SDL_KEYDOWN:
			if (!captureKeys)
				return false;

			break;

		case SDL_KEYUP:
			if (!captureKeys)
				return false;
			
			break;

		case SDL_MOUSEMOTION:
			if (!captureClicks)
				return false;

			if (dragging)
			{
				// Already dragging us around. Update the window co-ordinates.
				this->coor->x = event.motion.x - beginDragXO;
				this->coor->y = event.motion.y - beginDragYO;
			}

			break;
				

		case SDL_MOUSEBUTTONDOWN:
			if (!captureClicks)
				return false;

			if (event.button.button == SDL_BUTTON_LEFT)
			{
				// Left click - are we not dragging a window around already?
				
				if (!dragging)
				{
					// First, is the mouse within this window's title bar? If so, they're
					// probably going to move us.
			
					if ((event.button.x >= (this->coor->x + this->borderSize)) && (event.button.x <= (this->coor->x + this->coor->w - this->borderSize))
						&& (event.button.y >= (this->coor->y - (4 * this->title->font->height / 3))) && (event.button.y <= (this->coor->y + (4 * this->title->font->height / 3))))
					{
						dragging = true;
						beginDragX = event.button.x; beginDragXO = beginDragX - this->coor->x;
						beginDragY = event.button.y; beginDragYO = beginDragY - this->coor->y;
					}
				}
				// If we're dragging a window already.. that's impossible. ^_^ Ignore it kindly.
			}
			
			// Check all the objects this window owns, and see if we're in range.
			for (int i = 0; i < this->components->objects->GetSize(); i++)
				if (this->components->objects->IndexUsed(i))
				{
					// Calling updateObjects on this object should ensure that
					// we can rely on the size-values it exposes.
					kuroi_Object *refObj = this->components->objects->GetData(i);
					refObj->updateValues();
					SDL_Rect *refCoor = refObj->getCoor();

					// Test these values.
					if ((event.button.x >= (refCoor->x + this->coor->x)) && (event.button.x <= (refCoor->x + refCoor->w + this->coor->x))
						&& (event.button.y >= (refCoor->y + this->coor->y)) && (event.button.y <= (refCoor->y + refCoor->h + this->coor->y)))
					{
						int buttonsPressed = 0;
						if (event.button.button == SDL_BUTTON_LEFT)
							buttonsPressed = 1;
						else if (event.button.button == SDL_BUTTON_RIGHT)
							buttonsPressed = 2;
						else if (event.button.button == SDL_BUTTON_MIDDLE)
							buttonsPressed = 3;

						void (*onClickFunction)(kuroi_Object *, int, int, int) = refObj->onClick;

						onClickFunction(refObj, event.button.x, event.button.y, buttonsPressed);
					}
				}

			break;

		case SDL_MOUSEBUTTONUP:
			if (!captureClicks)
				return false;

			if (event.button.button == SDL_BUTTON_LEFT)
			{
				// LMB has been released.
	
				if (dragging)
				{
					// Stop dragging.
					dragging = false;
				}
			}

			break;
	}

	return false;
}

kuroi_PushButton::kuroi_PushButton(kuroi_Window *drawingContext, int x, int y, int w, int h, int r, int g, int b, kuroi_String *text)
{
	this->drawTo = drawingContext;
	this->coor = new SDL_Rect();
	this->coor->x = x;
	this->coor->y = y;
	this->coor->w = w;
	this->coor->h = h;
	
	fprintf(stderr, "dimensions are %dx%d at %d, %d.\n", this->coor->w, this->coor->h,
		this->coor->x, this->coor->y);

	this->color = new SDL_Color();
	this->color->r = r;
	this->color->g = g;
	this->color->b = b;

	this->text = text;
}

kuroi_PushButton::~kuroi_PushButton()
{
	delete this->coor;
	delete this->color;
}

void kuroi_PushButton::draw()
{
	kuroi_Window *rWin = (kuroi_Window *)this->drawTo;
	SDL_Surface *rDraw = (SDL_Surface *)rWin->drawTo;

	// WWWWWWB
	// W     B
	// WBBBBBB
	
	// Draw the background colour.
	boxRGBA(rDraw, rWin->coor->x + this->coor->x, rWin->coor->y + this->coor->y, rWin->coor->x + this->coor->x + this->coor->w, rWin->coor->y + this->coor->y + this->coor->h, this->color->r, this->color->g, this->color->b, 196);

	// Draw the top white line. (shy of the right co-or by 1px)
	lineRGBA(rDraw, rWin->coor->x + this->coor->x, rWin->coor->y + this->coor->y, rWin->coor->x + this->coor->x + this->coor->w - 1, rWin->coor->y + this->coor->y, 255, 255, 255, 196);
	
	// Draw the right black line. (fills in where the top white)
	lineRGBA(rDraw, rWin->coor->x + this->coor->x + this->coor->w, rWin->coor->y + this->coor->y, rWin->coor->x + this->coor->x + this->coor->w, rWin->coor->y + this->coor->y + this->coor->h, 0, 0, 0, 196);

	// Draw the bottom black line. (making sure not to overlap, so the alpha affect isn't ruined by _a single pixel_ - that would be horrific,
	// also compensate for the left white line)
	lineRGBA(rDraw, rWin->coor->x + this->coor->x + 1, rWin->coor->y + this->coor->y + this->coor->h, rWin->coor->x + this->coor->x + this->coor->w - 1, rWin->coor->y + this->coor->y + this->coor->h, 0, 0, 0, 196);

	// Draw the left white line. (don't overlap top)
	lineRGBA(rDraw, rWin->coor->x + this->coor->x, rWin->coor->y + this->coor->y + 1, rWin->coor->x + this->coor->x, rWin->coor->y + this->coor->y + this->coor->h, 255, 255, 255, 196);

	this->text->coor->x = rWin->coor->x + this->coor->x + (this->coor->w / 2) - (this->text->getPixelLength() / 2);
	this->text->coor->y = rWin->coor->y + this->coor->y + (this->coor->h / 2) - (this->text->font->height / 2);
	this->text->drawBackground = false;
	this->text->shadeBorder = false;
	this->text->draw();
}

kuroi_CheckBox::kuroi_CheckBox(kuroi_Window *drawingContext, int x, int y, int r, int g, int b, kuroi_String *text)
{
	this->drawTo = drawingContext;
	this->coor = new SDL_Rect();
	this->coor->x = x;
	this->coor->y = y;
	this->coor->w = 16;
	this->coor->h = 16;
	
	fprintf(stderr, "dimensions are at %d, %d.\n", this->coor->x, this->coor->y);

	this->color = new SDL_Color();
	this->color->r = r;
	this->color->g = g;
	this->color->b = b;

	this->text = text;
	this->checked = false;
}

kuroi_CheckBox::~kuroi_CheckBox()
{
	delete this->coor;
	delete this->color;
}

void kuroi_CheckBox::draw()
{
	kuroi_Window *rWin = (kuroi_Window *)this->drawTo;
	SDL_Surface *rDraw = (SDL_Surface *)rWin->drawTo;

	// Draw the box.
	rectangleRGBA(rDraw, rWin->coor->x + this->coor->x, rWin->coor->y + this->coor->y, rWin->coor->x + this->coor->x + this->coor->w, rWin->coor->y + this->coor->y + this->coor->h, this->color->r, this->color->g, this->color->b, 196);

	// Draw a cross, if applicable.
	if (this->checked)
	{
		int newr = this->color->r + 64, newg = this->color->g + 64, newb = this->color->b + 64;
		if (newr > 255) newr = 255;
		if (newg > 255) newg = 255;
		if (newb > 255) newb = 255;
		aalineRGBA(rDraw, rWin->coor->x + this->coor->x, rWin->coor->y + this->coor->y, rWin->coor->x + this->coor->x + this->coor->w, rWin->coor->y + this->coor->y + this->coor->h, newr, newg, newb, 196);
		aalineRGBA(rDraw, rWin->coor->x + this->coor->x, rWin->coor->y + this->coor->y + this->coor->h, rWin->coor->x + this->coor->x + this->coor->w, rWin->coor->y + this->coor->y, newr, newg, newb, 196);
	}
	
	this->text->coor->x = rWin->coor->x + this->coor->x + this->coor->w + 8;
	this->text->coor->y = rWin->coor->y + this->coor->y + (this->coor->h / 2) - (this->text->font->height / 2);
	this->text->drawBackground = false;
	this->text->shadeBorder = false;
	this->text->draw();
}

