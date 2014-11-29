----EMBOSS BUMP MAPPING
----Simple Bump Mapping Sample
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----GLOBALS----
  speed = 0
  ----CAMERA----
  setAmbient(.25,.25,.25)
  setPerspective(60,.5,1500)
  enableFog(500, 0,0,0)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,0,-6)
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
  ----PLANET----
  local planet = zip:getBumpedMesh("sphere.3ds")
  local material = planet:getBumpedMaterial()
  material:setBumpedTexture(zip:getBumpedTexture("logoBump.png"))
  material:setGlossTexture(zip:getTexture("logoBump.png"))
  material:setEnvironmentTexture(zip:getTexture("stars.jpg"),0.25)
  material:setShininess(128)
  planet:move(0,-1,0)
  addObject(planet)
  ----STAR----
  star = Light(zip:getTexture("light.jpg"),1)
  star:move(-8,0,0)
  addLight(star)
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
  showHelpUser()
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
  ----MOVE LIGHT----
  local starStep = 5.0265*timeStep
  local starAngle = 0.6283*timeStep
  star:moveForward(starStep)
  star:rotStanding(starAngle)
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
  star = nil
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
