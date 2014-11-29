----OBJECTS HIERARCHY
----ODE Demo
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.5,3000)
  enableFog(1000, .4,.4,1)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.6,6)
  camera:rotStanding(3.1415)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack1.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack1.dat' not found.")
  end
  local zip = Zip("DemoPack1.dat")
  local skyTxt = {
    zip:getTexture("skyboxTop.jpg"),
    zip:getTexture("skyboxLeft.jpg"),
    zip:getTexture("skyboxFront.jpg"),
    zip:getTexture("skyboxRight.jpg"),
    zip:getTexture("skyboxBack.jpg")
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
  ----SPHERE----
  sun = zip:getMesh("sphere.3ds")
  earth = sun:clone()
  moon = earth:clone()
  earthFrame = Objects()
  earthFrame:add(earth)
  moon:move(2,0,0)
  earthFrame:add(moon)
  sunFrame = Objects()
  sunFrame:add(sun)
  earthFrame:move(4,0,0)
  sunFrame:add(earthFrame)
  sunFrame:move(0,2,0)
  addObject(sunFrame)
  ----HELP----
  local help = {
    "[  Z  ] Rotate \"Earth\"",
    "[  X  ] Rotate \"Sun\"",
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[SPACE] On/Off Rotation",
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
  ---ROTATE FRAMES----
  local rotSpeed = 0.78
  if isKeyPressed(string.byte("Z")) then
    earthFrame:yaw(timeStep*rotSpeed)
  end
  if isKeyPressed(string.byte("X")) then
    sunFrame:yaw(timeStep*rotSpeed)
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
  ----MOVE CAMERA (KEYBOARD)----
  local speed = 3
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(speed*timeStep)
  end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-speed*timeStep)
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
  sun = nil
  earth = nil
  moon = nil
  sunFrame = nil
  earthFrame = nil
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----SCENE SETUP----
setScene(Scene(init,update,final))
