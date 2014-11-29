----FIRE & SMOKE
----Particle System Example
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----CAMERA----
  setAmbient(.3,.3,.3)
  setPerspective(60,.5,3000)
  enableFog(750, .5,.5,.75)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
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
  local sky = MirroredSky(skyTxt)
  setBackground(sky);
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0,.41,.91,
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
  ----FIRE----
  local fireImage = zip:getImage("smoke.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  local fireEmitter = Emitter(10,1,15)
  fireEmitter:setTexture(fireTexture,1)
  fireEmitter:setVelocity(3,2,.5, 0.5)
  fireEmitter:setColor(1,1,0,1, 1,0,0,0)
  fireEmitter:setSize(2,.5)
  fireEmitter:setGravity(0,0,0, 0,0,0)
  fireEmitter:move(0,1.25,.5)
  fireEmitter:reset()
  addObject(fireEmitter)
  local fireImage = zip:getImage("fire.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  local fireEmitter = Emitter(4,1,15)
  fireEmitter:setTexture(fireTexture,1)
  fireEmitter:setVelocity(3,2,.5, 0.5)
  fireEmitter:setColor(.75,.25,0,1, 1,0,0,.5)
  fireEmitter:setSize(2.5,.1)
  fireEmitter:setGravity(0,0,0, 0,0,0)
  fireEmitter:move(0,1.25,.5)
  fireEmitter:reset()
  addObject(fireEmitter)
  fireTexture:delete()
  local fireSound = zip:getSample3D("fire.wav");
  fireSound:setLooping(1)
  fireSound:setVolume(255)
  fireSound:setMinDistance(10)
  local fireSource = Source(fireSound,fireEmitter);
  addSource(fireSource)
  ----SMOKE----
  local smokeImage = zip:getImage("smoke.png")
  smokeImage:convertToRGBA()
  local smokeTexture = Texture(smokeImage)
  smokeImage:delete()
  local smokeEmitter = Emitter(15,2.5,30)
  smokeEmitter:setTexture(smokeTexture,1)
  smokeEmitter:setVelocity(2,1,-.5, 0.5)
  smokeEmitter:setColor(0,0,0,1, 0,0,0,0)
  smokeEmitter:setSize(.4,2)
  smokeEmitter:setGravity(0,0,0, 0,3,0)
  smokeEmitter:move(0,.25,0)
  smokeEmitter:reset()
  addObject(smokeEmitter)
  smokeTexture:delete()
  ----POLE----
  local pole = zip:getMeshes("pole.3ds")
  pole:move(0,0,0)
  addObject(pole)
  ----HELP----
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
  ----GLOBALS----
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----SCENE SETUP----
setScene(Scene(init,update,final))

