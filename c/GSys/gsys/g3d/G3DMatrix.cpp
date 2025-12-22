
/* Author Anders Kjeldsen (partly) */

#ifndef G3DMATRIX_CPP
#define G3DMATRIX_CPP

#include "g3d/G3DMatrix.h"
#include "g3d/G3DQuat.cpp"

G3DMatrix::G3DMatrix()
{
	SetIdentity();
}

void G3DMatrix::SetIdentity()
{
	int i, j;
	for (i = 0; i < 4; i++)
	{
		for (j = 0; j < 4; j++)
		{
			if (i==j) Matrix[i][j] = 1.0;
			else Matrix[i][j] = 0.0;
		}
	}
}

void G3DMatrix::SetIdentity(float scale)
{
	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			if (i==j) Matrix[i][j] = scale;
			else Matrix[i][j] = 0.0;
		}
	}
}

void G3DMatrix::SetAsX(float AngleX)
{

	Matrix[1][1] = cos(AngleX);
	Matrix[1][2] = sin(AngleX);
	Matrix[2][1] = -(sin(AngleX));
	Matrix[2][2] = cos(AngleX);
}

void G3DMatrix::SetAsY(float AngleY)
{
	Matrix[0][0] = cos(AngleY);
	Matrix[0][2] = -(sin(AngleY));
	Matrix[2][0] = sin(AngleY);
	Matrix[2][2] = cos(AngleY);
}

void G3DMatrix::SetAsZ(float AngleZ)
{
	Matrix[0][0] = cos(AngleZ);
	Matrix[0][1] = sin(AngleZ);
	Matrix[1][0] = -(sin(AngleZ));
	Matrix[1][1] = cos(AngleZ);
}

void G3DMatrix::SetPosition(float vx, float vy, float vz)
{
	Matrix[3][0] = vx;
	Matrix[3][1] = vy;
	Matrix[3][2] = vz;
}

void G3DMatrix::operator=(G3DMatrix &m)
{
	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			Matrix[i][j] = m.Matrix[i][j];
		}
	}
}

void G3DMatrix::PrintfAll()
{
	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			//Matrix[i][j] = m.Matrix[i][j];
			printf("%f\t", Matrix[i][j]);
		}
		printf("\n");
	}
}

//G3DMatrix G3DMatrix::operator = (GQuat &b)
void G3DMatrix::operator=(GQuat &b)
{
	SetIdentity();

	float sqrt2 = 1.4142136f;

	float x = sqrt2*b.x;
	float y = sqrt2*b.y;
	float z = sqrt2*b.z;
	float w = sqrt2*b.w;

	float xx = x*x;
	float yy = y*y;
	float zz = z*z;

	float xy = x*y;
	float xz = x*z;
	float yz = y*z;
	float wx = w*x;
	float wy = w*y;
	float wz = w*z;

	Matrix[0][0] = 1-yy-zz;
	Matrix[0][1] = xy-wz;
	Matrix[0][2] = xz+wy;

	Matrix[1][0] = xy+wz;
	Matrix[1][1] = 1-xx-zz;
	Matrix[1][2] = yz-wx;

	Matrix[2][0] = xz-wy;
	Matrix[2][1] = yz-wx;
	Matrix[2][2] = 1-xx-yy;

}

G3DMatrix operator*(class G3DMatrix &a, class G3DMatrix &b)
{
	class G3DMatrix d;

	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			d.Matrix[i][j] = a.Matrix[0][j] * b.Matrix[i][0] +
					 a.Matrix[1][j] * b.Matrix[i][1] +
					 a.Matrix[2][j] * b.Matrix[i][2] +
					 a.Matrix[3][j] * b.Matrix[i][3];
		}
	}

	return d;
}

#endif /* GMATRIXMET */