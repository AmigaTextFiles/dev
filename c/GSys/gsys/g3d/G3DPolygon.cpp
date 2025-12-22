
/* Author Anders Kjeldsen */

#ifndef G3DPOLYGON_CPP
#define G3DPOLYGON_CPP

#include "g3d/G3DPolygon.h"

GPolygon::GPolygon()
{
	memset((void *)this, 0, sizeof (class G3DPolygon));
	Visible = TRUE;
	GSortNode.SetData((void *)this);
}

GPolygon::~GPolygon()
{
	if (GPolygonA) delete GPolygonA;
	if (GPolygonB) delete GPolygonB;
}

BOOL G3DPolygon::ClipZ(float ClipValue, BOOL RightSide )	/* Clip polygon through CHOSEN Z-value */
{
		class G3DVertex PA;
		class G3DVertex PB;
		class G3DVertex *PC = NULL;
		class G3DVertex *PD = NULL;

		class G3DVertex *V1 = (class G3DVertex *)&Polygon.v1;
		class G3DVertex *V2 = (class G3DVertex *)&Polygon.v2;
		class G3DVertex *V3 = (class G3DVertex *)&Polygon.v3;
//		class G3DVertex *V1 = &GVertex1;
//		class G3DVertex *V2 = &GVertex2;
//		class G3DVertex *V3 = &GVertex3;

		class G3DVector VA;
		class G3DVector VB;

		ClippedA = FALSE;
		ClippedB = FALSE;
		Visible = TRUE;


		if (RightSide == HIGHER)	/* The Point Z should be HIGHER than the ClipValue? */
		{
			if (V1->Z < ClipValue) 					/* CLIP FIRST POINT? */
			{ 
				PC = V2;
				PD = V3;

				if (V2->Z < ClipValue) 				/* CLIP FIRST SECOND POINT ASWELL? */
				{ 
					if (V3->Z < ClipValue) 			/* CLIP ALL POINTS? */
					{
						Visible = FALSE;
						return TRUE;
					}
					else
					{
						PC = V3;
						PD = NULL;
						ClipLineZ(V2, V3, &PA, &VA, ClipValue);
					}
				}
				else 
				{
					ClipLineZ(V1, V2, &PA, &VA, ClipValue);
				}

				if (V3->Z < ClipValue)
				{ 
					PC = V2;
					PD = NULL;
					ClipLineZ(V3, V2, &PB, &VB, ClipValue);
				}
				else 
				{
					ClipLineZ(V1, V3, &PB, &VB, ClipValue);
				}
			}


			else if (V2->Z < ClipValue)
			{ 
				PC = V1;
				PD = V3;

				ClipLineZ(V2, V1, &PA, &VA, ClipValue);

				if (V3->Z < ClipValue)
				{ 
//					PD = V1;
//					PC = NULL;
					PD = NULL;
				
					ClipLineZ(V3, V1, &PB, &VB, ClipValue);
				}
				else 
				{
					ClipLineZ(V2, V3, &PB, &VB, ClipValue);
				}
			}

			else if (V3->Z < ClipValue) // clip first point
			{ 
				PC = V1;
				PD = V2;
				ClipLineZ(V3, V1, &PA, &VA, ClipValue);
				ClipLineZ(V3, V2, &PB, &VB, ClipValue);	

			}
			else
			{
				ClippedA = ClippedB = FALSE;
				V1->CopyVertex((class G3DVertex *)&Polygon.v1);
				V2->CopyVertex((class G3DVertex *)&Polygon.v2);
				V3->CopyVertex((class G3DVertex *)&Polygon.v3);
				return TRUE;
			} 
			
		}
		else
		{
			if (V1->Z > ClipValue) 					/* CLIP FIRST POINT? */
			{ 

				PC = V2;
				PD = V3;

				if (V2->Z > ClipValue) 				/* CLIP FIRST SECOND POINT ASWELL? */
				{ 
					if (V3->Z > ClipValue) 			/* CLIP ALL POINTS? */
					{
						Visible = FALSE;
						return TRUE;
					}
					else
					{
						PC = V3;
						PD = NULL;
						ClipLineZ(V2, V3, &PA, &VA, ClipValue);
					}
				}
				else ClipLineZ(V1, V2, &PA, &VA, ClipValue);


				if (V3->Z > ClipValue)
				{ 
					PC = V2;
					PD = NULL;
					ClipLineZ(V3, V2, &PB, &VB, ClipValue);
				}
				else ClipLineZ(V1, V3, &PB, &VB, ClipValue);
			}



			else if (V2->Z > ClipValue)
			{ 
				PC = V1;
				PD = V3;

				ClipLineZ(V2, V1, &PA, &VA, ClipValue);

				if (V3->Z < ClipValue)
				{ 
					PD = NULL;
					ClipLineZ(V3, V1, &PB, &VB, ClipValue);
				}
				else ClipLineZ(V2, V3, &PB, &VB, ClipValue);
			}

			else if (V3->Z > ClipValue) // clip first point
			{ 
				PC = V1;
				PD = V2;

				ClipLineZ(V3, V1, &PA, &VA, ClipValue);
				ClipLineZ(V3, V2, &PB, &VB, ClipValue);	
			}
			else 
			{
				ClippedA = ClippedB = FALSE;
				V1->CopyVertex((class G3DVertex *)&Polygon.v1);
				V2->CopyVertex((class G3DVertex *)&Polygon.v2);
				V3->CopyVertex((class G3DVertex *)&Polygon.v3);
				return TRUE;
			}

		}

		if (PC)
		{
			if (!GPolygonA) GPolygonA = new G3DPolygon();
			
			ClippedA = TRUE;
			PC->CopyVertex((class G3DVertex *)&GPolygonA->Polygon.v1);
			PA.CopyVertex((class G3DVertex *)&GPolygonA->Polygon.v2);
			PB.CopyVertex((class G3DVertex *)&GPolygonA->Polygon.v3);
		
			if (PD)
			{
				if (!GPolygonB) GPolygonB = new G3DPolygon();
				ClippedB = TRUE;

				PC->CopyVertex((class G3DVertex *)&GPolygonB->Polygon.v1);
				PB.CopyVertex((class G3DVertex *)&GPolygonB->Polygon.v2);
				PD->CopyVertex((class G3DVertex *)&GPolygonB->Polygon.v3);

				return TRUE;
			}
			return TRUE;
		}
		else if (PD)
		{
			if (!GPolygonA) GPolygonA = new G3DPolygon();

			ClippedA = TRUE;
			PD->CopyVertex((class G3DVertex *)&GPolygonA->Polygon.v1);
			PA.CopyVertex((class G3DVertex *)&GPolygonA->Polygon.v2);
			PB.CopyVertex((class G3DVertex *)&GPolygonA->Polygon.v3);


			return TRUE;
		}
		return TRUE;
}


BOOL G3DPolygon::ClipLineX(class G3DVertex *P1, class G3DVertex *P2, class G3DVertex *PD, class G3DVector *V, float ClipValue)
{
	V->Init(P1, P2);
	V->DivideByX();
	V->Multiply(ClipValue - P1->X);
	P1->CopyVertex(PD);
	PD->AddVector(V);
	return TRUE;
} /* Point (x, y, z) will be placed on the position where X == ClipValue (what you want it to be) */

BOOL G3DPolygon::ClipLineY(class G3DVertex *P1, class G3DVertex *P2, class G3DVertex *PD, class G3DVector *V, float ClipValue)
{
	V->Init(P1, P2);
	V->DivideByY();
	V->Multiply(ClipValue - P1->Y);
	P1->CopyVertex(PD);
	PD->AddVector(V);
	return TRUE;
} /* Point (x, y, z) will be placed on the position where Y == ClipValue (what you want it to be) */

BOOL G3DPolygon::ClipLineZ(class G3DVertex *P1, class G3DVertex *P2, class G3DVertex *PD, class G3DVector *V, float ClipValue)
{
	V->Init(P1, P2);
	V->DivideByZ();
	V->Multiply(ClipValue - P1->Z);	// (1.0 - P1->Z usually)
	P1->CopyVertex(PD);
	PD->AddVector(V);
	return TRUE;
} /* Point (x, y, z) will set to the position where Z == what you want it to be */

void G3DPolygon::SetSortWeight()
{
	GSortNode.SetWeight( (float) (Polygon.v1.z + Polygon.v2.z + Polygon.v3.z) / 3.0 ); 
	GSortNode.SetVisited(FALSE);
}

void G3DPolygon::Rotate(class G3DMatrix *GMatrix)
{
	Polygon.v1.x =	GVertex1.X * G3DMatrix->Matrix[0][0] +
			GVertex1.Y * G3DMatrix->Matrix[1][0] +
			GVertex1.Z * G3DMatrix->Matrix[2][0] +
			GMatrix->Matrix[3][0];

	Polygon.v1.y =	GVertex1.X * G3DMatrix->Matrix[0][1] +
			GVertex1.Y * G3DMatrix->Matrix[1][1] +
			GVertex1.Z * G3DMatrix->Matrix[2][1] +
			GMatrix->Matrix[3][1];

	Polygon.v1.z =	GVertex1.X * G3DMatrix->Matrix[0][2] +
			GVertex1.Y * G3DMatrix->Matrix[1][2] +
			GVertex1.Z * G3DMatrix->Matrix[2][2] +
			GMatrix->Matrix[3][2];
// v2
	Polygon.v2.x =	GVertex2.X * G3DMatrix->Matrix[0][0] +
			GVertex2.Y * G3DMatrix->Matrix[1][0] +
			GVertex2.Z * G3DMatrix->Matrix[2][0] +
			GMatrix->Matrix[3][0];

	Polygon.v2.y =	GVertex2.X * G3DMatrix->Matrix[0][1] +
			GVertex2.Y * G3DMatrix->Matrix[1][1] +
			GVertex2.Z * G3DMatrix->Matrix[2][1] +
			GMatrix->Matrix[3][1];

	Polygon.v2.z =	GVertex2.X * G3DMatrix->Matrix[0][2] +
			GVertex2.Y * G3DMatrix->Matrix[1][2] +
			GVertex2.Z * G3DMatrix->Matrix[2][2] +
			GMatrix->Matrix[3][2];
// v3
	Polygon.v3.x =	GVertex3.X * G3DMatrix->Matrix[0][0] +
			GVertex3.Y * G3DMatrix->Matrix[1][0] +
			GVertex3.Z * G3DMatrix->Matrix[2][0] +
			GMatrix->Matrix[3][0];

	Polygon.v3.y =	GVertex3.X * G3DMatrix->Matrix[0][1] +
			GVertex3.Y * G3DMatrix->Matrix[1][1] +
			GVertex3.Z * G3DMatrix->Matrix[2][1] +
			GMatrix->Matrix[3][1];

	Polygon.v3.z =	GVertex3.X * G3DMatrix->Matrix[0][2] +
			GVertex3.Y * G3DMatrix->Matrix[1][2] +
			GVertex3.Z * G3DMatrix->Matrix[2][2] +
			GMatrix->Matrix[3][2];
}

void G3DPolygon::DrawPoints(class G3DScreen *GScreen)
{
	int x, y, x2, y2, x3, y3;

	float z = Polygon.v1.z;
//	z = 1.0;

	if (GScreen)
	{

	if (z)
	{
		x = (int) ((Polygon.v1.x * G3DScreen->ScrWidth/2) / z);
		y = (int) ((Polygon.v1.y * G3DScreen->ScrHeight/2)/ z);
		x+=(GScreen->ScrWidth/2);
		y+=(GScreen->ScrHeight/2);


		if (0 <= x <= G3DScreen->ScrWidth)
		{
			if (0 <= y <= G3DScreen->ScrHeight)
			{
				GScreen->PutPixel( x, y, 0xffffff);
			}
			else y=0;
		}
		else x=0;

	}


	z = Polygon.v2.z;
// v2
	if (z)
	{
		x2 = (int) ((Polygon.v2.x * G3DScreen->ScrWidth/2) / z);
		y2 = (int) ((Polygon.v2.y * GScreen->ScrHeight/2) / z);
		x2+=(GScreen->ScrWidth/2);
		y2+=(GScreen->ScrHeight/2);
		if (0 <= x2 <= GScreen->ScrWidth)
		{
			if (0 <= y2 <= GScreen->ScrHeight)
			{
				GScreen->PutPixel( x2, y2, 0x0000ff);
			}
			else y2=0;
		}
		else x2=0;
	}

// v3
	z = Polygon.v3.z;

	if (z)
	{
		x3 = (int) ((Polygon.v3.x * GScreen->ScrWidth/2) / z);
		y3 = (int) ((Polygon.v3.y * GScreen->ScrHeight/2) / z);
		x3+=(GScreen->ScrWidth/2);
		y3+=(GScreen->ScrHeight/2);
		if (0 <= x3 <= GScreen->ScrWidth)
		{
			if (0 <= y3 <= GScreen->ScrHeight)
			{
				GScreen->PutPixel( x3 , y3 , 0xff0000);
			}
			else y3=0;
		}
		else x3=0;

	}

//	GScreen->DrawLine(x, y, x2, y2, 20);
//	GScreen->DrawLine(x, y, x3, y3, 20);
//	GScreen->DrawLine(x2, y2, x3, y3, 20);


	}

}

void G3DPolygon::DrawLines(class GScreen *GScreen)
{
	int x=0, y=0, x2=0, y2=0, x3=0, y3=0;
	short d1=0, d2=0, d3=0;

	if (Visible)
	{

	float z = Polygon.v1.z;
//	z = 1.0;

	if (GScreen)
	{

		if (z)
		{
			x = (int) ((Polygon.v1.x * GScreen->ScrWidth/2) / z);
			y = (int) ((Polygon.v1.y * GScreen->ScrHeight/2) / z);
//			x = (int) (Polygon.v1.x / z);
//			y = (int) (Polygon.v1.y / z);
			x+=(GScreen->ScrWidth/2);
			y+=(GScreen->ScrHeight/2);

			if ( (0 <= x) && (x < GScreen->ScrWidth))
			{
				if ((0 <= y) && (y < GScreen->ScrHeight))
				{
					d1 = TRUE;
				}
			}
		}


	z = Polygon.v2.z;
// v2
		if (z)
		{
			x2 = (int) ((Polygon.v2.x * GScreen->ScrWidth/2) / z);
			y2 = (int) ((Polygon.v2.y * GScreen->ScrHeight/2) / z);
//			x2 = (int) (Polygon.v2.x / z);
//			y2 = (int) (Polygon.v2.y / z);
			x2+=(GScreen->ScrWidth/2);
			y2+=(GScreen->ScrHeight/2);
			if ((0 <= x2) && (x2 < GScreen->ScrWidth))
			{
				if ((0 <= y2) && (y2 < GScreen->ScrHeight))
				{
					d2 = TRUE;
				}
			}
		}

// v3
	z = Polygon.v3.z;

		if (z)
		{
			x3 = (int) ((Polygon.v3.x * GScreen->ScrWidth/2) / z);
			y3 = (int) ((Polygon.v3.y * GScreen->ScrHeight/2) / z);
//			x3 = (int) (Polygon.v3.x / z);
//			y3 = (int) (Polygon.v3.y / z);
			x3+=(GScreen->ScrWidth/2);
			y3+=(GScreen->ScrHeight/2);
			if ((0 <= x3) && (x3 < GScreen->ScrWidth))
			{
				if ((0 <= y3) && (y3 < GScreen->ScrHeight))
				{
					d3 = TRUE;
				}
			}
		}

		if (d1 && d2 && d3)
		{
			GScreen->DrawLine(x, y, x2, y2, 20);
			GScreen->DrawLine(x, y, x3, y3, 20);
			GScreen->DrawLine(x2, y2, x3, y3, 20);
		}
	}

	}
}

void G3DPolygon::DrawPolygon(class GScreen *GScreen)
{
	class G3DVertex s12, s13, s23;
	
	class G3DVertex *p1, *p2, *p3, *pt;
	class G3DVertex *sl, *sr, *sl2, *sr2;
	class G3DVertex pl, spx;
	float prx;

	p1 = (class G3DVertex *)&Polygon.v1;
	p2 = (class G3DVertex *)&Polygon.v2;
	p3 = (class G3DVertex *)&Polygon.v3;
	pt = NULL;

	int y1, y2;

	if ( p1->Y > p2->Y )
	{
		pt = p2;
		p2 = p1;
		p1 = pt;
	}	
	if ( p2->Y > p3->Y )
	{
		pt = p3;
		p3 = p2;
		p2 = pt;
	}
	if ( p1->Y > p2->Y )
	{
		pt = p2;
		p2 = p1;
		p1 = pt;
	}	

	s12 = p2-p1;
	y1 = (int) s12.Y;
	if ( s12.DivideByY() )
	{
		s23 = p3-p2;
		y2 = (int) s23.Y;
		s23.DivideByY();

		s13 = p3-p1;
		s13.DivideByY();	

		if (s12.X < s13.X)
		{
			spx = s13-s12;
			spx.DivideByX();
			sl = &s12;
			sl2 = &s23;
			sr = &s13;
			sr2 = &s13;
		}
		else
		{
			spx = s12-s13;
			spx.DivideByX();
			sr = &s12;
			sr2 = &s23;
			sl = &s13;
			sl2 = &s13;
		}
	}
	else
	{
		y2 = -1;

		if (p1->X > p2->X)
		{
			pt = p1;
			p1 = p2;
			p2 = p1;
		}

		s12 = p3-p2;
		s13 = p3-p1;
		y1 = (int) s12.Y;

		sr = &s12;
		sr2 = NULL;
		sl = &s13;
		sl2 = NULL;
	}

	pl = p1;
	prx = p2->X;


	if ( GScreen->DDPixByte == 4)
	{
		unsigned int *screenpos = &( (unsigned int *) GScreen->DDBuffer() )[ (ScrWidth * (int)p1.Y) + GScreen->ScrHeight];

		while (1)
		{
//			interpolate16( &pl, &spx, (prx>>16) - (pl.xp>>16), texture, screenpos);
			int xx = (int) pl.X + ScrWidth;
			for (int i=0; i < (prx - pl.X); i++)
			{
				class G3DVertex ppx = pl;
				screenpos[x+i] = 0x3388ff;
				ppx += spx;
			}

			pl = sl+pl;
			prx+= sr->X;

			screenpos+=GScreen->ScrWidth;
			y1--;
			if (y1 < 1)
			{
/*
				if (y2 > 0)
				{
					y1 = y2;
					y2 = 0;
					sr = sr2;
					sl = sl2;
				}
				else break;
*/
				break;
			}
		}
	}
}

//void G3DPolygon::DrawPolygon()
//{
//	Warp3D/W3D_DrawTriangle
//};

/*

void G3DPolygon::DrawPolygon()
{
	class G3DVector Line12(GVertex1, G3DVertex2);
	class G3DVector Line13(GVertex1, G3DVertex3);
	class G3DVector Line23(GVertex2, G3DVertex3);
	class G3DVertex LeftVertex, RightVertex;
//	W3D_Vertex LeftVertex, RightVertex;

	struct PolyDrawList
	{
		class G3DVector *LineLeft, *LineRight;
	};

	struct PolyDrawList PolyDrawList[2];

	UWORD Yloops[3];

	if (Line12.DeltaY == 0)
	{
		printf(",");
		if (Line12.DeltaX > 0)
		{
			PolyDrawList[0].LineLeft = Line13;
			PolyDrawList[0].LineRight = Line23;
			PolyDrawList[1].LineLeft = NULL;
			PolyDrawList[1].LineRight = NULL;
			GVertex1.CopyVertex(LeftVertex);
			GVertex2.CopyVertex(RightVertex);
//			CopyVertex(&Polygon->v1, &LeftVertex);
//			CopyVertex(&Polygon->v2, &RightVertex);
			Yloops[0] = Line23.DeltaY;
			Yloops[1] = 0;
		}
		else
		{
			PolyDrawList[0].LineLeft = &Line23;
			PolyDrawList[0].LineRight = &Line13;
			PolyDrawList[1].LineLeft = NULL;
			PolyDrawList[1].LineRight = NULL;
			GVertex2.CopyVertex(LeftVertex);
			GVertex1.CopyVertex(RightVertex);
//			CopyVertex(&Polygon->v2, &LeftVertex);
//			CopyVertex(&Polygon->v1, &RightVertex);
			Yloops[0] = Line23.DeltaY;
			Yloops[1] = 0;
		}
	}
	else
	{
		if ( (Line12.DeltaX / Line12.DeltaY) < (Line13.DeltaX / Line13.DeltaY) )
		{
			PolyDrawList[0].LineLeft = &Line12;
			PolyDrawList[0].LineRight = &Line13;
			PolyDrawList[1].LineLeft = &Line23;
			PolyDrawList[1].LineRight = &Line13;

			GVertex1.CopyVertex(LeftVertex);
			GVertex1.CopyVertex(RightVertex);
//			CopyVertex(&Polygon->v1, &LeftVertex);
//			CopyVertex(&Polygon->v1, &RightVertex);
			Yloops[0] = Line12.DeltaY;
			Yloops[1] = Line23.DeltaY;
			Yloops[2] = NULL;
		}
		else
		{
			PolyDrawList[0].LineLeft = &Line13;
			PolyDrawList[0].LineRight = &Line12;
			PolyDrawList[1].LineLeft = &Line13;
			PolyDrawList[1].LineRight = &Line23;
			GVertex1.CopyVertex(LeftVertex);
			GVertex1.CopyVertex(RightVertex);
//			CopyVertex(&Polygon->v1, &LeftVertex);
//			CopyVertex(&Polygon->v1, &RightVertex);
			Yloops[0] = Line12.DeltaY;
			Yloops[1] = Line23.DeltaY;
			Yloops[2] = NULL;
		}
	}

	class G3DVertex XLineX;
//	W3D_Vertex XlineX;


	class G3DVector VectorX = PolyDrawList[0].LineRight - PolyDrawList[0].LineLeft);

	ULONG *Tex = NULL;

	UWORD Ycount;
	UWORD Part = 0;

	while(Yloops[Part])
	{
		for (Ycount = Yloops[Part]; Ycount > 0; Ycount--)
		{
			LeftVertex->CopyVertex(XLineX);
//			CopyVertex(&LeftVertex, &XlineX);

			ULONG *Buffer = (ULONG *) ((ULONG)TempScreen->Own24BitPixelArray + ((UWORD)LeftVertex.y * GameScr->GetGamePic()->Width) + (UWORD)LeftVertex.x;
			WORD Xcount;
			for (Xcount = ((WORD)RightVertex.x - (WORD)LeftVertex.x); Xcount > 0; Xcount--)
			{
				Buffer[0] = Tex[(((WORD)XlineX.u)<<8)+(BYTE)XlineX.v];
				Buffer+=1;
				VectorX.UpdateVertex(&XlineX);
			}
			PolyDrawList[Part].LineLeft->UpdateVertex(&LeftVertex);
			PolyDrawList[Part].LineRight->UpdateVertex(&RightVertex);
		}
		Part++;
	}
}

*/

#endif /* GPOLYGON_CPP */
