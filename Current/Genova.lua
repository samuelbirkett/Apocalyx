----GENOVA DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

------------------
----MENU SCENE----
------------------

-----------------------
----BSP LEVEL SCENE----
-----------------------

----BSP INITIALIZATION----
function BSP_init()
  showLoadingScreen()
  ----CAMERA----
  empty()
  setAmbient(.2,.2,.2)
  setPerspective(60,3,12000)
  local camera = getCamera()
  camera:reset()
  camera:move(20*32,15*32,0)
  ----SKYBOX----
  if not fileExists("Genova.dat") then
    showConsole()
    error("\nERROR: File 'Genova.dat' not found.")
  end
  local zip = Zip("Genova.dat")
  local skyTxt = {
    zip:getTexture("cielo4_rt.jpg"),
    zip:getTexture("cielo4_ft.jpg"),
    zip:getTexture("cielo4_lf.jpg"),
    zip:getTexture("cielo4_bk.jpg"),
    zip:getTexture("cielo4_up.jpg"),
    zip:getTexture("cielo4_dn.jpg")
  }
  local sky = Sky(skyTxt)
  setBackground(sky)
  ----SUN----
  local tetha = 118/180*3.1415
  local phi = 35/180*3.1415
  local dirX = math.cos(phi)*math.cos(tetha)
  local dirZ = math.cos(phi)*math.sin(tetha)
  local dirY = math.sin(phi)
  sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    dirX, dirY, dirZ,
    zip:getTexture("lensflares.png"),
    5, 0.2
  )
  sun:setColor(0.855,0.475,0.298);
  setSun(sun)
  ----BSP----
  bsp = zip:getLevel("max_zena_c.bsp",0.6)
  bsp:setShowUntexturedMeshes()
  bsp:setShowUntexturedPatches()
  bsp:setShowTransparencies()
  bsp:setDefaultTexture(zip:getTexture("textures/max_caruggi/mmurodirt2a.jpg",1))
  setScenery(bsp)
  collSet = true
  ----HELP----
  local help = {
    "Title : 'Zena on my mind' (Genoa, Italy)",
    "Date  : May.04.2006",
    "Author: massimagnus, Italy",
    "Email : massimagnus@tin.it",
    "URL   : http://xoomer.virgilio.it/massimagnus/maps/",
    " ",
    "[   MOUSE  ] Look around",
    "[  UP/DOWN ] Move Forward/Back",
    "[LEFT/RIGHT] Rotate Left/Right",
    "[    C     ] Set/Unset Collisions",
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

----BSP LOOP----
function BSP_update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end 
  if isKeyPressed(38) or isKeyPressed(40) then ---> VK_UP || VK_DOWN
    local posX,posY,posZ = camera:getPosition()
    local moveSpeed = 400
    local k = timeStep*moveSpeed
    if isKeyPressed(40) then ---> VK_UP
      k = -k
    end
    local velX,velY,velZ = camera:getViewDirection()
    if collSet then
      posX,posY,posZ =
        bsp:slideCollision(posX,posY,posZ,k*velX,k*velY,k*velZ,14,14,14)
      camera:setPosition(posX,posY,posZ)
    else
      camera:setPosition(posX+k*velX,posY+k*velY,posZ+k*velZ)
    end
  end
  local rotAngle = 0.15*timeStep
  local dx, dy = getMouseMove()
  if dx ~= 0 then
    camera:rotStanding(-dx*rotAngle)
  end
  if dy ~= 0 then
    camera:pitch(-dy*rotAngle)
  end
end

----BSP FINALIZATION----
function BSP_final()
  ----DELETE GLOBALS----
  bsp = nil
  emptyOverlay()
  empty()
end

----BSP KEYBOARD----
function BSP_keyDown(key)
  if key == string.byte("C") then
    if collSet then
      collSet = false
    else
      collSet = true
    end
  end
end

-------------------
----SCENE SETUP----
-------------------
setScene(Scene(BSP_init,BSP_update,BSP_final,BSP_keyDown))

