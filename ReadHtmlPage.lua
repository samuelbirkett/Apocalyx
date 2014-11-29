hostName = "localhost"
pageName = "/index.php"

--INIT FUNCTION--
function init()
print("\n\nRemember to set 'hostName' in 'ReadHtmlPage.lua'\n")
showConsole(false)
host = Host(hostName)
if host then
  socket = SocketStream()
  if socket:connect(host) then
    print("\nCONNECTED")
    while true do
      print("\nWAITING")
      if socket:waitForEvent(1000) then
        if socket:isReadEvent() then
          print("\nREAD EVENT")
          if socket:receive() then
            print("\nRECEIVED")
            print(socket:getBuffer())
          else
            print("\nNOT RECEIVED")
            break
          end
        elseif socket:isConnectEvent() then
          print("\nCONNECT EVENT")
          socket:getFile(pageName)
        elseif socket:isCloseEvent() then
          print("\nCLOSE EVENT")
          break
        end
      else
        break
      end
    end
    socket:disconnect()
    socket:delete()
  else
    print("\nNOT CONNECTED\n")
  end
  host:delete()
else
  print("\nHOST ERROR\n'")
end
print("\nPress 'ENTER' to go back to demos menu")
end --INIT

--UPDATE FUNCTION--
function update()
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
end

--SETUP THE SCENE (RUN)--
setScene(Scene(init,update,final,keyDown))
