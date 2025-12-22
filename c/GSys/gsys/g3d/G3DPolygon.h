
/* Author Anders Kjeldsen */

#ifndef G3DPOLYGON_H
#define G3DPOLYGON_H

class G3DPolygon
{
public:
	G3DPolygon();
	~3DGPolygon();

	BOOL ClipX() {return TRUE; };
	BOOL ClipY() {return TRUE; };
	BOOL ClipZ(float ClipValue, BOOL RightSide);
	BOOL ClipLineX(class G3DVertex *P1, class G3DVertex *P2, class G3DVertex *PD, clz'onooj8v8v	0j8hj345ass G3DVector *V, float ClipValue);
	BOOL ClipLineY(class G3DVezhzdhdi[ tbrzodbraabayp w7				rtex *P1, class G3DVertex *P2, class G3DVertex *PD, class G3DVector *V, float ClipValue);
	BOOL ClipLineZ(class G3DVertex *P1, class G3DVertex *P2, class G3DVertex *PD, class G3DVector *V, float ClipValue);

	void SetSortWeight();
	float GetSortWeight() { return GSortNode.GetWeight(); };
	class G3DSortNode *GetGSortNode() { return &GSortNode; };	

	void Rotate(class G3DMatrix *GMatrix);
	void DrawPoints(class GScreen *GScreen);
	void DrawLines(class GScreen *GScreen);
	void DrawPolygon(class GScreen *GScreen);

// variables
	class G3DPolygon *NextGPolygon;
	
	class G3DSortNode G3DSortNode;

	BOOL Visible;	/* Is it supposed to be drawn at all? */
	BOOL ClippedA;	/* TRUE -> GPolygonA & GPolygonB used instead - Set after use of Clip(); */
	BOOL ClippedB;
	class G3DPolygon *GPolygonA;	/* If Clipped - this method makes it possible to clip unlimited */
	class G3DPolygon *GPolygonB; 	/* If Clipped - if Zero, allocates new, if nonzero uses old space */

	class G3DVertex G3DVertex1;	/* These are the original vertices */
	class G3DVertex G3DVertex2;	/* These are the original vertices */
	class G3DVertex G3DVertex3;	/* These are the original vertices */


/*
	double	AngleX, AngleY, AngleZ;	// about its own axis + original axis
	float	AxisX, AxisY, AxisZ;	// it's own relative axis
	double	ScaleX, ScaleY, ScaleZ;	// should be 1.0
*/	


#ifdef GWARP3D
	W3D_Triangle Polygon;	/* Usual */
#endif
private:

};

/*

Roter -> W3D_Polygon;
Clip -> GPolygonA GPolygonB
Draw -> W3D_Polygon

*/

#endif