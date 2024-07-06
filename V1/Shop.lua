local shopMenu = require("shopMenu")

local shop = {}

shop.x = 610
shop.y = 464
shop.spriteSheet = {}
shop.spriteTexture = {}
shop.width = 118
shop.height = 128

--Position des images de pièces
local posCoins = {
  images = {
    x = 16,
    y = 16
  },
  text = {
    x = 32,
    y = 8
  }
}

shop.LoadImages = function()
  print("Shop : Chargement des textures...")
  --Chargement du shop
  shop.spriteSheet = love.graphics.newImage("Images/Shop/shop_anim.png")
  local nbColumns = shop.spriteSheet:getWidth() / shop.width
  local nbLines = shop.spriteSheet:getHeight() / shop.height
  local id = 1

  shop.spriteTexture[0] = nil

  for l = 1, nbLines do
    for c = 1, nbColumns do
      shop.spriteTexture[id] =
        love.graphics.newQuad(
        (c - 1) * shop.width,
        (l - 1) * shop.height,
        shop.width,
        shop.height,
        shop.spriteSheet:getWidth(),
        shop.spriteSheet:getHeight()
      )
      id = id + 1
    end
  end
  --Chargement image pièces
  money.animation.spriteSheet = love.graphics.newImage("Images/Shop/coin.png")
  local nbCollumn = money.animation.spriteSheet:getWidth() / money.spriteSheetDimensions.spriteWidth
  local nbLines = money.animation.spriteSheet:getHeight() / money.spriteSheetDimensions.spriteHeight
  local l, c
  local id = 1
  money.animation.spriteTexture[0] = nil
  for l = 1, nbLines do
    for c = 1, nbCollumn do
      money.animation.spriteTexture[id] =
        love.graphics.newQuad(
        (c - 1) * money.spriteSheetDimensions.spriteWidth,
        (l - 1) * money.spriteSheetDimensions.spriteHeight,
        money.spriteSheetDimensions.spriteWidth,
        money.spriteSheetDimensions.spriteHeight,
        money.animation.spriteSheet:getWidth(),
        money.animation.spriteSheet:getHeight()
      )
      id = id + 1
    end
  end
  print("Shop :Chargement des textures terminées...")
end

local roundFrameShop = 1
local animationSpeed = 10

shop.UpdateAnimation = function(dt)
  shop.frame = shop.frame + dt * animationSpeed
  money.frame = money.frame + dt * animationSpeed
  if shop.frame >= shop.maxFrame + 1 then
    shop.frame = 1
  end
  if money.frame >= money.animation.maxFrame + 1 then
    money.frame = 1
  end
  roundFrameShop = math.floor(shop.frame)
  money.roundFrameCoins = math.floor(money.frame)
end

shop.Load = function()
  shop.LoadImages()
  shopMenu.Load()
  shop.frame = 1
  shop.maxFrame = 6
  shop.openMenu = false
  money.frame = 1
end

local mouseState
local oldMouseState
shop.Update = function(dt)
  local mouseX, mouseY = love.mouse.getPosition()
  mouseState = love.mouse.isDown(1)
  shop.UpdateAnimation(dt)
  shopMenu.Update(dt, mouseX, mouseY)

  --Localisation du shop
  if
    mouseX >= (shop.x - shop.width * 0.5) and mouseX <= (shop.x + shop.width * 0.5) and
      mouseY >= (shop.y - shop.height * 0.5) and
      mouseY <= (shop.y + shop.height * 0.5) and
      shop.openMenu == false
   then
    if mouseState and mouseState ~= oldMouseState then
      shopMenu.MenuOpen()
      shop.openMenu = true
    end
  end
  --Le shop a été fermé
  if shopMenu.isOpen == false then
    shop.openMenu = false
  end
  --Fermeture du shop
  if
    (mouseX >= (shopMenu.x + shopMenu.image:getWidth() * 0.5) - shopMenu.offsetClose.x) and
      (mouseX <= (shopMenu.x + shopMenu.image:getWidth() * 0.5)) and
      (mouseY >= (shopMenu.y - shopMenu.image:getHeight() * 0.5)) and
      (mouseY <= (shopMenu.y - shopMenu.image:getHeight() * 0.5) + shopMenu.offsetClose.y) and
      shop.openMenu == true
   then
    if mouseState and mouseState ~= oldMouseState then
      shopMenu.MenuClose()
      shop.openMenu = false
    end
  end
  oldMouseState = mouseState
end

shop.Draw = function()
  love.graphics.setFont(font)
  --Valeur de pièces
  love.graphics.print(money.coins, posCoins.text.x, posCoins.text.y)
  --Dessin de la pièce
  love.graphics.draw(
    money.animation.spriteSheet,
    money.animation.spriteTexture[money.roundFrameCoins],
    posCoins.images.x,
    posCoins.images.y,
    0,
    1,
    1,
    money.spriteSheetDimensions.spriteHeight * 0.5,
    money.spriteSheetDimensions.spriteHeight * 0.5
  )
  --Dessin du shop
  love.graphics.draw(
    shop.spriteSheet,
    shop.spriteTexture[roundFrameShop],
    shop.x,
    shop.y,
    0,
    1,
    1,
    shop.width * 0.5,
    shop.height * 0.5
  )
  shopMenu.Draw()
end

return shop
