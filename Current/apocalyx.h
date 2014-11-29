#ifndef APOCALYX_H
#define APOCALYX_H
//// 3D engine
// Vector
typedef struct Vector Vector;
Vector* vectorCreate(float x, float y, float z);
int vectorDelete(Vector* v);
Vector* vectorSet(Vector* v, float x, float y, float z);
Vector* vectorGet(Vector* v, float* x, float* y, float* z);
Vector* vectorAdd(Vector* v, Vector* a);
Vector* vectorSubtract(Vector* v, Vector* a);
Vector* vectorScale(Vector* v, float scale);
float vectorDot(Vector* v, Vector* d);
Vector* vectorCross(Vector* v, Vector* c);
float vectorNorm2(Vector* v);
float vectorDist2(Vector* v, Vector* d);
Vector* vectorNormalize(Vector* v);
// Void
typedef struct Void Void;
Void* pointerReinterpretAsVoid(void* ptr);
// Matrix
typedef struct Matrix Matrix;
Matrix* voidCastToMatrix(Void* v);
Matrix* matrixCreate(void);
int matrixDelete(Matrix* m);
Matrix* matrixSet(Matrix* m, Matrix* clone);
float* matrixGet(Matrix* m);
Matrix* matrixMultiply(Matrix* m, Vector* v);
Matrix* matrixRotate(Matrix* m, Matrix* rot);
Matrix* matrixRotateT(Matrix* m, Matrix* rot);
Matrix* matrixExchangeYZX(Matrix* m);
Matrix* matrixInterpolate(Matrix* m, Matrix* target, float factor);
// Transform
typedef struct Transform Transform;
Matrix* transformCastToMatrix(Transform* t);
Transform* matrixCastToTransform(Matrix* m);
Transform* transformCreate(void);
int transformDelete(Transform* r);
Transform* transformReset(Transform* r);
Transform* transformScale(Transform* r, float sx, float sy, float sz);
Transform* transformMove(Transform* r, Vector* v);
Transform* transformMoveForward(Transform* r, float step);
Transform* transformMoveSide(Transform* r, float step);
Transform* transformMoveUp(Transform* r, float step);
Transform* transformMoveStanding(Transform* r, float step);
Transform* transformRoll(Transform* r, float angle);
Transform* transformYaw(Transform* r, float angle);
Transform* transformPitch(Transform* r, float angle);
Transform* transformRotStanding(Transform* r, float angle);
Transform* transformSetPosition(Transform* r, Vector* v);
Transform* transformGetPosition(Transform* r, Vector* result);
Transform* transformSetViewDirection(Transform* r, Vector* v);
Transform* transformGetViewDirection(Transform* r, Vector* result);
Transform* transformSetUpDirection(Transform* r, Vector* v);
Transform* transformGetUpDirection(Transform* r, Vector* result);
Transform* transformSetSideDirection(Transform* r, Vector* v);
Transform* transformGetSideDirection(Transform* r, Vector* result);
Transform* transformRotAround(Transform* r, float angle);
Transform* transformPointTo(Transform* r, Vector* v);
// Image
typedef struct Image Image;
Image* voidCastToImage(Void* v);
Image* imageRGBCreate(int w, int h);
Image* imageRGBACreate(int w, int h);
Image* imageGrayscaleCreate(int w, int h);
int imageDelete(Image* i);
int imageIsGrayscale(Image* i);
int imageHasAlpha(Image* i);
Image* imageSetPixel(Image* i, int x, int y,
  unsigned char r, unsigned char g, unsigned char b, unsigned char a);
Image* imageGetPixel(Image* i, int x, int y,
  unsigned char* r, unsigned char* g, unsigned char* b, unsigned char* a);
Image* imageGetDimension(Image* i, float* w, float* h);
Image* imageConvertTo111A(Image* i, float grayShade);
Image* imageConvertToRGB(Image* i);
Image* imageConvertToRGBA(Image* i);
Image* imageConvertToRGBmA(Image* i);
Image* imageConvertToGray(Image* i);
Image* imageConvertToBump(Image* i, float scaleSide, float scaleWidth);
Image* imageAddAlpha(Image* i, Image* alpha, int threshold, int cutoff);
int imageResample(Image* i, int newWidth, int newHeight);
int saveAsPng(Image* i, const char* fileName, int useFilters);
// OverlayObject
typedef struct OverlayObject OverlayObject;
OverlayObject* voidCastToOverlayObject(Void* v);
OverlayObject* overlayObjectSetVisible(OverlayObject* oo, int v);
OverlayObject* overlayObjectSetLayer(OverlayObject* oo, float layer);
// OverlayFader
typedef struct OverlayFader OverlayFader;
OverlayObject* overlayFaderCastToOverlayObject(OverlayFader* o);
OverlayFader* overlayObjectCastToOverlayFader(OverlayObject* o);
OverlayFader* overlayFaderCreate(void);
OverlayFader* overlayFaderSetColor(
  OverlayFader* of, float r, float g, float b, float a
);
// Font
typedef struct Font Font;
Font* voidCastToFont(Void* v);
Font* texturedFontCreate(int height, int width, int spacing, Image* image);
Font* bitmapFontCreate(
	const char* faceName, float h, float w, int isBold, int isItalic
);
int fontDelete(Font* f);
// Font3D
typedef struct Font3D Font3D;
Font3D* voidCastToFont3D(Void* v);
Font3D* font3DCreate(
  const char* faceName, float h, float w, float d, int isBold, int isItalic
);
int font3DDelete(Font3D* f);
float font3DGetHeight(Font3D* f);
// OverlayText
typedef struct OverlayText OverlayText;
OverlayText* voidCastToOverlayText(Void* v);
OverlayText* overlayTextCreate(const char* string);
OverlayText* overlayTextSetVisible(OverlayText* ot, int v);
OverlayText* overlayTextSetAlignment(OverlayText* ot, int align);
OverlayText* overlayTextSetScale(OverlayText* ot, float scale);
OverlayText* overlayTextSetColor(
  OverlayText* ot, float r, float g, float b, float a
);
OverlayText* overlayTextSetLocation(
  OverlayText* ot, float x, float y);
OverlayText* overlayTextGetLocation(
  OverlayText* ot, float* x, float* y);
OverlayText* overlayTextSetRotation(OverlayText* ot, float rot);
float overlayTextGetRotation(OverlayText* ot);
OverlayText* overlayTextSetText(OverlayText* ot, const char* string);
const char* overlayTextGetText(OverlayText* ot);
// OverlayTexts
typedef struct OverlayTexts OverlayTexts;
OverlayObject* overlayTextsCastToOverlayObject(OverlayTexts* o);
OverlayTexts* overlayObjectCastToOverlayTexts(OverlayObject* o);
OverlayTexts* overlayTextsCreate(Font* f);
OverlayTexts* overlayTextsSetLocation(
  OverlayTexts* ot, float x, float y
);
OverlayTexts* overlayTextsGetLocation(
  OverlayTexts* ot, float *x, float *y
);
OverlayTexts* overlayTextsSetRotation(OverlayTexts* ot, float rot);
float overlayTextsGetRotation(OverlayTexts* ot);
const OverlayText* overlayTextsGetTextAt(OverlayTexts* ot, float x, float y);
const OverlayText* overlayTextsGetText(OverlayTexts* ot, int idx);
OverlayTexts* overlayTextsAdd(OverlayTexts* ots, OverlayText* ot);
OverlayTexts* overlayTextsRemove(OverlayTexts* ots, OverlayText* ot);
int overlayTextsGetCount(OverlayTexts* ot);
// Texture
typedef struct Texture Texture;
Texture* voidCastToTexture(Void* v);
Texture* textureCreate(
  Image* image, int isRepeated, int doMipmaps, int is1D
);
int textureDelete(Texture* t);
// BumpedTexture
typedef struct BumpedTexture BumpedTexture;
Texture* bumpedTextureCastToTexture(BumpedTexture* t);
// AnimatedTexture
typedef struct AnimatedTexture AnimatedTexture;
Texture* animatedTextureCastToTexture(AnimatedTexture* t);
AnimatedTexture* textureCastToAnimatedTexture(Texture* t);
AnimatedTexture* animatedTextureCreate(
  int imagesCount, Image** imagesArray, float duration, int isRepeated
);
// OverlaySprite
typedef struct OverlaySprite OverlaySprite;
OverlayObject* overlaySpriteCastToOverlayObject(OverlaySprite* o);
OverlaySprite* overlayObjectCastToOverlaySprite(OverlayObject* o);
OverlaySprite* overlaySpriteCreate(float w, float h, Texture* t, int hasAlpha);
OverlaySprite* overlaySpriteSetColor(
  OverlaySprite* os,  float r, float g, float b, float a
);
OverlaySprite* overlaySpriteSetLocation(OverlaySprite* os, float x, float y);
OverlaySprite* overlaySpriteGetLocation(OverlaySprite* os, float* x, float* y);
OverlaySprite* overlaySpriteSetRotation(OverlaySprite* os, float rot);
float overlaySpriteGetRotation(OverlaySprite* os);
OverlaySprite* overlaySpriteSetDimension(OverlaySprite* os, float w, float h);
OverlaySprite* overlaySpriteGetDimension(OverlaySprite* os, float* w, float* h);
OverlaySprite* overlaySpriteSetTextureCoord(
  OverlaySprite* os, float l, float b, float r, float t
);
// OverlayPoints
typedef struct OverlayPoints OverlayPoints;
OverlayObject* overlayPointsCastToOverlayObject(OverlayPoints* o);
OverlayPoints* overlayObjectCastToOverlayPoints(OverlayObject* o);
OverlayPoints* overlayPointsCreate(
  int coordCount, float* coords, unsigned char* colors
);
int overlayPointsGetCount(OverlayPoints* p);
OverlayPoints* overlayPointsSetCoordsData(OverlayPoints* p,
  int index, float x, float y);
OverlayPoints* overlayPointsGetCoordsData(OverlayPoints* p,
  int index, float* x, float* y);
OverlayPoints* overlayPointsSetColorsData(OverlayPoints* p,
  int index, float r, float g, float b, float a);
OverlayPoints* overlayPointsGetColorsData(OverlayPoints* p,
  int index, float* r, float* g, float* b, float* a);
OverlayPoints* overlayPointsSetSmoothColor(OverlayPoints* p, int b);
OverlayPoints* overlayPointsSetSize(OverlayPoints* p, float f);
OverlayPoints* overlayPointsSetColor(OverlayPoints* os,
  float r, float g, float b, float a);
OverlayPoints* overlayPointsSetLocation(OverlayPoints* os, float x, float y);
OverlayPoints* overlayPointsGetLocation(OverlayPoints* os, float* x, float* y);
OverlayPoints* overlayPointsSetRotation(OverlayPoints* os, float rot);
float overlayPointsGetRotation(OverlayPoints* os);
// OverlayLines
typedef struct OverlayLines OverlayLines;
OverlayPoints* overlayLinesCastToOverlayPoints(OverlayLines* o);
OverlayLines* overlayPointsCastToOverlayLines(OverlayPoints* o);
OverlayLines* overlayLinesCreate(
  int indexesCount, unsigned short* indexes, int coordCount, float* coords,
  unsigned char* colors
);
OverlayLines* overlayLinesSetStipple(OverlayLines* l, unsigned short pattern, int factor);
OverlayLines* overlayLinesSetModeLineLoop(OverlayLines* l);
OverlayLines* overlayLinesSetModeLineStrip(OverlayLines* l);
// OverlayPolys
typedef struct OverlayPolys OverlayPolys;
OverlayLines* overlayPolysCastToOverlayLines(OverlayPolys* o);
OverlayPolys* overlayLinesCastToOverlayPolys(Lines* o);
OverlayPolys* overlayPolysCreate(
  int indexesCount, unsigned short* indexes, int coordCount, float* coords,
  unsigned char* colors
);
OverlayPolys* overlayPolysSetMask(OverlayPolys* p, unsigned char* mask);
OverlayPolys* overlayPolysSetModeTriangs(OverlayPolys* p);
OverlayPolys* overlayPolysSetModeTriangStrip(OverlayPolys* p);
OverlayPolys* overlayPolysSetModeTriangFan(OverlayPolys* p);
OverlayPolys* overlayPolysSetFillPoint(OverlayPolys* p);
OverlayPolys* overlayPolysSetFillLine(OverlayPolys* p);
// Material
typedef struct Material Material;
Material* voidCastToMaterial(Void* v);
Material* materialCreate(void);
int materialDelete(Material* bm);
Material* materialSetAmbient(Material* m, float r, float g, float b, float a);
Material* materialSetDiffuse(Material* m, float r, float g, float b, float a);
Material* materialSetSpecular(Material* bm, float r, float g, float b, float a);
Material* materialSetEmissive(Material* bm, float r, float g, float b, float a);
Material* materialSetShininess(Material* bm, float s);
Material* materialSetTransparency(Material* bm, float t);
Material* materialSetDiffuseTexture(Material* bm, Texture* t);
Material* materialSetEnlighted(Material* bm, int e);
Material* materialSetEnvironment(Material* m, float e);
Material* materialSetGlossTexture(Material* m, Texture* t);
Material* materialSetEnvironmentTexture(Material* m, Texture* t);
// BumpedMaterial
typedef struct BumpedMaterial BumpedMaterial;
Material* bumpedMaterialCastToMaterial(BumpedMaterial* m);
BumpedMaterial* materialCastToBumpedMaterial(Material* m);
BumpedMaterial* bumpedMaterialCreate(void);
BumpedMaterial* bumpedMaterialSetBump(BumpedMaterial* bm, float b);
BumpedMaterial* bumpedMaterialSetBumpedTexture(BumpedMaterial* bm, BumpedTexture* t);
// Program
typedef struct Program Program;
Program* voidCastToProgram(Void* v);
int programDelete(Program* p);
int programIsValid(Program* p);
Program* programApply(Program* p);
Program* programUnapply(Program* p);
Program* programSetLocalParameter(
  Program* p, int idx, float x, float y, float z, float w
);
Program* programSetEnvParameter(
  Program* p, int idx, float x, float y, float z, float w
);
// VertexProgram
typedef struct VertexProgram VertexProgram;
Program* vertexProgramCastToProgram(VertexProgram* p);
VertexProgram* programCastToVertexProgram(Program* p);
VertexProgram* vertexProgramCreate(const char* asciiSource);
// FragmentProgram
typedef struct FragmentProgram FragmentProgram;
Program* fragmentProgramCastToProgram(FragmentProgram* p);
FragmentProgram* programCastToFragmentProgram(Program* p);
FragmentProgram* fragmentProgramCreate(const char* asciiSource);
// ProgramMaterial
typedef struct ProgramMaterial ProgramMaterial;
Material* programMaterialCastToMaterial(ProgramMaterial* o);
ProgramMaterial* materialCastToProgramMaterial(Material* o);
ProgramMaterial* programMaterialCreate(void);
ProgramMaterial* programMaterialSetVertexProgram(
  ProgramMaterial* pm, VertexProgram* vp
);
ProgramMaterial* programMaterialSetFragmentProgram(
  ProgramMaterial* pm, FragmentProgram* fp
);
ProgramMaterial* programMaterialAddTexture(ProgramMaterial* pm, Texture* t);
// Shader
typedef struct Shader Shader;
Shader* voidCastToShader(Void* v);
int shaderDelete(Shader* s);
int shaderIsCompiled(Shader* s);
Shader* shaderGetInfo(Shader* s, int len, char* buffer);
int shaderCompile(Shader* s, const char* source);
// VertexShader
Shader* vertexShaderCreate(const char* source);
// FragmentShader
Shader* fragmentShaderCreate(const char* source);
// ShaderProgram
typedef struct ShaderProgram ShaderProgram;
ShaderProgram* voidCastToShaderProgram(Void* v);
ShaderProgram* shaderProgramCreate(void);
int shaderProgramDelete(ShaderProgram* sp);
ShaderProgram* shaderProgramGetInfo(ShaderProgram* sp, int len, char* buffer);
ShaderProgram* shaderProgramAttach(ShaderProgram* sp, Shader* s);
ShaderProgram* shaderProgramDetach(ShaderProgram* sp, Shader* s);
int shaderProgramLink(ShaderProgram* sp);
int shaderProgramValidate(ShaderProgram* sp);
ShaderProgram* shaderProgramApply(ShaderProgram* sp);
int shaderProgramGetUniformLocation(ShaderProgram* sp, const char* uniformName);
ShaderProgram* shaderProgramSetUniformFloats(
  ShaderProgram* sp, int index, float x, float y, float z, float w
);
ShaderProgram* shaderProgramSetUniformInt(ShaderProgram* sp, int index, int x);
ShaderProgram* shaderProgramSetUniformMatrix2(
  ShaderProgram* sp, int index, int count, float* array
);
ShaderProgram* shaderProgramSetUniformMatrix3(
  ShaderProgram* sp, int index, int count, float* array
);
ShaderProgram* shaderProgramSetUniformMatrix4(
  ShaderProgram* sp, int index, int count, float* array
);
// ShaderMaterial
typedef struct ShaderMaterial ShaderMaterial;
Material* shaderMaterialCastToMaterial(ShaderMaterial* m);
ShaderMaterial* materialCastToShaderMaterial(Material* m);
ShaderMaterial* shaderMaterialCreate(void);
ShaderMaterial* shaderMaterialSetShaderProgram(
  ShaderMaterial* sm, ShaderProgram* sp
);
ShaderMaterial* shaderMaterialAddTexture(ShaderMaterial* sm, Texture* t);
// Camera
typedef struct Camera Camera;
Transform* cameraCastToTransform(Camera* c);
Camera* transformCastToCamera(Reference* o);
Camera* cameraGetHorizontalView(Camera* c, float* x, float* z);
Camera* cameraProject(GLCamera* c,
  double objX, double objY, double objZ,
  double* winX, double* winY, double* winZ
);
Camera* cameraUnproject(GLCamera* c,
  double winX, double winY, double winZ
  double* objX, double* objY, double* objZ
);
// Object
typedef struct Object Object;
Transform* objectCastToTransform(Object* o);
int objectIsClipped(Object* o);
int objectIsVisible(Object* o);
Object* objectSetVisible(Object* o, int v);
Object* objectSetTransparent(Object* o, int t);
int objectIncludes(Object* o, Vector* p);
float objectGetMaxRadius(Object* o);
Object* objectSetMaxRadius(Object* o, float r);
float objectGetDistance(Object* o);
typedef void (*ObjectCallback)(Object* o, Camera* c);
Object* objectCreate(ObjectCallback renderObject);
// Shadowed
typedef struct Shadowed Shadowed;
typedef struct ShadowedDelegate ShadowedDelegate;
int shadowedIsShadowed(Shadowed* s);
Shadowed* shadowedSetShadowed(Shadowed* s, int b);
Shadowed* shadowedSetShadowOffset(Shadowed* s, float offset);
Shadowed* shadowedSetShadowFadeDistance(Shadowed* s, float distance);
Shadowed* shadowedSetShadowIntensity(Shadowed* s, float intensity);
Shadowed* shadowedAddDelegate(Shadowed* s, ShadowedDelegate* delegate);
Shadowed* shadowedRemoveDelegate(Shadowed* s, ShadowedDelegate* delegate);
int shadowedAreShadowsStatic(Shadowed* s);
Shadowed* shadowedSetShadowsStatic(
  Shadowed* s, int isStatic, Vector* dir
);
// Shadow
typedef struct Shadow Shadow;
Shadow* voidCastToShadow(Void* v);
Shadow* shadowCreate(Object* o, float w, float h, Texture* t);
Shadow* shadowSetMode(Shadow* o, int mode);
Shadow* shadowSetColor(Shadow* o, float r, float g, float b);
Shadow* shadowSetMaxRadius(Shadow* o, float r);
float shadowGetMaxRadius(Shadow* o);
// Objects
typedef struct Objects Objects;
Object* objectsCastToObject(Objects* o);
Objects* objectCastToObjects(Object* o);
Objects* objectsCreate(void);
Objects* objectsAdd(Objects* os, Object* o);
int objectsGetCount(Objects* os);
Object* objectsGetFirst(Objects* os);
Object* objectsGetNext(Objects* os);
// Lod
typedef struct Lod Lod;
Object* lodCastToObject(Lod* o);
Lod* lodCreate(void);
Lod* lodAddLevel(Lod* l, float dist, Object* obj);
// Shape
typedef struct Shape Shape;
Shape* voidCastToShape(Void* v);
Shape* shapeCreate(
  int vertCount, float* vertCoo, float* vertNorm,
  float* vertMap, int triCount, unsigned short* triIndexes
);
int shapeDelete(Shape* s);
int shapeGetVerticesCount(Shape* s);
Shape* shapeSetVertexData(
  Shape* s, int idx, float* coo, float* uv, float* normal
);
Shape* shapeGetVertexData(
  Shape* s, int idx, float* coo, float* uv, float* normal
);
float shapeGetMaxRadius(Shape* s);
Shape* shapeComputeMaxRadius(Shape* s);
Shape* shapeComputeNormals(Shape* s);
Shape* shapeSetDynamic(Shape* s, int d);
Shape* shapeSetTwoSided(Shape* s, int ts);
// ShaderShape
typedef struct ShaderShape ShaderShape;
Shape* shaderShapeCastToShape(ShaderShape* s);
ShaderShape* shaderCastToShaderShape(Shape* s);
ShaderShape* shaderShapeCreate(
  int vertCount, float* vertCoo, float* vertNorm,
  float* vertMap, int triCount, unsigned short* triIndexes
);
ShaderShape* shaderShapeSetColors(
  ShaderShape* s, unsigned char* colors, int colorDim
);
ShaderShape* shaderShapeSetColorData(
  ShaderShape* s, int idx, unsigned char* color
);
ShaderShape* shaderShapeGetColorData(
  ShaderShape* s, int idx, unsigned char* color
);
ShaderShape* shaderShapeSetSecondaryColors(
  ShaderShape* s, unsigned char* colors
);
ShaderShape* shaderShapeSetSecondaryColorData(
  ShaderShape* s, int idx, unsigned char* color
);
ShaderShape* shaderShapeGetSecondaryColorData(
  ShaderShape* s, int idx, unsigned char* color
);
ShaderShape* shaderShapeSetFogCoords(ShaderShape* s, float* fogs);
ShaderShape* shaderShapeSetFogCoordData(ShaderShape* s, int idx, float fog);
float shaderShapeGetFogCoordData(ShaderShape* s, int idx);
ShaderShape* shaderShapeSetTexCoords(
  ShaderShape* s, int texCount, float** texCoords, short* texDims
);
ShaderShape* shaderShapeSetTexCoordData(
  ShaderShape* s, int texIdx, int idx, float* texCoord
);
ShaderShape* shaderShapeGetTexCoordData(
  ShaderShape* s, int texIdx, int idx, float* texCoord
);
// Collider
typedef struct Collider Collider;
Collider* voidCastToCollider(Void* v);
Collider* colliderCreate(Mesh* bm, int isStatic);
int colliderDelete(Collider* c);
Collider* colliderSetShape(Collider* c, Shape* s);
Collider* colliderSetTrianglesCount(Collider* c, int tc);
Collider* colliderAddTriangle(
  Collider* c, float x1[3], float x2[3], float x3[3]
);
Collider* colliderFinalize(Collider* c);
Collider* colliderSetMatrix(Collider* c, Matrix* m);
int colliderCollision(
  Collider* c, Collider* other, Matrix* otherMatrix
);
int ColliderRayCollision(Collider*c, float origin[3], float direc[3]);
int ColliderSphereCollision(Collider*c, float center[3], float radius);
Collider* colliderGetCollidingTriangles(
  Collider* c, float tri1[9], float tri2[9]
);
Collider* colliderGetCollisionPoint(Collider* c, float point[3]);
// PathFound
typedef struct PathFound PathFound;
PathFound* voidCastToPathFound(Void* v);
PathFound* pathFoundCreate();
int pathFoundDelete(PathFound* p);
float pathFoundGetCost(PathFound* p);
int pathFoundGetSize(PathFound* p);
int pathFoundGetNode(PathFound* p, int index);
// PathFinder
typedef struct PathFinder PathFinder;
typedef float (*LeastCostEstimateFunc)(int,int);
typedef int (*AdjacentCostFunc)(int,int**,float**);
PathFinder* voidCastToPathFinder(Void* v);
PathFinder* pathFinderCreate();
int pathFinderDelete(PathFinder* p);
PathFinder* pathFinderSetLeastCostEstimate(PathFinder* p,
  LeastCostEstimateFunc lce);
PathFinder* pathFinderSetAdjacentCost(PathFinder* p,
  AdjacentCostFunc ac);
PathFinder* pathFinderReset(PathFinder* p);
int pathFinderSolve(PathFinder* p, int start, int end, PathFound* path);
// Points
typedef struct Points Points;
Object* pointsCastToObject(Points* o);
Points* objectCastToPoints(Object* o);
Points* pointsCreate(
  int coordCount, float* coords, unsigned char* colors
);
int pointsGetCount(Points* p);
Points* pointsSetCoordsData(Points* p, int index, float x, float y, float z);
Points* pointsGetCoordsData(Points* p, int index, float* x, float* y, float* z);
Points* pointsSetColorsData(Points* p, int index, float r, float g, float b, float a);
Points* pointsGetColorsData(Points* p, int index, float* r, float* g, float* b, float* a);
Points* pointsComputeMaxRadius(Points* p);
Points* pointsSetColor(Points* p, float r, float g, float b, float a);
Points* pointsSetSmoothColor(Points* p, int b);
Points* pointsSetSize(Points* p, float f);
// Lines
typedef struct Lines Lines;
Points* linesCastToPoints(Lines* o);
Lines* pointsCastToLines(Points* o);
Lines* linesCreate(
  int indexesCount, unsigned short* indexes, int coordCount, float* coords,
  unsigned char* colors
);
Lines* linesSetStipple(Lines* l, unsigned short pattern, int factor);
Lines* linesSetModeLineLoop(Lines* l);
Lines* linesSetModeLineStrip(Lines* l);
// Polys
typedef struct Polys Polys;
Lines* polysCastToLines(Polys* o);
Polys* linesCastToPolys(Lines* o);
Polys* polysCreate(
  int indexesCount, unsigned short* indexes, int coordCount, float* coords,
  unsigned char* colors
);
Polys* polysSetMask(Polys* p, unsigned char* mask);
Polys* polysSetModeTriangs(Polys* p);
Polys* polysSetModeTriangStrip(Polys* p);
Polys* polysSetModeTriangFan(Polys* p);
Polys* polysSetFillPoint(Polys* p);
Polys* polysSetFillLine(Polys* p);
// Mesh
typedef struct Mesh Mesh;
Object* meshCastToObject(Mesh* m);
Mesh* objectCastToMesh(Object* o);
Mesh* meshCreate(Shape* s, Material* mt);
int meshDelete(Mesh* o);
Shape* meshGetShape(Mesh* m);
Mesh* meshSetMaterial(Mesh* m, Material* mt);
Material* meshGetMaterial(Mesh* m);
Mesh* meshShowHalo(Mesh* m, float d, float hR, float hG, float hB, float hA);
Mesh* meshHideHalo(Mesh* m);
Mesh* meshClone(Mesh* m);
// BumpedMesh
typedef struct BumpedMesh BumpedMesh;
Mesh* bumpedMeshCastToMesh(BumpedMesh* o);
BumpedMesh* meshCastToBumpedMesh(Mesh* o);
BumpedMesh* bumpedMeshCreate(Shape* s, BumpedMaterial* mt);
BumpedMesh* bumpedMeshClone(BumpedMesh* m);
// BasicModel
typedef struct BasicModel BasicModel;
Object* basicModelCastToObject(BasicModel* t);
BasicModel* objectCastToBasicModel(Object* o);
BasicModel* basicModelLoad(
  const char* path, const char* md2Name,
  const char* imgName, const char* alphaImgName
);
BasicModel* basicModelCreate(BasicModel* clone);
int basicModelDelete(BasicModel* o);
BasicModel* basicModelSetMaterial(BasicModel* m, Material* mt);
Material* basicModelGetMaterial(BasicModel* m);
BasicModel* basicModelRescale(BasicModel* m, float scale);
BasicModel* basicModelSetAnimation(BasicModel* m, int anim, int playBack);
BasicModel* basicModelUpdateAnimation(BasicModel* m);
int basicModelGetStoppedAnimation(BasicModel* m);
BasicModel* basicModelSetAnimationTime(BasicModel* m, float time);
float basicModelGetAnimationTime(BasicModel* m);
// Model
typedef struct Model Model;
Object* modelCastToObject(Model* t);
Model* objectCastToModel(Object* o);
Model* modelLoad(
  const char* path, const char* md3Name,
  const char* imgName, const char* alphaImgName
);
Model* modelCreate(Model* clone);
int modelDelete(Model* o);
Model* modelSetMaterial(Model* m, Material* mt);
Material* modelGetMaterial(Model* m);
Model* modelRescale(Model* m, float scale);
Model* modelSetAnimation(Model* m, int anim, int playBack);
Model* modelUpdateAnimation(Model* m);
int modelGetStoppedAnimation(Model* m);
Model* modelSetAnimationTime(Model* m, float time);
float modelGetAnimationTime(Model* m);
Model* modelLink(Model* m, const char* name, Object* o);
float modelGetYawAngle(Model* m);
Model* modelSetYawAngle(Model* m, float a);
Model* modelAddYawAngle(Model* m, float a, float min, float max);
float modelGetPitchAngle(Model* m);
Model* modelSetPitchAngle(Model* m, float a);
Model* modelAddPitchAngle(Model* m, float a, float min, float max);
// AdvancedModel
typedef struct AdvancedModel AdvancedModel;
Object* advancedModelCastToObject(AdvancedModel* t);
AdvancedModel* objectCastToAdvancedModel(Object* o);
AdvancedModel* advancedModelLoad(const char* fileName, int useHW);
int advancedModelDelete(AdvancedModel* o);
AdvancedModel* advancedModelSetAnimationTime(AdvancedModel* m, float time);
float advancedModelGetAnimationTime(AdvancedModel* m);
AdvancedModel* advancedModelClone(AdvancedModel* m);
AdvancedModel* advancedModelSetLod(AdvancedModel* m, float lod);
AdvancedModel* advancedModelSetScaled(AdvancedModel* m, int b);
AdvancedModel* advancedModelSetCulled(AdvancedModel* m, int b);
int advancedModelGetAnimationsCount(AdvancedModel* m);
int advancedModelBlendCycle(
  AdvancedModel* m, int anim, float weight, float delay
);
int advancedModelClearCycle(AdvancedModel* m, int anim, float delay);
int advancedModelExecuteAction(
  AdvancedModel* m, int anim, float delayIn, float delayOut,
  float weight, int lock
);
int advancedModelRemoveAction(AdvancedModel* m, int anim);
AdvancedModel* advancedModelUpdateAnimation(AdvancedModel* m);
AdvancedModel* advancedModelDisableSprings(AdvancedModel* m);
// Bot
typedef struct Bot Bot;
Model* botCastToModel(Bot* b);
Bot* modelCastToBot(Model* m);
Bot* botLoad(const char* path, const char* modelName, int ownsCaches);
Bot* botCreate(Bot* clone);
int botDelete(Bot* o);
Bot* botRescale(Bot* b, float scale);
Model* botGetLower(Bot* b);
Model* botGetUpper(Bot* b);
Model* botGetHead(Bot* b);
Bot* botSetLowerAnimation(Bot* b, int anim, int playBack);
Bot* botSetUpperAnimation(Bot* b, int anim, int playBack);
int botGetLowerAnimation(Bot* b);
int botGetUpperAnimation(Bot* b);
int botGetLinkMatrix(Bot* b, const char* name, Matrix* m);
Bot* botWalk(Bot* b, float step);
// Mate
typedef struct Mate Mate;
Mate* mateSetStatus(Mate* m, int status);
int mateGetStatus(Mate* m);
Mate* mateSetDead(Mate* m, int v);
int mateIsDead(Mate* m);
Mate* mateSetFlashShown(Mate* m, int v);
int mateIsFlashShown(Mate* m);
Mate* mateSetHeadAngles(Mate* m, float yaw, float pitch);
Mate* mateGetHeadAngles(Mate* m, float* yaw, float* pitch);
Mate* mateAddHeadAngles(
  Mate* m, float yaw, float pitch,
  float minYaw, float maxYaw, float minPitch, float maxPitch
);
Mate* mateSetTorsoAngles(Mate* m, float yaw, float pitch);
Mate* mateGetTorsoAngles(Mate* m, float* yaw, float* pitch);
Mate* mateAddTorsoAngles(
  Mate* m, float yaw, float pitch,
  float minYaw, float maxYaw, float minPitch, float maxPitch
);
Mate* mateSetTorsoAnimation(Mate* m, Bot* b, int anim);
Mate* mateSetLastTorsoAnimation(Mate* m, int anim);
int mateGetCurrentTorsoAnimation(Mate* m);
int mateGetLastTorsoAnimation(Mate* m);
int mateGetStoppedTorsoAnimation(Mate* m);
Mate* mateSetLegsAnimation(Mate* m, Bot* b, int anim);
int mateGetCurrentLegsAnimation(Mate* m);
// WeaponData
typedef struct WeaponData WeaponData;
typedef int (*DataCallback)(int* idx, Vector* pos, int* type, int* attrib);
WeaponData* weaponDataCreate(DataCallback c);
int weaponDataDelete(WeaponData* d);
// Scenery
typedef struct Scenery Scenery;
typedef struct Furniture Furniture;
Shadowed* sceneryCastToShadowed(Scenery* s);
Scenery* shadowedCastToScenery(Shadowed* s);
Furniture* voidCastToFurniture(Void* v);
Scenery* sceneryAddFurniture(Scenery* s, Furniture* f);
Scenery* sceneryRemoveFurniture(Scenery* s, Furniture* f);
Scenery* sceneryEmpty(Scenery* s);
// Teams
typedef struct Teams Teams;
Furniture* teamsCastToFurniture(Teams* o);
Teams* furnitureCastToTeams(Furniture* o);
Teams* teamsCreate(
  int teamsCount, int teamMates, Bot* bot, Material** bodyMaterials,
  Material** torsoMaterials, Model* sign, int weaponsCount,
  Model** weaponModels, Model** flashModels, float lod,
  Texture* shadowTexture, float shadowWidth, float shadowHeight
);
int teamsGetTeamsCount(Teams* t);
int teamsGetMatesCount(Teams* t);
int teamsGetWeaponTypesCount(Teams* t);
Bot* teamsGetBot(Teams* t);
Mate* teamsGetMate(Teams* t, int team, int mate);
Teams* teamsSetWeaponData(Teams* t, WeaponData* d);
// PowerupData
typedef struct PowrupData PowerupData;
PowerupData* powerupDataCreate(DataCallback c);
int powerupDataDelete(PowerupData* d);
// Powerups
typedef struct Powerups Powerups;
Furniture* powerupsCastToFurniture(Powerups* o);
Powerups* furnitureCastToPowerups(Furniture* o);
Powerups* powerupsCreate(
  Model* medikit, Model* food, Model* armor, Model* bullets,
  Model* grenades, Model* target, PowerupData* pd,
  Texture* shadowTexture
);
Powerups* powerupsSetPowerupData(Powerups* p, PowerupData* d);
// Sample
typedef struct Sample Sample;
typedef struct Sound Sound;
Sample* voidCastToSample(Void* v);
Sound* voidCastToSound(Void* v);
int sampleDelete(Sample* s);
Sound* sampleCreateSound(Sample* s);
Sample* sampleSetVolume(Sample* s, unsigned char v);
Sample* sampleSetPan(Sample* s, unsigned char v);
Sample* sampleSetFrequency(Sample* s, unsigned int v);
Sample* sampleSetLooping(Sample* s, int v);
// Sample3D
typedef struct Sample3D Sample3D;
typedef struct Sound3D Sound3D;
Sample* sample3DCastToSample(Sample3D* s);
Sample3D* sampleCastToSample3D(Sample* o);
Sample3D* sample3DCreate(int freq, int bits);
Sound3D* sample3DCreateSound3D(Sample3D* s);
Sample3D* sample3DSetMinDistance(Sample3D* s, float v);
Sample3D* sample3DPlayAt(Sample3D* s,
  float x, float y, float z,float vx, float vy, float vz);
// Sound
int soundDelete(Sound* s);
Sound* soundSetVolume(Sound* s, unsigned char v);
Sound* soundSetPan(Sound* s, unsigned char v);
Sound* soundSetFrequency(Sound* s, unsigned int v);
Sound* soundPlay(Sound* s);
Sound* soundStop(Sound* s);
int soundIsPlaying(Sound* s);
// Sound3D
Sound* sound3DCastToSound(Sound3D* s);
Sound3D* soundCastToSound3D(Sound* o);
Sound3D* sound3DSetAttributes(Sound3D* s, float pos[3], float vel[3]);
// Source
typedef struct Source Source;
Source* voidCastToSource(Void* v);
Source* sourceCreate(Sample3D* s, Object* o, int playing);
Source* sourceSetSound3D(Source* s, Sound3D* sound);
Sound3D* sourceGetSound3D(Source* s);
Source* sourceSetObject(Source* s, Object* o);
Object* sourceGetObject(Source* s);
// CaptureDevice
typedef struct CaptureDevice CaptureDevice;
CaptureDevice* voidCastToCaptureDevice(Void* v);
CaptureDevice* captureDeviceCreate(int maxSamples, int frequency, int bits);
int captureDeviceDelete(CaptureDevice* cd);
CaptureDevice* captureDeviceStart(CaptureDevice* cd);
CaptureDevice* captureDeviceStop(CaptureDevice* cd);
int captureDeviceGetMaxSamples(CaptureDevice* cd);
int captureDeviceGetAcquiredSamples(CaptureDevice* cd);
int captureDeviceGetAvailableSamples(CaptureDevice* cd);
CaptureDevice* captureDeviceSetAvailableSamples(CaptureDevice* cd, int val);
float captureDeviceGetSample(CaptureDevice* cd, int index);
CaptureDevice* captureDeviceSetSample(CaptureDevice* cd, int index, float val);
CaptureDevice* captureDeviceCapture(CaptureDevice* cd);
CaptureDevice* captureDeviceWriteToSample3D(CaptureDevice* cd, Sample3D* s);
Sample3D* captureDeviceCreateSample3D(CaptureDevice* cd);
int captureDeviceSaveAsWav(CaptureDevice* cd, const char* fileName);
// Music
typedef struct Music Music;
Music* voidCastToMusic(Void* v);
int musicDelete(Music* m);
Music* musicSetVolume(Music* m, unsigned char v);
Music* musicSetLooping(Music* m, int v);
Music* musicPlay(Music* m);
Music* musicStop(Music* m);
int musicIsPlaying(Music* m);
// MediaControl
typedef struct MediaControl MediaControl;
MediaControl* voidCastToMediaControl(Void* v);
MediaControl* mediaControlCreate(const char* fileName);
int mediaControlDelete(MediaControl* mc);
int mediaControlOpen(MediaControl* mc, const char* fileName);
MediaControl* mediaControlClose(MediaControl* mc);
int mediaControlGetStart(MediaControl* mc);
int mediaControlGetEnd(MediaControl* mc);
int mediaControlGetPosition(MediaControl* mc);
MediaControl* mediaControlSetRepeat(MediaControl* mc, int b);
MediaControl* mediaControlSetVolume(MediaControl* mc, float vol);
MediaControl* mediaControlSetSpeed(MediaControl* mc, float speed);
int mediaControlSetPosition(MediaControl* mc, int pos);
int mediaControlPlay(MediaControl* mc);
int mediaControlPlayFromTo(MediaControl* mc, int from, int to);
int mediaControlStop(MediaControl* mc);
int mediaControlPause(MediaControl* mc);
int mediaControlResume(MediaControl* mc);
// AmmoData
typedef struct AmmoData AmmoData;
AmmoData* ammoDataCreate(DataCallback c);
int ammoDataDelete(AmmoData* d);
// Ammo
typedef struct Ammo Ammo;
Furniture* ammoCastToFurniture(Ammo* o);
Ammo* furnitureCastToAmmo(Furniture* o);
Ammo* ammoCreate(
  int weaponsCount, float* halfSizes, float* halfExplSizes,
  Texture** textures, Texture** explTextures,
  Sample3D** explSamples, int* soundEnabled,
  AmmoData* ad
);
Ammo* ammoSetAmmoData(Ammo* a, AmmoData* d);
Ammo* ammoSetBulletColor(
  Ammo* a, int weaponType, float r, float g, float b
);
Ammo* ammoSetGrenadeColor(
  Ammo* a, int weaponType, float r, float g, float b
);
// Bsp
typedef struct Bsp Bsp;
Scenery* bspCastToScenery(Bsp* b);
Bsp* sceneryCastToBsp(Scenery* o);
Bsp* bspLoad(const char* path, const char* fileName, float gamma);
Bsp* bspSetTransparenciesVisible(Bsp* b, int v);
Bsp* bspSetUntexturedMeshesVisible(Bsp* b, int v);
Bsp* bspSetUntexturedPatchesVisible(Bsp* b, int v);
Bsp* bspSetDefaultTexture(Bsp* b, Texture* t);
int bspSlideCollision(
  Bsp* b, float pos[3], float vel[3], float ext[3]
);
int bspCheckCollision(
  Bsp* b, float pos[3], float vel[3], float ext[3]
);
Bsp* bspGetCollisionNormal(Bsp* b, float normal[3]);
Bsp* bspGetCollisionTexture(Bsp* b, int* textureID, int* textureContent);
int bspCheckVisibility(Bsp* b, int cluster1, int cluster2);
int bspGetCluster(Bsp* b, float x, float y, float z);
const char* bspGetEntitiesString(Bsp* b);
int bspGetStartingPositionsCount(Bsp* b);
Bsp* bspGetStartingPosition(Bsp*b, int idx, float pos[3]);
int bspGetMedikitPositionsCount(Bsp* b);
Bsp* bspGetMedikitPosition(Bsp*b, int idx, float pos[3]);
int bspGetFoodPositionsCount(Bsp* b);
Bsp* bspGetFoodPosition(Bsp*b, int idx, float pos[3]);
int bspGetArmorPositionsCount(Bsp* b);
Bsp* bspGetArmorPosition(Bsp*b, int idx, float pos[3]);
int bspGetBulletsPositionsCount(Bsp* b);
Bsp* bspGetBulletsPosition(Bsp*b, int idx, float pos[3]);
int bspGetGrenadesPositionsCount(Bsp* b);
Bsp* bspGetGrenadesPosition(Bsp*b, int idx, float pos[3]);
int bspGetWeaponPositionsCount(Bsp* b);
Bsp* bspGetWeaponPosition(Bsp*b, int idx, float pos[3]);
// Sprite
typedef struct Sprite Sprite;
Object* spriteCastToObject(Sprite* s);
Sprite* objectCastToSprite(Object* o);
Sprite* spriteCreate(float w, float h, Material* m);
Sprite* spriteSetSize(Sprite* s, float w, float h);
Sprite* spriteGetSize(Sprite* s, float* w, float* h);
Sprite* spriteSetTextureCoord(
  Sprite* s, float l, float b, float r, float t
);
// AnimatedSprite
typedef struct AnimatedSprite AnimatedSprite;
Sprite* animatedSpriteCastToSprite(AnimatedSprite* s);
AnimatedSprite* spriteCastToAnimatedSprite(Sprite* o);
AnimatedSprite* animatedSpriteCreate(
  float w, float h, float duration, int sideFrame, Material* m
);
AnimatedSprite* animatedSpriteSetDuration(AnimatedSprite* s, float duration);
AnimatedSprite* animatedSpriteSetAnimated(AnimatedSprite* s, int isAnim);
// Sprites
typedef struct Sprites Sprites;
Object* spritesCastToObject(Sprites* s);
Sprites* objectCastToSprites(Object* o);
Sprites* spritesCreate(int cap, float w, float h, Texture* tex, int hasAlpha);
Sprites* spritesAddSprite(Sprites* s, float x, float y, float z);
Sprites* spritesSetColor(Sprites* s, float r, float g, float b);
Sprites* spritesSetSize(Sprites* s, float w, float h);
Sprites* spritesSetTexture(Sprites* s, Texture* texture, int hasAlpha);
Sprites* spritesSetPosition(Sprites* s, int idx, float x, float y, float z);
Sprites* spritesGetPosition(Sprites* s, int idx, float* x, float* y, float* z);
// AxisAligned
typedef struct AxisAligned AxisAligned;
Sprite* axisAlignedCastToSprite(AxisAligned* s);
AxisAligned* spriteCastToAxisAligned(Sprite* o);
AxisAligned* axisAlignedCreate(float w, float h, Material* m);
// Billboard
typedef struct Billboard Billboard;
Sprite* billboardCastToSprite(Billboard* s);
Billboard* spriteCastToBillboard(Sprite* o);
Billboard* billboardCreate(float w, float h, Material* m);
// FadingBillboard
typedef struct FadingBillboard FadingBillboard;
Billboard* fadingBillboardCastToBillboard(FadingBillboard* b);
FadingBillboard* billboardCastToFadingBillboard(Billboard* o);
FadingBillboard* fadingBillboardCreate(
  float fadeNear, float fadeFar, float w, float h, Material* m
);
// AnimatedBillboard
typedef struct AnimatedBillboard AnimatedBillboard;
Billboard* animatedBillboardCastToBillboard(animatedBillboard* b);
AnimatedBillboard* billboardCastToAnimatedBillboard(Billboard* o);
AnimatedBillboard* animatedBillboardCreate(
  float w, float h, float duration, int sideFrame, Material* m
);
AnimatedBillboard* animatedBillboardSetDuration(
  AnimatedBillboard* s, float duration
);
AnimatedBillboard* animatedBillboardSetAnimated(
  AnimatedBillboard* s, int isAnim
);
// Trees
typedef struct Trees Trees;
Object* treesCastToObject(Trees* t);
Trees* objectCastToTrees(Object* o);
Trees* treesCreate(int treesCount, int sideCount, Material* m);
Trees* treesAddTree(Trees* t, float pos[3], float w, float h);
// Emitter
typedef struct Emitter Emitter;
Object* emitterCastToObject(Emitter* t);
Emitter* objectCastToEmitter(Object* o);
Emitter* emitterCreate(
  int particlesCount, float maxLife, float maxRadius, int updateSpeed
);
Emitter* emitterReset(Emitter* e);
Emitter* emitterSetShape(Emitter* e, int shape);
Emitter* emitterSetShapeSize(Emitter* e, float size);
Emitter* emitterSetTexture(Emitter* e, Texture* t, int hasAlpha);
Emitter* emitterSetVelocity(Emitter* e, Vector* v, float speedVar);
Emitter* emitterSetColor(Emitter* e,
  float startR, float startG, float startB, float startA,
  float endR, float endG, float endB, float endA
);
Emitter* emitterSetSize(Emitter* e, float start, float end);
Emitter* emitterSetGravity(Emitter* e, Vector* start, Vector* end);
Emitter* emitterSetAngularSpeed(Emitter* e, float start, float end);
Emitter* emitterSetRadius(Emitter* e, float start, float end);
Emitter* emitterSetMaxLife(Emitter* e, float maxLife);
Emitter* emitterSetOneShot(Emitter* e, int oneShot);
Emitter* emitterSetBurstDuration(Emitter* e, float bd);
// AnimatedEmitter
typedef struct AnimatedEmitter AnimatedEmitter;
Emitter* animatedEmitterCastToEmitter(AnimatedEmitter* t);
AnimatedEmitter* emitterCastToAnimatedEmitter(Emitter* o);
AnimatedEmitter* animatedEmitterCreate(
  int particlesCount, float maxLife, float maxRadius, float duration,
  int sideFrames, int updateSpeed
);
AnimatedEmitter* animatedEmitterSetDuration(AnimatedEmitter* e, float duration);
// Text
typedef struct Text Text;
Object* textCastToObject(Text* t);
Text* objectCastToText(Object* o);
Text* textCreate(const char* string, Font3D* f, Material* m);
// Background
typedef struct Background Background;
Transform* backgroundCastToTransform(Background* b);
Background* transformCastToBackground(Transform* b);
int backgroundDelete(Background* b);
Background* backgroundSetColor(Background* b, float r, float g, float b);
Background* skyCreate(Texture* t[6]);
Background* mirroredSkyCreate(Texture* t[5]);
Background* starFieldCreate(float r, int starsCount, Texture* t, float objSize);
// CloudLayer
typedef struct CloudLayer CloudLayer;
CloudLayer* voidCastToCloudLayer(Void* v);
CloudLayer* cloudLayerCreate(Material* mat, float size, float height, int tiles);
int cloudLayerDelete(GLCloudLayer* cl);
CloudLayer* cloudLayerSetColor(CloudLayer* cl, float r, float g, float b, float a);
CloudLayer* cloudLayerSetSpeed(CloudLayer* cl, float speedX, float speedY);
// HalfSky
typedef struct HalfSky HalfSky;
Background* halfSkyCastToBackground(HalfSky* b);
HalfSky* backgroundCastToHalfSky(Background* b);
HalfSky* halfSkyCreate(Texture* t[5]);
HalfSky* halfSkySetGroundColor(HalfSky* s, float r, float g, float b);
// Skydome
typedef struct Skydome Skydome;
Background* skydomeCastToBackground(Skydome* b);
Skydome* backgroundCastToSkydome(Background* b);
Skydome* skydomeCreate(int merid, int paral, float radius);
Skydome* skydomeSetAtmosphere(
  Skydome* s, float r, float g, float b, float height, float density,
  float minDeg, float maxDeg
);
Skydome* skydomeSetHaze(
  Skydome* s, float r, float g, float b, float height, float density,
  float minDeg, float maxDeg
);
Skydome* skydomeSetRedShift(Skydome* s, float minDeg, float maxDeg);
Skydome* skydomeSetSun(
  Skydome* s, float r, float g, float b, float intensity, Vector* dir
);
Skydome* skydomeUpdate(Skydome* s);
Skydome* skydomeGetSunColor(Skydome* s, float* r, float* g, float* b);
Skydome* skydomeGetFogColor(Skydome* s, float* r, float* g, float* b);
Skydome* skydomeGetCloudColor(Skydome* s, float* r, float* g, float* b);
Skydome* skydomeSetMirrored(Skydome* s, int mirrored);
// Light
typedef struct Light Light;
Object* lightCastToObject(Light* o);
Light* objectCastToLight(Object* o);
Light* lightCreate(Texture* t, float size);
Light* lightSetSize(Light* l, float size);
Light* lightSetColor(Light* l, float r, float g, float b);
Light* lightSetAttenuation(Light* l, float c, float l, float q);
Light* lightSetDirection(Light* l, Vector* dir);
Light* lightSetSpot(Light* l, float cut, float exp);
// FireLight
typedef struct FireLight FireLight;
Light* fireLightCastToLight(FireLight* m);
FireLight* lightCastToFireLight(GLLight* o);
FireLight* fireLightCreate(Texture* t, float size);
FireLight* fireLightSetIntensities(FireLight* l,
  float minR, float minG, float minB, float maxR, float maxG, float maxB
);
// Moon
typedef struct Moon Moon;
Light* moonCastToLight(Moon* m);
Moon* lightCastToMoon(Light* o);
Moon* moonCreate(
  Texture* t, float size, Vector* dir, float cameraDist
);
// Sun
typedef struct Sun Sun;
Light* sunCastToLight(Sun* s);
Sun* lightCastToSun(Light* o);
Sun* sunCreate(
  Texture* t, float size, Vector* dir, Texture* flaresTexture,
  float flaresCount, float flaresSize, float cameraDist, int checkOcclusion
);
// Terrain
typedef struct Terrain Terrain;
Shadowed* terrainCastToShadowed(Terrain* t);
Terrain* shadowedCastToTerrain(Shadowed* t);
int terrainIsReflective(Terrain* t);
Terrain* terrainSetReflective(Terrain* t, int b);
int terrainIsTransparent(Terrain* t);
Terrain* terrainSetTransparent(Terrain* t, int b);
// FlatTerrain
typedef struct FlatTerrain FlatTerrain;
Terrain* flatTerrainCastToTerrain(FlatTerrain* t);
FlatTerrain* terrainCastToFlatTerrain(Terrain* t);
FlatTerrain* flatTerrainCreate(Material* m, float size, int tiles);
// Tiled Terrain
typedef struct TiledTerrain TiledTerrain;
Terrain* tiledTerrainCastToTerrain(TiledTerrain* t);
TiledTerrain* terrainCastToTiledTerrain(Terrain* t);
TiledTerrain* tiledTerrainCreate(
  Material* m, int tilesInTextureSide, Image* tileImage,
  float patchSideLength, int tilesInPatchSide, int defaultTile);
TiledTerrain* tiledTerrainSetMaterial(TiledTerrain* tt, Material* m);
Material* tiledTerrainGetMaterial(TiledTerrain* tt);
int tiledTerrainGetTilesWidth(TiledTerrain* tt);
int tiledTerrainGetTilesHeight(TiledTerrain* tt);
unsigned char tiledTerrainGetTileAtGrid(TiledTerrain* tt, float x, float z);
TiledTerrain* tiledTerrainSetTileAtGrid(TiledTerrain* tt,
  float x, float z, unsigned char t);
Image* tiledTerrainGetImageFromTiles(TiledTerrain* tt);
// Ocean
typedef struct Ocean Ocean;
Terrain* oceanCastToTerrain(Ocean* t);
Ocean* terrainCastToOcean(Terrain* t);
Ocean* oceanCreate(
  Material* m, float waveAmpl, float waveDispl, Vector* wind,
  int surfTileSide, int gridSize, int surfTilesCount, int textTileCount
);
// Patches
typedef struct Patches Patches;
Terrain* patchesCastToTerrain(Patches* t);
Patches* terrainCastToPatches(Terrain* t);
Patches* patchesCreate(
  Image* heightMap, Image* colorMap, Material* m, float sideLen,
  float h, int patchesCount, int repeatsCoarse, int repeatsDetail
);
Patches* patchesSetMaterial(Patches* p, Material* m);
Material* patchesGetMaterial(Patches* p);
float patchesGetHeightAt(Patches* p, float x, float z);
unsigned char patchesGetHeightAtGrid(Patches* p, float x, float z);
Patches* patchesSetHeightAtGrid(Patches* p, float x, float z, unsigned char h);
Patches* patchesGetColorAtGrid(Patches* p, float x, float z,
  unsigned char* r, unsigned char* g, unsigned char* b);
Patches* patchesSetColorAtGrid(Patches* p, float x, float z,
   unsigned char r, unsigned char g, unsigned char b);
float patchesGetLastNormal(Patches* p, Vector* n);
Image* patchesGetImageFromHeight(Patches* p);
Image* patchesGetImageFromColors(Patches* p);
// Heightfield
typedef struct HeightField HeightField;
Object* heightFieldCastToObject(HeightField* o);
ShadowedDelegate* heightFieldCastToShadowedDelegate(HeightField* o);
HeightField* objectCastToHeightField(Object* o);
HeightField* heightFieldCreate(
  Image* heightMap, Material* m, float w, float d, float h,
  float waterLevel, int detailTiles
);
float heightFieldGetHeightAtAbsolute(HeightField* h, float x, float z);
float heightFieldGetHeightAtRelative(HeightField* h, float x, float z);
float heightFieldGetLastNormal(HeightField* h, Vector* n);
HeightField* heightFieldSetHintNoRotation(HeightField* h, int noRot);
// Host
typedef struct Host Host;
Host* voidCastToHost(Void* v);
Host* hostCreate(const char* hostName);
int hostDelete(Host* h);
// Socket
typedef struct Socket Socket;
Socket* voidCastToSocket(Void* v);
int socketDelete(Socket* s);
int socketConnect(Socket* s, Host* h, int port);
int socketListen(Socket* s, int port);
Socket* socketAccept(Socket* s, int bufferLen);
int socketDisconnect(Socket* s);
int socketWaitForEvent(Socket* s, int timeOut);
int socketIsConnectEvent(Socket* s);
int socketIsReadEvent(Socket* s);
int socketIsWriteEvent(Socket* s);
int socketIsCloseEvent(Socket* s);
int socketGetFile(Socket* s, const char* name);
int socketReceive(Socket* s);
const char* socketGetBuffer(Socket* s);
int socketGetDataLength(Socket* s);
// SocketStream
Socket* socketStreamCreate(int bufferLen);
// SocketDatagram
Socket* socketDatagramCreate(int bufferLen);
// Data
typedef struct Data Data;
int dataDelete(Data* d);
const char* dataGetBuffer(Data* d);
int dataGetSize(Data* d);
// Buffer
typedef struct Buffer Buffer;
Buffer* bufferCreate(int increment);
Buffer* bufferCreateFromPointer(int size, const char* ptr);
int bufferDelete(Buffer* b);
Buffer* bufferOpen(Buffer* b, const char* mode);
int bufferClose(Buffer* b);
int bufferRead(void* ptr, int size, int n, Buffer* b);
int bufferWrite(const void* ptr, int size, int n, Buffer* b);
int bufferSeek(Buffer* b, int offset, int whence);
int bufferTell(Buffer* b);
// Zip
typedef struct Zip Zip;
Zip* voidCastToZip(Void* v);
Zip* zipCreate(const char* fileName, int zipped);
int zipDelete(Zip* z);
int zipGotoFirstFile(Zip* z);
int zipGotoNextFile(Zip* z);
Zip* zipGetZippedFileName(Zip* z, char* buffer, int len);
Data* zipCreateData(Zip* z, const char* n);
Image* zipCreateImage(Zip* z, const char* n);
Texture* zipCreateTexture(
  Zip* z, const char* n, int repeat, int doMipmaps, int is1D
);
BumpedTexture* zipCreateBumpedTexture(Zip* z, const char* n, int repeat);
Texture* zipCreateCubeMapTexture(Zip* z, const char* images[6], int doMipmaps);
Objects* zipCreateMeshes(Zip* z, const char* n);
Mesh* zipCreateMesh(Zip* z, const char* n);
Objects* zipCreateShaderMeshes(Zip* z, const char* n);
Mesh* zipCreateShaderMesh(Zip* z, const char* n);
Objects* zipCreateBumpedMeshes(Zip* z, const char* n);
BumpedMesh* zipCreateBumpedMesh(Zip* z, const char* n);
BasicModel* zipCreateBasicModel(Zip* z, const char* n, const char* imageName);
Model* zipCreateModel(Zip* z, const char* n, const char* imageName);
AdvancedModel* zipCreateAdvancedModel(Zip* z, const char* n, int useHW);
Bot* zipCreateBot(Zip* z, const char* n, int ownsCache);
Bsp* zipCreateLevel(Zip* z, const char* n, float gamma);
Sample* zipCreateSample(Zip* z, const char* n);
Sample3D* zipCreateSample3D(Zip* z, const char* n);
Music* zipCreateMusic(Zip* z, const char* n);
// NewZip
typedef struct NewZip NewZip;
NewZip* newZipCreate(const char* fileName);
void newZipDelete(NewZip* z);
int newZipOpenFile(NewZip* z, const char* fileName);
int newZipWriteInFile(NewZip* z, void* data, unsigned int len);
// OverlayWorldView
typedef struct OverlayWorldView OverlayWorldView;
OverlayObject* overlayWorldViewCastToOverlayObject(OverlayWorldView* o);
OverlayWorldView* overlayObjectCastToOverlayWorldView(OverlayObject* o);
OverlayWorldView* overlayWorldViewCreate(float w, float h);
Camera* overlayWorldViewGetCamera(OverlayWorldView* os);
OverlayWorldView* overlayWorldViewSetLocation(OverlayWorldView* os, float x, float y);
OverlayWorldView* overlayWorldViewGetLocation(OverlayWorldView* os, float* x, float* y);
OverlayWorldView* overlayWorldViewSetDimension(OverlayWorldView* os, float w, float h);
OverlayWorldView* overlayWorldViewGetDimension(OverlayWorldView* os, float* w, float* h);
OverlayWorldView* overlayWorldViewSetPerspective(
  OverlayWorldView* os, float fov, float minClip, float maxClip
);
OverlayWorldView* overlayWorldViewSetOrtho(OverlayWorldView* os, float clipPlaneFar);
OverlayWorldView* overlayWorldViewIsOrtho(OverlayWorldView* os);
// OverlayViewport
typedef struct OverlayViewport OverlayViewport;
OverlayWorldView* overlayViewportCastToOverlayWorldView(OverlayViewport* o);
OverlayViewport* overlayWorldViewCastToOverlayViewport(OverlayWorldView* o);
OverlayViewport* overlayViewportCreate(float w, float h);
OverlayViewport* overlayViewportSetColor(
  OverlayViewport* os,  float r, float g, float b, float a
);
OverlayViewport* overlayViewportAddObject(OverlayViewport* os, Object* o);
OverlayViewport* overlayViewportRemoveObject(OverlayViewport* os, Object* o);
OverlayViewport* overlayViewportDeleteObjects(OverlayViewport* os);
OverlayViewport* overlayViewportAddShadow(OverlayViewport* os, Shadow* s);
OverlayViewport* overlayViewportRemoveShadow(OverlayViewport* os, Shadow* s);
OverlayViewport* overlayViewportDeleteShadows(OverlayViewport* os);
OverlayViewport* overlayViewportSetBackground(OverlayViewport* os, Background* b);
OverlayViewport* overlayViewportEnableFog(
  OverlayViewport* os, float dist, float r, float g, float b
);
OverlayViewport* overlayViewportEnableLinearFog(
  OverlayViewport* os, float dist, float maxDist, float r, float g, float b
);
OverlayViewport* overlayViewportDisableFog(OverlayViewport* os);
OverlayViewport* overlayViewportSetSun(OverlayViewport* os, Sun* s);
OverlayViewport* overlayViewportSetTerrain(OverlayViewport* os, Terrain* t);
OverlayViewport* overlayViewportSetScenery(OverlayViewport* os, Scenery* s);
OverlayViewport* overlayViewportEmpty(OverlayViewport* os);
OverlayViewport* overlayViewportSetAmbient(OverlayViewport* os, float r, float g, float b);
// World
void worldAddObject(Object* o);
void worldRemoveObject(Object* o);
void worldDeleteObjects(void);
void worldAddShadow(Shadow* s);
void worldRemoveShadow(Shadow* s);
void worldDeleteShadows(void);
void worldAddLight(Light* l);
void worldRemoveLight(Light* l);
void worldDeleteLights(void);
void worldSetBackground(Background* b, int deleteOld);
void worldAddBackground(Background* b);
void worldRemoveBackground(Background* b);
void worldSetCloudLayer(CloudLayer* cl, int deleteOld);
void worldAddCloudLayer(CloudLayer* cl);
void worldRemoveCloudLayer(CloudLayer* cl);
void worldEnableFog(float dist, float colorR, float colorG, float colorB);
void worldEnableLinearFog(float dist, float maxDist, float colorR, float colorG, float colorB);
void worldDisableFog(void);
void worldSetMoon(Moon* m);
void worldSetSun(Sun* s);
void worldSetTerrain(Terrain* t);
void worldSetScenery(Scenery* s);
void worldEmpty(void);
void worldSetPerspective(float fov, float minClip, float maxClip);
void worldSetViewport(float x, float y, float w, float h);
void worldSetAmbient(float r, float g, float b);
void worldSetClear(float r, float g, float b);
Camera* worldGetCamera(void);
int worldGetSphereRayCollision(
  float center[3], float radius, float origin[3] float dir[3], float point[3]
);
int worldGetSphereSphereCollision(
  float center[3], float radius, float center2[3] float radius2[3], float point[3]
);
void worldAddSource(Source* s);
void worldRemoveSource(Source* s);
void worldDeleteSources(void);
void worldSetListener(
  float forw[3], float top[3], float pos[3], float vel[3]
);
void worldSetListenerScale(float distanceFactor);
// Overlay
Font* overlayGetMainOverlayFont(void);
void overlaySetMainOverlayFont(Font* f);
void overlayAddObject(OverlayObject* o);
void overlayRemoveObject(OverlayObject* o);
void overlayEmpty(void);
void overlaySetPointerVisible(int v);
void overlaySetPointerLocation(float x, float y);
void overlayGetPointerLocation(float* x, float* y);
void overlayMovePointer(
  float dx, float dy, float minX, float minY, float maxX float maxY
);
void overlaySetPointer(OverlaySprite* s);
// ParticleSet
typedef struct ParticleSet ParticleSet;
ParticleSet* voidCastToParticleSet(Void* v);
int particleSetGetID(ParticleSet* p);
ParticleSet* ParticleSetSetID(ParticleSet* p, int id);
int particleSetGetColliderHit(ParticleSet* p);
ParticleSet* ParticleSetSetRadius(ParticleSet* p, double r);
int particleSetGetParticlesCount(ParticleSet* p);
int particleSetWasTerrainHit(ParticleSet* p);
int particleSetWasEnvironmentHit(ParticleSet* p);
ParticleSet* particleSetSetPosition(
  ParticleSet* p, int idx, double x, double y, double z
);
ParticleSet* particleSetGetPosition(
  ParticleSet* p, int idx, double* x, double* y, double* z
);
ParticleSet* particleSetSetVelocity(
  ParticleSet* p, int idx, double vx, double vy, double vz
);
ParticleSet* particleSetGetVelocity(
  ParticleSet* p, int idx, double* vx, double* vy, double* vz
);
// Simulator
typedef struct Simulator Simulator;
Simulator* voidCastToSimulator(Void* v);
Simulator* simulatorCreate(void);
int simulatorDelete(Simulator* s);
Simulator* simulatorAddParticleSet(Simulator* s, ParticleSet* p);
Simulator* simulatorEmpty(Simulator* s);
float simulatorGetDealtaT(Simulator* s);
Simulator* simulatorRunStep(Simulator* s, double time);
// Obstruction
typedef struct Obstruction Obstruction;
Obstruction* voidCastToObstruction(Void* v);
Obstruction* obstructionSetPosition(
  Obstruction* o, double x, double y, double z
);
Obstruction* obstructionSetParticleProjected(
  Obstruction* o, int isProjected
);
Obstruction* sphericalObstructionCreate(
  double x, double y, double z, double r
);
Obstruction* cylindricalObstructionCreate(
  double x, double y, double z, double r, double h
);
Obstruction* boxedObstructionCreate(
  double x, double y, double z, double w, double h, double d
);
Obstruction* prismaticObstructionCreate(
  double x, double y, double z,
  double aX, double aY, double aZ,
  double bX, double bY, double bZ,
  double cX, double cY, double cZ
);
Obstruction* heightfieldObstructionCreate(
  Heightfield* hf, double offset
);
Obstruction* patchedObstructionCreate(
  Patches* p, double offset
);
// Environment
typedef struct Environment Environment;
Environment* voidCastToEnvironment(Void* v);
Environment* environmentCreate(
  double windX, double windY, double windZ, double terrainHeight
);
int environmentDelete(Environment* e);
// Body
typedef struct Body Body;
typedef cdecl (*BodyCallback)(Body* b);
Body* voidCastToBody(Void* v);
Body* bodyCreate(
  BodyCallback* c, Simulator* s, Environment* e, Transform* ref
);
int bodyGetID(Body* b);
Body* bodySetID(Body* b, int id);
int bodyGetColliderHit(Body* b);
Body* bodySetRadius(Body* b, double r);
Body* bodySetPosition(
  Body* b, double x, double y, double z
);
Body* bodyGetPosition(Body* b, double* x, double* y, double* z);
Body* bodySetVelocity(
  Body* b, double vx, double vy, double vz
);
Body* bodyGetVelocity(Body* b, double* vx, double* vy, double* vz);
Body* bodySetOrientation(
  Body* b, double theta, double phi, double rho
);
Body* bodyGetOrientation(
  Body* b, double* theta, double* phi, double* rho
);
Body* bodySetAngularVelocity(
  Body* b, double theta, double phi, double rho
);
Body* bodyGetAngularVelocity(
  Body* b, double* theta, double* phi, double* rho
);
Body* bodySetMass(Body* b, double m);
double bodyGetMass(Body* b);
Body* bodySetMomentOfInertia(
  Body* b, double mX, double mY, double mZ
);
Body* bodyGetMomentOfInertia(
  Body* b, double* mX, double* mY, double* mZ
);
Body* bodyAddForce(
  Body* b, double fX, double fY, double fZ
);
Body* bodyGetForce(
  Body* b, double* fX, double* fY, double* fZ
);
Body* bodyAddTorque(
  Body* b, double tX, double tY, double tZ
);
Body* bodyGetTorque(
  Body* b, double* tX, double* tY, double* tZ
);
Body* bodyUpdateReference(Body* b);
// Assembly
typedef struct Assembly Assembly;
typedef cdecl (*AssemblyCallback)(Assembly* a);
ParticleSet* assemblyCastToParticleSet(Assembly* a);
Assembly* particleSetCastToAssembly(ParticleSet* o);
Assembly* assemblyCreate(
  AssemblyCallback* c, Simulator* s, Environment* e,
  int particlesCount, double* particlesPositions,
  int sticksCount, unsigned short* sticksIndexes
);
Assembly* assemblySetRelaxationCycles(Assembly* a, int cycles);
Assembly* assemblyAddForce(
  Assembly* a, int idx, double fX, double fY, double fZ
);
Assembly* assemblyAddNail(
  Assembly* a, int idx, double x, double y, double z
);
int assemblyGetNailsCount(Assembly* a);
Assembly* assemblySetNailPosition(
  Assembly* a, int idx, double x, double y, double z
);
// Machinery
typedef struct Machinery Machinery;
Assembly* machineryCastToAssembly(Machinery* m);
Machinery* assemblyCastToMachinery(Assembly* o);
Machinery* machineryCreate(
  Simulator* s, Environment* e, double mass,
  int particlesCount, double* particlesPositions,
  int sticksCount, unsigned short* sticksIndexes,
  int texCoordsCount, float* texCoords,
  int trianglesCount, unsigned short* trianglesIndexes,
  int ropesCount, unsigned short* ropesIndexes, double* ropesLens2,
  int bumpersCount, unsigned short* bumpersIndexes, double* bumpersLens2,
  int springsCount, unsigned short* springsIndexes, double* springsK,
  int dampersCount, unsigned short* dampersIndexes, double* dampersK,
  int paddingsCount, unsigned short* paddingsIndexes, double* paddingsK
  int nailsCount, unsigned short* nailsIndexes
);
Mesh* machineryGetMesh(Machinery* m);
Machinery* machinerySetAirDragEnabled(Machinery* m, int b);
// Cloth
typedef struct Cloth Cloth;
Assembly* clothCastToAssembly(Cloth* m);
Cloth* assemblyCastToCloth(Assembly* o);
Cloth* clothCreate(
  int uCount, int vCount, float oX, float oY, float oZ,
  float uX, float uY, float uZ, float vX, float vY, float vZ,
  float m, Simulator* s, Environment* e
);
Mesh* clothGetMesh(Cloth* c);
//// lua interface
typedef int (*lua_CFunction)(void);
// App
void appSetTitle(const char* t);
void appSetScene(lua_CFunction i, lua_CFunction u, lua_CFunction f, lua_CFunction k);
void appSetHelp(int stringsCount, const char** strings);
void appSetHelpMode(int mode);
void appSetFramerateVisible(int b);
void appSetConsoleVisible(int b);
void appShowSplashImage(Image* splashImage, float waitForSeconds);
void appShowLoadingScreen(float waitForSeconds);
Image* appGetScreenshot(int x, int y, int w, int h);
void appReleaseKey(int key);
int appIsKeyPressed(int key);
int appIsCTRLPressed(void);
int appIsSHIFTPressed(void);
void appGetDimension(int* w, int* h);
void appGetMouseMove(int* dx, int* dy);
int appGetMouseWheel(void);
int appIsMouseLeftPressed(void);
int appIsMouseMiddlePressed(void);
int appIsMouseRightPressed(void);
int appIsMouseAcquired(void);
void appAcquireMouse(int acquire);
int appHasFocus(void);
void appGainFocus(void);
float appGetTimeStep(void);
float appGetElapsedTime(void);
int appIsPaused(void);
void appRender(void);
int appExit(void);
int appIsVertexProgramSupported(void);
int appIsFragmentProgramSupported(void);
int appAreShadersSupported(void);
int appGetTextureUnitsCount(void);
int appIsStencilAvailable(void);
void appUseFixedPipeline(void);
// FileSystem
int fileSystemFileExists(const char* fileName);
// Compiler
typedef struct Compiler Compiler;
Compiler* compilerCreate(int areWarningsEnabled);
int compilerDelete(Compiler* c);
Compiler* compilerDefSymbol(Compiler* c, const char* sym, const char* val);
Compiler* compilerUndefSymbol(Compiler* c, const char* sym);
int compilerAddLibrary(Compiler* c, const char* libraryName);
int compilerRemoveLibrary(Compiler* c, const char* libraryName);
int compilerCompileString(Compiler* c, const char* string);
int compilerCompileFile(Compiler* c, const char* fileName);
int compilerSaveObjFile(Compiler* c, const char* fileName);
int compilerLoadObjFile(Compiler* c, const char* fileName);
int compilerLoadObjBuffer(Compiler* c, const char* buffer);
int compilerLink(Compiler* c);
lua_CFunction compilerGetFunction(Compiler* c, const char* funcName);
#endif // APOCALYX_H
