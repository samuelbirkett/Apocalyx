----MDL Model
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  rotateView = true
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,0.25*16,1000*16)
  enableFog(200*16, 0.475,0.431,0.451)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(-16*16,6*16,0)
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
  local ground = FlatTerrain(terrainMaterial,500*16,125)
  ground:setShadowed()
  ground:setShadowOffset(0.01*16)
  setTerrain(ground)
  terrainMaterial:delete()
  ----ANIMATIONS----
  anim = -1
  anims = {
    34, 2.0, 1, 2.0, 35, 3.0, 36, 3.0, 35, 3.0, 1, 2.0, 34, 2.0, 6, -99,
    41, 2.0, 42, -99, 43, -99, 42, -99, 43, -99, 42, -99, 44, -99,
    8, 3.0, 9, -99, 34, 1.0, 17, -99, 34, 2.0, 37, 1.0, 38, -99, 39, -99,
    38, -99, 39, -99, 38, -99, 40, -99, 34, 1.0, 18, -99, 34, 1.0,
    45, 1.0, 46, 2.0, 47, 3.0, 46, 2.0, 45, 1.0, 48, -99, 6, -99, 49, 1.0,
    50, -99, 49, 1.0, 9, -99, 34, 1.0,
    45, 1.0, 46, 2.0, 47, 6.0, 46, 2.0, 45, 1.0,
    51, 2.0, 52, -99, 53, 2.0, 54, -99, 34, 1.0, 6, -99, 55, 2.0, 56,
    -99, 57, 2.0, 58, -99, 41, 1.0, 9, -99,
  }
  speed = 0
  height = 37
  rotSpeed = 0
  countdown = 0
  animStopped = -1
  local MODELS_ROW = 4
  local MODELS_ROW2 = MODELS_ROW*MODELS_ROW
  MAX_MODELS = MODELS_ROW2*2
  ----MODELS----
  models = {}
  local model = MDLModel("models-data/british.mdl")
  for x = 1, MODELS_ROW do
    for y = 1, MODELS_ROW do
      local m = model:clone()
      models[(x-1)*MODELS_ROW+y] = m
      m:move(8*(x-1)*16+4*16,37,8*(y-1)*16-20*16)
      m:pitch(-1.5708)
      m:rotStanding(1.5708)
      m:setMaxRadius(8*16)
      m:setSequence(1)
      m:setBodyGroup(0,0)
      m:setBodyGroup(1,0)
      m:setBodyGroup(2,0)
      m:setBodyGroup(3,math.random()*7)
      m:setBodyGroup(4,0)
      m:setSkin(math.random()*4)
      addObject(m)
      local shadow
      shadow = Shadow(m)
      shadow:setMaxRadius(m:getMaxRadius()*3)
      addShadow(shadow)
    end
  end
  model:delete()
  local model = MDLModel("models-data/german.mdl")
  for x = 1, MODELS_ROW do
    for y = 1, MODELS_ROW do
      local m = model:clone()
      models[(x-1)*MODELS_ROW+y+MODELS_ROW2] = m
      m:move(8*(x-1)*16+8*16,37,8*(y-1)*16-16*16)
      m:pitch(-1.5708)
      m:rotStanding(1.5708)
      m:setMaxRadius(8*16)
      m:setSequence(1)
      m:setBodyGroup(0,0)
      m:setBodyGroup(1,0)
      m:setBodyGroup(2,0)
      m:setBodyGroup(3,math.random()*7)
      m:setBodyGroup(4,0)
      m:setSkin(math.random()*4)
      addObject(m)
      local shadow
      shadow = Shadow(m)
      shadow:setMaxRadius(m:getMaxRadius()*3)
      addShadow(shadow)
    end
  end
  model:delete()
  ----HELP----
  local help = {
    "MDL model from",
    "\"The Trenches\" MOD",
    "(Half-Life 1)",
    " ",
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
  if timeStep > 0.1 then timeStep = 0.1 end
  ----ANIMATIONS----
  local changedAnim = false
  animStopped = models[1]:getStoppedSequence()
  if countdown ~= -99 then
    countdown = countdown-timeStep
    if countdown <= 0 then
      changedAnim = true
    end
  elseif animStopped >= 0 then
    changedAnim = true
    if animStopped == 18 then
      for ct = 1, MAX_MODELS do
        local m = models[ct]
        m:setBodyGroup(1,0)
      end
    elseif animStopped == 17 then
      for ct = 1, MAX_MODELS do
        local m = models[ct]
        m:setBodyGroup(1,1)
      end
    elseif animStopped == 54 or animStopped == 58 then
      for ct = 1, MAX_MODELS do
        local m = models[ct]
        m:setBodyGroup(2,0)
      end    
    end
  end
  if changedAnim then
    anim = anim+2
    if anim > #anims then
      anim = 1
    end
    local a = anims[anim]
    countdown = anims[anim+1]
    local looping
    if countdown == -99 then
      looping = false
    else
      looping = true
    end
    if
      a == 34 or a == 6 or a == 7 or a == 9 or a == 10 or
      a == 37 or a == 38 or a == 39 or a == 40 or
      a == 45 or a == 48 or
      a == 52 or a == 53 or a == 54
    then
    ---> rfl_idle | go_prone | prone | get_up | jump |
    ---> rfl_aim | rfl_fire | rfl_cock | rfl_reload |
    ---> mle_idle | mle_stab  |
    ---> grn_prime | grn_primed | grn_throw
      speed = 0
      rotSpeed = 0
      height = 37
    elseif a == 51 then ---> grn_idle
      for ct = 1, MAX_MODELS do
        local m = models[ct]
        m:setBodyGroup(2,1)
      end    
      speed = 0
      rotSpeed = 0
      height = 37
    elseif a == 1 then ---> sneak
      speed = 2*16
      rotSpeed = 0.4
      height = 37
    elseif a == 2 or a == 35 or a == 46 then ---> run
      speed = 5*16
      rotSpeed = 0.4
      height = 37
    elseif a == 3 or a == 36 or a == 47 then ---> sprint
      speed = 8*16
      rotSpeed = 0.4
      height = 37
    elseif a == 8 then ---> crawl
      speed = 1*16
      rotSpeed = 0.4
      height = 12
    elseif a == 49 or a == 50 then
    ---> mle_prone | prone_stab
      speed = 0
      rotSpeed = 0
      height = 37
    elseif a == 56 or a == 57 or a == 58 then
    ---> prone_prime | prome_primed | prone_throw
      speed = 0
      rotSpeed = 0
      height = 37
    elseif a == 55 then ---> prone_idle (grn)
      for ct = 1, MAX_MODELS do
        local m = models[ct]
        m:setBodyGroup(2,1)
      end    
      speed = 0
      rotSpeed = 0
      height = 37
    elseif a == 42 or a == 43 then
    ---> prone_fire | prone_cock
      speed = 0
      rotSpeed = 0
      height = 23
    elseif a == 44 or a == 41 then
    ---> prone_reload | prone_idle
      speed = 0
      rotSpeed = 0
      height = 9
    elseif a == 17 then ---> mask_on
      for ct = 1, MAX_MODELS do
        local m = models[ct]
        m:setBodyGroup(1,2)
      end        
      speed = 0
      rotSpeed = 0
      height = 37
    elseif a == 18 then ---> mask_off
      for ct = 1, MAX_MODELS do
        local m = models[ct]
        m:setBodyGroup(1,2)
      end        
      speed = 0
      rotSpeed = 0
      height = 37
    end
    for ct = 1, MAX_MODELS do
      local m = models[ct]
      m:setSequence(a,looping)
      local x,y,z = m:getPosition()
      m:setPosition(x,height,z)
    end    
  end
  ----MODEL----
  for ct = 1, MAX_MODELS do
    local m = models[ct]
    m:advanceFrame(timeStep)
    if speed ~= 0 then
      local step = speed*timeStep
      local vx,vy,vz = m:getSideDirection()
      vx,vy,vz = step*vx,step*vy,step*vz
      m:move(vx,vy,vz)
    end
    if rotSpeed ~= 0 then
      m:rotStanding(timeStep*rotSpeed)
    end
  end
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = 0.13*timeStep
    camera:rotAround(rotAngle)
    local x,y,z = models[1]:getPosition()
    camera:pointTo(x,37,z)
  end
  ----MOVE CAMERA (KEYBOARD)----
  local moveSpeed = 10*16
  local climbSpeed = 10*16
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(moveSpeed*timeStep)
  elseif isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-moveSpeed*timeStep)
  elseif isKeyPressed(37) then --> VK_LEFT
    camera:rotStanding(0.8*timeStep)
  elseif isKeyPressed(39) then --> VK_RIGHT
    camera:rotStanding(-0.8*timeStep)
  elseif isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  elseif isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
    local posX,posY,posZ = camera:getPosition()
    if posY < 0.5*16 then
      camera:setPosition(posX,0.5*16,posZ)
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
  anim = nil
  anims = nil
  models = nil
  speed = nil
  height = nil
  rotSpeed = nil
  countdown = nil
  rotateView = nil
  animStopped = nil
  MAX_MODELS = nil
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
