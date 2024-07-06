local scene = {}
--Scène de Game Over
local BGGameOver = {
    image = love.graphics.newImage("Images/BackGround/GameOver.png"),
    x = 816 / 2,
    y = 600 / 2
}

local buttonRetry = {
    x = 177,
    y = 531,
    width = 235,
    height = 55
}
local buttonMainMenu = {
    x = 465,
    y = 534,
    width = 235,
    height = 55
}

scene.Load = function(needInit)
    -- Chargement de la scène
    print("Chargement de la scène GameOver")
    if not needInit then
        return
    end
end

scene.Update = function(dt)
end

scene.Draw = function()
    love.graphics.draw(
        BGGameOver.image,
        BGGameOver.x,
        BGGameOver.y,
        0,
        0.85,
        0.6,
        BGGameOver.image:getWidth() * 0.5,
        BGGameOver.image:getHeight() * 0.5
    )
end

scene.keypressed = function(key)
    if key == "r" then
        ChangeScene("GAME", true)
    elseif key == "escape" then
        ChangeScene("MENU", true)
    end
end

scene.mousepressed = function(x, y, button)
    if
        x >= buttonRetry.x and x <= buttonRetry.x + buttonRetry.width and y >= buttonRetry.y and
            y <= buttonRetry.y + buttonRetry.height and
            button == 1
     then
        ChangeScene("GAME", true)
    end
    if
        x >= buttonMainMenu.x and x <= buttonMainMenu.x + buttonMainMenu.width and y >= buttonMainMenu.y and
            y <= buttonMainMenu.y + buttonMainMenu.height and
            button == 1
     then
        ChangeScene("MENU", true)
    end
end

scene.Unload = function()
    --Déchargement de la scène
    print("Déchargement de la scène Game Over")
end

return scene
