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
#define	inc()   { w += dw; }
#define	fill(z) { *zBuffer++ = (unsigned short int)(z); }

staticfnc unsigned short int *draw_affine8flat(int n, unsigned short int *zBuffer, int w, int dw)
{
  while (n--) {
    fill(w);
    inc();
  }
  return zBuffer;
}
#endif

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
staticfnc void draw_spans8flat(int y, int ey)
{
#ifdef	USE_ZBUFFER
  vec1D prew = tmap[6] + y * tmap[8];
#endif

  for (; y < ey; y++) {
    int sx = scan[y][0];
    int len = scan[y][1] - sx;

    if (len > 0) {
      unsigned char *pBuffer = (unsigned char *)localDim.frameBuffer + multRows[y] + sx;

#ifdef	USE_ZBUFFER
      unsigned short int *zBuffer = localDim.zBuffer + multRows[y] + sx;
      vec1D w0;
      int w, dw;						/* 1/zbuffer */
      int slen;

      /* compute (u,v) at left end */
      w0 = 1 / (prew + sx * tmap[7]);				/* 1/zbuffer */

      w = FLOAT_TO_FIX(w0);					/* 1/zbuffer */

      for (slen = len >> SUBDIV_SHIFT; slen > 0; slen--) {
	sx += SUBDIV;
	w0 = 1 / (prew + sx * tmap[7]);

	dw = (FLOAT_TO_FIX(w0) - w) >> SUBDIV_SHIFT;		/* 1/zbuffer */

	zBuffer = draw_affine8flat(SUBDIV, zBuffer, w, dw);
	w = FLOAT_TO_FIX(w0);					/* 1/zbuffer */
      }

      if ((slen = (len & SUBDIV_MASK) - 1)) {			/* a) do not calc if only draw 1 pixel */
	vec1D w1;

	sx += slen;
	w1 = 1 / (prew + sx * tmap[7]);

	dw = FLOAT_TO_FIX((w1 - w0) / slen);			/* 1/zbuffer */
      }
      /* a) but draw that pixel surely */
      draw_affine8flat(slen + 1, zBuffer, w, dw);		/* for the last pixel the du and dv are thrown away */
#endif
      for (len = len - 1 - 1; len >= 0; len--)
	*pBuffer++ = textureColor;
    }

#ifdef	USE_ZBUFFER
    prew += tmap[8];
#endif
  }
}
