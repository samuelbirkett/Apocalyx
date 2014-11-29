----MS3D Model
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  rotateView = true
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, .522,.373,.298)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack2.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack2.dat' not found.")
  end
  local zip = Zip("DemoPack2.dat")
  local skyTxt = {
    zip:getTexture("left3.jpg"),
    zip:getTexture("front3.jpg"),
    zip:getTexture("right3.jpg"),
    zip:getTexture("back3.jpg"),
    zip:getTexture("top3.jpg"),
    zip:getTexture("bottom3.jpg")
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
  terrainMaterial:setDiffuseTexture(zip:getTexture("desert.jpg",1))
  local ground = FlatTerrain(terrainMaterial,500,125)
  ground:setShadowed()
  ground:setShadowOffset(0.01)
  setTerrain(ground)
  terrainMaterial:delete()
  ----MODELS----
  local anims = {
      2, 13, true, ---> WALK
     16, 25, true, ---> RUN
     27, 39, false, ---> JUMP
     41, 53, false, ---> JUMP ON THE SPOT
     55, 58, false, ---> CROUCH DOWN
     59, 68, true, ---> STAY CROUCHED
     69, 73, false, ---> GET UP
     74, 87, true, ---> BATTLE IDLE 1
     89,109, true, ---> BATTLE IDLE 2
    111,125, false, ---> ATTACK 1 - SWIPE AXE
    127,141, false, ---> ATTACK 2 - JUMP AND OVERHEAD WHACK ATTACK
    143,159, false, ---> ATTACK 3 - 360 SPIN BACK HANDER
    161, 179, false, ---> ATTACK 4 - 2 SWIPES LEFT AND RIGHT
    181,191, false, ---> ATTACK 5 - STAB
    193,209, false, ---> BLOCK
    211,226, false, ---> DIE 1 - FORWARDS
    229,250, false, ---> DIE 2 - BACKWARDS
    252,271, true, ---> NOD YES
    273,289, true, ---> SHAKE HEAD NO
    291,324, true, ---> IDLE 1
    326,359, true ---> IDLE 2
  }
  animation = 20
  model = MS3DModel("models-data/dwarf2.ms3d")
  model:scale(1/25.0)
  model:setScaled()
  model:setMaxRadius(2)
  model:move(0,0,0)
  model:setAnimations(anims)
  model:setAnimation(animation)
  model:setTimeScale(0.333)
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
  if key == string.byte("Z") then
    releaseKey(string.byte("Z"))
    animation = animation+1
    if animation == 3 then  ---> JUMP ON THE SPOT
      animation = 4  ---> CROUCH DOWN
    elseif animation == 5 then ---> STAY CROUCHED
      animation = 6 ---> GET UP
    elseif animation >= 21 then ---> MAX_ANIMATIONS
      animation = 0
    end
    model:setAnimation(animation)
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
