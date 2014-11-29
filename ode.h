#ifndef ODE_H
#define ODE_H
//// ODE
/* real */
typedef double dReal;
/* these types are mainly just used in headers */
typedef dReal dVector3[4];
typedef dReal dVector4[4];
typedef dReal dMatrix3[4*3];
typedef dReal dMatrix4[4*4];
typedef dReal dMatrix6[8*6];
typedef dReal dQuaternion[4];
/* internal object types */
struct dxWorld;
struct dxSpace;
struct dxBody;
struct dxGeom;
struct dxJoint;
struct dxJointNode;
struct dxJointGroup;
typedef struct dxWorld *dWorldID;
typedef struct dxSpace *dSpaceID;
typedef struct dxBody *dBodyID;
typedef struct dxGeom *dGeomID;
typedef struct dxJoint *dJointID;
typedef struct dxJointGroup *dJointGroupID;
/* joint type numbers */
enum {
  dJointTypeNone = 0,
  dJointTypeBall,
  dJointTypeHinge,
  dJointTypeSlider,
  dJointTypeContact,
  dJointTypeUniversal,
  dJointTypeHinge2,
  dJointTypeFixed,
  dJointTypeNull,
  dJointTypeAMotor
};
/* angular motor mode numbers */
enum{
  dAMotorUser = 0,
  dAMotorEuler = 1
};
/* joint force feedback information */
typedef struct dJointFeedback {
  dVector3 f1;
  dVector3 t1;
  dVector3 f2;
  dVector3 t2;
} dJointFeedback;
/* mass */
struct dMass {
  dReal mass;
  dVector4 c;
  dMatrix3 I;
};
typedef struct dMass dMass;
void dMassSetZero (dMass *);
void dMassSetParameters (dMass *, dReal themass,
			 dReal cgx, dReal cgy, dReal cgz,
			 dReal I11, dReal I22, dReal I33,
			 dReal I12, dReal I13, dReal I23);
void dMassSetSphere (dMass *, dReal density, dReal radius);
void dMassSetSphereTotal (dMass *, dReal total_mass, dReal radius);
void dMassSetCappedCylinder (dMass *, dReal density, int direction,
			     dReal radius, dReal length);
void dMassSetCappedCylinderTotal (dMass *, dReal total_mass, int direction,
				  dReal radius, dReal length);
void dMassSetCylinder (dMass *, dReal density, int direction,
		       dReal radius, dReal length);
void dMassSetCylinderTotal (dMass *, dReal total_mass, int direction,
			    dReal radius, dReal length);
void dMassSetBox (dMass *, dReal density,
		  dReal lx, dReal ly, dReal lz);
void dMassSetBoxTotal (dMass *, dReal total_mass,
		       dReal lx, dReal ly, dReal lz);
void dMassAdjust (dMass *, dReal newmass);
void dMassTranslate (dMass *, dReal x, dReal y, dReal z);
void dMassRotate (dMass *, const dMatrix3 R);
void dMassAdd (dMass *a, const dMass *b);
/* Contact */
enum {
  dContactMu2		= 0x001,
  dContactFDir1		= 0x002,
  dContactBounce	= 0x004,
  dContactSoftERP	= 0x008,
  dContactSoftCFM	= 0x010,
  dContactMotion1	= 0x020,
  dContactMotion2	= 0x040,
  dContactSlip1		= 0x080,
  dContactSlip2		= 0x100,
  dContactApprox0	= 0x0000,
  dContactApprox1_1	= 0x1000,
  dContactApprox1_2	= 0x2000,
  dContactApprox1	= 0x3000
};
typedef struct dSurfaceParameters {
  int mode;
  dReal mu;
  dReal mu2;
  dReal bounce;
  dReal bounce_vel;
  dReal soft_erp;
  dReal soft_cfm;
  dReal motion1,motion2;
  dReal slip1,slip2;
} dSurfaceParameters;
/* contact info set by collision functions */
typedef struct dContactGeom {
  dVector3 pos;
  dVector3 normal;
  dReal depth;
  dGeomID g1,g2;
} dContactGeom;
/* contact info used by contact joint */
typedef struct dContact {
  dSurfaceParameters surface;
  dContactGeom geom;
  dVector3 fdir1;
} dContact;
/* world */
dWorldID dWorldCreate();
void dWorldDestroy (dWorldID);
void dWorldSetGravity (dWorldID, dReal x, dReal y, dReal z);
void dWorldGetGravity (dWorldID, dVector3 gravity);
void dWorldSetERP (dWorldID, dReal erp);
dReal dWorldGetERP (dWorldID);
void dWorldSetCFM (dWorldID, dReal cfm);
dReal dWorldGetCFM (dWorldID);
void dWorldStep (dWorldID, dReal stepsize);
void dWorldImpulseToForce (dWorldID, dReal stepsize,
			   dReal ix, dReal iy, dReal iz, dVector3 force);
/* World QuickStep functions */
void dWorldQuickStep (dWorldID w, dReal stepsize);
void dWorldSetQuickStepNumIterations (dWorldID, int num);
int dWorldGetQuickStepNumIterations (dWorldID);
void dWorldSetQuickStepW (dWorldID, dReal param);
dReal dWorldGetQuickStepW (dWorldID);
/* World contact parameter functions */
void dWorldSetContactMaxCorrectingVel (dWorldID, dReal vel);
dReal dWorldGetContactMaxCorrectingVel (dWorldID);
void dWorldSetContactSurfaceLayer (dWorldID, dReal depth);
dReal dWorldGetContactSurfaceLayer (dWorldID);
/* StepFast1 functions */
void dWorldStepFast1(dWorldID, dReal stepsize, int maxiterations);
void dWorldSetAutoEnableDepthSF1(dWorldID, int autoEnableDepth);
int dWorldGetAutoEnableDepthSF1(dWorldID);
/* Auto-disable functions */
dReal dWorldGetAutoDisableLinearThreshold (dWorldID);
void  dWorldSetAutoDisableLinearThreshold (dWorldID, dReal linear_threshold);
dReal dWorldGetAutoDisableAngularThreshold (dWorldID);
void  dWorldSetAutoDisableAngularThreshold (dWorldID, dReal angular_threshold);
int   dWorldGetAutoDisableSteps (dWorldID);
void  dWorldSetAutoDisableSteps (dWorldID, int steps);
dReal dWorldGetAutoDisableTime (dWorldID);
void  dWorldSetAutoDisableTime (dWorldID, dReal time);
int   dWorldGetAutoDisableFlag (dWorldID);
void  dWorldSetAutoDisableFlag (dWorldID, int do_auto_disable);
dReal dBodyGetAutoDisableLinearThreshold (dBodyID);
void  dBodySetAutoDisableLinearThreshold (dBodyID, dReal linear_threshold);
dReal dBodyGetAutoDisableAngularThreshold (dBodyID);
void  dBodySetAutoDisableAngularThreshold (dBodyID, dReal angular_threshold);
int   dBodyGetAutoDisableSteps (dBodyID);
void  dBodySetAutoDisableSteps (dBodyID, int steps);
dReal dBodyGetAutoDisableTime (dBodyID);
void  dBodySetAutoDisableTime (dBodyID, dReal time);
int   dBodyGetAutoDisableFlag (dBodyID);
void  dBodySetAutoDisableFlag (dBodyID, int do_auto_disable);
void  dBodySetAutoDisableDefaults (dBodyID);
/* bodies */
dBodyID dBodyCreate (dWorldID);
void dBodyDestroy (dBodyID);
void  dBodySetData (dBodyID, void *data);
void *dBodyGetData (dBodyID);
void dBodySetPosition   (dBodyID, dReal x, dReal y, dReal z);
void dBodySetRotation   (dBodyID, const dMatrix3 R);
void dBodySetQuaternion (dBodyID, const dQuaternion q);
void dBodySetLinearVel  (dBodyID, dReal x, dReal y, dReal z);
void dBodySetAngularVel (dBodyID, dReal x, dReal y, dReal z);
const dReal * dBodyGetPosition   (dBodyID);
const dReal * dBodyGetRotation   (dBodyID);
const dReal * dBodyGetQuaternion (dBodyID);
const dReal * dBodyGetLinearVel  (dBodyID);
const dReal * dBodyGetAngularVel (dBodyID);
void dBodySetMass (dBodyID, const dMass *mass);
void dBodyGetMass (dBodyID, dMass *mass);
void dBodyAddForce            (dBodyID, dReal fx, dReal fy, dReal fz);
void dBodyAddTorque           (dBodyID, dReal fx, dReal fy, dReal fz);
void dBodyAddRelForce         (dBodyID, dReal fx, dReal fy, dReal fz);
void dBodyAddRelTorque        (dBodyID, dReal fx, dReal fy, dReal fz);
void dBodyAddForceAtPos       (dBodyID, dReal fx, dReal fy, dReal fz,
			                dReal px, dReal py, dReal pz);
void dBodyAddForceAtRelPos    (dBodyID, dReal fx, dReal fy, dReal fz,
			                dReal px, dReal py, dReal pz);
void dBodyAddRelForceAtPos    (dBodyID, dReal fx, dReal fy, dReal fz,
			                dReal px, dReal py, dReal pz);
void dBodyAddRelForceAtRelPos (dBodyID, dReal fx, dReal fy, dReal fz,
			                dReal px, dReal py, dReal pz);
const dReal * dBodyGetForce   (dBodyID);
const dReal * dBodyGetTorque  (dBodyID);
void dBodySetForce  (dBodyID b, dReal x, dReal y, dReal z);
void dBodySetTorque (dBodyID b, dReal x, dReal y, dReal z);
void dBodyGetRelPointPos    (dBodyID, dReal px, dReal py, dReal pz,
			     dVector3 result);
void dBodyGetRelPointVel    (dBodyID, dReal px, dReal py, dReal pz,
			     dVector3 result);
void dBodyGetPointVel       (dBodyID, dReal px, dReal py, dReal pz,
			     dVector3 result);
void dBodyGetPosRelPoint    (dBodyID, dReal px, dReal py, dReal pz,
			     dVector3 result);
void dBodyVectorToWorld     (dBodyID, dReal px, dReal py, dReal pz,
			     dVector3 result);
void dBodyVectorFromWorld   (dBodyID, dReal px, dReal py, dReal pz,
			     dVector3 result);
void dBodySetFiniteRotationMode (dBodyID, int mode);
void dBodySetFiniteRotationAxis (dBodyID, dReal x, dReal y, dReal z);
int dBodyGetFiniteRotationMode (dBodyID);
void dBodyGetFiniteRotationAxis (dBodyID, dVector3 result);
int dBodyGetNumJoints (dBodyID b);
dJointID dBodyGetJoint (dBodyID, int index);
void dBodyEnable (dBodyID);
void dBodyDisable (dBodyID);
int dBodyIsEnabled (dBodyID);
void dBodySetGravityMode (dBodyID b, int mode);
int dBodyGetGravityMode (dBodyID b);
/* joints */
dJointID dJointCreateBall (dWorldID, dJointGroupID);
dJointID dJointCreateHinge (dWorldID, dJointGroupID);
dJointID dJointCreateSlider (dWorldID, dJointGroupID);
dJointID dJointCreateContact (dWorldID, dJointGroupID, const dContact *);
dJointID dJointCreateHinge2 (dWorldID, dJointGroupID);
dJointID dJointCreateUniversal (dWorldID, dJointGroupID);
dJointID dJointCreateFixed (dWorldID, dJointGroupID);
dJointID dJointCreateNull (dWorldID, dJointGroupID);
dJointID dJointCreateAMotor (dWorldID, dJointGroupID);
void dJointDestroy (dJointID);
dJointGroupID dJointGroupCreate (int max_size);
void dJointGroupDestroy (dJointGroupID);
void dJointGroupEmpty (dJointGroupID);
void dJointAttach (dJointID, dBodyID body1, dBodyID body2);
void dJointSetData (dJointID, void *data);
void *dJointGetData (dJointID);
int dJointGetType (dJointID);
dBodyID dJointGetBody (dJointID, int index);
void dJointSetFeedback (dJointID, dJointFeedback *);
dJointFeedback *dJointGetFeedback (dJointID);
void dJointSetBallAnchor (dJointID, dReal x, dReal y, dReal z);
void dJointSetHingeAnchor (dJointID, dReal x, dReal y, dReal z);
void dJointSetHingeAxis (dJointID, dReal x, dReal y, dReal z);
void dJointSetHingeParam (dJointID, int parameter, dReal value);
void dJointAddHingeTorque(dJointID joint, dReal torque);
void dJointSetSliderAxis (dJointID, dReal x, dReal y, dReal z);
void dJointSetSliderParam (dJointID, int parameter, dReal value);
void dJointAddSliderForce(dJointID joint, dReal force);
void dJointSetHinge2Anchor (dJointID, dReal x, dReal y, dReal z);
void dJointSetHinge2Axis1 (dJointID, dReal x, dReal y, dReal z);
void dJointSetHinge2Axis2 (dJointID, dReal x, dReal y, dReal z);
void dJointSetHinge2Param (dJointID, int parameter, dReal value);
void dJointAddHinge2Torques(dJointID joint, dReal torque1, dReal torque2);
void dJointSetUniversalAnchor (dJointID, dReal x, dReal y, dReal z);
void dJointSetUniversalAxis1 (dJointID, dReal x, dReal y, dReal z);
void dJointSetUniversalAxis2 (dJointID, dReal x, dReal y, dReal z);
void dJointSetUniversalParam (dJointID, int parameter, dReal value);
void dJointAddUniversalTorques(dJointID joint, dReal torque1, dReal torque2);
void dJointSetFixed (dJointID);
void dJointSetAMotorNumAxes (dJointID, int num);
void dJointSetAMotorAxis (dJointID, int anum, int rel,
			  dReal x, dReal y, dReal z);
void dJointSetAMotorAngle (dJointID, int anum, dReal angle);
void dJointSetAMotorParam (dJointID, int parameter, dReal value);
void dJointSetAMotorMode (dJointID, int mode);
void dJointAddAMotorTorques (dJointID, dReal torque1, dReal torque2, dReal torque3);
void dJointGetBallAnchor (dJointID, dVector3 result);
void dJointGetBallAnchor2 (dJointID, dVector3 result);
void dJointGetHingeAnchor (dJointID, dVector3 result);
void dJointGetHingeAnchor2 (dJointID, dVector3 result);
void dJointGetHingeAxis (dJointID, dVector3 result);
dReal dJointGetHingeParam (dJointID, int parameter);
dReal dJointGetHingeAngle (dJointID);
dReal dJointGetHingeAngleRate (dJointID);
dReal dJointGetSliderPosition (dJointID);
dReal dJointGetSliderPositionRate (dJointID);
void dJointGetSliderAxis (dJointID, dVector3 result);
dReal dJointGetSliderParam (dJointID, int parameter);
void dJointGetHinge2Anchor (dJointID, dVector3 result);
void dJointGetHinge2Anchor2 (dJointID, dVector3 result);
void dJointGetHinge2Axis1 (dJointID, dVector3 result);
void dJointGetHinge2Axis2 (dJointID, dVector3 result);
dReal dJointGetHinge2Param (dJointID, int parameter);
dReal dJointGetHinge2Angle1 (dJointID);
dReal dJointGetHinge2Angle1Rate (dJointID);
dReal dJointGetHinge2Angle2Rate (dJointID);
void dJointGetUniversalAnchor (dJointID, dVector3 result);
void dJointGetUniversalAnchor2 (dJointID, dVector3 result);
void dJointGetUniversalAxis1 (dJointID, dVector3 result);
void dJointGetUniversalAxis2 (dJointID, dVector3 result);
dReal dJointGetUniversalParam (dJointID, int parameter);
dReal dJointGetUniversalAngle1 (dJointID);
dReal dJointGetUniversalAngle2 (dJointID);
dReal dJointGetUniversalAngle1Rate (dJointID);
dReal dJointGetUniversalAngle2Rate (dJointID);
int dJointGetAMotorNumAxes (dJointID);
void dJointGetAMotorAxis (dJointID, int anum, dVector3 result);
int dJointGetAMotorAxisRel (dJointID, int anum);
dReal dJointGetAMotorAngle (dJointID, int anum);
dReal dJointGetAMotorAngleRate (dJointID, int anum);
dReal dJointGetAMotorParam (dJointID, int parameter);
int dJointGetAMotorMode (dJointID);
int dAreConnected (dBodyID, dBodyID);
int dAreConnectedExcluding (dBodyID, dBodyID, int joint_type);
typedef void dJointBreakCallback (dJointID joint);
enum {
  dJOINT_BROKEN = 1, dJOINT_DELETE_ON_BREAK = 2,
  dJOINT_BREAK_AT_B1_FORCE = 4, dJOINT_BREAK_AT_B1_TORQUE = 8,
  dJOINT_BREAK_AT_B2_FORCE = 16, dJOINT_BREAK_AT_B2_TORQUE = 32
};
void dJointSetBreakable (dJointID, int b);
void dJointSetBreakCallback (dJointID, dJointBreakCallback *callbackFunc);
void dJointSetBreakMode (dJointID, int mode);
int dJointGetBreakMode (dJointID);
void dJointSetBreakForce (dJointID, int body, dReal x, dReal y, dReal z);
void dJointSetBreakTorque (dJointID, int body, dReal x, dReal y, dReal z);
int dJointIsBreakable (dJointID);
void dJointGetBreakForce (dJointID, int body, dReal *force);
void dJointGetBreakTorque (dJointID, int body, dReal *torque);
/* collision_space */
typedef void dNearCallback (void *data, dGeomID o1, dGeomID o2);
dSpaceID dSimpleSpaceCreate (dSpaceID space);
dSpaceID dHashSpaceCreate (dSpaceID space);
dSpaceID dQuadTreeSpaceCreate (dSpaceID space, dVector3 Center, dVector3 Extents, int Depth);
void dSpaceDestroy (dSpaceID);
void dHashSpaceSetLevels (dSpaceID space, int minlevel, int maxlevel);
void dHashSpaceGetLevels (dSpaceID space, int *minlevel, int *maxlevel);
void dSpaceSetCleanup (dSpaceID space, int mode);
int dSpaceGetCleanup (dSpaceID space);
void dSpaceAdd (dSpaceID, dGeomID);
void dSpaceRemove (dSpaceID, dGeomID);
int dSpaceQuery (dSpaceID, dGeomID);
void dSpaceClean (dSpaceID);
int dSpaceGetNumGeoms (dSpaceID);
dGeomID dSpaceGetGeom (dSpaceID, int i);
/* collision: general functions */
void dGeomDestroy (dGeomID);
void dGeomSetData (dGeomID, void *);
void *dGeomGetData (dGeomID);
void dGeomSetBody (dGeomID, dBodyID);
dBodyID dGeomGetBody (dGeomID);
void dGeomSetPosition (dGeomID, dReal x, dReal y, dReal z);
void dGeomSetRotation (dGeomID, const dMatrix3 R);
void dGeomSetQuaternion (dGeomID, const dQuaternion);
const dReal * dGeomGetPosition (dGeomID);
const dReal * dGeomGetRotation (dGeomID);
void dGeomGetQuaternion (dGeomID, dQuaternion result);
void dGeomGetAABB (dGeomID, dReal aabb[6]);
int dGeomIsSpace (dGeomID);
dSpaceID dGeomGetSpace (dGeomID);
int dGeomGetClass (dGeomID);
void dGeomSetCategoryBits (dGeomID, unsigned long bits);
void dGeomSetCollideBits (dGeomID, unsigned long bits);
unsigned long dGeomGetCategoryBits (dGeomID);
unsigned long dGeomGetCollideBits (dGeomID);
void dGeomEnable (dGeomID);
void dGeomDisable (dGeomID);
int dGeomIsEnabled (dGeomID);
/* collision detection */
int dCollide (dGeomID o1, dGeomID o2, int flags, dContactGeom *contact,
	      int skip);
void dSpaceCollide (dSpaceID space, void *data, dNearCallback *callback);
void dSpaceCollide2 (dGeomID o1, dGeomID o2, void *data,
		     dNearCallback *callback);
enum {
  dSphereClass = 0,
  dBoxClass,
  dCCylinderClass,
  dCylinderClass,
  dPlaneClass,
  dRayClass,
  dGeomTransformClass,
  dTriMeshClass,
  dFirstSpaceClass,
  dSimpleSpaceClass = dFirstSpaceClass,
  dHashSpaceClass,
  dQuadTreeSpaceClass,
  dLastSpaceClass = dQuadTreeSpaceClass,
  dFirstUserClass,
  dLastUserClass = dFirstUserClass + 4 - 1,
  dGeomNumClasses
};
dGeomID dCreateSphere (dSpaceID space, dReal radius);
void dGeomSphereSetRadius (dGeomID sphere, dReal radius);
dReal dGeomSphereGetRadius (dGeomID sphere);
dReal dGeomSpherePointDepth (dGeomID sphere, dReal x, dReal y, dReal z);
dGeomID dCreateBox (dSpaceID space, dReal lx, dReal ly, dReal lz);
void dGeomBoxSetLengths (dGeomID box, dReal lx, dReal ly, dReal lz);
void dGeomBoxGetLengths (dGeomID box, dVector3 result);
dReal dGeomBoxPointDepth (dGeomID box, dReal x, dReal y, dReal z);
dGeomID dCreatePlane (dSpaceID space, dReal a, dReal b, dReal c, dReal d);
void dGeomPlaneSetParams (dGeomID plane, dReal a, dReal b, dReal c, dReal d);
void dGeomPlaneGetParams (dGeomID plane, dVector4 result);
dReal dGeomPlanePointDepth (dGeomID plane, dReal x, dReal y, dReal z);
dGeomID dCreateCylinder (dSpaceID space, dReal radius, dReal length);
void dGeomCylinderSetParams (dGeomID ccylinder, dReal radius, dReal length);
void dGeomCylinderGetParams (dGeomID ccylinder, dReal *radius, dReal *length);
dGeomID dCreateCCylinder (dSpaceID space, dReal radius, dReal length);
void dGeomCCylinderSetParams (dGeomID ccylinder, dReal radius, dReal length);
void dGeomCCylinderGetParams (dGeomID ccylinder, dReal *radius, dReal *length);
dReal dGeomCCylinderPointDepth (dGeomID ccylinder, dReal x, dReal y, dReal z);
dGeomID dCreateRay (dSpaceID space, dReal length);
void dGeomRaySetLength (dGeomID ray, dReal length);
dReal dGeomRayGetLength (dGeomID ray);
void dGeomRaySet (dGeomID ray, dReal px, dReal py, dReal pz,
		  dReal dx, dReal dy, dReal dz);
void dGeomRayGet (dGeomID ray, dVector3 start, dVector3 dir);
void dGeomRaySetParams (dGeomID g, int FirstContact, int BackfaceCull);
void dGeomRayGetParams (dGeomID g, int *FirstContact, int *BackfaceCull);
void dGeomRaySetClosestHit (dGeomID g, int closestHit);
int dGeomRayGetClosestHit (dGeomID g);
dGeomID dCreateGeomTransform (dSpaceID space);
void dGeomTransformSetGeom (dGeomID g, dGeomID obj);
dGeomID dGeomTransformGetGeom (dGeomID g);
void dGeomTransformSetCleanup (dGeomID g, int mode);
int dGeomTransformGetCleanup (dGeomID g);
void dGeomTransformSetInfo (dGeomID g, int mode);
int dGeomTransformGetInfo (dGeomID g);
/* collision: triangle meshes */
struct dxTriMeshData;
typedef struct dxTriMeshData* dTriMeshDataID;
dTriMeshDataID dGeomTriMeshDataCreate();
void dGeomTriMeshDataDestroy(dTriMeshDataID g);
enum { TRIMESH_FACE_NORMALS, TRIMESH_LAST_TRANSFORMATION };
void dGeomTriMeshDataSet(dTriMeshDataID g, int data_id, void* data);
void dGeomTriMeshDataBuildSingle(dTriMeshDataID g,
                                 const void* Vertices, int VertexStride, int VertexCount, 
                                 const void* Indices, int IndexCount, int TriStride);
void dGeomTriMeshDataBuildSingle1(dTriMeshDataID g,
                                  const void* Vertices, int VertexStride, int VertexCount, 
                                  const void* Indices, int IndexCount, int TriStride,
                                  const void* Normals);
void dGeomTriMeshDataBuildDouble(dTriMeshDataID g, 
                                 const void* Vertices,  int VertexStride, int VertexCount, 
                                 const void* Indices, int IndexCount, int TriStride);
void dGeomTriMeshDataBuildDouble1(dTriMeshDataID g, 
                                  const void* Vertices,  int VertexStride, int VertexCount, 
                                  const void* Indices, int IndexCount, int TriStride,
                                  const void* Normals);
void dGeomTriMeshDataBuildSimple(dTriMeshDataID g,
                                 const dReal* Vertices, int VertexCount,
                                 const int* Indices, int IndexCount);
void dGeomTriMeshDataBuildSimple1(dTriMeshDataID g,
                                  const dReal* Vertices, int VertexCount,
                                  const int* Indices, int IndexCount,
                                  const int* Normals);
typedef int dTriCallback(dGeomID TriMesh, dGeomID RefObject, int TriangleIndex);
void dGeomTriMeshSetCallback(dGeomID g, dTriCallback* Callback);
dTriCallback* dGeomTriMeshGetCallback(dGeomID g);
typedef void dTriArrayCallback(dGeomID TriMesh, dGeomID RefObject, const int* TriIndices, int TriCount);
void dGeomTriMeshSetArrayCallback(dGeomID g, dTriArrayCallback* ArrayCallback);
dTriArrayCallback* dGeomTriMeshGetArrayCallback(dGeomID g);
typedef int dTriRayCallback(dGeomID TriMesh, dGeomID Ray, int TriangleIndex, dReal u, dReal v);
void dGeomTriMeshSetRayCallback(dGeomID g, dTriRayCallback* Callback);
dTriRayCallback* dGeomTriMeshGetRayCallback(dGeomID g);
dGeomID dCreateTriMesh(dSpaceID space, dTriMeshDataID Data, dTriCallback* Callback, dTriArrayCallback* ArrayCallback, dTriRayCallback* RayCallback);
void dGeomTriMeshSetData(dGeomID g, dTriMeshDataID Data);
void dGeomTriMeshEnableTC(dGeomID g, int geomClass, int enable);
int dGeomTriMeshIsTCEnabled(dGeomID g, int geomClass);
void dGeomTriMeshClearTCCache(dGeomID g);
dTriMeshDataID dGeomTriMeshGetTriMeshDataID(dGeomID g);
void dGeomTriMeshGetTriangle(dGeomID g, int Index, dVector3* v0, dVector3* v1, dVector3* v2);
void dGeomTriMeshGetPoint(dGeomID g, int Index, dReal u, dReal v, dVector3 Out);
/* collision: utility functions */
void dClosestLineSegmentPoints (const dVector3 a1, const dVector3 a2,
				const dVector3 b1, const dVector3 b2,
				dVector3 cp1, dVector3 cp2);
int dBoxTouchesBox (const dVector3 _p1, const dMatrix3 R1,
		    const dVector3 side1, const dVector3 _p2,
		    const dMatrix3 R2, const dVector3 side2);
void dInfiniteAABB (dGeomID geom, dReal aabb[6]);
void dCloseODE();
/* collision: custom classes */
typedef void dGetAABBFn (dGeomID, dReal aabb[6]);
typedef int dColliderFn (dGeomID o1, dGeomID o2,
			 int flags, dContactGeom *contact, int skip);
typedef dColliderFn * dGetColliderFnFn (int num);
typedef void dGeomDtorFn (dGeomID o);
typedef int dAABBTestFn (dGeomID o1, dGeomID o2, dReal aabb[6]);
typedef struct dGeomClass {
  int bytes;
  dGetColliderFnFn *collider;
  dGetAABBFn *aabb;
  dAABBTestFn *aabb_test;
  dGeomDtorFn *dtor;
} dGeomClass;
int dCreateGeomClass (const dGeomClass *classptr);
void * dGeomGetClassData (dGeomID);
dGeomID dCreateGeom (int classnum);
#endif // ODE_H