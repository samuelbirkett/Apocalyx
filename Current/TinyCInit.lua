----Functions mixture: "init" in C, the others in LUA
----Questions? Contact: leo <tetractys@users.sf.net>

cc = Compiler()

ok = cc:compileFile("TinyCInit.c")
if ok then
  ok = cc:link()
end
if ok then
  c_init = cc:getFunction("init")
  c_moveUpTransform = cc:getFunction("moveUpTransform")
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
    c_moveUpTransform(camera:getPointer(), climbSpeed*timeStep)
  end
  if isKeyPressed(34) then --> VK_NEXT
    c_moveUpTransform(camera:getPointer(), -climbSpeed*timeStep)
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

----FINAL----
function final()
  ----DELETE GLOBALS----
  rotateView = nil
  cc = nil
  c_init = nil
  ok = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----KEYDOWN----
function keyDown(key)
  ----LOAD MAIN MENU----
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    final()
    dofile("main.lua")
    return
  end
  if isKeyPressed(string.byte(" ")) then
    releaseKey(string.byte(" "))
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  end
end

----SCENE SETUP----
if c_init then
  setScene(Scene(c_init,update,final,keyDown))
end
