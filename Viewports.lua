----Viewports DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----SOME GLOBALS----
  MAX_AVATARS = 9
  shotEmitter = {}
  avatar = {}
  linkTransform = Transform()
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
    error("\nRequires 'DemoPack0.dat' to work.\nERROR: File 'DemoPack0.dat' not found.")
  end
  local zip = Zip("DemoPack0.dat")
  local skyTxt = {
    zip:getTexture("skyboxTop2.jpg"),
    zip:getTexture("skyboxLeft2.jpg"),
    zip:getTexture("skyboxFront2.jpg"),
    zip:getTexture("skyboxRight2.jpg"),
    zip:getTexture("skyboxBack2.jpg")
  }
  isDay = 1
  skyBackground = MirroredSky(skyTxt)
  skyBackground:rotStanding(3.1415)
  setBackground(skyBackground)
  starBackground = StarField(50,6000,zip:getTexture("stars.jpg"),20)
  ----SUN----
  sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, -0.9659,
    zip:getTexture("lensflares.png"),
    5, 0.1
  )
  sun:setColor(0.855,0.475,0.298);
  setSun(sun)
  ----FIRELIGHT----
  fireLight = FireLight(zip:getTexture("light.jpg"),1.5)
  fireLight:setAttenuation(0,0,0.02)
  fireLight:setIntensities(0.75,0.25,0, 1,0.75,0)
  addLight(fireLight)
  fireLight:hide()
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(1,1,1)
  terrainMaterial:setDiffuse(0,0,0)
  terrainMaterial:setDiffuseTexture(zip:getTexture("marble.jpg",1))
  ground = FlatTerrain(terrainMaterial,500,125)
  setTerrain(ground)
  terrainMaterial:delete()
  ----EMITTERS----
  local fireImage = zip:getImage("smoke.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  fireEmitter = Emitter(15,0.75,3)
  fireEmitter:setTexture(fireTexture,1)
  fireEmitter:setVelocity(-1,1,0, 0.3)
  fireEmitter:setColor(1,1,0,1, 1,0,0,0)
  fireEmitter:setSize(.5,.1)
  fireEmitter:setGravity(0,0,0, 0,0,0)
  fireEmitter:reset()
  addObject(fireEmitter)
  local fireSound = zip:getSample3D("fire.wav");
  fireSound:setLooping(1)
  fireSound:setVolume(255)
  fireSound:setMinDistance(4)
  local fireSource = Source(fireSound,fireEmitter);
  addSource(fireSource)
  for ct = 0, MAX_AVATARS-1 do
    shotEmitter[ct] = Emitter(5,0.1,3)
    shotEmitter[ct]:setTexture(fireTexture,1)
    shotEmitter[ct]:setVelocity(10,1,0, 0)
    shotEmitter[ct]:setColor(1,1,1,1, 1,0.5,0,0)
    shotEmitter[ct]:setSize(.75,.75)
    shotEmitter[ct]:setGravity(0,0,0, 0,0,0)
    shotEmitter[ct]:setOneShot()
    shotEmitter[ct]:reset()
    addObject(shotEmitter[ct])
    shotEmitter[ct]:hide()
    end
  fireTexture:delete()
  ----MODELS----
  torso = 4  ---> TORSO_STAND
  legs = 5   ---> LEGS_IDLE
  weapon = zip:getModel("gun.md3","gun.jpg")
  weapon:rescale(0.04)
  local avatarCt = 0
  avatar[0] = zip:getBot("wrokdam.mdl")
  avatar[0]:rescale(0.04)
  avatar[0]:pitch(-1.5708)
  avatar[0]:rotStanding(1.5708)
  avatar[0]:move(0,1,0)
  avatar[0]:getUpper():link("tag_weapon",weapon)
  avatar[0]:setUpperAnimation(torso)
  avatar[0]:setLowerAnimation(legs)
  addObject(avatar[0])
  for ct = avatarCt+1, MAX_AVATARS/3-1 do
    avatar[ct] = Bot(avatar[0])
    avatar[ct]:pitch(-1.5708)
    avatar[ct]:rotStanding(1.5708)
    avatar[ct]:move(3*(ct-avatarCt),1,0)
    addObject(avatar[ct])
    end
  avatarCt = MAX_AVATARS/3
  local torsoRed = Material()
  torsoRed:setDiffuseTexture(zip:getTexture("torsoRed.jpg"))
  local bodyRed = Material()
  bodyRed:setDiffuseTexture(zip:getTexture("bodyRed.jpg"))
  avatar[avatarCt] = Bot(avatar[0])
  avatar[avatarCt]:getUpper():setMaterial(torsoRed)
  avatar[avatarCt]:getLower():setMaterial(bodyRed)
  avatar[avatarCt]:pitch(-1.5708)
  avatar[avatarCt]:rotStanding(1.5708)
  avatar[avatarCt]:move(0,1,2)
  addObject(avatar[avatarCt])
  for ct = avatarCt+1, 2*MAX_AVATARS/3-1 do
    avatar[ct] = Bot(avatar[avatarCt])
    avatar[ct]:pitch(-1.5708)
    avatar[ct]:rotStanding(1.5708)
    avatar[ct]:move(3*(ct-avatarCt),1,2)
    addObject(avatar[ct])
    end
  avatarCt = 2*MAX_AVATARS/3
  local torsoBlue = Material()
  torsoBlue:setDiffuseTexture(zip:getTexture("torsoBlue.jpg"))
  local bodyBlue = Material()
  bodyBlue:setDiffuseTexture(zip:getTexture("bodyBlue.jpg"))
  avatar[avatarCt] = Bot(avatar[0])
  avatar[avatarCt]:getUpper():setMaterial(torsoBlue)
  avatar[avatarCt]:getLower():setMaterial(bodyBlue)
  avatar[avatarCt]:pitch(-1.5708)
  avatar[avatarCt]:rotStanding(1.5708)
  avatar[avatarCt]:move(0,1,4)
  addObject(avatar[avatarCt])
  for ct = avatarCt+1, MAX_AVATARS-1 do
    avatar[ct] = Bot(avatar[avatarCt])
    avatar[ct]:pitch(-1.5708)
    avatar[ct]:rotStanding(1.5708)
    avatar[ct]:move(3*(ct-avatarCt),1,4)
    addObject(avatar[ct])
    end
  torch = zip:getMesh("torch.3ds")
  torch:pitch(1.5708)
  torch:move(-0.15,0,-0.5)
  avatar[0]:getUpper():link("tag_weapon",torch)
  pole = zip:getMesh("pole2.3ds")
  pole:pitch(1.5708)
  pole:move(-0.15,0,-0.5)
  avatar[MAX_AVATARS-1]:getUpper():link("tag_weapon",pole)
  local shotSound = zip:getSample3D("shot.wav");
  shotSound:setVolume(255)
  shotSound:setMinDistance(8)
  shotSource = Source(shotSound,avatar[math.floor(MAX_AVATARS/2)]);
  shotSource:getSound3D():stop()
  addSource(shotSource)
  local reloadSound = zip:getSample3D("reload.wav");
  reloadSound:setVolume(255)
  reloadSound:setMinDistance(4)
  reloadSource = Source(reloadSound,avatar[math.floor(MAX_AVATARS/2)]);
  reloadSource:getSound3D():stop()
  addSource(reloadSource)
  ----FLAG SIMULATOR----
  local posHighX, posHighY, posHighZ = -0.15, 0, 5.5
  local posLowX, posLowY, posLowZ = -0.15, 0, 2.5
  if avatar[MAX_AVATARS-1]:getLinkTransform("tag_weapon",linkTransform) then
    posHighX, posHighY, posHighZ = linkTransform:multiply(
      posHighX, posHighY, posHighZ
    )
    posLowX, posLowY, posLowZ = linkTransform:multiply(
      posLowX, posLowY, posLowZ
    )
    end
  simulator = Simulator()
  windSpeed = 2
  environment = StaticEnvironment(-windSpeed,0,windSpeed, 0.01)
  local SIDE_CT = 17
  local SIDE_LEN = 3
  cloth = Cloth(
    SIDE_CT, SIDE_CT,        ---> width, height
    posLowX,posLowY,posLowZ, ---> origin
    0,SIDE_LEN/SIDE_CT,0,    ---> uGen
    -SIDE_LEN/SIDE_CT,0,0,   ---> vGen
    0.01,                    ---> mass
    simulator, environment
  )
  cloth:setRelaxationCycles(4)
  cloth:addNail(0, posLowX,posLowY,posLowZ)
  cloth:addNail(SIDE_CT-1, posHighX,posHighY,posHighZ)
  local flagMaterial = Material()
  flagMaterial:setAmbient(0.7,0.7,0.7)
  flagMaterial:setDiffuse(1,1,1)
  flagMaterial:setSpecular(1,1,1)
  flagMaterial:setShininess(128)
  flagMaterial:setDiffuseTexture(zip:getTexture("foulard.jpg"))
  flagMaterial:setEnvironmentTexture(zip:getTexture("environ.jpg"),0.25)
  clothModel = cloth:getMesh()
  clothModel:setMaterial(flagMaterial)
  addObject(clothModel)
  flagMaterial:delete()
  local flagSound = zip:getSample3D("flag.wav");
  flagSound:setLooping(1)
  flagSound:setVolume(255)
  flagSound:setMinDistance(4)
  local flagSource = Source(flagSound,clothModel);
  addSource(flagSource)
  ----VIEWPORTS----
  setClear(1,1,0)
  local w, h = getDimension()
  setViewport(w/8,h/8,6*w/8,6*h/8)
  vp1 = OverlayWorldView(400,300)
  vp1:setLocation(400,200)
  vp1:setPerspective(60,.25,1000)
  vp1:getCamera():setPosition(0,1.8,20)
  vp1:getCamera():rotStanding(3.1415)
  addToOverlay(vp1)
  vp1 = OverlayViewport(200,200)
  vp1:setLayer(-1)
  vp1:setLocation(100,100)
  vp1:setPerspective(70,0.1,100)
  local vp1sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, -0.9659
  )
  vp1sun:setColor(0.855,0.475,0.298);
  vp1:setSun(vp1sun)
  vp1model = zip:getModel("gun.md3","gun.jpg")
  vp1model:rescale(0.04)
  vp1model:move(0,0,1.5)
  vp1model:pitch(-1.57)
  vp1:addObject(vp1model)
  addToOverlay(vp1)
  vp2 = OverlayViewport(200,200)
  vp2:setLocation(100,300)
  vp2:setPerspective(70,0.1,1000)
  vp2:getCamera():setPosition(0,1,-2)
  local vp2SkyTxt = {
    zip:getTexture("skyboxTop2.jpg"),
    zip:getTexture("skyboxLeft2.jpg"),
    zip:getTexture("skyboxFront2.jpg"),
    zip:getTexture("skyboxRight2.jpg"),
    zip:getTexture("skyboxBack2.jpg")
  }
  local vp2Background = MirroredSky(vp2SkyTxt)
  vp2:setBackground(vp2Background)
  local vp2Material = Material()
  vp2Material:setAmbient(1,1,1)
  vp2Material:setDiffuse(0,0,0)
  vp2Material:setDiffuseTexture(zip:getTexture("wood.jpg",1))
  local vp2ground = FlatTerrain(vp2Material,500,125)
  vp2:setTerrain(vp2ground)
  vp2:enableFog(200, .522,.373,.298)
  addToOverlay(vp2)
  vp3 = OverlayViewport(200,200)
  vp3:setLocation(300,100)
  vp3:setPerspective(70,0.1,100)
  vp2:getCamera():setPosition(0,1,-2)
  vp3:setAmbient(1,1,0.5)
  local vp3Background = StarField(50,6000,zip:getTexture("stars.jpg"),20)
  vp3:setBackground(vp3Background)
  local vp3mesh = zip:getMesh("foot.3ds")
  vp3mesh:move(0,0,5)
  vp3:addObject(vp3mesh)
  addToOverlay(vp3)
  vp4 = OverlayViewport(200,200)
  vp4:setLayer(-1)
  vp4:setLocation(300,300)
  vp4:setColor(0.5,0,0)
  vp4:setOrtho(1000)
  vp4:setAmbient(1,1,0.5)
  vp4model = zip:getBot("wrokdam.mdl")
  vp4model:rescale(2)
  vp4model:pitch(-1.5708)
  vp4model:rotStanding(1.5708)
  vp4model:move(0,-1*32,2*32)
  vp4:addObject(vp4model)
  addToOverlay(vp4)
  ----HELP----
  local help = {
    "The model of this tutorial was made by:",
    "  Grant Struthers <TheGragster@yahoo.com>",
    "The weapon of this tutorial was made by:",
    "  Janus <janus@planetquake.com>",
    "[  MOUSE  ] Look around",
    "[ UP/DOWN ] Move Forward/Back",
    "[PREV/NEXT] Raise/Lower View",
    "[  Z key  ] Shoot/Recharge",
    "[  X key  ] Change Animations",
    "[  C key  ] Death Animation",
    "[ A,S,Q,W ] Rotate Torso/Head",
    "[ D,F,E,R ] Bend Torso/Head",
    "[ 0,1...6 ] Select Wind Speed",
    "[  7,8,9  ] Select Flag Elasticity",
    "[   INS   ] Day/Night Transition",
    "[   DEL   ] Show/Hide Reflections",
    "[  SPACE  ] Rotate Scene",
    "[  ENTER  ] Demos Menu",
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
  ----VIEWPORTS----
  if timeStep > 0.1 then
    timeStep = 0.1
  end
  vp1model:rotStanding(1.57*timeStep)
  vp2:getCamera():rotAround(0.25*timeStep)
  vp3:getCamera():rotAround(-0.25*timeStep)
  vp4model:rotStanding(-1.57*timeStep)
  local posX, posY
  local sizeX, sizeY
  posX, posY  = vp2:getLocation()
  sizeX, sizeY = vp2:getDimension()
  posX = posX+timeStep*100*math.random(-2,2)
  posY = posY+timeStep*100*math.random(-2,2)
  sizeX = sizeX+timeStep*100*math.random(-2,2)
  if sizeX < 0 then
    sizeX = 0
  end
  sizeY = sizeY+timeStep*200*math.random(-2,2)
  if sizeY < 0 then
    sizeY = 0
  end
  vp2:setLocation(posX,posY)
  vp2:setDimension(sizeX,sizeY)
  posX, posY  = vp3:getLocation()
  sizeX, sizeY = vp3:getDimension()
  posX = posX+timeStep*100*math.random(-2,2)
  posY = posY+timeStep*100*math.random(-2,2)
  sizeX = sizeX+timeStep*100*math.random(-2,2)
  if sizeX < 0 then
    sizeX = 0
  end
  sizeY = sizeY+timeStep*100*math.random(-2,2)
  if sizeY < 0 then
    sizeY = 0
  end
  vp3:setLocation(posX,posY)
  vp3:setDimension(sizeX,sizeY)
   ----DEFAULT----
  local fwdSpeed = 0
  local rotSpeed = 0
  if legs == 1 then  ---> LEGS_WALKCR
    fwdSpeed = 2.5
    rotSpeed = 0.31415
  elseif legs == 2 then ---> LEGS_WALK
    fwdSpeed = 2.5
    rotSpeed = 0.6283
  elseif legs == 3 then ---> LEGS_RUN
    fwdSpeed = 5
    rotSpeed = 0.6283
  elseif legs == 4 then ---> LEGS_BACK
    fwdSpeed = -3.5
    rotSpeed = 0.31415
  elseif legs == 7 then ---> LEGS_TURN
    rotSpeed = 1.5708
    end
  for ct = 0, MAX_AVATARS-1 do
    avatar[ct]:walk(fwdSpeed*timeStep);
    avatar[ct]:rotStanding(rotSpeed*timeStep);
    local stopped = avatar[ct]:getLower():getStoppedAnimation()
    stopped = avatar[ct]:getUpper():getStoppedAnimation()
    if stopped == 2 then ---> TORSO_DROP
      avatar[ct]:setUpperAnimation(3) ---> TORSO_RAISE
    elseif (stopped == 1) or (stopped == 3) then ---> TORSO_ATTACK or RAISE
      avatar[ct]:setUpperAnimation(4) ---> TORSO_STAND
      end
    end
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
    local posX,posY,posZ = avatar[0]:getPosition()
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
  if isKeyPressed(string.byte("A")) then
    local angle = 3.1415*timeStep
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:getUpper():addYawAngle(angle,1.047)
    end
  elseif isKeyPressed(string.byte("S")) then
    local angle = -3.1415*timeStep
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:getUpper():addYawAngle(angle,1.047)
    end
  elseif isKeyPressed(string.byte("Q")) then
    local angle = 3.1415*timeStep
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:getHead():addYawAngle(angle,1.5708)
    end
  elseif isKeyPressed(string.byte("W")) then
    local angle = -3.1415*timeStep
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:getHead():addYawAngle(angle,1.5708)
    end
  elseif isKeyPressed(string.byte("D")) then
    local angle = 1.57*timeStep
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:getUpper():addPitchAngle(angle,0.5236)
    end
  elseif isKeyPressed(string.byte("F")) then
    local angle = -1.57*timeStep
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:getUpper():addPitchAngle(angle,0.5236)
    end
  elseif isKeyPressed(string.byte("E")) then
    local angle = 1.57*timeStep
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:getHead():addPitchAngle(angle,0.5236)
    end
  elseif isKeyPressed(string.byte("R")) then
    local angle = -1.57*timeStep
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:getHead():addPitchAngle(angle,0.5236)
    end
  end
  if avatar[0]:getLinkTransform("tag_weapon",linkTransform) then
    local posX,posY,posZ = -0.15,0,1.25
    posX,posY,posZ = linkTransform:multiply(posX,posY,posZ);
    fireEmitter:setPosition(posX,posY,posZ)
    fireLight:setPosition(posX,posY,posZ)
    end
  if avatar[MAX_AVATARS-1]:getLinkTransform("tag_weapon",linkTransform) then
    local posX,posY,posZ = -0.15,0,5.5
    posX,posY,posZ = linkTransform:multiply(posX,posY,posZ);
    cloth:setNailPosition(1,posX,posY,posZ)
    posX,posY,posZ = -0.15,0,2.5
    posX,posY,posZ = linkTransform:multiply(posX,posY,posZ);
    cloth:setNailPosition(0,posX,posY,posZ)
    end
  local simTime = timeStep
  if(simTime > 0.1) then
    simTime = 0.1
    end
  simulator:runStep(simTime)
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
  ----VIEWPORTS----
  setViewport(0,0,getDimension())
  setClear(0,0,0)
  vp1 = nil
  vp2 = nil
  vp3 = nil
  vp4 = nil
  vp1model = nil
  vp4model = nil
  ----DELETE GLOBALS----
  linkTransform:delete()
  if environment then
    environment:delete()
    environment = nil
    end
  if simulator then
    simulator:delete()
    simulator = nil
    end
  shotSource = nil
  reloadSource = nil
  windSpeed = nil
  rotateView = nil
  torso = nil
  legs = nil
  ----EMPTY WORLD----
  sun = nil
  fireLight = nil
  fireEmitter = nil
  for ct = 0, MAX_AVATARS-1 do
    avatar[ct] = nil
    shotEmitter[ct] = nil
    end
  MAX_AVATARS = nil
  avatar = nil
  shotEmitter = nil
  if weapon then
    weapon:delete()
    weapon = nil
    end
  if pole then
    pole:delete()
    pole = nil
    end
  if torch then
    torch:delete()
    torch = nil
    end
  ground = nil
  cloth = nil
  if isDay then
    starBackground:delete()
  else
    skyBackground:delete()
    end
  skyBackground = nil
  starBackground = nil
  isDay = nil
  disableFog()
  emptyOverlay()
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
  ----WIND SPEED & RELAXATION----
  local asciiBase = string.byte("0")
  for ct = 0, 6 do
    if key == asciiBase+ct then
      releaseKey(asciiBase+ct)
      windSpeed = ct*0.5
      environment:setWind(-windSpeed,0,windSpeed)
      break
      end
    end
  for ct = 7, 9 do
    if key == asciiBase+ct then
      releaseKey(asciiBase+ct)
      local val = 4
      if ct == 7 then
        val = 2
      elseif ct == 9 then
        val = 8
        end
      cloth:setRelaxationCycles(val)
      break
      end
    end
  ----VARIOUS SCENE MODIFIERS----
  if key == 46 then --> VK_DELETE
    releaseKey(46)
    if ground:isReflective() then
      ground:setOpaque()
    else
      ground:setReflective()
      end
  elseif key == 45 then --> VK_INSERT
    releaseKey(45)
    if isDay then
      isDay = nil
      setBackground(starBackground,nil)
      enableFog(200, 0,0,0)
      setAmbient(0.2,0.2,0.2)
      sun:hide()
      fireLight:show()
      clothModel:getMaterial():setEnvironment(0.1)
    else
      isDay = 1
      setBackground(skyBackground,nil)
      enableFog(200, 0.522,0.373,0.298)
      setAmbient(0.5,0.5,0.5)
      sun:show()
      fireLight:hide()
      clothModel:getMaterial():setEnvironment(0.25)
      end
  elseif key == string.byte("Z") then
    releaseKey(string.byte("Z"))
    torso = torso+1
    if torso >= 5 then ---> MAX_TORSO_ANIMATIONS
      torso = 1 ---> TORSO_ATTACK
    elseif torso == 3 then ---> TORSO_RAISE
      torso = 1 ---> TORSO_ATTACK
      end
    for ct = 1, MAX_AVATARS-2 do
      avatar[ct]:setUpperAnimation(torso)
      end
    if torso == 1 then ---> TORSO_ATTACK
      shotSource:getSound3D():play()
      for ct = 1, MAX_AVATARS-2 do
        if avatar[ct]:getLinkTransform("tag_weapon",linkTransform) then
          shotEmitter[ct]:set(linkTransform)
          shotEmitter[ct]:moveSide(1)
          shotEmitter[ct]:show()
          shotEmitter[ct]:reset()
          end
        end
    elseif torso == 2 then ---> TORSO_DROP
      reloadSource:getSound3D():play()
      end
  elseif key == string.byte("X") then
    releaseKey(string.byte("X"))
    legs = legs+1
    if legs >= 8 then ---> MAX_LEGS_ANIMATIONS
      legs = 1 ---> LEGS_WALKCR
      end
    for ct = 0, MAX_AVATARS-1 do
      avatar[ct]:setLowerAnimation(legs)
      end
  elseif key == string.byte("C") then
    releaseKey(string.byte("C"))
    legs = 0 ---> LEGS_DEATH
    for ct = 1, MAX_AVATARS-2 do
      avatar[ct]:setLowerAnimation(legs)
      avatar[ct]:setUpperAnimation(legs)
      end
    avatar[0]:setLowerAnimation(5) ---> LEGS_IDLE
    avatar[0]:setUpperAnimation(4) ---> TORSO_STAND
    avatar[MAX_AVATARS-1]:setLowerAnimation(5) ---> LEGS_IDLE
    avatar[MAX_AVATARS-1]:setUpperAnimation(4) ---> TORSO_STAND
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

