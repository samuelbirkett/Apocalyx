----MD3 MODEL LOADING Tutorial
----A loader of "pure" MD3 models
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----SOME GLOBALS----
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, .522,.373,.298)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-3)
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
  local skyBackground = MirroredSky(skyTxt)
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
  terrainMaterial:delete()
  setTerrain(ground)
  ----MODELS----
  torso = 11  ---> TORSO_STAND
  legs = 15   ---> LEGS_IDLE
  weapon = zip:getModel("gun.md3","gun.jpg")
  weapon:rescale(0.04)
  avatar = zip:getBot("warrior.mdl",1)
  avatar:rescale(0.04)
  avatar:pitch(-1.5708)
  avatar:rotStanding(1.5708)
  avatar:move(0,1,0)
  avatar:getUpper():link("tag_weapon",weapon)
  avatar:setUpperAnimation(torso)
  avatar:setLowerAnimation(legs)
  addObject(avatar)
  local shadow = Shadow(avatar)
  addShadow(shadow)
  ----HELP----
  local help = {
    "The model of this tutorial was made by:",
    "  ALPHAwolf <ALPHAwolf@Planatquake.com>",
    "The weapon of this tutorial was made by:",
    "  Janus <janus@planetquake.com>",
    " ",
    "[  MOUSE  ] Look around",
    "[ UP/DOWN ] Move Forward/Back",
    "[PREV/NEXT] Raise/Lower View",
    "[  Z key  ] Change Torso Animation",
    "[  X key  ] Change Legs Animation",
    "[  C key  ] Death Animation",
    "[ Q,W,E,R ] Rotate/Bend Head",
    "[ A,S,D,F ] Rotate/Bend Torso",
    "[  SPACE  ] Rotate Scene",
    " ",
    "[ENTER] Main Menu",
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
  if legs == 6 then  ---> LEGS_WALKCR
    fwdSpeed = 2.5
    rotSpeed = 0.31415
  elseif legs == 7 then ---> LEGS_WALK
    fwdSpeed = 2.5
    rotSpeed = 0.6283
  elseif legs == 8 then ---> LEGS_RUN
    fwdSpeed = 5
    rotSpeed = 0.6283
  elseif legs == 9 then ---> LEGS_BACK
    fwdSpeed = -3.5
    rotSpeed = 0.31415
  elseif legs == 10 then ---> LEGS_SWIM
    fwdSpeed = 2.5
    rotSpeed = 0.31415
  elseif legs == 17 then ---> LEGS_TURN
    rotSpeed = 1.5708
  end
  avatar:walk(fwdSpeed*timeStep);
  avatar:rotStanding(rotSpeed*timeStep);
  local stopped = avatar:getLower():getStoppedAnimation()
  if stopped == 11 then ---> LEGS_JUMP
    avatar:setLowerAnimation(12) ---> LEGS_LAND
    legs = 12
  elseif stopped == 13 then ---> LEGS_JUMPB
    avatar:setLowerAnimation(14) ---> LEGS_LANDB
    legs = 14
  end
  stopped = avatar:getUpper():getStoppedAnimation()
  if stopped >= 6 then ---> TORSO_GESTURE
    avatar:setUpperAnimation(11) ---> TORSO_STAND
  end
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
    local posX,posY,posZ = avatar:getPosition()
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
  ----MODEL MOVEMENT----
  if isKeyPressed(string.byte("D")) then
    local angle = 3.1415*timeStep
    avatar:getUpper():addPitchAngle(angle,0.7854,-0.5236)
  elseif isKeyPressed(string.byte("F")) then
    local angle = -3.1415*timeStep
    avatar:getUpper():addPitchAngle(angle,0.7854,-0.5236)
  elseif isKeyPressed(string.byte("A")) then
    local angle = 3.1415*timeStep
    avatar:getUpper():addYawAngle(angle,1.5708)
  elseif isKeyPressed(string.byte("S")) then
    local angle = -3.1415*timeStep
    avatar:getUpper():addYawAngle(angle,1.5708)
  elseif isKeyPressed(string.byte("E")) then
    local angle = 3.1415*timeStep
    avatar:getHead():addPitchAngle(angle,0.7854)
  elseif isKeyPressed(string.byte("R")) then
    local angle = -3.1415*timeStep
    avatar:getHead():addPitchAngle(angle,0.7854)
  elseif isKeyPressed(string.byte("Q")) then
    local angle = 3.1415*timeStep
    avatar:getHead():addYawAngle(angle,1.5708)
  elseif isKeyPressed(string.byte("W")) then
    local angle = -3.1415*timeStep
    avatar:getHead():addYawAngle(angle,1.5708)
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
  torso = nil
  legs = nil
  ----EMPTY WORLD----
  sun = nil
  avatar = nil
  if weapon then
    weapon:delete()
    weapon = nil
  end
  disableFog()
  empty()
  end

----KEYBOARD----
function keyDown(key)
  if key == 32 then --> SPACE
    releaseKey(32)
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  end
  ----VARIOUS SCENE MODIFIERS----
  if key == string.byte("Z") then
    releaseKey(string.byte("Z"))
    if(torso >= 6) then ---> TORSO_GESTURE
      torso = torso+1
    else
      legs = 15  ---> LEGS_IDLE
      avatar:setLowerAnimation(legs)
      torso = 11  ---> TORSO_STAND
    end
    if torso >= 13 then ---> MAX_TORSO_ANIMATIONS
      torso = 6 ---> TORSO_GESTURE
    end
    avatar:setUpperAnimation(torso)
  elseif key == string.byte("X") then
    releaseKey(string.byte("X"))
    if(legs >= 6) then ---> LEGS_WALKCR
      legs = legs+1
    else
      torso = 11  ---> TORSO_STAND
      avatar:setUpperAnimation(torso)
      legs = 15  ---> LEGS_IDLE
    end
    if legs >= 18 then ---> MAX_LEGS_ANIMATIONS
      legs = 6 ---> LEGS_WALKCR
    end
    avatar:setLowerAnimation(legs)
  elseif key == string.byte("C") then
    releaseKey(string.byte("C"))
    if legs < 4 then ---> LEGS_DEAD3
      torso = torso+2
      legs = legs+2
    else
      torso = 0 ---> BOTH_DEATH1
      legs = 0 ---> BOTH_DEATH1
    end
    avatar:setLowerAnimation(legs)
    avatar:setUpperAnimation(torso)
  end
  ----LOAD MAIN MENU----
  if key == 13 then
    releaseKey(13)
    if fileExists("main.lua") then
      final()
      dofile("main.lua")
    end
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
