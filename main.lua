----The 'APOCALYX 3D Engine' executes this file by default.
----The following code list the available LUA files and let the
----user choose one of them for execution.
----Questions? Contact: leo <tetractys@users.sourceforge.it>

----INITIALIZATION----Sets the help strings
function init()
  emptyOverlay()
  empty()
  help = {}
  demoFileNames = listFiles("*.lua")
  demoOffset = 0
  help[1] = "Choose a LUA demo file:"
  help[2] = ""
  local DEMO_COUNT = table.getn(demoFileNames)
  local MAX_LINES = DEMO_COUNT
  if MAX_LINES > 9 then
    MAX_LINES = 9
  end
  for ct = 1, MAX_LINES do
    help[2+ct] = "[  "..ct.."  ] "..demoFileNames[ct]
  end
  if DEMO_COUNT > 9 then
    help[12] = ""
    help[13] = "[ENTER] List Further Demos"
  end
  setHelp(help)
  hideConsole()
  showHelpUser()
end

----LOOP----Nothing to do
function update()
end

----KEY----Starts the demo of choice
function keyDown(key)
  releaseKey(key)
  if key == 13 then
    help = {}
    local DEMO_COUNT = table.getn(demoFileNames)
    demoOffset = demoOffset+9
    if demoOffset >= DEMO_COUNT then
      demoOffset = 0
    end
    local MAX_LINES = DEMO_COUNT-demoOffset
    if MAX_LINES > 9 then
      MAX_LINES = 9
    end
    help[1] = "Choose a LUA demo file:"
    help[2] = ""
    for ct = 1, MAX_LINES do
      help[ct+2] = "[  "..ct.."  ] "..demoFileNames[demoOffset+ct]
    end
    if DEMO_COUNT > 9 then
      help[MAX_LINES+3] = ""
      help[MAX_LINES+4] = "[ENTER] List Further Demos"
    end
    setHelp(help)
  elseif key >= string.byte("1") and key <= string.byte("9") then
    local DEMO_COUNT = table.getn(demoFileNames)
    local MAX_LINES = DEMO_COUNT-demoOffset
    local diff = key-string.byte("0")
    if diff <= MAX_LINES then
      showLoadingScreen()  
      dofile(demoFileNames[demoOffset+diff])
    end
  end
end

----FINALIZATION----None
function final()
  demoFileNames = nil
  demoOffset = nil
  help = nil
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
