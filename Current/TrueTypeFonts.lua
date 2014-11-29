----True Type Fonts Demo
----Questions? Contact: Leonardo Boselli <boselli@uno.it>

ALL = {}
TTDEMO = {}

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
  setBackground(sky)
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, 0.9659,
    zip:getTexture("lensflares.png"),
    5, 0.2
  )
  sun:setColor(1,1,1);
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
  local speed = 30
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(speed*timeStep)
  end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-speed*timeStep)
  end
  local climbSpeed = 30
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
  ----
end

function ALL.final()
  setTitle("APOCALYX 3D Engine")
  rotateView = nil
  ----EMPTY WORLD----
  empty()
end

function ALL.keyDown(key)
  ----LOAD MAIN MENU----
  if key == string.byte("\r") then
    releaseKey(string.byte("\r"))
    if fileExists("main.lua") then
      dofile("main.lua")
    end
    return
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


----TrueType Fonts

----INITIALIZATION----
function TTDEMO.init()
  setTitle("True Type Fonts Demo")
  ----
  local zip = ALL.init()
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,.1,1000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,0,100)
  camera:rotStanding(3.1415)
  ----TEXTS----
  ttMonochrome = TrueTypeMonochrome("font-data/Vera.ttf",12,150)
  ttMonochrome:setHorizontalJustification(2)
  ttMonochrome:setForegroundColor(1,0,0)
  ttMonochrome:setBackgroundColor(1,1,1,0.25)
  --
  ttGrayscale = TrueTypeGrayscale("font-data/Vera.ttf",12,150)
  ttGrayscale:setHorizontalJustification(2)
  ttGrayscale:setForegroundColor(0,1,0)
  ttGrayscale:setBackgroundColor(1,1,1)
  --
  ttTranslucent = TrueTypeTranslucent("font-data/Vera.ttf",12,150)
  ttTranslucent:setHorizontalJustification(2)
  ttTranslucent:setForegroundColor(0,0,1)
  ttTranslucent:setBackgroundColor(1,1,1,0)
  --
  ttOutline = TrueTypeOutline("font-data/Vera.ttf",12,150)
  ttOutline:setHorizontalJustification(2)
  ttOutline:setForegroundColor(1,0,0)
  ttOutline:setBackgroundColor(1,1,1)
  --
  ttFilled = TrueTypeFilled("font-data/Vera.ttf",12,150)
  ttFilled:setHorizontalJustification(2)
  ttFilled:setForegroundColor(0,1,0)
  ttFilled:setBackgroundColor(1,1,1)
  --
  ttSolid = TrueTypeSolid("font-data/Vera.ttf",12,150)
  ttSolid:setHorizontalJustification(2)
  ttSolid:setForegroundColor(0,0,1)
  ttSolid:setBackgroundColor(1,1,1)
  ttSolid:setDepth(5)
  --
  local text
  --
  text = TrueTypeText("Monochrome",ttMonochrome)
  text:scale(0.5)
  text:setTransparent()
  text:move(0,40,0)
  addObject(text)
  text = TrueTypeText("Grayscale",ttGrayscale)
  text:scale(0.5)
  text:move(0,25,0)
  addObject(text)
  text = TrueTypeText("Translucent",ttTranslucent)
  text:scale(0.5)
  text:setTransparent()
  text:move(0,10,0)
  addObject(text)
  text = TrueTypeText("Outline",ttOutline)
  text:scale(0.5)
  text:move(0,-10,0)
  addObject(text)
  text = TrueTypeText("Filled",ttFilled)
  text:scale(0.5)
  text:move(0,-25,0)
  addObject(text)
  text = TrueTypeText("Solid",ttSolid)
  text:scale(0.5)
  text:move(0,-40,0)
  addObject(text)
  --
  local tt, tts
  tt = OverlayText("Monochrome")
  tts = OverlayTrueTypeTexts(ttMonochrome)
  tts:setTransparent()
  tts:add(tt)
  tts:setLocation(100,400)
  addToOverlay(tts)
  tt = OverlayText("Grayscale")
  tts = OverlayTrueTypeTexts(ttGrayscale)
  tts:add(tt)
  tts:setLocation(100,350)
  addToOverlay(tts)
  tt = OverlayText("Translucent")
  tts = OverlayTrueTypeTexts(ttTranslucent)
  tts:setTransparent()
  tts:add(tt)
  tts:setLocation(100,300)
  addToOverlay(tts)
  tt = OverlayText("Outline")
  tts = OverlayTrueTypeTexts(ttOutline)
  tts:add(tt)
  tts:setLocation(100,250)
  addToOverlay(tts)
  tt = OverlayText("Filled")
  tts = OverlayTrueTypeTexts(ttFilled)
  tts:add(tt)
  tts:setLocation(100,200)
  addToOverlay(tts)
  tt = OverlayText("Solid")
  tts = OverlayTrueTypeTexts(ttSolid)
  tts:add(tt)
  tts:setLocation(100,150)
  addToOverlay(tts)
  --
  ----HELP----
  local help = {
    "Title : True Type Fonts Demo",
    "Engine: http://apocalyx.sf.net",
    "Author: Leonardo Boselli",
    "E-mail: tetractys@users.sf.net",
    " ",
    "[  SPACE  ] Rotate Around Objects",
    "[  MOUSE  ] Look Around",
    "[ UP/DOWN ] Move Camera Forward/Back",
    "[PREV/NEXT] Raise/Lower Camera",
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
function TTDEMO.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ALL.update(camera,timeStep)
end

----FINALIZATION----
function TTDEMO.final()
  ----GLOBALS----
  ttMonochrome:delete()
  ttMonochrome = nil
  ttGrayscale:delete()
  ttGrayscale = nil
  ttTranslucent:delete()
  ttTranslucent = nil
  ttOutline:delete()
  ttOutline = nil
  ttFilled:delete()
  ttFilled = nil
  ttSolid:delete()
  ttSolid = nil
  ----
  ALL.final()
end

----KEY_DOWN----
function TTDEMO.keyDown(key)
  ALL.keyDown(key)
end


----SCENE SETUP----
setScene(Scene(TTDEMO.init,TTDEMO.update,TTDEMO.final,TTDEMO.keyDown))
