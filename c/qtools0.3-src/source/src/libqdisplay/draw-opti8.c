/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifdef	USE_ZBUFFER
#define	inc()        { u += du; v += dv; w += dw; }
#define	fill(pel, z) { *pBuffer++ = (pel); *zBuffer++ = (unsigned short int)(z); }
#else
#define	inc()        { u += du; v += dv; }
#define	fill(pel, z) { *pBuffer++ = (pel); }
#endif

#ifdef	USE_ZBUFFER
staticfnc unsigned char *draw_affine8(int n, unsigned char *pBuffer, unsigned short int *zBuffer, int u, int v, int w, int du, int dv, int dw)
#else
staticfnc unsigned char *draw_affine8(int n, unsigned char *pBuffer, int u, int v, int du, int dv)
#endif
{
  if (textureType == WALL_TYPE) {
    while (n--) {
      int iu = u >> 16;
      int iv = ((v >> (16 - MAX_LOGY)) & MAX_MASKX) + textureRow;

#ifdef CALCULATE_PIXELDRAW
      pixelDraw++;
      if (*pBuffer)
	pixelOverdraw++;
#endif

      fill(texture.indexed[multMuls[iv] + iu], w);
      inc();
    }
  }
  else if (textureType == SKY_TYPE) {
    /* TODO: skies */
    while (n--) {
      int iu;
      int iv;
      unsigned char pel, sum;

#ifdef CALCULATE_PIXELDRAW
      pixelDraw++;
      if (*pBuffer)
	pixelOverdraw++;
#endif

      iu = ((u >> 8) + skyMovementX1) & 0x00007F00;
      iv = ((v >> 16) + skyMovementY1) & 0x0000007F;
      sum = texture.indexed[iu + iv + 0x80];
      iu = ((u >> 8) + skyMovementX2) & 0x00007F00;
      iv = ((v >> 16) + skyMovementY2) & 0x0000007F;
      if ((pel = texture.indexed[iu + iv]))
	sum = pel;

      fill(sum, 0xFFFF);
      inc();
    }
  }
  else {
    while (n--) {
#ifndef	FAST_WARP
      int iv = ((v + (swim_v[((u >> textureShift2) & 0xff)] >> textureMip)) >> 16) & textureMask2;
      int iu = ((u + (swim_u[((v >> textureShift2) & 0xff)] >> textureMip)) >> textureShift1) & textureMask1;

#else
      int iv = ((v + swim_v[(u >> 16)]) >> 16) & textureMask2;
      int iu = ((u + swim_u[(v >> 16)]) >> textureShift1) & textureMask1;

#endif

      fill(pretransp(texture.indexed[iu + iv], *pBuffer), w);
      inc();
    }
  }
  return pBuffer;
}

/* given a span (x0,y)..(x1,y), draw a perspective-correct span for it */
/*
 * the zbuffer is interesting for dynamic model-draw etc.
 * the buffers values (1/z) are all under 0, we can try to
 * store them as 16bit-wide-fraction
 *
 * while(n--) {
 *   *zbuf++ = (unsigned short int)(w); / we need only the lower part /
 *   w += dw;
 * }
 *
 */
staticfnc void draw_spans8(int y, int ey)
{
  vec1D prew = tmap[6] + y * tmap[8];
  vec1D prev = tmap[3] + y * tmap[5];
  vec1D preu = tmap[0] + y * tmap[2];

  for (; y < ey; y++) {
    int sx = scan[y][0];
    int len = scan[y][1] - sx;

    if (len > 0) {
      vec1D w0;
      vec1D v0;
      vec1D u0;

#ifdef	USE_ZBUFFER
      int w, dw;						/* 1/zbuffer */

#endif
      int v, dv;
      int u, du;
      int slen;

      unsigned char *pBuffer = (unsigned char *)localDim.frameBuffer + multRows[y] + sx;

#ifdef	USE_ZBUFFER
      unsigned short int *zBuffer = localDim.zBuffer + multRows[y] + sx;

#endif

      /* compute (u,v) at left end */
      w0 = 1 / (prew + sx * tmap[7]);				/* 1/zbuffer */
      v0 = (prev + sx * tmap[4]) * w0;
      u0 = (preu + sx * tmap[1]) * w0;

#ifdef	USE_ZBUFFER
      w = FLOAT_TO_FIX(w0);					/* 1/zbuffer */
#endif
      v = FLOAT_TO_FIX(v0);
      u = FLOAT_TO_FIX(u0);

      for (slen = len >> SUBDIV_SHIFT; slen > 0; slen--) {
	sx += SUBDIV;
	w0 = 1 / (prew + sx * tmap[7]);
	v0 = (prev + sx * tmap[4]) * w0;
	u0 = (preu + sx * tmap[1]) * w0;

#ifdef	USE_ZBUFFER
	dw = (FLOAT_TO_FIX(w0) - w) >> SUBDIV_SHIFT;		/* 1/zbuffer */
#endif
	dv = (FLOAT_TO_FIX(v0) - v) >> SUBDIV_SHIFT;
	du = (FLOAT_TO_FIX(u0) - u) >> SUBDIV_SHIFT;

#ifdef	USE_ZBUFFER
	pBuffer = draw_affine8(SUBDIV, pBuffer, zBuffer, u, v, w, du, dv, dw);
	zBuffer += SUBDIV;
#else
	pBuffer = draw_affine8(SUBDIV, pBuffer, u, v, du, dv);
#endif

#ifdef	USE_ZBUFFER
	w = FLOAT_TO_FIX(w0);					/* 1/zbuffer */
#endif
	v = FLOAT_TO_FIX(v0);
	u = FLOAT_TO_FIX(u0);
      }

      if ((slen = (len & SUBDIV_MASK) - 1)) {			/* a) do not calc if only draw 1 pixel */
	vec1D w1;
	vec1D v1;
	vec1D u1;

	sx += slen;
	w1 = 1 / (prew + sx * tmap[7]);
	v1 = (prev + sx * tmap[4]) * w1;
	u1 = (preu + sx * tmap[1]) * w1;

#ifdef	USE_ZBUFFER
	dw = FLOAT_TO_FIX((w1 - w0) / slen);			/* 1/zbuffer */
#endif
	dv = FLOAT_TO_FIX((v1 - v0) / slen);
	du = FLOAT_TO_FIX((u1 - u0) / slen);
      }
      /* a) but draw that pixel surely */
#ifdef	USE_ZBUFFER
      draw_affine8(slen + 1, pBuffer, zBuffer, u, v, w, du, dv, dw);	/* for the last pixel the du and dv are thrown away */
#else
      draw_affine8(slen + 1, pBuffer, u, v, du, dv);		/* for the last pixel the du and dv are thrown away */
#endif
    }

    prew += tmap[8];
    prev += tmap[5];
    preu += tmap[2];
  }
}
