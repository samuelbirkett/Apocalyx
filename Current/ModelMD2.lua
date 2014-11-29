----MD2 Model
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, .522,.373,.298)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
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
  skyBackground = MirroredSky(skyTxt)
  skyBackground:rotStanding(3.1415)
  setBackground(skyBackground)
  ----SUN----
  sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, -0.9659,
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
  local ground = FlatTerrain(terrainMaterial,500,125)
  ground:setReflective()
  ground:setShadowed()
  ground:setShadowOffset(0.01)
  setTerrain(ground)
  terrainMaterial:delete()
  ----MODELS----
  animation = 0
  weapon = zip:getBasicModel("ogroweapon.md2","ogroweapon.jpg")
  weapon:rescale(0.04)
  weapon:pitch(-1.5708)
  weapon:rotStanding(1.5708)
  weapon:move(0,1,0)
  weapon:setAnimation(animation)
  addObject(weapon)
  local shadow = Shadow(weapon)
  shadow:setMaxRadius(weapon:getMaxRadius()*3)
  addShadow(shadow)
  model = zip:getBasicModel("ogro.md2","ogro.jpg")
  model:rescale(0.04)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:move(0,1,0)
  model:setAnimation(animation)
  addObject(model)
  shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  ----HELP----
  local help = {
    "The model of this tutorial was made by:",
    "  Magarnigal <mellor@netgazer.net.au>",
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
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
    local posX,posY,posZ = model:getPosition()
    camera:pointTo(posX,posY+1,posZ)
  end
  ----MOVE CAMERA (KEYBOARD)----
  local moveSpeed = 15
  local climbSpeed = 15
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
    if posY < 0.5 then
      camera:setPosition(posX,0.5,posZ)
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
  sun = nil
  ground = nil
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
    if animation >= 20 then ---> MAX_ANIMATIONS
      animation = 0
    end
    model:setAnimation(animation)
    weapon:setAnimation(animation)
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
