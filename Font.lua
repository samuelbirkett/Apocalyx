----INIT----
function init()
emptyOverlay()
empty()
hideConsole()
hideHelp()
local w, h = getDimension()
local font = getMainOverlayFont()
local text = OverlayTexts(font)
local text1 = OverlayText("This is the default font")
text1:setLocation(0,0)
text1:setScale(1.5)
text1:setColor(0,1,1)
text1:setAlignmentCenter()
text:add(text1)
text:setLocation(w*0.5,h*0.5)
addToOverlay(text)
local arial = BitmapFont("Arial",16,0,true,false)
local texttwo = OverlayTexts(arial)
local text2 = OverlayText("Press 'Enter' to go back to demos menu")
text2:setLocation(0,0)
text2:setScale(1.5)
text2:setColor(1,1,1)
text2:setAlignmentCenter()
-- note that alignment and scale works only on monospaced fonts 
texttwo:add(text2)
local newh = h*0.5 - font:getHeight()*2
texttwo:setLocation(w*0.5,newh)
addToOverlay(texttwo)
if not fileExists("DemoPack1.dat") then
  showConsole()
  error("\nERROR: File 'DemoPack1.dat' not found")
end
local zip = Zip("DemoPack1.dat")
local fontImage = zip:getImage("font2.png")
local textured = TexturedFont(16,16,8,fontImage)
fontImage:delete()
local textthree = OverlayTexts(textured)
local text3 = OverlayText("This font is loaded from the ZIP file")
text3:setLocation(0,0)
text3:setScale(1.5)
text3:setColor(1,1,0)
text3:setAlignmentCenter()
textthree:add(text3)
local newh = h*0.5 + font:getHeight()*2
textthree:setLocation(w*0.5,newh)
addToOverlay(textthree)
end

----LOOP----
function update()
end

----FINALIZATION----
function final()
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
