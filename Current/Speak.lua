----SPEAK DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  showConsole(false)
  local speech = [[
this engine uses Jonathan Duddington's speech synthesizer
]]
  if not speakIsInit() then speakInit() end
  if not speakSetVoice("en\\en") then
    print("voice not found!")
    return
  end
--  speakAsWav("speech.wav",speech)
  print("\neSpeak is saying:")
  print("\n",speech)
  local sample = Sample3D(22050,16)
  sound = sample:create3DSound()
  speak(sound,speech)
  sound:play()
  print("\nFor more information about eSpeak visit")
  print("http://espeak.sourceforge.net")
  print("\nPress 'ENTER' to go back to demos menu")
  print("or write a text to hear it (TAB ends string, BACKSPACE deletes char)")
  ttsString = ""
end

----LOOP----
function update()
end

----FINALIZATION----
function final()
  ttsString = nil
  sound:delete()
  sound = nil
end

----KEYDOWN----
function keyDown(key)
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    hideConsole()
    dofile("main.lua")
    return
  elseif isKeyPressed(string.byte("\t")) then
    sound:reset()
    speak(sound,ttsString)
    sound:play()
    ttsString = ""
    print("\nPress 'ENTER' to go back to demos menu")
    print("or write a text to hear it (TAB ends string, BACKSPACE deletes char)")
  elseif isKeyPressed(string.byte("\b")) then
    ttsString = string.sub(ttsString,1,string.len(ttsString)-1)
    typewrite("\b")
  else
    local chr = string.char(key)
    ttsString = ttsString..chr
    typewrite(chr)
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
