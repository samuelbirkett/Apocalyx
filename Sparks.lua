----Sparks
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  rotateView = true
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, .522,.373,.298)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2,-7.5)
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
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(zip:getTexture("desert.jpg",1))
  local ground = FlatTerrain(terrainMaterial,500,125)
  ground:setShadowed()
  ground:setShadowOffset(0.01)
  setTerrain(ground)
  terrainMaterial:delete()
  ----SPARKS----
  local spark
  spark = Spark(2, 1,-2)
  spark:setColor(0.1,0.1,0.4)
  spark:setSegmentsOffset(2,0.2,0.1)
  spark:setSegmentsCount(16)
  spark:setUpdateTime(0.05)
  spark:move(-2, 1,-2)
  addObject(spark)
  --
  spark = Spark( 2, 1,-2)
  spark:setColor(0.4,0.1,0.1)
  spark:setSegmentsOffset(1,0.2,0.1)
  spark:setSegmentsCount(12)
  spark:setUpdateTime(0.075)
  spark:move( 0, 1, 2)
  addObject(spark)
  --
  spark = Spark(-2, 1,-2)
  spark:setColor(0.1,0.4,0.1)
  spark:setSegmentsOffset(0.5,0.5,0.1)
  spark:setSegmentsCount(8)
  spark:setUpdateTime(0.1)
  spark:move( 0, 1, 2)
  addObject(spark)
  --
  spark = Spark( 0, 4, 0)
  spark:setColor(0.6,0.1,0.6)
  spark:setSparksOffset(0.1)
  spark:setWidth(0.02)
  spark:move( 2, 1,-2)
  addObject(spark)
  --
  spark = Spark( 0, 4, 0)
  spark:setColor(0.4,0.4,0.1)
  spark:setSparksOffset(0.075)
  spark:setWidth(0.04)
  spark:move(-2, 1,-2)
  addObject(spark)
  --
  spark = Spark( 0, 4, 0)
  spark:setColor(0.1,0.4,0.4)
  spark:setSparksOffset(0.05)
  spark:setWidth(0.08)
  spark:move( 0, 1, 2)
  addObject(spark)
  ----HELP----
  local help = {
    "[  MOUSE  ] Look around",
    "[ UP/DOWN ] Move Forward/Back",
    "[PREV/NEXT] Raise/Lower View",
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
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  local fwdSpeed = 0
  local rotSpeed = 0
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
    camera:pointTo(0,2,0)
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
  ----DELETE GLOBALS----
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
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
