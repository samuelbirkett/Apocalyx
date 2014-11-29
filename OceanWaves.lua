----OCEAN WAVES DEMO
----A simulator of ocean waves using FFT techniques
----Questions? Contact: leo <tetractys@users.sf.net>

----SUPPORT FUNCTION----Create an isle
function generateIsle(
  zip, terrainTextureName, detailedTexture, detailRepeat, heightFieldName,
  waterLevel, width, depth, height, x, y, treesCount, treesMaterial,
  minTreesHeight
)
  ----LOAD IMAGES AND CREATE TEXTURES----
  local terrainImage = zip:getImage(terrainTextureName)
  local heightImage = zip:getImage(heightFieldName)
  terrainImage:addAlpha(heightImage,64,9)
  local terrainTexture = Texture(terrainImage)
  terrainImage:delete()
  ----TERRAIN MATERIAL----
  local terrainMaterial = Material()
  terrainMaterial:setDiffuse(1,1,1)
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
  trees:move(x,treesSize*.4-waterLevel,y)
  addObject(trees)
  return isle, trees
end

----INITIALIZATION----
function init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.5,3000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,25,150)
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
  local sky = HalfSky(skyTxt)
  sky:setGroundColor(.5,.5,.75)
  setBackground(sky)
  enableFog(750, .5,.5,.75)
  ----MUSIC----
  soundTrack = zip:getMusic("sympho.mid")
  soundTrack:setVolume(255)
  soundTrack:setLooping(1)
  soundTrack:play()
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0,.41,.91,
    zip:getTexture("lensflares.png"),
    4, 0.2
  )
  setSun(sun)
  ----WATER MATERIAL----
  local waterImages = {
    zip:getImage("water00.png"),
    zip:getImage("water01.png"),
    zip:getImage("water02.png"),
    zip:getImage("water03.png"),
    zip:getImage("water04.png"),
    zip:getImage("water05.png"),
    zip:getImage("water06.png"),
    zip:getImage("water07.png"),
    zip:getImage("water08.png"),
    zip:getImage("water09.png"),
    zip:getImage("water10.png"),
    zip:getImage("water11.png"),
    zip:getImage("water12.png"),
    zip:getImage("water13.png"),
    zip:getImage("water14.png"),
    zip:getImage("water15.png")
  }
  local waterTexture = AnimatedTexture(waterImages,1.5,1)
  for ct = 1, 16 do
    waterImages[ct]:delete()
  end
  local waterMaterial = Material()
  waterMaterial:setAmbient(0.75,0.75,1)
  waterMaterial:setDiffuse(0.75,0.75,1)
  waterMaterial:setSpecular(1,1,1)
  waterMaterial:setShininess(64)
  waterMaterial:setDiffuseTexture(waterTexture)
  ----OCEAN----
  local waveAmplitude = 0.000025
  local waveDisplacement = 3
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
  waterTexture:delete()
  ----GENERATE ISLE----
  local detailedTexture = zip:getTexture("detail.jpg",1)
  local treesMaterial = Material()
  treesMaterial:setAmbient(1,1,1)
  treesMaterial:setDiffuse(1,1,1)
  treesMaterial:setDiffuseTexture(zip:getTexture("trees2.png"));
  local isle, trees = generateIsle(
    zip,"smallTerrain.jpg",detailedTexture,8,"terrain2.png",15,
    150,150,40,0,0,32,treesMaterial,35
  )
  treesMaterial:delete()
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
  local speed = 25;
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
  local climbSpeed = 25
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