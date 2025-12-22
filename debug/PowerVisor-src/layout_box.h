//===============================================//
// Layout manager classes                        //
// Box header file                               //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_BOX_H
#define LAYOUT_BOX_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

enum DirType
{
	DirectionLeft = 0,
	DirectionRight,
	DirectionTop,
	DirectionBottom
};

class Shell;

class box
{
	static int counter;
	int number;
	int x, y, w, h;

public:
	box (int l, int t, int ww, int hh) { D("box::box(_,_,_,_)", counter+1); number = ++counter; x = l; y = t; w = ww; h = hh; }
	box () { D("box::box()", counter+1); number = ++counter; x = y = w = h = 0; }
	box (const box& b)
	{
		D("box::box(_) Copy from", b.number, " to ", counter+1);
		number = ++counter; x = b.x; y = b.y; w = b.w; h = b.h;
	}
	virtual ~box () { D("box::~box", number); }

	box& setbox (int l, int t, int ww, int hh) { x = l; y = t; w = ww; h = hh; return *this; }
	box& setbox (box& b) { return setbox (b.left (), b.top (), b.width (), b.height ()); }
	void setleft (int l) { w += x-l; x = l; }
	void setright (int r) { w = r-x+1; }
	void settop (int t) { h += y-t; y = t; }
	void setbottom (int b) { h = b-y+1; }
	void setwidth (int ww) { w = ww; }
	void setheight (int hh) { h = hh; }
	void setpos (DirType dir, int p);
	void setspan (DirType dir, int p);
	int left () { return x; }
	int right () { return x+w-1; }
	int top () { return y; }
	int bottom () { return y+h-1; }
	int width () { return w; }
	int height () { return h; }
	int pos (DirType dir);
	int span (DirType dir);
	int isempty () { return w == 0 && h == 0; }
	box& show (Shell* shell);
	box& show ();
	box operator+ (box& b);
	box operator- (box& b);
	box& operator+= (box& b);
	box& operator-= (box& b);
	boolean operator== (box& b);
	boolean operator!= (box& b) { return !(*this == b); }
	boolean operator< (box& b);
	boolean operator> (box& b) { return *this < b; }
	boolean operator<= (box &b) { return *this < b || *this == b; }
	boolean operator>= (box &b) { return *this > b || *this == b; }
};

#endif
