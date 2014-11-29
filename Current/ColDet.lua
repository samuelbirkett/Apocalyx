----COLDET Demo
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  setTitle("ColDet Demo")
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, 0.6,0.7,1)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,15,-5)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack1.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack1.dat' not found")
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
  sky:rotStanding(-3.1415)
  setBackground(sky)
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0,0.41,-0.91,
    zip:getTexture("lensflares.png"),
    5, 0.1
  )
  setSun(sun)
  ----3DS TERRAIN----
  local terrain = zip:getMesh("terrain.3ds")
  terrain:pitch(-1.57)
  addObject(terrain)
  terrainCollider = Collider(terrain,true)
  ----3DS BALL----
  remTimeStep = 0
  velX, velY, velZ = 0, 0, 0
  ball = zip:getMesh("sphere.3ds")
  ball:move(0,30,10)
  addObject(ball)
  ballCollider = Collider(ball,true)
  ----HELP----
  local help = {
    "[  SPACE  ] Rotate Around Object",
    "[  MOUSE  ] Look Around",
    "[ UP/DOWN ] Move Camera Forward/Back",
    "[LEFT/RGHT] Move Camera Left/Right",
    "[PREV/NEXT] Raise/Lower Camera",
    "[ W,A,S,Z ] Move Object Around",
    "[HOME/END ] Raise/Lower Object",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help"
  }
  setHelp(help)
  hideConsole()
  showHelpReduced()
  ----DELETE ZIP----
  zip:delete()
end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ----COLLISION DETECTION----
  local STEPS_PER_SEC = 100
  local SUB_TIME_STEP = 1/STEPS_PER_SEC
  timeStep = timeStep+remTimeStep
  if timeStep > 0.1 then
    timeStep = 0.1
  end
  local STEPS = math.floor(timeStep*STEPS_PER_SEC)
  remTimeStep = timeStep-STEPS*SUB_TIME_STEP
  for tick = 1, STEPS do
    local balX, balY, balZ = ball:getPosition()
    if terrainCollider:collision(ballCollider) then
      local colX, colY, colZ = terrainCollider:getCollisionPoint()
      local nX, nY, nZ = balX-colX, balY-colY, balZ-colZ
      local n2 = nX*nX+nY*nY+nZ*nZ
      local velDotNorm = velX*nX+velY*nY+velZ*nZ
      if velDotNorm < 0 then 
        velDotNorm = 2*velDotNorm/n2
        velX = velX-nX*velDotNorm
        velY = velY-nY*velDotNorm
        velZ = velZ-nZ*velDotNorm
        balY = balY+0.5
      end
    end
    velY = velY-9.81*SUB_TIME_STEP
    balX = balX+velX*SUB_TIME_STEP
    balY = balY+velY*SUB_TIME_STEP
    balZ = balZ+velZ*SUB_TIME_STEP
    if balX < -80 or balX > 80 then
      velX = -velX
    end
    if balZ < -80 or balZ > 80 then
      velZ = -velZ
    end
    ball:setPosition(balX,balY,balZ)
  end
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
    local x,y,z = ball:getPosition()
    camera:pointTo(x,y+1,z)
  end
  ----MOVE CAMERA (KEYBOARD)----
  local moveSpeed = 15
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(moveSpeed*timeStep)
  end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-moveSpeed*timeStep)
  end
  if isKeyPressed(37) then --> VK_LEFT
    camera:rotStanding(0.4*timeStep)
  end
  if isKeyPressed(39) then --> VK_RIGHT
    camera:rotStanding(-0.4*timeStep)
  end
  local climbSpeed = 15
  if isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  end
  if isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
  end
  ----MOVE CAMERA (MOUSE)----
  local dx, dy = getMouseMove()
  local changeStep = 0.15*timeStep
  if dx ~= 0 then
    camera:rotStanding(-dx*changeStep)
  end
  if dy ~= 0 then
    camera:pitch(-dy*changeStep)
  end
end

----FINALIZATION----
function final()
  ----EMPTY WORLD----
  disableFog()
  empty()
  ----COLLIDERS----
  if ballCollider then
    ballCollider:delete()
    ballCollider = nil
  end
  if terrainCollider then
    terrainCollider:delete()
    terrainCollider = nil
  end
  ----GLOBALS----
  remTimeStep = nil
  velX, velY, velZ = nil, nil, nil
  ball = nil
  rotateView = nil
end

----KEYBOARD----
function keyDown(key)
  if isKeyPressed(string.byte(" ")) then
    releaseKey(string.byte(" "))
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  elseif isKeyPressed(string.byte("\r")) then
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
