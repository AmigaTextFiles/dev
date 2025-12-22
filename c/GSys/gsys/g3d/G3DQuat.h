
/* Author Anders Kjeldsen */

#ifndef G3DQUAT
#define G3DQUAT

class G3DQuat
{
public:
	G3DQuat();
	G3DQuat(float rx, float ry, float rz);
	~G3DQuat() {};

	void Set(float rx, float ry, float rz);
	void Set();

	void PrintfAll();


//	G3DQuat operator*(GQuat &a,GQuat &b);
//	void operator*(GQuat &b);

	float x,y,z,w;
private:
};

#endif /* G3DQUAT */