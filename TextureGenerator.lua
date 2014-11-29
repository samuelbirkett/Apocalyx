--TEXTURE GENERATOR DEMO
----Questions? Contact:leo <tetractys@users.sf.net>

--INIT FUNCTION--
function init()
  --CAMERA INIT
  local camera = getCamera() --Get the camera
  camera:reset() --Reset
  emptyOverlay() -- empty 2D overlay
  empty() -- empty 3D world
  --TEXTURES--
  textures = {}
  local brickPalette = {
      0,   30, 15,  8,
     80,   60, 30, 10,
    150,  150, 80, 30,
    255,  200, 90, 40,
  }
  local wood1Palette = {
      0,   90, 50, 20,
     40,  120, 90, 40,
    150,  150,120, 60,
    255,  200,150, 40,
  }
  local wood2Palette = {
      0,  180,120, 30,
     30,  200,140, 50,
    120,  210,150, 60,
    230,  230,170, 70,
    255,  180,120, 30,
  }
  local cloudPalette = {
      0,   40, 50,255,
    140,   40, 60,255,
    180,  200,200,255,
    200,  250,250,255,
    220,  240,240,255,
    230,  250,250,255,
    255,  255,255,255,
  }
  local warmPalette = {
      0,  100,  0,  0,
     40,  200,  0,  0,
    180,  255,255,  0,
    255,  255,255,255,
    255,  220,240,255,
  }
  local mandelPalette = {
      0,    0,  0, 30,  0,
      1,  255,  0,  0,255,
    100,  200,255,  0,255,
    180,  100,255,100,255,
    230,  230,  0,255,255,
    255,  255,255,100,255,
  }
  local marble1Palette = {
      0,   74, 65, 33,
     30,  140,121, 82,
     80,  255,237,191,
    204,  200,187,101,
    255,  255,229,198,
  }
  local marble2Palette = {
      0,   57, 69, 66,
     10,   60, 80, 78,
     50,   74, 95, 90,
    100,   90, 95, 90,
    240,  100,110,100,
    255,  220,220,200,
  }
  --bricks
  local texCount = 1
  local t1 = TexImageBricks(128,128,100)
  local t2 = TexImagePerlin(128,128,0.5,2)
  t1:balance(188,195)
  t2:balance(128,30)
  local t3 = t1:combine(t2,3) ---> MODULATE
  t3:balance(128,50)
  local t4 = t1:combine(t3,2) ---> SIGNED_ADD
  t4:colorize(3,brickPalette)
  local image = t4:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t1:delete()
  t2:delete()
  t3:delete()
  t4:delete()
  image:delete()
  --wood1
  t1 = TexImageWood(128,256,1,227,200)
  t1:soften(2)
  t1:colorize(3,wood1Palette)
  image = t1:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t1:delete()
  image:delete()
  --wood2
  t1 = TexImageWood(128,256,0.7,235,-300)
  t1:colorize(3,wood2Palette)
  image = t1:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t1:delete()
  image:delete()
  --cloud
  TexImageSetSeed(323)
  t1 = TexImagePerlin(256,256,0.6,7)
  t2 = t1:clone()
  t1:colorize(3,cloudPalette)
  image = t1:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t1:delete()
  image:delete()
  --warm
  t2:colorize(3,warmPalette)
  image = t2:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t2:delete()
  image:delete()
  --mand1
  t1 = TexImageMandel(256,256,100,-2,-1.5,1,1.5)
  t1:colorize(4,mandelPalette)
  image = t1:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t1:delete()
  image:delete()
  --mand2
  t1 = TexImageMandel(256,256,140,-1.26,-0.39,-1.25,-0.38)
  t1:colorize(4,mandelPalette)
  image = t1:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t1:delete()
  image:delete()
  --marble1
  TexImageSetSeed(324)
  t1 = TexImageMarble(256,256,0.6,6,5)
  t1:colorize(3,marble1Palette)
  image = t1:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t1:delete()
  image:delete()
  --marble2
  TexImageSetSeed(324)
  t1 = TexImageMarble(256,256,0.5,6,6)
  t1:colorize(3,marble2Palette)
  image = t1:getImage()
  textures[texCount] = Texture(image)
  texCount = texCount+1
  t1:delete()
  image:delete()
  --SPRITES--
  overlaySprites = {}
  for ct = 0, 8 do
    local s = OverlaySprite(128,128,textures[ct+1],true)
    s:setLocation(150*(ct%3)+225,150*math.floor(ct/3)+225)
    addToOverlay(s)
    overlaySprites[ct+1] = s
  end
  --HELP TEXT--
  local help = {
    "Texture generator Test",
    "",
    "Use the mouse to move the first square",
    "Press 'ENTER' to go back to demos menu",
  }
  setHelp(help)
  showHelpUser()
  hideConsole()
end --INIT

--UPDATE FUNCTION--
function update()
  local camera = getCamera()
  local dx, dy = getMouseMove()
  local x, y = overlaySprites[1]:getLocation()
  overlaySprites[1]:setLocation(x+dx,y+dy)
end

--KEY PRESS DETECTION
function keyDown(key)
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    hideConsole()
    final()
    dofile("main.lua")
    return
  end
end

--CLEANUP AND END
function final()
  overlaySprites = nil
  emptyOverlay() -- empty 2D overlay
  empty() -- empty 3D world
end

--SETUP THE SCENE (RUN)--
setScene(Scene(init,update,final,keyDown))
