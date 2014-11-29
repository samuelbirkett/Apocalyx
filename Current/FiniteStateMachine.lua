----INITIALIZATION----

function printDropSnack()
  print("Snack dropped!")
end

function printDropCola()
  print("Cola dropped!")
end

function init()
  showConsole(false)
  print("\nS N A C K   M A C H I N E")
  print("Demo of several features of FSM\n")
  print("The machine provides snacks at 50 cents,")
  print("drinks at 60 cents and gives no change.")
  print("With an excess of 3 coins the machine")
  print("resets and you lose your money.")
  print("Press 'A' to insert 10 cents")
  print("press 'B' to insert 50 cents")
  print("press 'C' to drop snack")
  print("press 'D' to drop cola")
  print("press 'ENTER' to go back to demos menu")
  print("---------")
  fsm = FiniteStateMachine()
  local var = fsm:addVariable("excess")
  local state = fsm:addState("start")
  local actionSet = state:addLeaveActionSet()
  actionSet:setVariable("excess")
  actionSet:setValue(0)
  state:addTransition("total 10","pressed A")
  state:addTransition("total 50","pressed B")
  state = fsm:addState("total 10")
  state:addTransition("total 20","pressed A")
  state:addTransition("total 60","pressed B")
  state = fsm:addState("total 20")
  state:addTransition("total 30","pressed A")
  state:addTransition("total too much","pressed B")
  state = fsm:addState("total 30")
  state:addTransition("total 40","pressed A")
  state:addTransition("total too much","pressed B")
  state = fsm:addState("total 40")
  state:addTransition("total 50","pressed A")
  state:addTransition("total too much","pressed B")
  state = fsm:addState("total 50")
  state:addTransition("total 60","pressed A")
  state:addTransition("total too much","pressed B")
  local transition = state:addTransition("start","pressed C")
  local actionCall = transition:addActionCall()
  actionCall:setFunction("printDropSnack")
  state = fsm:addState("total 60")
  state:addTransition("total too much","pressed A")
  state:addTransition("total too much","pressed B")
  transition = state:addTransition("start","pressed C")
  actionCall = transition:addActionCall()
  actionCall:setFunction("printDropSnack")
  transition = state:addTransition("start","pressed D")
  actionCall = transition:addActionCall()
  actionCall:setFunction("printDropCola")
  state = fsm:addState("total too much")
  transition = state:addTransition("total too much","pressed A")
  local actionIncr = transition:addActionIncr()
  actionIncr:setVariable("excess")
  actionIncr:setIncrement(1)
  transition = state:addTransition("total too much","pressed B")
  actionIncr = transition:addActionIncr()
  actionIncr:setVariable("excess")
  actionIncr:setIncrement(1)
  transition = state:addTransition("start","pressed C")
  actionCall = transition:addActionCall()
  actionCall:setFunction("printDropSnack")
  transition = state:addTransition("start","pressed D")
  actionCall = transition:addActionCall()
  actionCall:setFunction("printDropCola")
  transition = state:addTransition("start","ANY")
  local condition = transition:addCondition()
  condition:setCondition("excess",4,3) ---> 4 = GREATER_EQ
  fsm:setInitialState("start")
  fsm:start()
end

----LOOP----
function update()
end

----FINALIZATION----
function final()
  hideConsole()
  fsm:stop()
  fsm:delete()
  fsm = nil
end

----KEYDOWN----
function keyDown(key)
  if key == string.byte("A") then
    print("* Pressed A")
    fsm:processEvent("pressed A")
    fsm:processEvent("ANY")
    local state = fsm:getCurrentState()
    print("State : ",state:getName())
    local excess = fsm:getVariable("excess")
    print("Excess: ",excess)
  elseif key == string.byte("B") then
    print("* Pressed B")
    fsm:processEvent("pressed B")
    fsm:processEvent("ANY")
    local state = fsm:getCurrentState()
    print("State : ",state:getName())
    local excess = fsm:getVariable("excess")
    print("Excess: ",excess)
  elseif key == string.byte("C") then
    print("* Pressed C")
    fsm:processEvent("pressed C")
    local state = fsm:getCurrentState()
    print("State : ",state:getName())
    local excess = fsm:getVariable("excess")
    print("Excess: ",excess)
  elseif key == string.byte("D") then
    print("* Pressed D")
    fsm:processEvent("pressed D")
    local state = fsm:getCurrentState()
    print("State : ",state:getName())
    local excess = fsm:getVariable("excess")
    print("Excess: ",excess)
  elseif key == string.byte("\r") then
    releaseKey(string.byte("\r"))
    hideConsole()
    final()
    dofile("main.lua")
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))

