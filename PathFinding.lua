----PATH FINDING DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

------------------
----MENU SCENE----
------------------

cc = Compiler()
ok = cc:compileString([[
float leastCostEstimate(int nodeA, int nodeB) {
  int a = nodeA-1;
  int b = nodeB-1;
  int aX = a/4;
  int aY = a%4;
  int bX = b/4;
  int bY = b%4;
  float diffX = aX-bX;
  float diffY = aY-bY;
  return diffX*diffX+diffY*diffY;
}
int neighsCount[17] = {
  0,
  2, 3, 3, 2,
  3, 4, 4, 3,
  3, 4, 4, 3,
  2, 3, 3, 2
};
int neighs[17][4] = {
  {0,0,0,0},
  {2, 5, 0, 0}, {1, 6, 3, 0}, {2, 7, 4, 0}, {3, 8, 0, 0},
  {1, 6, 9, 0}, {2, 7, 10, 5}, {3, 8, 11, 6}, {4, 7, 12, 0},
  {5,10,13, 0}, {6,11,14,9}, {7,12,15,10}, {8,11,16, 0},
  {9,14, 0, 0}, {13,10,15, 0}, {14,11,16, 0}, {12,15, 0, 0}
};
float costs[17][4] = {
  {0,0,0,0},
  {1, 1, 0, 0}, {1, 1, 1, 0}, {1, 1, 1, 0}, {1, 1, 0, 0},
  {1, 1, 1, 0}, {1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 0},
  {1, 1, 1, 0}, {1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 0},
  {1, 1, 0, 0}, {1, 1, 1, 0}, {1, 1, 1, 0}, {1, 1, 0, 0}
};
int adjacentCost(int node, int** n, float** c) {
  if(node <= 0) return 0;
  *n = neighs[node];
  *c = costs[node];
  return neighsCount[node];
}
]])
if ok then
  ok = cc:link()
end
if ok then
  leastCostEstimate = cc:getFunction("leastCostEstimate")
  adjacentCost = cc:getFunction("adjacentCost")
end

path = PathFound()
  
finder = PathFinder()
finder:setLeastCostEstimate(leastCostEstimate)
finder:setAdjacentCost(adjacentCost)
finder:solve(1,16,path)
print("\nPath. Cost = ",path:getCost(),"; Size = ",path:getSize())
for ct = 0,path:getSize()-1 do
  print("node ",ct,": ",path:getNode(ct))
end

leastCostEstimate = nil
adjacentCost = nil
ok = nil
path:delete()
finder:delete()
cc:delete()

----INITIALIZATION----
function init()
  showConsole(false)
  print("Press 'ENTER' to go back to demos menu")
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
