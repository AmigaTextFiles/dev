
/* 
**	tek/examples/dino.c
**
**	3d softrendering test
*/


#include <math.h>
#include <stdio.h>
#include <tek/mem.h>
#include <tek/visual.h>
#include <tek/array.h>

#include "dino.h"

#define PI 3.14159265358979323846

#define FRAMERATE		30


#define OBJSOURCE		dinoobject

#define	WINSIZE			240

#define	VRX 			0.011		/* initial X angle velocity */
#define	VRY				0.015		/* initial Y angle velocity */
#define	VRZ 			0.007		/* initial Z angle velocity */

#define	LVRX			0.038
#define	LVRY			0.027
#define	LVRZ			0.011

#define	DIST			4500		/* initial object distance */
#define	LIGHTSTEPS		210			/* number of shading steps */
#define	LIGHTDISTANCE	3000		/* lightsource distance */
#define	SPECULARITY		1500		/* light normal multiplicator */
#define	LIGHTMIN		2000		/* maximum brightness at this distance */
#define	LIGHTMAX		4000		/* minimum brightness at this distance */


typedef struct
{
	THNDL handle;
	TAPTR buffer;
	TVISUAL *visual;
	TINT width;
	TINT height;
	TVPEN pen[2];
	
} window;


struct polynode
{
	struct polynode *next;
	TINT *poly;
	TFLOAT vecprod;
	TINT8 turnindex;
	TINT8 reserved1;
	TINT8 reserved2;
	TINT8 reserved3;
};

typedef struct
{
	THNDL handle;

	TUINT numvertex;
	TUINT numpoly;
	TUINT numcat;
	TFLOAT *array3d;
	TFLOAT *array2d;
	TINT *polys;
	TINT **parray;
	struct polynode **categories;
	TAPTR pbuffer;
	TUINT *texture;
	TFLOAT *texcoords;
	TFLOAT *lightarray;
	TFLOAT *normalarray;
	TUINT texheight;
	TUINT texwidthb;
	TFLOAT distance;
	TFLOAT rx;
	TFLOAT ry;
	TFLOAT rz;
	TFLOAT vrx;
	TFLOAT vry;
	TFLOAT vrz;
	TFLOAT lx;
	TFLOAT ly;
	TFLOAT lz;
	TFLOAT ltx;
	TFLOAT lty;
	TFLOAT ltz;
	TFLOAT lrx;
	TFLOAT lry;
	TFLOAT lrz;
	TFLOAT lvrx;
	TFLOAT lvry;
	TFLOAT lvrz;
} object;




TUINT deletewindow(window *win, TTAGITEM *tags)
{
	TVFreePen(win->visual, win->pen[0]);
	TVFreePen(win->visual, win->pen[1]);
	TDestroy(win->visual);
	TMMUFree(win->handle.mmu, win->buffer);
	TMMUFreeHandle(win);
	return 0;
}


window *createwindow(TAPTR mmu, TAPTR basetask)
{
	window *win;
	
	win = TMMUAllocHandle0(mmu, (TDESTROYFUNC) deletewindow, sizeof(window));
	if (win)
	{
		TTAGITEM tags[4];

		win->width = WINSIZE;
		win->height = WINSIZE;

		TInitTags(tags);
		TAddTag(tags, TVisual_Title, "dino");
		TAddTag(tags, TVisual_PixWidth, win->width);
		TAddTag(tags, TVisual_PixHeight, win->height);

		win->visual = TCreateVisual(basetask, tags);
	

		if (win->visual)
		{
			win->pen[0] = TVAllocPen(win->visual, 0x000000);
			win->pen[1] = TVAllocPen(win->visual, 0xffffff);

			TVSetInput(win->visual, TITYPE_NONE, TITYPE_VISUAL_CLOSE | TITYPE_KEY | TITYPE_VISUAL_NEWSIZE);
			return win;
		}
		
		TDestroy(win);
	}

	return TNULL;
}



void rotrans(TFLOAT *a3p, TFLOAT *a2p, TFLOAT rx, TFLOAT ry, TFLOAT rz, TFLOAT dist, TINT count)
{
	TFLOAT pre1,pre2,pre3,pre4,pre5,pre6,pre7,pre8,pre9;
	TFLOAT x,y,z,z2,zf;
	
	double sx,sy,sz,cx,cy,cz;
	double t1, t2;
	
	t1 = (double) rx;
	sx = sin(t1);
	cx = cos(t1);

	t1 = (double) ry;
	sy = sin(t1);
	cy = cos(t1);

	t1 = (double) rz;
	sz = sin(t1);
	cz = cos(t1);

	t1 = sx * sy;
	t2 = cx * sy;
	
	pre1 = (TFLOAT) (cy*cz);
	pre2 = (TFLOAT) (t1*cz+cx*sz);
	pre3 = (TFLOAT) (t2*cz-sx*sz);
	pre4 = (TFLOAT) (cy*sz);
	pre5 = (TFLOAT) (t1*sz-cx*cz);
	pre6 = (TFLOAT) (t2*sz+sx*cz);
	pre7 = (TFLOAT) (sx*cy);
	pre8 = (TFLOAT) (cx*cy);
	pre9 = (TFLOAT) sy;

	dist += 256;
	
	while (--count >= 0)
	{
		x = *a3p++;
		y = *a3p++;
		z = *a3p++;
		
		z2 = x*pre9-y*pre7+z*pre8;
		zf = 1024.0/(z2+dist);
		*a2p++ = zf*(x*pre1+y*pre2-z*pre3);
		*a2p++ = zf*(x*pre4+y*pre5-z*pre6);
		*a2p = z2;
		a2p += 2;
	}
}




void rotate(TFLOAT *a3p1, TFLOAT *a3p2, TFLOAT rx, TFLOAT ry, TFLOAT rz, TINT count)
{
	TFLOAT pre1,pre2,pre3,pre4,pre5,pre6,pre7,pre8,pre9;
	TFLOAT x,y,z;
	
	double sx,sy,sz,cx,cy,cz;
	double t1, t2;
	
	t1 = (double) rx;
	sx = sin(t1);
	cx = cos(t1);

	t1 = (double) ry;
	sy = sin(t1);
	cy = cos(t1);

	t1 = (double) rz;
	sz = sin(t1);
	cz = cos(t1);

	t1 = sx * sy;
	t2 = cx * sy;
	
	pre1 = (TFLOAT) (cy*cz);
	pre2 = (TFLOAT) (t1*cz+cx*sz);
	pre3 = (TFLOAT) (t2*cz-sx*sz);
	pre4 = (TFLOAT) (cy*sz);
	pre5 = (TFLOAT) (t1*sz-cx*cz);
	pre6 = (TFLOAT) (t2*sz+sx*cz);
	pre7 = (TFLOAT) (sx*cy);
	pre8 = (TFLOAT) (cx*cy);
	pre9 = (TFLOAT) sy;

	do
	{
		x = *a3p1++;
		y = *a3p1++;
		z = *a3p1++;
		
		*a3p2++ = x*pre1+y*pre2-z*pre3;
		*a3p2++ = x*pre4+y*pre5-z*pre6;
		*a3p2++ = x*pre9-y*pre7+z*pre8;

	} while (--count > 0);
}




struct polynode *facesort(TINT **parray, TFLOAT *vxarray, struct polynode **dest, struct polynode *buffer, TINT numpoly, TINT numcat, TFLOAT zmin, TFLOAT zmax)
{
	TFLOAT scale = ((TFLOAT) (numcat - 1)) / (zmax - zmin);
	TFLOAT x1,y1,x2,y2,x3,y3,vecprod,z;
	TINT *polyp;
	TINT flags, numvertex, index1, index2, index3;
	struct polynode **destp;

	do
	{
		polyp = *parray++;	
		flags = polyp[1];
		if (flags == 0) continue;
		
		numvertex = polyp[0];

		index1 = polyp[3]<<2;
		index2 = polyp[(numvertex>>1)+3]<<2;
			
		z = (vxarray[index1+2]+vxarray[index2+2])/2;
		
		index3 = polyp[numvertex+2]<<2;
		
		x1 = vxarray[index1];
		y1 = vxarray[index1+1];
		x2 = vxarray[index2];
		y2 = vxarray[index2+1];
		x3 = vxarray[index3];
		y3 = vxarray[index3+1];

		vecprod = (x2-x1)*(y3-y1)-(x3-x1)*(y2-y1);
		
		if (vecprod < 0)
		{
			if (!(flags & 1)) continue;
			buffer->turnindex = -1;
		}
		else
		{
			if (!(flags & 2)) continue;
			buffer->turnindex = 1;
		}

		destp = dest + (TINT) ((z-zmin)*scale);
		buffer->next = *destp;
		*destp = buffer;
		buffer->poly = polyp;
		buffer->vecprod = vecprod;
		buffer++;

	} while (--numpoly > 0);

	return buffer;
}



void drawpolygt(TUINT *buf, TINT *poly, TFLOAT *array2d, TUINT *texture, TFLOAT *texcoords, TINT width, TINT height, TINT turnindex, TINT texturewidthb, TFLOAT lmin, TFLOAT lscale)
{
	TINT numv, upperindex, index, lowery, uppery, j, k;
	TINT bordertableft[10], bordertabright[10];
	TINT *bpl, *bpr, *scrp;
	TINT y, indexleft, indexright, ycountleft, ycountright;
	TFLOAT sll, stxl, styl, aktleftx, slr, stxr, styr, aktrightx, f;
	TFLOAT dll, dtxl, dtyl, deltaxleft, dlr, dtxr, dtyr, deltaxright;
	
	numv = *poly;
	poly += 3;
	
	upperindex = 0;
	index = *poly;
	lowery = uppery = (TINT) array2d[(index<<2)+1];
	j = 1;

	do
	{
		index = poly[j];
		y = (TINT) array2d[(index<<2)+1];
		if (y < uppery)
		{
			upperindex = j;
			uppery = y;
		}
		if (y > lowery)
		{
			lowery = y;
		}
	} while (++j < numv);
		
		
	if (uppery >= lowery) return;
	
 	bpl = bordertableft;
 	k = 2;

	for(;;)
	{
		index = upperindex;

		for(;;)
		{		
			j = index - turnindex;
			if (j == numv)
			{
				j = 0;
			}
			else if (j < 0)
			{
				j = numv - 1;
			}
	
			if ((TINT) array2d[(poly[j]<<2)+1] != uppery)
			{
				break;
			}

			index = j;
		}
		
		while ((TINT) array2d[(poly[index]<<2)+1] < lowery)
		{
			*bpl++ = poly[index];
			index -= turnindex;
			if (index == numv)
			{
				index = 0;
			}
			else if (index < 0)
			{
				index = numv-1;
			}
		}
		
		*bpl = poly[index];
		
		if (--k == 0) break;
		
		bpl = bordertabright;
		turnindex = -turnindex;
	}		


	uppery += height >> 1;
	lowery += height >> 1;
	buf += uppery*width;

	
	bpl = bordertableft;
	bpr = bordertabright;
	
	indexleft = *bpl;
	indexright = *bpr;

	ycountleft = 0;
	ycountright = 0;	

	y = uppery;


	do
	{
		if (ycountleft == 0)
		{
			sll = (array2d[(indexleft<<2)+3]-lmin)*lscale;
			stxl = texcoords[indexleft<<1];
			styl = texcoords[(indexleft<<1)+1];
			aktleftx = array2d[indexleft<<2];
			ycountleft = - (TINT) array2d[(indexleft<<2)+1];
			indexleft = *(++bpl);
			ycountleft += (TINT) array2d[(indexleft<<2)+1];
			f = 1.0 / (TFLOAT) ycountleft;
			dll = ((array2d[(indexleft<<2)+3]-lmin)*lscale-sll)*f;
			dtxl = (texcoords[indexleft<<1]-stxl)*f;
			dtyl = (texcoords[(indexleft<<1)+1]-styl)*f;
			deltaxleft = (array2d[indexleft<<2]-aktleftx)*f;
		}

		if (ycountright == 0)
		{
			slr = (array2d[(indexright<<2)+3]-lmin)*lscale;
			stxr = texcoords[indexright<<1];
			styr = texcoords[(indexright<<1)+1];
			aktrightx = array2d[indexright<<2];
			ycountright = - (TINT) array2d[(indexright<<2)+1];
			indexright = *(++bpr);
			ycountright += (TINT) array2d[(indexright<<2)+1];
			f = 1.0 / (TFLOAT) ycountright;
			dlr = ((array2d[(indexright<<2)+3]-lmin)*lscale-slr)*f;
			dtxr = (texcoords[indexright<<1]-stxr)*f;
			dtyr = (texcoords[(indexright<<1)+1]-styr)*f;
			deltaxright = (array2d[indexright<<2]-aktrightx)*f;
		}


		if (y >= 0)
		{
			TINT x0, x1, w;

			if (y >= height) return;

			x0 = (TINT) aktleftx;
			x1 = (TINT) aktrightx;
			w = x1 - x0;
			
			if (w > 0)
			{
				TINT stx,sty,sl,dtx,dty,dl,ll,pix;

				stx = (TINT) (stxl * 65536.0);
				sty = (TINT) (styl * 65536.0);
				sl = (TINT) (sll * 65536.0);
				f = 65536.0 / (TFLOAT) w;
				dtx = (TINT) ((stxr-stxl)*f);
				dty = (TINT) ((styr-styl)*f);
				dl = (TINT) ((slr-sll)*f);
				
				x0 += width >> 1;
				x1 += width >> 1;

				if (x0 < 0)
				{
					stx -= x0*dtx;
					sty -= x0*dty;
					sl -= x0*dl;
					w += x0;
					x0 = 0;
				}
				if (x1 >= width)
				{
					w -= x1-width+1;
				}

				if (w > 0)
				{
					scrp = buf+x0;

					do
					{
						pix = texture[(stx>>16)+((sty>>16)<<texturewidthb)];

						if (sl >= 0)
						{
							x0 = pix;
							ll = sl>>16;
							pix = (x0 & 0xff)-ll;
							if (pix < 0) pix = 0;
							x1 = ((x0>>8) & 0xff)-ll;
							if (x1 > 0) pix |= x1<<8;
							x1 = ((x0>>16) & 0xff)-ll;
							if (x1 > 0) pix |= x1<<16;
						}
				
						*scrp++ = pix;
						
						stx += dtx;
						sty += dty;
						sl += dl;

					} while	(--w >= 0);	
				}
			}
		}

		aktleftx += deltaxleft;
		aktrightx += deltaxright;
		stxl += dtxl;
		styl += dtyl;
		stxr += dtxr;
		styr += dtyr;
		sll += dll;
		slr += dlr;
		
		ycountleft--;
		ycountright--;
		buf += width;

	} while (++y < lowery);

}






/*****************************************************************************

	calcnormals(array3d,parray,normalarray,numpoints,numpoly)
	
*****************************************************************************/

void calcnormals(TFLOAT *array3d, TINT **parray, TFLOAT *normalarray, TUINT numpoints, TUINT numpoly)
{
	TINT i, j, index;
	TINT *poly;
	TUINT numvertex;
	TFLOAT x1,y1,z1, x2,y2,z2, x3,y3,z3, xn,yn,zn;
	TDOUBLE norm;
	TFLOAT n;


	/*	clear normals array. */
	
	for (i = 0; i < numpoints*3; ++i)
	{
		normalarray[i] = 0;
	}

	
	/*	calc polygon normals. */

	for (i = 0; i < numpoly; ++i)
	{
		poly = parray[i];
		
		numvertex = poly[0];
		poly += 3;

		index = poly[0] * 3;
		x1 = array3d[index];
		y1 = array3d[index + 1];
		z1 = array3d[index + 2];
		
		index = poly[numvertex>>1] * 3;
		x2 = array3d[index];
		y2 = array3d[index + 1];
		z2 = array3d[index + 2];
		
		index = poly[numvertex-1] * 3;
		x3 = array3d[index];
		y3 = array3d[index + 1];
		z3 = array3d[index + 2];

		xn = ((y2-y1)*(z3-z1)-(y3-y1)*(z2-z1));
		yn = ((x2-x1)*(z3-z1)-(x3-x1)*(z2-z1));
		zn = ((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

		for (j = 0; j < numvertex; ++j)
		{
			index = *poly++;
			normalarray[index*3] += xn;
			normalarray[index*3 + 1] += yn;
			normalarray[index*3 + 2] += zn;
		}
	}


	/* 	calc vertex normals. */
	
	for (i = 0; i < numpoints; ++i)
	{
		xn = normalarray[0];
		yn = normalarray[1];
		zn = normalarray[2];

		norm = (TDOUBLE) (xn*xn + yn*yn + zn*zn);
		n = SPECULARITY/sqrt(norm);
		
		xn *= n;
		yn *= n;
		zn *= n;
		
		xn += *array3d++;
		yn += *array3d++;
		zn += *array3d++;
		
		normalarray[0] = -xn;
		normalarray[1] = yn;
		normalarray[2] = -zn;
		
		normalarray += 3;
	}
}



/*****************************************************************************

	placetexture(object)
	
*****************************************************************************/

void placetexture(object *obj)
{
	TUINT numv;
	TFLOAT maxx,maxy,minx,miny;
	TFLOAT *array3d, *txc;
	TINT i;
	TFLOAT x,y, xscale,yscale;

	array3d = obj->array3d;
	
	numv = obj->numvertex;
	maxy = maxx = -1000000;
	miny = minx = 1000000;

	for (i = 0; i < numv; ++i)
	{
		x = array3d[i * 3 + 1];
		y = array3d[i * 3 + 2];
		
		if (x > maxx)
		{
			maxx = x;
		}
		if (x < minx)
		{
			minx = x;
		}
		if (y > maxy)
		{
			maxy = y;
		}
		if (y < miny)
		{
			miny = y;
		}
	}

	xscale = ((TFLOAT) ((1 << obj->texwidthb) - 2)) / (maxx - minx);
	yscale = ((TFLOAT) (obj->texheight - 2)) / (maxy - miny);
	txc = obj->texcoords;
	
	for (i = 0; i < numv; ++i)
	{
		x = array3d[i * 3 + 1];
		y = array3d[i * 3 + 2];

		*txc++ = (x - minx) * xscale + 1.0;
		*txc++ = (y - miny) * yscale + 1.0;
	}
}




/*****************************************************************************

	drawobject(object,window)

*****************************************************************************/

void drawobject(object *obj, window *win)
{
	if (win->buffer)
	{
		struct polynode **catp, *node;
		TFLOAT *array2d, *texcoords;
		TUINT *texture;
		TUINT numcat, width, height, texwidthb;
		TFLOAT lmin, lscale;
		TINT i;

		width = win->width;
		height = win->height;

		numcat = obj->numcat;
		catp = obj->categories + numcat;
		array2d = obj->array2d;
		texture = obj->texture;
		texcoords = obj->texcoords;
		texwidthb = obj->texwidthb;

		lmin = LIGHTMIN * LIGHTMIN;
		lscale = LIGHTSTEPS / (LIGHTMAX * LIGHTMAX - lmin);

		TMemFill(win->buffer, win->width*win->height*4, 0);

		for (i = 0; i < obj->numcat; ++i)
		{
			node = *(--catp);
			while (node)
			{
				drawpolygt(win->buffer, node->poly, array2d, texture, texcoords, width, height, node->turnindex, texwidthb, lmin, lscale);
				node = node->next;
			}
		}

		TVDrawRGB(win->visual, 0,0, win->buffer, win->width, win->height, win->width);
	}
}


/*****************************************************************************

	dobject(object,timescale)

*****************************************************************************/

void doobject(object *obj, TFLOAT timescale)
{
	TFLOAT rx,ry,rz, dx,dy,dz;
	TFLOAT distance;
	TINT numvertex, i;
	TFLOAT *array2d, *array3d, *lightarray;
	TFLOAT zmin, zmax, z;
	
	numvertex = obj->numvertex;
	distance = obj->distance;


	/*	rotate world */
	
	rx = obj->rx;
	ry = obj->ry;
	rz = obj->rz;
	
	rx += obj->vrx * timescale;
	ry += obj->vry * timescale;
	rz += obj->vrz * timescale;

	if (rx >= PI*2)
	{
		rx -= PI*2;
	}

	if (ry >= PI*2)
	{
		ry -= PI*2;
	}

	if (rz >= PI*2)
	{
		rz -= PI*2;
	}


	obj->rx = rx;
	obj->ry = ry;
	obj->rz = rz;


	/*	rotate/transform array */

	array3d = obj->array3d;
	array2d = obj->array2d;
	rotrans(array3d, array2d, rx,ry,rz, distance, numvertex);



	/*	rotate array of point normals to light array */
	
	array3d = obj->normalarray;
	lightarray = obj->lightarray;
	rotate(array3d, lightarray, rx,ry,rz, numvertex);


	/* rotate lightsource */
	
	rx = obj->lrx;
	ry = obj->lry;
	rz = obj->lrz;
	
	rx += obj->lvrx * timescale;
	ry += obj->lvry * timescale;
	rz += obj->lvrz * timescale;

	if (rx >= PI*2)
	{
		rx -= PI*2;
	}
	if (ry >= PI*2)
	{
		ry -= PI*2;
	}
	if (rz >= PI*2)
	{
		rz -= PI*2;
	}

	obj->lrx = rx;
	obj->lry = ry;
	obj->lrz = rz;

	array3d = &obj->lx;
	lightarray = &obj->ltx;
	rotate(array3d, lightarray, rx,ry,rz, 1);


	/* calc distance from each vertex to lightsource */	

	lightarray = obj->lightarray;
	array2d = obj->array2d;
	rx = obj->ltx;
	ry = obj->lty;
	rz = obj->ltz;
	
	for (i = 0; i < numvertex; ++i)
	{
		dx = *lightarray++ - rx;
		dy = *lightarray++ - ry;
		dz = *lightarray++ - rz;
		array2d[3] = dx*dx + dy*dy + dz*dz;
		array2d += 4;
	}


	/* get zmin/zmax for category sort */	

	array2d = obj->array2d;
	zmin = 100000000;		
	zmax = -100000000;		

	for (i = 0; i < numvertex; ++i)
	{
		z = array2d[(i<<2)+2];
		if (z > zmax)
		{
			zmax = z;
		}
		if (z < zmin)
		{
			zmin = z;
		}
	}

	
	/* sort faces into z categories */


	TMemFill(obj->categories, obj->numcat * sizeof(struct polynode **), 0);
	facesort(obj->parray,array2d,obj->categories,obj->pbuffer,obj->numpoly,obj->numcat,zmin,zmax);
}




/*****************************************************************************

	deleteobject(object)
	
*****************************************************************************/

TUINT deleteobject(object *obj, TTAGITEM *tags)
{
	TMMUFree(obj->handle.mmu, obj->normalarray);
	TMMUFree(obj->handle.mmu, obj->lightarray);
	TMMUFree(obj->handle.mmu, obj->texcoords);
	TMMUFree(obj->handle.mmu, obj->pbuffer);
	TMMUFree(obj->handle.mmu, obj->categories);
	TMMUFree(obj->handle.mmu, obj->parray);
	TMMUFree(obj->handle.mmu, obj->polys);
	TMMUFree(obj->handle.mmu, obj->array2d);
	TMMUFree(obj->handle.mmu, obj->array3d);
	TMMUFreeHandle(obj);
	return 0;
}


/*****************************************************************************

	obj = createobject(texbuf,coords,polys,numcoords,numpolys,numcategories,texwidthb,texheight)
	
*****************************************************************************/

object *createobject(TAPTR mmu, TUINT *texbuf, TINT *coords, TINT *polys,
	TUINT numvertex, TUINT numpoly, TUINT numcat, TUINT texwidthb, TUINT texheight)
{
	object *obj;
	TBOOL success = TFALSE;

	obj = TMMUAllocHandle0(mmu, (TDESTROYFUNC) deleteobject, sizeof(object));
	if (obj)
	{
		obj->array3d = TMMUAlloc(obj->handle.mmu, sizeof(TFLOAT) * 3 * numvertex);
		
		if (obj->array3d)
		{
			obj->array2d = TMMUAlloc(obj->handle.mmu, sizeof(TFLOAT) * 4 * numvertex);
		}
		
		if (obj->array2d)
		{
			obj->polys = TMMUAlloc(obj->handle.mmu, sizeof(TFLOAT) * 6 * numpoly);
		}

		if (obj->polys)
		{
			obj->parray = TMMUAlloc(obj->handle.mmu, sizeof(TINT *) * numpoly);
		}	
	
		if (obj->parray)
		{
			obj->categories = TMMUAlloc(obj->handle.mmu, sizeof(struct polynode **) * numcat);
		}
		
		if (obj->categories)
		{
			obj->pbuffer = TMMUAlloc(obj->handle.mmu, sizeof(struct polynode) * numpoly);
		}
		
		if (obj->pbuffer)
		{
			obj->texcoords = TMMUAlloc(obj->handle.mmu, sizeof(TFLOAT) * 2 * numvertex);
		}
		
		if (obj->texcoords)
		{
			obj->lightarray = TMMUAlloc(obj->handle.mmu, sizeof(TFLOAT) * 3 * numvertex);
		}

		if (obj->lightarray)
		{
			obj->normalarray = TMMUAlloc(obj->handle.mmu, sizeof(TFLOAT) * 3 * numvertex);
		}
		
		if (obj->normalarray)
		{
			TINT i;
			TINT *sp = coords;
			TFLOAT *dp = obj->array3d;
			TINT *dp2;

			obj->numvertex = numvertex;
			obj->numpoly = numpoly;
			obj->numcat = numcat;


			/* copy coordinates. */
			
			for (i = 0; i < numvertex * 3; ++i)
			{
				*dp++ = (TFLOAT) *sp++;				
			}


			/* copy polygon indices, create polygon pointer table. */

			sp = polys;
			dp2 = obj->polys;
			for (i = 0; i < numpoly; ++i)
			{
				obj->parray[i] = dp2;
				*dp2++ = *sp++;
				*dp2++ = *sp++;
				*dp2++ = *sp++;
				*dp2++ = *sp++;
				*dp2++ = *sp++;
				*dp2++ = *sp++;
			}


			/* initial angles and angle velocities. */
			
			obj->distance = DIST;

			obj->rx = 0;
			obj->ry = 0;
			obj->rz = 0;

			obj->vrx = VRX;
			obj->vry = VRY;
			obj->vrz = VRZ;


			/* calculate point normals. */


			calcnormals(obj->array3d, obj->parray, obj->normalarray, numvertex, numpoly);


			/* light parameters. */
			
			obj->lx = 0;
			obj->ly = 0;
			obj->lz = LIGHTDISTANCE;

			obj->lrx = 0;
			obj->lry = 0;
			obj->lrz = 0;

			obj->lvrx = LVRX;
			obj->lvry = LVRY;
			obj->lvrz = LVRZ;
			

			/* texture. */

			obj->texwidthb = texwidthb;
			obj->texheight = texheight;
			obj->texture = texbuf;

			placetexture(obj);

			success = TTRUE;
		}
		
	
		if (!success)
		{
			TDestroy(obj);
			obj = TNULL;
		}
	}

	return obj;
}




TBOOL setobjectdistance(object *obj, window *win)
{
	TTAGITEM tags[3];

	tags[0].tag = TVisual_PixWidth;
	tags[0].value = &win->width;
	tags[1].tag = TVisual_PixHeight;
	tags[1].value = &win->height;
	tags[2].tag = TTAG_DONE;

	TVGetAttrs(win->visual, tags);

	obj->distance = (TFLOAT) (WINSIZE * DIST) / (TFLOAT) sqrt((TDOUBLE) win->width * win->height);

	TMMUFree(win->handle.mmu, win->buffer);
	if ((win->buffer = TMMUAlloc(win->handle.mmu, win->width * win->height * 4)))
	{
		return TTRUE;
	}
	else
	{
		return TFALSE;
	}
}


int main(int argc, char **argv)
{
	TAPTR basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TAPTR mmu = TNULL;
		window *win;
		TINT *objsrc = OBJSOURCE;
		TINT *coords, *polys;
		TUINT numpoint, numpoly, numcat;
		object *obj;


		win = createwindow(mmu, basetask);

		numpoint = objsrc[0];
		numpoly = objsrc[1];
		numcat = objsrc[2];
		coords = &objsrc[3];
		polys = &objsrc[3 + numpoint * 3];
		obj = createobject(mmu, texture, coords, polys, numpoint, numpoly, numcat, 7, 128);

	
		if (win && obj)
		{
			TBOOL abort = TFALSE;
			TIMSG *imsg;
			TTIME t1;
			TFLOAT delayf, fps = 1.0;
			char buf[100];
			TFLOAT timescale = 1.0;

			setobjectdistance(obj, win);

			while (!abort)
			{
				TTimeReset(basetask);

				doobject(obj, timescale);
				drawobject(obj, win);

				sprintf(buf, "FPS: %.2f - TS: %.2f   ", fps, timescale);
				TVText(win->visual,1,1,buf,TStrLen(buf),win->pen[0],win->pen[1]);

				TVFlushArea(win->visual, 0,0, win->width, win->height);


				TTimeQuery(basetask, &t1);

				delayf = 1.0f/FRAMERATE - TTIMETOF(&t1);
				if (delayf > 0.00001f)
				{
					TFTOTIME(delayf, &t1);
					TTimedWait(basetask, win->visual->iport->signal, &t1);
				}

				TTimeQuery(basetask, &t1);
				fps = 1.0f/TTIMETOF(&t1);

				timescale = TTIMETOF(&t1) / (1.0f/FRAMERATE);


				while ((imsg = TGetMsg(win->visual->iport)))
				{
					switch (imsg->type)
					{
						case TITYPE_VISUAL_CLOSE:
							abort = TTRUE;
							break;

						case TITYPE_KEY:
							if (imsg->code == TKEYCODE_ESC)
							{
								abort = TTRUE;
							}
							break;

						case TITYPE_VISUAL_NEWSIZE:
							setobjectdistance(obj, win);
							break;
					}
					TAckMsg(imsg);
				}
			}	
		}	

		TDestroy(obj);
		TDestroy(win);
		TDestroy(basetask);
	}

	return 0;
}


