local archer = require("Archer")
local lancer = require("Lancer")
local iceWall = require("IceWall")

local allies = {
    alliesList = {}
}

allies.Load = function()
    allies.alliesList = {}
    archer.Load()
    lancer.Load()
    iceWall.Load()
end

-- Création d'alliés
-- 1 = archer
-- 2 = Lancer
--TODO ICEWALL
allies.Update = function(dt, ennemyList)
    local mouseX, mouseY = love.mouse.getPosition()

    --Mur de glace -- Ancienne méthode
    for a = 1, #iceWall.iceWallList do
        table.insert(allies.alliesList, iceWall.iceWallList[a])
    end

    -- Nouvelle méthode
    --Creation Archer
    if archer.needToPlace then
        archer.PlaceWithMouse(mouseX, mouseY)
    elseif archer.creation then
        table.insert(allies.alliesList, archer.Create(mouseX, archer.archerPlacing.direction))
        archer.creation = false
    end
    --Creation Lancer
    if lancer.needToPlace then
        lancer.PlaceWithMouse(mouseX, mouseY)
    elseif lancer.creation then
        table.insert(allies.alliesList, lancer.Create(mouseX, lancer.lancerPlacing.direction))
        lancer.creation = false
    end
    --Update Allies
    for a = #allies.alliesList, 1, -1 do
        local allie = allies.alliesList[a]
        if allie.type == 1 then
            archer.Update(dt, allie, ennemyList)
        elseif allie.type == 2 then
            lancer.Update(dt, allie, ennemyList)
        end
        --Suppression de l'allié
        if allie.isFree == true then
            table.remove(allies.alliesList, a)
        end
    end

    iceWall.Update(dt)
end

allies.Draw = function()
    --Dessin des alliés
    for a = 1, #allies.alliesList do
        local allie = allies.alliesList[a]
        if allie.type == 1 then
            archer.Draw(allie)
        elseif allie.type == 2 then
            lancer.Draw(allie)
        end
    end
    --Dessin sur la souris en cas de choix
    archer.Draw()
    lancer.Draw()

    iceWall.Draw()
end

return allies
