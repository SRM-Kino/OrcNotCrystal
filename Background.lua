local background = {}

background.offsetImages = {
  sx = 1.1,
  sy = 1,
  caveX = 610,
  caveY = 450,
  caveSx = 1.5,
  caveSy = 1.5
}

background.image = {
  layer1 = love.graphics.newImage("Images/Background/background_layer_1.png"),
  layer2 = love.graphics.newImage("Images/Background/background_layer_2.png"),
  layer3 = love.graphics.newImage("Images/Background/background_layer_3.png"),
  layer1Cave = love.graphics.newImage("Images/Background/backgroundCave_layer_1.png"),
  layer2Cave = love.graphics.newImage("Images/Background/backgroundCave_layer_2.png"),
  layer3Cave = love.graphics.newImage("Images/Background/backgroundCave_layer_3.png")
}
local tiers = 0.33
background.Draw = function()
  --Arbres
  love.graphics.draw(
    background.image.layer1,
    screenWidth / 2,
    background.image.layer1:getHeight() * tiers,
    0,
    background.offsetImages.sx,
    background.offsetImages.sy,
    background.image.layer1:getWidth() * 0.5,
    background.image.layer1:getHeight() * 0.5
  )
  love.graphics.draw(
    background.image.layer2,
    screenWidth / 2,
    background.image.layer2:getHeight() * tiers,
    0,
    background.offsetImages.sx,
    background.offsetImages.sy,
    background.image.layer2:getWidth() * 0.5,
    background.image.layer2:getHeight() * 0.5
  )
  love.graphics.draw(
    background.image.layer3,
    screenWidth / 2,
    background.image.layer3:getHeight() * tiers,
    0,
    background.offsetImages.sx,
    background.offsetImages.sy,
    background.image.layer3:getWidth() * 0.5,
    background.image.layer3:getHeight() * 0.5
  )
  --Cave
  love.graphics.draw(
    background.image.layer1Cave,
    background.offsetImages.caveX,
    background.offsetImages.caveY,
    0,
    background.offsetImages.caveSx,
    background.offsetImages.caveSy,
    background.image.layer1Cave:getWidth() * 0.5,
    background.image.layer1Cave:getHeight() * 0.5
  )
  love.graphics.draw(
    background.image.layer2Cave,
    background.offsetImages.caveX,
    background.offsetImages.caveY,
    0,
    background.offsetImages.caveSx,
    background.offsetImages.caveSy,
    background.image.layer2Cave:getWidth() * 0.5,
    background.image.layer2Cave:getHeight() * 0.5
  )
  love.graphics.draw(
    background.image.layer3Cave,
    background.offsetImages.caveX,
    background.offsetImages.caveY,
    0,
    background.offsetImages.caveSx,
    background.offsetImages.caveSy,
    background.image.layer3Cave:getWidth() * 0.5,
    background.image.layer3Cave:getHeight() * 0.5
  )
end

return background
