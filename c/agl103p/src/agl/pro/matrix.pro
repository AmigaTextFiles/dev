/* matrix.c */
void init_matrices(void);
void reset_matrix_pointers(void);
void pushmatrix(void);
void popmatrix(void);
void mmode(short mode);
long getmmode(void);
void getmatrix(Matrix  m);
void loadmatrix(Matrix  m);
void multmatrix(Matrix  m);
long is_one_to_one(Matrix m);
void perspective(long angle,float aspect,float near,float far);
void ortho(float left,float right,float bottom,float top,float near,float far);
void ortho2(float left,float right,float bottom,float top);
void viewport(Screencoord left,Screencoord right,Screencoord bottom,Screencoord top);
long viewport_aligned(void);
void v2i(long lvert[2]);
void v3i(long lvert[3]);
void v2s(short svert[2]);
void v3s(short svert[3]);
void v2f(float fvert2[2]);
void v3f(float vert[3]);
void translate(float fx,float fy,float fz);
void rot(float angle,long axis);
void scale(float sx,float sy,float sz);

