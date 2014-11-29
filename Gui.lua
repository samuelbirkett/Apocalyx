----Gui Demo
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION SUPPORT----

--***--
--[[
function setupPointer(zip)
  local pointerImage = zip:getImage("arrow.png")
  local pointerSize = pointerImage:getDimension()
  local pointerSprite = OverlaySprite(
    pointerSize,pointerSize,Texture(pointerImage),true)
  pointerImage:delete()
  pointerSprite:setLayer(0)
  setPointer(pointerSprite)
  local w, h = getDimension()
  setPointerLocation(w/2,h/2)
  setPointerOffset(-7,7)
  showPointer()
end
]]--

----INITIALIZATION----
function init()
  ----ZIP----
  if not fileExists("DemoPack2.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack2.dat' not found.")
  end
  local zip = Zip("DemoPack2.dat")
  ----GUI----
--***--  setupPointer(zip)
--***--  hidePointer()
  acquireMouse(false);
  guiInitialize("font-data/Vera.ttf")
  GUI = {}
  local GUI = GUI
  local startX, startY = 50, 50
  ----GUI: Skin Frame (checkBoxes)----
  GUI.skinFrame = GuiFrameWindow(startX,startY,startX+300,startY+200)
  GUI.skinFrame:setText("Skins")
  GUI.skinFrame:setMovable()
  GUI.skinsCheckBoxGroup = GuiCheckBoxGroup()
  GUI.skinsCheckBoxA = GuiCheckBox("default",GUI.skinsCheckBoxGroup)
  skinCheckBoxA_Func = function() guiLoadScheme("gui-data/default.xml") end
  GUI.slotHolderSkinCheckBoxA = GuiSlotHolder("skinCheckBoxA_Func")
  GUI.skinsCheckBoxA:connectPressed(GUI.slotHolderSkinCheckBoxA)
  GUI.skinsCheckBoxB = GuiCheckBox("redskin",GUI.skinsCheckBoxGroup)
  skinCheckBoxB_Func = function() guiLoadScheme("gui-data/redskin.xml") end
  GUI.slotHolderSkinCheckBoxB = GuiSlotHolder("skinCheckBoxB_Func")
  GUI.skinsCheckBoxB:connectPressed(GUI.slotHolderSkinCheckBoxB)
  GUI.skinsCheckBoxC = GuiCheckBox("highcontrast",GUI.skinsCheckBoxGroup)
  skinCheckBoxC_Func = function() guiLoadScheme("gui-data/highcontrast.xml") end
  GUI.slotHolderSkinCheckBoxC = GuiSlotHolder("skinCheckBoxC_Func")
  GUI.skinsCheckBoxC:connectPressed(GUI.slotHolderSkinCheckBoxC)
  GUI.skinsCheckBoxGroup:select(GUI.skinsCheckBoxA)
  GUI.skinsPanel = GuiPanel(0,0,300,200)
  local skinsLayouter = GuiBoxLayouter()
  skinsLayouter:setJustification(1) ---> vertical
  skinsLayouter:setSpacing(8)
  skinsLayouter:setChildSizeRespected()
  GUI.skinsPanel:setLayouter(skinsLayouter)
  GUI.skinsPanel:addChildWindow(GUI.skinsCheckBoxA)
  GUI.skinsPanel:addChildWindow(GUI.skinsCheckBoxB)
  GUI.skinsPanel:addChildWindow(GUI.skinsCheckBoxC)
  GUI.skinFrame:setClientWindow(GUI.skinsPanel)
  guiAddWindow(GUI.skinFrame)
  ----GUI: Edit Frame (StaticText, EditField, Button)----
  startX, startY = startX+50, startY+50
  GUI.editFrame = GuiFrameWindow(startX,startY,startX+300,startY+200)
  GUI.editFrame:setText("Edit")
  GUI.editFrame:setMovable()
  GUI.editLabel = GuiStaticText("Text to be changed")
  GUI.editField = GuiEditField("Change this text")
  GUI.editButton = GuiButton("Confirm")
  modifyLabel_Func = function() GUI.editLabel:setText(GUI.editField:getText()) end
  GUI.slotHolderModifyLabel = GuiSlotHolder("modifyLabel_Func")
  GUI.editField:connectReturnPressed(GUI.slotHolderModifyLabel)
  GUI.editButton:connectPressed(GUI.slotHolderModifyLabel)
  GUI.editPanel = GuiPanel(0,0,300,200)
  local editLayouter = GuiFlowLayouter()
  editLayouter:setAlignment(0) ---> left
  GUI.editPanel:setLayouter(editLayouter)
  GUI.editPanel:addChildWindow(GUI.editField)
  GUI.editPanel:addChildWindow(GUI.editButton)
  GUI.editPanel:addChildWindow(GUI.editLabel)
  GUI.editFrame:setClientWindow(GUI.editPanel)
  guiAddWindow(GUI.editFrame)
  ----GUI: Combo Frame (ComboBox)----
  startX, startY = startX+50, startY+50
  GUI.comboFrame = GuiFrameWindow(startX,startY,startX+300,startY+150)
  GUI.comboFrame:setText("Combo Box")
  GUI.comboFrame:setMovable()
  GUI.comboLabel = GuiStaticText("Text to be changed")
  GUI.comboBox = GuiComboBox(0,0,300,25)
  for ct = 1, 20 do
    GUI.comboBox:addString("String"..ct)
  end
  selectionChangedCombo_Func = function()
    GUI.comboLabel:setText(GUI.comboBox:getSelectedString()) end
  GUI.slotHolderSelectionChangedCombo = GuiSlotHolder("selectionChangedCombo_Func")
  GUI.comboBox:connectSelectionChanged(GUI.slotHolderSelectionChangedCombo)
  GUI.comboPanel = GuiPanel(0,0,300,200)
  local comboLayouter = GuiGridLayouter()
  comboLayouter:setRowsCount(2)
  comboLayouter:setColumnsCount(1)
  comboLayouter:setHorizontalSpacing(8)
  comboLayouter:setVerticalSpacing(4)
  GUI.comboPanel:setLayouter(comboLayouter)
  GUI.comboPanel:addChildWindow(GUI.comboLabel)
  GUI.comboPanel:addChildWindow(GUI.comboBox)
  GUI.comboFrame:setClientWindow(GUI.comboPanel)
  guiAddWindow(GUI.comboFrame)
  ----GUI: List Frame (ListBox)----
  startX, startY = startX+50, startY+50
  GUI.listFrame = GuiFrameWindow(startX,startY,startX+300,startY+200)
  GUI.listFrame:setText("List Box")
  GUI.listFrame:setMovable()
  GUI.listLabel = GuiStaticText("Text to be changed")
  GUI.listBox = GuiListBox(0,0,300,25)
  for ct = 1, 20 do
    GUI.listBox:addString("String"..ct)
  end
  selectionChangedList_Func = function()
    GUI.listLabel:setText(GUI.listBox:getStringAt(GUI.listBox:getSelectedIndex())) end
  GUI.slotHolderSelectionChangedList = GuiSlotHolder("selectionChangedList_Func")
  GUI.listBox:connectSelectionChanged(GUI.slotHolderSelectionChangedList)
  GUI.listPanel = GuiPanel(0,0,300,200)
  local listLayouter = GuiGridLayouter()
  listLayouter:setRowsCount(2)
  listLayouter:setColumnsCount(1)
  listLayouter:setHorizontalSpacing(8)
  listLayouter:setVerticalSpacing(4)
  GUI.listPanel:setLayouter(listLayouter)
  GUI.listPanel:addChildWindow(GUI.listLabel)
  GUI.listPanel:addChildWindow(GUI.listBox)
  GUI.listFrame:setClientWindow(GUI.listPanel)
  guiAddWindow(GUI.listFrame)
  ----GUI: Progress Frame (ProgressBar)----
  startX, startY = startX+50, startY+50
  GUI.progressFrame = GuiFrameWindow(startX,startY,startX+300,startY+100)
  GUI.progressFrame:setText("Progress Bar")
  GUI.progressFrame:setMovable()
  GUI.progressBar = GuiProgressBar(0,0,300,25)
  GUI.timer = GuiTimer()
  GUI.timer:setInterval(0.5)
  GUI.timer:start()
  trigger_Func = function()
    local p = GUI.progressBar:getPercentage()+5
    if p > 100 then p = 0 end
    GUI.progressBar:setPercentage(p)
    GUI.timer:start()
  end
  GUI.slotHolderTrigger = GuiSlotHolder("trigger_Func")
  GUI.timer:connectTrigger(GUI.slotHolderTrigger)
  guiAddTimer(GUI.timer)
  GUI.progressFrame:setClientWindow(GUI.progressBar)
  guiAddWindow(GUI.progressFrame)
  ----GUI: Slideable (ScrollBar, Slider, SpinBox)----
  startX, startY = startX+50, startY+50
  GUI.sliFrame = GuiFrameWindow(startX,startY,startX+300,startY+150)
  GUI.sliFrame:setText("Slideable")
  GUI.sliFrame:setMovable()
  GUI.sliScrollBar = GuiScrollBar(0, 0,0, 100)
  GUI.sliSlider = GuiSlider(0, 0,0,300,100)
  GUI.sliSpinBox = GuiSpinBox()
  GUI.sliPanel = GuiPanel(0,0,300,300)
  local sliLayouter = GuiGridLayouter()
  sliLayouter:setRowsCount(3)
  sliLayouter:setColumnsCount(1)
  sliLayouter:setHorizontalSpacing(8)
  sliLayouter:setVerticalSpacing(4)
  GUI.sliPanel:setLayouter(sliLayouter)
  GUI.sliPanel:addChildWindow(GUI.sliScrollBar)
  GUI.sliPanel:addChildWindow(GUI.sliSlider)
  GUI.sliPanel:addChildWindow(GUI.sliSpinBox)
  GUI.sliFrame:setClientWindow(GUI.sliPanel)
  guiAddWindow(GUI.sliFrame)
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, .522,.373,.298)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2,-7.5)
  empty()
  ----SKYBOX----
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
  local rotAngle = .13*timeStep
  camera:rotAround(rotAngle)
  camera:pointTo(0,2,0)
  ----MOVE POINTER (MOUSE)----
  local dx, dy = getMouseMove()
  local w, h = getDimension()
  movePointer(dx,dy,w,h,0,0)
end

----FINALIZATION----
function final()
--***--  hidePointer()
  ----GUI----
  guiRemoveAllWindows()
  GUI.skinFrame:delete()
  GUI.skinsCheckBoxA:delete()
  skinCheckBoxA_Func = nil
  GUI.slotHolderSkinCheckBoxA:delete()
  GUI.skinsCheckBoxB:delete()
  skinCheckBoxB_Func = nil
  GUI.slotHolderSkinCheckBoxB:delete()
  GUI.skinsCheckBoxC:delete()
  skinCheckBoxC_Func = nil
  GUI.slotHolderSkinCheckBoxC:delete()
  GUI.skinsPanel:delete()
  GUI.skinsCheckBoxGroup:delete()
  GUI.editFrame:delete()
  GUI.editLabel:delete()
  GUI.editField:delete()
  GUI.editButton:delete()
  modifyLabel_Func = nil
  GUI.slotHolderModifyLabel:delete()
  GUI.editPanel:delete()
  GUI.comboFrame:delete()
  GUI.comboLabel:delete()
  GUI.comboBox:delete()
  selectionChangedCombo_Func = nil
  GUI.slotHolderSelectionChangedCombo:delete()
  GUI.comboPanel:delete()
  GUI.listFrame:delete()
  GUI.listLabel:delete()
  GUI.listBox:delete()
  selectionChangedList_Func = nil
  GUI.slotHolderSelectionChangedList:delete()
  GUI.listPanel:delete()
  GUI.progressFrame:delete()
  GUI.progressBar:delete()
  GUI.timer:stop()
  trigger_Func = nil
  GUI.slotHolderTrigger:delete()
  guiRemoveTimer(GUI.timer)
  GUI.timer:delete()
  GUI.sliFrame:delete()
  GUI.sliScrollBar:delete()
  GUI.sliSlider:delete()
  GUI.sliSpinBox:delete()
  GUI.sliPanel:delete()
  for key, val in pairs(GUI) do
    GUI.key = nil
  end
  GUI = nil
  guiTerminate()
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----KEYBOARD----
function keyDown(key)
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
