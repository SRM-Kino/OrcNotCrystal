-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")
love.window.setTitle("Not Orc's Crystal")

font = love.graphics.newFont("Fonts/ThaleahFat.ttf", 20)
require("SceneManager")

--Taille de l'écran
love.window.setMode(816, 600)

function math.angle(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end
    
function math.dist(x1, y1, x2, y2)
  return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end
  
function FindClosestEnnemy(list)
  --On considère que le premier est le plus proche
  local mini = list[1]
  local id = 1
  for i = 2, #list do
      if list[i] < mini then
          mini = list[i]
          id = i
      end
  end
  return mini, id
end
    
function FindFarthestEnnemy(list)
  --On considère que le premier est le plus loin
  local maxi = list[1]
  local id = 1
  for i = 2, #list do
      if list[i] > maxi then
          mini = list[i]
          id = i
      end
  end
  return maxi, id
end

function love.load()
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  ChangeScene("MENU")
end

function love.update(dt)
  UpdateCurrentScene(dt)
end

function love.draw()
  DrawCurrentScene()
end

function love.keypressed(key)
  keypressedCurrentScene(key)
end

function love.mousepressed(x, y, button)
  mousepressedCurrentScene(x, y, button)
end
