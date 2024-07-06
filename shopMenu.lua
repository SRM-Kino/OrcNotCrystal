local archer = require("Archer")
local lancer = require("Lancer")
local iceWall = require("IceWall")
local heal = require("Heal")

local shopMenu = {}

shopMenu.offsetClose = {
  x = 20,
  y = 20
}

local coinsPos = {
  [1] = {
    x = 308,
    y = 185
  },
  [2] = {
    x = 308,
    y = 270
  },
  [3] = {
    x = 308,
    y = 355
  },
  [4] = {
    x = 308,
    y = 440
  },
  [5] = {
    x = 498,
    y = 185
  },
  [6] = {
    x = 498,
    y = 270
  }
}

local buyPos = {
  archer = {
    title = "Archer",
    titleX = 240,
    titleY = 200,
    spriteX = 270,
    spriteY = 170,
    priceX = 322,
    priceY = 175,
    buttonX = 320,
    buttonY = 178,
    buttonWidth = 25,
    buttonHeight = 10,
    price = 100
  },
  lancer = {
    title = "Lancer",
    titleX = 240,
    titleY = 285,
    spriteX = 270,
    spriteY = 265,
    priceX = 322,
    priceY = 260,
    buttonX = 321,
    buttonY = 265,
    buttonWidth = 25,
    buttonHeight = 10,
    price = 200
  },
  iceWall ={
    title = "IceWall",
    titleX = 430,
    titleY = 200,
    spriteX = 455,
    spriteY = 170,
    priceX = 510,
    priceY = 175,
    buttonX = 510,
    buttonY = 175,
    buttonWidth = 25,
    buttonHeight = 10,
    price = 250
  },
  heal ={
    title = "Heal",
    titleX = 430,
    titleY = 285,
    spriteX = 455,
    spriteY = 265,
    priceX = 510,
    priceY = 260,
    buttonX = 510,
    buttonY = 265,
    buttonWidth = 25,
    buttonHeight = 10,
    price = 300
  }
}

shopMenu.Load = function()
  shopMenu.image = love.graphics.newImage("Images/Shop/MenuShop.png")
  shopMenu.x = screenWidth * 0.5
  shopMenu.y = screenHeight * 0.5
  shopMenu.isOpen = false
end

shopMenu.MenuOpen = function()
  print("Ouverture du menu SHOP")
  shopMenu.isOpen = true
end

shopMenu.MenuClose = function()
  print("Fermeture du menu SHOP")
  shopMenu.isOpen = false
end

shopMenu.buyAllie = {
  archer = false
}
--Etat de la souris
local mouseState
local oldMouseState
shopMenu.Update = function(dt, mouseX, mouseY)
  mouseState = love.mouse.isDown(1)
  --Achat de l'archer
  if
    shopMenu.isOpen == true and
      (mouseX >= buyPos.archer.buttonX and mouseX <= buyPos.archer.buttonX + buyPos.archer.buttonWidth and
        mouseY >= buyPos.archer.buttonY and
        mouseY <= buyPos.archer.buttonY + buyPos.archer.buttonHeight) and
      (mouseState and mouseState ~= oldMouseState) and
      money.coins >= buyPos.archer.price
   then
    money.coins = money.coins - buyPos.archer.price
    archer.needToPlace = true
    shopMenu.isOpen = false
  end
  --Achat de Lancer
  if
    shopMenu.isOpen == true and
      (mouseX >= buyPos.lancer.buttonX and mouseX <= buyPos.lancer.buttonX + buyPos.lancer.buttonWidth and
        mouseY >= buyPos.lancer.buttonY and
        mouseY <= buyPos.lancer.buttonY + buyPos.lancer.buttonHeight) and
      (mouseState and mouseState ~= oldMouseState) and
      money.coins >= buyPos.lancer.price
   then
    money.coins = money.coins - buyPos.lancer.price
    lancer.needToPlace = true
    shopMenu.isOpen = false
  end
  --Achat du sort : IceWall
  if
    shopMenu.isOpen == true and
      (mouseX >= buyPos.iceWall.buttonX and mouseX <= buyPos.iceWall.buttonX + buyPos.iceWall.buttonWidth and
        mouseY >= buyPos.iceWall.buttonY and
        mouseY <= buyPos.iceWall.buttonY + buyPos.iceWall.buttonHeight) and
      (mouseState and mouseState ~= oldMouseState) and
      money.coins >= buyPos.iceWall.price and iceWall.unlocked == false
   then
    money.coins = money.coins - buyPos.iceWall.price
    iceWall.unlocked = true
    shopMenu.isOpen = false
  end
  --Achat du sort : Heal
  if
    shopMenu.isOpen == true and
      (mouseX >= buyPos.heal.buttonX and mouseX <= buyPos.heal.buttonX + buyPos.heal.buttonWidth and
        mouseY >= buyPos.heal.buttonY and
        mouseY <= buyPos.heal.buttonY + buyPos.heal.buttonHeight) and
      (mouseState and mouseState ~= oldMouseState) and
      money.coins >= buyPos.heal.price and heal.unlocked == false
   then
    money.coins = money.coins - buyPos.heal.price
    heal.unlocked = true
    shopMenu.isOpen = false
  end
  oldMouseState = mouseState
end

shopMenu.Draw = function()
  if shopMenu.isOpen == true then
    --Dessin du menu
    love.graphics.draw(
      shopMenu.image,
      shopMenu.x,
      shopMenu.y,
      0,
      1,
      1,
      shopMenu.image:getWidth() * 0.5,
      shopMenu.image:getHeight() * 0.5
    )
    --Dessin de l'archer - SPRITE
    love.graphics.draw(
      archer.animation.IDLE.spriteSheet,
      archer.animation.IDLE.spriteTexture[1],
      buyPos.archer.spriteX,
      buyPos.archer.spriteY,
      0,
      archer.animation.sx,
      archer.animation.sy,
      archer.spriteSheetDimensions.spriteWidth * 0.5,
      archer.spriteSheetDimensions.spriteHeight * 0.5
    )
    --Dessin de l'archer - PRICE
    love.graphics.setColor(1, 1, 0)
    love.graphics.print(tostring(buyPos.archer.price), buyPos.archer.priceX, buyPos.archer.priceY)
    love.graphics.setColor(0, 0, 0)
    --Dessin de l'archer -- TITLE
    love.graphics.print(buyPos.archer.title, buyPos.archer.titleX, buyPos.archer.titleY)
    love.graphics.setColor(1, 1, 1)

    --Dessin de Lancer - SPRITE
    love.graphics.draw(
      lancer.animation.IDLE.spriteSheet,
      lancer.animation.IDLE.spriteTexture[1],
      buyPos.lancer.spriteX,
      buyPos.lancer.spriteY,
      0,
      lancer.animation.sx,
      lancer.animation.sy,
      lancer.spriteSheetDimensions.spriteWidth * 0.5,
      lancer.spriteSheetDimensions.spriteHeight * 0.5
    )
    --Dessin de lancer - PRICE
    love.graphics.setColor(1, 1, 0)
    love.graphics.print(tostring(buyPos.lancer.price), buyPos.lancer.priceX, buyPos.lancer.priceY)
    love.graphics.setColor(0, 0, 0)
    --Dessin de lancer -- TITLE
    love.graphics.print(buyPos.lancer.title, buyPos.lancer.titleX, buyPos.lancer.titleY)
    love.graphics.setColor(1, 1, 1)

    --Dessin de IceWall - SPRITE
    love.graphics.draw(
      iceWall.Animation.spriteSheet,
      iceWall.Animation.spriteTexture[1],
      buyPos.iceWall.spriteX,
      buyPos.iceWall.spriteY,
      0,
      1,
      1,
      iceWall.imageDimensions.WIDTH * 0.5,
      iceWall.imageDimensions.HEIGHT * 0.5
    )
    --Dessin de IceWall - PRICE
    love.graphics.setColor(1, 1, 0)
    love.graphics.print(tostring(buyPos.iceWall.price), buyPos.iceWall.priceX, buyPos.iceWall.priceY)
    love.graphics.setColor(0, 0, 0)
    --Dessin de IceWall -- TITLE
    love.graphics.print(buyPos.iceWall.title, buyPos.iceWall.titleX, buyPos.iceWall.titleY)
    love.graphics.setColor(1, 1, 1)

    --Dessin de IceWall - SPRITE
    love.graphics.draw(
      heal.Animation.spriteSheet,
      heal.Animation.spriteTexture[2],
      buyPos.heal.spriteX,
      buyPos.heal.spriteY,
      0,
      1,
      1,
      heal.imageDimensions.WIDTH * 0.5,
      heal.imageDimensions.HEIGHT * 0.5
    )
    --Dessin de IceWall - PRICE
    love.graphics.setColor(1, 1, 0)
    love.graphics.print(tostring(buyPos.heal.price), buyPos.heal.priceX, buyPos.heal.priceY)
    love.graphics.setColor(0, 0, 0)
    --Dessin de IceWall -- TITLE
    love.graphics.print(buyPos.heal.title, buyPos.heal.titleX, buyPos.heal.titleY)
    love.graphics.setColor(1, 1, 1)
    --Coins
    for c = 1, #coinsPos do
      local posX = coinsPos[c].x
      local posY = coinsPos[c].y
      love.graphics.draw(
        money.animation.spriteSheet,
        money.animation.spriteTexture[money.roundFrameCoins],
        posX,
        posY,
        0,
        1,
        1,
        money.spriteSheetDimensions.spriteHeight * 0.5,
        money.spriteSheetDimensions.spriteHeight * 0.5
      )
    end
  end
end

return shopMenu
