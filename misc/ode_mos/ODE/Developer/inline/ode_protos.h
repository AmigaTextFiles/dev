/* Automatically generated header! Do not edit! */

#ifndef _VBCCINLINE_ODE_H
#define _VBCCINLINE_ODE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EMUL_EMULREGS_H
#include <emul/emulregs.h>
#endif

void  __dJointGetHinge2Anchor(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1870(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHinge2Anchor(__p0, __p1) __dJointGetHinge2Anchor((__p0), (__p1))

void  __dMassSetCylinderTotal(dMass *, dReal , int , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-730(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetCylinderTotal(__p0, __p1, __p2, __p3, __p4) __dMassSetCylinderTotal((__p0), (__p1), (__p2), (__p3), (__p4))

dGeomID  __dCreateRay(dSpaceID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-274(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreateRay(__p0, __p1) __dCreateRay((__p0), (__p1))

int  __dInvertPDMatrix(const dReal *, dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-820(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dInvertPDMatrix(__p0, __p1, __p2) __dInvertPDMatrix((__p0), (__p1), (__p2))

void  __dGeomRaySetParams(dGeomID , int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-304(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomRaySetParams(__p0, __p1, __p2) __dGeomRaySetParams((__p0), (__p1), (__p2))

void  __dBodySetGravityMode(dBodyID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1516(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetGravityMode(__p0, __p1) __dBodySetGravityMode((__p0), (__p1))

void  __dGeomBoxGetLengths(dGeomID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-214(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomBoxGetLengths(__p0, __p1) __dGeomBoxGetLengths((__p0), (__p1))

void  __dHashSpaceSetLevels(dSpaceID , int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-436(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dHashSpaceSetLevels(__p0, __p1, __p2) __dHashSpaceSetLevels((__p0), (__p1), (__p2))

void  __dGeomTriMeshDataDestroy(dTriMeshDataID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-502(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataDestroy(__p0) __dGeomTriMeshDataDestroy((__p0))

void  __dGeomTriMeshDataBuildSimple1(dTriMeshDataID , const dReal *, int , const int *, int , const int *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-544(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataBuildSimple1(__p0, __p1, __p2, __p3, __p4, __p5) __dGeomTriMeshDataBuildSimple1((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

void  __dMassSetBox(dMass *, dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-736(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetBox(__p0, __p1, __p2, __p3, __p4) __dMassSetBox((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dClearUpperTriangle(dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-982(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dClearUpperTriangle(__p0, __p1) __dClearUpperTriangle((__p0), (__p1))

void  __dBodyAddRelForce(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1366(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyAddRelForce(__p0, __p1, __p2, __p3) __dBodyAddRelForce((__p0), (__p1), (__p2), (__p3))

void  __dJointGetUniversalAnchor2(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1924(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalAnchor2(__p0, __p1) __dJointGetUniversalAnchor2((__p0), (__p1))

void  __dSolveCholesky(const dReal *, dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-814(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSolveCholesky(__p0, __p1, __p2) __dSolveCholesky((__p0), (__p1), (__p2))

void  __dJointGetAMotorAxis(dJointID , int , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1978(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetAMotorAxis(__p0, __p1, __p2) __dJointGetAMotorAxis((__p0), (__p1), (__p2))

void  __dBodyAddRelForceAtRelPos(dBodyID , dReal , dReal , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1396(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyAddRelForceAtRelPos(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __dBodyAddRelForceAtRelPos((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

void  __dJointSetAMotorAxis(dJointID , int , int , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1768(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetAMotorAxis(__p0, __p1, __p2, __p3, __p4, __p5) __dJointSetAMotorAxis((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

void  __dRfromQ(dMatrix3 , const dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2110(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRfromQ(__p0, __p1) __dRfromQ((__p0), (__p1))

void  __dTimerEnd() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2164(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dTimerEnd() __dTimerEnd()

void  __dGeomPlaneGetParams(dGeomID , dVector4 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-238(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomPlaneGetParams(__p0, __p1) __dGeomPlaneGetParams((__p0), (__p1))

void  __dRFromEulerAngles(dMatrix3 , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2056(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRFromEulerAngles(__p0, __p1, __p2, __p3) __dRFromEulerAngles((__p0), (__p1), (__p2), (__p3))

const dReal * __dBodyGetRotation(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1318(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetRotation(__p0) __dBodyGetRotation((__p0))

void  __dMassTranslate(dMass *, dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-754(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassTranslate(__p0, __p1, __p2, __p3) __dMassTranslate((__p0), (__p1), (__p2), (__p3))

void  __dGeomPlaneSetParams(dGeomID , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-232(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomPlaneSetParams(__p0, __p1, __p2, __p3, __p4) __dGeomPlaneSetParams((__p0), (__p1), (__p2), (__p3), (__p4))

dReal  __dJointGetUniversalParam(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1942(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalParam(__p0, __p1) __dJointGetUniversalParam((__p0), (__p1))

void  __dJointGetHinge2Anchor2(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1876(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHinge2Anchor2(__p0, __p1) __dJointGetHinge2Anchor2((__p0), (__p1))

void  __dSpaceClean(dSpaceID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-478(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceClean(__p0) __dSpaceClean((__p0))

dGeomID  __dCreateTriMesh(dSpaceID , dTriMeshDataID , dTriCallback *, dTriArrayCallback *, dTriRayCallback *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-586(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreateTriMesh(__p0, __p1, __p2, __p3, __p4) __dCreateTriMesh((__p0), (__p1), (__p2), (__p3), (__p4))

dReal  __dGeomBoxPointDepth(dGeomID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-220(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomBoxPointDepth(__p0, __p1, __p2, __p3) __dGeomBoxPointDepth((__p0), (__p1), (__p2), (__p3))

void  __dJointAddAMotorTorques(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1792(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointAddAMotorTorques(__p0, __p1, __p2, __p3) __dJointAddAMotorTorques((__p0), (__p1), (__p2), (__p3))

dBodyID  __dGeomGetBody(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-52(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetBody(__p0) __dGeomGetBody((__p0))

void  __dLDLTAddTL(dReal *, dReal *, const dReal *, int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-862(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dLDLTAddTL(__p0, __p1, __p2, __p3, __p4) __dLDLTAddTL((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dSpaceCollide2(dGeomID , dGeomID , void *, dNearCallback *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-172(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceCollide2(__p0, __p1, __p2, __p3) __dSpaceCollide2((__p0), (__p1), (__p2), (__p3))

void  __dJointSetUniversalParam(dJointID , int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1744(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetUniversalParam(__p0, __p1, __p2) __dJointSetUniversalParam((__p0), (__p1), (__p2))

void  __dWorldSetAutoDisableFlag(dWorldID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1186(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetAutoDisableFlag(__p0, __p1) __dWorldSetAutoDisableFlag((__p0), (__p1))

void  __dMassAdd(dMass *, const dMass *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-766(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassAdd(__p0, __p1) __dMassAdd((__p0), (__p1))

const dReal * __dGeomGetPosition(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-76(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetPosition(__p0) __dGeomGetPosition((__p0))

void  __dJointAddSliderForce(dJointID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1690(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointAddSliderForce(__p0, __p1) __dJointAddSliderForce((__p0), (__p1))

void  __dJointGroupEmpty(dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1600(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGroupEmpty(__p0) __dJointGroupEmpty((__p0))

int  __dFactorCholesky(dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-808(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dFactorCholesky(__p0, __p1) __dFactorCholesky((__p0), (__p1))

dBodyID  __dBodyCreate(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1258(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyCreate(__p0) __dBodyCreate((__p0))

void  __dJointGetHinge2Axis1(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1882(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHinge2Axis1(__p0, __p1) __dJointGetHinge2Axis1((__p0), (__p1))

void  __dJointGetHinge2Axis2(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1888(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHinge2Axis2(__p0, __p1) __dJointGetHinge2Axis2((__p0), (__p1))

dAllocFunction * __dGetAllocHandler() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-898(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGetAllocHandler() __dGetAllocHandler()

void  __dGeomTriMeshSetRayCallback(dGeomID , dTriRayCallback *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-574(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshSetRayCallback(__p0, __p1) __dGeomTriMeshSetRayCallback((__p0), (__p1))

dJointID  __dJointCreateAMotor(dWorldID , dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1576(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateAMotor(__p0, __p1) __dJointCreateAMotor((__p0), (__p1))

void  __dBodySetMass(dBodyID , const dMass *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1342(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetMass(__p0, __p1) __dBodySetMass((__p0), (__p1))

void  __dGeomGetQuaternion(dGeomID , dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-88(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetQuaternion(__p0, __p1) __dGeomGetQuaternion((__p0), (__p1))

void  __dWorldSetAutoDisableTime(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1174(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetAutoDisableTime(__p0, __p1) __dWorldSetAutoDisableTime((__p0), (__p1))

void  __dWorldSetAutoDisableSteps(dWorldID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1162(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetAutoDisableSteps(__p0, __p1) __dWorldSetAutoDisableSteps((__p0), (__p1))

void  __dSetErrorHandler(dMessageFunction *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-634(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSetErrorHandler(__p0) __dSetErrorHandler((__p0))

int  __dBodyGetNumJoints(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1486(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetNumJoints(__p0) __dBodyGetNumJoints((__p0))

dReal  __dGeomRayGetLength(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-286(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomRayGetLength(__p0) __dGeomRayGetLength((__p0))

int  __dIsPositiveDefinite(const dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-826(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dIsPositiveDefinite(__p0, __p1) __dIsPositiveDefinite((__p0), (__p1))

void  __dJointGetUniversalAnchor(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1918(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalAnchor(__p0, __p1) __dJointGetUniversalAnchor((__p0), (__p1))

dReal  __dWorldGetQuickStepW(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1084(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetQuickStepW(__p0) __dWorldGetQuickStepW((__p0))

void  __dGeomTriMeshDataBuildSimple(dTriMeshDataID , const dReal *, int , const int *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-538(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataBuildSimple(__p0, __p1, __p2, __p3, __p4) __dGeomTriMeshDataBuildSimple((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dJointAddUniversalTorques(dJointID , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1750(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointAddUniversalTorques(__p0, __p1, __p2) __dJointAddUniversalTorques((__p0), (__p1), (__p2))

void  __dGeomSetQuaternion(dGeomID , const dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-70(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSetQuaternion(__p0, __p1) __dGeomSetQuaternion((__p0), (__p1))

void  __dBodySetLinearVel(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1300(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetLinearVel(__p0, __p1, __p2, __p3) __dBodySetLinearVel((__p0), (__p1), (__p2), (__p3))

void  __dGeomTriMeshSetArrayCallback(dGeomID , dTriArrayCallback *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-562(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshSetArrayCallback(__p0, __p1) __dGeomTriMeshSetArrayCallback((__p0), (__p1))

int  __dBodyGetFiniteRotationMode(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1474(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetFiniteRotationMode(__p0) __dBodyGetFiniteRotationMode((__p0))

void  __dGeomSetCollideBits(dGeomID , unsigned long ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-124(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSetCollideBits(__p0, __p1) __dGeomSetCollideBits((__p0), (__p1))

void  __dGeomRaySetLength(dGeomID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-280(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomRaySetLength(__p0, __p1) __dGeomRaySetLength((__p0), (__p1))

void  __dWorldStep(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1048(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldStep(__p0, __p1) __dWorldStep((__p0), (__p1))

void  __dWorldSetQuickStepW(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1078(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetQuickStepW(__p0, __p1) __dWorldSetQuickStepW((__p0), (__p1))

void  __dBodySetForce(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1414(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetForce(__p0, __p1, __p2, __p3) __dBodySetForce((__p0), (__p1), (__p2), (__p3))

void  __dRFrom2Axes(dMatrix3 , dReal , dReal , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2062(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRFrom2Axes(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __dRFrom2Axes((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

void  __dWorldSetCFM(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1036(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetCFM(__p0, __p1) __dWorldSetCFM((__p0), (__p1))

int  __dBodyGetAutoDisableSteps(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1216(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetAutoDisableSteps(__p0) __dBodyGetAutoDisableSteps((__p0))

void  __dMassSetSphereTotal(dMass *, dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-706(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetSphereTotal(__p0, __p1, __p2) __dMassSetSphereTotal((__p0), (__p1), (__p2))

dReal  __dWorldGetAutoDisableAngularThreshold(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1144(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetAutoDisableAngularThreshold(__p0) __dWorldGetAutoDisableAngularThreshold((__p0))

void  __dGeomSetData(dGeomID , void *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-34(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSetData(__p0, __p1) __dGeomSetData((__p0), (__p1))

void  __dBodySetFiniteRotationMode(dBodyID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1462(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetFiniteRotationMode(__p0, __p1) __dBodySetFiniteRotationMode((__p0), (__p1))

void  __dGeomTriMeshDataBuildSingle(dTriMeshDataID , const void *, int , int , const void *, int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-514(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataBuildSingle(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __dGeomTriMeshDataBuildSingle((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

dJointID  __dJointCreateUniversal(dWorldID , dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1558(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateUniversal(__p0, __p1) __dJointCreateUniversal((__p0), (__p1))

int  __dWorldGetQuickStepNumIterations(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1072(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetQuickStepNumIterations(__p0) __dWorldGetQuickStepNumIterations((__p0))

void  __dGeomRayGet(dGeomID , dVector3 , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-298(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomRayGet(__p0, __p1, __p2) __dGeomRayGet((__p0), (__p1), (__p2))

int  __dGeomRayGetClosestHit(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-322(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomRayGetClosestHit(__p0) __dGeomRayGetClosestHit((__p0))

void  __dGeomTriMeshClearTCCache(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-610(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshClearTCCache(__p0) __dGeomTriMeshClearTCCache((__p0))

int  __dSpaceGetNumGeoms(dSpaceID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-484(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceGetNumGeoms(__p0) __dSpaceGetNumGeoms((__p0))

void * __dGeomGetClassData(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-400(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetClassData(__p0) __dGeomGetClassData((__p0))

void  __dGeomTransformSetCleanup(dGeomID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-346(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTransformSetCleanup(__p0, __p1) __dGeomTransformSetCleanup((__p0), (__p1))

void  __dSolveLDLT(const dReal *, const dReal *, dReal *, int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-856(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSolveLDLT(__p0, __p1, __p2, __p3, __p4) __dSolveLDLT((__p0), (__p1), (__p2), (__p3), (__p4))

int  __dBodyGetGravityMode(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1522(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetGravityMode(__p0) __dBodyGetGravityMode((__p0))

void  __dSpaceRemove(dSpaceID , dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-466(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceRemove(__p0, __p1) __dSpaceRemove((__p0), (__p1))

void  __dMassSetCylinder(dMass *, dReal , int , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-724(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetCylinder(__p0, __p1, __p2, __p3, __p4) __dMassSetCylinder((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dBodyAddRelTorque(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1372(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyAddRelTorque(__p0, __p1, __p2, __p3) __dBodyAddRelTorque((__p0), (__p1), (__p2), (__p3))

void  __dWorldSetERP(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1024(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetERP(__p0, __p1) __dWorldSetERP((__p0), (__p1))

dGeomID  __dCreateGeom(int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-406(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreateGeom(__p0) __dCreateGeom((__p0))

void  __dWorldSetQuickStepNumIterations(dWorldID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1066(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetQuickStepNumIterations(__p0, __p1) __dWorldSetQuickStepNumIterations((__p0), (__p1))

void  __dStopwatchReset(dStopwatch *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2128(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dStopwatchReset(__p0) __dStopwatchReset((__p0))

void  __dJointSetFixed(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1756(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetFixed(__p0) __dJointSetFixed((__p0))

double  __dTimerTicksPerSecond() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2170(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dTimerTicksPerSecond() __dTimerTicksPerSecond()

void  __dGeomRaySetClosestHit(dGeomID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-316(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomRaySetClosestHit(__p0, __p1) __dGeomRaySetClosestHit((__p0), (__p1))

dJointID  __dJointCreateHinge(dWorldID , dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1534(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateHinge(__p0, __p1) __dJointCreateHinge((__p0), (__p1))

dReal  __dJointGetHinge2Angle1Rate(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1906(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHinge2Angle1Rate(__p0) __dJointGetHinge2Angle1Rate((__p0))

void  __dWorldSetContactSurfaceLayer(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1102(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetContactSurfaceLayer(__p0, __p1) __dWorldSetContactSurfaceLayer((__p0), (__p1))

unsigned long  __dRandGetSeed() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-946(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRandGetSeed() __dRandGetSeed()

dTriMeshDataID  __dGeomTriMeshGetTriMeshDataID(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-616(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshGetTriMeshDataID(__p0) __dGeomTriMeshGetTriMeshDataID((__p0))

void  __dRSetIdentity(dMatrix3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2044(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRSetIdentity(__p0) __dRSetIdentity((__p0))

void  __dSpaceCollide(dSpaceID , void *, dNearCallback *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-166(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceCollide(__p0, __p1, __p2) __dSpaceCollide((__p0), (__p1), (__p2))

dJointFeedback * __dJointGetFeedback(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1642(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetFeedback(__p0) __dJointGetFeedback((__p0))

#if defined(USE_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
void  __dError(int , const char *, ...) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-670(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dError(__p0, ...) __dError((__p0), __VA_ARGS__)
#endif

void  __dSetFreeHandler(dFreeFunction *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-892(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSetFreeHandler(__p0) __dSetFreeHandler((__p0))

dBodyID  __dJointGetBody(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1630(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetBody(__p0, __p1) __dJointGetBody((__p0), (__p1))

void  __dGeomDestroy(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-28(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomDestroy(__p0) __dGeomDestroy((__p0))

void  __dMakeRandomMatrix(dReal *, int , int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-976(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMakeRandomMatrix(__p0, __p1, __p2, __p3) __dMakeRandomMatrix((__p0), (__p1), (__p2), (__p3))

void  __dTimerNow(const char *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2158(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dTimerNow(__p0) __dTimerNow((__p0))

int  __dJointGetAMotorNumAxes(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1972(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetAMotorNumAxes(__p0) __dJointGetAMotorNumAxes((__p0))

const dReal * __dGeomGetRotation(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-82(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetRotation(__p0) __dGeomGetRotation((__p0))

void  __dJointAttach(dJointID , dBodyID , dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1606(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointAttach(__p0, __p1, __p2) __dJointAttach((__p0), (__p1), (__p2))

void  __dSolveL1T(const dReal *, dReal *, int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-844(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSolveL1T(__p0, __p1, __p2, __p3) __dSolveL1T((__p0), (__p1), (__p2), (__p3))

void  __dGeomTransformSetInfo(dGeomID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-358(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTransformSetInfo(__p0, __p1) __dGeomTransformSetInfo((__p0), (__p1))

void  __dBodyVectorFromWorld(dBodyID , dReal , dReal , dReal , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1456(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyVectorFromWorld(__p0, __p1, __p2, __p3, __p4) __dBodyVectorFromWorld((__p0), (__p1), (__p2), (__p3), (__p4))

dReal  __dWorldGetAutoDisableLinearThreshold(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1132(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetAutoDisableLinearThreshold(__p0) __dWorldGetAutoDisableLinearThreshold((__p0))

void  __dBodySetAutoDisableFlag(dBodyID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1246(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetAutoDisableFlag(__p0, __p1) __dBodySetAutoDisableFlag((__p0), (__p1))

void  __dNormalize3(dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2026(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dNormalize3(__p0) __dNormalize3((__p0))

void  __dJointSetSliderParam(dJointID , int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1684(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetSliderParam(__p0, __p1, __p2) __dJointSetSliderParam((__p0), (__p1), (__p2))

dGeomID  __dCreatePlane(dSpaceID , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-226(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreatePlane(__p0, __p1, __p2, __p3, __p4) __dCreatePlane((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dNormalize4(dVector4 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2032(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dNormalize4(__p0) __dNormalize4((__p0))

unsigned long  __dRand() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-940(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRand() __dRand()

dReal  __dJointGetAMotorAngleRate(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1996(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetAMotorAngleRate(__p0, __p1) __dJointGetAMotorAngleRate((__p0), (__p1))

void  __dJointSetAMotorAngle(dJointID , int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1774(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetAMotorAngle(__p0, __p1, __p2) __dJointSetAMotorAngle((__p0), (__p1), (__p2))

void  __dWorldSetAutoDisableLinearThreshold(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1138(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetAutoDisableLinearThreshold(__p0, __p1) __dWorldSetAutoDisableLinearThreshold((__p0), (__p1))

dSpaceID  __dSimpleSpaceCreate(dSpaceID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-412(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSimpleSpaceCreate(__p0) __dSimpleSpaceCreate((__p0))

void * __dAlloc(size_t ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-916(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dAlloc(__p0) __dAlloc((__p0))

int  __dWorldGetAutoDisableFlag(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1180(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetAutoDisableFlag(__p0) __dWorldGetAutoDisableFlag((__p0))

void  __dJointSetAMotorParam(dJointID , int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1780(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetAMotorParam(__p0, __p1, __p2) __dJointSetAMotorParam((__p0), (__p1), (__p2))

void  __dSpaceAdd(dSpaceID , dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-460(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceAdd(__p0, __p1) __dSpaceAdd((__p0), (__p1))

void  __dBodySetAutoDisableTime(dBodyID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1234(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetAutoDisableTime(__p0, __p1) __dBodySetAutoDisableTime((__p0), (__p1))

void  __dGeomTransformSetGeom(dGeomID , dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-334(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTransformSetGeom(__p0, __p1) __dGeomTransformSetGeom((__p0), (__p1))

void  __dVectorScale(dReal *, const dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-850(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dVectorScale(__p0, __p1, __p2) __dVectorScale((__p0), (__p1), (__p2))

dTriRayCallback * __dGeomTriMeshGetRayCallback(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-580(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshGetRayCallback(__p0) __dGeomTriMeshGetRayCallback((__p0))

void  __dRemoveRowCol(dReal *, int , int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-874(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRemoveRowCol(__p0, __p1, __p2, __p3) __dRemoveRowCol((__p0), (__p1), (__p2), (__p3))

dReal  __dWorldGetAutoDisableTime(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1168(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetAutoDisableTime(__p0) __dWorldGetAutoDisableTime((__p0))

dJointGroupID  __dJointGroupCreate(int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1588(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGroupCreate(__p0) __dJointGroupCreate((__p0))

void  __dMassSetSphere(dMass *, dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-700(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetSphere(__p0, __p1, __p2) __dMassSetSphere((__p0), (__p1), (__p2))

int  __dWorldGetAutoEnableDepthSF1(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1126(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetAutoEnableDepthSF1(__p0) __dWorldGetAutoEnableDepthSF1((__p0))

dReal  __dRandReal() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-964(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRandReal() __dRandReal()

void  __dJointSetData(dJointID , void *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1612(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetData(__p0, __p1) __dJointSetData((__p0), (__p1))

int  __dBoxTouchesBox(const dVector3 , const dMatrix3 , const dVector3 , const dVector3 , const dMatrix3 , const dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-376(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBoxTouchesBox(__p0, __p1, __p2, __p3, __p4, __p5) __dBoxTouchesBox((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

void  __dBodyGetPosRelPoint(dBodyID , dReal , dReal , dReal , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1444(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetPosRelPoint(__p0, __p1, __p2, __p3, __p4) __dBodyGetPosRelPoint((__p0), (__p1), (__p2), (__p3), (__p4))

const dReal * __dBodyGetTorque(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1408(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetTorque(__p0) __dBodyGetTorque((__p0))

void  __dBodySetPosition(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1282(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetPosition(__p0, __p1, __p2, __p3) __dBodySetPosition((__p0), (__p1), (__p2), (__p3))

void  __dTimerStart(const char *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2152(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dTimerStart(__p0) __dTimerStart((__p0))

void  __dBodyAddForceAtRelPos(dBodyID , dReal , dReal , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1384(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyAddForceAtRelPos(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __dBodyAddForceAtRelPos((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

void  __dBodyGetFiniteRotationAxis(dBodyID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1480(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetFiniteRotationAxis(__p0, __p1) __dBodyGetFiniteRotationAxis((__p0), (__p1))

void  __dWorldSetAutoEnableDepthSF1(dWorldID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1120(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetAutoEnableDepthSF1(__p0, __p1) __dWorldSetAutoEnableDepthSF1((__p0), (__p1))

unsigned long  __dGeomGetCollideBits(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-136(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetCollideBits(__p0) __dGeomGetCollideBits((__p0))

dReal  __dGeomSphereGetRadius(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-190(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSphereGetRadius(__p0) __dGeomSphereGetRadius((__p0))

dReal  __dGeomPlanePointDepth(dGeomID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-244(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomPlanePointDepth(__p0, __p1, __p2, __p3) __dGeomPlanePointDepth((__p0), (__p1), (__p2), (__p3))

void  __dBodySetTorque(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1420(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetTorque(__p0, __p1, __p2, __p3) __dBodySetTorque((__p0), (__p1), (__p2), (__p3))

dSpaceID  __dQuadTreeSpaceCreate(dSpaceID , dVector3 , dVector3 , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-424(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dQuadTreeSpaceCreate(__p0, __p1, __p2, __p3) __dQuadTreeSpaceCreate((__p0), (__p1), (__p2), (__p3))

dWorldID  __dWorldCreate() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1000(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldCreate() __dWorldCreate()

dReal  __dJointGetSliderPosition(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1846(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetSliderPosition(__p0) __dJointGetSliderPosition((__p0))

dReal  __dWorldGetCFM(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1042(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetCFM(__p0) __dWorldGetCFM((__p0))

void  __dBodySetFiniteRotationAxis(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1468(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetFiniteRotationAxis(__p0, __p1, __p2, __p3) __dBodySetFiniteRotationAxis((__p0), (__p1), (__p2), (__p3))

void  __dJointSetHinge2Param(dJointID , int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1714(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetHinge2Param(__p0, __p1, __p2) __dJointSetHinge2Param((__p0), (__p1), (__p2))

dReallocFunction * __dGetReallocHandler() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-904(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGetReallocHandler() __dGetReallocHandler()

dReal  __dJointGetUniversalAngle1Rate(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1960(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalAngle1Rate(__p0) __dJointGetUniversalAngle1Rate((__p0))

int  __dSpaceQuery(dSpaceID , dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-472(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceQuery(__p0, __p1) __dSpaceQuery((__p0), (__p1))

void  __dMassRotate(dMass *, const dMatrix3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-760(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassRotate(__p0, __p1) __dMassRotate((__p0), (__p1))

void  __dGeomSphereSetRadius(dGeomID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-184(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSphereSetRadius(__p0, __p1) __dGeomSphereSetRadius((__p0), (__p1))

int  __dGeomTransformGetCleanup(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-352(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTransformGetCleanup(__p0) __dGeomTransformGetCleanup((__p0))

void  __dSetReallocHandler(dReallocFunction *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-886(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSetReallocHandler(__p0) __dSetReallocHandler((__p0))

void  __dMassSetBoxTotal(dMass *, dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-742(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetBoxTotal(__p0, __p1, __p2, __p3, __p4) __dMassSetBoxTotal((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dJointDestroy(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1582(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointDestroy(__p0) __dJointDestroy((__p0))

dReal  __dWorldGetERP(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1030(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetERP(__p0) __dWorldGetERP((__p0))

void  __dSetDebugHandler(dMessageFunction *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-640(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSetDebugHandler(__p0) __dSetDebugHandler((__p0))

dGeomID  __dCreateCCylinder(dSpaceID , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-250(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreateCCylinder(__p0, __p1, __p2) __dCreateCCylinder((__p0), (__p1), (__p2))

void  __dWorldDestroy(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1006(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldDestroy(__p0) __dWorldDestroy((__p0))

dJointID  __dJointCreateNull(dWorldID , dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1570(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateNull(__p0, __p1) __dJointCreateNull((__p0), (__p1))

void  __dBodySetData(dBodyID , void *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1270(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetData(__p0, __p1) __dBodySetData((__p0), (__p1))

dReal  __dJointGetHinge2Angle1(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1900(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHinge2Angle1(__p0) __dJointGetHinge2Angle1((__p0))

void  __dWorldSetGravity(dWorldID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1012(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetGravity(__p0, __p1, __p2, __p3) __dWorldSetGravity((__p0), (__p1), (__p2), (__p3))

dReal  __dWorldGetContactSurfaceLayer(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1108(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetContactSurfaceLayer(__p0) __dWorldGetContactSurfaceLayer((__p0))

void  __dGeomTriMeshSetCallback(dGeomID , dTriCallback *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-550(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshSetCallback(__p0, __p1) __dGeomTriMeshSetCallback((__p0), (__p1))

void  __dWorldSetContactMaxCorrectingVel(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1090(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetContactMaxCorrectingVel(__p0, __p1) __dWorldSetContactMaxCorrectingVel((__p0), (__p1))

dFreeFunction * __dGetFreeHandler() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-910(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGetFreeHandler() __dGetFreeHandler()

void  __dGeomSetCategoryBits(dGeomID , unsigned long ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-118(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSetCategoryBits(__p0, __p1) __dGeomSetCategoryBits((__p0), (__p1))

dReal  __dJointGetHinge2Angle2Rate(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1912(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHinge2Angle2Rate(__p0) __dJointGetHinge2Angle2Rate((__p0))

void  __dSolveL1(const dReal *, dReal *, int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-838(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSolveL1(__p0, __p1, __p2, __p3) __dSolveL1((__p0), (__p1), (__p2), (__p3))

void  __dJointSetHinge2Anchor(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1696(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetHinge2Anchor(__p0, __p1, __p2, __p3) __dJointSetHinge2Anchor((__p0), (__p1), (__p2), (__p3))

void  __dGeomCCylinderGetParams(dGeomID , dReal *, dReal *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-262(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomCCylinderGetParams(__p0, __p1, __p2) __dGeomCCylinderGetParams((__p0), (__p1), (__p2))

double  __dStopwatchTime(dStopwatch *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2146(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dStopwatchTime(__p0) __dStopwatchTime((__p0))

int  __dCreateGeomClass(const dGeomClass *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-394(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreateGeomClass(__p0) __dCreateGeomClass((__p0))

void  __dMakeRandomVector(dReal *, int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-970(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMakeRandomVector(__p0, __p1, __p2) __dMakeRandomVector((__p0), (__p1), (__p2))

dJointID  __dBodyGetJoint(dBodyID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1492(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetJoint(__p0, __p1) __dBodyGetJoint((__p0), (__p1))

void  __dRFromZAxis(dMatrix3 , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2068(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRFromZAxis(__p0, __p1, __p2, __p3) __dRFromZAxis((__p0), (__p1), (__p2), (__p3))

void  __dGeomCCylinderSetParams(dGeomID , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-256(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomCCylinderSetParams(__p0, __p1, __p2) __dGeomCCylinderSetParams((__p0), (__p1), (__p2))

void  __dClosestLineSegmentPoints(const dVector3 , const dVector3 , const dVector3 , const dVector3 , dVector3 , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-370(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dClosestLineSegmentPoints(__p0, __p1, __p2, __p3, __p4, __p5) __dClosestLineSegmentPoints((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

int  __dBodyGetAutoDisableFlag(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1240(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetAutoDisableFlag(__p0) __dBodyGetAutoDisableFlag((__p0))

dReal  __dJointGetSliderParam(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1864(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetSliderParam(__p0, __p1) __dJointGetSliderParam((__p0), (__p1))

void  __dBodyDestroy(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1264(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyDestroy(__p0) __dBodyDestroy((__p0))

void  __dInfiniteAABB(dGeomID , dReal *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-382(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dInfiniteAABB(__p0, __p1) __dInfiniteAABB((__p0), (__p1))

dReal  __dJointGetAMotorAngle(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1990(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetAMotorAngle(__p0, __p1) __dJointGetAMotorAngle((__p0), (__p1))

void  __dJointAddHinge2Torques(dJointID , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1720(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointAddHinge2Torques(__p0, __p1, __p2) __dJointAddHinge2Torques((__p0), (__p1), (__p2))

void  __dLDLTRemove(dReal **, const int *, dReal *, dReal *, int , int , int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-868(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dLDLTRemove(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7) __dLDLTRemove((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6), (__p7))

void  __dGeomTriMeshDataBuildSingle1(dTriMeshDataID , const void *, int , int , const void *, int , int , const void *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-520(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataBuildSingle1(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7) __dGeomTriMeshDataBuildSingle1((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6), (__p7))

void * __dRealloc(void *, size_t , size_t ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-922(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRealloc(__p0, __p1, __p2) __dRealloc((__p0), (__p1), (__p2))

void  __dJointGetUniversalAxis1(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1930(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalAxis1(__p0, __p1) __dJointGetUniversalAxis1((__p0), (__p1))

void  __dJointSetAMotorNumAxes(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1762(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetAMotorNumAxes(__p0, __p1) __dJointSetAMotorNumAxes((__p0), (__p1))

void  __dJointGetUniversalAxis2(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1936(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalAxis2(__p0, __p1) __dJointGetUniversalAxis2((__p0), (__p1))

void  __dQSetIdentity(dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2074(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dQSetIdentity(__p0) __dQSetIdentity((__p0))

dReal  __dJointGetAMotorParam(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2002(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetAMotorParam(__p0, __p1) __dJointGetAMotorParam((__p0), (__p1))

void  __dGeomTriMeshDataSet(dTriMeshDataID , int , void *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-508(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataSet(__p0, __p1, __p2) __dGeomTriMeshDataSet((__p0), (__p1), (__p2))

dReal  __dBodyGetAutoDisableTime(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1228(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetAutoDisableTime(__p0) __dBodyGetAutoDisableTime((__p0))

void  __dBodySetRotation(dBodyID , const dMatrix3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1288(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetRotation(__p0, __p1) __dBodySetRotation((__p0), (__p1))

int  __dAreConnected(dBodyID , dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2014(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dAreConnected(__p0, __p1) __dAreConnected((__p0), (__p1))

void  __dJointGetBallAnchor2(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1804(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetBallAnchor2(__p0, __p1) __dJointGetBallAnchor2((__p0), (__p1))

void  __dJointSetUniversalAxis1(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1732(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetUniversalAxis1(__p0, __p1, __p2, __p3) __dJointSetUniversalAxis1((__p0), (__p1), (__p2), (__p3))

void  __dJointSetUniversalAxis2(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1738(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetUniversalAxis2(__p0, __p1, __p2, __p3) __dJointSetUniversalAxis2((__p0), (__p1), (__p2), (__p3))

int  __dRandInt(int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-958(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRandInt(__p0) __dRandInt((__p0))

dTriMeshDataID  __dGeomTriMeshDataCreate() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-496(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataCreate() __dGeomTriMeshDataCreate()

dSpaceID  __dGeomGetSpace(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-106(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetSpace(__p0) __dGeomGetSpace((__p0))

void  __dMassSetParameters(dMass *, dReal , dReal , dReal , dReal , dReal , dReal , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-694(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetParameters(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7, __p8, __p9, __p10) __dMassSetParameters((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6), (__p7), (__p8), (__p9), (__p10))

void  __dBodyEnable(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1498(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyEnable(__p0) __dBodyEnable((__p0))

dGeomID  __dCreateGeomTransform(dSpaceID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-328(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreateGeomTransform(__p0) __dCreateGeomTransform((__p0))

void  __dJointGetBallAnchor(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1798(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetBallAnchor(__p0, __p1) __dJointGetBallAnchor((__p0), (__p1))

void  __dGeomTriMeshDataBuildDouble1(dTriMeshDataID , const void *, int , int , const void *, int , int , const void *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-532(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataBuildDouble1(__p0, __p1, __p2, __p3, __p4, __p5, __p6, __p7) __dGeomTriMeshDataBuildDouble1((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6), (__p7))

void  __dDQfromW(dReal *, const dVector3 , const dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2122(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dDQfromW(__p0, __p1, __p2) __dDQfromW((__p0), (__p1), (__p2))

void  __dGeomSetBody(dGeomID , dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-46(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSetBody(__p0, __p1) __dGeomSetBody((__p0), (__p1))

void  __dFree(void *, size_t ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-928(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dFree(__p0, __p1) __dFree((__p0), (__p1))

void  __dBodyGetMass(dBodyID , dMass *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1348(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetMass(__p0, __p1) __dBodyGetMass((__p0), (__p1))

dReal  __dBodyGetAutoDisableLinearThreshold(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1192(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetAutoDisableLinearThreshold(__p0) __dBodyGetAutoDisableLinearThreshold((__p0))

void  __dJointGetHingeAxis(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1822(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHingeAxis(__p0, __p1) __dJointGetHingeAxis((__p0), (__p1))

int  __dWorldGetAutoDisableSteps(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1156(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetAutoDisableSteps(__p0) __dWorldGetAutoDisableSteps((__p0))

#if defined(USE_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
void  __dMessage(int , const char *, ...) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-682(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMessage(__p0, ...) __dMessage((__p0), __VA_ARGS__)
#endif

void  __dJointSetBallAnchor(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1648(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetBallAnchor(__p0, __p1, __p2, __p3) __dJointSetBallAnchor((__p0), (__p1), (__p2), (__p3))

dMessageFunction * __dGetErrorHandler() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-652(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGetErrorHandler() __dGetErrorHandler()

void  __dGeomSetPosition(dGeomID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-58(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSetPosition(__p0, __p1, __p2, __p3) __dGeomSetPosition((__p0), (__p1), (__p2), (__p3))

void  __dSetZero(dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-772(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSetZero(__p0, __p1) __dSetZero((__p0), (__p1))

void  __dGeomTriMeshGetPoint(dGeomID , int , dReal , dReal , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-628(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshGetPoint(__p0, __p1, __p2, __p3, __p4) __dGeomTriMeshGetPoint((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dBodySetAutoDisableLinearThreshold(dBodyID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1198(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetAutoDisableLinearThreshold(__p0, __p1) __dBodySetAutoDisableLinearThreshold((__p0), (__p1))

dReal  __dJointGetHinge2Param(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1894(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHinge2Param(__p0, __p1) __dJointGetHinge2Param((__p0), (__p1))

dJointID  __dJointCreateBall(dWorldID , dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1528(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateBall(__p0, __p1) __dJointCreateBall((__p0), (__p1))

void  __dQFromAxisAndAngle(dQuaternion , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2080(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dQFromAxisAndAngle(__p0, __p1, __p2, __p3, __p4) __dQFromAxisAndAngle((__p0), (__p1), (__p2), (__p3), (__p4))

const dReal * __dBodyGetQuaternion(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1324(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetQuaternion(__p0) __dBodyGetQuaternion((__p0))

double  __dTimerResolution() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2176(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dTimerResolution() __dTimerResolution()

void  __dRFromAxisAndAngle(dMatrix3 , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2050(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRFromAxisAndAngle(__p0, __p1, __p2, __p3, __p4) __dRFromAxisAndAngle((__p0), (__p1), (__p2), (__p3), (__p4))

dReal  __dJointGetUniversalAngle1(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1948(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalAngle1(__p0) __dJointGetUniversalAngle1((__p0))

void  __dSetAllocHandler(dAllocFunction *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-880(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSetAllocHandler(__p0) __dSetAllocHandler((__p0))

dReal  __dJointGetUniversalAngle2(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1954(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalAngle2(__p0) __dJointGetUniversalAngle2((__p0))

void  __dSpaceDestroy(dSpaceID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-430(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceDestroy(__p0) __dSpaceDestroy((__p0))

void  __dGeomDisable(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-148(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomDisable(__p0) __dGeomDisable((__p0))

void  __dBodySetAutoDisableAngularThreshold(dBodyID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1210(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetAutoDisableAngularThreshold(__p0, __p1) __dBodySetAutoDisableAngularThreshold((__p0), (__p1))

void  __dBodySetAutoDisableDefaults(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1252(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetAutoDisableDefaults(__p0) __dBodySetAutoDisableDefaults((__p0))

void  __dBodySetQuaternion(dBodyID , const dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1294(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetQuaternion(__p0, __p1) __dBodySetQuaternion((__p0), (__p1))

void  __dWorldQuickStep(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1060(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldQuickStep(__p0, __p1) __dWorldQuickStep((__p0), (__p1))

dReal  __dJointGetUniversalAngle2Rate(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1966(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetUniversalAngle2Rate(__p0) __dJointGetUniversalAngle2Rate((__p0))

void * __dGeomGetData(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-40(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetData(__p0) __dGeomGetData((__p0))

dReal  __dGeomCCylinderPointDepth(dGeomID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-268(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomCCylinderPointDepth(__p0, __p1, __p2, __p3) __dGeomCCylinderPointDepth((__p0), (__p1), (__p2), (__p3))

dSpaceID  __dHashSpaceCreate(dSpaceID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-418(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dHashSpaceCreate(__p0) __dHashSpaceCreate((__p0))

dJointID  __dJointCreateContact(dWorldID , dJointGroupID , const dContact *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1546(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateContact(__p0, __p1, __p2) __dJointCreateContact((__p0), (__p1), (__p2))

int  __dTestRand() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-934(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dTestRand() __dTestRand()

int  __dJointGetType(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1624(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetType(__p0) __dJointGetType((__p0))

void  __dSetValue(dReal *, int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-778(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSetValue(__p0, __p1, __p2) __dSetValue((__p0), (__p1), (__p2))

void  __dGeomTriMeshDataBuildDouble(dTriMeshDataID , const void *, int , int , const void *, int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-526(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshDataBuildDouble(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __dGeomTriMeshDataBuildDouble((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

void  __dGeomTriMeshSetData(dGeomID , dTriMeshDataID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-592(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshSetData(__p0, __p1) __dGeomTriMeshSetData((__p0), (__p1))

void  __dMassSetCappedCylinderTotal(dMass *, dReal , int , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-718(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetCappedCylinderTotal(__p0, __p1, __p2, __p3, __p4) __dMassSetCappedCylinderTotal((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dWorldGetGravity(dWorldID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1018(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetGravity(__p0, __p1) __dWorldGetGravity((__p0), (__p1))

dReal  __dGeomSpherePointDepth(dGeomID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-196(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSpherePointDepth(__p0, __p1, __p2, __p3) __dGeomSpherePointDepth((__p0), (__p1), (__p2), (__p3))

int  __dAreConnectedExcluding(dBodyID , dBodyID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2020(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dAreConnectedExcluding(__p0, __p1, __p2) __dAreConnectedExcluding((__p0), (__p1), (__p2))

void  __dGeomEnable(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-142(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomEnable(__p0) __dGeomEnable((__p0))

dReal  __dWorldGetContactMaxCorrectingVel(dWorldID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1096(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldGetContactMaxCorrectingVel(__p0) __dWorldGetContactMaxCorrectingVel((__p0))

void  __dBodySetAutoDisableSteps(dBodyID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1222(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetAutoDisableSteps(__p0, __p1) __dBodySetAutoDisableSteps((__p0), (__p1))

void  __dJointSetHingeAnchor(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1654(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetHingeAnchor(__p0, __p1, __p2, __p3) __dJointSetHingeAnchor((__p0), (__p1), (__p2), (__p3))

dReal  __dJointGetHingeAngle(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1834(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHingeAngle(__p0) __dJointGetHingeAngle((__p0))

void  __dQfromR(dQuaternion , const dMatrix3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2116(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dQfromR(__p0, __p1) __dQfromR((__p0), (__p1))

void  __dGeomTriMeshGetTriangle(dGeomID , int , dVector3 *, dVector3 *, dVector3 *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-622(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshGetTriangle(__p0, __p1, __p2, __p3, __p4) __dGeomTriMeshGetTriangle((__p0), (__p1), (__p2), (__p3), (__p4))

int  __dCollide(dGeomID , dGeomID , int , dContactGeom *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-160(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCollide(__p0, __p1, __p2, __p3, __p4) __dCollide((__p0), (__p1), (__p2), (__p3), (__p4))

const dReal * __dBodyGetAngularVel(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1336(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetAngularVel(__p0) __dBodyGetAngularVel((__p0))

void  __dGeomRaySet(dGeomID , dReal , dReal , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-292(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomRaySet(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __dGeomRaySet((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

void  __dSpaceSetCleanup(dSpaceID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-448(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceSetCleanup(__p0, __p1) __dSpaceSetCleanup((__p0), (__p1))

dReal  __dJointGetHingeParam(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1828(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHingeParam(__p0, __p1) __dJointGetHingeParam((__p0), (__p1))

dReal  __dJointGetHingeAngleRate(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1840(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHingeAngleRate(__p0) __dJointGetHingeAngleRate((__p0))

void  __dBodySetAngularVel(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1306(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodySetAngularVel(__p0, __p1, __p2, __p3) __dBodySetAngularVel((__p0), (__p1), (__p2), (__p3))

void  __dJointSetHingeParam(dJointID , int , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1666(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetHingeParam(__p0, __p1, __p2) __dJointSetHingeParam((__p0), (__p1), (__p2))

void  __dGeomGetAABB(dGeomID , dReal *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-94(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetAABB(__p0, __p1) __dGeomGetAABB((__p0), (__p1))

int  __dGeomIsEnabled(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-154(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomIsEnabled(__p0) __dGeomIsEnabled((__p0))

int  __dGeomIsSpace(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-100(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomIsSpace(__p0) __dGeomIsSpace((__p0))

int  __dGeomTransformGetInfo(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-364(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTransformGetInfo(__p0) __dGeomTransformGetInfo((__p0))

void  __dRandSetSeed(unsigned long ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-952(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dRandSetSeed(__p0) __dRandSetSeed((__p0))

void  __dGeomBoxSetLengths(dGeomID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-208(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomBoxSetLengths(__p0, __p1, __p2, __p3) __dGeomBoxSetLengths((__p0), (__p1), (__p2), (__p3))

dJointID  __dJointCreateHinge2(dWorldID , dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1552(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateHinge2(__p0, __p1) __dJointCreateHinge2((__p0), (__p1))

int  __dBodyIsEnabled(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1510(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyIsEnabled(__p0) __dBodyIsEnabled((__p0))

void  __dJointSetFeedback(dJointID , dJointFeedback *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1636(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetFeedback(__p0, __p1) __dJointSetFeedback((__p0), (__p1))

dJointID  __dJointCreateSlider(dWorldID , dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1540(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateSlider(__p0, __p1) __dJointCreateSlider((__p0), (__p1))

int  __dJointGetAMotorMode(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2008(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetAMotorMode(__p0) __dJointGetAMotorMode((__p0))

dMessageFunction * __dGetMessageHandler() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-664(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGetMessageHandler() __dGetMessageHandler()

void  __dGeomSetRotation(dGeomID , const dMatrix3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-64(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomSetRotation(__p0, __p1) __dGeomSetRotation((__p0), (__p1))

void  __dJointSetAMotorMode(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1786(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetAMotorMode(__p0, __p1) __dJointSetAMotorMode((__p0), (__p1))

dGeomID  __dGeomTransformGetGeom(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-340(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTransformGetGeom(__p0) __dGeomTransformGetGeom((__p0))

void  __dBodyGetRelPointPos(dBodyID , dReal , dReal , dReal , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1426(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetRelPointPos(__p0, __p1, __p2, __p3, __p4) __dBodyGetRelPointPos((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dFactorLDLT(dReal *, dReal *, int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-832(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dFactorLDLT(__p0, __p1, __p2, __p3) __dFactorLDLT((__p0), (__p1), (__p2), (__p3))

void  __dSetMessageHandler(dMessageFunction *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-646(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSetMessageHandler(__p0) __dSetMessageHandler((__p0))

dGeomID  __dSpaceGetGeom(dSpaceID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-490(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceGetGeom(__p0, __p1) __dSpaceGetGeom((__p0), (__p1))

void  __dJointAddHingeTorque(dJointID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1672(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointAddHingeTorque(__p0, __p1) __dJointAddHingeTorque((__p0), (__p1))

void  __dWorldImpulseToForce(dWorldID , dReal , dReal , dReal , dReal , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1054(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldImpulseToForce(__p0, __p1, __p2, __p3, __p4, __p5) __dWorldImpulseToForce((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

dGeomID  __dCreateBox(dSpaceID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-202(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreateBox(__p0, __p1, __p2, __p3) __dCreateBox((__p0), (__p1), (__p2), (__p3))

int  __dGeomGetClass(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-112(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetClass(__p0) __dGeomGetClass((__p0))

void * __dJointGetData(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1618(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetData(__p0) __dJointGetData((__p0))

void  __dGeomTriMeshEnableTC(dGeomID , int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-598(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshEnableTC(__p0, __p1, __p2) __dGeomTriMeshEnableTC((__p0), (__p1), (__p2))

int  __dGeomTriMeshIsTCEnabled(dGeomID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-604(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshIsTCEnabled(__p0, __p1) __dGeomTriMeshIsTCEnabled((__p0), (__p1))

const dReal * __dBodyGetPosition(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1312(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetPosition(__p0) __dBodyGetPosition((__p0))

void  __dWorldStepFast1(dWorldID , dReal , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1114(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldStepFast1(__p0, __p1, __p2) __dWorldStepFast1((__p0), (__p1), (__p2))

void  __dStopwatchStop(dStopwatch *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2140(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dStopwatchStop(__p0) __dStopwatchStop((__p0))

void  __dBodyAddForce(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1354(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyAddForce(__p0, __p1, __p2, __p3) __dBodyAddForce((__p0), (__p1), (__p2), (__p3))

#if defined(USE_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
void  __dDebug(int , const char *, ...) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-676(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dDebug(__p0, ...) __dDebug((__p0), __VA_ARGS__)
#endif

void  __dMassSetCappedCylinder(dMass *, dReal , int , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-712(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetCappedCylinder(__p0, __p1, __p2, __p3, __p4) __dMassSetCappedCylinder((__p0), (__p1), (__p2), (__p3), (__p4))

dJointID  __dJointCreateFixed(dWorldID , dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1564(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointCreateFixed(__p0, __p1) __dJointCreateFixed((__p0), (__p1))

void  __dStopwatchStart(dStopwatch *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2134(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dStopwatchStart(__p0) __dStopwatchStart((__p0))

void  __dBodyVectorToWorld(dBodyID , dReal , dReal , dReal , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1450(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyVectorToWorld(__p0, __p1, __p2, __p3, __p4) __dBodyVectorToWorld((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dBodyAddForceAtPos(dBodyID , dReal , dReal , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1378(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyAddForceAtPos(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __dBodyAddForceAtPos((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

void  __dCloseODE() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-388(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCloseODE() __dCloseODE()

const dReal * __dBodyGetLinearVel(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1330(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetLinearVel(__p0) __dBodyGetLinearVel((__p0))

dTriArrayCallback * __dGeomTriMeshGetArrayCallback(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-568(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshGetArrayCallback(__p0) __dGeomTriMeshGetArrayCallback((__p0))

void  __dJointSetHingeAxis(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1660(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetHingeAxis(__p0, __p1, __p2, __p3) __dJointSetHingeAxis((__p0), (__p1), (__p2), (__p3))

dReal  __dBodyGetAutoDisableAngularThreshold(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1204(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetAutoDisableAngularThreshold(__p0) __dBodyGetAutoDisableAngularThreshold((__p0))

void  __dJointSetHinge2Axis1(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1702(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetHinge2Axis1(__p0, __p1, __p2, __p3) __dJointSetHinge2Axis1((__p0), (__p1), (__p2), (__p3))

void  __dJointSetHinge2Axis2(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1708(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetHinge2Axis2(__p0, __p1, __p2, __p3) __dJointSetHinge2Axis2((__p0), (__p1), (__p2), (__p3))

void  __dBodyAddTorque(dBodyID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1360(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyAddTorque(__p0, __p1, __p2, __p3) __dBodyAddTorque((__p0), (__p1), (__p2), (__p3))

void  __dJointGetHingeAnchor2(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1816(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHingeAnchor2(__p0, __p1) __dJointGetHingeAnchor2((__p0), (__p1))

void  __dJointGetSliderAxis(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1858(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetSliderAxis(__p0, __p1) __dJointGetSliderAxis((__p0), (__p1))

void  __dPlaneSpace(const dVector3 , dVector3 , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2038(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dPlaneSpace(__p0, __p1, __p2) __dPlaneSpace((__p0), (__p1), (__p2))

const dReal * __dBodyGetForce(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1402(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetForce(__p0) __dBodyGetForce((__p0))

void  __dBodyGetPointVel(dBodyID , dReal , dReal , dReal , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1438(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetPointVel(__p0, __p1, __p2, __p3, __p4) __dBodyGetPointVel((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dMassAdjust(dMass *, dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-748(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassAdjust(__p0, __p1) __dMassAdjust((__p0), (__p1))

void  __dMassSetZero(dMass *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-688(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMassSetZero(__p0) __dMassSetZero((__p0))

void  __dQMultiply0(dQuaternion , const dQuaternion , const dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2086(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dQMultiply0(__p0, __p1, __p2) __dQMultiply0((__p0), (__p1), (__p2))

void  __dBodyDisable(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1504(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyDisable(__p0) __dBodyDisable((__p0))

void  __dBodyGetRelPointVel(dBodyID , dReal , dReal , dReal , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1432(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetRelPointVel(__p0, __p1, __p2, __p3, __p4) __dBodyGetRelPointVel((__p0), (__p1), (__p2), (__p3), (__p4))

void  __dQMultiply1(dQuaternion , const dQuaternion , const dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2092(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dQMultiply1(__p0, __p1, __p2) __dQMultiply1((__p0), (__p1), (__p2))

void  __dQMultiply2(dQuaternion , const dQuaternion , const dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2098(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dQMultiply2(__p0, __p1, __p2) __dQMultiply2((__p0), (__p1), (__p2))

void  __dJointSetUniversalAnchor(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1726(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetUniversalAnchor(__p0, __p1, __p2, __p3) __dJointSetUniversalAnchor((__p0), (__p1), (__p2), (__p3))

void  __dQMultiply3(dQuaternion , const dQuaternion , const dQuaternion ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-2104(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dQMultiply3(__p0, __p1, __p2) __dQMultiply3((__p0), (__p1), (__p2))

dMessageFunction * __dGetDebugHandler() =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-658(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGetDebugHandler() __dGetDebugHandler()

dReal  __dDot(const dReal *, const dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-784(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dDot(__p0, __p1, __p2) __dDot((__p0), (__p1), (__p2))

void * __dBodyGetData(dBodyID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1276(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyGetData(__p0) __dBodyGetData((__p0))

void  __dJointSetSliderAxis(dJointID , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1678(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointSetSliderAxis(__p0, __p1, __p2, __p3) __dJointSetSliderAxis((__p0), (__p1), (__p2), (__p3))

dReal  __dJointGetSliderPositionRate(dJointID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1852(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetSliderPositionRate(__p0) __dJointGetSliderPositionRate((__p0))

void  __dJointGetHingeAnchor(dJointID , dVector3 ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1810(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetHingeAnchor(__p0, __p1) __dJointGetHingeAnchor((__p0), (__p1))

int  __dJointGetAMotorAxisRel(dJointID , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1984(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGetAMotorAxisRel(__p0, __p1) __dJointGetAMotorAxisRel((__p0), (__p1))

void  __dBodyAddRelForceAtPos(dBodyID , dReal , dReal , dReal , dReal , dReal , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1390(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dBodyAddRelForceAtPos(__p0, __p1, __p2, __p3, __p4, __p5, __p6) __dBodyAddRelForceAtPos((__p0), (__p1), (__p2), (__p3), (__p4), (__p5), (__p6))

dReal  __dMaxDifferenceLowerTriangle(const dReal *, const dReal *, int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-994(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMaxDifferenceLowerTriangle(__p0, __p1, __p2) __dMaxDifferenceLowerTriangle((__p0), (__p1), (__p2))

void  __dMultiply0(dReal *, const dReal *, const dReal *, int , int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-790(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMultiply0(__p0, __p1, __p2, __p3, __p4, __p5) __dMultiply0((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

dReal  __dMaxDifference(const dReal *, const dReal *, int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-988(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMaxDifference(__p0, __p1, __p2, __p3) __dMaxDifference((__p0), (__p1), (__p2), (__p3))

dTriCallback * __dGeomTriMeshGetCallback(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-556(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomTriMeshGetCallback(__p0) __dGeomTriMeshGetCallback((__p0))

void  __dMultiply1(dReal *, const dReal *, const dReal *, int , int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-796(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMultiply1(__p0, __p1, __p2, __p3, __p4, __p5) __dMultiply1((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

void  __dMultiply2(dReal *, const dReal *, const dReal *, int , int , int ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-802(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dMultiply2(__p0, __p1, __p2, __p3, __p4, __p5) __dMultiply2((__p0), (__p1), (__p2), (__p3), (__p4), (__p5))

int  __dSpaceGetCleanup(dSpaceID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-454(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dSpaceGetCleanup(__p0) __dSpaceGetCleanup((__p0))

void  __dWorldSetAutoDisableAngularThreshold(dWorldID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1150(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dWorldSetAutoDisableAngularThreshold(__p0, __p1) __dWorldSetAutoDisableAngularThreshold((__p0), (__p1))

void  __dGeomRayGetParams(dGeomID , int *, int *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-310(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomRayGetParams(__p0, __p1, __p2) __dGeomRayGetParams((__p0), (__p1), (__p2))

unsigned long  __dGeomGetCategoryBits(dGeomID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-130(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dGeomGetCategoryBits(__p0) __dGeomGetCategoryBits((__p0))

dGeomID  __dCreateSphere(dSpaceID , dReal ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-178(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dCreateSphere(__p0, __p1) __dCreateSphere((__p0), (__p1))

void  __dHashSpaceGetLevels(dSpaceID , int *, int *) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-442(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dHashSpaceGetLevels(__p0, __p1, __p2) __dHashSpaceGetLevels((__p0), (__p1), (__p2))

void  __dJointGroupDestroy(dJointGroupID ) =
	"\tlis\t11,ODEBase@ha\n"
	"\tlwz\t12,ODEBase@l(11)\n"
	"\tlwz\t0,-1594(12)\n"
	"\tmtlr\t0\n"
	"\tblrl";
#define dJointGroupDestroy(__p0) __dJointGroupDestroy((__p0))

#endif /* !_VBCCINLINE_ODE_H */
