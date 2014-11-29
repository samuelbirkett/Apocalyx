---------------------------------------------
---------U R B A N   T A C T I C S-----------
-------A Simple Third Person Shooter---------
--Questions? Contact tetractys@users.sf.net--
---------------------------------------------

----MODULES----

MENU = {}
PLAY = {}
ALL = {}

----INITIALIZATION SUPPORT----

function ALL.showSplashImage(zip)
  local splashImage = zip:getImage("logo.jpg")
  showSplashImage(splashImage)
  splashImage:delete()
end

function ALL.playSoundtrack(zip,fileName,MODULE)
  MODULE.soundTrack = zip:getMusic(fileName)
  local soundTrack = MODULE.soundTrack
  soundTrack:setVolume(255)
  soundTrack:setLooping(1)
  soundTrack:play()
end

function ALL.stopSoundtrack(MODULE)
  local soundTrack = MODULE.soundTrack
  if soundTrack then
    soundTrack:stop()
    soundTrack:delete()
    MODULE.soundTrack = nil
  end
end

function ALL.createSkybox(zip)
  local txtNames = {"Top", "Left", "Front", "Right", "Back"}
  local skyTxt = {}
  for txtIdx = 1, table.getn(txtNames) do
    skyTxt[txtIdx] = zip:getTexture("skybox"..txtNames[txtIdx]..".jpg")
  end
  local sky = MirroredSky(skyTxt)
  setBackground(sky)
end

function ALL.createSun(zip)
  local sun = {
    size = 0.32, distance = 3200, texture = zip:getTexture("light.jpg"),
    dir = {x = 0.0, y = 0.2588, z = 0.9659},
    color = {r = 0.9, g = 0.5, b = 0.2},
    flares = {
      count = 5, size = 0.128, texture = zip:getTexture("lensflares.png")
    }
  }
  local theSun = Sun(
    sun.texture, sun.size, sun.dir.x,sun.dir.y,sun.dir.z,
    sun.flares.texture,sun.flares.count,sun.flares.size,
    sun.distance
  )
  theSun:setColor(sun.color.r,sun.color.g,sun.color.b)
  setSun(theSun)
end

function ALL.createLevel(zip)
  local bsp = zip:getLevel("city.bsx",3)
  bsp:setShowUntexturedMeshes()
  bsp:setShowUntexturedPatches()
  bsp:setDefaultTexture(
    zip:getTexture("textures/maxpayne/Brick52a.jpg",1)
  )
  bsp:setShadowsStatic()
  setScenery(bsp)
  return bsp
end

------------------
----MENU SCENE----
------------------

----INITIALIZATION SUPPORT----

function MENU.setupPointer(zip)
  local pointerImage = zip:getImage("arrow.png")
  local pointerSize = pointerImage:getDimension()
  pointerImage:addAlpha(pointerImage)
  local pointerSprite = OverlaySprite(
    pointerSize,pointerSize,Texture(pointerImage),true
  )
  pointerImage:delete()
  pointerSprite:setLayer(-1)
  setPointer(pointerSprite)
  local w, h = getDimension()
  setPointerLocation(w/2,h/2)
  showPointer()
end

function MENU.createLogo(zip)
  local logoImage = zip:getImage("logo.jpg")
  local alphaImage = zip:getImage("logo.png")
  alphaImage:convertTo111A()
  logoImage:addAlpha(alphaImage)
  alphaImage:delete()
  local logoSize = logoImage:getDimension()
  MENU.GUI.logoSprite = OverlaySprite(
    logoSize,logoSize,Texture(logoImage),true
  )
  local logoSprite = MENU.GUI.logoSprite
  logoImage:delete()
  local w, h = getDimension()
  logoSprite:setLocation(w/2,h)
  addToOverlay(logoSprite)
end

function MENU.createCredits()
  local colors = {
    {r = 1,    g = 1, b = 0},
    {r = 0.75, g = 1, b = 1},
    {r = 1,    g = 1, b = 1}
  }
  local creditStrings = {
    {
      2, "",
      1, "U R B A N   T A C T I C S",
      2, "",
      3, "Copyright \184 2004",
      2, "Leonardo Boselli",
      1, "",
      3, "A Simple Third Person Shooter",
      2, ""
    },
    {
      1, "- Programming & Design -",
      2, "Leonardo \"leo\" Boselli",
      3, "tetractys@users.sf.net",
      1, "- Warriors Models -",
      2, "ALPHAwolf",
      3, "ALPHAwolf@Planatquake.com",
      2, "HitmanDaz",
      3, "daz@darren-pattenden.cix.co.uk",
      1, "- Gun Model -",
      2, "Janus & Chemical Burn",
      3, "janus@planetquake.com",
      1, "- Textures -",
      2, "Remedy Entertainment Ltd.",
      3, "from MAX PAYNE's official",
      3, "textures pack (non-comm.)"
    },
    {
      3, "Thanks to",
      3, "",
      2, "Matteo \"Fuzz\" Perenzoni",
      3, "",
      3, "for fruitful discussions on",
      3, "OpenGL and 3D programming.",
      3, "",
      3, "The sources of his demo for",
      3, "the NeHe's Apocalypse Contest",
      3, "were the first building blocks",
      3, "of the APOCALYX 3D Engine."
    },
    {
      3, "Thanks to",
      3, "",
      1, "TeCGraf, PUC-Rio",
      3, "for the LUA script language",
      2, "www.lua.org",
      3, "",
      1, "Borland",
      3, "for their free C++ compiler",
      2, "www.borland.com",
      3, "",
      1, "ID Software",
      3, "for developing great FPS",
      3, "whose file formats were",
      3, "fundamental for this game"
    },
    {
      3, "Thanks to the following sites",
      3, "for their useful tutorials",
      3, "about game programming",
      3, "",
      1, "NeHe Productions",
      2, "nehe.gamedev.net",
      1, "Game Tutorials",
      2, "www.gametutorials.com",
      1, "SULACO",
      2, "www.sulaco.co.za",
      3, "",
      3, "and",
      3, "",
      1, "Game Programming Italia",
      2, "www.gameprog.it"
    },
    {
      3, "Thanks to these web sites",
      3, "for publishing news about game",
      3, "development and related stuff",
      3, "",
      1, "GameDev",
      2, "www.gamedev.net",
      1, "FlipCode",
      2, "www.flipcode.org",
      1, "CFXweb",
      2, "www.cfxweb.net",
      1, "OpenGL.org",
      2, "www.opengl.org"
    },
    {
      3, "",
      3, "And, finally, thanks to",
      3, "ALL the people of the",
      3, "italian newsgroup",
      3, "",
      1, "it.comp.giochi.sviluppo",
      3, ""
    }
  }
  local font = getMainOverlayFont()
  local fontH = font:getHeight()
  local w, h = getDimension()
  local x = w/2+160
  MENU.GUI.optionsTexts = OverlayTexts(font)
  local optionsTexts = MENU.GUI.optionsTexts
  local playText = OverlayText("[1] PLAY GAME")
  playText:setScale(2)
  playText:setColor(1,1,0)
  optionsTexts:add(playText)
  optionsTexts:setLocation(w/2,h)
  addToOverlay(optionsTexts)
  MENU.GUI.credits = {}
  local credits = MENU.GUI.credits
  credits.status = 0
  credits.index = 1
  credits.texts = {}
  local creditTexts = credits.texts
  for creditIdx = 1, table.getn(creditStrings) do
    creditTexts[creditIdx] = OverlayTexts(font)
    local currentCreditText = creditTexts[creditIdx]
    local textLines = creditStrings[creditIdx]
    local textLinesCount = table.getn(textLines)
    local y = (h+fontH*(textLinesCount-1))/2-240
    for textLineIdx = 1, table.getn(textLines), 2 do
      local text = OverlayText(textLines[textLineIdx+1])
      local colorIdx = textLines[textLineIdx]
      text:setColor(
        colors[colorIdx].r,colors[colorIdx].g,colors[colorIdx].b
      )
      text:setLocation(x,y)
      y = y-fontH
      currentCreditText:add(text)
    end
    currentCreditText:setLocation(0,-h/2)
    addToOverlay(currentCreditText)
    currentCreditText:hide()
  end
end

function MENU.setupCamera(bsp)
  setAmbient(0.3,0.3,0.3)
  local camera = {angleOfView = 60, nearClip = 3, farClip = 12000}
  setPerspective(camera.angleOfView, camera.nearClip, camera.farClip)
  local theCamera = getCamera()
  theCamera:reset()
  local GUI = MENU.GUI
  GUI.startIndex = math.random(0,bsp:getStartingPositionsCount()-1)
  theCamera:setPosition(bsp:getStartingPosition(GUI.startIndex))
end

function MENU.setupHelp()
  hideConsole()
  showHelpReduced()
  local help = {
    "U R B A N   T A C T I C S",
    "A Simple Third Person Shooter",
    "Questions? Contact leo <boselli@uno.it>",
    " ",
    "[SPACE] Change Point of View",
    "[  1  ] Start",
    " ",
    "[ F 1 ] Show/Hide Help",
  }
  setHelp(help)
end

----INITIALIZATION----

function MENU.init()
  setTitle(" U R B A N   T A C T I C S")
  MENU.GUI = {}
  empty()
  emptyOverlay()
  if not fileExists("UrbanTactics.dat") then
    showConsole()
    error("\nERROR: File 'UrbanTactics.dat' not found.")
  end
  local zip = Zip("UrbanTactics.dat")
  ALL.playSoundtrack(zip,"intro.mid",MENU.GUI)
  ALL.showSplashImage(zip)
  MENU.createLogo(zip)
  MENU.createCredits()
  ALL.createSkybox(zip)
  ALL.createSun(zip)
  local GUI = MENU.GUI
  GUI.bsp = ALL.createLevel(zip)
  MENU.setupCamera(GUI.bsp)
  MENU.setupPointer(zip)
  MENU.setupHelp()
  zip:delete()
end

----UPDATE SUPPORT----

function MENU.rotateCamera(timeStep)
  local camera = getCamera()
  local rotSpeed = -math.pi/12
  camera:rotStanding(rotSpeed*timeStep)
end

function MENU.animateLogo(timeStep)
  local GUI = MENU.GUI
  local logoSprite = GUI.logoSprite
  local credits = GUI.credits
  local creditTexts = credits.texts
  local creditTextTime = credits.time
  local creditTextIndex = credits.index
  local creditTextStatus = credits.status
  local logoSpeedX, logoSpeedY = 200, 400
  local logoSize = logoSprite:getDimension()
  local w, h = getDimension()
  local markX = (w-320)/2
  local markY = (h+logoSize-480)/2
  local logoX, logoY = logoSprite:getLocation()
  if timeStep > 0.1 then
    timeStep = 0.1
  end
  if logoY > markY then
    logoY = logoY-timeStep*logoSpeedY
    if logoY < markY then
      logoY = markY
    end
    MENU.GUI.optionsTexts:setLocation(w/2,logoY+(h-logoSize)/2)
    logoSprite:setLocation(logoX,logoY)
  elseif logoY == markY then
    logoSprite:setLocation(logoX,markY-1)
  else
    if logoX > markX then
      logoX = logoX-timeStep*logoSpeedX
      if logoX < markX then
        logoX = markX
      end
      logoSprite:setLocation(logoX,logoY)
    elseif logoX == markX then
      hideHelp()
      logoSprite:setLocation(logoX-1,logoY)
      creditTexts[creditTextIndex]:show()
      creditTexts[creditTextIndex]:setLocation(0,-h/2)
    else
      local creditText = creditTexts[creditTextIndex]
      if creditTextStatus == 0 then --> FADE_IN
        local creditX, creditY = creditText:getLocation()
        creditY = creditY+timeStep*logoSpeedX
        if creditY >= 0 then
           creditText:setLocation(creditX,0)
           credits.time = getElapsedTime()
           credits.status = 1 --> WAIT
        else
          creditText:setLocation(creditX,creditY)
        end
      elseif creditTextStatus == 1 then --> WAIT
        local diff = getElapsedTime()-creditTextTime
        if diff > creditText:getCount()*0.5 then
          credits.status = 2 --> FADE_OUT
        end
      elseif creditTextStatus == 2 then --> FADE_OUT
        local creditX, creditY = creditText:getLocation()
        creditY = creditY-timeStep*logoSpeedY
        if creditY <= -h/2 then
          creditText:setLocation(creditX,-h/2)
          creditText:hide()
          credits.index = creditTextIndex+1
          if credits.index > table.getn(creditTexts) then
            credits.index = 1
          end
          creditTexts[credits.index]:show()
          credits.status = 0 --> FADE_IN
        else
          creditText:setLocation(creditX,creditY)
        end
      end
    end
  end
end

----UPDATE----

function MENU.update()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  MENU.rotateCamera(timeStep)
  MENU.animateLogo(timeStep)
  local dx, dy = getMouseMove()
  movePointer(dx,dy,getDimension())
  local GUI = MENU.GUI
  local text = GUI.optionsTexts:getTextAt(getPointerLocation())
  local oldPointerText = GUI.oldPointerText
  if text then
    if text ~= oldPointerText then
      if oldPointerText then
        oldPointerText:setColor(1,1,0)
      end
      text:setColor(1,0.25,0.25)
      GUI.oldPointerText = text
    end
    if isMouseLeftPressed() then
      if MENU.GUI.selected == nil then
        MENU.GUI.selected = true
        MENU.keyDown(string.byte("1"))
      end
    else
      MENU.GUI.selected = nil
    end
  elseif oldPointerText then
    oldPointerText:setColor(1,1,0)
    GUI.oldPointerText = nil
  end
end

----FINALIZATION----

function MENU.final()
  ALL.stopSoundtrack(MENU.GUI)
  MENU.GUI = nil
  hidePointer()
  emptyOverlay()
  empty()
end

----KEYBOARD----

function MENU.keyDown(key)
  if key == 32 then ---> KEY_SPACE
    releaseKey(32)
    local camera = getCamera()
    local GUI = MENU.GUI
    local bsp = GUI.bsp
    GUI.startIndex = GUI.startIndex+1
    if GUI.startIndex >= bsp:getStartingPositionsCount() then
      GUI.startIndex = 0
    end
    camera:setPosition(bsp:getStartingPosition(GUI.startIndex))
  elseif key == string.byte("1") then
    releaseKey(string.byte("1"))
    setScene(Scene(PLAY.init,PLAY.update,PLAY.final,PLAY.keyDown))
  end
end

------------------
----PLAY SCENE----
------------------

----INITIALIZATION SUPPORT----

function PLAY.setupCamera()
  setAmbient(0.3,0.3,0.3)
  local camera = {angleOfView = 60, nearClip = 3, farClip = 12000}
  setPerspective(camera.angleOfView, camera.nearClip, camera.farClip)
  local theCamera = getCamera()
  theCamera:set(PLAY.AVATAR.object)
end

function PLAY.setupScore(theScore,len,offset,texture,u0,v0,u1,v1)
  local w, h = getDimension()
  local w2, h2 = w/2, h/2
  local sw, sh = 64, 32
  local sw2, sh2 = sw/2, sh/2
  local nw, nh = 16, 16
  local nw2, nh2 = nw/2, nh/2
  local sprite = OverlaySprite(sw,sh,texture,true)
  sprite:setTextureCoord(u0,v0,u1,v1)
  sprite:setLocation(w2+offset,h-sh2)
  sprite:setColor(0.75,0.75,0)
  addToOverlay(sprite)
  local offsetX, offsetY = w2+offset+nw2*(len+1), h-sh2-nh2-nh 
  for ct = 1, len do
    theScore[ct] = OverlaySprite(nw,nh,texture,true)
    local number = theScore[ct]
    number:setTextureCoord(0,0.75,0.25,1)
    number:setLocation(offsetX-nw*ct,offsetY)
    number:setColor(1,1,0)
    addToOverlay(number)
  end
end

function PLAY.setScoreValue(theScore,value)
  local theString = string.format("%d",value)
  local len = string.len(theString) 
  for ct = 1, len do
    local byte = string.byte(theString,ct)-string.byte("0")
    local u, v = math.mod(byte,4)*0.25, math.floor(byte/4)*0.25
    theScore[len-ct+1]:setTextureCoord(u,0.75-v,u+0.25,1-v)
  end
end

function PLAY.setupScores(zip)
  local scoreImage = zip:getImage("numbers.png",0)
  local texture = Texture(scoreImage)
  scoreImage:delete()
  local AVATAR = PLAY.AVATAR
  local setupScore = PLAY.setupScore
  AVATAR.highestScore = {}
  setupScore(AVATAR.highestScore,5,-160,texture,0,0,0.5,0.25)
  AVATAR.scoreScore = {}
  setupScore(AVATAR.scoreScore,5,0,texture,0.5,0,1,0.25)
  AVATAR.damageScore = {}
  setupScore(AVATAR.damageScore,3,160,texture,0.5,0.25,1,0.5)
  if fileExists("hiscore.txt") then
    local file = ReadableTextFile("hiscore.txt")
    if file then
      local read = file:read()
      AVATAR.highest = tonumber(read)
      file:close()
    end
  end
  PLAY.setScoreValue(AVATAR.highestScore,AVATAR.highest)
  PLAY.setScoreValue(AVATAR.scoreScore,AVATAR.score)
  PLAY.setScoreValue(AVATAR.damageScore,AVATAR.damage)
end

function PLAY.setupHelp()
  hideHelp()
  hideConsole()
  local help = {
    "U R B A N   T A C T I C S",
    "A Simple Third Person Shooter",
    "Questions? Contact tetractys@users.sf.net",
    " ",
    "[   MOUSE  ] Look around",
    "[ L/R CLICK] Shoot Bullet/Grenade",
    "[  UP/DOWN ] Move Forward/Back",
    "[LEFT/RIGHT] Strafe Left/Right",
    "[PRIOR/NEXT] Move Up/Down (when flying)",
    "[   SPACE  ] Fly/Follow Avatar",
    "[    +/-   ] Fast/Slow Motion",
    "[   PAUSE  ] Pause",
    "[   ENTER  ] Back to Menu",
    "[     1    ] Start Game",
    " ",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
end

function PLAY.createEmitter(zip)
  local fireImage = zip:getImage("fire.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  PLAY.AVATAR.shotEmitter = Emitter(5,0.075,3)
  local shotEmitter = PLAY.AVATAR.shotEmitter
  shotEmitter:setTexture(fireTexture,1)
  shotEmitter:setVelocity(200,0,0, 0)
  shotEmitter:setColor(1,1,1,1, 1,0.5,0,0)
  shotEmitter:setSize(5,5)
  shotEmitter:setGravity(0,0,0, 0,0,0)
  shotEmitter:setOneShot()
  shotEmitter:reset()
  addObject(shotEmitter)
  shotEmitter:hide()
  fireTexture:delete()
end

function PLAY.createAvatar(zip,bsp,shadowTexture)
  PLAY.createEmitter(zip)
  local AVATAR = PLAY.AVATAR
  AVATAR.class = 0 ---> AVATAR
  AVATAR.alive = true
  AVATAR.score = 0
  AVATAR.highest = 0
  AVATAR.damage = 0
  AVATAR.flyModeActive = 0
  AVATAR.isRunning = 0
  AVATAR.isStrafing = 0
  AVATAR.linkReference = Reference()
  local legs = 4 ---> LEGS_IDLE
  AVATAR.legs = legs
  AVATAR.weapon = zip:getModel("gun.mdx","gun.jpg")
  local weapon = AVATAR.weapon
  weapon:rescale(0.5)
  AVATAR.object = zip:getBot("warrior.mdl",1)
  local avatar = AVATAR.object
  avatar:rescale(0.5)
  avatar:pitch(-1.5708)
  local startIndex = math.random(0,bsp:getStartingPositionsCount()-1)
  avatar:move(bsp:getStartingPosition(startIndex))
  avatar:getUpper():link("tag_weapon",weapon)
  avatar:setAnimationTime(0)
  avatar:setUpperAnimation(2) ---> TORSO_STAND
  avatar:setLowerAnimation(legs)
  addObject(avatar)
  addShadow(Shadow(avatar,14,14,shadowTexture))
  PLAY.SIM.OBJECTS[PLAY.SIM.MAX_ENEMIES*3+1] = AVATAR
  local boomSample = zip:getSample3D("boom.wav");
  AVATAR.boomSample = boomSample
  boomSample:setVolume(255)
  boomSample:setMinDistance(500)
  local shotSample = zip:getSample3D("shot.wav");
  AVATAR.shotSample = shotSample
  shotSample:setVolume(255)
  shotSample:setMinDistance(500)
  AVATAR.shotSource = Source(shotSample,avatar,false);
  local shotSource = AVATAR.shotSource
  addSource(shotSource)
  local runSound = zip:getSample3D("run.wav");
  runSound:setLooping(1)
  runSound:setVolume(255)
  runSound:setMinDistance(32)
  AVATAR.runSource = Source(runSound,avatar,false);
  local runSource = AVATAR.runSource
  addSource(runSource)
end

function PLAY.createEnemyModel(zip,shadowTexture,posX,posY,posZ)
  local weapon = zip:getBasicModel("marine_weapon.md2","marine_weapon.jpg")
  local material = weapon:getMaterial()
  material:setAmbient(1,1,1)
  material:setDiffuse(1,1,1)
  material:setSpecular(1,1,0)
  material:setShininess(64)
  weapon:rescale(0.5)
  weapon:pitch(-1.5708)
  weapon:move(posX,posY,posZ)
  weapon:setAnimation(1) ---> RUNNING
  addObject(weapon)
  local marine = zip:getBasicModel("marine_warrior.md2","marine_us.jpg")
  material = marine:getMaterial()
  material:setAmbient(1,1,1)
  material:setDiffuse(1,1,1)
  material:setSpecular(1,1,0)
  material:setShininess(64)
  marine:rescale(0.5)
  marine:pitch(-1.5708)
  marine:move(posX,posY,posZ)
  marine:setAnimationTime(0)
  marine:setAnimation(1) ---> RUNNING
  addObject(marine)
  addShadow(Shadow(marine,12,12,shadowTexture))
  return marine,weapon
end

function PLAY.cloneEnemy(marine,weapon,zip,textureName,shadowTexture,posX,posY,posZ)
  local weapon2 = BasicModel(weapon)
  weapon2:pitch(-1.5708)
  weapon2:move(posX,posY,posZ)
  weapon2:setAnimation(1) ---> RUNNING
  addObject(weapon2)
  local marine2 = BasicModel(marine)
  if textureName then
    local material = Material()
    material:setDiffuseTexture(zip:getTexture(textureName))
    material:setAmbient(1,1,1)
    material:setDiffuse(1,1,1)
    material:setSpecular(1,1,0)
    material:setShininess(64)
    marine2:setMaterial(material)
  end
  marine2:pitch(-1.5708)
  marine2:move(posX,posY,posZ)
  marine2:setAnimation(1) ---> RUNNING
  addObject(marine2)
  addShadow(Shadow(marine2,12,12,shadowTexture))
	return marine2, weapon2
end

function PLAY.compareObjects(firstObj,secondObj)
  local firstX = firstObj.object:getPosition()
  local secondX = secondObj.object:getPosition()
  return firstX < secondX
end

function PLAY.setEnemyStatus(theEnemy,status,countdown,altCountdown)
  if theEnemy.status ~= status then
    theEnemy.status = status
    theEnemy.object:setAnimation(status)
    if status < 15 then
      theEnemy.weapon:setAnimation(status)
    else
      theEnemy.weapon:hide()
    end
    theEnemy.countdown = countdown
  elseif altCountdown then
      theEnemy.countdown = altCountdown
  else
      theEnemy.countdown = countdown
  end
end

function PLAY.constructEnemy(theEnemy)
  if theEnemy.alive == nil then
    theEnemy.alive = true
  end
  if theEnemy.weight == nil then
    theEnemy.weight = 1
  end
  if theEnemy.health == nil then
    theEnemy.health = 2
  end
  if theEnemy.rotDir == nil then
    theEnemy.rotDir = 0
  end
  if theEnemy.status == nil then
    theEnemy.status = 1 ---> RUNNING
  end
  if theEnemy.countdown == nil then
    theEnemy.countdown = 0
  end
  if theEnemy.isAvatarInSight == nil then
    theEnemy.isAvatarInSight = false
  end
  if theEnemy.setStatus == nil then
    theEnemy.setStatus = PLAY.setEnemyStatus
  end
  theEnemy.class = 1 ---> ENEMY
  return theEnemy
end

function PLAY.createEnemies(zip,bsp,shadowTexture)
  local ENEMIES = PLAY.SIM.ENEMIES
  local OBJECTS = PLAY.SIM.OBJECTS
  local startIndex = math.random(0,bsp:getStartingPositionsCount()-1)
  local startX,startY,startZ = bsp:getStartingPosition(startIndex)
  local avatarCluster = bsp:getCluster(PLAY.AVATAR.object:getPosition())
  repeat
    startIndex = math.random(0,bsp:getStartingPositionsCount()-1)
    startX,startY,startZ = bsp:getStartingPosition(startIndex)
  until not bsp:checkVisibility(avatarCluster,bsp:getCluster(startX,startY,startZ))
  local marine, weapon = PLAY.createEnemyModel(zip,shadowTexture,startX,startY-15,startZ)
  ENEMIES[1] = PLAY.constructEnemy{object = marine, weapon = weapon, weight = 1}
  OBJECTS[1] = ENEMIES[1]
  local textureList =
    {"marine_centurion.jpg", "marine_brownie.jpg", "marine_reese.jpg"}
  for ct = 2, 4 do
    repeat
      startIndex = math.random(0,bsp:getStartingPositionsCount()-1)
      startX,startY,startZ = bsp:getStartingPosition(startIndex)
    until not bsp:checkVisibility(avatarCluster,bsp:getCluster(startX,startY,startZ))
    local dontRepeat = false
    repeat
      for enemyCt = 1, ct-1 do
        local posX,posY,posZ = ENEMIES[enemyCt].object:getPosition()
        if
          math.abs(startX-posX) <= 16 and
          math.abs(startZ-posZ) <= 16 and
          math.abs(startY-posY) <= 16
        then
          startX = startX + 17
          startZ = startZ + 17
        else
          dontRepeat = true
        end
      end
    until dontRepeat
    local marine2, weapon2 = PLAY.cloneEnemy(
      marine,weapon,zip,textureList[ct],shadowTexture,startX,startY-15,startZ
    )
    ENEMIES[ct] = PLAY.constructEnemy{
      object = marine2, weapon = weapon2, weight = 2^(ct-1)
    }
    OBJECTS[ct] = ENEMIES[ct]
    table.sort(ENEMIES,PLAY.compareObjects)
  end
  for ct = 5, PLAY.SIM.MAX_ENEMIES do
    repeat
      startIndex = math.random(0,bsp:getStartingPositionsCount()-1)
      startX,startY,startZ = bsp:getStartingPosition(startIndex)
    until not bsp:checkVisibility(avatarCluster,bsp:getCluster(startX,startY,startZ))
    local dontRepeat = false
    repeat
      for enemyCt = 1, ct-1 do
        local posX,posY,posZ = ENEMIES[enemyCt].object:getPosition()
        if
          math.abs(startX-posX) <= 16 and
          math.abs(startZ-posZ) <= 16 and
          math.abs(startY-posY) <= 16
        then
          startX = startX + 17
          startZ = startZ + 17
        else
          dontRepeat = true
        end
      end
    until dontRepeat
    marine = ENEMIES[math.mod(ct,4)+1].object
    local marine2, weapon2 = 
      PLAY.cloneEnemy(marine,weapon,zip,nil,shadowTexture,startX,startY-15,startZ)
    ENEMIES[ct] = PLAY.constructEnemy{
      object = marine2, weapon = weapon2, weight = 2^(math.mod(ct-5,4))
    }
    OBJECTS[ct] = ENEMIES[ct]
    table.sort(ENEMIES,PLAY.compareObjects)
  end
end

function PLAY.createBullets(zip)
  local BULLETS = PLAY.SIM.BULLETS
  local OBJECTS = PLAY.SIM.OBJECTS
  local material = Material()
  local image = zip:getImage("light.jpg")
  image:addAlpha(image)
  material:setDiffuseTexture(Texture(image))
  image:delete()
  material:setEnlighted(false)
  material:setEmissive(1,0.75,0)
  local MAX_BULLETS = PLAY.SIM.MAX_ENEMIES*2
  for ct = 1, MAX_BULLETS do
    local sprite = Sprite(20,20,material)
    BULLETS[ct] =
      {object = sprite, velX = 0, velY = 0, velZ = 0, type = 0, countdown = 0, class = 2}
    OBJECTS[ct+PLAY.SIM.MAX_ENEMIES] = BULLETS[ct]
    sprite:setTransparent()
    addObject(sprite)
    sprite:hide()
  end
end

function PLAY.createExplosions(zip)
  local EXPLOSIONS = PLAY.SIM.EXPLOSIONS
  local material = Material()
  local image = zip:getImage("boom.jpg")
  image:addAlpha(image)
  material:setDiffuseTexture(Texture(image))
  image:delete()
  material:setEnlighted(false)
  material:setEmissive(1,1,1)
  local MAX_EXPLOSIONS = 4
  for ct = 1, MAX_EXPLOSIONS do
    local sprite = Sprite(160,160,material)
    EXPLOSIONS[ct] =
      {object = sprite, countdown = 0, class = 3}
    sprite:setTransparent()
    addObject(sprite)
    sprite:hide()
  end
end

----INITIALIZATION----

function PLAY.init()
  PLAY.AVATAR = {}
  PLAY.SIM = {}
  local SIM = PLAY.SIM
  SIM.MAX_ENEMIES = 24
  SIM.ENEMIES = {}
  SIM.BULLETS = {}
  SIM.EXPLOSIONS = {}
  SIM.OBJECTS = {}
  SIM.timeMultiplier = 1
  SIM.aiElapsedTime = 0
  SIM.physicsElapsedTime = 0
  empty()
  emptyOverlay()
  setListenerScale(16)
  if not fileExists("UrbanTactics.dat") then
    showConsole()
    error("\nERROR: File 'UrbanTactics.dat' not found.")
  end
  local zipA = Zip("UrbanTactics.dat")
  local zipB = Zip("UrbanTactics.dat")
  ALL.playSoundtrack(zipB,"soundtrack.mid",PLAY.SIM)
  ALL.showSplashImage(zipA)
  ALL.createSkybox(zipA)
  ALL.createSun(zipA)
  PLAY.SIM.bsp = ALL.createLevel(zipA)
  local bsp = PLAY.SIM.bsp
  local shadowImage = zipB:getImage("shadow.png")
  shadowImage:convertTo111A()
  local shadowTexture = Texture(shadowImage)
  shadowImage:delete()
  PLAY.createAvatar(zipB,bsp,shadowTexture)
  PLAY.createEnemies(zipB,bsp,shadowTexture)
  PLAY.createBullets(zipA)
  PLAY.createExplosions(zipB)
  PLAY.setupScores(zipB)
  PLAY.setupCamera()
  PLAY.setupHelp()
  zipA:delete()
  zipB:delete()
end

----UPDATE SUPPORT----

function PLAY.rotateIfNeeded(timeStep)
  local avatar = PLAY.AVATAR.object
  local headAngle = avatar:getHead():getYawAngle()
  local upperAngle = avatar:getUpper():getYawAngle()
  local yawAngle = headAngle+upperAngle
  if yawAngle ~= 0 then
    local rotation = timeStep*3.1415
    if yawAngle > 0 then
      rotation = -rotation
    end
    avatar:rotStanding(-rotation)
    if headAngle ~= 0 then
      local newHeadAngle = headAngle+rotation
      if headAngle*newHeadAngle < 0 then
        avatar:getHead():setYawAngle(0)
        avatar:getUpper():addYawAngle(newHeadAngle-headAngle,1.047)
      else
        avatar:getHead():addYawAngle(rotation,1.5708)
      end
    else
      local diff = avatar:getUpper():addYawAngle(rotation,1.047)
      if diff ~= 0 then
        avatar:getHead():addYawAngle(diff,1.5708)
      end
    end
  end
end

----UPDATE----

function PLAY.update()
  local camera = getCamera()
  local AVATAR = PLAY.AVATAR
  local avatar = AVATAR.object
  local SIM = PLAY.SIM
  local ENEMIES = SIM.ENEMIES
  local BULLETS = SIM.BULLETS
  local EXPLOSIONS = SIM.EXPLOSIONS
  local OBJECTS = SIM.OBJECTS
  local bsp = SIM.bsp
  local timeStep = getTimeStep()
  local modelTimeStep
  if isPaused() then
    modelTimeStep = 0
  else
    modelTimeStep  = timeStep*SIM.timeMultiplier
    local animationTime = avatar:getAnimationTime()+modelTimeStep
    avatar:setAnimationTime(animationTime)
    ENEMIES[1].object:setAnimationTime(animationTime)
  end
  local ENEMIES_AI_TIMESTEP = 0.1
  SIM.aiElapsedTime = SIM.aiElapsedTime+modelTimeStep
  if SIM.aiElapsedTime > ENEMIES_AI_TIMESTEP then
    local timeStep = SIM.aiElapsedTime
    local lookForward = 200
    local lookForward2 = lookForward*lookForward
    local rotSpeed = 1.57*timeStep
    local avatarX,avatarY,avatarZ = avatar:getPosition()
    local avatarCluster = bsp:getCluster(avatarX,avatarY,avatarZ)
    for enemyCt = 1, table.getn(ENEMIES) do
      local theEnemy = ENEMIES[enemyCt]
      if not theEnemy.alive then
        if theEnemy.object:isClipped() then
          repeat
            startIndex = math.random(0,bsp:getStartingPositionsCount()-1)
            startX,startY,startZ = bsp:getStartingPosition(startIndex)
          until not bsp:checkVisibility(avatarCluster,bsp:getCluster(startX,startY,startZ))
          for ct = 1, table.getn(ENEMIES) do
            local posX,posY,posZ = ENEMIES[ct].object:getPosition()
            if
              math.abs(startX-posX) <= 16 and
              math.abs(startZ-posZ) <= 16 and
              math.abs(startY-posY) <= 16
            then
              startX = startX + 17
              startZ = startZ + 17
            end
          end
          theEnemy.object:setPosition(startX,startY-15,startZ)
          theEnemy.object:setAnimation(1,5) ---> RUNNING
          theEnemy.weapon:setPosition(startX,startY-15,startZ)
          theEnemy.weapon:setAnimation(1,5) ---> RUNNING
          theEnemy.weapon:show()
          theEnemy.health = 3
          theEnemy.alive = true
        end
      else
        local marine = theEnemy.object
        local weapon = theEnemy.weapon
        local posX,posY,posZ = marine:getPosition()
        local enemyCluster = bsp:getCluster(posX,posY,posZ)
        if AVATAR.alive and bsp:checkVisibility(enemyCluster,avatarCluster) then
          local dirX, dirY, dirZ = avatarX-posX, avatarY-posY, avatarZ-posZ
          local viewX, viewY, viewZ = marine:getSideDirection()
          local dot = viewX*dirX+viewZ*dirZ
          if dot > 0 then
            local finalX,finalY,finalZ,collided = bsp:checkCollision(
              posX,posY,posZ,dirX,dirY,dirZ,1,1,1
            )
            if not collided then
              if not theEnemy.isAvatarInSight then
                theEnemy.isAvatarInSight = true
                theEnemy:setStatus(10,1.5) ---> WAVE
              else
                local arg = dot/math.sqrt(dirX*dirX+dirZ*dirZ)
                if arg > 1 then
                  arg = 1
                end
                angle = math.acos(arg)
                if angle > rotSpeed then
                  angle = rotSpeed
                end
                if viewX*dirZ-viewZ*dirX > 0 then
                  angle = -angle
                end
                marine:rotStanding(angle)
                weapon:rotStanding(angle)
              end
            elseif theEnemy.isAvatarInSight then
              theEnemy.isAvatarInSight = false
              theEnemy:setStatus(0,2) ---> STAND
            end
          elseif theEnemy.isAvatarInSight then
            theEnemy.isAvatarInSight = false
            theEnemy:setStatus(0,2) ---> STAND
          end
        elseif theEnemy.isAvatarInSight then
          theEnemy.isAvatarInSight = false
          theEnemy:setStatus(0,2) ---> STAND
        end
        local status = theEnemy.status
        theEnemy.countdown = theEnemy.countdown-timeStep
        if status == 0 then ---> STAND
          if theEnemy.countdown < 0 then
            status = math.random(0,2)
            if status == 2 then
              theEnemy:setStatus(7,1) ---> FLIP
              theEnemy.rotDir = math.random(-1,1)
            else
              theEnemy:setStatus(status,10,5)
            end
          end
        elseif status == 1 then ---> RUN
          local lookX,lookY,lookZ = marine:getSideDirection()
          lookX = lookX*lookForward
          lookY = lookY*lookForward
          lookZ = lookZ*lookForward
          local finalX,finalY,finalZ,collided = bsp:checkCollision(
            posX,posY,posZ,lookX,lookY,lookZ,1,1,1
          )
          if collided then
            local diffX,diffZ = finalX-posX,finalZ-posZ
            local diff2 = diffX*diffX+diffZ*diffZ
            if diff2 < lookForward2*0.5 then
              if theEnemy.rotDir == 0 then
                lookX,lookY,lookZ = marine:getUpDirection()
                lookX = lookX*lookForward
                lookXneg = -lookX
                lookY = lookY*lookForward
                lookYneg = -lookY
                lookZ = lookZ*lookForward
                lookZneg = -lookZ
                finalX,finalY,finalZ = bsp:checkCollision(
                  posX,posY,posZ,lookX,lookY,lookZ,1,1,1
                )
                diffX,diffZ = finalX-posX,finalZ-posZ
                diff2 = diffX*diffX+diffZ*diffZ
                finalX,finalY,finalZ = bsp:checkCollision(
                  posX,posY,posZ,lookXneg,lookYneg,lookZneg,1,1,1
                )
                diffX,diffZ = finalX-posX,finalZ-posZ
                local diff2neg = diffX*diffX+diffZ*diffZ
                if diff2 < diff2neg then
                  theEnemy.rotDir = -1
                elseif diff2 > diff2neg then
                  theEnemy.rotDir = 1
                else
                  theEnemy.rotDir = math.random(-1,1)
                end
              end
              local angle = rotSpeed*theEnemy.rotDir
              marine:rotStanding(angle)
              weapon:rotStanding(angle)
            end
          else
            theEnemy.rotDir = 0
          end
          if theEnemy.countdown < 0 then
            theEnemy:setStatus(math.random(0,1),10,5)
          end
        elseif status == 7 then ---> FLIP
          if theEnemy.countdown < 0 then
            theEnemy:setStatus(math.random(0,1),2)
            theEnemy.rotDir = 0
          end
        elseif status == 10 then ---> WAVE
          if theEnemy.countdown < 0 then
            theEnemy:setStatus(11,1.5) ---> POINT
          end
        elseif status == 11 then ---> POINT
          if theEnemy.countdown < 0 then
            theEnemy:setStatus(14,1) ---> CROUCH_ATTACK
            for ct = 1, table.getn(BULLETS) do
              local bullet = BULLETS[ct]
              local sprite = bullet.object
              if not sprite:isVisible() then
                local posX,posY,posZ = marine:getPosition()
                local dirX,dirY,dirZ = marine:getSideDirection()
                sprite:setPosition(posX+dirX*16,posY+dirY*16,posZ+dirZ*16)
                bullet.velX,bullet.velY,bullet.velZ = dirX*480,dirY*480,dirZ*480
                bullet.type = 0 ---> BULLET
                sprite:show()
                AVATAR.shotSample:playAt(posX,posY,posZ)
                break
              end
            end
          end
        end
      end
    end
    SIM.aiElapsedTime = 0
  end
  local ENEMIES_PHYSICS_TIMESTEP = 0.01
  SIM.physicsElapsedTime = SIM.physicsElapsedTime+modelTimeStep
  if SIM.physicsElapsedTime > ENEMIES_PHYSICS_TIMESTEP then
    table.sort(ENEMIES,PLAY.compareObjects)
    local timeStep = SIM.physicsElapsedTime
    local runSpeed = 125*timeStep
    local rotSpeed = 1.57*timeStep
    for enemyCt = 1, table.getn(ENEMIES) do
      local theEnemy = ENEMIES[enemyCt]
      if theEnemy.alive then
        local marine = theEnemy.object
        local weapon = theEnemy.weapon
        local status = theEnemy.status
        if status == 1 then ---> RUN
          local posX,posY,posZ = marine:getPosition()
          local velX,velY,velZ = marine:getSideDirection()
          velX = velX*runSpeed
          velY = velY*runSpeed-5.8
          velZ = velZ*runSpeed
          local newPosX,newPosY,newPosZ = bsp:slideCollision(
            posX,posY,posZ,velX,velY,velZ,8,12,8
          )
          local foundCollision = false
          for neighCt = enemyCt-1, 1, -1 do
            local otherX,otherY,otherZ = ENEMIES[neighCt].object:getPosition()
            if math.abs(otherX-newPosX) > 16 then
              break
            end
            if math.abs(otherZ-newPosZ) <= 16 and math.abs(otherY-newPosY) <= 16 then
              foundCollision = true
              newPosX,newPosY,newPosZ = posX,posY,posZ
              theEnemy:setStatus(7,2) ---> FLIP
              theEnemy.rotDir = 1
            end
          end
          if not foundCollision then
            for neighCt = enemyCt+1, table.getn(ENEMIES) do
              local otherX,otherY,otherZ = ENEMIES[neighCt].object:getPosition()
              if math.abs(otherX-newPosX) > 16 then
                break
              end
              if math.abs(otherZ-newPosZ) <= 16 and math.abs(otherY-newPosY) <= 16 then
                foundCollision = true
                newPosX,newPosY,newPosZ = posX,posY,posZ
                theEnemy:setStatus(7,2) ---> FLIP
                theEnemy.rotDir = 1
              end
            end
          end
          marine:setPosition(newPosX,newPosY,newPosZ)
          weapon:setPosition(newPosX,newPosY,newPosZ)
        elseif status == 7 then ---> FLIP
          local angle = theEnemy.rotDir*rotSpeed/2
          marine:rotStanding(angle)
          weapon:rotStanding(angle)
        elseif status == 14 then ---> CROUCH_ATTACK
          if marine:getStoppedAnimation() == 14 then
            theEnemy:setStatus(14,1)
          end
          if theEnemy.countdown < 0 then
            theEnemy.countdown = 1
            for ct = 1, table.getn(BULLETS) do
              local bullet = BULLETS[ct]
              local sprite = bullet.object
              if not sprite:isVisible() then
                local posX,posY,posZ = marine:getPosition()
                local dirX,dirY,dirZ = marine:getSideDirection()
                sprite:setPosition(posX+dirX*16,posY+dirY*16,posZ+dirZ*16)
                bullet.velX,bullet.velY,bullet.velZ = dirX*480,dirY*480,dirZ*480
                bullet.type = 0 ---> BULLET
                sprite:show()
                AVATAR.shotSample:playAt(posX,posY,posZ)
                break
              end
            end
          end
        elseif status == 15 then ---> CROUCH_PAIN
          if theEnemy.countdown < 0 then
            theEnemy:setStatus(14,1) ---> CROUCH_ATTACK
          end
        elseif status >=3 and status <= 5 then ---> PAIN_*
          if theEnemy.countdown < 0 then
            theEnemy:setStatus(0,1) ---> STAND
          end
        end
      end
    end
    for ct = 1, table.getn(EXPLOSIONS) do
      local sprite = EXPLOSIONS[ct].object
      if sprite:isVisible() then
        local theExplosion = EXPLOSIONS[ct]
        theExplosion.countdown = theExplosion.countdown-timeStep
        if theExplosion.countdown < 0 then
          sprite:hide()
        else
          local frame = math.floor(theExplosion.countdown*16)
          local u, v = (3-math.mod(frame,4))*0.25, math.floor(frame/4)*0.25
          sprite:setTextureCoord(u,v,u+0.25,v+0.25)
        end
      end
    end
    for ct = 1, table.getn(BULLETS) do
      local bullet = BULLETS[ct]
      local sprite = bullet.object
      if sprite:isVisible() then
        local posX,posY,posZ = sprite:getPosition()
        local velX,velY,velZ = bullet.velX,bullet.velY,bullet.velZ
        local newPosX,newPosY,newPosZ,collided = bsp:checkCollision(
          posX,posY,posZ,velX*timeStep,velY*timeStep,velZ*timeStep,1,1,1
        )
        if collided then
          if bullet.type == 1 then ---> GRENADE
            local normalX, normalY, normalZ = bsp:getCollisionNormal()
            local velDotNorm2 = -2*(velX*normalX+velY*normalY+velZ*normalZ)
            velX, velY, velZ =
              0.8*(velX+velDotNorm2*normalX),
              0.8*(velY+velDotNorm2*normalY),
              0.8*(velZ+velDotNorm2*normalZ)
            newPosY = newPosY+0.02
          else
            sprite:hide()
          end
        end
        sprite:setPosition(newPosX,newPosY,newPosZ)
        if bullet.type == 1 then ---> GRENADE
          bullet.countdown = bullet.countdown-timeStep
          if bullet.countdown < 0 then
            sprite:hide()
            for ct = 1, table.getn(EXPLOSIONS) do
              local theExplosion = EXPLOSIONS[ct]
              local sprite = theExplosion.object
              if not sprite:isVisible() then
                theExplosion.countdown = 1
                sprite:setPosition(newPosX,newPosY,newPosZ)
                sprite:setTextureCoord(0,0,0.25,0.25)
                AVATAR.boomSample:playAt(newPosX,newPosY,newPosZ)
                sprite:show()
                break
              end
            end
          else
            bullet.velX,bullet.velY,bullet.velZ  = velX,velY-157*timeStep,velZ
          end
        end
      end
    end
    table.sort(OBJECTS,PLAY.compareObjects)
    for ct = 1, table.getn(OBJECTS) do
      local theObject = OBJECTS[ct]
      if theObject.class == 2 and theObject.object:isVisible() then
        local bullet = theObject.object
        local posX,posY,posZ = bullet:getPosition()
        for neighCt = ct-1, 1, -1 do
          local theOtherObject = OBJECTS[neighCt]
          local object = theOtherObject.object
          local otherX,otherY,otherZ = object:getPosition()
          if math.abs(otherX-posX) > 8 then
            break
          end
          if
            theOtherObject.class ~= 2 and
            math.abs(otherZ-posZ) <= 8 and
            math.abs(otherY-posY) <= 8
          then
            if theOtherObject.alive then
              bullet:hide()
              if theOtherObject.class == 0 then
                AVATAR.damage = AVATAR.damage+10
                PLAY.setScoreValue(AVATAR.damageScore,AVATAR.damage)
                if AVATAR.damage >= 100 then
                  avatar:setUpperAnimation(0) ---> TORSO_DEAD
                  avatar:setLowerAnimation(0) ---> LEGS_DEAD
                  AVATAR.flyModeActive = 1
                  AVATAR.alive = false
                  if AVATAR.score > AVATAR.highest then
                    local file = WritableTextFile("hiscore.txt")
                    if file then
                      file:write(string.format("%d",AVATAR.score))
                      file:close()
                    end
                  end
                end
              elseif theOtherObject.class == 1 then
                if theObject.type == 1 then
                  for ct = 1, table.getn(EXPLOSIONS) do
                    local theExplosion = EXPLOSIONS[ct]
                    local sprite = theExplosion.object
                    if not sprite:isVisible() then
                      theExplosion.countdown = 1
                      sprite:setPosition(posX,posY,posZ)
                      AVATAR.boomSample:playAt(posX,posY,posZ)
                      sprite:show()
                      theOtherObject.health = 0
                      break
                    end
                  end
                else
                  theOtherObject.health = theOtherObject.health-1
                end
                if theOtherObject.health == 0 then
                  if theOtherObject.status == 14 then ---> CROUCH_ATTACK
                    theOtherObject:setStatus(16,1) ---> CROUCH_DEATH
                  else
                    theOtherObject:setStatus(math.random(17,19),1) ---> DEATH_*
                  end
                  theOtherObject.alive = false
                  AVATAR.score = AVATAR.score+theOtherObject.weight
                  PLAY.setScoreValue(AVATAR.scoreScore,AVATAR.score)
                else
                  if theOtherObject.status == 14 then ---> CROUCH_ATTACK
                    theOtherObject:setStatus(15,1) ---> CROUCH_PAIN
                  else 
                    theOtherObject:setStatus(math.random(3,5),1) ---> PAIN_*
                  end
                end
              end
            end
          end
        end
        for neighCt = ct+1, table.getn(OBJECTS) do
          local theOtherObject = OBJECTS[neighCt]
          local object = theOtherObject.object
          local otherX,otherY,otherZ = object:getPosition()
          if math.abs(otherX-posX) > 8 then
            break
          end
          if
            theOtherObject.class ~= 2 and
            math.abs(otherZ-posZ) <= 8 and
            math.abs(otherY-posY) <= 8
          then
            if theOtherObject.alive then
              bullet:hide()
              if theOtherObject.class == 0 then
                AVATAR.damage = AVATAR.damage+10
                PLAY.setScoreValue(AVATAR.damageScore,AVATAR.damage)
                if AVATAR.damage >= 100 then
                  avatar:setUpperAnimation(0) ---> TORSO_DEAD
                  avatar:setLowerAnimation(0) ---> LEGS_DEAD
                  AVATAR.flyModeActive = 1
                  AVATAR.alive = false
                  if AVATAR.score > AVATAR.highest then
                    local file = WritableTextFile("hiscore.txt")
                    if file then
                      file:write(string.format("%d",AVATAR.score))
                      file:close()
                    end
                  end
                end
              elseif theOtherObject.class == 1 then
                if theObject.type == 1 then
                  for ct = 1, table.getn(EXPLOSIONS) do
                    local theExplosion = EXPLOSIONS[ct]
                    local sprite = theExplosion.object
                    if not sprite:isVisible() then
                      theExplosion.countdown = 1
                      sprite:setPosition(posX,posY,posZ)
                      AVATAR.boomSample:playAt(posX,posY,posZ)
                      sprite:show()
                      theOtherObject.health = 0
                      break
                    end
                  end
                else
                  theOtherObject.health = theOtherObject.health-1
                end
                if theOtherObject.health == 0 then
                  if theOtherObject.status == 14 then ---> CROUCH_ATTACK
                    theOtherObject:setStatus(16,1) ---> CROUCH_DEATH
                  else
                    theOtherObject:setStatus(math.random(17,19),1) ---> DEATH_*
                  end
                  theOtherObject.alive = false
                  AVATAR.score = AVATAR.score+theOtherObject.weight
                  PLAY.setScoreValue(AVATAR.scoreScore,AVATAR.score)
                else
                  if theOtherObject.status == 14 then ---> CROUCH_ATTACK
                    theOtherObject:setStatus(15,1) ---> CROUCH_PAIN
                  else 
                    theOtherObject:setStatus(math.random(3,5),1) ---> PAIN_*
                  end
                end
              end
            end
          end
        end
      end
    end
    SIM.physicsElapsedTime = 0
  end
  if avatar:getUpper():getStoppedAnimation() == 1 then ---> TORSO_ATTACK
    avatar:setUpperAnimation(2) ---> TORSO_STAND
  end
  if
    (isMouseLeftPressed() or isMouseRightPressed()) and
    (avatar:getUpperAnimation() ~= 1) and ---> TORSO_ATTACK
    AVATAR.alive
  then
    avatar:setUpperAnimation(1) ---> TORSO_ATTACK
    AVATAR.shotSource:getSound3D():play()
    if avatar:getLinkTransform("tag_weapon",AVATAR.linkReference) then
      local shotEmitter = AVATAR.shotEmitter
      local linkReference = AVATAR.linkReference
      shotEmitter:set(linkReference)
      shotEmitter:moveSide(10)
      shotEmitter:show()
      shotEmitter:reset()
      for ct = 1, table.getn(BULLETS) do
        local bullet = BULLETS[ct]
        local sprite = bullet.object
        if not sprite:isVisible() then
          local posX,posY,posZ = linkReference:getPosition()
          local dirX,dirY,dirZ = linkReference:getSideDirection()
          sprite:setPosition(posX+dirX*16,posY+dirY*16,posZ+dirZ*16)
          bullet.velX,bullet.velY,bullet.velZ = dirX*480,dirY*480,dirZ*480
          if isMouseLeftPressed() then
            bullet.type = 0 ---> BULLET
          else
            bullet.type = 1 ---> GRENADE
            bullet.countdown = 3
          end
          sprite:show()
          break
        end
      end
    end
  end
  if AVATAR.flyModeActive == 1 then
    if
      isKeyPressed(38) or isKeyPressed(40) or ---> KEY_UP || KEY_DOWN
      isKeyPressed(37) or isKeyPressed(39) or ---> KEY_LEFT || KEY_RIGHT
      isKeyPressed(33) or isKeyPressed(34)    ---> KEY_PRIOR || KEY_NEXT
    then 
      local stepSpeed = 150
      local step = 0
      if isKeyPressed(38) then ---> KEY_UP
        step =  stepSpeed*timeStep
      elseif isKeyPressed(40) then ---> KEY_DOWN
        step = -stepSpeed*timeStep
      end
      local sideSpeed = 150
      local side = 0
      if isKeyPressed(37) then ---> KEY_LEFT
        side =  sideSpeed*timeStep
      elseif isKeyPressed(39) then ---> KEY_RIGHT
        side = -sideSpeed*timeStep
      end
      local climbSpeed = 75
      local climb = 0
      if isKeyPressed(33) then ---> KEY_PRIOR
        climb =  climbSpeed*timeStep
      elseif isKeyPressed(34) then ---> KEY_NEXT
        climb = -climbSpeed*timeStep
      end
      local posX,posY,posZ = camera:getPosition()
      local velX,velY,velZ = camera:getViewDirection()
      local sidX,sidY,sidZ = camera:getSideDirection()
      posX,posY,posZ = bsp:slideCollision(
        posX,posY,posZ,
        step*velX+side*sidX,climb,step*velZ+side*sidZ,
        7,7,7
      )
      camera:setPosition(posX,posY,posZ)
    end
    local rotAngle = 0.15*timeStep
    local dx, dy = getMouseMove()
    if dx ~= 0 then
      camera:rotStanding(-dx*rotAngle)
    end
    if dy ~= 0 then
      camera:pitch(-dy*rotAngle)
    end
  else
    local rotAngle = 0.15*modelTimeStep
    local moveSpeed = 25*modelTimeStep
    local velX,velY,velZ
    local posX,posY,posZ = avatar:getPosition()
    if isKeyPressed(38) or isKeyPressed(40) then ---> KEY_UP || KEY_DOWN
      if AVATAR.legs == 4 then ---> LEGS_IDLE
        AVATAR.isRunning = 1
        AVATAR.runSource:getSound3D():play()
        if isKeyPressed(38) then ---> KEY_UP
          AVATAR.legs = 2 ---> LEGS_RUN
          avatar:setLowerAnimation(2)
        else
          AVATAR.legs = 3 ---> LEGS_BACK
          avatar:setLowerAnimation(3)
        end
      end
      if isKeyPressed(38) then ---> KEY_UP
        moveSpeed = 5*moveSpeed
      elseif isKeyPressed(40) then ---> KEY_DOWN
        moveSpeed = -3.5*moveSpeed
      end
      velX,velY,velZ = avatar:getSideDirection()
      velX = velX*moveSpeed
      velY = velY*moveSpeed-5.8
      velZ = velZ*moveSpeed
    else
      if AVATAR.isRunning == 1 then
        AVATAR.legs = 4 ---> LEGS_IDLE
        avatar:setLowerAnimation(4)
        AVATAR.isRunning = 0
        AVATAR.runSource:getSound3D():stop()
      end
      if isKeyPressed(37) or isKeyPressed(39) then ---> KEY_LEFT || KEY_RIGHT
        if (AVATAR.isRunning == 0) and (AVATAR.isStrafing == 0) then
          AVATAR.isStrafing = 1
          AVATAR.runSource:getSound3D():play()
          avatar:setLowerAnimation(5) ---> LEGS_TURN
        end
        PLAY.rotateIfNeeded(modelTimeStep)
        moveSpeed = 2*moveSpeed
        if isKeyPressed(39) then ---> KEY_RIGHT
          moveSpeed = -moveSpeed
        end
        velX,velY,velZ = avatar:getUpDirection()
        velX = velX*moveSpeed
        velY = velY*moveSpeed-5.8
        velZ = velZ*moveSpeed
      else
        if AVATAR.isStrafing == 1 then
          AVATAR.isStrafing = 0
          AVATAR.runSource:getSound3D():stop()
          avatar:setLowerAnimation(4) ---> LEGS_IDLE
        end
        velX,velY,velZ = 0,-5.8,0
      end
    end
    posX,posY,posZ = bsp:slideCollision(
      posX,posY,posZ,velX,velY,velZ,8,12,8
    )
    avatar:setPosition(posX,posY,posZ);
    local dx,dy = getMouseMove()
    if dx ~= 0 then
      local headAngle = avatar:getHead():getYawAngle()
      if headAngle ~= 0 then
        local newHeadAngle = headAngle-dx*rotAngle
        if headAngle*newHeadAngle < 0 then
          avatar:getHead():setYawAngle(0)
          avatar:getUpper():addYawAngle(newHeadAngle-headAngle,1.047)
        else
          avatar:getHead():addYawAngle(-dx*rotAngle,1.5708)
        end
      else
        local diff = avatar:getUpper():addYawAngle(-dx*rotAngle,1.047)
        if diff ~= 0 then
          avatar:getHead():addYawAngle(diff,1.5708)
        end
      end
    end
    if AVATAR.isRunning == 1 then
      PLAY.rotateIfNeeded(modelTimeStep)
    end
    if dy ~= 0 then
      local headAngle = avatar:getHead():getPitchAngle()
      if headAngle ~= 0 then
        local newHeadAngle = headAngle-dy*rotAngle
        if headAngle*newHeadAngle < 0 then
          avatar:getHead():setPitchAngle(0)
          avatar:getUpper():addPitchAngle(
            newHeadAngle-headAngle,1.047,-.5236
          )
        else
          avatar:getHead():addPitchAngle(
            -dy*rotAngle,.5236,-.7854
          )
        end
      else
        local diff = avatar:getUpper():addPitchAngle(
          -dy*rotAngle,1.047,-.5236
        )
        if diff ~= 0 then
          avatar:getHead():addPitchAngle(diff,.5236,-7854)
        end
      end
    end
    local target = Reference()
    target:set(avatar)
    target:rotateT(avatar:getUpper())
    target:rotateT(avatar:getHead())
    target:exchangeYZX()
    local posX,posY,posZ = target:getPosition()
    posY = posY+25
    local velX,velY,velZ = target:getViewDirection()
    velX,velY,velZ = -45*velX,-45*velY,-45*velZ
    posX,posY,posZ = bsp:checkCollision(posX,posY,posZ,velX,velY,velZ,4,4,4)
    target:setPosition(posX,posY,posZ)
    local camX,camY,camZ = camera:getPosition()
    local pathX,pathY,pathZ = posX-camX,posY-camY,posZ-camZ
    local dist = math.sqrt(pathX*pathX+pathY*pathY+pathZ*pathZ)
    local speed;
    if dist < 200 then
      speed = 250
    elseif dist < 400 then
      speed = 500
    else
      speed = 1000
    end
    local interpolation = speed*timeStep/dist
    if interpolation > 1 then
      interpolation = 1
    end
    camera:interpolate(target,interpolation)
    camera:setPosition(
      camX+interpolation*pathX,
      camY+interpolation*pathY,
      camZ+interpolation*pathZ
    )
  end
end

----FINALIZATION----

function PLAY.final()
  ALL.stopSoundtrack(PLAY.SIM)
  local AVATAR = PLAY.AVATAR
  if AVATAR.weapon then
    AVATAR.weapon:delete()
    AVATAR.weapon = nil
  end
  PLAY.AVATAR = nil
  PLAY.SIM = nil
  empty()
  emptyOverlay()
end

----KEYBOARD----

function PLAY.keyDown(key)
  if key == 32 then ---> KEY_RETURN
    releaseKey(32)
    if PLAY.AVATAR.alive then
      PLAY.AVATAR.flyModeActive = 1-PLAY.AVATAR.flyModeActive
      if PLAY.AVATAR.flyModeActive == 1 then
        local camera = getCamera()
        local posX,posY,posZ = camera:getPosition()
        camera:set(PLAY.AVATAR.object)
        camera:exchangeYZX()
        camera:setPosition(posX,posY,posZ)
      end
    end
  elseif key == 107 then ---> KEY_ADD
    releaseKey(107)
    PLAY.SIM.timeMultiplier = PLAY.SIM.timeMultiplier*2
    if PLAY.SIM.timeMultiplier > 2 then
      PLAY.SIM.timeMultiplier = 2
    end
  elseif key == 109 then ---> KEY_SUBTRACT
    releaseKey(109)
    PLAY.SIM.timeMultiplier = PLAY.SIM.timeMultiplier/2
    if PLAY.SIM.timeMultiplier < 0.125 then
      PLAY.SIM.timeMultiplier = 0.125
    end
  elseif key == 13 then ---> KEY_RETURN
    releaseKey(13)
    setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
  elseif key == string.byte("1") then
    releaseKey(string.byte("1"))
    setScene(Scene(PLAY.init,PLAY.update,PLAY.final,PLAY.keyDown))
  end
end

-------------------
----SCENE SETUP----
-------------------
setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
