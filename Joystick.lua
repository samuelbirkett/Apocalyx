----JOYSTICK DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  showConsole(false)
  print("\nPress 'ENTER' to go back to demos menu")
  print("This script is not tested yet and may contain bugs!")
  print("Please, report malfunctions to <tetractys@users.sf.net>")
  numJoy = getJoysticksCount()
  print("Joysticks connected:",numJoy)
  joys = {}
  axes = {}
  balls = {}
  hats = {}
  buttons = {}
  for ct = 0, numJoy-1 do
    print("Joystick",ct,"Name:",getJoystickName(ct))
    local joy = Joystick(ct)
    joys[ct] = joy
    axes[ct] = joy:getAxesCount()
    balls[ct] = joy:getBallsCount()
    hats[ct] = joy:getHatsCount()
    buttons[ct] = joy:getButtonsCount()
  end
end

----LOOP----
function update()
  updateJoysticks()
  for ct = 0, numJoy-1 do
    for axesCt = 0, axes[ct]-1 do
      local axis = joys[ct]:getAxis(axesCt)
      if axis ~= 0 then
        print("Joy",ct,"Axis",axesCt,"=",axis)
      end
    end
    for ballsCt = 0, balls[ct]-1 do
      local dx, dy = joys[ct]:getBall(ballsCt)
      if dx ~= 0 or dy ~= 0 then
        print("Joy",ct,"Ball",ballsCt,"=",dx,",",dy)
      end
    end
    for hatsCt = 0, hats[ct]-1 do
      local up, right, down, left = joys[ct]:getHat(hatsCt)
      if up or right or down or left then
        print("Joy",ct,"Hat",hatsCt,"=",up,",",right,",",down,",",left)
      end
    end
    for buttonsCt = 0, buttons[ct]-1 do
      local pressed = joys[ct]:isButtonPressed(buttonsCt)
      if pressed then
        print("Joy",ct,"Button",buttonsCt,"=",pressed)
      end
    end
  end
end

----FINALIZATION----
function final()
  for ct = 0, numJoy-1 do
    joys[ct]:delete()
    joys[ct] = nil
  end
  joys = nil
  axes = nil
  balls = nil
  hats = nil
  buttons = nil
  numJoy = nil
end

----KEYDOWN----
function keyDown(key)
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    hideConsole()
    final()
    dofile("main.lua")
    return
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
