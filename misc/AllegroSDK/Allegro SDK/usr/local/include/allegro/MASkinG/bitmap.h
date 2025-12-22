// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_BITMAP_H
#define			MASKING_BITMAP_H

#include <allegro.h>
#include "color.h"
#include "rect.h"
#include "error.h"
#include "maskingdll.h"

namespace MAS {
/**
	A wrapper for the Allegro BITMAP structure.
	It has all the blitting, sprite drawing and primitive drawing functions,
	copy constructors, overloaded assignment operators and a few special GUI
	drawing functions (like drawing a pseudo 3D rectangle for example). At the
	time I wrote this class I thought it was a good idea to have wrappers for
	all the Allegro structures but I have since changed my mind. This class
	however is almost complete (some functions are missing though) and as far
	as I know it works and since I used it throughout the rest of the library
	I decided to keep it in anyway. I suggest you keep using the drawing and
	bitmap manipulation functions Allegro provides instead of learning the
	interface of this class though, but there's no harm using this class so
	if you want take a look at the actual header:
	\URL[bitmap.h]{"../../include/MASkinG/bitmap.h"}
*/
class MASKING_DLL_DECLSPEC Bitmap {
	public:
		// subtype of the bitmap
		enum Type {
			MEMORY,		// normal memory bitmap
			SYSTEM,		// system bitmap
			VIDEO,		// video bitmap
			UNDEFINED
		};

	protected:
		BITMAP *data;		// the actual bitmap data
		Type type;
		bool allocated;		// did we allocate the data or did we just make a pointer?
		Size thick;			// size of the central area (for tiled blit)

	public:
		// ctors & dtor
		Bitmap();
		Bitmap(int w, int h, Type t = MEMORY);
		Bitmap(const Size& s, Type t = MEMORY);
		Bitmap(const char *file, Type t = MEMORY);
		Bitmap(BITMAP *src);
		Bitmap(const Bitmap &src);
		virtual ~Bitmap();

		// some handy overloaded operators and other functions
		//operator bool() const;					// does bitmap data exist?
		//bool operator!() const { return data?false:true; }
		operator BITMAP*() const;
		Bitmap& operator=(BITMAP *bmp);			// assignment from Allegro bitmap: makes a pointer!
		Bitmap& operator=(const Bitmap &bmp);	// assignment from another bitmap: makes a copy!
		virtual Bitmap& Set(BITMAP *bmp, bool copy=false, Type=UNDEFINED);
		virtual Bitmap& Set(const Bitmap &bmp, bool copy=false, Type=UNDEFINED);
		virtual int ThickX() const { return thick.w(); }
		virtual int ThickY() const { return thick.h(); }
		virtual const Size& Thick() const { return thick; }
		virtual void ThickX(int x) { thick.w(x); }
		virtual void ThickY(int y) { thick.h(y); }
		virtual void Thick(const Size &s) { thick = s; }

		// loading and saving functions
		virtual Error Load(const char *file, Type t = MEMORY);
		virtual void Save(const char *file);

		// basic bitmap manipulation functions
		Bitmap&		Create(const Size &s, Type t = MEMORY) { return Create(s.w(), s.h(), t); }
		Bitmap&		Create(int w, int h, Type t = MEMORY);
		Bitmap&		CreateEx(int bpp, const Size &s) { return CreateEx(bpp, s.w(), s.h()); }
		Bitmap&		CreateEx(int bpp, int w, int h);
		Bitmap&		CreateSubBitmap(const Bitmap &parent, const Rect &r) { return CreateSubBitmap(parent, r.x(), r.y(), r.w(), r.h()); }
		Bitmap&		CreateSubBitmap(const Bitmap &parent, int x, int y, int w, int h);
		void		Destroy();
		int	w()		const { return data->w; }
		int	h()		const { return data->h; }
		Size	size()		const { return Size(data->w, data->h); }
		void	Acquire()	const { acquire_bitmap(data); }
		void	Release()	const { release_bitmap(data); }
		int	ColorDepth()	const { return bitmap_color_depth(data); }
		bool	IsLinear()	const { return is_linear_bitmap(data)?true:false; }
		bool	IsPlanar()	const { return is_planar_bitmap(data)?true:false; }
		bool	IsSame(const Bitmap &bmp) const { return is_same_bitmap(data, bmp.data)?true:false; }
		bool	operator==(const Bitmap &bmp) const { return IsSame(bmp); }
		bool	IsScreen()	const { return is_screen_bitmap(data)?true:false; }
		bool	IsMemory()	const { return is_memory_bitmap(data)?true:false; }
		bool	IsSubBitmap()	const { return is_sub_bitmap(data)?true:false; }
		bool	IsSystem()	const { return is_system_bitmap(data)?true:false; }
		bool	IsVideo()	const { return is_video_bitmap(data)?true:false; }
		void	SetClip(const Rect &r)	{ SetClip(r.x(), r.y(), r.x2(), r.y2()); }
#if (ALLEGRO_VERSION >= 4 && ((ALLEGRO_SUB_VERSION == 1 && ALLEGRO_WIP_VERSION >= 13) || ALLEGRO_SUB_VERSION >= 2))
		void	SetClip(int x1, int y1, int x2, int y2)	{ set_clip_rect(data, x1,y1,x2,y2); }
#else
		void	SetClip(int x1, int y1, int x2, int y2)	{ set_clip(data, x1,y1,x2,y2); }
#endif
		Rect	GetClip()	const { return Rect(data->cl, data->ct, data->cr - data->cl, data->cb - data->ct); }
		void Show() const { show_video_bitmap(data); }

		// drawing primitives
		void	Putpixel(const Point &p, const Color &c) {	Putpixel(p.x(), p.y(), c); }
		Color	Getpixel(const Point &p) const { return Getpixel(p.x(), p.y()); }
		void	Vline(const Point &p, int y2, const Color &c) {	Vline(p.x(), p.y(), y2, c); }
		void	Hline(const Point &p, int x2, const Color &c) {	Hline(p.x(), p.y(), x2, c); }
		void	Line(const Point &p1, const Point &p2, const Color &c) { Line(p1.x(), p1.y(), p2.x(), p2.y(), c); }
		void	Triangle(const Point &p1, const Point &p2, const Point &p3, const Color &c) { triangle(data, p1.x(), p1.y(), p2.x(), p2.y(), p3.x(), p3.y(), c); }
		void	Rectangle(const Rect &r, const Color &c) {	Rectangle(r.x(), r.y(), r.x2(), r.y2(), c); }
		void	Rectfill(const Rect &r, const Color &c) {	Rectfill(r.x(), r.y(), r.x2(), r.y2(), c); }
		void	Circle(const Point &p, int r, const Color &c) {	Circle(p.x(), p.y(), r, c); }
		void	Circlefill(const Point &p, int r, const Color &c) {	Circlefill(p.x(), p.y(), r, c); }
		void	Ellipse(const Point &p, const Size &s, const Color &c) { ellipse(data, p.x(), p.y(), s.w(), s.h(), c); }
		void	Ellipsefill(const Point &p, const Size &s, const Color &c) { ellipsefill(data, p.x(), p.y(), s.w(), s.h(), c); }
		void	Arc(const Point &p, fixed a1, fixed a2, int r, const Color &c) { arc(data, p.x(), p.y(), a1, a2, r, c); }
		void	Spline(const int points[8], const Color &c) { spline(data, points, c); }
		void	Floodfill(const Point &p, const Color &c) { floodfill(data, p.x(), p.y(), c); }

		void	Putpixel(int x, int y, int c) { putpixel(data, x, y, c); }
		int		Getpixel(int x, int y) const { return getpixel(data, x, y); }
		void	Vline(int x, int y1, int y2, int c) { vline(data, x, y1, y2, c); }
		void	Hline(int x1, int y, int x2, int c) { hline(data, x1, y, x2, c); }
		void	Line(int x1, int y1, int x2, int y2, int c) { line(data, x1, y1, x2, y2, c); }
		void	Triangle(int x1, int y1, int x2, int y2, int x3, int y3, int c) { triangle(data, x1, y1, x2, y2, x3, y3, c); }
		void	Rectangle(int x1, int y1, int x2, int y2, int c) { rect(data, x1, y1, x2, y2, c); }
		void	Rectfill(int x1, int y1, int x2, int y2, int c) { rectfill(data, x1, y1, x2, y2, c); }
		void	Circle(int x, int y, int r, int c) { circle(data, x, y, r, c); }
		void	Circlefill(int x, int y, int r, int c) { circlefill(data, x, y, r, c); }
		void	Ellipse(int x, int y, int rx, int ry, int c) { ellipse(data, x, y, rx, ry, c); }
		void	Ellipsefill(int x, int y, int rx, int ry, int c) { ellipsefill(data, x, y, rx, ry, c); }
		void	Arc(int x, int y, fixed a1, fixed a2, int r, int c) { arc(data, x, y, a1, a2, r, c); }
		void	Floodfill(int x, int y, int c) { floodfill(data, x, y, c); }

		// blitting functions
		void	Clear() { clear_bitmap(data); }
		void	Clear(const Color &c) { clear_to_color(data, c); }
		void	Blit(Bitmap &dest, const Point &pSrc, const Point &pDest, const Size &s) const { blit(data, dest, pSrc.x(), pSrc.y(), pDest.x(), pDest.y(), s.w(), s.h()); }
		void	MaskedBlit(Bitmap &dest, const Point &pSrc, const Point &pDest, const Size &s) const { masked_blit(data, dest, pSrc.x(), pSrc.y(), pDest.x(), pDest.y(), s.w(), s.h()); }
		void	StretchBlit(Bitmap &dest, const Rect &rSrc, const Rect &rDest) const { stretch_blit(data, dest, rSrc.x(), rSrc.y(), rSrc.w(), rSrc.h(), rDest.x(), rDest.y(), rDest.w(), rDest.h()); }
		void	MaskedStretchBlit(Bitmap &dest, const Rect &rSrc, const Rect &rDest) const { masked_stretch_blit(data, dest, rSrc.x(), rSrc.y(), rSrc.w(), rSrc.h(), rDest.x(), rDest.y(), rDest.w(), rDest.h()); }

		void	Blit(Bitmap &dest, int sx, int sy, int dx, int dy, int w, int h) { blit(data, dest, sx, sy, dx, dy, w, h); }
		void	MaskedBlit(Bitmap &dest, int sx, int sy, int dx, int dy, int w, int h) { masked_blit(data, dest, sx, sy, dx, dy, w, h); }
		void	StretchBlit(Bitmap &dest, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh) { stretch_blit(data, dest, sx, sy, sw, sh, dx, dy, dw, dh); }
		void	MaskedStretchBlit(Bitmap &dest, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh) { masked_stretch_blit(data, dest, sx, sy, sw, sh, dx, dy, dw, dh); }

		// sprite functions
		void	DrawSprite(const Bitmap &sprite, const Point &p) { draw_sprite(data, sprite.data, p.x(), p.y()); }
		void	DrawSpriteVFlip(const Bitmap &sprite, const Point &p) { draw_sprite_v_flip(data, sprite.data, p.x(), p.y()); }
		void	DrawSpriteHFlip(const Bitmap &sprite, const Point &p) { draw_sprite_h_flip(data, sprite.data, p.x(), p.y()); }
		void	DrawSpriteVHFlip(const Bitmap &sprite, const Point &p) { draw_sprite_vh_flip(data, sprite.data, p.x(), p.y()); }
		void	DrawTransSprite(const Bitmap &sprite, const Point &p) { draw_trans_sprite(data, sprite.data, p.x(), p.y()); }
		void	DrawLitSprite(const Bitmap &sprite, const Point &p, const Color &c) { draw_lit_sprite(data, sprite.data, p.x(), p.y(), c); }
		void	DrawGouraoudSprite(const Bitmap &sprite, const Point &p, const Color &c1, const Color &c2, const Color &c3, const Color &c4) { draw_gouraud_sprite(data, sprite.data, p.x(), p.y(), c1,c2,c3,c4); }
		void	RotateSprite(const Bitmap &sprite, const Point &p, fixed angle) { rotate_sprite(data, sprite.data, p.x(), p.y(), angle); }
		void	RotateSpriteVFlip(const Bitmap &sprite, const Point &p, fixed angle) { rotate_sprite_v_flip(data, sprite.data, p.x(), p.y(), angle); }
		void	RotateScaledSprite(const Bitmap &sprite, const Point &p, fixed angle, fixed scale) { rotate_scaled_sprite(data, sprite.data, p.x(), p.y(), angle, scale); }
		void	RotateScaledSpriteVFlip(const Bitmap &sprite, const Point &p, fixed angle, fixed scale) { rotate_scaled_sprite_v_flip(data, sprite.data, p.x(), p.y(), angle, scale); }
		void	PivotSprite(const Bitmap &sprite, const Point &p, const Point &cp, fixed angle) { pivot_sprite(data, sprite.data, p.x(), p.y(), cp.x(), cp.y(), angle); }
		void	PivotSpriteVFlip(const Bitmap &sprite, const Point &p, const Point &cp, fixed angle) { pivot_sprite_v_flip(data, sprite.data, p.x(), p.y(), cp.x(), cp.y(), angle); }
		void	PivotScaledSprite(const Bitmap &sprite, const Point &p, const Point &cp, fixed angle, fixed scale) { pivot_scaled_sprite(data, sprite.data, p.x(), p.y(), cp.x(), cp.y(), angle, scale); }
		void	PivotScaledSpriteVFlip(const Bitmap &sprite, const Point &p, const Point &cp, fixed angle, fixed scale) { pivot_scaled_sprite_v_flip(data, sprite.data, p.x(), p.y(), cp.x(), cp.y(), angle, scale); }
		void	StretchSprite(const Bitmap &sprite, const Rect &r) { stretch_sprite(data, sprite.data, r.x(), r.y(), r.w(), r.h()); }

		void	DrawSprite(const Bitmap &sprite, int x, int y) { draw_sprite(data, sprite.data, x, y); }
		void	DrawSpriteVFlip(const Bitmap &sprite, int x, int y) { draw_sprite_v_flip(data, sprite.data, x, y); }
		void	DrawSpriteHFlip(const Bitmap &sprite, int x, int y) { draw_sprite_h_flip(data, sprite.data, x, y); }
		void	DrawSpriteVHFlip(const Bitmap &sprite, int x, int y) { draw_sprite_vh_flip(data, sprite.data, x, y); }
		void	DrawTransSprite(const Bitmap &sprite, int x, int y) { draw_trans_sprite(data, sprite.data, x, y); }
		void	DrawLitSprite(const Bitmap &sprite, int x, int y, int c) { draw_lit_sprite(data, sprite.data, x, y, c); }
		void	DrawGouraoudSprite(const Bitmap &sprite, int x, int y, int c1, int c2, int c3, int c4) { draw_gouraud_sprite(data, sprite.data, x, y, c1,c2,c3,c4); }
		void	RotateSprite(const Bitmap &sprite, int x, int y, fixed angle) { rotate_sprite(data, sprite.data, x, y, angle); }
		void	RotateSpriteVFlip(const Bitmap &sprite, int x, int y, fixed angle) { rotate_sprite_v_flip(data, sprite.data, x, y, angle); }
		void	RotateScaledSprite(const Bitmap &sprite, int x, int y, fixed angle, fixed scale) { rotate_scaled_sprite(data, sprite.data, x, y, angle, scale); }
		void	RotateScaledSpriteVFlip(const Bitmap &sprite, int x, int y, fixed angle, fixed scale) { rotate_scaled_sprite_v_flip(data, sprite.data, x, y, angle, scale); }
		void	PivotSprite(const Bitmap &sprite, int x, int y, int cx, int cy, fixed angle) { pivot_sprite(data, sprite.data, x, y, cx, cy, angle); }
		void	PivotSpriteVFlip(const Bitmap &sprite, int x, int y, int cx, int cy, fixed angle) { pivot_sprite_v_flip(data, sprite.data, x, y, cx, cy, angle); }
		void	PivotScaledSprite(const Bitmap &sprite, int x, int y, int cx, int cy, fixed angle, fixed scale) { pivot_scaled_sprite(data, sprite.data, x, y, cx, cy, angle, scale); }
		void	PivotScaledSpriteVFlip(const Bitmap &sprite, int x, int y, int cx, int cy, fixed angle, fixed scale) { pivot_scaled_sprite_v_flip(data, sprite.data, x, y, cx, cy, angle, scale); }
		void	StretchSprite(const Bitmap &sprite, int x, int y, int w, int h) { stretch_sprite(data, sprite.data, x, y, w, h); }

		// special drawing functions
		void	DrawDottedRect(const Rect &r, const Color &c) { DrawDottedRect(r.x(), r.y(), r.x2(), r.y2(), c); }
		void	Draw3DFrame(const Rect &r, const Color &c1, const Color &c2, const Color &c3) { Draw3DFrame(r.x(), r.y(), r.x2(), r.y2(), c1, c2, c3); }
		void	Draw3DCircle(const Point &centre, int r, const Color &c1, const Color &c2, const Color &c3) { Draw3DCircle(centre.x(), centre.y(), r, c1, c2, c3); }
		void	DrawXMark(const Point &centre, int size, const Color &col) { DrawXMark(centre.x(), centre.y(), size, col); }
		void	DrawCheckMark(const Point &origin, const Color &col) { DrawCheckMark(origin.x(), origin.y(), col); }
		void	DrawArrow(const Point &origin, const Color &col, int dir) { DrawArrow(origin.x(), origin.y(), col, dir); }

		void	DrawDottedRect(int x1, int y1, int x2, int y2, int c);
		void	Draw3DFrame(int x1, int y1, int x2, int y2, int c1, int c2, int c3);
		void	Draw3DCircle(int x, int y, int r, int c1, int c2, int c3);
		void	DrawXMark(int x, int y, int size, int col);
		void	DrawCheckMark(int x, int y, int col);
		void	DrawArrow(int x, int y, int col, int dir);

		void TiledBlit(
			Bitmap &dest,	// destination
			int sx = 0,		// x offset of the source subbitmap
			int sy = 0,		// y offset of the source subbitmap
			int dx = 0,		// destination x
			int dy = 0,		// destination y
			int w = 0,		// blit width (0 ==> w=destination->w)
			int h = 0,		// blit height (0 ==> h=destination->h)
			int countx = 0,	// number of subbitmaps (horizontaly)
			int county = 0,	// number of subbitmaps (verticaly)
			bool mask = false
		);
		void MaskedTiledBlit(
			Bitmap &dest,	// destination
			int sx = 0,		// x offset of the source subbitmap
			int sy = 0,		// y offset of the source subbitmap
			int dx = 0,		// destination x
			int dy = 0,		// destination y
			int w = 0,		// blit width (0 ==> w=destination->w)
			int h = 0,		// blit height (0 ==> h=destination->h)
			int countx = 0,	// number of subbitmaps (horizontaly)
			int county = 0	// number of subbitmaps (verticaly)
		);
		void HorizontalTile(Bitmap &dest, int i, int x, int y, int w, int count, bool mask=false);
		void VerticalTile(Bitmap &dest, int i, int x, int y, int h, int count, bool mask=false);
		void MaskedHorizontalTile(Bitmap &dest, int i, int x, int y, int w, int count);
		void MaskedVerticalTile(Bitmap &dest, int i, int x, int y, int h, int count);

		static Bitmap null;
};
}

#endif			//MASKING_BITMAP_H
