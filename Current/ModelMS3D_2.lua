----MS3D Model
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  rotateView = true
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, 99/256,104/256,107/256)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
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
  local ground = FlatTerrain(terrainMaterial,500,125)
  ground:setShadowed()
  ground:setShadowOffset(0.01)
  setTerrain(ground)
  terrainMaterial:delete()
  ----MODELS----
  local anims = {
      1, 51, true, ---> WALK
  }
  animation = 0
  model = MS3DModel("models-data/penguin.ms3d")
  model:rotStanding(3.1415)
  model:scale(1/25)
  model:setScaled()
  model:setMaxRadius(2)
  model:move(0,0,0)
  model:setAnimations(anims)
  model:setAnimation(animation)
  model:setTimeScale(0.5)
  addObject(model)
  local shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  ----HELP----
  local help = {
    "The model of this tutorial was made by:",
    "  Psionic <http://www.psionicdesign.com>",
    " ",
    "[  MOUSE  ] Look around",
    "[ UP/DOWN ] Move Forward/Back",
    "[PREV/NEXT] Raise/Lower View",
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
  --- MODEL ---
  local stopped = model:getStoppedAnimation()
  if stopped >= 0 then
    if stopped == 4 then ---> CROUCH DOWN
      model:setAnimation(5) ---> STAY CROUCHED
    elseif stopped ~= 15 and stopped ~= 16 then ---> other
      model:setAnimation(20) ---> IDLE 2
    end
  end
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
