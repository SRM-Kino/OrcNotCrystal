--Liste des Scènes
local scenes = {
  GAME = require("GameScene"),
  MENU = require("MenuScene"),
  PAUSE = require("PauseScene"),
  GAMEOVER = require("GameOverScene")
}

local currentScene

--Changement de scène
function ChangeScene(key, needInit) -- Clé de la scène voulue
  if currentScene ~= nil then -- Sécuritée en cas de mauvais appel
    currentScene.Unload()
  end
  currentScene = scenes[key]
  if currentScene ~= nil then -- Sécuritée en cas de mauvais appel
    currentScene.Load(needInit)
  end
end

--Update de la scène
function UpdateCurrentScene(dt) --Update de la scène voulue
  if currentScene == nil then
    return
  end -- Sécuritée en cas de mauvais appel
  currentScene.Update(dt)
end

--Draw de la scène
function DrawCurrentScene() --Update de la scène voulue
  if currentScene == nil then
    return
  end -- Sécuritée en cas de mauvais appel
  currentScene.Draw()
end

function keypressedCurrentScene(key)
  if currentScene == nil then
    return
  end -- Sécuritée en cas de mauvais appel
  if currentScene.keypressed == nil then
    return
  end -- Sécuritée en cas d'aucun appuie sur une touche
  currentScene.keypressed(key)
end

function mousepressedCurrentScene(x, y, button)
  if currentScene == nil then
    return
  end -- Sécuritée en cas de mauvais appel
  if currentScene.mousepressed == nil then
    return
  end -- Sécuritée en cas d'aucun appuie sur une touche
  currentScene.mousepressed(x, y, button)
end
