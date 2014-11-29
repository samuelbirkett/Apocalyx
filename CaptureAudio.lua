----INITIALIZATION----
function init()
  local FREQUENCY = 22050
  local BITS = 8
  captureDevice = CaptureDevice(FREQUENCY*3,FREQUENCY,BITS)
  sample = Sample3D(FREQUENCY,BITS)
  sample:setVolume(255)
  showConsole(false)
  print("\nC A P T U R E   A U D I O")
  print("press 'B' to start microphone acquisition")
  print("press 'C' to capture sound data")
  print("press 'E' to stop microphone data")
  print("press 'P' to play sound data")
  print("press 'S' to save sound data to WAV")
  print("press 'ENTER' to go back to demos menu")
  print("---------")
end

----LOOP----
function update()
end

----FINALIZATION----
function final()
  sample:delete()
  sample = nil
  captureDevice:delete()
  captureDevice = nil
  hideConsole()
end

----KEYDOWN----
function keyDown(key)
  if key == string.byte("B") then
    print("Acquisition START")
    captureDevice:start()
  elseif key == string.byte("E") then
    print("Acquisition STOP")
    captureDevice:stop()
  elseif key == string.byte("C") then
    print("3 seconds sound captured")
    captureDevice:capture()
  elseif key == string.byte("P") then
    print("sound data played")
    captureDevice:writeToSample3D(sample)
    sample:playAt(0,0,0)
  elseif key == string.byte("S") then
    print("3 seconds sound saved to \"sound.wav\"")
    captureDevice:saveAsWav("sound.wav")
  elseif key == string.byte("\r") then
    releaseKey(string.byte("\r"))
    hideConsole()
    final()
    dofile("main.lua")
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))

