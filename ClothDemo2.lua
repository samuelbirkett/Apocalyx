----CLOTH DEMO 2
----A simulator of cloths
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----GLOBALS----
  windSpeed = 1
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.5,3000)
  enableFog(1000, .4,.4,1)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.6,6)
  camera:rotStanding(3.1415)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack0.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack0.dat' not found.")
  end
  local zip = Zip("DemoPack0.dat")
  local skyTxt = {
    zip:getTexture("SkyboxTop.jpg"),
    zip:getTexture("SkyboxLeft.jpg"),
    zip:getTexture("SkyboxFront.jpg"),
    zip:getTexture("SkyboxRight.jpg"),
    zip:getTexture("SkyboxBack.jpg")
  }
  local sky = MirroredSky(skyTxt)
  setBackground(sky);
  ----MUSIC----
  soundTrack = zip:getMusic("sympho.mid")
  soundTrack:setVolume(255)
  soundTrack:setLooping(1)
  soundTrack:play()
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.41, 0.91,
    zip:getTexture("lensflares.png"),
    4, 0.2
  )
  setSun(sun)
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(.7,.7,.7)
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(zip:getTexture("marble.jpg",1))
  local terrain = FlatTerrain(terrainMaterial,3000,300)
  terrain:setReflective()
  setTerrain(terrain)
  terrainMaterial:delete()
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
  tableClothMaterial:delete()
  local mesh = foulard:getMesh()
  mesh:setMaterial(foulardMaterial)
  addObject(mesh)
  foulardMaterial:delete()
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[LEFT ] Rotate Left",
    "[RIGHT] Rotate Right",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[ 0-9 ] Wind Speed",
    "[SPACE] On/Off Rotation",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  showHelpUser()
  hideConsole()
  ----DELETE ZIP----
  zip:delete()
end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local simTime = timeStep;
  if(simTime > 0.1) then
    simTime = 0.1
  end
  simulator:runStep(simTime)
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
  ----WIND SPEED----
  local asciiBase = string.byte("0")
  for ct = 0, 9 do
    if isKeyPressed(asciiBase+ct) then
      releaseKey(asciiBase+ct)
      windSpeed = ct/2
      clothEnvironment1:setWind(windSpeed,0,-windSpeed)
      clothEnvironment2:setWind(windSpeed,0,-windSpeed)
      clothEnvironment3:setWind(windSpeed,0,-windSpeed)
      break
    end
  end
  ----MOVE CAMERA (KEYBOARD)----
  local speed = 3
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
  local climbSpeed = 3
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

