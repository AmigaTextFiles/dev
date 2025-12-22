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
staticfnc struct rgb *draw_affine24(int n, struct rgb *pBuffer, unsigned short int *zBuffer, int u, int v, int w, int du, int dv, int dw)
#else
staticfnc struct rgb *draw_affine24(int n, struct rgb *pBuffer, int u, int v, int du, int dv)
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

      fill(texture.truecolor[multMuls[iv] + iu], w);
      inc();
    }
  }
  else if (textureType == SKY_TYPE) {
    /* TODO: skies */
    while (n--) {
      int iu;
      int iv;
      struct rgb pel, sum;

#ifdef CALCULATE_PIXELDRAW
      pixelDraw++;
      if (*pBuffer)
	pixelOverdraw++;
#endif

      iu = ((u >> 8) + skyMovementX1) & 0x00007F00;
      iv = ((v >> 16) + skyMovementY1) & 0x0000007F;
      sum = texture.truecolor[iu + iv + 0x80];
      iu = ((u >> 8) + skyMovementX2) & 0x00007F00;
      iv = ((v >> 16) + skyMovementY2) & 0x0000007F;
      pel = texture.truecolor[iu + iv];
      if ((!pel.r) && (!pel.g) && (!pel.b))
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

      fill(texture.truecolor[iu + iv], w);
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
staticfnc void draw_spans24(int y, int sx, int ex)
{
  vec1D w0, w1;
  vec1D v0, v1;
  vec1D u0, u1;

#ifdef	USE_ZBUFFER
  int w, dw;							/* 1/zbuffer */
#endif
  int v, dv;
  int u, du;
  int slen, rlen, len, end;

  struct rgb *pBuffer = (struct rgb *)localDim.frameBuffer + multRows[y] + sx;

#ifdef	USE_ZBUFFER
  unsigned short int *zBuffer = localDim.zBuffer + multRows[y] + sx;
#endif
  vec1D prew = tmap[6] + y * tmap[8];
  vec1D prev = tmap[3] + y * tmap[5];
  vec1D preu = tmap[0] + y * tmap[2];

  /* compute (u,v) at left end */
  w0 = 1 / (prew + sx * tmap[7]);				/* 1/zbuffer */
  v0 = (prev + sx * tmap[4]) * w0;
  u0 = (preu + sx * tmap[1]) * w0;

  len = ex - sx;
  for (slen = len >> SUBDIV_SHIFT; slen > 0; slen--) {
#ifdef	USE_ZBUFFER
    w = FLOAT_TO_FIX(w0);					/* 1/zbuffer */
#endif
    v = FLOAT_TO_FIX(v0);
    u = FLOAT_TO_FIX(u0);

    end = sx + SUBDIV;
    w1 = 1 / (prew + end * tmap[7]);
    v1 = (prev + end * tmap[4]) * w1;
    u1 = (preu + end * tmap[1]) * w1;

#ifdef	USE_ZBUFFER
    dw = (FLOAT_TO_FIX(v1) - w) >> SUBDIV_SHIFT;		/* 1/zbuffer */
#endif
    dv = (FLOAT_TO_FIX(v1) - v) >> SUBDIV_SHIFT;
    du = (FLOAT_TO_FIX(u1) - u) >> SUBDIV_SHIFT;

#ifdef	USE_ZBUFFER
    pBuffer = draw_affine24(SUBDIV, pBuffer, zBuffer, u, v, w, du, dv, dw);
    zBuffer += SUBDIV;
#else
    pBuffer = draw_affine24(SUBDIV, pBuffer, u, v, du, dv);
#endif
    sx = end;

#ifdef	USE_ZBUFFER
    w0 = w1;							/* 1/zbuffer */
#endif
    v0 = v1;
    u0 = u1;
  }

#ifdef	USE_ZBUFFER
  w = FLOAT_TO_FIX(w0);						/* 1/zbuffer */
#endif
  v = FLOAT_TO_FIX(v0);
  u = FLOAT_TO_FIX(u0);
  if ((rlen = (len & SUBDIV_MASK) - 1)) {			/* a) do not calc if only draw 1 pixel */
    end = sx + rlen;
    w1 = 1 / (prew + end * tmap[7]);
    v1 = (prev + end * tmap[4]) * w1;
    u1 = (preu + end * tmap[1]) * w1;

#ifdef	USE_ZBUFFER
    dw = FLOAT_TO_FIX((w1 - w0) / rlen);			/* 1/zbuffer */
#endif
    dv = FLOAT_TO_FIX((v1 - v0) / rlen);
    du = FLOAT_TO_FIX((u1 - u0) / rlen);
  }
  /* a) but draw that pixel surely */
#ifdef	USE_ZBUFFER
  draw_affine24(rlen + 1, pBuffer, zBuffer, u, v, w, du, dv, dw);	/* for the last pixel the du and dv are thrown away */
#else
  draw_affine24(rlen + 1, pBuffer, u, v, du, dv);		/* for the last pixel the du and dv are thrown away */
#endif
}
