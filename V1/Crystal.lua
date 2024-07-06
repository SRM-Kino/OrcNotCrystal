local crystal = {}

crystal.imageDimensions = {
  WIDTH = 64,
  HEIGHT = 64
}

crystal.Animation = {
  frame = 1,
  maxFrame = 24,
  spriteSheet,
  spriteTexture = {}
}

crystalLife = 1000
crystal.maxLife = 1000
crystal.percentLife = 100
local roundFrame

crystal.LoadImages = function()
  crystal.Animation.spriteSheet = love.graphics.newImage("Images/Crystal/CrystalSpriteSheet.png")
  local nbCollumns = crystal.Animation.spriteSheet:getWidth() / crystal.imageDimensions.WIDTH
  local nbLines = crystal.Animation.spriteSheet:getHeight() / crystal.imageDimensions.HEIGHT
  local l, c
  local id = 1
  for l = 1, nbLines do
    for c = 1, nbCollumns do
      crystal.Animation.spriteTexture[id] =
        love.graphics.newQuad(
        (c - 1) * crystal.imageDimensions.WIDTH,
        (l - 1) * crystal.imageDimensions.HEIGHT,
        crystal.imageDimensions.WIDTH,
        crystal.imageDimensions.HEIGHT,
        crystal.Animation.spriteSheet
      )
      id = id + 1
    end
  end
end

crystal.UpdateAnimation = function(dt)
  crystal.Animation.frame = crystal.Animation.frame + dt * 10
  if crystal.Animation.frame >= crystal.Animation.maxFrame + 1 then
    crystal.Animation.frame = 1
  end
  roundFrame = math.floor(crystal.Animation.frame)
end

local offsetGoalY = 25
crystal.Load = function()
  print("Chargement du crystal ... ")
  crystal.LoadImages()
  crystal.x = screenWidth * 0.5
  crystal.y = 250
  crystal.goalY = crystal.y + offsetGoalY
  crystalLife = crystal.maxLife
  print("Chargement du crystal terminé ... ")
end

crystal.Update = function(dt)
  crystal.UpdateAnimation(dt)
  --Pourcentage de vie
  crystal.percentLife = (crystalLife * 100) / crystal.maxLife
  --Fin du jeu
  if crystalLife <= 0 then
    crystalLife = 0
  end
end

local offseyLifePos = {
  x = 50,
  y = 70,
  height = 10
}
crystal.Draw = function()
  love.graphics.draw(
    crystal.Animation.spriteSheet,
    crystal.Animation.spriteTexture[roundFrame],
    crystal.x,
    crystal.y,
    0,
    1,
    1,
    crystal.imageDimensions.WIDTH * 0.5,
    crystal.imageDimensions.HEIGHT * 0.5
  )
  --Rouge
  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle(
    "fill",
    crystal.x - offseyLifePos.x,
    crystal.y - offseyLifePos.y,
    crystal.percentLife,
    offseyLifePos.height
  )
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", crystal.x - offseyLifePos.x, crystal.y - offseyLifePos.y, 100, offseyLifePos.height)
end

return crystal
