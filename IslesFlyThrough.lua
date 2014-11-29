----ISLES FLY-THROUGHT
----A "next to come" flight-simulator
----Questions? Contact:leo <tetractys@users.sf.net>

----SUPPORT FUNCTION----Generate Trees Material
function generateTreesMaterial(zip, fileName)
  local treesMaterial = Material()
  treesMaterial:setAmbient(1,1,1)
  treesMaterial:setDiffuse(1,1,1)
  treesMaterial:setDiffuseTexture(zip:getTexture(fileName));
  return treesMaterial
end

----SUPPORT FUNCTION----Generate Isle
function generateIsle(
  zip, terrainTextureName, detailedTexture, detailRepeat, heightFieldName,
  waterLevel, width, depth, height, x, y, treesCount, treesMaterial,
  minTreesHeight
)
  ----LOAD IMAGES AND CREATE TEXTURES----
  local terrainImage = zip:getImage(terrainTextureName)
  local heightImage = zip:getImage(heightFieldName)
  local terrainTexture = Texture(terrainImage)
  terrainImage:delete()
  ----TERRAIN MATERIAL----
  local terrainMaterial = Material()
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(terrainTexture)
  terrainMaterial:setGlossTexture(detailedTexture)
  ----CREATE HEIGHTFIELD----
  local heightField = HeightField(
    heightImage,terrainMaterial,width,depth,height,waterLevel,8
  )
  heightField:move(x,-waterLevel,y)
  addObject(heightField)
  terrainMaterial:delete()
  terrainTexture:delete()
  ----TREES CREATION----
  local trees = Trees(treesCount,2,treesMaterial,2,0.1)
  local treesSize = 6
  local counter = 0
  while counter < treesCount do
    local xx = math.random()*width-width*0.5
    local yy = math.random()*depth-depth*0.5
    local h = heightField:getHeightAtRelative(xx,yy)
    if h > minTreesHeight then
      counter = counter + 1
      trees:addTree(
        xx,h,yy,treesSize,treesSize,math.mod(counter,4),counter<treesCount*2
      )
    end
  end
  trees:setTransparent()
  trees:move(x,treesSize*.5-waterLevel,y)
  addObject(trees)
  treesMaterial:delete()
  return heightField, trees
end

----SUPPORT FUNCTION----Clone Meshes
function cloneMeshes(meshes)
  local meshesClone = Objects()
  local mesh = meshes:getFirstMesh()
  while mesh do
    meshesClone:add(mesh:clone())
    mesh = meshes:getNextMesh()
  end
  return meshesClone
end

----INITIALIZATION----
function init()
  ----GLOBALS----
  speed = 0
  lastHeight = 0
  ----SET HELP----
  local help = {
    "[MOUSE] Change Direction",
    "[ UP  ] Increase Speed",
    "[DOWN ] Decrease Speed",
    "[LEFT ] Roll Left",
    "[RIGHT] Roll Right",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  showHelpUser()
  hideConsole()
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,0.5,4000)
  enableFog(1000, .4,.4,1)
  local camera = getCamera()
  camera:reset()
  camera:move(650,10,0)
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
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.41, 0.91,
    zip:getTexture("lensflares.png"),
    4, 0.2
  )
  setSun(sun)
  ----WATER MATERIAL----
  local waterImages = {
    zip:getImage("water00.jpg"),
    zip:getImage("water01.jpg"),
    zip:getImage("water02.jpg"),
    zip:getImage("water03.jpg"),
    zip:getImage("water04.jpg"),
    zip:getImage("water05.jpg"),
    zip:getImage("water06.jpg"),
    zip:getImage("water07.jpg"),
    zip:getImage("water08.jpg"),
    zip:getImage("water09.jpg"),
    zip:getImage("water10.jpg"),
    zip:getImage("water11.jpg"),
    zip:getImage("water12.jpg"),
    zip:getImage("water13.jpg"),
    zip:getImage("water14.jpg"),
    zip:getImage("water15.jpg")
  }
  local waterTexture = AnimatedTexture(waterImages,1.5,1)
  for ct = 1, 16 do
    waterImages[ct]:delete()
  end
  local waterMaterial = Material()
  waterMaterial:setAmbient(0.7,0.7,0.7)
  waterMaterial:setDiffuse(0.0,0.5,0.9)
  waterMaterial:setDiffuseTexture(waterTexture)
  ----SEA----
  local sea = FlatTerrain(waterMaterial,3000.0,200,1)
  sea:setReflective()
  setTerrain(sea)
  waterMaterial:delete()
  ----GENERATE ISLES----
  local detailedTexture = zip:getTexture("detail.jpg",1)
  isle1, trees1 = generateIsle(
    zip, ---- ZIP file
    "terrain1.jpg", ---- ground texture
    detailedTexture, ---- detailedTexture
    16, ---- detailedTiles
    "terrain1.png", ---- heightfield map
    4, ---- water level
    256, ---- width
    256, ---- depth
    32, ---- height
    500, ---- position x
    0, ---- position z
    128, ---- trees count
    generateTreesMaterial(zip,"trees1.png"), ---- trees material
    26 ---- trees min height
  )
  isle2, trees2 = generateIsle(
    zip,"terrain2.jpg",detailedTexture,8,"terrain2.png",4,
    256,256,32,1000,500,128,generateTreesMaterial(zip,"trees2.png"),24
  )
  isle3, trees3 = generateIsle(
    zip,"terrain3.jpg",detailedTexture,16,"terrain3.png",4,
    256,256,12,1000,-500,128,generateTreesMaterial(zip,"trees3.png"),4
  )
  ----WIND & WATER SOUND----
  waterSample = zip:getSample("water.wav")
  waterSample:setLooping(1)
  waterSound = waterSample:createSound()
  waterSound:play()
  waterSound:setVolume(255)
  windSample = zip:getSample("wind.wav")
  windSample:setLooping(1)
  windSound = windSample:createSound()
  windSound:play()
  windSound:setVolume(32)
  ----CARRIER----
  local carrier = zip:getMeshes("carrier.3ds")
  carrier:move(600.0,-2.0,300.0)
  carrier:rotStanding(1.5708)
  addObject(carrier)
  alarmSample = zip:getSample3D("alarm.wav");
  alarmSample:setLooping(1)
  alarmSample:setVolume(255)
  alarmSample:setMinDistance(50)
  local source = Source(alarmSample,carrier);
  addSource(source)
  ----AIRPLANES----
  motorSample = zip:getSample3D("motor.wav");
  motorSample:setLooping(1)
  motorSample:setVolume(255)
  motorSample:setMinDistance(25)
  zero1 = zip:getMeshes("zero.3ds")
  zero1:move(600,15,300)
  zero1:rotStanding(1.5708)
  addObject(zero1)
  local sourceZero1 = Source(motorSample,zero1)
  addSource(sourceZero1)
  zero2 = cloneMeshes(zero1)
  zero2:move(625,30,325)
  zero2:rotStanding(1.5708)
  addObject(zero2)
  local sourceZero2 = Source(motorSample,zero2)
  addSource(sourceZero2)
  zero3 = cloneMeshes(zero1)
  zero3:move(615,25,275)
  zero3:rotStanding(1.5708)
  addObject(zero3)
  local sourceZero3 = Source(motorSample,zero3)
  addSource(sourceZero3)
  wild1 = zip:getMeshes("wildcat.3ds")
  wild1:move(400,55,310)
  wild1:rotStanding(1.5708)
  addObject(wild1)
  local sourceWild1 = Source(motorSample,wild1)
  addSource(sourceWild1)
  wild2 = cloneMeshes(wild1)
  wild2:move(450,75,320)
  wild2:rotStanding(1.5708)
  addObject(wild2)
  local sourceWild2 = Source(motorSample,wild2)
  addSource(sourceWild2)
  wild3 = cloneMeshes(wild1)
  wild3:move(425,45,330)
  wild3:rotStanding(1.5708)
  addObject(wild3)
  local sourceWild3 = Source(motorSample,wild3)
  addSource(sourceWild3)
  ----DELETE ZIP----
  zip:delete()
end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  camera:moveForward(speed*timeStep)
  ----MOVE CAMERA (KEYBOARD)----
  if isKeyPressed(38) then --> VK_UP
    speed = speed + 15*timeStep;
    if speed > 75 then
      speed = 75
    end
  end
  if isKeyPressed(40) then --> VK_DOWN
    speed = speed - 15*timeStep;
    if speed < 0 then
      speed = 0
    end
  end
  if isKeyPressed(37) then --> VK_LEFT
    camera:roll(-0.4*timeStep)
  end
  if isKeyPressed(39) then --> VK_RIGHT
    camera:roll(0.4*timeStep)
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
  if dx ~= 0 then
    camera:yaw(-dx*0.15*timeStep)
  end
  if dy ~= 0 then
    camera:pitch(-dy*0.15*timeStep)
  end
  ----CHECK CAMERA HEIGHT----
  local posX, posY, posZ = camera:getPosition()
  if isle1:includes(posX,posY,posZ) then
    local h = isle1:getHeightAtAbsolute(posX,posZ)+5.5
    if posY < h then
      posY = h
      camera:setPosition(posX,posY,posZ)
    end
  elseif isle2:includes(posX,posY,posZ) then
    local h = isle2:getHeightAtAbsolute(posX,posZ)+5.5
    if posY < h then
      posY = h
      camera:setPosition(posX,posY,posZ)
    end
  elseif isle3:includes(posX,posY,posZ) then
    local h = isle3:getHeightAtAbsolute(posX,posZ)+5.5
    if posY < h then
      posY = h
      camera:setPosition(posX,posY,posZ)
    end
  end
  if posY < 5.5 then
    posY = 5.5
    camera:setPosition(posX,posY,posZ)
  elseif posY > 2500 then
    posY = 2500
    camera:setPosition(posX,posY,posZ)
  end
  ----CHANGE SOUNDS ACCORDING TO CAMERA HEIGHT----
  if posY ~= lastHeight then
    lastHeight = posY
    local windVol = lastHeight*5
    if windVol > 255 then
      windVol = 255
    end
    windSound:setVolume(windVol)
    waterSound:setVolume(255-windVol)
  end
  ----MOVE AIRPLANES----
  local airplaneStep = 50*timeStep
  local airplaneAngle = 0.1*timeStep
  zero1:moveForward(airplaneStep)
  zero1:rotStanding(airplaneAngle)
  zero2:moveForward(airplaneStep)
  zero2:rotStanding(airplaneAngle)
  zero3:moveForward(airplaneStep)
  zero3:rotStanding(airplaneAngle)
  wild1:moveForward(airplaneStep)
  wild1:rotStanding(airplaneAngle)
  wild2:moveForward(airplaneStep)
  wild2:rotStanding(airplaneAngle)
  wild3:moveForward(airplaneStep)
  wild3:rotStanding(airplaneAngle)
end

----FINALIZATION----
function final()
  ----DELETE GLOBALS----
  speed = nil
  lastHeight = nil
  isle1 = nil
  isle2 = nil
  isle3 = nil
  trees1 = nil
  trees2 = nil
  trees3 = nil
  zero1 = nil
  zero2 = nil
  zero3 = nil
  wild1 = nil
  wild2 = nil
  wild3 = nil
  if alarmSample then
    alarmSample:delete()
    alarmSample = nil
  end
  if motorSample then
    motorSample:delete()
    motorSample = nil
  end
  if waterSound then
    waterSound:stop()
    waterSound:delete()
    waterSound = nil
    if waterSample then
      waterSample:delete()
      waterSample = nil
    end
  end
  if windSound then
    windSound:stop()
    windSound:delete()
    windSound = nil
    if windSample then
      windSample:delete()
      windSample = nil
    end
  end
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----SCENE SETUP----
setScene(Scene(init,update,final))
