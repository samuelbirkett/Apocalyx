----Collection of GLSL Demos
----Questions? Contact: Leonardo Boselli <boselli@uno.it>

ALL = {}
PARALLAX_MAPPING = {}
BRICKS = {}
TOON_SHADING = {}
TOON_MD3 = {}
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
  sky:rotStanding(3.14159)
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
  ----MOVE OBJECT----
  local moveSpeed = 3
  local climbSpeed = 3
  if isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  end
  if isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
  end
  if isKeyPressed(string.byte("A")) then
    object:move(moveSpeed*timeStep,0,0)
  end
  if isKeyPressed(string.byte("S")) then
    object:move(-moveSpeed*timeStep,0,0)
  end
  if isKeyPressed(string.byte("W")) then
    object:move(0,0,moveSpeed*timeStep)
  end
  if isKeyPressed(string.byte("Z")) then
    object:move(0,0,-moveSpeed*timeStep)
  end
  if isKeyPressed(36) then ---> VK_HOME
    object:move(0,climbSpeed*timeStep,0)
  elseif isKeyPressed(35) then ---> VK_END
    object:move(0,-climbSpeed*timeStep,0)
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


----PARALLAX MAPPING
----Parallax Mapping on a Sphere

----INITIALIZATION----
function PARALLAX_MAPPING.init()
  if not isFragmentShaderSupported() then
    showConsole()
    error("\nFragment shaders not supported by your OpenGL drivers")
  end
  setTitle("Parallax Demo")
  ----
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
  ----
  ----ROCKWALL----
  local vertexShader = VertexShader(readFile("parallax.vs"))
  local fragmentShader = FragmentShader(readFile("parallax.fs"))
  local shaderProgram = ShaderProgram()
  shaderProgram:attach(vertexShader)
  shaderProgram:attach(fragmentShader)
  if not shaderProgram:link() then
    showConsole()
    error(shaderProgram:getInfo())
  end
  local shaderMaterial = ShaderMaterial()
  shaderMaterial:setShaderProgram(shaderProgram)
  shaderMaterial:setDiffuseTexture(zip:getTexture("rockwall.jpg"))
  shaderMaterial:setGlossTexture(zip:getTexture("rockwallHeight.png"))
  shaderProgram:apply()
  shaderProgram:setUniformInt(shaderProgram:getUniformLocation("basetex"),0)
  shaderProgram:setUniformInt(shaderProgram:getUniformLocation("bumptex"),1)
  useFixedPipeline()
  object = zip:getShaderMeshes("cube.obj")
  object:getFirstMesh()
  object:getNextMesh():setMaterial(shaderMaterial)
  object:move(0,2,0)
  addObject(object)
  ----HELP----
  local help = {
    "Title : Parallax Mapping Demo",
    "Engine: http://apocalyx.sf.net",
    "Author: Leonardo Boselli",
    "E-mail: tetractys@users.sf.net",
    " ",
    "[  SPACE  ] Rotate Around Object",
    "[  MOUSE  ] Look Around",
    "[ UP/DOWN ] Move Camera Forward/Back",
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
function PARALLAX_MAPPING.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function PARALLAX_MAPPING.final()
  ----GLOBALS----
  object = nil
  ----
  ALL.final()
end

----KEY_DOWN----
function PARALLAX_MAPPING.keyDown(key)
  ALL.keyDown(key)
end


----BRICKS
----Bricks

----INITIALIZATION----
function BRICKS.init()
  if not isFragmentShaderSupported() then
    showConsole()
    error("\nFragment shaders not supported by your OpenGL drivers")
  end
  setTitle("Bricks Demo")
  ----
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
  ----
  ----BRICKS----
  local vertexShader = VertexShader(readFile("bricks.vs"))
  local fragmentShader = FragmentShader(readFile("bricks.fs"))
  shaderProgram = ShaderProgram()
  shaderProgram:attach(vertexShader)
  shaderProgram:attach(fragmentShader)
  if not shaderProgram:link() then
    showConsole()
    error(shaderProgram:getInfo())
  end
  local shaderMaterial = ShaderMaterial()
  shaderMaterial:setShaderProgram(shaderProgram)
  shaderProgram:apply()
  shaderProgram:setUniformFloats(
    shaderProgram:getUniformLocation("BrickColor"), 1,0.3,0.2)
  shaderProgram:setUniformFloats(
    shaderProgram:getUniformLocation("MortarColor"), 0.85,0.86,0.84)
  brickWidth = 0.3
  shaderProgram:setUniformFloats(
    shaderProgram:getUniformLocation("BrickSize"), brickWidth,brickWidth*0.5)
  shaderProgram:setUniformFloats(
    shaderProgram:getUniformLocation("BrickPct"), 0.9,0.85)
  shaderProgram:setUniformFloats(
    shaderProgram:getUniformLocation("MortarPct"), 0.1,0.15)
  shaderProgram:setUniformFloats(
    shaderProgram:getUniformLocation("LightPosition"), 0,10,10)
  useFixedPipeline()
  object = zip:getShaderMesh("dragon.3ds")
  object:rotStanding(3.1415)
  object:setMaterial(shaderMaterial)
  object:move(0,0,0)
  addObject(object)
  ----HELP----
  local help = {
    "Title : Bricks Demo",
    "Engine: http://apocalyx.sf.net",
    "Author: Leonardo Boselli",
    "E-mail: tetractys@users.sf.net",
    " ",
    "[  SPACE  ] Rotate Around Object",
    "[  MOUSE  ] Look Around",
    "[ UP/DOWN ] Move Camera Forward/Back",
    "[PREV/NEXT] Raise/Lower Camera",
    "[ W,A,S,Z ] Move Object Around",
    "[HOME/END ] Raise/Lower Object",
    "[   X,C   ] Brick Size +/-",
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
function BRICKS.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ----KEYBOARD----
  if isKeyPressed(string.byte("X")) then
    brickWidth = brickWidth+0.05*timeStep
    shaderProgram:apply()
    shaderProgram:setUniformFloats(
      shaderProgram:getUniformLocation("BrickSize"), brickWidth,brickWidth*0.5)
    useFixedPipeline()
  elseif isKeyPressed(string.byte("C")) then
    brickWidth = brickWidth-0.05*timeStep
    shaderProgram:apply()
    shaderProgram:setUniformFloats(
      shaderProgram:getUniformLocation("BrickSize"), brickWidth,brickWidth*0.5)
    useFixedPipeline()
  end
  ----
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function BRICKS.final()
  ----GLOBALS----
  brickWidth = nil
  shaderProgram = nil
  object = nil
  ----
  ALL.final()
end

----KEY_DOWN----
function BRICKS.keyDown(key)
  ALL.keyDown(key)
end


----TOON SHADING (Mesh)
----Toon effect on mesh

----INITIALIZATION----
function TOON_SHADING.init()
  if not isFragmentShaderSupported() then
    showConsole()
    error("\nFragment shaders not supported by your OpenGL drivers")
  end
  setTitle("Toon Shading")
  ----
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
  ----TOON----
  local vertexShader = VertexShader(readFile("toon.vs"))
  local fragmentShader = FragmentShader(readFile("toon.fs"))
  shaderProgram = ShaderProgram()
  shaderProgram:attach(vertexShader)
  shaderProgram:attach(fragmentShader)
  if not shaderProgram:link() then
    showConsole()
    error(shaderProgram:getInfo())
  end
  shaderProgram:apply()
  shaderProgram:setUniformInt(shaderProgram:getUniformLocation("diffuse"),0)
  useFixedPipeline()
  local shaderMaterial = ShaderMaterial()
  shaderMaterial:setShaderProgram(shaderProgram)
  object = zip:getShaderMesh("dragon.3ds")
  object:rotStanding(3.1415)
  object:setMaterial(shaderMaterial)
  object:move(0,0,0)
  addObject(object)
  ----HELP----
  local help = {
    "Title : Toon Shading Demo",
    "Engine: http://apocalyx.sf.net",
    "Author: Leonardo Boselli",
    "E-mail: tetractys@users.sf.net",
    " ",
    "[  SPACE  ] Rotate Around Object",
    "[  MOUSE  ] Look Around",
    "[ UP/DOWN ] Move Camera Forward/Back",
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
function TOON_SHADING.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ----
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function TOON_SHADING.final()
  ----GLOBALS----
  shaderProgram = nil
  object = nil
  ----
  ALL.final()
end

----KEY_DOWN----
function TOON_SHADING.keyDown(key)
  ALL.keyDown(key)
end


----TOON SHADING (Model)
----Toon effect on model

----INITIALIZATION----
function TOON_MD3.init()
  if not isFragmentShaderSupported() then
    showConsole()
    error("\nFragment shaders not supported by your OpenGL drivers")
  end
  setTitle("Toon Shading")
  ----
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
  ---TOON---
  local vertexShader = VertexShader(readFile("toonTex.vs"))
  local fragmentShader = FragmentShader(readFile("toonTex.fs"))
  shaderProgram = ShaderProgram()
  shaderProgram:attach(vertexShader)
  shaderProgram:attach(fragmentShader)
  if not shaderProgram:link() then
    showConsole()
    error(shaderProgram:getInfo())
  end
  local shaderMaterial = ShaderMaterial()
  shaderMaterial:setShaderProgram(shaderProgram)
  shaderMaterial:addTexture(zip:getTexture("dogToon.jpg"))
  ----MODELS----
  local anims = {
     1,13, 12, 15,
    15,23, 8, 15,
    25,59, 34, 15,
  }
  animation = 2
  object = zip:getModel("dog.md3","dog.jpg")
  object:setMaterial(shaderMaterial)
  object:setAnimations(anims)
  object:rescale(0.04)
  object:pitch(-1.5708)
  object:rotStanding(-1.2)
  object:move(0,0,0)
  object:setAnimation(animation)
  addObject(object)
  ----HELP----
  local help = {
    "The model of this tutorial was made by:",
    "  Psionic <http://www.psionicdesign.com>",
    " ",
    "[  MOUSE  ] Look around",
    "[ UP/DOWN ] Move Forward/Back",
    "[PREV/NEXT] Raise/Lower View",
    "[  Z key  ] Change Animations",
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
function TOON_MD3.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ----MODEL----
  object:updateAnimation()
  ----
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function TOON_MD3.final()
  ----GLOBALS----
  shaderProgram = nil
  object = nil
  ----
  ALL.final()
end

----KEYBOARD----
function TOON_MD3.keyDown(key)
  if key == string.byte("Z") then
    releaseKey(string.byte("Z"))
    animation = animation+1
    if animation >= 3 then ---> MAX_ANIMATIONS
      animation = 0
    end
    object:setAnimation(animation)
  end
  ALL.keyDown(key)
end


----MAIN MENU
----

----INITIALIZATION----Sets the help strings
function MENU.init()
  empty()
  demos = {
    PARALLAX_MAPPING,
    BRICKS,
    TOON_SHADING,
    TOON_MD3,
  }
  local help = {
    "OpenGL Shading Language Demos",
    "",
    "[  1  ] Parallax Mapping",
    "[  2  ] Procedural Bricks",
    "[  3  ] Toon Shading (Mesh)",
    "[  4  ] Toon Shading (Model)",
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
