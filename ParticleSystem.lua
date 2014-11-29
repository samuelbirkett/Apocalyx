----Collection of Particle System Demos
----Questions? Contact: Leonardo Boselli <boselli@uno.it>

ALL = {}
FIRE_AND_SNOW = {}
BOUNCE = {}
MENU = {}

----Common functions

function ALL.init()
  rotateView = true
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack2.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack2.dat' not found.")
  end
  local zip = Zip("DemoPack2.dat")
  local skyTxt = {
    zip:getTexture("left3.jpg"),
    zip:getTexture("front3.jpg"),
    zip:getTexture("right3.jpg"),
    zip:getTexture("back3.jpg"),
    zip:getTexture("top3.jpg"),
    zip:getTexture("bottom3.jpg")
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
  terrainMaterial:setDiffuse(0,0,0)
  terrainMaterial:setDiffuseTexture(zip:getTexture("desert.jpg",1))
  local ground = FlatTerrain(terrainMaterial,500,125)
  ground:setShadowed()
  ground:setShadowOffset(0.01)
  setTerrain(ground)
  terrainMaterial:delete()
  --------
  return zip
end

function ALL.update(camera,timeStep)
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
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
  ----
end

function ALL.final()
  setTitle("APOCALYX 3D Engine")
  rotateView = nil
  ----EMPTY WORLD----
  empty()
end

function ALL.keyDown(key)
  if key == string.byte("\r") then
  ----LOAD MAIN MENU----
    releaseKey(key)
    setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
  elseif key == string.byte(" ") then
  ----ROTATE VIEW----
    releaseKey(key)
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  end
end

----SUPPORT----
function readFile(fileName)
  local file = io.open(fileName,"r")
  local source = file:read("*a")
  file:close()
  return source
end


----FIRE_AND_SNOW
----Fire & Snow Demo 

----INITIALIZATION----
function FIRE_AND_SNOW.init()
  setTitle("Fire & Snow Demo")
  ----
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,.1,1000)
  enableFog(200, .522,.373,.298)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1,-10)
  camera:pointTo(0,2,0)
  ----OBJECT----
  object = zip:getMeshes("cube.obj")
  object:move(0,3,0)
  addObject(object)
  ----PARTICLE MATERIAL----
  local fireImage = zip:getImage("smoke.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage,false,false)
  fireImage:delete()
  local mat = Material()
  mat:setEnlighted(false)
  mat:setEmissive(1,1,1)
  mat:setDiffuseTexture(fireTexture)
  ----PARTICLE_SYSTEM----
  particleSystem = ParticleSystem()
  ----PARTICLE GROUP 1----
  particleGroup = particleSystem:createParticleGroup()
  particleGroup:setMaxRadius(10)
  particleGroup:setMaterial(mat)
  particleGroup:setTransparent()
  particleGroup:setMaxParticles(1000)
  particleGroup:setConstColor(false)
  particleGroup:setConstSize(false)
  particleGroup:setSizeScale(1)
  particleGroup:setMode(3)
  addObject(particleGroup)
  obstacleDomain = ParticleSphere(0,3,0, 1.25)
  sourceDomain = ParticleRectangle(-1,-0.5,-1, 2,0,0, 0,0,2)
  actionList = particleSystem:generateActionList()
  particleSystem:newActionList(actionList)
  particleSystem:setColor(1,1,0)
  particleSystem:targetColor(1,0,0,0, 5)
  particleSystem:setSize(0.5,0.5,0.5)
  particleSystem:targetSize(0,0,0, 0.25,0.25,0.25)
  particleSystem:setVelocity(0,3,0)
  particleSystem:killOld(2)
  particleSystem:source(250,sourceDomain)
  particleSystem:endActionList()
  ----PARTICLE GROUP 2----
  particleGroup2 = particleSystem:createParticleGroup()
  particleGroup2:setMaxRadius(10)
  particleGroup2:setMaterial(mat)
  particleGroup2:setTransparent()
  particleGroup2:setMaxParticles(1000)
  particleGroup2:setSizeScale(0.1)
  particleGroup2:setMode(3)
  addObject(particleGroup2)
  obstacleDomain2 = ParticlePlane(0,0.1,0, 0,1,0)
  sourceDomain2 = ParticleRectangle(-10,10,-10, 20,0,0, 0,0,20)
  velDomain2 = ParticleSphere(-2,-10,-1, 1)
  actionList2 = particleSystem:generateActionList()
  particleSystem:newActionList(actionList2)
  particleSystem:setVelocityDomain(velDomain2)
  particleSystem:killOld(1.5)
  particleSystem:source(50,sourceDomain2)
  particleSystem:sink(false, obstacleDomain2)
  particleSystem:endActionList()
  ----HELP----
  local help = {
    "Title : Fire & Snow Demo",
    "Engine: http://apocalyx.sf.net",
    "Author: Leonardo Boselli",
    "E-mail: tetractys@users.sf.net",
    " ",
    "[  SPACE  ] Rotate Around Object",
    "[  MOUSE  ] Look Around",
    "[ UP/DOWN ] Move Camera Forward/Back",
    "[PREV/NEXT] Raise/Lower Camera",
    "[   0-4   ] Change Mode",
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
function FIRE_AND_SNOW.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ALL.update(camera,timeStep)
  particleSystem:setCurrentGroup(particleGroup)
  particleSystem:setTimeStep(timeStep)
  particleSystem:callActionList(actionList)
  particleSystem:move()
  particleSystem:setCurrentGroup(particleGroup2)
  particleSystem:setTimeStep(timeStep)
  particleSystem:callActionList(actionList2)
  particleSystem:move()
end

----FINALIZATION----
function FIRE_AND_SNOW.final()
  ----GLOBALS----
  object = nil
  particleGroup:delete()
  particleGroup = nil
  particleGroup2:delete()
  particleGroup2 = nil
  obstacleDomain:delete()
  sourceDomain:delete()
  obstacleDomain2:delete()
  sourceDomain2:delete()
  velDomain2:delete()
  obstacleDomain = nil
  sourceDomain = nil
  obstacleDomain2 = nil
  sourceDomain2 = nil
  velDomain2 = nil
  particleSystem:deleteActionList(actionList)
  particleSystem:deleteActionList(actionList2)
  actionList = nil
  actionList2 = nil
  particleSystem:delete()
  particleSystem = nil
  ----
  disableFog()
  ALL.final()
end

----KEY_DOWN----
function FIRE_AND_SNOW.keyDown(key)
  ALL.keyDown(key)
  if key >= string.byte("0") and key <= string.byte("4") then
    particleGroup:setMode(key-string.byte("0"))
    particleGroup2:setMode(key-string.byte("0"))
  end
end


----BOUNCE
----Bounce Demo 

----INITIALIZATION----
function BOUNCE.init()
  setTitle("Bounce Demo")
  ----
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,.1,1000)
  enableFog(200, .522,.373,.298)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1,-10)
  camera:pointTo(0,2,0)
  ----OBJECT----
  object = zip:getMeshes("cube.obj")
  object:move(0,3,0)
  addObject(object)
  ----PARTICLE MATERIAL----
  local fireImage = zip:getImage("smoke.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage,false,false)
  fireImage:delete()
  local mat = Material()
  mat:setEnlighted(false)
  mat:setEmissive(1,1,1)
  mat:setDiffuseTexture(fireTexture)
  ----PARTICLE_SYSTEM----
  particleSystem = ParticleSystem()
  ----PARTICLE GROUP----
  particleGroup = particleSystem:createParticleGroup()
  particleGroup:setMaxRadius(10)
  particleGroup:setMaterial(mat)
  particleGroup:setTransparent()
  particleGroup:setMaxParticles(1000)
  particleGroup:setConstColor(false)
  particleGroup:setConstSize(false)
  particleGroup:setSizeScale(0.2)
  particleGroup:setMode(3)
  addObject(particleGroup)
  obstacleDomain = ParticleSphere(0,3,0, 1.5)
  planeDomain = ParticlePlane(0,0.1,0, 0,1,0)
  sourceDomain = ParticlePoint(0,0.1,0)
  velDomain = ParticleSphere(0,10,0, 5)
  actionList = particleSystem:generateActionList()
  particleSystem:newActionList(actionList)
  particleSystem:setColor(0.3,0.2,0.2)
  particleSystem:targetColor(0.3,0,0,0, 1)
  particleSystem:setSize(1,1,1)
  particleSystem:targetSize(0,0,0, 0.25,0.25,0.25)
  particleSystem:setVelocityDomain(velDomain)
  particleSystem:killOld(4)
  particleSystem:source(250,sourceDomain)
  particleSystem:gravity(0,-10,0)
  particleSystem:bounce(0.2,0.8,0, planeDomain)
  particleSystem:avoid(4,2, obstacleDomain)
  particleSystem:endActionList()
  ----HELP----
  local help = {
    "Title : Bounce Demo",
    "Engine: http://apocalyx.sf.net",
    "Author: Leonardo Boselli",
    "E-mail: tetractys@users.sf.net",
    " ",
    "[  SPACE  ] Rotate Around Object",
    "[  MOUSE  ] Look Around",
    "[ UP/DOWN ] Move Camera Forward/Back",
    "[PREV/NEXT] Raise/Lower Camera",
    "[   0-4   ] Change Mode",
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
function BOUNCE.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ALL.update(camera,timeStep)
  particleSystem:setCurrentGroup(particleGroup)
  particleSystem:setTimeStep(timeStep)
  particleSystem:callActionList(actionList)
  particleSystem:move()
end

----FINALIZATION----
function BOUNCE.final()
  ----GLOBALS----
  object = nil
  particleGroup:delete()
  particleGroup = nil
  obstacleDomain:delete()
  obstacleDomain = nil
  planeDomain:delete()
  planeDomain = nil
  sourceDomain:delete()
  sourceDomain = nil
  velDomain:delete()
  velDomain = nil
  particleSystem:deleteActionList(actionList)
  actionList = nil
  particleSystem:delete()
  particleSystem = nil
  ----
  disableFog()
  ALL.final()
end

----KEY_DOWN----
function BOUNCE.keyDown(key)
  ALL.keyDown(key)
  if key >= string.byte("0") and key <= string.byte("4") then
    particleGroup:setMode(key-string.byte("0"))
  end
end


----MAIN MENU
----

----INITIALIZATION----Sets the help strings
function MENU.init()
  empty()
  demos = {
    FIRE_AND_SNOW,
    BOUNCE,
  }
  local help = {
    "Particle System Demos",
    "",
    "[  1  ] Fire & Snow",
    "[  2  ] Bounce",
    "",
    "[ENTER] Back to Menu",
    "[ ESC ] Exit",
  }
  setHelp(help)
  hideConsole()
  showHelpUser()
end

----LOOP----Does nothing
function MENU.update()
end

----KEY_DOWN----Checks the keyboard and starts demos
function MENU.keyDown(key)
  local theKey = key-string.byte("0")
  if theKey >= 1 and theKey <= table.getn(demos) then
    releaseKey(theKey)
    local DEMO = demos[theKey]
    setScene(Scene(DEMO.init,DEMO.update,DEMO.final,DEMO.keyDown))
  end
  ----LOAD MAIN MENU----
  if key == string.byte("\r") then
    releaseKey(string.byte("\r"))
    if fileExists("main.lua") then
      MENU.final()
      dofile("main.lua")
    end
    return
  end
end

----FINALIZATION----None
function MENU.final()
  demos = nil
end

----SCENE SETUP----
setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
