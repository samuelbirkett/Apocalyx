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
  setTitle("Unicode True Type Fonts Demo")
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
  ttBitmap = UnicodeFontBitmap("font-data/Vera.ttf")
  ttPixmap = UnicodeFontPixmap("font-data/Vera.ttf")
  ttOutline = UnicodeFontOutline("font-data/Vera.ttf")
  ttPolygon = UnicodeFontPolygon("font-data/Vera.ttf")
-- *** Change the lines below if a TrueType Unicode Font is available
  ttExtruded = UnicodeFontExtruded("font-data/Vera.ttf")
--  ttExtruded = UnicodeFontExtruded("font-data/simhei.ttf")
  ttExtruded:setDepth(5)
  ttTextured = UnicodeFontTextured("font-data/Vera.ttf")
  --
  local text
  --
  text = UnicodeText("Bitmap",ttBitmap)
  text:setColor(1,0,0)
  text:move(0,40,0)
  addObject(text)
  text = UnicodeText("Pixmap",ttPixmap)
  text:setColor(0,1,0)
  text:move(0,25,0)
  addObject(text)
  text = UnicodeText("Outline",ttOutline)
  text:setColor(0,0,1)
  text:scale(0.5)
  text:move(0,10,0)
  addObject(text)
  text = UnicodeText("Polygon",ttPolygon)
  text:setColor(1,0,0)
  text:scale(0.5)
  text:move(0,-10,0)
  addObject(text)
  text = UnicodeText("Extruded",ttExtruded)
  text:setColor(0,1,0)
-- *** Uncomment the line below if a TrueType Unicode Font is available
--  text:setUnicodeText("\0xef\0xbb\0xbf\0xe5\0xa6\0x82\0xe6\0x9e")
  text:scale(0.5)
  text:move(0,-25,0)
  addObject(text)
  text = UnicodeText("Textured",ttTextured)
  text:setColor(0,0,1)
  text:setTransparent()
  text:scale(0.5)
  text:move(0,-40,0)
  addObject(text)
  --
  local tt, tts
  tt = OverlayUnicodeText("Bitmap")
  tt:setColor(1,0,0)
  tts = OverlayUnicodeTexts(ttBitmap)
  tts:add(tt)
  tts:setLocation(100,400)
  addToOverlay(tts)
  tt = OverlayUnicodeText("Pixmap")
  tt:setColor(0,1,0)
  tts = OverlayUnicodeTexts(ttPixmap)
  tts:add(tt)
  tts:setLocation(100,350)
  addToOverlay(tts)
  tt = OverlayUnicodeText("Outline")
  tt:setColor(0,0,1)
  tts = OverlayUnicodeTexts(ttOutline)
  tts:add(tt)
  tts:setLocation(100,300)
  addToOverlay(tts)
  tt = OverlayUnicodeText("Polygon")
  tt:setColor(1,0,0)
  tts = OverlayUnicodeTexts(ttPolygon)
  tts:add(tt)
  tts:setLocation(100,250)
  addToOverlay(tts)
  tt = OverlayUnicodeText("Extruded")
  tt:setColor(0,1,0)
  tts = OverlayUnicodeTexts(ttExtruded)
  tts:add(tt)
  tts:setLocation(100,200)
  addToOverlay(tts)
  tt = OverlayUnicodeText("Textured")
  tt:setColor(0,0,1)
  tts = OverlayUnicodeTexts(ttTextured)
  tts:add(tt)
  tts:setLocation(100,150)
  addToOverlay(tts)
  --
  ----HELP----
  local help = {
    "Title : Unicode True Type Fonts Demo",
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
  ttBitmap:delete()
  ttBitmap = nil
  ttPixmap:delete()
  ttPixmap = nil
  ttOutline:delete()
  ttOutline = nil
  ttPolygon:delete()
  ttPolygon = nil
  ttExtruded:delete()
  ttExtruded = nil
  ttTextured:delete()
  ttTextured = nil
  ----
  ALL.final()
end

----KEY_DOWN----
function TTDEMO.keyDown(key)
  ALL.keyDown(key)
end


----SCENE SETUP----
setScene(Scene(TTDEMO.init,TTDEMO.update,TTDEMO.final,TTDEMO.keyDown))
