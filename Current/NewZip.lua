----New Zip DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  showConsole(false)
  print("\nCreate ZIP file: \"newZip.zip\"")
  local zip = NewZip("newZip.zip")
  if zip then 
    print("Create new file in ZIP file: \"data.txt\"")
    local ok = zip:openFile("data.txt")
    if ok then
      local string = "Data stored in ZIP file\r\nas a text file."
      print("Write data in new file in ZIP file:\n\"",string,"\"")
      zip:writeInFile(string)
    else
      print("Error creating file in ZIP")
    end
  else
    print("Error creating ZIP")
  end
  zip:delete()
  print("Open ZIP file: \"newZip.zip\"")
  zip = Zip("newZip.zip")
  if zip then
    print("Reading \"data.txt\" from ZIP file")
    local string = zip:getString("data.txt")
    if string then
      print("The text is:\n")
      print(string)
    else
      print("Error reading file in ZIP")
    end
  else
    print("Error opening ZIP file")
  end
  print("\nPress 'ENTER' to go back to demos menu")
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
