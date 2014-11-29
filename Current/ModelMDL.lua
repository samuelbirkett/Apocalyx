----MDL Model
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  rotateView = true
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,0.25*32,1000*32)
  enableFog(200*32, 99/256,104/256,107/256)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,0.5*32,-7*32)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack3.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack3.dat' not found.")
  end
  local zip = Zip("DemoPack3.dat")
  local skyTxt = {
    zip:getTexture("left4.jpg"),
    zip:getTexture("front4.jpg"),
    zip:getTexture("right4.jpg"),
    zip:getTexture("back4.jpg"),
    zip:getTexture("top4.jpg"),
    zip:getTexture("bottom4.jpg")
  }
  local sky = Sky(skyTxt)
  sky:rotStanding(3.1415)
  setBackground(sky)
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, -0.9659,
    zip:getTexture("lensflares.png"),
    5, 0.2
  )
  sun:setColor(0.855,0.475,0.298);
  setSun(sun)
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(1,1,1)
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(zip:getTexture("snow4.jpg",1))
  local ground = FlatTerrain(terrainMaterial,500*32,125)
  ground:setShadowed()
  ground:setShadowOffset(0.01*32)
  setTerrain(ground)
  terrainMaterial:delete()
  ----MODELS----
  models = {}
  local modelsCount = 1
  animation = 0
  local model = MDLModel("models-data/platoon.mdl")
  --
  model:move(0.5*32,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,0)
  model:setBodyGroup(2,0)
  model:setBodyGroup(3,0)
  model:setSequence(0)
  addObject(model)
  local shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  --
  model = model:clone()
  model:move(1.5*32,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,1)
  model:setBodyGroup(2,1)
  model:setBodyGroup(3,1)
  model:setSequence(1)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  --
  model = model:clone()
  model:move(2.5*32,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,2)
  model:setBodyGroup(2,2)
  model:setBodyGroup(3,2)
  model:setSequence(2)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  --
  model = model:clone()
  model:move(3.5*32,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,3)
  model:setBodyGroup(2,3)
  model:setBodyGroup(3,0)
  model:setSequence(0)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  --
  model = model:clone()
  model:move(-0.5*32,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,4)
  model:setBodyGroup(2,0)
  model:setBodyGroup(3,1)
  model:setSequence(1)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  --
  model = model:clone()
  model:move(-1.5*32,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,5)
  model:setBodyGroup(2,1)
  model:setBodyGroup(3,2)
  model:setSequence(0)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  --
  model = model:clone()
  model:move(-2.5*32,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,6)
  model:setBodyGroup(2,2)
  model:setBodyGroup(3,0)
  model:setSequence(2)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  --
  model = model:clone()
  model:move(-3.5*32,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,7)
  model:setBodyGroup(2,3)
  model:setBodyGroup(3,1)
  model:setSequence(1)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  --
  model = MDLModel("models-data/osprey.mdl")
  model:move(0,2*32,15*32)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(40*32)
  model:setController(0,0)
  model:setSequence(0)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  models[modelsCount] = model
  modelsCount = modelsCount+1
  ----HELP----
  local help = {
    "The model of this tutorial was included in",
    "  Half-Life: Opposing Force",
    " Do not use in commercial products!",
    " ",
    "[  MOUSE  ] Look around",
    "[ UP/DOWN ] Move Forward/Back",
    "[PREV/NEXT] Raise/Lower View",
    "[  Z key  ] Change Animations",
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
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local fwdSpeed = 0
  local rotSpeed = 0
  ----MODELS----
  for ct = 1, #models do
    models[ct]:advanceFrame(timeStep)
  end
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = 0.13*timeStep
    camera:rotAround(rotAngle)
    local posX,posY,posZ = models[1]:getPosition()
    camera:pointTo(posX,posY+1*32,posZ)
  end
  ----MOVE CAMERA (KEYBOARD)----
  local moveSpeed = 15*32
  local climbSpeed = 15*32
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(moveSpeed*timeStep)
  elseif isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-moveSpeed*timeStep)
  elseif isKeyPressed(37) then --> VK_LEFT
    camera:rotStanding(0.4*timeStep)
  elseif isKeyPressed(39) then --> VK_RIGHT
    camera:rotStanding(-0.4*timeStep)
  elseif isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  elseif isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
    local posX,posY,posZ = camera:getPosition()
    if posY < 0.5*32 then
      camera:setPosition(posX,0.5*32,posZ)
    end
  end
  ----MOVE CAMERA (MOUSE)----
  if not rotateView then
    local dx, dy = getMouseMove()
    local changeStep = 0.15*timeStep;
    if dx ~= 0 then
      camera:rotStanding(-dx*changeStep)
    end
    if dy ~= 0 then
      camera:pitch(-dy*changeStep)
    end
  end
end

----FINALIZATION----
function final()
  ----DELETE GLOBALS----
  rotateView = nil
  animation = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----KEYBOARD----
function keyDown(key)
  if key == string.byte(" ") then
    releaseKey(string.byte(" "))
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  end
  if key == string.byte("Z") then
    releaseKey(string.byte("Z"))
    animation = animation+1
    if animation >= 33 then ---> MAX_ANIMATIONS
      animation = 0
    end
    models[1]:setSequence(animation)
  end
  ----LOAD MAIN MENU----
  if key == string.byte("\r") then
    releaseKey(string.byte("\r"))
    if fileExists("main.lua") then
      final()
      dofile("main.lua")
    end
    return
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
