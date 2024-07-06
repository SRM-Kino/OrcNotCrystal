local scene = {}
--Scène de Menu
local BGMenu = {
  image = love.graphics.newImage("Images/BackGround/StartGame.png"),
  x = 816 / 2,
  y = 600 / 2
}
local buttonStart = {
  x = 280,
  y = 530,
  width = 270,
  height = 60
}
scene.Load = function(needInit)
  -- Chargement de la scène
  print("Chargement de la scène MENU")
end

local mouseState
local oldMouseState
local startGame = false

scene.Update = function(dt)
end
local scale = {
  x = 0.85,
  y = 0.6
}
scene.Draw = function()
  love.graphics.draw(
    BGMenu.image,
    BGMenu.x,
    BGMenu.y,
    0,
    scale.x,
    scale.y,
    BGMenu.image:getWidth() * 0.5,
    BGMenu.image:getHeight() * 0.5
  )
  love.graphics.setFont(font)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Press Enter", 370, 500)
  love.graphics.setColor(1, 1, 1)
end

scene.keypressed = function(key)
  if key == "return" then
    ChangeScene("GAME", true)
  end
end

scene.mousepressed = function(x, y, button)
  if
    x >= buttonStart.x and x <= buttonStart.x + buttonStart.width and y >= buttonStart.y and
      y <= buttonStart.y + buttonStart.height and
      button == 1
   then
    ChangeScene("GAME", true)
  end
end
scene.Unload = function()
  --Déchargement de la scène
  print("Déchargement de la scène MENU")
end

return scene
