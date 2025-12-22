
/* Author Anders Kjeldsen */

#ifndef G3DMATRIX_H
#define G3DMATRIX_H

#include "g3d/G3DQuat.h"

class G3DMatrix
{
public:
	G3DMatrix();
	~G3DMatrix() {};

	void SetIdentity();
	void SetIdentity(float scale);
	void SetAsX(float AngleX);
	void SetAsY(float AngleY);
	void SetAsZ(float AngleZ);
	void SetPosition(float vx, float vy, float vz);

	void PrintfAll();

//	G3DMatrix operator = (GQuat &b);
	void operator=(G3DMatrix &m);
	void operator=(GQuat &b);
//	G3DMatrix operator*(G3DMatrix &a, G3DMatrix &b);

	float Matrix[4][4];

private:

};

#endif /* GMATRIX_H */


