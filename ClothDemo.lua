----CLOTH DEMO
----A simulator of cloths
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----GLOBALS----
  windSpeed = 4
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(75,.5,3000)
  enableFog(1000, .4,.4,1)
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
    0.0, 0.41, 0.91,
    zip:getTexture("lensflares.png"),
    4, 0.2
  )
  setSun(sun)

end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()

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
  ----DELETE GLOBALS----
  flag = nil
  if clothEnvironment then
    clothEnvironment:delete()
    clothEnvironment = nil
  end
  if simulator then
    simulator:delete()
    simulator = nil
  end
  if flagSource then
    flagSource:getSound3D():stop()
    flagSource = nil
  end
  windSpeed = nil
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----SCENE SETUP----
setScene(Scene(init,update,final))

