----OUTER SPACE
----Space Sim Environment
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----GLOBALS----
  speed = 0
  ----CAMERA----
  setAmbient(.25,.25,.25)
  setPerspective(60,.5,3000)
  enableFog(500, 0,0,0)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,0,-10)
  empty()
  ----STARFIELD----
  if not fileExists("DemoPack0.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack0.dat' not found.")
  end
  local zip = Zip("DemoPack0.dat")
  local starfield = StarField(50,6000,zip:getTexture("stars.jpg"),20)
  setBackground(starfield)
  ----MUSIC----
  soundTrack = zip:getMusic("dvorak.mid")
  soundTrack:setVolume(255)
  soundTrack:setLooping(1)
  soundTrack:play()
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0,.41,.91,
    zip:getTexture("lensflares.png"),
    5, 0.2
  )
  sun:setColor(1,1,.5)
  setSun(sun)
  ----FOOT----
  foot1 = zip:getMesh("foot.3ds")
  foot1:getMaterial():setShininess(128)
  foot1:move(0,0,0)
  addObject(foot1)
  foot2 = foot1:clone()
  foot2:getMaterial():setShininess(128)
  foot2:move(-15,0,10)
  addObject(foot2)
  foot3 = foot1:clone()
  foot3:getMaterial():setShininess(128)
  foot3:move(15,0,10)
  addObject(foot3)
  ----SET HELP----
  local help = {
    "[MOUSE] Change Direction",
    "[ UP  ] Increase Speed",
    "[DOWN ] Decrease Speed",
    "[LEFT ] Roll Left",
    "[RIGHT] Roll Right",
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
  camera:moveForward(speed*timeStep)
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
  ----MOVE FOOTS----
  local angle = timeStep*.25
  foot1:roll(angle)
  foot2:yaw(angle)
  foot3:pitch(angle)
  ----MOVE CAMERA (KEYBOARD)----
  if isKeyPressed(38) then --> VK_UP
    speed = speed + 15*timeStep;
    if speed > 50 then
      speed = 50
    end
  end
  if isKeyPressed(40) then --> VK_DOWN
    speed = speed - 15*timeStep;
    if speed < -50 then
      speed = -50
    end
  end
  if isKeyPressed(37) then --> VK_LEFT
    camera:roll(-0.4*timeStep)
  end
  if isKeyPressed(39) then --> VK_RIGHT
    camera:roll(0.4*timeStep)
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
    camera:yaw(-dx*changeStep)
  end
  if dy ~= 0 then
    camera:pitch(-dy*changeStep)
  end
end

----FINALIZATION----
function final()
  ----DELETE GLOBALS----
  speed = nil
  rotateView = nil
  foot1 = nil
  foot2 = nil
  foot3 = nil
  ----STOP MUSIC----
  if soundTrack then
    soundTrack:stop()
    soundTrack:delete()
    soundTrack = nil
  end
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----SCENE SETUP----
setScene(Scene(init,update,final))

