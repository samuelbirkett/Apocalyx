----Collection of Particles-Based Physics Engine Demos
----Questions? Contact: Leonardo Boselli <boselli@uno.it>

ALL = {}
STANDARD = {}
TABLES = {}
FLAG_WAVER = {}
JELLY_CUBE = {}
JELLY_TREE = {}
HINGES = {}
CUBES = {}
MENU = {}

----Common functions

function ALL.init()
  empty()
  enableFog(200, .522,.373,.298)
  ----SKYBOX----
  local zip = Zip("PhysicsDemo.dat")
  local skyTxt = {
    zip:getTexture("SkyboxTop.jpg"),
    zip:getTexture("SkyboxLeft.jpg"),
    zip:getTexture("SkyboxFront.jpg"),
    zip:getTexture("SkyboxRight.jpg"),
    zip:getTexture("SkyboxBack.jpg")
  }
  local sky = MirroredSky(skyTxt)
  setBackground(sky);
  ----SUN----
  sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, 0.9659,
    zip:getTexture("lensflares.png"),
    5, 0.1
  )
  sun:setColor(0.855,0.475,0.298);
  setSun(sun)
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(1,1,1)
  terrainMaterial:setDiffuse(0,0,0)
  terrainMaterial:setDiffuseTexture(zip:getTexture("marble.jpg",1))
  local terrain = FlatTerrain(terrainMaterial,3000,300)
  terrain:setReflective()
  setTerrain(terrain)
  return zip
end

function ALL.update(camera,timeStep)
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
  end
  ----MOVE CAMERA (KEYBOARD)----
  local speed = 3
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(speed*timeStep)
  end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-speed*timeStep)
  end
  local climbSpeed = 3
  if isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  end
  if isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
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

function ALL.final()
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

function ALL.keyDown(key)
  if key == string.byte("\r") then
  ----LOAD MAIN MENU----
    releaseKey(key)
    setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
  elseif key == string.byte(" ") then
  ----ROTATE VIEW----
    releaseKey(key)
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  end
end

----CLOTH DEMO (STANDARD)
----A simulator of cloths

----INITIALIZATION----
function STANDARD.init()
  local zip = ALL.init()
  ----GLOBALS----
  windSpeed = 4
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
  camera:rotStanding(3.1415)
  ----FLAG SIMULATOR----
  simulator = Simulator()
  clothEnvironment = StaticEnvironment(windSpeed,0,-windSpeed, 0)
  local SIDE_CT = 17
  local SIDE_LEN = 3
  local posX = SIDE_LEN/2
  flag = Cloth(
    SIDE_CT, SIDE_CT, ---- width, height
    posX,6,0, ---- origin
    -SIDE_LEN/SIDE_CT,0,0, ---- uGen
    0,0,SIDE_LEN/SIDE_CT, ---- vGen
    0.05, ---- mass
    simulator, clothEnvironment
  )
  for ct = 0, SIDE_CT-1, 4 do
    flag:addNail(ct*SIDE_CT, 0,3+ct*3/SIDE_CT,0)
  end
  local baseIndex = SIDE_CT*SIDE_CT-SIDE_CT
  for ct = 0, SIDE_CT-1, 4 do
    flag:addNail(baseIndex+ct, ct*2.5/SIDE_CT,6,0)
  end
  ----FLAG RENDERER----
  local pole = zip:getMeshes("pole.3ds")
  pole:move(0,0,0)
  addObject(pole)
  local flagSound = zip:getSample3D("flag.wav");
  flagSound:setLooping(1)
  flagSound:setVolume(255)
  flagSound:setMinDistance(5)
  flagSource = Source(flagSound,pole);
  addSource(flagSource)
  local flagMaterial = Material()
  flagMaterial:setAmbient(0.7,0.7,0.7)
  flagMaterial:setDiffuse(1,1,1)
  flagMaterial:setDiffuseTexture(zip:getTexture("foulard.jpg"))
  flagMaterial:setEnvironmentTexture(zip:getTexture("environ.jpg"),.333)
  local mesh = flag:getMesh()
  mesh:setMaterial(flagMaterial)
  addObject(mesh)
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[ 0-9 ] Wind Speed",
    "[ZXCVB] Relaxation 1-16",
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
function STANDARD.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local simTime = timeStep;
  if(simTime > 0.1) then
    simTime = 0.1
  end
  simulator:runStep(simTime)
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function STANDARD.final()
  flag = nil
  if clothEnvironment then
    clothEnvironment:delete()
    clothEnvironment = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  if flagSource then
    flagSource:getSound3D():stop()
    flagSource = nil
  end
  windSpeed = nil
  ALL.final()
end

----KEY_DOWN----
function STANDARD.keyDown(key)
  ----WIND SPEED----
  local theKey = key-string.byte("0")
  if theKey >= 0 and theKey <= 9 then
    releaseKey(key)
    windSpeed = theKey
    clothEnvironment:setWind(windSpeed,0,-windSpeed)
    local sound = flagSource:getSound3D()
    sound:stop()
    if windSpeed > 2 then
      sound:play()
    end
    return
  end
  ----RELAXATION CYCLES----
  if key == string.byte("Z") then
    releaseKey(key)
    flag:setRelaxationCycles(1)
  elseif key == string.byte("X") then
    releaseKey(key)
    flag:setRelaxationCycles(2)
  elseif key == string.byte("C") then
    releaseKey(key)
    flag:setRelaxationCycles(4)
  elseif key == string.byte("V") then
    releaseKey(key)
    flag:setRelaxationCycles(8)
  elseif key == string.byte("B") then
    releaseKey(key)
    flag:setRelaxationCycles(16)
  end
  ALL.keyDown(key)
end

----CLOTH DEMO (TABLES)
----A simulator of cloths

----INITIALIZATION----
function TABLES.init()
  local zip = ALL.init()
  ----GLOBALS----
  windSpeed = 1
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.6,6)
  camera:rotStanding(3.1415)
  ----CLOTH SIMULATOR----
  simulator = Simulator()
  local boxX, boxY, boxZ = -2, .75, 0
  local boxedObs = BoxedObstruction(boxX,boxY,boxZ, 1.65,.15,1.65)
  clothEnvironment1 = StaticEnvironment(windSpeed,0,-windSpeed,.1,boxedObs)
  local cylX, cylY, cylZ = 2, .75, 0
  local cylindricalObs = CylindricalObstruction(cylX,cylY,cylZ, .85,.15)
  clothEnvironment2 = StaticEnvironment(windSpeed,0,-windSpeed,.1,cylindricalObs)
  local sphX, sphY, sphZ = 0, 2, -3
  local sphericalObs = SphericalObstruction(sphX,sphY,sphZ, 1.05)
  clothEnvironment3 = StaticEnvironment(windSpeed,0,-windSpeed,.1,sphericalObs)
  local SIDE_CT = 23
  local SIDE_LEN = 2.25
  local posX = SIDE_LEN/2
  local posZ = -posX
  local posY = 1.1
  local tableCloth1 = Cloth(
    SIDE_CT, SIDE_CT, ---- width, height
    posX+boxX,posY+boxY,posZ+boxZ, ---- origin
    -SIDE_LEN/SIDE_CT,0,0, ---- uGen
    0,0,SIDE_LEN/SIDE_CT, ---- vGen
    0.2, ---- mass
    simulator, clothEnvironment1
  )
  local tableCloth2 = Cloth(
    SIDE_CT, SIDE_CT, ---- width, height
    posX+cylX,posY+cylY,posZ+cylZ, ---- origin
    -SIDE_LEN/SIDE_CT,0,0, ---- uGen
    0,0,SIDE_LEN/SIDE_CT, ---- vGen
    0.2, ---- mass
    simulator, clothEnvironment2
  )
  local SIDE_CT = 23
  local SIDE_LEN = 5
  local posX = SIDE_LEN/2
  local posZ = -posX
  local foulard = Cloth(
    SIDE_CT, SIDE_CT, ---- width, height
    posX+sphX,posY+sphY,posZ+sphZ, ---- origin
    -SIDE_LEN/SIDE_CT,0,0, ---- uGen
    0,0,SIDE_LEN/SIDE_CT, ---- vGen
    0.4, ---- mass
    simulator, clothEnvironment3
  )
  ----TABLES RENDERER----
  local squareTable = zip:getMeshes("squareTable.3ds")
  squareTable:move(-2,0,0)
  addObject(squareTable)
  local roundTable = zip:getMeshes("roundTable.3ds")
  roundTable:move(2,0,0)
  addObject(roundTable)
  local sphere = zip:getMeshes("sphere.3ds")
  sphere:move(0,1,-3)
  addObject(sphere)
  ----CLOTH RENDERER----
  local foulardMaterial = Material()
  foulardMaterial:setAmbient(0.7,0.7,0.7)
  foulardMaterial:setDiffuse(1,1,1)
  foulardMaterial:setDiffuseTexture(zip:getTexture("foulard.jpg"))
  foulardMaterial:setEnvironmentTexture(zip:getTexture("environ.jpg"),.333)
  local tableClothMaterial = Material()
  tableClothMaterial:setAmbient(0.7,0.7,0.7)
  tableClothMaterial:setDiffuse(1,1,.5)
  tableClothMaterial:setDiffuseTexture(zip:getTexture("net.jpg"))
  local mesh = tableCloth1:getMesh()
  mesh:setMaterial(tableClothMaterial)
  addObject(mesh)
  local mesh = tableCloth2:getMesh()
  mesh:setMaterial(tableClothMaterial)
  addObject(mesh)
  local mesh = foulard:getMesh()
  mesh:setMaterial(foulardMaterial)
  addObject(mesh)
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[ 0-9 ] Wind Speed",
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
function TABLES.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local simTime = timeStep;
  if(simTime > 0.1) then
    simTime = 0.1
  end
  simulator:runStep(simTime)
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function TABLES.final()
  if clothEnvironment1 then
    clothEnvironment1:delete()
    clothEnvironment1 = nil
  end
  if clothEnvironment2 then
    clothEnvironment2:delete()
    clothEnvironment2 = nil
  end
  if clothEnvironment3 then
    clothEnvironment3:delete()
    clothEnvironment3 = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  windSpeed = nil
  ALL.final()
end

----KEY_DOWN----
function TABLES.keyDown(key)
  ----WIND SPEED----
  local theKey = key-string.byte("0")
  if theKey >= 0 and theKey <= 9 then
    releaseKey(key)
    windSpeed = theKey
    clothEnvironment1:setWind(windSpeed,0,-windSpeed)
    clothEnvironment2:setWind(windSpeed,0,-windSpeed)
    clothEnvironment3:setWind(windSpeed,0,-windSpeed)
    return
  end
  ALL.keyDown(key)
end

----CLOTH DEMO (FLAG)
----A cloth simulator

----INITIALIZATION----
function FLAG_WAVER.init()
  local zip = ALL.init()
  ----SOME GLOBALS----
  linkTransform = Transform()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
  ----MODELS----
  torso = 0
  legs = 6   ---> LEGS_IDLE
  avatar = zip:getBot("warrior.mdl",1)
  avatar:rescale(0.04)
  avatar:pitch(-1.5708)
  avatar:rotStanding(1.5708)
  avatar:move(0,1,0)
  avatar:setUpperAnimation(torso)
  avatar:setLowerAnimation(legs)
  addObject(avatar)
  pole = zip:getMesh("pole2.3ds")
  pole:pitch(1.5708)
  pole:move(-0.15,0,-0.5)
  avatar:getUpper():link("tag_weapon",pole)
  ----FLAG SIMULATOR----
  local posHighX, posHighY, posHighZ = -0.15, 0, 5.5
  local posLowX, posLowY, posLowZ = -0.15, 0, 2.5
  if avatar:getLinkTransform("tag_weapon",linkTransform) then
    posHighX, posHighY, posHighZ = linkTransform:multiply(
      posHighX, posHighY, posHighZ
    )
    posLowX, posLowY, posLowZ = linkTransform:multiply(
      posLowX, posLowY, posLowZ
    )
  end
  simulator = Simulator()
  windSpeed = 2
  environment = StaticEnvironment(-windSpeed,0,windSpeed, 0.01)
  local SIDE_CT = 17
  local SIDE_LEN = 3
  cloth = Cloth(
    SIDE_CT, SIDE_CT,        ---> width, height
    posLowX,posLowY,posLowZ, ---> origin
    0,SIDE_LEN/SIDE_CT,0,    ---> uGen
    -SIDE_LEN/SIDE_CT,0,0,   ---> vGen
    0.01,                    ---> mass
    simulator, environment
  )
  cloth:setRelaxationCycles(4)
  cloth:addNail(0, posLowX,posLowY,posLowZ)
  cloth:addNail(SIDE_CT-1, posHighX,posHighY,posHighZ)
  local flagMaterial = Material()
  flagMaterial:setAmbient(0.7,0.7,0.7)
  flagMaterial:setDiffuse(1,1,1)
  flagMaterial:setSpecular(1,1,1)
  flagMaterial:setShininess(128)
  flagMaterial:setDiffuseTexture(zip:getTexture("foulard.jpg"))
  flagMaterial:setEnvironmentTexture(zip:getTexture("environ.jpg"),0.25)
  local clothModel = cloth:getMesh()
  clothModel:setMaterial(flagMaterial)
  addObject(clothModel)
  local flagSound = zip:getSample3D("flag.wav");
  flagSound:setLooping(1)
  flagSound:setVolume(255)
  flagSound:setMinDistance(4)
  flagSource = Source(flagSound,clothModel);
  addSource(flagSource)
  ----HELP----
  local help = {
    "[  MOUSE  ] Look around",
    "[ UP/DOWN ] Move Forward/Back",
    "[PREV/NEXT] Raise/Lower View",
    "[  X key  ] Change Movement",
    "[ Q,W,E,R ] Rotate/Bend Head",
    "[ A,S,D,F ] Rotate/Bend Torso",
    "[ 0,1...6 ] Select Wind Speed",
    "[  7,8,9  ] Select Flag Elasticity",
    "[  SPACE  ] Rotate Scene",
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
function FLAG_WAVER.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local fwdSpeed = 0
  local rotSpeed = 0
  if legs == 0 then  ---> LEGS_WALKCR
    fwdSpeed = 2.5
    rotSpeed = 0.31415
  elseif legs == 1 then ---> LEGS_WALK
    fwdSpeed = 2.5
    rotSpeed = 0.6283
  elseif legs == 2 then ---> LEGS_RUN
    fwdSpeed = 5
    rotSpeed = 0.6283
  elseif legs == 3 then ---> LEGS_BACK
    fwdSpeed = -3.5
    rotSpeed = 0.31415
  elseif legs == 8 then ---> LEGS_TURN
    rotSpeed = 1.5708
  end
  avatar:walk(fwdSpeed*timeStep);
  avatar:rotStanding(rotSpeed*timeStep);
  local stopped = avatar:getLower():getStoppedAnimation()
  if stopped == 4 then ---> LEGS_JUMP
    avatar:setLowerAnimation(5) ---> LEGS_LAND
  elseif stopped == 5 then ---> LEGS_LAND
    avatar:setLowerAnimation(6) ---> LEGS_IDLE
  end
  stopped = avatar:getUpper():getStoppedAnimation()
  ----MODEL MOVEMENT----
  if isKeyPressed(string.byte("A")) then
    local angle = 3.1415*timeStep
    avatar:getUpper():addYawAngle(angle,1.047)
  elseif isKeyPressed(string.byte("S")) then
    local angle = -3.1415*timeStep
    avatar:getUpper():addYawAngle(angle,1.047)
  elseif isKeyPressed(string.byte("D")) then
    local angle = 3.1415*timeStep
    avatar:getUpper():addPitchAngle(angle,0.7854)
  elseif isKeyPressed(string.byte("F")) then
    local angle = -3.1415*timeStep
    avatar:getUpper():addPitchAngle(angle,0.7854)
  elseif isKeyPressed(string.byte("Q")) then
    local angle = 3.1415*timeStep
    avatar:getHead():addYawAngle(angle,1.5708)
  elseif isKeyPressed(string.byte("W")) then
    local angle = -3.1415*timeStep
    avatar:getHead():addYawAngle(angle,1.5708)
  elseif isKeyPressed(string.byte("E")) then
    local angle = 3.1415*timeStep
    avatar:getHead():addPitchAngle(angle,0.7854)
  elseif isKeyPressed(string.byte("R")) then
    local angle = -3.1415*timeStep
    avatar:getHead():addPitchAngle(angle,0.7854)
  end
  if avatar:getLinkTransform("tag_weapon",linkTransform) then
    local posX,posY,posZ = -0.15,0,5.5
    posX,posY,posZ = linkTransform:multiply(posX,posY,posZ);
    cloth:setNailPosition(1,posX,posY,posZ)
    posX,posY,posZ = -0.15,0,2.5
    posX,posY,posZ = linkTransform:multiply(posX,posY,posZ);
    cloth:setNailPosition(0,posX,posY,posZ)
  end
  local simTime = timeStep
  if(simTime > 0.1) then
    simTime = 0.1
  end
  simulator:runStep(simTime)
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function FLAG_WAVER.final()
  ----DELETE GLOBALS----
  linkTransform:delete()
  if environment then
    environment:delete()
    environment = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  windSpeed = nil
  flagSource = nil
  rotateView = nil
  torso = nil
  legs = nil
  ----EMPTY WORLD----
  avatar = nil
  if pole then
    pole:delete()
    pole = nil
  end
  cloth = nil
end

----KEYBOARD----
function FLAG_WAVER.keyDown(key)
  ----WIND SPEED & RELAXATION----
  local asciiBase = string.byte("0")
  for ct = 0, 6 do
    if key == asciiBase+ct then
      releaseKey(asciiBase+ct)
      windSpeed = ct*0.5
      environment:setWind(-windSpeed,0,windSpeed)
      local sound = flagSource:getSound3D()
      sound:stop()
      if windSpeed > 2 then
        sound:play()
      end
      break
    end
  end
  for ct = 7, 9 do
    if key == asciiBase+ct then
      releaseKey(asciiBase+ct)
      local val = 4
      if ct == 7 then
        val = 2
      elseif ct == 9 then
        val = 8
      end
      cloth:setRelaxationCycles(val)
      break
    end
  end
  ----VARIOUS SCENE MODIFIERS----
  if key == string.byte("X") then
    releaseKey(string.byte("X"))
    legs = legs+1
    if legs >= 9 then ---> MAX_LEGS_ANIMATIONS
      legs = 0 ---> LEGS_WALKCR
    elseif legs == 5 then ---> LEGS_LAND
      legs = 7 ---> LEGS_IDLECR
    end
    avatar:setLowerAnimation(legs)
  end
  ALL.keyDown(key)
end

----JELLY CUBE
----

----INITIALIZATION----
function JELLY_CUBE.init()
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
  camera:rotStanding(3.1415)
  ----GLOBALS----
  windSpeed = 0
  ----FLAG SIMULATOR----
  simulator = Simulator()
  environment = StaticEnvironment(windSpeed,0,-windSpeed, 0)
  -- local PARTICLES_COUNT = 16*2+12*2
  local SIDE_STEP = 0.5
  local HEIGHT = 4
  local particlePositions = {
    SIDE_STEP*2,  HEIGHT+SIDE_STEP*2, -SIDE_STEP*2,
    SIDE_STEP,    HEIGHT+SIDE_STEP*2, -SIDE_STEP*2,
    -SIDE_STEP,   HEIGHT+SIDE_STEP*2, -SIDE_STEP*2,
    -SIDE_STEP*2, HEIGHT+SIDE_STEP*2, -SIDE_STEP*2,
    SIDE_STEP*2,  HEIGHT+SIDE_STEP*2, -SIDE_STEP,
    SIDE_STEP,    HEIGHT+SIDE_STEP*2, -SIDE_STEP,
    -SIDE_STEP,   HEIGHT+SIDE_STEP*2, -SIDE_STEP,
    -SIDE_STEP*2, HEIGHT+SIDE_STEP*2, -SIDE_STEP,
    SIDE_STEP*2,  HEIGHT+SIDE_STEP*2, SIDE_STEP,
    SIDE_STEP,    HEIGHT+SIDE_STEP*2, SIDE_STEP,
    -SIDE_STEP,   HEIGHT+SIDE_STEP*2, SIDE_STEP,
    -SIDE_STEP*2, HEIGHT+SIDE_STEP*2, SIDE_STEP,
    SIDE_STEP*2,  HEIGHT+SIDE_STEP*2, SIDE_STEP*2,
    SIDE_STEP,    HEIGHT+SIDE_STEP*2, SIDE_STEP*2,
    -SIDE_STEP,   HEIGHT+SIDE_STEP*2, SIDE_STEP*2,
    -SIDE_STEP*2, HEIGHT+SIDE_STEP*2, SIDE_STEP*2,
    SIDE_STEP*2,  HEIGHT+SIDE_STEP, -SIDE_STEP*2,
    SIDE_STEP,    HEIGHT+SIDE_STEP, -SIDE_STEP*2,
    -SIDE_STEP,   HEIGHT+SIDE_STEP, -SIDE_STEP*2,
    -SIDE_STEP*2, HEIGHT+SIDE_STEP, -SIDE_STEP*2,
    SIDE_STEP*2,  HEIGHT+SIDE_STEP, -SIDE_STEP,
    -SIDE_STEP*2, HEIGHT+SIDE_STEP, -SIDE_STEP,
    SIDE_STEP*2,  HEIGHT+SIDE_STEP, SIDE_STEP,
    -SIDE_STEP*2, HEIGHT+SIDE_STEP, SIDE_STEP,
    SIDE_STEP*2,  HEIGHT+SIDE_STEP, SIDE_STEP*2,
    SIDE_STEP,    HEIGHT+SIDE_STEP, SIDE_STEP*2,
    -SIDE_STEP,   HEIGHT+SIDE_STEP, SIDE_STEP*2,
    -SIDE_STEP*2, HEIGHT+SIDE_STEP, SIDE_STEP*2,
    SIDE_STEP*2,  HEIGHT-SIDE_STEP, -SIDE_STEP*2,
    SIDE_STEP,    HEIGHT-SIDE_STEP, -SIDE_STEP*2,
    -SIDE_STEP,   HEIGHT-SIDE_STEP, -SIDE_STEP*2,
    -SIDE_STEP*2, HEIGHT-SIDE_STEP, -SIDE_STEP*2,
    SIDE_STEP*2,  HEIGHT-SIDE_STEP, -SIDE_STEP,
    -SIDE_STEP*2, HEIGHT-SIDE_STEP, -SIDE_STEP,
    SIDE_STEP*2,  HEIGHT-SIDE_STEP, SIDE_STEP,
    -SIDE_STEP*2, HEIGHT-SIDE_STEP, SIDE_STEP,
    SIDE_STEP*2,  HEIGHT-SIDE_STEP, SIDE_STEP*2,
    SIDE_STEP,    HEIGHT-SIDE_STEP, SIDE_STEP*2,
    -SIDE_STEP,   HEIGHT-SIDE_STEP, SIDE_STEP*2,
    -SIDE_STEP*2, HEIGHT-SIDE_STEP, SIDE_STEP*2,
    SIDE_STEP*2,  HEIGHT-SIDE_STEP*2, -SIDE_STEP*2,
    SIDE_STEP,    HEIGHT-SIDE_STEP*2, -SIDE_STEP*2,
    -SIDE_STEP,   HEIGHT-SIDE_STEP*2, -SIDE_STEP*2,
    -SIDE_STEP*2, HEIGHT-SIDE_STEP*2, -SIDE_STEP*2,
    SIDE_STEP*2,  HEIGHT-SIDE_STEP*2, -SIDE_STEP,
    SIDE_STEP,    HEIGHT-SIDE_STEP*2, -SIDE_STEP,
    -SIDE_STEP,   HEIGHT-SIDE_STEP*2, -SIDE_STEP,
    -SIDE_STEP*2, HEIGHT-SIDE_STEP*2, -SIDE_STEP,
    SIDE_STEP*2,  HEIGHT-SIDE_STEP*2, SIDE_STEP,
    SIDE_STEP,    HEIGHT-SIDE_STEP*2, SIDE_STEP,
    -SIDE_STEP,   HEIGHT-SIDE_STEP*2, SIDE_STEP,
    -SIDE_STEP*2, HEIGHT-SIDE_STEP*2, SIDE_STEP,
    SIDE_STEP*2,  HEIGHT-SIDE_STEP*2, SIDE_STEP*2,
    SIDE_STEP,    HEIGHT-SIDE_STEP*2, SIDE_STEP*2,
    -SIDE_STEP,   HEIGHT-SIDE_STEP*2, SIDE_STEP*2,
    -SIDE_STEP*2, HEIGHT-SIDE_STEP*2, SIDE_STEP*2,
  }
  local textureCoords = {
    0,0, 0,.33, 0,.66, 0,1,
    0,.33, 0,0, 0,1, 0,.66,
    0,.66, 0,1, 0,0, 0,.33,
    0,1, 0,.66, 0,.33, 0,0,
    .33,0, .33,.33, .33,.66, .33,1,
    .33,.33, .33,.66,
    .33,.66, .33,.33,
    .33,1, .33,.66, .33,.33, .33,0,
    .66,0, .66,.33, .66,.66, .66,1,
    .66,.33, .66,.66,
    .66,.66, .66,.33,
    .66,1, .66,.66, .66,.33, .66,0,
    1,0, 1,.33, 1,.66, 1,1,
    1,.33, 1,0, 1,1, 1,.66,
    1,.66, 1,1, 1,0, 1,.33,
    1,1, 1,.66, 1,.33, 1,0,
  }
  -- local TRIANGLES_COUNT = 18*2+24*3
  local triangleIndexes = {
    0,1,4, 4,1,5, 5,1,2, 5,2,6, 6,2,3, 6,3,7,
    8,4,5, 8,5,9, 9,5,6, 9,6,10, 10,6,7, 10,7,11,
    12,8,9, 12,9,13, 13,9,10, 13,10,14, 14,10,11, 14,11,15,
    44,41,40, 44,45,41, 45,42,41, 45,46,42, 46,43,42, 46,47,43,
    48,45,44, 48,49,45, 49,46,45, 49,50,46, 50,47,46, 50,51,47,
    52,49,48, 52,53,49, 53,50,49, 53,54,50, 54,51,50, 54,55,51,
    0,16,1, 1,16,17, 1,17,2, 2,17,18, 2,18,3, 3,18,19,
    3,19,7, 7,19,21, 7,21,11, 11,21,23, 11,23,15, 15,23,27,
    15,27,14, 14,27,26, 14,26,13, 13,26,25, 13,25,12, 12,25,24,
    12,24,8, 8,24,22, 8,22,4, 4,22,20, 4,20,0, 0,20,16,
    16,28,17, 17,28,29, 17,29,18, 18,29,30, 18,30,19, 19,30,31,
    19,31,21, 21,31,33, 21,33,23, 23,33,35, 23,35,27, 27,35,39,
    27,39,26, 26,39,38, 26,38,25, 25,38,37, 25,37,24, 24,37,36,
    24,36,22, 22,36,34, 22,34,20, 20,34,32, 20,32,16, 16,32,28,
    28,40,29, 29,40,41, 29,41,30, 30,41,42, 30,42,31, 31,42,43,
    31,43,33, 33,43,47, 33,47,35, 35,47,51, 35,51,39, 39,51,55,
    39,55,38, 38,55,54, 38,54,37, 37,54,53, 37,53,36, 36,53,52,
    36,52,34, 34,52,48, 34,48,32, 32,48,44, 32,44,28, 28,44,40,
  }
  -- local STICKS_COUNT = 33*2+24*3+12*2;
  local stickIndexes = {
    0,1, 1,2, 2,3, 4,5, 5,6, 6,7, 8,9, 9,10, 10,11, 12,13, 13,14, 14,15,
    0,4, 4,8, 8,12, 1,5, 5,9, 9,13, 2,6, 6,10, 10,14, 3,7, 7,11, 11,15,
    4,1, 5,2, 6,3, 8,5, 9,6, 10,7, 12,9, 13,10, 14,11,
    40,41, 41,42, 42,43, 44,45, 45,46, 46,47,
    48,49, 49,50, 50,51, 52,53, 53,54, 54,55,
    40,44, 44,48, 48,52, 41,45, 45,49, 49,53,
    42,46, 46,50, 50,54, 43,47, 47,51, 51,55,
    44,41, 45,42, 46,43, 48,45, 49,46, 50,47, 52,49, 53,50, 54,51,
    0,16, 1,16, 1,17, 2,17, 2,18, 3,18, 3,19, 7,19, 7,21, 11,21, 11,23,
    15,23, 15,27, 14,27, 14,26, 13,26, 13,25, 12,25, 12,24, 8,24, 8,22,
    4,22, 4,20, 0,20,
    16,17, 17,18, 18,19, 19,21, 21,23, 23,27,
    27,26, 26,25, 25,24, 24,22, 22,20, 20,16,
    16,28, 17,28, 17,29, 18,29, 18,30, 19,30, 19,31, 21,31, 21,33, 23,33,
    23,35, 27,35, 27,39, 26,39, 26,38, 25,38, 25,37, 24,37, 24,36,
    22,36, 22,34, 20,34, 20,32, 16,32,
    28,29, 29,30, 30,31, 31,33, 33,35, 35,39,
    39,38, 38,37, 37,36, 36,34, 34,32, 32,28,
    28,40, 29,40, 29,41, 30,41, 30,42, 31,42, 31,43, 33,43, 33,47,
    35,47, 35,51, 39,51, 39,55, 38,55, 38,54, 37,54, 37,53, 36,53, 36,52,
    34,52, 34,48, 32,48, 32,44, 28,44,
  }
  -- local PADDINGS_COUNT = 4+8+4
  local paddingIndexes = {
    0,55, 12,43, 15,40, 3,52,
    13,42, 14,41, 11,44, 7,48, 2,53, 1,54, 4,51, 8,47,
    16,39, 28,27, 19,36, 31,24,
  }
  local paddingKs = {
    0.75, 0.75, 0.75, 0.75,
    0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75,
    0.75, 0.75, 0.75, 0.75,
  }
  machinery = Machinery(
    simulator,environment,1,
    particlePositions, stickIndexes,
    textureCoords, triangleIndexes,
    nil, nil, 
    nil, nil, 
    nil, nil, 
    nil, nil, 
    paddingIndexes, paddingKs
  ) 
  machinery:setRelaxationCycles(1)
  machinery:setAirDragEnabled(true)
  local model = machinery:getMesh()
  local cubeMaterial = Material()
  cubeMaterial:setAmbient(0.7,0.7,0.7)
  cubeMaterial:setDiffuse(1,1,1)
  cubeMaterial:setDiffuseTexture(zip:getTexture("agate.jpg"))
  cubeMaterial:setEnvironmentTexture(zip:getTexture("environ.jpg"),.333)
  model:setMaterial(cubeMaterial)
  addObject(model)
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[ 0-9 ] Wind Speed",
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
function JELLY_CUBE.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local simTime = timeStep;
  if(simTime > 0.1) then
    simTime = 0.1
  end
  simulator:runStep(simTime)
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function JELLY_CUBE.final()
  machinery = nil
  if environment then
    environment:delete()
    environment = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  windSpeed = nil
  ALL.final()
end

----KEY_DOWN----
function JELLY_CUBE.keyDown(key)
  ----WIND SPEED----
  local theKey = key-string.byte("0")
  if theKey >= 0 and theKey <= 9 then
    releaseKey(key)
    windSpeed = theKey
    environment:setWind(windSpeed,0,-windSpeed)
    return
  end
  ALL.keyDown(key)
end

----JELLY TREE
----

----INITIALIZATION----
function JELLY_TREE.init()
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
  camera:rotStanding(3.1415)
  ----GLOBALS----
  windSpeed = 4
  ----FLAG SIMULATOR----
  simulator = Simulator()
  environment = StaticEnvironment(windSpeed,0,-windSpeed, 0)
  -- local PARTICLES_COUNT = 21;
  local TRUNCK_SIZE = 0.25
  local TRUNCK_HEIGHT = 2
  local BRANCH_SIZE = 1.5
  local BRANCH_HEIGHT = 3
  local LEAF_SIZE = 2
  local LEAF_HEIGHT = 4
  local positions = {
    BRANCH_SIZE,LEAF_HEIGHT,-BRANCH_SIZE,
    0,0,TRUNCK_SIZE*2,
    TRUNCK_SIZE*2,0,0,
    0,0,-TRUNCK_SIZE*2,
    -TRUNCK_SIZE,TRUNCK_HEIGHT,0,
    0,TRUNCK_HEIGHT,TRUNCK_SIZE,
    TRUNCK_SIZE,TRUNCK_HEIGHT,0,
    0,TRUNCK_HEIGHT,-TRUNCK_SIZE,
    0,TRUNCK_HEIGHT+TRUNCK_SIZE,0,
    -BRANCH_SIZE,BRANCH_HEIGHT,-BRANCH_SIZE,
    -BRANCH_SIZE,BRANCH_HEIGHT,BRANCH_SIZE,
    BRANCH_SIZE,BRANCH_HEIGHT,BRANCH_SIZE,
    BRANCH_SIZE,BRANCH_HEIGHT,-BRANCH_SIZE,
    -LEAF_SIZE,BRANCH_HEIGHT,-LEAF_SIZE,
    -LEAF_SIZE,BRANCH_HEIGHT,LEAF_SIZE,
    LEAF_SIZE,BRANCH_HEIGHT,LEAF_SIZE,
    LEAF_SIZE,BRANCH_HEIGHT,-LEAF_SIZE,
    -BRANCH_SIZE,LEAF_HEIGHT,-BRANCH_SIZE,
    -BRANCH_SIZE,LEAF_HEIGHT,BRANCH_SIZE,
    BRANCH_SIZE,LEAF_HEIGHT,BRANCH_SIZE,
    -TRUNCK_SIZE*2,0,0,
  }
  local textureCoords = {
    0, 0,  1, 0,   0, 0,   1, 0,   1, 1,   0, 1,   1, 1,    0, 1,
    0, 0,  1, 1,   1, 0,   1, 1,   1, 0,   1, 1,   1, 0,    1, 1,
    1, 0,  0, 1,   0, 0,   0, 1,   0, 0,
  }
  -- local TRIANGLES_COUNT = 44
  local triangles = {
    20,1,5, 20,5,4,
    1,2,6, 1,6,5,
    6,2,3, 6,3,7,
    7,3,20, 7,20,4,
    8,7,9,
    7,4,9,
    9,4,8,
    8,4,10,
    8,10,5,
    5,10,4,
    8,5,11,
    8,11,6,
    11,5,6,
    8,12,7,
    8,6,12,
    12,6,7,
    9,14,13, 9,10,14,
    10,15,14, 15,10,11,
    15,11,16, 16,11,12,
    12,13,16, 12,9,13,
    9,17,18, 18,10,9,
    19,10,18, 19,11,10,
    19,12,11, 19, 0,12,
    0,17,9,  0,9,12,
    18,17,13, 18,13,14,
    19,18,14, 19,14,15,
    19,15,16, 19,16, 0,
    0,16,13,  0,13,17,
  }
  -- local STICKS_COUNT = 52
  local sticks = {
    20,5, 1,6, 2,7, 3,4, 20,4, 1,5, 2,6, 3,7, 6,7, 7,4, 4,5, 5,6,
    4,8, 5,8, 6,8, 7,8, 9,4, 9,7, 9,8, 10,4, 10,5, 10,8, 11,8, 11,5, 11,6,
    12,6, 12,7, 12,8, 11,10, 10,9, 9,12, 12,11, 15,14, 14,13, 13,16, 16,15,
    16,12, 15,11, 10,14, 9,13, 12, 0, 16, 0, 19,11, 19,15,
    10,18, 18,14, 17,9, 17,13,  0,17, 17,18, 18,19, 19, 0,
  }
  -- local PADDINGS_COUNT = 12
  local paddings = {
    0,8, 19,8, 18,8, 17,8,
    13,20, 13,3, 14,1, 14,20, 15,1, 15,2, 16,2, 16,3,
  }
  local paddingsKs = {
    0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75,
    0.75, 0.75,
  }
  -- local NAILS_COUNT = 4;
  local nails = {20,1,2,3}
  machinery = Machinery(
    simulator,environment,2.5,
    positions, sticks,
    textureCoords, triangles,
    nil, nil, 
    nil, nil, 
    nil, nil, 
    nil, nil, 
    paddings, paddingsKs, nails
  ) 
  machinery:setRelaxationCycles(8)
  machinery:setAirDragEnabled()
  local model = machinery:getMesh()
  local treeMaterial = Material()
  treeMaterial:setAmbient(0.7,0.7,0.7)
  treeMaterial:setDiffuse(1,1,1)
  treeMaterial:setDiffuseTexture(zip:getTexture("wood.jpg"))
  model:setMaterial(treeMaterial)
  addObject(model)
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[ 0-9 ] Wind Speed",
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
function JELLY_TREE.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local simTime = timeStep;
  if(simTime > 0.1) then
    simTime = 0.1
  end
  simulator:runStep(simTime)
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function JELLY_TREE.final()
  machinery = nil
  if environment then
    environment:delete()
    environment = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  windSpeed = nil
  ALL.final()
end

----KEY_DOWN----
function JELLY_TREE.keyDown(key)
  ----WIND SPEED----
  local theKey = key-string.byte("0")
  if theKey >= 0 and theKey <= 9 then
    releaseKey(key)
    windSpeed = theKey
    environment:setWind(windSpeed,0,-windSpeed)
    return
  end
  ALL.keyDown(key)
end

----HINGES
----

----INITIALIZATION----
function HINGES.init()
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
  camera:rotStanding(3.1415)
  ----GLOBALS----
  windSpeed = 0
  ----FLAG SIMULATOR----
  simulator = Simulator()
  environment = StaticEnvironment(windSpeed,0,-windSpeed, 0)
  -- local PARTICLES_COUNT = 6
  local HALF_SIZE   = 0.5
  local HALF_HEIGHT = 1.5
  local HEIGHT = 4
  local LEFT = 1
  local positions = {
    0+LEFT, -HALF_HEIGHT*2+HEIGHT,  0,
    HALF_SIZE+LEFT, -HALF_HEIGHT-HALF_SIZE+HEIGHT, 0,
    0+LEFT, -HALF_HEIGHT+HEIGHT,  -HALF_SIZE,
    0+LEFT, -HALF_HEIGHT+HEIGHT,  HALF_SIZE,
    HALF_SIZE+LEFT, -HALF_HEIGHT+HALF_SIZE+HEIGHT, 0,
    0+LEFT, HEIGHT, 0,
  }
  local textureCoords = {
    0, 0,   1, 1,   1, 0,   0, 1,  0, 0,  1, 1,
  }
  -- local TRIANGLES_COUNT = 12
  local triangles = {
    0, 1, 2,
    0, 2, 3,
    0, 3, 1,
    4, 2, 1,
    4, 1, 3,
    4, 5, 2,
    5, 3, 2,
    3, 5, 4,
  }
  -- local STICKS_COUNT = 12
  local sticks = {
    0,1, 2,0, 2,3, 3,0, 2,1, 3,1, 4,2, 4,3, 3,2, 3,5, 5,2, 5,4,
  }
  -- local SPRINGS_COUNT = 1;
  local springs = {4,1}
  local springsKs = {0.02}
  -- local BUMPERS_COUNT = 1
  local bumpers = {5,1}
  local distX = positions[13]-positions[16]
  local distY = positions[14]-positions[17]
  local distZ = positions[15]-positions[18]
  local bumpersLen2 = {distX*distX+distY*distY+distZ*distZ}
  -- local NAILS_COUNT = 1
  local nails = {5}
  machinery = Machinery(
    simulator,environment,5,
    positions, sticks,
    textureCoords, triangles,
    nil, nil, 
    bumpers, bumpersLen2, 
    springs, springsKs, 
    nil, nil, 
    nil, nil, nails
  ) 
  machinery:setRelaxationCycles(4)
  machinery:setAirDragEnabled()
  local model = machinery:getMesh()
  local hingeMaterial = Material()
  hingeMaterial:setAmbient(0.7,0.7,0.7)
  hingeMaterial:setDiffuse(1,1,1)
  hingeMaterial:setDiffuseTexture(zip:getTexture("foulard.jpg"))
  model:setMaterial(hingeMaterial)
  addObject(model)
  for ct = 1, table.getn(positions), 3 do
    positions[ct] = positions[ct]-LEFT*2
  end
  -- local DAMPERS_COUNT = 1
  local dampers = {4,1}
  local dampersKs = {0.1}
  machinery2 = Machinery(
    simulator,environment,5,
    positions, sticks,
    textureCoords, triangles,
    nil, nil, 
    bumpers, bumpersLen2, 
    springs, springsKs, 
    dampers, dampersKs, 
    nil, nil, nails
  ) 
  machinery2:setRelaxationCycles(4)
  machinery2:setAirDragEnabled()
  model = machinery2:getMesh()
  model:setMaterial(hingeMaterial)
  addObject(model)
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[ 0-9 ] Wind Speed",
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
function HINGES.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local simTime = timeStep;
  if(simTime > 0.1) then
    simTime = 0.1
  end
  simulator:runStep(simTime)
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function HINGES.final()
  machinery = nil
  machinery2 = nil
  if environment then
    environment:delete()
    environment = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  windSpeed = nil
  ALL.final()
end

----KEY_DOWN----
function HINGES.keyDown(key)
  ----WIND SPEED----
  local theKey = key-string.byte("0")
  if theKey >= 0 and theKey <= 9 then
    releaseKey(key)
    windSpeed = theKey
    environment:setWind(windSpeed,0,-windSpeed)
    return
  end
  ALL.keyDown(key)
end

----CUBES
----

----INITIALIZATION----
function CUBES.init()
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
  camera:rotStanding(3.1415)
  ----GLOBALS----
  windSpeed = 0
  ----FLAG SIMULATOR----
  simulator = Simulator()
  local squareTable = zip:getMeshes("squareTable.3ds")
  addObject(squareTable)
  local boxX, boxY, boxZ = 0, .75, 0
  local boxedObs = BoxedObstruction(boxX,boxY,boxZ, 1.65,.15,1.65)
  environment = StaticEnvironment(windSpeed,0,-windSpeed, 0.1, boxedObs)
  -- local PARTICLES_COUNT = 8
  local HALF_SIZE = 0.33
  local HEIGHT = 4
  local LEFT = 1
  local positions = {
    HALF_SIZE+LEFT, -HALF_SIZE+HEIGHT,  HALF_SIZE,
    -HALF_SIZE+LEFT, -HALF_SIZE+HEIGHT,  HALF_SIZE,
    -HALF_SIZE+LEFT, -HALF_SIZE+HEIGHT, -HALF_SIZE,
    HALF_SIZE+LEFT, -HALF_SIZE+HEIGHT, -HALF_SIZE,
    HALF_SIZE+LEFT,  HALF_SIZE+HEIGHT,  HALF_SIZE,
    -HALF_SIZE+LEFT,  HALF_SIZE+HEIGHT,  HALF_SIZE,
    -HALF_SIZE+LEFT,  HALF_SIZE+HEIGHT, -HALF_SIZE,
    HALF_SIZE+LEFT,  HALF_SIZE+HEIGHT, -HALF_SIZE,
  }
  local textureCoords = {
    0, 0,   0, 1,   1, 1,   1, 0,   0, 1,  1, 1,  1, 0,   0, 0,
  }
  -- local TRIANGLES_COUNT = 12
  local triangles = {
    0, 1, 2,
    0, 2, 3,
    4, 6, 5,
    4, 7, 6,
    0, 4, 5,
    0, 5, 1,
    1, 5, 6,
    1, 6, 2,
    2, 6, 7,
    2, 7, 3,
    0, 3, 4,
    3, 7, 4,
  }
  -- local STICKS_COUNT = 18+6
  local sticks = {
    0, 1,   0, 2,   0, 3,   0, 4,   0, 5,   1, 2,  1, 5,
    1, 6,   2, 3,   2, 6,   2, 7,   3, 4,   3, 7,  4, 5,
    4, 6,   4, 7,   5, 6,   6, 7,
    3,6, 2,5, 1,4, 0,7, 7,5, 1,3,
  }
  machinery = Machinery(
    simulator,environment,1.5,
    positions, sticks,
    textureCoords, triangles
  ) 
  machinery:setRelaxationCycles(4)
  machinery:setAirDragEnabled()
  local model = machinery:getMesh()
  local cubeMaterial = Material()
  cubeMaterial:setAmbient(0.7,0.7,0.7)
  cubeMaterial:setDiffuse(1,1,1)
  cubeMaterial:setDiffuseTexture(zip:getTexture("foulard.jpg"))
  model:setMaterial(cubeMaterial)
  addObject(model)
  for ct = 1, table.getn(positions), 3 do
    positions[ct] = positions[ct]-LEFT*2
  end
  local paddingsKs = {
    0.33,0.33,0.33,0.33,0.33,0.33,0.33,0.33,0.33,0.33,
    0.33,0.33,0.33,0.33,0.33,0.33,0.33,0.33,0.33,0.33,
    0.33,0.33,0.33,0.33,
  }
  machinery2 = Machinery(
    simulator,environment,1.5,
    positions, nil,
    textureCoords, triangles,
    nil, nil,
    nil, nil,
    nil, nil,
    nil, nil,
    sticks, paddingsKs
  ) 
  machinery2:setRelaxationCycles(4)
  machinery2:setAirDragEnabled()
  model = machinery2:getMesh()
  model:setMaterial(cubeMaterial)
  addObject(model)
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[ 0-9 ] Wind Speed",
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
function CUBES.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local simTime = timeStep;
  if(simTime > 0.1) then
    simTime = 0.1
  end
  simulator:runStep(simTime)
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function CUBES.final()
  machinery = nil
  machinery2 = nil
  if environment then
    environment:delete()
    environment = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  windSpeed = nil
  ALL.final()
end

----KEY_DOWN----
function CUBES.keyDown(key)
  ----WIND SPEED----
  local theKey = key-string.byte("0")
  if theKey >= 0 and theKey <= 9 then
    releaseKey(key)
    windSpeed = theKey
    environment:setWind(windSpeed,0,-windSpeed)
    return
  end
  ALL.keyDown(key)
end

----MAIN MENU
----

----INITIALIZATION----Sets the help strings
function MENU.init()
  empty()
  demos = {
    STANDARD,
    TABLES,
    FLAG_WAVER,
    JELLY_CUBE,
    JELLY_TREE,
    HINGES,
    CUBES,
  }
  local help = {
    "[ 1 ] Standard",
    "[ 2 ] Two Tables",
    "[ 3 ] Flag Waver",
    "[ 4 ] Jelly Cube",
    "[ 5 ] Jelly Tree",
    "[ 6 ] Hinges",
    "[ 7 ] Cubes",
    "",
    "[ESC] Exit",
  }
  setHelp(help)
  hideConsole()
  showHelpUser()
end

----LOOP----Does nothing
function MENU.update()
end

----KEY_DOWN----Checks the keyboard and starts demos
function MENU.keyDown(key)
  local theKey = key-string.byte("0")
  if theKey >= 1 and theKey <= table.getn(demos) then
    releaseKey(theKey)
    local DEMO = demos[theKey]
    setScene(Scene(DEMO.init,DEMO.update,DEMO.final,DEMO.keyDown))
  end
end

----FINALIZATION----None
function MENU.final()
  demos = nil
end

----SCENE SETUP----
setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
