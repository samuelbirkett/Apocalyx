----AUDIO_CD DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  showConsole(false)
  print("\nPress 'ENTER' to go back to demos menu")
  local drives = getCdDrivesCount()
  print("CD-Rom Drives Count:",drives)
  local full = -1
  for ct = 0,drives-1 do
    local cd = AudioCd(ct)
    if cd:isEmpty() then
      print("CD-Rom Drive",ct,"is empty")
    else
      print("CD-Rom Drive",ct,"is full")
      full = ct
    end
    cd:delete()
  end
  if full >= 0 then
    cdFull = AudioCd(full)
    print("Tracks in CD:",cdFull:getTracksCount())
    local isMusic, len, offs = cdFull:getTrackInfo(0)
    local isMusicString
    if isMusic then
      isMusicString = "music"
    else
      isMusicString = "data"
    end
    print("Track is ",isMusicString,"with len",len,"frames and offset",offs)
    print("Length is seconds:",len/75)
    print("Playing 15 sec of track 0")
    cdFull:playTracks(0,0,0,75*15)
  end
  for ct = 0,drives-1 do
    if ct ~= full then
      print("Opening CD-Rom Drive",ct)
      local cd = AudioCd(ct)
      cd:eject()
      cd:delete()
    end
  end
end

----LOOP----
function update()
end

----FINALIZATION----
function final()
  if cdFull then
    cdFull:delete()
    cdFull = nil
  end
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
