----GRAPHIC TO TEXTURE DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----GLOBALS----
  windSpeed = 4
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.5,3000)
  enableFog(1000, .4,.4,1)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
  camera:rotStanding(3.1415)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack1.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack1.dat' not found.")
  end
  local zip = Zip("DemoPack1.dat")
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
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(.7,.7,.7)
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(zip:getTexture("marble.jpg",1))
  local terrain = FlatTerrain(terrainMaterial,3000,300)
  terrain:setReflective()
  setTerrain(terrain)
  terrainMaterial:delete()
  ----UNDERLAY----
  drawTime = 0
  graphicImage = gd.createTrueColor(256,256)
  graphicTexture = GraphicTexture(graphicImage)
  addToUnderlay(graphicTexture)
  ----MODEL----
  local model = zip:getMD2Model("pknight.md2","pknight.jpg")
  model:rescale(0.04)
  model:rotStanding(-1.5708)
  model:pitch(-1.5708)
  model:move(1,1,0)
  model:setAnimation(0)
  addObject(model)
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
  local flagMaterial = Material()
  flagMaterial:setAmbient(0.7,0.7,0.7)
  flagMaterial:setDiffuse(1,1,1)
  flagMaterial:setDiffuseTexture(graphicTexture) -- graphicTexture
  flagMaterial:setEnvironmentTexture(zip:getTexture("environ.jpg"),.333)
  local mesh = flag:getMesh()
  mesh:setMaterial(flagMaterial)
  mesh:setTransparent()
  addObject(mesh)
  flagMaterial:delete()
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
    "[ZXCVB] Relaxation 1-16",
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
  local simTime = timeStep;
  if simTime > 0.1 then
    simTime = 0.1
  end
  simulator:runStep(simTime)
  ----GRAPHIC TEXTURE
  drawTime = drawTime+timeStep
  if drawTime > 0.05 then
    drawTime = 0
    local x1, y1 = math.random(0,254), math.random(0,254)
    local x2, y2 = math.random(x1+1,255), math.random(y1+1,255)
    local r, g, b = math.random(0,255), math.random(0,255), math.random(0,255)
    local a= math.random(0,255)
    local color = r+256*(g+256*(b+256*a))
    graphicImage:filledRectangle(x1,y1,x2,y2,color)
    graphicTexture:setFrozen(false)
  else
    graphicTexture:setFrozen(true)
  end
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
      windSpeed = ct
      clothEnvironment:setWind(windSpeed,0,-windSpeed)
      break
    end
  end
  ----RELAXATION CYCLES----
  if isKeyPressed(string.byte("Z")) then
    releaseKey(string.byte("Z"))
    flag:setRelaxationCycles(1)
  elseif isKeyPressed(string.byte("X")) then
    releaseKey(string.byte("X"))
    flag:setRelaxationCycles(2)
  elseif isKeyPressed(string.byte("C")) then
    releaseKey(string.byte("C"))
    flag:setRelaxationCycles(4)
  elseif isKeyPressed(string.byte("V")) then
    releaseKey(string.byte("V"))
    flag:setRelaxationCycles(8)
  elseif isKeyPressed(string.byte("B")) then
    releaseKey(string.byte("B"))
    flag:setRelaxationCycles(16)
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
  graphicTexture = nil
  graphicImage = nil
  drawTime = nil
  flag = nil
  if clothEnvironment then
    clothEnvironment:delete()
    clothEnvironment = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  windSpeed = nil
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
  emptyUnderlay()
  empty()
end

----SCENE SETUP----
setScene(Scene(init,update,final))

