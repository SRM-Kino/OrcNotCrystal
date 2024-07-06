local allies = require("Allies")

local heal = {
    closestID,
    closestDistance,
    healAmount = 25,
    timerCoolDown = 30,
    coolDown = 30,
    distanceCibleList = {},
    unlocked = false,
    playAnimation = false,
    Animation = {
        frame = 1,
        maxFrame = 4,
        roundFrame = 1,
        animationSpeed = 5,
        spriteSheet,
        spriteTexture = {}
    },
    imageDimensions = {
        WIDTH = 100,
        HEIGHT = 100,
        ox = 50,
        oy = 50
    },
    coolDown = 10,
    timerCoolDown = 10,
    position = {
        x,
        y
    }
}

heal.FindClosestAllie = function(list)
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

--Chargement des images
heal.LoadImages = function()
    heal.Animation.spriteSheet = love.graphics.newImage("Images/Projectiles/Wizard-Heal_Effect.png")
    local nbCollumns = heal.Animation.spriteSheet:getWidth() / heal.imageDimensions.WIDTH
    local nbLines = heal.Animation.spriteSheet:getHeight() / heal.imageDimensions.HEIGHT
    local l, c
    local id = 1
    for l = 1, nbLines do
      for c = 1, nbCollumns do
        heal.Animation.spriteTexture[id] =
          love.graphics.newQuad(
          (c - 1) * heal.imageDimensions.WIDTH,
          (l - 1) * heal.imageDimensions.HEIGHT,
          heal.imageDimensions.WIDTH,
          heal.imageDimensions.HEIGHT,
          heal.Animation.spriteSheet
        )
        id = id + 1
      end
    end
end

--Update des animation
heal.UpdateAnimation = function(dt)
    if heal.playAnimation then
        heal.Animation.frame = heal.Animation.frame + dt * heal.Animation.animationSpeed
        if (heal.Animation.frame >= heal.Animation.maxFrame + 1) then
            heal.playAnimation = false
            heal.Animation.frame = 1
        end
        heal.Animation.roundFrame = math.floor(heal.Animation.frame)
    end
end

--Création du heal
heal.CreateHeal = function(mouseX, mouseY)
    if heal.unlocked == true then
        print(#allies.alliesList)
        if #allies.alliesList == 0 then return end
        for a = 1, #allies.alliesList do
            heal.distanceCibleList[a] = math.dist(mouseX, mouseY, allies.alliesList[a].x, allies.alliesList[a].y)
        end 
        --Trouver l'alliée le plus proche et prendre sa position
        heal.closestDistance, heal.closestID = heal.FindClosestAllie(heal.distanceCibleList)
        heal.position.x = allies.alliesList[heal.closestID].x
        heal.position.y = allies.alliesList[heal.closestID].y

        heal.playAnimation = true
        allies.alliesList[heal.closestID].life = allies.alliesList[heal.closestID].life + heal.healAmount
    end
end

--Chargement des images et suppression de la liste
heal.Load = function()
    heal.LoadImages()
end

--Update
heal.Update = function(dt, ennemyList)
    heal.UpdateAnimation(dt)
end

--Dessin
heal.Draw = function()
    if heal.playAnimation then
        love.graphics.draw(
            heal.Animation.spriteSheet,
            heal.Animation.spriteTexture[heal.Animation.roundFrame],
            heal.position.x,
            heal.position.y,
            0,
            1,
            1,
            heal.imageDimensions.ox,
            heal.imageDimensions.oy
        )
    end
end

return heal