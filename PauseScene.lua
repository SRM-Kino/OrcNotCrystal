GameScene = require("GameScene")

local scene = {}
--Scène de Pause

scene.Load = function(needInit)
    -- Chargement de la scène
    print("Chargement de la scène PAUSE")
end

scene.Update = function(dt)
end
local posText = {
    x = 380,
    y = 200
}
scene.Draw = function()
    GameScene.Draw()
    love.graphics.print("PAUSE", posText.x, posText.y)
end

scene.keypressed = function(key)
    if key == "p" then
        ChangeScene("GAME", false)
    elseif key == "escape" then
        ChangeScene("MENU", true)
    end
end

scene.Unload = function()
    --Déchargement de la scène
    print("Déchargement de la scène PAUSE")
end

return scene
