
/* Author Anders Kjeldsen */

#ifndef G3DOBJECT_CPP
#define G3DOBJECT_CPP

#include "g3d/G3DObject.h"
#include "ggraphics/GScreen.cpp"
#include "g3d/G3DPolygon.cpp"
#include "g3d/G3DQuat.cpp"

int teller, teller2 = NULL;

GObject::GObject(STRPTR FileName)
{
	class GBuffer *OldObject = new GBuffer(FileName);

	APTR ObjectBuffer = OldObject->LockBuf();
	
	if ( ((ULONG *)ObjectBuffer)[2] == (ULONG) ((ULONG *)"LWOB")[0] )
	{
		/* LIGHTWAVE */

		class GChunkHandler *LwHandler = new GChunkHandler(ObjectBuffer, SIZELONG, SIZELONG, FALSE);

		float *PNTS;
		WORD *POLS;
		ULONG POLS_SIZE;
		WORD *POLS_END;

		if (LwHandler)
		{
			LwHandler->EnterChunk();
			LwHandler->Adjust(4);
			LwHandler->FindChunk("PNTS", SIZELONG);
			PNTS = (float *) LwHandler->EnterChunk();
			LwHandler->ParentChunk();

			LwHandler->ParentChunk();
			LwHandler->EnterChunk();
			LwHandler->Adjust(4);
			LwHandler->FindChunk("POLS", SIZELONG);

			POLS_SIZE = LwHandler->GetSIZE();
			POLS_END = (WORD *)LwHandler->GetEND();
			POLS = (WORD *)LwHandler->EnterChunk();

//			printf("POLS (first) %x\n", (ULONG)POLS );
//			printf("Size 2: %d\n", (ULONG)POLS_END );

			class G3DPolygon *CurrentPoly = new G3DPolygon;
			GPolygons = CurrentPoly;	// first entry in poly-linked-list
			class G3DPolygon *PrevPoly = NULL;
			BOOL out = FALSE;	

			while ( (POLS < POLS_END) && !out )
			{
				UWORD Point1 = POLS[1];
				UWORD Point2, Point3;
				UWORD Loop = POLS[0] - 2;
				POLS+=2;
				if (Loop>1)
				{
//					printf("POLS %x\t POLS_END %x\n", (int)POLS, (int)POLS_END );
//					printf("Hey, LOOP>1 !\n");
					out = TRUE;
				}
				while (Loop==1)
				{
//					printf("%d", Loop);
					Point2 = POLS[0];
					Point3 = POLS[1];

//					printf("Polygon #%x\n", teller/(sizeof (class G3DPolygon)) );
					CurrentPoly->GVertex1.X = PNTS[(Point1*3)];
					CurrentPoly->GVertex1.Y = PNTS[(Point1*3)+1];
					CurrentPoly->GVertex1.Z = (double)PNTS[(Point1*3)+2];
					CurrentPoly->GVertex2.X = PNTS[(Point2*3)];
					CurrentPoly->GVertex2.Y = PNTS[(Point2*3)+1];
					CurrentPoly->GVertex2.Z = (double)PNTS[(Point2*3)+2];
					CurrentPoly->GVertex3.X = PNTS[(Point3*3)];
					CurrentPoly->GVertex3.Y = PNTS[(Point3*3)+1];
					CurrentPoly->GVertex3.Z = (double)PNTS[(Point3*3)+2];

//					CurrentPoly->GVertex1.PrintfAll();
//					CurrentPoly->GVertex2.PrintfAll();
//					CurrentPoly->GVertex3.PrintfAll();
//					printf("\n");
					POLS+=1;

					PrevPoly = CurrentPoly;
					CurrentPoly = new G3DPolygon();
					PrevPoly->NextGPolygon = CurrentPoly;

					teller+= sizeof (class G3DPolygon);
					Loop--;
				}
				POLS+=1;

				if (POLS[0] > 0) // then no DETAIL POLYGON(s)
				{	
					POLS+=1;
				}
				else
				{
					POLS+=1;
					UWORD DPOLS = POLS[0];
					POLS+=1;	// ON A DPOL or on next
					while (DPOLS)
					{
						POLS+=POLS[0]+1;	// x+surface data
						DPOLS--;
					}
				}

				teller2++;
			}
			if (PrevPoly) PrevPoly->NextGPolygon = NULL;
			if (CurrentPoly) delete CurrentPoly;	// Made one too many

			printf("Rakk å telle %d polys\n", teller2);

			LwHandler->ParentChunk();
			LwHandler->ParentChunk();
			LwHandler->EnterChunk();
			LwHandler->Adjust(4);	// back at start
		}
	}
	OldObject->UnLockBuf();

	printf("GPolygon size %d\n", (int) sizeof (class G3DPolygon));
	printf("total %d\n", teller);
	printf("total %d\n", teller2);
}

void G3DObject::ClipPolygons(class GScreen *GScreen)
{
	class G3DPolygon *CurrentGPolygon = G3DPolygons;
	while (CurrentGPolygon)
	{
		CurrentGPolygon->ClipZ(1.0, HIGHER);
//draw lines

		if (CurrentGPolygon->GPolygonA && CurrentGPolygon->ClippedA)
		{
			CurrentGPolygon->GPolygonA->DrawLines(GScreen);
		}
		if (CurrentGPolygon->GPolygonB  && CurrentGPolygon->ClippedB)
		{
			CurrentGPolygon->GPolygonB->DrawLines(GScreen);
		}
		if ( !(CurrentGPolygon->ClippedA | CurrentGPolygon->ClippedB) )
		{
			CurrentGPolygon->DrawLines(GScreen);
		}

		CurrentGPolygon = CurrentGPolygon->NextGPolygon;
	}
}

void G3DObject::SetDirection(float Ax, float Ay, float Az)
{
	ObjQuat.Set(Ax, Ay, Az);
}

void G3DObject::SetPosition(double px, double py, double pz)
{
	AxisX = px;
	AxisY = py;
	AxisZ = pz;
}

void G3DObject::AddPosition(double px, double py, double pz)
{
	AxisX += px;
	AxisY += py;
	AxisZ += pz;
}

void G3DObject::AddDirection(float Ax, float Ay, float Az)
{
	DiffQuat.Set(Ax, Ay, Az);
	ObjQuat = DiffQuat * ObjQuat;
}


void G3DObject::Rotate(class G3DCamera *GCamera)
{
	class G3DPolygon *CurrentGPolygon = GPolygons;

	class G3DMatrix ObjMatrix, YMatrix, ZMatrix, TMatrix;
//	ObjMatrix = ObjQuat;

	ObjMatrix.SetAsX(Anglex);
	YMatrix.SetAsY(Angley);
	ZMatrix.SetAsZ(Anglez);
	TMatrix.SetPosition(AxisX, AxisY, AxisZ);

//	printf("angles %f %f %f\n", Anglex, Angley, Anglez);
	ObjMatrix = TMatrix * ObjMatrix * YMatrix * ZMatrix;

//	class G3DMatrix IdMatrix;
//	IdMatrix.SetIdentity(320.0);	// 320
//	ObjMatrix = ObjMatrix * IdMatrix;

//	printf("Object Quat\n");
//	ObjQuat.PrintfAll();

//	printf("Object Matrix \n");
//	ObjMatrix.PrintfAll();

	ObjMatrix.SetPosition(AxisX-GCamera->GetAxisX(), G3DCamera->GetAxisY(), G3DCamera->GetAxisZ() );
	class G3DMatrix EyeMatrix = ObjMatrix; //* G3DCamera->CamMatrix;

//	printf("Eye Matrix \n");
//	EyeMatrix.PrintfAll();


	while (CurrentGPolygon)
	{
		CurrentGPolygon->Rotate(&EyeMatrix);
//		CurrentGPolygon->DrawPoints(GScreen);
//		CurrentGPolygon->DrawLines(GScreen);
		CurrentGPolygon = CurrentGPolygon->NextGPolygon;
	}
}

void G3DObject::SortPolygons()
{
	class G3DPolygon *CurrentGPolygon = GPolygons->NextGPolygon;
	GPolygons->SetSortWeight();

/*
	if (GPolygons->GPolygonA && GPolygons->ClippedA)
	{
		GPolygons->GPolygonA->DrawLines(GScreen);
	}
	if (GPolygons->GPolygonB  && GPolygons->ClippedB)
	{
		GPolygons->GPolygonB->DrawLines(GScreen);
	}
	if ( !(GPolygons->ClippedA | GPolygons->ClippedB) )
	{
		GPolygons->DrawLines(GScreen);
	}
*/

	while (CurrentGPolygon)
	{
		if (CurrentGPolygon->Visible)
		{
			CurrentGPolygon->SetSortWeight();
			float w = CurrentGPolygon->GetSortWeight();
//			GPolygons->GSortNode.InsertNode( &CurrentGPolygon->GSortNode );

/*
			if (CurrentGPolygon->GPolygonA && CurrentGPolygon->ClippedA)
			{
				CurrentGPolygon->GPolygonA->DrawLines(GScreen);
			}
			if (CurrentGPolygon->GPolygonB  && CurrentGPolygon->ClippedB)
			{
				CurrentGPolygon->GPolygonB->DrawLines(GScreen);
			}
			if ( !(CurrentGPolygon->ClippedA | CurrentGPolygon->ClippedB) )
			{
				CurrentGPolygon->DrawLines(GScreen);
			}
*/
		}
		CurrentGPolygon = CurrentGPolygon->NextGPolygon;
	}
}

void G3DObject::DrawPolygons()
{
	class G3DPolygon *CurrentGPolygon = GPolygons->NextGPolygon;

	while (CurrentGPolygon)
	{
		if (CurrentGPolygon->Visible)
		{
			CurrentGPolygon->DrawPolygon(GScreen);
		}
		CurrentGPolygon = CurrentGPolygon->NextGPolygon;
	}
}


#endif /* G3DOBJECT_CPP */