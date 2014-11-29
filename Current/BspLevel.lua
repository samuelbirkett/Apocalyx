----BSP LEVEL DEMO
----A viewer of BSP levels
----Questions? Contact:leo <tetractys@users.sf.net>

------------------
----MENU SCENE----
------------------

----MENU INITIALIZATION----
function MENU_init()
  selectedLevel = -1
  if fileExists("pak0.pk3") then
    if not levelNames then
      local levelsCount = 1
      levelNames = {}
      zip = Zip("pak0.pk3")
      zip:gotoFirstFile()
      repeat
        local fileName = zip:getZippedFileName()
        if string.find(fileName,".bsp",1,1) then
          levelNames[levelsCount] = fileName
          levelsCount = levelsCount+1
        end
        until not zip:gotoNextFile()
    end
  end
  if levelNames then
    local help = {"Choose a BSP level:"}
    local levelsCount = table.getn(levelNames)
    for ct = 1, levelsCount do
      if ct < 10 then
        help[ct+1] = "["..ct.."] "..levelNames[ct]
      else
        help[ct+1] = "["..string.char(string.byte("A")+ct-10).."] "..levelNames[ct]
      end
    end
    help[levelsCount+2] = " "
    help[levelsCount+3] = "[ENTER] Demos Menu"
    setHelp(help)
    showHelpUser()
    hideConsole()
  else
    setScene(Scene(BSP_init,BSP_update,BSP_final,BSP_keyDown))
  end
end

----MENU LOOP----
function MENU_update()
end

----MENU FINALIZATION----
function MENU_final()
  ----DELETE GLOBALS----
  ----EMPTY WORLD----
  empty()
end

----MENU KEYBOARD----
function MENU_keyDown(key)
  selectedLevel = key-string.byte("0")
  if selectedLevel > 9 then
    selectedLevel = selectedLevel-string.byte("A")+string.byte("0")+10
  end
  if selectedLevel < 1 or (selectedLevel > table.getn(levelNames)) then
    selectedLevel = -1
    if key == 13 then ---> RETURN
      releaseKey(13)
      levelNames = nil
      selectedLevel = nil
      if fileExists("main.lua") then
        final()
        dofile("main.lua")
      end
    end
  else
    setScene(Scene(BSP_init,BSP_update,BSP_final,BSP_keyDown))
  end
end

-----------------------
----BSP LEVEL SCENE----
-----------------------

----BSP INITIALIZATION----
function BSP_init()
  showLoadingScreen()
  ----CAMERA----
  setAmbient(.2,.2,.2)
  setPerspective(60,3,12000)
  local camera = getCamera()
  camera:reset()
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
  local sky = MirroredSky(skyTxt)
  setBackground(sky)
  ----SUN----
  sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, 0.9659,
    zip:getTexture("lensflares.png"),
    5, 0.2
  )
  sun:setColor(0.855,0.475,0.298);
  setSun(sun)
  ----EMITTER----
  local fireImage = zip:getImage("smoke.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  shotEmitter = Emitter(5,.1,3)
  shotEmitter:setTexture(fireTexture,1)
  shotEmitter:setVelocity(300,0,0, 0)
  shotEmitter:setColor(1,1,1,1, 1,.5,0,0)
  shotEmitter:setSize(22.5,22.5)
  shotEmitter:setGravity(0,0,0, 0,0,0)
  shotEmitter:setOneShot()
  shotEmitter:reset()
  addObject(shotEmitter)
  shotEmitter:hide()
  fireTexture:delete()
  ----BSP----
  if selectedLevel < 0 then
    bsp = zip:getLevel("maze.bsx",2.5)
  else
    local pak = Zip("pak0.pk3")
    bsp = pak:getLevel(levelNames[selectedLevel],2.5)
    pak:delete()
  end
  bsp:setShowUntexturedMeshes()
  bsp:setShowUntexturedPatches()
  showTransparenciesFlag = false
  useFastRenderingModeFlag = false
  bsp:setDefaultTexture(zip:getTexture("bricks.jpg",1))
  setScenery(bsp)
  ----MODELS----
  flyModeActive = 0
  runModeActive = 1
  isWalking = 0
  isRotating = 0
  linkTransform = Transform()
  legs = 5   ---> LEGS_IDLE
  weapon = zip:getModel("gun.md3","gun.jpg")
  avatar = zip:getBot("wrokdam.mdl",1)
  avatar:pitch(-1.5708)
  local startX, startY, startZ = bsp:getStartingPosition()
  avatar:move(startX,startY,startZ)
  avatar:move(0,0,0)
  avatar:getUpper():link("tag_weapon",weapon)
  avatar:setUpperAnimation(4) ---> TORSO_STAND
  avatar:setLowerAnimation(legs)
  addObject(avatar)
  setListenerScale(32)
  local shotSound = zip:getSample3D("shot.wav");
  shotSound:setVolume(255)
  shotSound:setMinDistance(8)
  shotSource = Source(shotSound,avatar);
  shotSource:getSound3D():stop()
  addSource(shotSource)
  local runSound = zip:getSample3D("run.wav");
  runSound:setLooping(1)
  runSound:setVolume(255)
  runSound:setMinDistance(8)
  runSource = Source(runSound,avatar);
  runSource:getSound3D():stop()
  addSource(runSource)
  ----HELP----
  VEL_Y = 0 --**
  local help = {
    "The model of this tutorial was made by:",
    "  Grant Struthers <TheGragster@yahoo.com>",
    "The weapon of this tutorial was made by:",
    "  Janus <janus@planetquake.com>",
    " ",
    "[   MOUSE  ] Look around",
    "[LEFT CLICK] Shoot",
    "[  UP/DOWN ] Move Forward/Back",
    "[LEFT/RIGHT] Rotate Left/Right",
    "[   SPACE  ] Walk/Run Mode",
    "[    DEL   ] Fly/Follow Model",
    "[ BACKSPACE] Restart Model",
    "[     T    ] Transparencies on/off",
    "[     F    ] Fast rendering on/off",
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

----BSP LOOP----
function BSP_update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end --** to avoid too large steps 
  if avatar:getUpper():getStoppedAnimation() == 1 then ---> TORSO_ATTACK
    avatar:setUpperAnimation(4) ---> TORSO_STAND
  end
  if
    isMouseLeftPressed() and
    (avatar:getUpperAnimation() ~= 1) ---> TORSO_ATTACK
  then
    avatar:setUpperAnimation(1) ---> TORSO_ATTACK
    shotSource:getSound3D():play()
    if avatar:getLinkTransform("tag_weapon",linkTransform) then
      shotEmitter:set(linkTransform)
      shotEmitter:moveSide(30)
      shotEmitter:show()
      shotEmitter:reset()
    end
  end
  local rotAngle = .15*timeStep
  if flyModeActive == 1 then
    if isKeyPressed(38) or isKeyPressed(40) then ---> VK_UP || VK_DOWN
      local posX,posY,posZ = camera:getPosition()
      local moveSpeed = 300
      local k = timeStep*moveSpeed
      if isKeyPressed(40) then ---> VK_UP
        k = -k
      end
      local velX,velY,velZ = camera:getViewDirection()
      posX,posY,posZ =
        bsp:slideCollision(posX,posY,posZ,k*velX,k*velY,k*velZ,14,14,14)
      camera:setPosition(posX,posY,posZ)
    end
    local dx, dy = getMouseMove()
    if dx ~= 0 then
      camera:rotStanding(-dx*rotAngle)
    end
    if dy ~= 0 then
      camera:pitch(-dy*rotAngle)
    end
  else
    local velX,velY,velZ
    local posX,posY,posZ = avatar:getPosition()
    if isKeyPressed(38) or isKeyPressed(40) then ---> VK_UP || VK_DOWN
      if legs == 5 then ---> LEGS_IDLE
        isWalking = 1
        runSource:getSound3D():play()
        if isKeyPressed(38) then ---> VK_UP
          if runModeActive == 1 then
            legs = 3 ---> LEGS_RUN
            avatar:setLowerAnimation(legs)
          else
            legs = 2 ---> LEGS_WALK
            avatar:setLowerAnimation(legs)
          end
        else
          legs = 4 ---> LEGS_BACK
          avatar:setLowerAnimation(legs)
        end
      end
      local moveSpeed = 30*timeStep
      if isKeyPressed(40) then ---> VK_DOWN
        moveSpeed = -7*moveSpeed
      elseif runModeActive == 1 then
        moveSpeed = 10*moveSpeed
      else
        moveSpeed = 5*moveSpeed
      end
      --**
      -- The use of the name velX etc. is misleading. In reality
      -- velX contains the step in the X direction (a length) and
      -- not the component of a velocity. Instead VEL_Y contains
      -- a real velocity component to be consistent between frames
      -- of different duration. Sorry!
      --**
      velX,velY,velZ = avatar:getSideDirection()
      velX = velX*moveSpeed
--**      velY = velY*moveSpeed-5.8
      velY = velY*moveSpeed --**
      velZ = velZ*moveSpeed
    else
      if isWalking == 1 then
        legs = 5 ---> LEGS_IDLE
        avatar:setLowerAnimation(legs)
        isWalking = 0
        runSource:getSound3D():stop()
      end
--**      velX,velY,velZ = 0,-5.8,0
      velX,velY,velZ = 0,0,0 --**
    end
--**    posX,posY,posZ = bsp:slideCollision(posX,posY,posZ,velX,velY,velZ,14,28,14)
    VEL_Y = VEL_Y-500*timeStep
    velY = velY+VEL_Y*timeStep -- velY is a length, while VEL_Y a speed
    local POS_Y
    posX,POS_Y,posZ = bsp:slideCollision(posX,posY,posZ,velX,velY,velZ,14,28,14)
    if POS_Y < posY then
      VEL_Y = (POS_Y-posY)/timeStep
    else
      VEL_Y = 0
    end
    posY = POS_Y+0.032 
    --**
    -- Without the 0.032 (that is 1 mm if 1 m is 32 units) the model
    -- sinks in the ground. Probably slideCollision() may return
    -- values a little below the ground, then passing back that
    -- values no collision occurs any more and the model sinks.
    --**
--**
    avatar:setPosition(posX,posY,posZ);
    if isKeyPressed(37) or isKeyPressed(39) then ---> VK_LEFT || VK_RIGHT
      if (isWalking == 0) and (isRotating == 0) then
        isRotating = 1
        avatar:setLowerAnimation(7) ---> LEGS_TURN
      end
      if isKeyPressed(37) then ---> VK_LEFT
        avatar:rotStanding(1.5708*timeStep)
      end
      if isKeyPressed(39) then ---> VK_RIGHT
        avatar:rotStanding(-1.5708*timeStep)
      end
    else
      if isRotating == 1 then
        isRotating = 0
        avatar:setLowerAnimation(5) ---> LEGS_IDLE
      end
    end
    local dx,dy = getMouseMove()
    if dx ~= 0 then
      local headAngle = avatar:getHead():getYawAngle()
      if headAngle ~= 0 then
        local newHeadAngle = headAngle-dx*rotAngle
        if headAngle*newHeadAngle < 0 then
          avatar:getHead():setYawAngle(0)
          avatar:getUpper():addYawAngle(newHeadAngle-headAngle,1.047)
        else
          avatar:getHead():addYawAngle(-dx*rotAngle,1.5708)
        end
      else
        local diff = avatar:getUpper():addYawAngle(-dx*rotAngle,1.047)
        if diff ~= 0 then
          avatar:getHead():addYawAngle(diff,1.5708)
        end
      end
    end
    if isWalking == 1 then
      local headAngle = avatar:getHead():getYawAngle()
      local upperAngle = avatar:getUpper():getYawAngle()
      local yawAngle = headAngle+upperAngle
      if yawAngle ~= 0 then
        local rotation = timeStep*3.1415
        if yawAngle > 0 then
          rotation = -rotation
        end
        avatar:rotStanding(-rotation)
        if headAngle ~= 0 then
          local newHeadAngle = headAngle+rotation
          if headAngle*newHeadAngle < 0 then
            avatar:getHead():setYawAngle(0)
            avatar:getUpper():addYawAngle(newHeadAngle-headAngle,1.047)
          else
            avatar:getHead():addYawAngle(rotation,1.5708)
          end
        else
          local diff = avatar:getUpper():addYawAngle(rotation,1.047)
          if diff ~= 0 then
            avatar:getHead():addYawAngle(diff,1.5708)
          end
        end
      end
    end
    if dy ~= 0 then
      local headAngle = avatar:getHead():getPitchAngle()
      if headAngle ~= 0 then
        local newHeadAngle = headAngle-dy*rotAngle
        if headAngle*newHeadAngle < 0 then
          avatar:getHead():setPitchAngle(0)
          avatar:getUpper():addPitchAngle(
            newHeadAngle-headAngle,1.047,-.5236
          )
        else
          avatar:getHead():addPitchAngle(
            -dy*rotAngle,.5236,-.7854
          )
        end
      else
        local diff = avatar:getUpper():addPitchAngle(
          -dy*rotAngle,1.047,-.5236
        )
        if diff ~= 0 then
          avatar:getHead():addPitchAngle(diff,.5236,-7854)
        end
      end
    end
    if isMouseRightPressed() then
      if
        (avatar:getUpper():getPitchAngle() ~= 0) or
        (avatar:getUpper():getYawAngle() ~= 0) or
        (avatar:getHead():getPitchAngle() ~= 0) or
        (avatar:getHead():getYawAngle() ~= 0)
      then
        avatar:getUpper():setPitchAngle(0)
        avatar:getUpper():setYawAngle(0)
        avatar:getHead():setPitchAngle(0)
        avatar:getHead():setYawAngle(0)
      end
    end
    camera:set(avatar)
    camera:rotateT(avatar:getUpper())
    camera:rotateT(avatar:getHead())
    camera:exchangeYZX()
    local posX,posY,posZ = camera:getPosition()
    posY = posY+30
    local velX,velY,velZ = camera:getViewDirection()
    velX = -90*velX
    velY = -90*velY
    velZ = -90*velZ
    posX,posY,posZ = bsp:checkCollision(posX,posY,posZ,velX,velY,velZ,3,3,3)
    camera:setPosition(posX,posY,posZ)
  end
end

----BSP FINALIZATION----
function BSP_final()
  ----DELETE GLOBALS----
  showTransparenciesFlag = nil
  useFastRenderingModeFlag = nil
  VEL_Y = nil --**
  selectedLevel = nil
  levelNames = nil
  runSource = nil
  shotSource = nil
  legs = nil
  linkTransform = nil
  flyModeActive = nil
  runModeActive = nil
  isWalking = nil
  isRotating = nil
  ----EMPTY WORLD----
  bsp = nil
  avatar = nil
  shotEmitter = nil
  if weapon then
    weapon:delete()
    weapon = nil
  end
  empty()
  setListenerScale(1)
end

----BSP KEYBOARD----
function BSP_keyDown(key)
  ----VARIOUS SCENE MODIFIERS----
  if key == 46 then ---> VK_DELETE
    releaseKey(46)
    flyModeActive = 1-flyModeActive
    if flyModeActive == 1 then
      local camera = getCamera()
      camera:set(avatar)
      camera:exchangeYZX()
      camera:move(0,60,0)
    end
  elseif key == 32 then ---> SPACE
    releaseKey(32)
    runModeActive = 1-runModeActive
  elseif key == 8 then ---> VK_BACK
    releaseKey(8)
    local posX,posY,posZ = bsp:getStartingPosition()
    avatar:setPosition(posX,posY,posZ)
  elseif key == string.byte("T") then
    releaseKey(string.byte("T"))
    showTransparenciesFlag = not showTransparenciesFlag
    bsp:setShowTransparencies(showTransparenciesFlag)
  elseif key == string.byte("F") then
    releaseKey(string.byte("F"))
    useFastRenderingModeFlag = not useFastRenderingModeFlag
    bsp:setUseFastRendering(useFastRenderingModeFlag)
  end
  ----LOAD MAIN MENU----
  if key == 13 then ---> RETURN
    releaseKey(13)
    if levelNames then
      empty()
      setScene(Scene(MENU_init,MENU_update,MENU_final,MENU_keyDown))
    else
      levelNames = nil
      selectedLevel = nil
      if fileExists("main.lua") then
        final()
        dofile("main.lua")
      end
    end
  end
end

-------------------
----SCENE SETUP----
-------------------
setScene(Scene(MENU_init,MENU_update,MENU_final,MENU_keyDown))

