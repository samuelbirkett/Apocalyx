----FIRE & SMOKE 2
----Particle System Example
----Questions? Contact: leo <tetractys@users.sf.net>

----CALLBACKS----
function initVars()
  _oneShot = false
  _particlesCount = 15
  _maxLife = 3
  _startColor = 255*256^3
  _endColor = 0
  _textureIndex = 0
  _shapeIndex = 0
  _shapeSize = 0
  _velX = 2
  _velY = 1
  _velZ = -0.5
  _velVar = 0.5
  _startSize = 1.5
  _endSize = 5
  _aX = 0
  _aY = 0
  _aZ = 0
  _bX = 0
  _bY = 3
  _bZ = 0
  _startRadius = 0
  _endRadius = 0
  _startAngular = 0
  _endRadius = 0
end
function termVars()
  _oneShot = nil
  _particlesCount = nil
  _maxLife = nil
  _startColor = nil
  _endColor = nil
  _textureIndex = nil
  _shapeIndex = nil
  _shapeSize = nil
  _velX = nil
  _velY = nil
  _velZ = nil
  _velVar = nil
  _startSize = nil
  _endSize = nil
  _aX = nil
  _aY = nil
  _aZ = nil
  _bX = nil
  _bY = nil
  _bZ = nil
  _startRadius = nil
  _endRadius = nil
  _startAngular = nil
  _endAngular = nil
end

function resetCallback()
  emitter:reset()
end

function timeGetCallback()
  return math.floor(getElapsedTime())
end

function oneShotSetCallback(v)
  _oneShot = v
  emitter:setOneShot(v)
end
function oneShotGetCallback()
  return _oneShot
end

function hSetCallback(v)
  local x,_,z = emitter:getPosition()
  emitter:setPosition(x,v,z)
end
function hGetCallback()
  local _,h,_ = emitter:getPosition()
  return h
end

function particlesSetCallback(v)
  _particlesCount = v
  emitter:setParticlesCount(v)
end
function particlesGetCallback()
  return _particlesCount
end

function maxLifeSetCallback(v)
  _maxLife = v
  emitter:setMaxLife(v)
end
function maxLifeGetCallback()
  return _maxLife
end

function startSizeSetCallback(v)
  _startSize = v
  emitter:setSize(_startSize,_endSize)
end
function startSizeGetCallback()
  return _startSize
end
function endSizeSetCallback(v)
  _endSize = v
  emitter:setSize(_startSize,_endSize)
end
function endSizeGetCallback()
  return _endSize
end

function startRadiusSetCallback(v)
  _startRadius = v
  emitter:setRadius(_startRadius,_endRadius)
end
function startRadiusGetCallback()
  return _startRadius
end
function endRadiusSetCallback(v)
  _endRadius = v
  emitter:setRadius(_startRadius,_endRadius)
end
function endRadiusGetCallback()
  return _endRadius
end

function startAngularSetCallback(v)
  _startAngular = v
  emitter:setAngularSpeed(_startAngular,_endAngular)
end
function startAngularGetCallback()
  return _startAngular
end
function endAngularSetCallback(v)
  _endAngular = v
  emitter:setAngularSpeed(_startAngular,_endAngular)
end
function endAngularGetCallback()
  return _endAngular
end

function speedXSetCallback(v)
  _velX = v
  emitter:setVelocity(_velX,_velY,_velZ,_velVar)
end
function speedXGetCallback()
  return _velX
end
function speedYSetCallback(v)
  _velY = v
  emitter:setVelocity(_velX,_velY,_velZ,_velVar)
end
function speedYGetCallback()
  return _velY
end
function speedZSetCallback(v)
  _velZ = v
  emitter:setVelocity(_velX,_velY,_velZ,_velVar)
end
function speedZGetCallback()
  return _velZ
end
function speedVarSetCallback(v)
  _velVar = v
  emitter:setVelocity(_velX,_velY,_velZ,_velVar)
end
function speedVarGetCallback()
  return _velVar
end

function aXSetCallback(v)
  _aX = v
  emitter:setGravity(_aX,_aY,_aZ,_bX,_bY,_bZ)
end
function aXGetCallback()
  return _aX
end
function aYSetCallback(v)
  _aY = v
  emitter:setGravity(_aX,_aY,_aZ,_bX,_bY,_bZ)
end
function aYGetCallback()
  return _aY
end
function aZSetCallback(v)
  _aZ = v
  emitter:setGravity(_aX,_aY,_aZ,_bX,_bY,_bZ)
end
function aZGetCallback()
  return _aZ
end
function bXSetCallback(v)
  _bX = v
  emitter:setGravity(_aX,_aY,_aZ,_bX,_bY,_bZ)
end
function bXGetCallback()
  return _bX
end
function bYSetCallback(v)
  _bY = v
  emitter:setGravity(_aX,_aY,_aZ,_bX,_bY,_bZ)
end
function bYGetCallback()
  return _bY
end
function bZSetCallback(v)
  _bZ = v
  emitter:setGravity(_aX,_aY,_aZ,_bX,_bY,_bZ)
end
function bZGetCallback()
  return _bZ
end

function intToColor(val)
  local c = val
  c = c/256
  local r = c-math.floor(c)
  c = c/256
  local g = c-math.floor(c)
  c = c/256
  local b = c-math.floor(c)
  c = c/256
  local a = c-math.floor(c)
  return r,g,b,a
end
function colorToInt(r,g,b,a)
  local c = a*256
  c = (c+b)*256
  c = (c+g)*256
  c = c+r
  return math.floor(c)
end

function startColorSetCallback(v)
  _startColor = v
  local startR, startG, startB, startA = intToColor(v)
  local endR, endG, endB, endA
  endR, endG, endB, endA = intToColor(_endColor)
  emitter:setColor(startR,startG,startB,startA,endR,endG,endB,endA)
end
function startColorGetCallback()
  return _startColor
end

function endColorSetCallback(v)
  _endColor = v
  local endR, endG, endB, endA = intToColor(v)
  local startR, startG, startB, startA
  startR, startG, startB, startA = intToColor(_startColor)
  emitter:setColor(startR,startG,startB,startA,endR,endG,endB,endA)
end
function endColorGetCallback()
  return _endColor
end

function textureSetCallback(v)
  local image
  if v == 0 then
    image = zip:getImage("smoke.jpg")
  elseif v == 1 then
    image = zip:getImage("light.jpg")
  else
    return
  end
  image:convertToGray()
  image:convertTo111A()
  local texture = Texture(image)
  image:delete()
  emitter:setTexture(texture,1)
  _textureIndex = v
end
function textureGetCallback()
  return _textureIndex
end

function shapeSetCallback(v)
  emitter:setShape(v)
  _shapeIndex = v
end
function shapeGetCallback()
  return _shapeIndex
end

function shapeSizeSetCallback(v)
  _shapeSize = v
  emitter:setShapeSize(v)
end
function shapeSizeGetCallback()
  return _shapeSize
end

----INITIALIZATION----
function init()
  ----VARS----
  initVars()
  ----CAMERA----
  setAmbient(.3,.3,.3)
  setPerspective(60,.5,1000)
  enableFog(500, .5,.5,.75)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
  camera:rotStanding(3.1415)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack1.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack1.dat' not found.")
  end
  zip = Zip("DemoPack1.dat")
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
--  terrain:setReflective()
  setTerrain(terrain)
  terrainMaterial:delete()
  ----SMOKE----
  local smokeImage = zip:getImage("smoke.jpg")
  smokeImage:convertToGray()
  smokeImage:convertTo111A()
  local smokeTexture = Texture(smokeImage)
  smokeImage:delete()
  emitter = Emitter(_particlesCount,_maxLife,30)
  emitter:setTexture(smokeTexture,1)
  emitter:setVelocity(_velX,_velY,_velZ, _velVar)
  local sR,sG,sB,sA = intToColor(_startColor)
  local eR,eG,eB,eA = intToColor(_endColor)
  emitter:setColor(sR,sG,sB,sA, eR,eG,eB,eA)
  emitter:setSize(_startSize,_endSize)
  emitter:setGravity(_aX,_aY,_aZ, _bX,_bY,_bZ)
  emitter:move(0,1,.75)
  emitter:reset()
  addObject(emitter)
  smokeTexture:delete()
  ----TWEAKBAR---
  acquireMouse(false)
  TweakBarInit()
  bar = TweakBar("Emitter")
  TweakBarDefine("Emitter label='Emitter Properties' fontSize=2")
  bar:addNumberVar("Elapsed Time",timeGetCallback,timeGetCallback,"readonly")
  bar:addButton("Reset",resetCallback,"")
  bar:addNumberVar("Particles",particlesSetCallback,particlesGetCallback,
    "min=1 max=100 step=5 keyIncr=p keyDecr=P")
  bar:addNumberVar("Max Life",maxLifeSetCallback,maxLifeGetCallback,
    "min=0.5 max=10 step=0.5 keyIncr=l keyDecr=L")
  bar:addBooleanVar("One Shot",oneShotSetCallback,oneShotGetCallback,"key=o")
  local enums = {0, "SMOKE", 1, "SPARKLE"}
  bar:addEnumVar("Texture",enums,textureSetCallback,textureGetCallback,"")
  bar:addNumberVar("H",hSetCallback,hGetCallback,
    "min=0 max=10 step=0.1 keyIncr=h keyDecr=H")
  bar:addNumberVar("Size: Start",startSizeSetCallback,startSizeGetCallback,
    "group='Size' min=0 max=5 step=0.1 keyIncr=s keyDecr=S")
  bar:addNumberVar("Size: End",endSizeSetCallback,endSizeGetCallback,
    "group='Size' min=0 max=5 step=0.1 keyIncr=e keyDecr=E")
  bar:addColorVar("Color: Start",startColorSetCallback,startColorGetCallback,"group='Color' alpha")
  bar:addColorVar("Color: End",endColorSetCallback,endColorGetCallback,"group='Color' alpha")
  bar:addNumberVar("Speed X",speedXSetCallback,speedXGetCallback,
    "group='Velocity' min=-25 max=25 step=0.5 keyIncr=x keyDecr=X")
  bar:addNumberVar("Speed Y",speedYSetCallback,speedYGetCallback,
    "group='Velocity' min=-25 max=25 step=0.5 keyIncr=y keyDecr=Y")
  bar:addNumberVar("Speed Z",speedZSetCallback,speedZGetCallback,
    "group='Velocity' min=-25 max=25 step=0.5 keyIncr=z keyDecr=Z")
  bar:addNumberVar("Speed Var.",speedVarSetCallback,speedVarGetCallback,
    "group='Velocity' min=0 max=25 step=0.5 keyIncr=v keyDecr=V")
  bar:addNumberVar("Start Ax",aXSetCallback,aXGetCallback,
    "group='Acceleration' min=-10 max=10 step=0.2")
  bar:addNumberVar("Start Ay",aYSetCallback,aYGetCallback,
    "group='Acceleration' min=-10 max=10 step=0.2")
  bar:addNumberVar("Start Az",aZSetCallback,aZGetCallback,
    "group='Acceleration' min=-10 max=10 step=0.2")
  bar:addNumberVar("End Ax",bXSetCallback,bXGetCallback,
    "group='Acceleration' min=-10 max=10 step=0.2")
  bar:addNumberVar("End Ay",bYSetCallback,bYGetCallback,
    "group='Acceleration' min=-10 max=10 step=0.2")
  bar:addNumberVar("End Az",bZSetCallback,bZGetCallback,
    "group='Acceleration' min=-10 max=10 step=0.2")
  bar:addNumberVar("Radius: Start",startRadiusSetCallback,startRadiusGetCallback,
    "group='Circular Motion' min=0 max=10 step=0.1")
  bar:addNumberVar("Radius: End",endRadiusSetCallback,endRadiusGetCallback,
    "group='Circular Motion' min=0 max=10 step=0.1")
  bar:addNumberVar("Speed: Start",startAngularSetCallback,startAngularGetCallback,
    "group='Circular Motion' min=-6 max=6 step=0.1")
  bar:addNumberVar("Speed: End",endAngularSetCallback,endAngularGetCallback,
    "group='Circular Motion' min=-6 max=6 step=0.1")
  local shapes = {
    0, "POINT", 1, "LINE", 2, "CIRCUMFERENCE", 3, "CIRCLE",
    4, "SQUARE", 5, "SPHERE SHELL", 6, "SPHERE", 7, "CUBE"}
  bar:addEnumVar("Shape: Type",shapes,shapeSetCallback,shapeGetCallback,
    "group='Emitting Area'")
  bar:addNumberVar("Shape: Size",shapeSizeSetCallback,shapeSizeGetCallback,
    "min=0 max=10 step=0.1 keyIncr=z keyDecr=Z group='Emitting Area'")
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
  ----TWEAKBAR----
  acquireMouse(true)
  bar:delete()
  TweakBarTerm()
  ----VARS----
  termVars()
  ----ZIP----
  zip:delete()
  zip = nil
  ----GLOBALS----
  emitter = nil
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----SCENE SETUP----
setScene(Scene(init,update,final))

