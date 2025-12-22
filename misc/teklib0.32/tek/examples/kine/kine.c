/**********************************************************
**
**		Kinematic Test
**		using Teklib
**		Copper / Defect Softworks
**		02.05.2001  
**		24.05.2001
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <tek/mem.h>
#include <tek/visual.h>
#include <tek/array.h>
#include <tek/debug.h>
#include "mathutil.h"
#include "kine.h"

#define XWIN 400
#define YWIN 300
#define ABS(a)		(((a)<0) ? -(a) : (a))
#define SGN(a)		(((a)<0) ? -1 : 0)

#ifndef PI
	#ifdef M_PI
	#define PI M_PI
	#else
	#define PI 3.1415927
	#endif
#endif

typedef struct
{
	THNDL handle;
	TAPTR buffer;
	TVISUAL *visual;
	TINT width;
	TINT height;
	TVPEN pen[2];
	
} window;


TUINT deletewindow(window *win, TTAGITEM *tags)
{
	TVFreePen(win->visual, win->pen[0]);
	TVFreePen(win->visual, win->pen[1]);
	TDestroy(win->visual);
	//TMMUFree(win->handle.mmu, win->buffer);
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

		win->width = XWIN;
		win->height = YWIN;

		TInitTags(tags);
		TAddTag(tags, TVisual_Title, "Kinematic at Work");
		TAddTag(tags, TVisual_PixWidth, XWIN);
		TAddTag(tags, TVisual_PixHeight, YWIN);

		win->visual = TCreateVisual(basetask, tags);
		//win->buffer = TMMUAlloc(mmu, XWIN*YWIN*4);
		

		//if (win->visual && win->buffer)
		if (win->visual)
		{
			win->pen[0] = TVAllocPen(win->visual, 0x000000);
			win->pen[1] = TVAllocPen(win->visual, 0xffffff);

			TVSetInput(win->visual, TITYPE_NONE, TITYPE_VISUAL_CLOSE | TITYPE_KEY | TITYPE_MOUSEMOVE |TITYPE_MOUSEBUTTON |TITYPE_VISUAL_NEWSIZE);
			return win;
		}
		
		TDestroy(win);
	}

	return TNULL;
}


/*
**
** Draw Joints
**
*/
TVOID drawjoints(world *w, window *win)
{
		TINT xoff = w->xoff;
		TINT yoff = w->yoff;
		TINT tx,ty,tx1,ty1;
		
		TVClear(win->visual,win->pen[0]);
		TVLine(win->visual,w->basex,win->height-w->basey,w->basex+w->baselength,win->height-w->basey,win->pen[1]);
		TVFRect(win->visual,xoff-2,win->height-yoff-2,5,5,win->pen[1]);

		tx1 = (TINT)w->kc[0].px+xoff;
		ty1 = (TINT)w->kc[0].py+yoff;

		tx = (TINT)w->kc[1].px+xoff;
		ty = (TINT)w->kc[1].py+yoff;

		TVLine(win->visual,tx1,win->height-ty1,tx,win->height-ty,win->pen[1]);
		TVFRect(win->visual,tx-2,win->height-ty-2,5,5,win->pen[1]);		

		tx1 = (TINT)w->kc[2].px+xoff;
		ty1 = (TINT)w->kc[2].py+yoff;

		TVLine(win->visual,tx,win->height-ty,tx1,win->height-ty1,win->pen[1]);
		TVFRect(win->visual,tx1-2,win->height-ty1-2,5,5,win->pen[1]);		

		tx = (TINT)w->kc[3].px+xoff;
		ty = (TINT)w->kc[3].py+yoff;

		TVLine(win->visual,tx1,win->height-ty1,tx,win->height-ty,win->pen[1]);

		tx1 = (TINT)w->ex+xoff;
		ty1 = (TINT)w->ey+yoff;

		TVLine(win->visual,tx,win->height-ty,tx1,win->height-ty1,win->pen[1]);
		TVFRect(win->visual,tx1-4,win->height-ty1-4,9,9,win->pen[1]);

		TVFlush(win->visual);
		
}


/* 
** Berechne Gelenkpositionen mit Hartenbergtrafo
*/
TVOID makejoints(world *w)
{
		/* Erster Punkt */
		w->v[0] = 0;
		w->v[1] = 0;
		w->v[2] = 0;
		w->v[3] = 1;
		
		w->kc[0].px = 0;
		w->kc[0].py = 0;
		w->kc[0].pz = 0;

		GetHartenberg(&w->kc[0].j, &w->kc[0].m);

		MatMultPoint(&w->kc[0].m , w->v, w->tmp);
		w->kc[1].px = w->tmp[0];
		w->kc[1].py = w->tmp[1];
		w->kc[1].pz = w->tmp[2];
		
		GetHartenberg(&w->kc[1].j, &w->mat1);

		MatMultGeneral(&w->kc[0].m,&w->mat1,&w->kc[1].m);

		MatMultPoint(&w->kc[1].m, w->v, w->tmp);
		w->kc[2].px = w->tmp[0];
		w->kc[2].py = w->tmp[1];
		w->kc[2].pz = w->tmp[2];
		
		GetHartenberg(&w->kc[2].j, &w->mat1);

		MatMultGeneral(&w->kc[1].m,&w->mat1,&w->kc[2].m);

		MatMultPoint(&w->kc[2].m,w->v,w->tmp);
		w->kc[3].px = w->tmp[0];
		w->kc[3].py = w->tmp[1];
		w->kc[3].pz = w->tmp[2];

		GetHartenberg(&w->kc[3].j, &w->mat1);

		MatMultGeneral(&w->kc[2].m,&w->mat1,&w->kc[3].m);
		MatMultPoint(&w->kc[3].m,w->v,w->tmp);

		w->ex = w->tmp[0];
		w->ey = w->tmp[1];
		w->ez = w->tmp[2];

}

/*
**
** 	Calculate JacobiMatrix
**
*/
TVOID GetJacobi(GenMatrix *A, world *w)
{
	TINT i,j,t;
	TFLOAT bx,by,bz;
	#define a(x) (w->kc[j].m.v[OF_##x])
	
	/* Copy 'a' and 'b' Coeffizents */
	
	i=0;
	j=0;
	
	for(t=0;t < JMax;t++,j++,i+=3)
	{
		bx = w->ex - w->kc[j].px;
		by = w->ey - w->kc[j].py;
		bz = w->ez - w->kc[j].pz;

		A->m[3][i] = a(11);
		A->m[4][i] = a(21);
		A->m[5][i] = a(31);

		A->m[0][i] = a(21)*bz - a(31)*by;
		A->m[1][i] = a(31)*bx - a(11)*bz;
		A->m[2][i] = a(11)*by - a(21)*bx;
		
		A->m[3][i+1] = a(12);
		A->m[4][i+1] = a(22);
		A->m[5][i+1] = a(32);

		A->m[0][i+1] = a(22)*bz - a(32)*by;
		A->m[1][i+1] = a(32)*bx - a(12)*bz;
		A->m[2][i+1] = a(12)*by - a(22)*bx;

		A->m[3][i+2] = a(13);
		A->m[4][i+2] = a(23);
		A->m[5][i+2] = a(33);

		A->m[0][i+2] = a(23)*bz - a(33)*by;
		A->m[1][i+2] = a(33)*bx - a(13)*bz;
		A->m[2][i+2] = a(13)*by - a(23)*bx;

	}
	
	#undef a
}


/*
**
**  calculate the new angels for a new position
**
*/
void CalcNewAngel(world *w,window *win, TINT dx, TINT dy)
{
			TFLOAT x1,x2,y1,y2,tx,ty;
				
			InitGenMatrix(&w->gmat1,6,3*JMax);
			InitGenMatrix(&w->gmat2,3*JMax,6);
			InitGenMatrix(&w->gmat3,6,6);

			x1 = w->ex + dx;
			y1 = w->ey + dy;
			
			GetJacobi(&w->gmat1,w);

			//GenMatPseudoInvers(&w->gmat1,&w->gmat2,&w->gmat3);

			/* Calculate Pseudoinverse */
			/* J^T(JJ^T+kI)^-1, k damping factor to minimize singualies */
			GenMatTranspose(&w->gmat1,&w->gmat2);
			GenMatMultiply(&w->gmat1,&w->gmat2,&w->gmat3);

			InitGenMatrix(&w->gmat5,6,6);
			GenMatLoadIdentity(&w->gmat5,0.5);
			InitGenMatrix(&w->gmat4,6,6);
			GenMatAdd(&w->gmat3,&w->gmat5,&w->gmat4);
			GenMatInvers(&w->gmat4);
			w->gmat1.rows = w->gmat2.rows;
			w->gmat1.colum = w->gmat2.colum;
			GenMatMultiply(&w->gmat2,&w->gmat4,&w->gmat1);


			InitGenMatrix(&w->gmat4,6,1);
			w->gmat4.m[0][0] = dx;
			w->gmat4.m[1][0] = dy;
			w->gmat4.m[2][0] = 0;
			w->gmat4.m[3][0] = 0;
			w->gmat4.m[4][0] = 0;
			w->gmat4.m[5][0] = 0;
			
			InitGenMatrix(&w->gmat5,3*JMax,1);

			GenMatMultiply(&w->gmat1,&w->gmat4,&w->gmat5);

			w->kc[0].j.theta += w->gmat5.m[2][0];
			w->kc[1].j.theta += w->gmat5.m[5][0];
			w->kc[2].j.theta += w->gmat5.m[8][0];
			w->kc[3].j.theta += w->gmat5.m[11][0];

			makejoints(w);

			x2 = x1 - w->ex;
			y2 = y1 - w->ey;
			
			w->gmat4.m[0][0] = x2;
			w->gmat4.m[1][0] = y2;
			

			GenMatMultiply(&w->gmat1,&w->gmat4,&w->gmat5);

			w->kc[0].j.theta += w->gmat5.m[2][0];
			w->kc[1].j.theta += w->gmat5.m[5][0];
			w->kc[2].j.theta += w->gmat5.m[8][0];
			w->kc[3].j.theta += w->gmat5.m[11][0];

			makejoints(w);

			/* Fehler Testen */
			tx = w->ex-x1;
			ty = w->ey-y1;
			//printf("finaldiffx: %f finaldiffy: %f\n",tx,ty);

}


/*
**	Calculate new Position
**
*/
TVOID MakeNewPosition(TINT xx, TINT yy, world *w, window *win)
{
		
	TINT x1,y1,x2,y2,k,steps;
	TFLOAT xincrement,yincrement,x,y,dx,dy;
	
	x2 = xx - w->xoff;
	y2 = win->height - yy - w->yoff;
	x1 = w->ex;
	y1 = w->ey;
	
    dx = x2-x1;
    dy = y2-y1;  

	if(ABS(dx) > ABS(dy)) {steps = ABS(dx);} else {steps = ABS(dy);}
	{
		xincrement = dx/steps;
		yincrement = dy/steps;
	}
	
	x = x1;
	y = y1;
	
	for(k=0;k < steps;k++)
	{
		x += xincrement;
		y += yincrement;

		/* check if we can reach the new position */
		if(sqrt(x*x+y*y)<w->lenght-1)
		CalcNewAngel(w,win,(TINT)(x-w->ex),(TINT)(y-w->ey));

		if(!w->check)
		{
			drawjoints(w,win);
			TTimeDelayF(w->task,0.002);
		}
	}
	if(w->check)
		drawjoints(w,win);
}

/*
**		Start the stuff
**
*/
TINT main(int argc, char **argv)
{
	TAPTR basetask = TCreateTask(TNULL, TNULL, TNULL);

	if(basetask)
	{
		TAPTR mmu = TNULL;
		world *w;
		window *win;
		
		w = TMMUAlloc0(mmu,sizeof(world));

		w->task = basetask;

		w->kc[0].j.theta = 120 * PI / 180;
		w->kc[0].j.d = 0;
		w->kc[0].j.a = 60;
		w->kc[0].j.a1 = 60;
		w->kc[0].j.alpha = 0;

		w->kc[1].j.theta = 280 * PI / 180;
		w->kc[1].j.d = 0;
		w->kc[1].j.a = 80;
		w->kc[1].j.a1 = 80;
		w->kc[1].j.alpha = 0;

		w->kc[2].j.theta = 310 * PI / 180;
		w->kc[2].j.d = 0;
		w->kc[2].j.a = 60;
		w->kc[2].j.a1 = 60;
		w->kc[2].j.alpha = 0;

		w->kc[3].j.theta = 0 * PI / 180;
		w->kc[3].j.d = 0;
		w->kc[3].j.a = 5;
		w->kc[3].j.a1 = 5;
		w->kc[3].j.alpha = 0;

		w->lenght = 200;
		w->baselength = 100;
		w->basex = XWIN / 2 - w->baselength / 2;
		w->basey = YWIN/3;
		w->xoff = XWIN / 2;
		w->yoff = w->basey;

		/* Window erzeugen */
		win = createwindow(mmu, basetask);

		if(win)
		{
			TBOOL abort = TFALSE;
			TIMSG *imsg;
			

			makejoints(w);
			drawjoints(w,win);

			
			do
			{			
				TWait(basetask, win->visual->iport->signal);

				while ((imsg = (TIMSG *) TGetMsg(win->visual->iport)))
				{
					switch (imsg->type)
					{
						case TITYPE_VISUAL_NEWSIZE:
						{
								TTAGITEM tags[3];
								TFLOAT ow,oh,sc;
								TINT i;
								
								ow = (TFLOAT)win->width;
								oh = (TFLOAT)win->height;
								
								tags[0].tag = TVisual_PixWidth;
								tags[0].value = &win->width;
								tags[1].tag = TVisual_PixHeight;
								tags[1].value = &win->height;
								tags[2].tag = TTAG_DONE;

								TVGetAttrs(win->visual, tags);

								sc = sqrt((TDOUBLE) win->width * win->height) / sqrt((TDOUBLE) XWIN * YWIN);
								
								//printf("sc: %f\n",sc);
								
								w->lenght = 0;
								for(i=0;i<JMax;i++)
								{
									w->kc[i].j.a = w->kc[i].j.a1 * sc;
									w->lenght += w->kc[i].j.a;
								}
								
								w->baselength = 100 * sc;
								w->basex = win->width / 2 - w->baselength / 2;
								w->basey = win->height/3;
								w->xoff = win->width / 2;
								w->yoff = w->basey;

								//printf("width: %d height: %d\n",win->width,win->height);
								//printf("xoff: %d yoff: %d\n",w->xoff,w->yoff);

									makejoints(w);
									drawjoints(w,win);
						}
						break;
						
						case TITYPE_VISUAL_CLOSE:
									abort = TTRUE;
									break;

						case TITYPE_KEY:
							switch (imsg->code)
							{
								case TKEYCODE_ESC:
									abort = TTRUE;
									break;
								case 55:
									w->kc[0].j.theta += 2 * PI /180;
									makejoints(w);
									drawjoints(w,win);
									break;
								case 57:
									w->kc[0].j.theta -= 2 * PI / 180;
									makejoints(w);
									drawjoints(w,win);
									break;
								case 52:
									w->kc[1].j.theta += 2 * PI / 180;
									makejoints(w);
									drawjoints(w,win);
									break;
								case 54:
									w->kc[1].j.theta -= 2 * PI / 180;
									makejoints(w);
									drawjoints(w,win);
									break;
								case 49:
									w->kc[2].j.theta += 2 * PI / 180;
									makejoints(w);
									drawjoints(w,win);
									break;
								case 51:
									w->kc[2].j.theta -= 2 * PI / 180;
									makejoints(w);
									drawjoints(w,win);
									break;

							}
							break;

						case TITYPE_MOUSEMOVE:
							if(w->check)
							{
								MakeNewPosition(imsg->mousex,imsg->mousey,w,win);
							}
							break;

						case TITYPE_MOUSEBUTTON:
							switch (imsg->code)
							{
							
								case TMBCODE_LEFTDOWN:
								{
									w->check = TFALSE;
									
									if (ABS(imsg->mousex - w->ex - w->xoff) <= 4)
										if (ABS(win->height - imsg->mousey - w->ey - w->yoff) <= 4)
											w->check = TTRUE;

									//printf("ex: %f  ey: %f\n",w->ex,w->ey);
									if(!w->check)
									{	
										TINT x,y;
										x = imsg->mousex;
										y = imsg->mousey;
										MakeNewPosition(x,y,w,win);
									}
								}
								break;
								case TMBCODE_LEFTUP:
									w->check = TFALSE;
									break;
							}

							break;	
					}
					TAckMsg(imsg);
				}

			} while (!abort);

		}
	
		
		TMMUFree(mmu, w);
	
		TDestroy(win);
		TDestroy(basetask);

	}

	return 0;

}
