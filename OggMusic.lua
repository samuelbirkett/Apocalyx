----OggMusic DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  showConsole(false)
  print("\n*** Playing OggVorbis Music ***")
  oggMusic = OggMusic("music-data/stereo.ogg")
  if oggMusic then
    oggMusic:play()
  else
    print("Can't find 'music-data/stereo.ogg' music file.")
  end
  print("\nPress 'ENTER' to go back to demos menu")
end

----LOOP----
function update()
end

----FINALIZATION----
function final()
  if oggMusic then
    oggMusic:stop()
    oggMusic:delete()
    oggMusic = nil
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
