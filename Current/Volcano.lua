----VOLCANO
----Ocean waves & Particles emitters
----Questions? Contact:leo <tetractys@users.sf.net>

----SUPPORT FUNCTION----Create an isle
function generateIsle(
  zip, terrainTextureName, detailedTexture, detailRepeat, heightFieldName,
  waterLevel, width, depth, height, x, y
)
  ----LOAD IMAGES AND CREATE TEXTURES----
  local terrainImage = zip:getImage(terrainTextureName)
  local heightImage = zip:getImage(heightFieldName)
  terrainImage:addAlpha(heightImage,64,9)
  local terrainTexture = Texture(terrainImage)
  terrainImage:delete()
  ----TERRAIN MATERIAL----
  local terrainMaterial = Material()
  terrainMaterial:setDiffuseTexture(terrainTexture)
  terrainMaterial:setGlossTexture(detailedTexture)
  ----CREATE HEIGHTFIELD----
  local heightField = HeightField(
    heightImage,terrainMaterial,width,depth,height,0,8
  )
  terrainTexture:delete()
  terrainMaterial:delete()
  heightField:move(x,-waterLevel,y)
  addObject(heightField)
  return isle
end

----INITIALIZATION----
function init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.5,3000)
  enableFog(700, 0.5,0.5,0.75)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,30,-200)
  camera:pitch(0.2)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack0.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack0.dat' not found.")
  end
  local zip = Zip("DemoPack0.dat")
  local skyTxt = {
    zip:getTexture("skyboxTop2.jpg"),
    zip:getTexture("skyboxLeft2.jpg"),
    zip:getTexture("skyboxFront2.jpg"),
    zip:getTexture("skyboxRight2.jpg"),
    zip:getTexture("skyboxBack2.jpg")
  }
  local sky = HalfSky(skyTxt)
  sky:setGroundColor(.5,.5,.75)
  setBackground(sky)
  ----SUN----
  sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, 0.9659,
    zip:getTexture("lensflares.png"),
    5, 0.2
  )
  sun:setColor(0.855,0.475,0.298);
  setSun(sun)
  ----WATER MATERIAL----
  local waterMaterial = Material()
  waterMaterial:setAmbient(1,1,0.75,0.5)
  waterMaterial:setDiffuse(0.125,0.25,0.75,0.5)
  waterMaterial:setSpecular(1,1,0,1)
  waterMaterial:setShininess(128)
  waterMaterial:setDiffuseTexture(zip:getTexture("water00.jpg",1))
  ----OCEAN----
  local waveAmplitude = .00003
  local waveDisplacement = 5
  local windX, windZ = 20, 20
  local surfaceTileSide = 200
  local gridSize = 8
  local surfaceTilesCount = 7
  local textureTilesCount = 10
  local ocean = Ocean(
    waterMaterial,waveAmplitude,waveDisplacement,windX,windZ,
    surfaceTileSide,gridSize,surfaceTilesCount,textureTilesCount
  )
  ocean:setTransparent()
  setTerrain(ocean)
  waterMaterial:delete()
  ----GENERATE ISLE----
  local detailedTexture = zip:getTexture("detail.jpg",1)
  local isle = generateIsle(
    zip,"volcano.jpg",detailedTexture,8,"volcano.png",15,
    150,150,60,0,0
  )
  ----FIRE----
  local fireImage = zip:getImage("smoke.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  local fireEmitter = Emitter(10,1,15)
  fireEmitter:setTexture(fireTexture,1)
  fireEmitter:setVelocity(20,15,2.5, 4)
  fireEmitter:setColor(1,1,0,1, 1,0,0,0)
  fireEmitter:setSize(10,2.5)
  fireEmitter:setGravity(0,0,0, 0,0,0)
  fireEmitter:move(0,40,-.5)
  fireEmitter:reset()
  addObject(fireEmitter)
  local bombEmitter = Emitter(10,10,100)
  bombEmitter:setTexture(fireTexture,1)
  bombEmitter:setVelocity(0,40,0, 10)
  bombEmitter:setColor(.25,0,0,1, 1,1,0,0)
  bombEmitter:setSize(1,1)
  bombEmitter:setGravity(0,-15,0, 0,-15,0)
  bombEmitter:move(0,40,-.5)
  bombEmitter:reset()
  addObject(bombEmitter)
  fireTexture:delete()
  local fireSound = zip:getSample3D("fire.wav");
  fireSound:setLooping(1)
  fireSound:setVolume(255)
  fireSound:setMinDistance(30)
  local fireSource = Source(fireSound,fireEmitter);
  addSource(fireSource)
  ----SMOKE----
  local smokeImage = zip:getImage("smoke.png")
  smokeImage:convertToRGBA()
  local smokeTexture = Texture(smokeImage)
  smokeImage:delete()
  local smokeEmitter = Emitter(40,4,100)
  smokeEmitter:setTexture(smokeTexture,1)
  smokeEmitter:setVelocity(5,12,-3, 2.5)
  smokeEmitter:setColor(0,0,0,0.8, 0.25,0.25,0.25,0)
  smokeEmitter:setSize(2,10)
  smokeEmitter:setGravity(0,0,0, 0,0,0)
  smokeEmitter:move(0,35,0)
  smokeEmitter:reset()
  addObject(smokeEmitter)
  smokeTexture:delete()
  ----SET HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[LEFT ] Rotate Left",
    "[RIGHT] Rotate Right",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[SPACE] On/Off Rotation",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  showHelpReduced()
  hideConsole()
  ----DELETE ZIP----
  zip:delete()
end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
  end
  if isKeyPressed(string.byte(" ")) then
    releaseKey(string.byte(" "))
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  end
  ----MOVE CAMERA (KEYBOARD)----
  local speed = 75;
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(speed*timeStep)
  end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-speed*timeStep)
  end
  if isKeyPressed(37) then --> VK_LEFT
    camera:rotStanding(0.4*timeStep)
  end
  if isKeyPressed(39) then --> VK_RIGHT
    camera:rotStanding(-0.4*timeStep)
  end
  local climbSpeed = 50
  if isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  end
  if isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
  end
  ----LOAD MAIN MENU----
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    if fileExists("main.lua") then
      final()
      dofile("main.lua")
    end
    return
  end
  ----MOVE CAMERA (MOUSE)----
  local dx, dy = getMouseMove()
  local changeStep = 0.15*timeStep;
  if dx ~= 0 then
    camera:rotStanding(-dx*changeStep)
  end
  if dy ~= 0 then
    camera:pitch(-dy*changeStep)
  end
  local posX, posY, posZ = camera:getPosition()
  if posY < 1 then
    camera:setPosition(posX,1,posZ)
  end
end

----FINALIZATION----
function final()
  ----DELETE GLOBALS----
  rotateView = nil
  ----STOP MUSIC----
  if soundTrack then
    soundTrack:stop()
    soundTrack:delete()
    soundTrack = nil
  end
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----SCENE SETUP----
setScene(Scene(init,update,final))
