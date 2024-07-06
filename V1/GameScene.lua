local player = require("Player")
local crystal = require("Crystal")
local projectile = require("projectile")
local ennemy = require("Ennemy")
local map = require("Map")
local background = require("Background")
local wave = require("Waves")
local shop = require("Shop")
local allies = require("Allies")

local scene = {}
--Pièces
money = {
  coins = 0,
  frame = 1,
  roundFrameCoins = 1,
  animation = {
    spriteSheet,
    spriteTexture = {},
    maxFrame = 15
  },
  spriteSheetDimensions = {
    spriteWidth = 16,
    spriteHeight = 16
  }
}

local textWave = {
  x = 320,
  y = 10,
  actualWave
}

ennemyOnScreen = 0

--Scène de jeu
scene.Load = function(needInit)
  -- Chargement de la scène
  print("Chargement de la scène de GAME")
  if not needInit then
    return
  end
  --Init demandé
  map.Load()
  player.Load()
  crystal.Load()
  ennemy.Load()
  wave.Load()
  shop.Load()
  allies.Load()
  projectile.Load()

  ennemyOnScreen = 0
  money.coins = 0
end

local delayWave = 8
local timerWave = delayWave
local warningWave = false
local timerWaveRound

scene.Update = function(dt)
  textWave.actualWave = wave.waveNumber + 1
  --Gestion de la création des waves avec delais
  if wave.waveNumber == 0 or ennemyOnScreen == 0 then
    warningWave = true
    timerWave = timerWave - dt
    timerWaveRound = math.floor(timerWave)
    if timerWave <= 0 then
      warningWave = false
      wave.GenerateWave()
      timerWave = delayWave
    end
  end

  allies.Update(dt, ennemy.ennemyList)
  ennemy.Update(dt, allies.alliesList)

  player.Update(dt)
  shop.Update(dt)
  crystal.Update(dt)
  projectile.Update(dt, ennemy.ennemyList)

  --Condition de défaite
  if crystalLife <= 0 then
    print("GameOver")
    ChangeScene("GAMEOVER", true)
  end
end

scene.Draw = function()
  background.Draw()
  crystal.Draw()
  allies.Draw()
  player.Draw()
  ennemy.Draw()
  projectile.Draw()
  map.Draw()
  shop.Draw()

  -- UI
  if warningWave then
    love.graphics.print(
      "Wave " .. tostring(textWave.actualWave) .. " in : " .. tostring(timerWaveRound),
      textWave.x,
      textWave.y
    )
  else
    love.graphics.print("Number of ennemies : " .. tostring(ennemyOnScreen), textWave.x, textWave.y)
  end
  love.graphics.print("Space to shot Fireballs", 15, 350)
  love.graphics.print("W to spawn Walls", 15, 370)
  love.graphics.print("H to heal your Minions", 15, 390)
end

scene.keypressed = function(key)
  if key == "p" then
    ChangeScene("PAUSE", true)
  end
end

scene.mousepressed = function(x, y, button)
  print(x, y)
end

scene.Unload = function()
  --Déchargement de la scène
  print("Déchargement de la scène GAME")
end

return scene
