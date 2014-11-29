#include "apocalyx.h"
#include "lua.h"

int init() {
  lua_State* LS = lua_getstate();
  //----CAMERA----
  worldSetAmbient(0.5,0.5,0.5);
  worldSetPerspective(60,0.5,3000);
  Camera* camera = worldGetCamera();
  Transform* cameraTransform = cameraCastToTransform(camera);
  transformReset(cameraTransform);
  Vector* v = vectorCreate(0,1.8f,-5);
  transformSetPosition(cameraTransform,v);
  vectorDelete(v);
  transformRotStanding(cameraTransform,3.1415);
  worldEmpty();
  //----SKYBOX----
  Zip* zip = zipCreate("DemoPack1.dat",1);
  Texture* skyTxt[5] = {
    zipCreateTexture(zip,"skyboxTop.jpg",0,1,0),
    zipCreateTexture(zip,"skyboxLeft.jpg",0,1,0),
    zipCreateTexture(zip,"skyboxFront.jpg",0,1,0),
    zipCreateTexture(zip,"skyboxRight.jpg",0,1,0),
    zipCreateTexture(zip,"skyboxBack.jpg",0,1,0)
  };
  Background* sky = mirroredSkyCreate(skyTxt);
  worldSetBackground(sky,1);
  worldEnableFog(750, 0.5,0.5,0.75);
  //----SUN----
  Vector* dir = vectorCreate(0,0.41,0.91);
  Sun* sun = sunCreate(
    zipCreateTexture(zip,"light.jpg",0,1,0),0.25,dir,
    zipCreateTexture(zip,"lensflares.png",0,1,0),
    4, 0.2, 1000, 1
  );
  vectorDelete(dir);
  worldSetSun(sun);
  //----TERRAIN----
  Material* terrainMaterial = materialCreate();
  materialSetAmbient(terrainMaterial,0.7f,0.7f,0.7f,1);
  materialSetDiffuse(terrainMaterial,1,1,1,1);
  materialSetDiffuseTexture(
    terrainMaterial,zipCreateTexture(zip,"marble.jpg",1,1,0)
  );
  FlatTerrain* flatTerrain = flatTerrainCreate(terrainMaterial,3000,300);
  materialDelete(terrainMaterial);
  Terrain* terrain = flatTerrainCastToTerrain(flatTerrain);
  terrainSetReflective(terrain,1);
  worldSetTerrain(terrain);
  //----HELP----
  const char* help[] = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help"
  };
  appSetConsoleVisible(0);
  appSetHelpMode(2);
  appSetHelp(8,help);
  //----DELETE ZIP----
  zipDelete(zip);
  return 0;
}

int moveUpTransform() {
  lua_State* LS = lua_getstate();
  void* ptr = lua_touserdata(LS,1);
  double val = lua_tonumber(LS,2);
  Transform* camera =
    matrixCastToTransform(voidCastToMatrix(pointerReinterpretAsVoid(ptr)));
  // It is not a good idea to create a vector this way,
  // because of the performance hit of several
  // creations and deletions.
  // It is better to create it once for all, thus
  // several functions can use it. Then it is
  // deleted during the 'finalization' phase
  // only once.
  Vector* vec = vectorCreate(0,val,0);
  transformMove(camera, vec);
  vectorDelete(vec);
  return 0;
}