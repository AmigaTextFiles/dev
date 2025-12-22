#ifndef __VECMAT_H
#define __VECMAT_H

/*
** Basic vector and matrix stuff
** Modelled after, but not copied from, Descent.
** Thanks for the inspiration ;-)
**
** Targeted at 68o4o and 68o6o, hence uses floats.
*/

typedef struct {
	float x,y,z;
} vm_vector;

typedef struct {
	float xzy[3];
} vm_vector_array;

typedef struct {
	float a[3][3];
} vm_matrix;

#define IS_VEC_ZERO(vec) (vec)->x == 0.0 && (vec)->y == 0.0 && (vec)->z == 0.0
#define vm_vec_zero(vec) (vec)->x = (vec)->y = (vec)->z = 0.0
#define vm_mat_identity(m) do {\
		(m)->a[0][0] = (m)->a[1][1] = (m)->a[2][2] = 1.0;\
		(m)->a[0][1] = (m)->a[0][2] = (m)->a[1][0] = (m)->a[1][2] = \
		(m)->a[2][0] = (m)->a[2][1] = 0.0; } while (0)
#define vm_vec_neg(v) do { (v)->x = - (v)->x;(v)->y = - (v)->y; (v)->z = - (v)->z; } while (0)

#define vm_vec_add_to(to,frm) do {\
	(to)->x += (frm)->x; \
	(to)->y += (frm)->y; \
	(to)->z += (frm)->z; } while (0)

#define vm_vec_add(to,src0, src1) do {\
	(to)->x = (src0)->x + (src1)->x; \
	(to)->y = (src0)->y + (src1)->y; \
	(to)->z = (src0)->z + (src1)->z; } while (0);

#define vm_vec_sub_from(to,frm) do {\
	(to)->x -= (frm)->x; \
	(to)->y -= (frm)->y; \
	(to)->z -= (frm)->z; } while (0)

#define vm_vec_sub(to,src0, src1) do {\
	(to)->x = (src0)->x - (src1)->x; \
	(to)->y = (src0)->y - (src1)->y; \
	(to)->z = (src0)->z - (src1)->z; } while (0);

#define vm_vec_scale(v,lambda) do {\
	(v)->x *= lambda; \
	(v)->y *= lambda; \
	(v)->z *= lambda; } while (0);

#define vm_vec_dot(v,w) (v)->x * (w)->x + (v)->y * (w)->y + (v)->z * (w)->z

#define vm_vec_cross(to,v,w) do { \
	(to)->x = (v)->y * (w)->z - (v)->z * (w)->y; \
	(to)->y = (v)->x * (w)->z - (v)->z * (w)->x; \
	(to)->z = (v)->x * (w)->y - (v)->y * (w)->x; } while (0)

#define vm_M(mat,i,j) ((mat)->a[i][j])

#define vm_mat_x_vec(to,mat,vec) do { \
	(to)->x = vm_M(mat,0,0)*(vec)->x + vm_M(mat,0,1)*(vec)->y + vm_M(mat,0,2)*(vec)->z; \
	(to)->y = vm_M(mat,1,0)*(vec)->x + vm_M(mat,1,1)*(vec)->y + vm_M(mat,1,2)*(vec)->z; \
	(to)->z = vm_M(mat,2,0)*(vec)->x + vm_M(mat,2,1)*(vec)->y + vm_M(mat,2,2)*(vec)->z; } while (0)

#define vm_mat_set(mat,j,b,c,d,e,f,g,h,i) do {\
	(mat)->a[0][0] = j; (mat)->a[0][1] = b;  (mat)->a[0][2] = c; \
	(mat)->a[1][0] = d; (mat)->a[1][1] = e;  (mat)->a[1][2] = f; \
	(mat)->a[2][0] = g; (mat)->a[2][1] = h;  (mat)->a[2][2] = i; } while (0)


void vm_mat_x_mat(vm_matrix* out, vm_matrix* a, vm_matrix* b);
void vm_make_camera_mat(vm_matrix* cam, float el, float az);

#endif
