#define MAX 20
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define EPS 1e-10

class Matrix
{
	public:
	int m,n;
	float **koff;
	Matrix(float **,int,int);
	Matrix(int);
	Matrix(int,int);
	Matrix(const Matrix&);
	Matrix(const Matrix&,int,int);
	Matrix();
	~Matrix();
	Matrix&	 operator = (const Matrix& );
	Matrix operator[](int);
	int operator ==(const Matrix& );
	int operator !=(const Matrix& );
	void print();
	void read();
};

Matrix T(const Matrix & );
Matrix I(int);
float **alloc(int,int);
void dealloc(float **,int);
int Matrix::operator == (const Matrix&);
int Matrix::operator != (const Matrix&);
Matrix::Matrix(float **,int,int);
Matrix::Matrix(int,int);
Matrix::Matrix(int);
Matrix::Matrix(const Matrix&);
Matrix::Matrix(const Matrix&,int,int);
Matrix::~Matrix();
Matrix& Matrix::operator = (const Matrix&);
Matrix operator + (const Matrix& ,const Matrix& );
Matrix operator * (float,const Matrix& );
Matrix operator * (const Matrix& ,float);
Matrix operator * (const Matrix& ,const Matrix& );
void Matrix::read();
void Matrix::print();
Matrix gauss(const Matrix& );
Matrix solve(const Matrix& ,const Matrix&);
Matrix operator / (const Matrix&,const Matrix& );
Matrix e(int,int);
Matrix inv(const Matrix& );
Matrix operator / (const Matrix & ,const Matrix & );
Matrix operator /(const float x,const Matrix& );
Matrix operator /(const Matrix& ,const float);
Matrix eigen(const Matrix &);
float det(const Matrix&);
void LR(const Matrix &,Matrix &,Matrix &);
