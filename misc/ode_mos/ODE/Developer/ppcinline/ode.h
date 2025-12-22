/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_ODE_H
#define _PPCINLINE_ODE_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef ODE_BASE_NAME
#define ODE_BASE_NAME ODEBase
#endif /* !ODE_BASE_NAME */

#define dJointGetHinge2Anchor(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1870))(__t__p0, __t__p1));\
	})

#define dMassSetCylinderTotal(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , int , dReal , dReal ))*(void**)(__base - 730))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dCreateRay(__p0, __p1) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dSpaceID , dReal ))*(void**)(__base - 274))(__t__p0, __t__p1));\
	})

#define dInvertPDMatrix(__p0, __p1, __p2) \
	({ \
		const dReal * __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(const dReal *, dReal *, int ))*(void**)(__base - 820))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomRaySetParams(__p0, __p1, __p2) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , int , int ))*(void**)(__base - 304))(__t__p0, __t__p1, __t__p2));\
	})

#define dBodySetGravityMode(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , int ))*(void**)(__base - 1516))(__t__p0, __t__p1));\
	})

#define dGeomBoxGetLengths(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dVector3 ))*(void**)(__base - 214))(__t__p0, __t__p1));\
	})

#define dHashSpaceSetLevels(__p0, __p1, __p2) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dSpaceID , int , int ))*(void**)(__base - 436))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomTriMeshDataDestroy(__p0) \
	({ \
		dTriMeshDataID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dTriMeshDataID ))*(void**)(__base - 502))(__t__p0));\
	})

#define dGeomTriMeshDataBuildSimple1(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		dTriMeshDataID  __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		const int * __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		const int * __t__p5 = __p5;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dTriMeshDataID , const dReal *, int , const int *, int , const int *))*(void**)(__base - 544))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define dMassSetBox(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , dReal , dReal , dReal ))*(void**)(__base - 736))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dClearUpperTriangle(__p0, __p1) \
	({ \
		dReal * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, int ))*(void**)(__base - 982))(__t__p0, __t__p1));\
	})

#define dBodyAddRelForce(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1366))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointGetUniversalAnchor2(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1924))(__t__p0, __t__p1));\
	})

#define dSolveCholesky(__p0, __p1, __p2) \
	({ \
		const dReal * __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(const dReal *, dReal *, int ))*(void**)(__base - 814))(__t__p0, __t__p1, __t__p2));\
	})

#define dJointGetAMotorAxis(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dVector3  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int , dVector3 ))*(void**)(__base - 1978))(__t__p0, __t__p1, __t__p2));\
	})

#define dBodyAddRelForceAtRelPos(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dReal  __t__p5 = __p5;\
		dReal  __t__p6 = __p6;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dReal , dReal , dReal ))*(void**)(__base - 1396))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define dJointSetAMotorAxis(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dReal  __t__p5 = __p5;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int , int , dReal , dReal , dReal ))*(void**)(__base - 1768))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define dRfromQ(__p0, __p1) \
	({ \
		dMatrix3  __t__p0 = __p0;\
		const dQuaternion  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMatrix3 , const dQuaternion ))*(void**)(__base - 2110))(__t__p0, __t__p1));\
	})

#define dTimerEnd() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)())*(void**)(__base - 2164))());\
	})

#define dGeomPlaneGetParams(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dVector4  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dVector4 ))*(void**)(__base - 238))(__t__p0, __t__p1));\
	})

#define dRFromEulerAngles(__p0, __p1, __p2, __p3) \
	({ \
		dMatrix3  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMatrix3 , dReal , dReal , dReal ))*(void**)(__base - 2056))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dBodyGetRotation(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dBodyID ))*(void**)(__base - 1318))(__t__p0));\
	})

#define dMassTranslate(__p0, __p1, __p2, __p3) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , dReal , dReal ))*(void**)(__base - 754))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGeomPlaneSetParams(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal , dReal , dReal , dReal ))*(void**)(__base - 232))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dJointGetUniversalParam(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID , int ))*(void**)(__base - 1942))(__t__p0, __t__p1));\
	})

#define dJointGetHinge2Anchor2(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1876))(__t__p0, __t__p1));\
	})

#define dSpaceClean(__p0) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dSpaceID ))*(void**)(__base - 478))(__t__p0));\
	})

#define dCreateTriMesh(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dTriMeshDataID  __t__p1 = __p1;\
		dTriCallback * __t__p2 = __p2;\
		dTriArrayCallback * __t__p3 = __p3;\
		dTriRayCallback * __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dSpaceID , dTriMeshDataID , dTriCallback *, dTriArrayCallback *, dTriRayCallback *))*(void**)(__base - 586))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dGeomBoxPointDepth(__p0, __p1, __p2, __p3) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dGeomID , dReal , dReal , dReal ))*(void**)(__base - 220))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointAddAMotorTorques(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1792))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGeomGetBody(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dBodyID (*)(dGeomID ))*(void**)(__base - 52))(__t__p0));\
	})

#define dLDLTAddTL(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dReal * __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		const dReal * __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, dReal *, const dReal *, int , int ))*(void**)(__base - 862))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dSpaceCollide2(__p0, __p1, __p2, __p3) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dGeomID  __t__p1 = __p1;\
		void * __t__p2 = __p2;\
		dNearCallback * __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dGeomID , void *, dNearCallback *))*(void**)(__base - 172))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointSetUniversalParam(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int , dReal ))*(void**)(__base - 1744))(__t__p0, __t__p1, __t__p2));\
	})

#define dWorldSetAutoDisableFlag(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , int ))*(void**)(__base - 1186))(__t__p0, __t__p1));\
	})

#define dMassAdd(__p0, __p1) \
	({ \
		dMass * __t__p0 = __p0;\
		const dMass * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, const dMass *))*(void**)(__base - 766))(__t__p0, __t__p1));\
	})

#define dGeomGetPosition(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dGeomID ))*(void**)(__base - 76))(__t__p0));\
	})

#define dJointAddSliderForce(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal ))*(void**)(__base - 1690))(__t__p0, __t__p1));\
	})

#define dJointGroupEmpty(__p0) \
	({ \
		dJointGroupID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointGroupID ))*(void**)(__base - 1600))(__t__p0));\
	})

#define dFactorCholesky(__p0, __p1) \
	({ \
		dReal * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dReal *, int ))*(void**)(__base - 808))(__t__p0, __t__p1));\
	})

#define dBodyCreate(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dBodyID (*)(dWorldID ))*(void**)(__base - 1258))(__t__p0));\
	})

#define dJointGetHinge2Axis1(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1882))(__t__p0, __t__p1));\
	})

#define dJointGetHinge2Axis2(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1888))(__t__p0, __t__p1));\
	})

#define dGetAllocHandler() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dAllocFunction *(*)())*(void**)(__base - 898))());\
	})

#define dGeomTriMeshSetRayCallback(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dTriRayCallback * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dTriRayCallback *))*(void**)(__base - 574))(__t__p0, __t__p1));\
	})

#define dJointCreateAMotor(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID ))*(void**)(__base - 1576))(__t__p0, __t__p1));\
	})

#define dBodySetMass(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		const dMass * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , const dMass *))*(void**)(__base - 1342))(__t__p0, __t__p1));\
	})

#define dGeomGetQuaternion(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dQuaternion  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dQuaternion ))*(void**)(__base - 88))(__t__p0, __t__p1));\
	})

#define dWorldSetAutoDisableTime(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1174))(__t__p0, __t__p1));\
	})

#define dWorldSetAutoDisableSteps(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , int ))*(void**)(__base - 1162))(__t__p0, __t__p1));\
	})

#define dSetErrorHandler(__p0) \
	({ \
		dMessageFunction * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMessageFunction *))*(void**)(__base - 634))(__t__p0));\
	})

#define dBodyGetNumJoints(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dBodyID ))*(void**)(__base - 1486))(__t__p0));\
	})

#define dGeomRayGetLength(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dGeomID ))*(void**)(__base - 286))(__t__p0));\
	})

#define dIsPositiveDefinite(__p0, __p1) \
	({ \
		const dReal * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(const dReal *, int ))*(void**)(__base - 826))(__t__p0, __t__p1));\
	})

#define dJointGetUniversalAnchor(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1918))(__t__p0, __t__p1));\
	})

#define dWorldGetQuickStepW(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dWorldID ))*(void**)(__base - 1084))(__t__p0));\
	})

#define dGeomTriMeshDataBuildSimple(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dTriMeshDataID  __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		const int * __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dTriMeshDataID , const dReal *, int , const int *, int ))*(void**)(__base - 538))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dJointAddUniversalTorques(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal ))*(void**)(__base - 1750))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomSetQuaternion(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		const dQuaternion  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , const dQuaternion ))*(void**)(__base - 70))(__t__p0, __t__p1));\
	})

#define dBodySetLinearVel(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1300))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGeomTriMeshSetArrayCallback(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dTriArrayCallback * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dTriArrayCallback *))*(void**)(__base - 562))(__t__p0, __t__p1));\
	})

#define dBodyGetFiniteRotationMode(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dBodyID ))*(void**)(__base - 1474))(__t__p0));\
	})

#define dGeomSetCollideBits(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		unsigned long  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , unsigned long ))*(void**)(__base - 124))(__t__p0, __t__p1));\
	})

#define dGeomRaySetLength(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal ))*(void**)(__base - 280))(__t__p0, __t__p1));\
	})

#define dWorldStep(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1048))(__t__p0, __t__p1));\
	})

#define dWorldSetQuickStepW(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1078))(__t__p0, __t__p1));\
	})

#define dBodySetForce(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1414))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dRFrom2Axes(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		dMatrix3  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dReal  __t__p5 = __p5;\
		dReal  __t__p6 = __p6;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMatrix3 , dReal , dReal , dReal , dReal , dReal , dReal ))*(void**)(__base - 2062))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define dWorldSetCFM(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1036))(__t__p0, __t__p1));\
	})

#define dBodyGetAutoDisableSteps(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dBodyID ))*(void**)(__base - 1216))(__t__p0));\
	})

#define dMassSetSphereTotal(__p0, __p1, __p2) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , dReal ))*(void**)(__base - 706))(__t__p0, __t__p1, __t__p2));\
	})

#define dWorldGetAutoDisableAngularThreshold(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dWorldID ))*(void**)(__base - 1144))(__t__p0));\
	})

#define dGeomSetData(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		void * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , void *))*(void**)(__base - 34))(__t__p0, __t__p1));\
	})

#define dBodySetFiniteRotationMode(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , int ))*(void**)(__base - 1462))(__t__p0, __t__p1));\
	})

#define dGeomTriMeshDataBuildSingle(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		dTriMeshDataID  __t__p0 = __p0;\
		const void * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		const void * __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		int  __t__p6 = __p6;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dTriMeshDataID , const void *, int , int , const void *, int , int ))*(void**)(__base - 514))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define dJointCreateUniversal(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID ))*(void**)(__base - 1558))(__t__p0, __t__p1));\
	})

#define dWorldGetQuickStepNumIterations(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dWorldID ))*(void**)(__base - 1072))(__t__p0));\
	})

#define dGeomRayGet(__p0, __p1, __p2) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		dVector3  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dVector3 , dVector3 ))*(void**)(__base - 298))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomRayGetClosestHit(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dGeomID ))*(void**)(__base - 322))(__t__p0));\
	})

#define dGeomTriMeshClearTCCache(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID ))*(void**)(__base - 610))(__t__p0));\
	})

#define dSpaceGetNumGeoms(__p0) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dSpaceID ))*(void**)(__base - 484))(__t__p0));\
	})

#define dGeomGetClassData(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void *(*)(dGeomID ))*(void**)(__base - 400))(__t__p0));\
	})

#define dGeomTransformSetCleanup(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , int ))*(void**)(__base - 346))(__t__p0, __t__p1));\
	})

#define dSolveLDLT(__p0, __p1, __p2, __p3, __p4) \
	({ \
		const dReal * __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		dReal * __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(const dReal *, const dReal *, dReal *, int , int ))*(void**)(__base - 856))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dBodyGetGravityMode(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dBodyID ))*(void**)(__base - 1522))(__t__p0));\
	})

#define dSpaceRemove(__p0, __p1) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dGeomID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dSpaceID , dGeomID ))*(void**)(__base - 466))(__t__p0, __t__p1));\
	})

#define dMassSetCylinder(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , int , dReal , dReal ))*(void**)(__base - 724))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dBodyAddRelTorque(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1372))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dWorldSetERP(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1024))(__t__p0, __t__p1));\
	})

#define dCreateGeom(__p0) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(int ))*(void**)(__base - 406))(__t__p0));\
	})

#define dWorldSetQuickStepNumIterations(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , int ))*(void**)(__base - 1066))(__t__p0, __t__p1));\
	})

#define dStopwatchReset(__p0) \
	({ \
		dStopwatch * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dStopwatch *))*(void**)(__base - 2128))(__t__p0));\
	})

#define dJointSetFixed(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID ))*(void**)(__base - 1756))(__t__p0));\
	})

#define dTimerTicksPerSecond() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)())*(void**)(__base - 2170))());\
	})

#define dGeomRaySetClosestHit(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , int ))*(void**)(__base - 316))(__t__p0, __t__p1));\
	})

#define dJointCreateHinge(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID ))*(void**)(__base - 1534))(__t__p0, __t__p1));\
	})

#define dJointGetHinge2Angle1Rate(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1906))(__t__p0));\
	})

#define dWorldSetContactSurfaceLayer(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1102))(__t__p0, __t__p1));\
	})

#define dRandGetSeed() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((unsigned long (*)())*(void**)(__base - 946))());\
	})

#define dGeomTriMeshGetTriMeshDataID(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dTriMeshDataID (*)(dGeomID ))*(void**)(__base - 616))(__t__p0));\
	})

#define dRSetIdentity(__p0) \
	({ \
		dMatrix3  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMatrix3 ))*(void**)(__base - 2044))(__t__p0));\
	})

#define dSpaceCollide(__p0, __p1, __p2) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		void * __t__p1 = __p1;\
		dNearCallback * __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dSpaceID , void *, dNearCallback *))*(void**)(__base - 166))(__t__p0, __t__p1, __t__p2));\
	})

#define dJointGetFeedback(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointFeedback *(*)(dJointID ))*(void**)(__base - 1642))(__t__p0));\
	})

#ifndef __cplusplus
#define dError(__p0, ...) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		(((void (*)(int , const char *, ...))*(void**)(__base - 670))(__t__p0, __VA_ARGS__,({__asm volatile("mr 12,%0": :"r"(__base):"r12");0L;})));\
	})
#endif

#define dSetFreeHandler(__p0) \
	({ \
		dFreeFunction * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dFreeFunction *))*(void**)(__base - 892))(__t__p0));\
	})

#define dJointGetBody(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dBodyID (*)(dJointID , int ))*(void**)(__base - 1630))(__t__p0, __t__p1));\
	})

#define dGeomDestroy(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID ))*(void**)(__base - 28))(__t__p0));\
	})

#define dMakeRandomMatrix(__p0, __p1, __p2, __p3) \
	({ \
		dReal * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, int , int , dReal ))*(void**)(__base - 976))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dTimerNow(__p0) \
	({ \
		const char * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(const char *))*(void**)(__base - 2158))(__t__p0));\
	})

#define dJointGetAMotorNumAxes(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dJointID ))*(void**)(__base - 1972))(__t__p0));\
	})

#define dGeomGetRotation(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dGeomID ))*(void**)(__base - 82))(__t__p0));\
	})

#define dJointAttach(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		dBodyID  __t__p1 = __p1;\
		dBodyID  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dBodyID , dBodyID ))*(void**)(__base - 1606))(__t__p0, __t__p1, __t__p2));\
	})

#define dSolveL1T(__p0, __p1, __p2, __p3) \
	({ \
		const dReal * __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(const dReal *, dReal *, int , int ))*(void**)(__base - 844))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGeomTransformSetInfo(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , int ))*(void**)(__base - 358))(__t__p0, __t__p1));\
	})

#define dBodyVectorFromWorld(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dVector3  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dVector3 ))*(void**)(__base - 1456))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dWorldGetAutoDisableLinearThreshold(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dWorldID ))*(void**)(__base - 1132))(__t__p0));\
	})

#define dBodySetAutoDisableFlag(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , int ))*(void**)(__base - 1246))(__t__p0, __t__p1));\
	})

#define dNormalize3(__p0) \
	({ \
		dVector3  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dVector3 ))*(void**)(__base - 2026))(__t__p0));\
	})

#define dJointSetSliderParam(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int , dReal ))*(void**)(__base - 1684))(__t__p0, __t__p1, __t__p2));\
	})

#define dCreatePlane(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dSpaceID , dReal , dReal , dReal , dReal ))*(void**)(__base - 226))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dNormalize4(__p0) \
	({ \
		dVector4  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dVector4 ))*(void**)(__base - 2032))(__t__p0));\
	})

#define dRand() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((unsigned long (*)())*(void**)(__base - 940))());\
	})

#define dJointGetAMotorAngleRate(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID , int ))*(void**)(__base - 1996))(__t__p0, __t__p1));\
	})

#define dJointSetAMotorAngle(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int , dReal ))*(void**)(__base - 1774))(__t__p0, __t__p1, __t__p2));\
	})

#define dWorldSetAutoDisableLinearThreshold(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1138))(__t__p0, __t__p1));\
	})

#define dSimpleSpaceCreate(__p0) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dSpaceID (*)(dSpaceID ))*(void**)(__base - 412))(__t__p0));\
	})

#define dAlloc(__p0) \
	({ \
		size_t  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void *(*)(size_t ))*(void**)(__base - 916))(__t__p0));\
	})

#define dWorldGetAutoDisableFlag(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dWorldID ))*(void**)(__base - 1180))(__t__p0));\
	})

#define dJointSetAMotorParam(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int , dReal ))*(void**)(__base - 1780))(__t__p0, __t__p1, __t__p2));\
	})

#define dSpaceAdd(__p0, __p1) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dGeomID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dSpaceID , dGeomID ))*(void**)(__base - 460))(__t__p0, __t__p1));\
	})

#define dBodySetAutoDisableTime(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal ))*(void**)(__base - 1234))(__t__p0, __t__p1));\
	})

#define dGeomTransformSetGeom(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dGeomID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dGeomID ))*(void**)(__base - 334))(__t__p0, __t__p1));\
	})

#define dVectorScale(__p0, __p1, __p2) \
	({ \
		dReal * __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, const dReal *, int ))*(void**)(__base - 850))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomTriMeshGetRayCallback(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dTriRayCallback *(*)(dGeomID ))*(void**)(__base - 580))(__t__p0));\
	})

#define dRemoveRowCol(__p0, __p1, __p2, __p3) \
	({ \
		dReal * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, int , int , int ))*(void**)(__base - 874))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dWorldGetAutoDisableTime(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dWorldID ))*(void**)(__base - 1168))(__t__p0));\
	})

#define dJointGroupCreate(__p0) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointGroupID (*)(int ))*(void**)(__base - 1588))(__t__p0));\
	})

#define dMassSetSphere(__p0, __p1, __p2) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , dReal ))*(void**)(__base - 700))(__t__p0, __t__p1, __t__p2));\
	})

#define dWorldGetAutoEnableDepthSF1(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dWorldID ))*(void**)(__base - 1126))(__t__p0));\
	})

#define dRandReal() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)())*(void**)(__base - 964))());\
	})

#define dJointSetData(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		void * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , void *))*(void**)(__base - 1612))(__t__p0, __t__p1));\
	})

#define dBoxTouchesBox(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		const dVector3  __t__p0 = __p0;\
		const dMatrix3  __t__p1 = __p1;\
		const dVector3  __t__p2 = __p2;\
		const dVector3  __t__p3 = __p3;\
		const dMatrix3  __t__p4 = __p4;\
		const dVector3  __t__p5 = __p5;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(const dVector3 , const dMatrix3 , const dVector3 , const dVector3 , const dMatrix3 , const dVector3 ))*(void**)(__base - 376))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define dBodyGetPosRelPoint(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dVector3  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dVector3 ))*(void**)(__base - 1444))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dBodyGetTorque(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dBodyID ))*(void**)(__base - 1408))(__t__p0));\
	})

#define dBodySetPosition(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1282))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dTimerStart(__p0) \
	({ \
		const char * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(const char *))*(void**)(__base - 2152))(__t__p0));\
	})

#define dBodyAddForceAtRelPos(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dReal  __t__p5 = __p5;\
		dReal  __t__p6 = __p6;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dReal , dReal , dReal ))*(void**)(__base - 1384))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define dBodyGetFiniteRotationAxis(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dVector3 ))*(void**)(__base - 1480))(__t__p0, __t__p1));\
	})

#define dWorldSetAutoEnableDepthSF1(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , int ))*(void**)(__base - 1120))(__t__p0, __t__p1));\
	})

#define dGeomGetCollideBits(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((unsigned long (*)(dGeomID ))*(void**)(__base - 136))(__t__p0));\
	})

#define dGeomSphereGetRadius(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dGeomID ))*(void**)(__base - 190))(__t__p0));\
	})

#define dGeomPlanePointDepth(__p0, __p1, __p2, __p3) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dGeomID , dReal , dReal , dReal ))*(void**)(__base - 244))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dBodySetTorque(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1420))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dQuadTreeSpaceCreate(__p0, __p1, __p2, __p3) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		dVector3  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dSpaceID (*)(dSpaceID , dVector3 , dVector3 , int ))*(void**)(__base - 424))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dWorldCreate() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dWorldID (*)())*(void**)(__base - 1000))());\
	})

#define dJointGetSliderPosition(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1846))(__t__p0));\
	})

#define dWorldGetCFM(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dWorldID ))*(void**)(__base - 1042))(__t__p0));\
	})

#define dBodySetFiniteRotationAxis(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1468))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointSetHinge2Param(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int , dReal ))*(void**)(__base - 1714))(__t__p0, __t__p1, __t__p2));\
	})

#define dGetReallocHandler() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReallocFunction *(*)())*(void**)(__base - 904))());\
	})

#define dJointGetUniversalAngle1Rate(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1960))(__t__p0));\
	})

#define dSpaceQuery(__p0, __p1) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dGeomID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dSpaceID , dGeomID ))*(void**)(__base - 472))(__t__p0, __t__p1));\
	})

#define dMassRotate(__p0, __p1) \
	({ \
		dMass * __t__p0 = __p0;\
		const dMatrix3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, const dMatrix3 ))*(void**)(__base - 760))(__t__p0, __t__p1));\
	})

#define dGeomSphereSetRadius(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal ))*(void**)(__base - 184))(__t__p0, __t__p1));\
	})

#define dGeomTransformGetCleanup(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dGeomID ))*(void**)(__base - 352))(__t__p0));\
	})

#define dSetReallocHandler(__p0) \
	({ \
		dReallocFunction * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReallocFunction *))*(void**)(__base - 886))(__t__p0));\
	})

#define dMassSetBoxTotal(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , dReal , dReal , dReal ))*(void**)(__base - 742))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dJointDestroy(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID ))*(void**)(__base - 1582))(__t__p0));\
	})

#define dWorldGetERP(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dWorldID ))*(void**)(__base - 1030))(__t__p0));\
	})

#define dSetDebugHandler(__p0) \
	({ \
		dMessageFunction * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMessageFunction *))*(void**)(__base - 640))(__t__p0));\
	})

#define dCreateCCylinder(__p0, __p1, __p2) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dSpaceID , dReal , dReal ))*(void**)(__base - 250))(__t__p0, __t__p1, __t__p2));\
	})

#define dWorldDestroy(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID ))*(void**)(__base - 1006))(__t__p0));\
	})

#define dJointCreateNull(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID ))*(void**)(__base - 1570))(__t__p0, __t__p1));\
	})

#define dBodySetData(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		void * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , void *))*(void**)(__base - 1270))(__t__p0, __t__p1));\
	})

#define dJointGetHinge2Angle1(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1900))(__t__p0));\
	})

#define dWorldSetGravity(__p0, __p1, __p2, __p3) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal , dReal , dReal ))*(void**)(__base - 1012))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dWorldGetContactSurfaceLayer(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dWorldID ))*(void**)(__base - 1108))(__t__p0));\
	})

#define dGeomTriMeshSetCallback(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dTriCallback * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dTriCallback *))*(void**)(__base - 550))(__t__p0, __t__p1));\
	})

#define dWorldSetContactMaxCorrectingVel(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1090))(__t__p0, __t__p1));\
	})

#define dGetFreeHandler() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dFreeFunction *(*)())*(void**)(__base - 910))());\
	})

#define dGeomSetCategoryBits(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		unsigned long  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , unsigned long ))*(void**)(__base - 118))(__t__p0, __t__p1));\
	})

#define dJointGetHinge2Angle2Rate(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1912))(__t__p0));\
	})

#define dSolveL1(__p0, __p1, __p2, __p3) \
	({ \
		const dReal * __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(const dReal *, dReal *, int , int ))*(void**)(__base - 838))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointSetHinge2Anchor(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1696))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGeomCCylinderGetParams(__p0, __p1, __p2) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		dReal * __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal *, dReal *))*(void**)(__base - 262))(__t__p0, __t__p1, __t__p2));\
	})

#define dStopwatchTime(__p0) \
	({ \
		dStopwatch * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)(dStopwatch *))*(void**)(__base - 2146))(__t__p0));\
	})

#define dCreateGeomClass(__p0) \
	({ \
		const dGeomClass * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(const dGeomClass *))*(void**)(__base - 394))(__t__p0));\
	})

#define dMakeRandomVector(__p0, __p1, __p2) \
	({ \
		dReal * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, int , dReal ))*(void**)(__base - 970))(__t__p0, __t__p1, __t__p2));\
	})

#define dBodyGetJoint(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dBodyID , int ))*(void**)(__base - 1492))(__t__p0, __t__p1));\
	})

#define dRFromZAxis(__p0, __p1, __p2, __p3) \
	({ \
		dMatrix3  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMatrix3 , dReal , dReal , dReal ))*(void**)(__base - 2068))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGeomCCylinderSetParams(__p0, __p1, __p2) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal , dReal ))*(void**)(__base - 256))(__t__p0, __t__p1, __t__p2));\
	})

#define dClosestLineSegmentPoints(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		const dVector3  __t__p0 = __p0;\
		const dVector3  __t__p1 = __p1;\
		const dVector3  __t__p2 = __p2;\
		const dVector3  __t__p3 = __p3;\
		dVector3  __t__p4 = __p4;\
		dVector3  __t__p5 = __p5;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(const dVector3 , const dVector3 , const dVector3 , const dVector3 , dVector3 , dVector3 ))*(void**)(__base - 370))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define dBodyGetAutoDisableFlag(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dBodyID ))*(void**)(__base - 1240))(__t__p0));\
	})

#define dJointGetSliderParam(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID , int ))*(void**)(__base - 1864))(__t__p0, __t__p1));\
	})

#define dBodyDestroy(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID ))*(void**)(__base - 1264))(__t__p0));\
	})

#define dInfiniteAABB(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal *))*(void**)(__base - 382))(__t__p0, __t__p1));\
	})

#define dJointGetAMotorAngle(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID , int ))*(void**)(__base - 1990))(__t__p0, __t__p1));\
	})

#define dJointAddHinge2Torques(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal ))*(void**)(__base - 1720))(__t__p0, __t__p1, __t__p2));\
	})

#define dLDLTRemove(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7) \
	({ \
		dReal ** __t__p0 = __p0;\
		const int * __t__p1 = __p1;\
		dReal * __t__p2 = __p2;\
		dReal * __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		int  __t__p6 = __p6;\
		int  __t__p7 = __p7;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal **, const int *, dReal *, dReal *, int , int , int , int ))*(void**)(__base - 868))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6, __t__p7));\
	})

#define dGeomTriMeshDataBuildSingle1(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7) \
	({ \
		dTriMeshDataID  __t__p0 = __p0;\
		const void * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		const void * __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		int  __t__p6 = __p6;\
		const void * __t__p7 = __p7;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dTriMeshDataID , const void *, int , int , const void *, int , int , const void *))*(void**)(__base - 520))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6, __t__p7));\
	})

#define dRealloc(__p0, __p1, __p2) \
	({ \
		void * __t__p0 = __p0;\
		size_t  __t__p1 = __p1;\
		size_t  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void *(*)(void *, size_t , size_t ))*(void**)(__base - 922))(__t__p0, __t__p1, __t__p2));\
	})

#define dJointGetUniversalAxis1(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1930))(__t__p0, __t__p1));\
	})

#define dJointSetAMotorNumAxes(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int ))*(void**)(__base - 1762))(__t__p0, __t__p1));\
	})

#define dJointGetUniversalAxis2(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1936))(__t__p0, __t__p1));\
	})

#define dQSetIdentity(__p0) \
	({ \
		dQuaternion  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dQuaternion ))*(void**)(__base - 2074))(__t__p0));\
	})

#define dJointGetAMotorParam(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID , int ))*(void**)(__base - 2002))(__t__p0, __t__p1));\
	})

#define dGeomTriMeshDataSet(__p0, __p1, __p2) \
	({ \
		dTriMeshDataID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		void * __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dTriMeshDataID , int , void *))*(void**)(__base - 508))(__t__p0, __t__p1, __t__p2));\
	})

#define dBodyGetAutoDisableTime(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dBodyID ))*(void**)(__base - 1228))(__t__p0));\
	})

#define dBodySetRotation(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		const dMatrix3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , const dMatrix3 ))*(void**)(__base - 1288))(__t__p0, __t__p1));\
	})

#define dAreConnected(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dBodyID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dBodyID , dBodyID ))*(void**)(__base - 2014))(__t__p0, __t__p1));\
	})

#define dJointGetBallAnchor2(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1804))(__t__p0, __t__p1));\
	})

#define dJointSetUniversalAxis1(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1732))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointSetUniversalAxis2(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1738))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dRandInt(__p0) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(int ))*(void**)(__base - 958))(__t__p0));\
	})

#define dGeomTriMeshDataCreate() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dTriMeshDataID (*)())*(void**)(__base - 496))());\
	})

#define dGeomGetSpace(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dSpaceID (*)(dGeomID ))*(void**)(__base - 106))(__t__p0));\
	})

#define dMassSetParameters(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7, __p8, __p9, __p10) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dReal  __t__p5 = __p5;\
		dReal  __t__p6 = __p6;\
		dReal  __t__p7 = __p7;\
		dReal  __t__p8 = __p8;\
		dReal  __t__p9 = __p9;\
		dReal  __t__p10 = __p10;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , dReal , dReal , dReal , dReal , dReal , dReal , dReal , dReal , dReal ))*(void**)(__base - 694))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6, __t__p7, __t__p8, __t__p9, __t__p10));\
	})

#define dBodyEnable(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID ))*(void**)(__base - 1498))(__t__p0));\
	})

#define dCreateGeomTransform(__p0) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dSpaceID ))*(void**)(__base - 328))(__t__p0));\
	})

#define dJointGetBallAnchor(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1798))(__t__p0, __t__p1));\
	})

#define dGeomTriMeshDataBuildDouble1(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7) \
	({ \
		dTriMeshDataID  __t__p0 = __p0;\
		const void * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		const void * __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		int  __t__p6 = __p6;\
		const void * __t__p7 = __p7;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dTriMeshDataID , const void *, int , int , const void *, int , int , const void *))*(void**)(__base - 532))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6, __t__p7));\
	})

#define dDQfromW(__p0, __p1, __p2) \
	({ \
		dReal * __t__p0 = __p0;\
		const dVector3  __t__p1 = __p1;\
		const dQuaternion  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, const dVector3 , const dQuaternion ))*(void**)(__base - 2122))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomSetBody(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dBodyID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dBodyID ))*(void**)(__base - 46))(__t__p0, __t__p1));\
	})

#define dFree(__p0, __p1) \
	({ \
		void * __t__p0 = __p0;\
		size_t  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(void *, size_t ))*(void**)(__base - 928))(__t__p0, __t__p1));\
	})

#define dBodyGetMass(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dMass * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dMass *))*(void**)(__base - 1348))(__t__p0, __t__p1));\
	})

#define dBodyGetAutoDisableLinearThreshold(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dBodyID ))*(void**)(__base - 1192))(__t__p0));\
	})

#define dJointGetHingeAxis(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1822))(__t__p0, __t__p1));\
	})

#define dWorldGetAutoDisableSteps(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dWorldID ))*(void**)(__base - 1156))(__t__p0));\
	})

#ifndef __cplusplus
#define dMessage(__p0, ...) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		(((void (*)(int , const char *, ...))*(void**)(__base - 682))(__t__p0, __VA_ARGS__,({__asm volatile("mr 12,%0": :"r"(__base):"r12");0L;})));\
	})
#endif

#define dJointSetBallAnchor(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1648))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGetErrorHandler() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dMessageFunction *(*)())*(void**)(__base - 652))());\
	})

#define dGeomSetPosition(__p0, __p1, __p2, __p3) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal , dReal , dReal ))*(void**)(__base - 58))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dSetZero(__p0, __p1) \
	({ \
		dReal * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, int ))*(void**)(__base - 772))(__t__p0, __t__p1));\
	})

#define dGeomTriMeshGetPoint(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dVector3  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , int , dReal , dReal , dVector3 ))*(void**)(__base - 628))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dBodySetAutoDisableLinearThreshold(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal ))*(void**)(__base - 1198))(__t__p0, __t__p1));\
	})

#define dJointGetHinge2Param(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID , int ))*(void**)(__base - 1894))(__t__p0, __t__p1));\
	})

#define dJointCreateBall(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID ))*(void**)(__base - 1528))(__t__p0, __t__p1));\
	})

#define dQFromAxisAndAngle(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dQuaternion  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dQuaternion , dReal , dReal , dReal , dReal ))*(void**)(__base - 2080))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dBodyGetQuaternion(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dBodyID ))*(void**)(__base - 1324))(__t__p0));\
	})

#define dTimerResolution() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((double (*)())*(void**)(__base - 2176))());\
	})

#define dRFromAxisAndAngle(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dMatrix3  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMatrix3 , dReal , dReal , dReal , dReal ))*(void**)(__base - 2050))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dJointGetUniversalAngle1(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1948))(__t__p0));\
	})

#define dSetAllocHandler(__p0) \
	({ \
		dAllocFunction * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dAllocFunction *))*(void**)(__base - 880))(__t__p0));\
	})

#define dJointGetUniversalAngle2(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1954))(__t__p0));\
	})

#define dSpaceDestroy(__p0) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dSpaceID ))*(void**)(__base - 430))(__t__p0));\
	})

#define dGeomDisable(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID ))*(void**)(__base - 148))(__t__p0));\
	})

#define dBodySetAutoDisableAngularThreshold(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal ))*(void**)(__base - 1210))(__t__p0, __t__p1));\
	})

#define dBodySetAutoDisableDefaults(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID ))*(void**)(__base - 1252))(__t__p0));\
	})

#define dBodySetQuaternion(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		const dQuaternion  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , const dQuaternion ))*(void**)(__base - 1294))(__t__p0, __t__p1));\
	})

#define dWorldQuickStep(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1060))(__t__p0, __t__p1));\
	})

#define dJointGetUniversalAngle2Rate(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1966))(__t__p0));\
	})

#define dGeomGetData(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void *(*)(dGeomID ))*(void**)(__base - 40))(__t__p0));\
	})

#define dGeomCCylinderPointDepth(__p0, __p1, __p2, __p3) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dGeomID , dReal , dReal , dReal ))*(void**)(__base - 268))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dHashSpaceCreate(__p0) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dSpaceID (*)(dSpaceID ))*(void**)(__base - 418))(__t__p0));\
	})

#define dJointCreateContact(__p0, __p1, __p2) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		const dContact * __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID , const dContact *))*(void**)(__base - 1546))(__t__p0, __t__p1, __t__p2));\
	})

#define dTestRand() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)())*(void**)(__base - 934))());\
	})

#define dJointGetType(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dJointID ))*(void**)(__base - 1624))(__t__p0));\
	})

#define dSetValue(__p0, __p1, __p2) \
	({ \
		dReal * __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, int , dReal ))*(void**)(__base - 778))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomTriMeshDataBuildDouble(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		dTriMeshDataID  __t__p0 = __p0;\
		const void * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		const void * __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		int  __t__p6 = __p6;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dTriMeshDataID , const void *, int , int , const void *, int , int ))*(void**)(__base - 526))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define dGeomTriMeshSetData(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dTriMeshDataID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dTriMeshDataID ))*(void**)(__base - 592))(__t__p0, __t__p1));\
	})

#define dMassSetCappedCylinderTotal(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , int , dReal , dReal ))*(void**)(__base - 718))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dWorldGetGravity(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dVector3 ))*(void**)(__base - 1018))(__t__p0, __t__p1));\
	})

#define dGeomSpherePointDepth(__p0, __p1, __p2, __p3) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dGeomID , dReal , dReal , dReal ))*(void**)(__base - 196))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dAreConnectedExcluding(__p0, __p1, __p2) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dBodyID  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dBodyID , dBodyID , int ))*(void**)(__base - 2020))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomEnable(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID ))*(void**)(__base - 142))(__t__p0));\
	})

#define dWorldGetContactMaxCorrectingVel(__p0) \
	({ \
		dWorldID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dWorldID ))*(void**)(__base - 1096))(__t__p0));\
	})

#define dBodySetAutoDisableSteps(__p0, __p1) \
	({ \
		dBodyID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , int ))*(void**)(__base - 1222))(__t__p0, __t__p1));\
	})

#define dJointSetHingeAnchor(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1654))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointGetHingeAngle(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1834))(__t__p0));\
	})

#define dQfromR(__p0, __p1) \
	({ \
		dQuaternion  __t__p0 = __p0;\
		const dMatrix3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dQuaternion , const dMatrix3 ))*(void**)(__base - 2116))(__t__p0, __t__p1));\
	})

#define dGeomTriMeshGetTriangle(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dVector3 * __t__p2 = __p2;\
		dVector3 * __t__p3 = __p3;\
		dVector3 * __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , int , dVector3 *, dVector3 *, dVector3 *))*(void**)(__base - 622))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dCollide(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dGeomID  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		dContactGeom * __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dGeomID , dGeomID , int , dContactGeom *, int ))*(void**)(__base - 160))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dBodyGetAngularVel(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dBodyID ))*(void**)(__base - 1336))(__t__p0));\
	})

#define dGeomRaySet(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dReal  __t__p5 = __p5;\
		dReal  __t__p6 = __p6;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal , dReal , dReal , dReal , dReal , dReal ))*(void**)(__base - 292))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define dSpaceSetCleanup(__p0, __p1) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dSpaceID , int ))*(void**)(__base - 448))(__t__p0, __t__p1));\
	})

#define dJointGetHingeParam(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID , int ))*(void**)(__base - 1828))(__t__p0, __t__p1));\
	})

#define dJointGetHingeAngleRate(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1840))(__t__p0));\
	})

#define dBodySetAngularVel(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1306))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointSetHingeParam(__p0, __p1, __p2) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int , dReal ))*(void**)(__base - 1666))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomGetAABB(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal *))*(void**)(__base - 94))(__t__p0, __t__p1));\
	})

#define dGeomIsEnabled(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dGeomID ))*(void**)(__base - 154))(__t__p0));\
	})

#define dGeomIsSpace(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dGeomID ))*(void**)(__base - 100))(__t__p0));\
	})

#define dGeomTransformGetInfo(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dGeomID ))*(void**)(__base - 364))(__t__p0));\
	})

#define dRandSetSeed(__p0) \
	({ \
		unsigned long  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(unsigned long ))*(void**)(__base - 952))(__t__p0));\
	})

#define dGeomBoxSetLengths(__p0, __p1, __p2, __p3) \
	({ \
		dGeomID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , dReal , dReal , dReal ))*(void**)(__base - 208))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointCreateHinge2(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID ))*(void**)(__base - 1552))(__t__p0, __t__p1));\
	})

#define dBodyIsEnabled(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dBodyID ))*(void**)(__base - 1510))(__t__p0));\
	})

#define dJointSetFeedback(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dJointFeedback * __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dJointFeedback *))*(void**)(__base - 1636))(__t__p0, __t__p1));\
	})

#define dJointCreateSlider(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID ))*(void**)(__base - 1540))(__t__p0, __t__p1));\
	})

#define dJointGetAMotorMode(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dJointID ))*(void**)(__base - 2008))(__t__p0));\
	})

#define dGetMessageHandler() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dMessageFunction *(*)())*(void**)(__base - 664))());\
	})

#define dGeomSetRotation(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		const dMatrix3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , const dMatrix3 ))*(void**)(__base - 64))(__t__p0, __t__p1));\
	})

#define dJointSetAMotorMode(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , int ))*(void**)(__base - 1786))(__t__p0, __t__p1));\
	})

#define dGeomTransformGetGeom(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dGeomID ))*(void**)(__base - 340))(__t__p0));\
	})

#define dBodyGetRelPointPos(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dVector3  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dVector3 ))*(void**)(__base - 1426))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dFactorLDLT(__p0, __p1, __p2, __p3) \
	({ \
		dReal * __t__p0 = __p0;\
		dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, dReal *, int , int ))*(void**)(__base - 832))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dSetMessageHandler(__p0) \
	({ \
		dMessageFunction * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMessageFunction *))*(void**)(__base - 646))(__t__p0));\
	})

#define dSpaceGetGeom(__p0, __p1) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dSpaceID , int ))*(void**)(__base - 490))(__t__p0, __t__p1));\
	})

#define dJointAddHingeTorque(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal ))*(void**)(__base - 1672))(__t__p0, __t__p1));\
	})

#define dWorldImpulseToForce(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dVector3  __t__p5 = __p5;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal , dReal , dReal , dReal , dVector3 ))*(void**)(__base - 1054))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define dCreateBox(__p0, __p1, __p2, __p3) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dSpaceID , dReal , dReal , dReal ))*(void**)(__base - 202))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGeomGetClass(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dGeomID ))*(void**)(__base - 112))(__t__p0));\
	})

#define dJointGetData(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void *(*)(dJointID ))*(void**)(__base - 1618))(__t__p0));\
	})

#define dGeomTriMeshEnableTC(__p0, __p1, __p2) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , int , int ))*(void**)(__base - 598))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomTriMeshIsTCEnabled(__p0, __p1) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dGeomID , int ))*(void**)(__base - 604))(__t__p0, __t__p1));\
	})

#define dBodyGetPosition(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dBodyID ))*(void**)(__base - 1312))(__t__p0));\
	})

#define dWorldStepFast1(__p0, __p1, __p2) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal , int ))*(void**)(__base - 1114))(__t__p0, __t__p1, __t__p2));\
	})

#define dStopwatchStop(__p0) \
	({ \
		dStopwatch * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dStopwatch *))*(void**)(__base - 2140))(__t__p0));\
	})

#define dBodyAddForce(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1354))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#ifndef __cplusplus
#define dDebug(__p0, ...) \
	({ \
		int  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		(((void (*)(int , const char *, ...))*(void**)(__base - 676))(__t__p0, __VA_ARGS__,({__asm volatile("mr 12,%0": :"r"(__base):"r12");0L;})));\
	})
#endif

#define dMassSetCappedCylinder(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal , int , dReal , dReal ))*(void**)(__base - 712))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dJointCreateFixed(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dJointGroupID  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dJointID (*)(dWorldID , dJointGroupID ))*(void**)(__base - 1564))(__t__p0, __t__p1));\
	})

#define dStopwatchStart(__p0) \
	({ \
		dStopwatch * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dStopwatch *))*(void**)(__base - 2134))(__t__p0));\
	})

#define dBodyVectorToWorld(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dVector3  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dVector3 ))*(void**)(__base - 1450))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dBodyAddForceAtPos(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dReal  __t__p5 = __p5;\
		dReal  __t__p6 = __p6;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dReal , dReal , dReal ))*(void**)(__base - 1378))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define dCloseODE() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)())*(void**)(__base - 388))());\
	})

#define dBodyGetLinearVel(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dBodyID ))*(void**)(__base - 1330))(__t__p0));\
	})

#define dGeomTriMeshGetArrayCallback(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dTriArrayCallback *(*)(dGeomID ))*(void**)(__base - 568))(__t__p0));\
	})

#define dJointSetHingeAxis(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1660))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dBodyGetAutoDisableAngularThreshold(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dBodyID ))*(void**)(__base - 1204))(__t__p0));\
	})

#define dJointSetHinge2Axis1(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1702))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointSetHinge2Axis2(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1708))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dBodyAddTorque(__p0, __p1, __p2, __p3) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal ))*(void**)(__base - 1360))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointGetHingeAnchor2(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1816))(__t__p0, __t__p1));\
	})

#define dJointGetSliderAxis(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1858))(__t__p0, __t__p1));\
	})

#define dPlaneSpace(__p0, __p1, __p2) \
	({ \
		const dVector3  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		dVector3  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(const dVector3 , dVector3 , dVector3 ))*(void**)(__base - 2038))(__t__p0, __t__p1, __t__p2));\
	})

#define dBodyGetForce(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((const dReal *(*)(dBodyID ))*(void**)(__base - 1402))(__t__p0));\
	})

#define dBodyGetPointVel(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dVector3  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dVector3 ))*(void**)(__base - 1438))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dMassAdjust(__p0, __p1) \
	({ \
		dMass * __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *, dReal ))*(void**)(__base - 748))(__t__p0, __t__p1));\
	})

#define dMassSetZero(__p0) \
	({ \
		dMass * __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dMass *))*(void**)(__base - 688))(__t__p0));\
	})

#define dQMultiply0(__p0, __p1, __p2) \
	({ \
		dQuaternion  __t__p0 = __p0;\
		const dQuaternion  __t__p1 = __p1;\
		const dQuaternion  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dQuaternion , const dQuaternion , const dQuaternion ))*(void**)(__base - 2086))(__t__p0, __t__p1, __t__p2));\
	})

#define dBodyDisable(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID ))*(void**)(__base - 1504))(__t__p0));\
	})

#define dBodyGetRelPointVel(__p0, __p1, __p2, __p3, __p4) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dVector3  __t__p4 = __p4;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dVector3 ))*(void**)(__base - 1432))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4));\
	})

#define dQMultiply1(__p0, __p1, __p2) \
	({ \
		dQuaternion  __t__p0 = __p0;\
		const dQuaternion  __t__p1 = __p1;\
		const dQuaternion  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dQuaternion , const dQuaternion , const dQuaternion ))*(void**)(__base - 2092))(__t__p0, __t__p1, __t__p2));\
	})

#define dQMultiply2(__p0, __p1, __p2) \
	({ \
		dQuaternion  __t__p0 = __p0;\
		const dQuaternion  __t__p1 = __p1;\
		const dQuaternion  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dQuaternion , const dQuaternion , const dQuaternion ))*(void**)(__base - 2098))(__t__p0, __t__p1, __t__p2));\
	})

#define dJointSetUniversalAnchor(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1726))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dQMultiply3(__p0, __p1, __p2) \
	({ \
		dQuaternion  __t__p0 = __p0;\
		const dQuaternion  __t__p1 = __p1;\
		const dQuaternion  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dQuaternion , const dQuaternion , const dQuaternion ))*(void**)(__base - 2104))(__t__p0, __t__p1, __t__p2));\
	})

#define dGetDebugHandler() \
	({ \
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dMessageFunction *(*)())*(void**)(__base - 658))());\
	})

#define dDot(__p0, __p1, __p2) \
	({ \
		const dReal * __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(const dReal *, const dReal *, int ))*(void**)(__base - 784))(__t__p0, __t__p1, __t__p2));\
	})

#define dBodyGetData(__p0) \
	({ \
		dBodyID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void *(*)(dBodyID ))*(void**)(__base - 1276))(__t__p0));\
	})

#define dJointSetSliderAxis(__p0, __p1, __p2, __p3) \
	({ \
		dJointID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dReal , dReal , dReal ))*(void**)(__base - 1678))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dJointGetSliderPositionRate(__p0) \
	({ \
		dJointID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(dJointID ))*(void**)(__base - 1852))(__t__p0));\
	})

#define dJointGetHingeAnchor(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		dVector3  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointID , dVector3 ))*(void**)(__base - 1810))(__t__p0, __t__p1));\
	})

#define dJointGetAMotorAxisRel(__p0, __p1) \
	({ \
		dJointID  __t__p0 = __p0;\
		int  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dJointID , int ))*(void**)(__base - 1984))(__t__p0, __t__p1));\
	})

#define dBodyAddRelForceAtPos(__p0, __p1, __p2, __p3, __p4, __p5, __p6) \
	({ \
		dBodyID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		dReal  __t__p2 = __p2;\
		dReal  __t__p3 = __p3;\
		dReal  __t__p4 = __p4;\
		dReal  __t__p5 = __p5;\
		dReal  __t__p6 = __p6;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dBodyID , dReal , dReal , dReal , dReal , dReal , dReal ))*(void**)(__base - 1390))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5, __t__p6));\
	})

#define dMaxDifferenceLowerTriangle(__p0, __p1, __p2) \
	({ \
		const dReal * __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(const dReal *, const dReal *, int ))*(void**)(__base - 994))(__t__p0, __t__p1, __t__p2));\
	})

#define dMultiply0(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		dReal * __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		const dReal * __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, const dReal *, const dReal *, int , int , int ))*(void**)(__base - 790))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define dMaxDifference(__p0, __p1, __p2, __p3) \
	({ \
		const dReal * __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		int  __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dReal (*)(const dReal *, const dReal *, int , int ))*(void**)(__base - 988))(__t__p0, __t__p1, __t__p2, __t__p3));\
	})

#define dGeomTriMeshGetCallback(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dTriCallback *(*)(dGeomID ))*(void**)(__base - 556))(__t__p0));\
	})

#define dMultiply1(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		dReal * __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		const dReal * __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, const dReal *, const dReal *, int , int , int ))*(void**)(__base - 796))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define dMultiply2(__p0, __p1, __p2, __p3, __p4, __p5) \
	({ \
		dReal * __t__p0 = __p0;\
		const dReal * __t__p1 = __p1;\
		const dReal * __t__p2 = __p2;\
		int  __t__p3 = __p3;\
		int  __t__p4 = __p4;\
		int  __t__p5 = __p5;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dReal *, const dReal *, const dReal *, int , int , int ))*(void**)(__base - 802))(__t__p0, __t__p1, __t__p2, __t__p3, __t__p4, __t__p5));\
	})

#define dSpaceGetCleanup(__p0) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((int (*)(dSpaceID ))*(void**)(__base - 454))(__t__p0));\
	})

#define dWorldSetAutoDisableAngularThreshold(__p0, __p1) \
	({ \
		dWorldID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dWorldID , dReal ))*(void**)(__base - 1150))(__t__p0, __t__p1));\
	})

#define dGeomRayGetParams(__p0, __p1, __p2) \
	({ \
		dGeomID  __t__p0 = __p0;\
		int * __t__p1 = __p1;\
		int * __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dGeomID , int *, int *))*(void**)(__base - 310))(__t__p0, __t__p1, __t__p2));\
	})

#define dGeomGetCategoryBits(__p0) \
	({ \
		dGeomID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((unsigned long (*)(dGeomID ))*(void**)(__base - 130))(__t__p0));\
	})

#define dCreateSphere(__p0, __p1) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		dReal  __t__p1 = __p1;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((dGeomID (*)(dSpaceID , dReal ))*(void**)(__base - 178))(__t__p0, __t__p1));\
	})

#define dHashSpaceGetLevels(__p0, __p1, __p2) \
	({ \
		dSpaceID  __t__p0 = __p0;\
		int * __t__p1 = __p1;\
		int * __t__p2 = __p2;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dSpaceID , int *, int *))*(void**)(__base - 442))(__t__p0, __t__p1, __t__p2));\
	})

#define dJointGroupDestroy(__p0) \
	({ \
		dJointGroupID  __t__p0 = __p0;\
		long __base = (long)(ODE_BASE_NAME);\
		__asm volatile("mr 12,%0": :"r"(__base):"r12");\
		(((void (*)(dJointGroupID ))*(void**)(__base - 1594))(__t__p0));\
	})

#endif /* !_PPCINLINE_ODE_H */
