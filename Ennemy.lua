--TODO Séparation des ennemis du fichier // 3 fichiers différents 
local orc = require("Orc")
local skeleton = require("Skeleton")
local slime = require("Slime")
local crystal = require("Crystal")

local ennemy = {
    ennemyList = {},
    ennemyTypes = 3,
    ennemyOnScreen = 0,
    SPAWNS = {}
}
--Zone de spawns possibles
ennemy.SPAWNS[1] = {
    x = 50,
    y = 275,
    direction = 2
}
ennemy.SPAWNS[2] = {
    x = 816 - 50,
    y = 275,
    direction = -2
}
-- Création d'ennemies
-- 1 = Slime
-- 2 = Squelette
-- 3 = Orc
ennemy.CreateEnnemy = function(type)
    if type == nil then
        return
    end
    if type == 1 then
        table.insert(ennemy.ennemyList, slime.CreateEnnemy(ennemy.SPAWNS))
    elseif type == 2 then
        table.insert(ennemy.ennemyList, skeleton.CreateEnnemy(ennemy.SPAWNS))
    elseif type == 3 then
        table.insert(ennemy.ennemyList, orc.CreateEnnemy(ennemy.SPAWNS))
    end
end

ennemy.Load = function()
    ennemy.ennemyList = {}
    slime.Load()
    orc.Load()
    skeleton.Load()
end

-- Updates des ennemis
ennemy.Update = function(dt, alliesList)
    for e = #ennemy.ennemyList, 1, -1 do
        myEnnemy = ennemy.ennemyList[e]
        if myEnnemy.type == 1 then
            slime.Update(dt, myEnnemy, alliesList, crystal.x, crystal.goalY)
        elseif myEnnemy.type == 2 then
            skeleton.Update(dt, myEnnemy, alliesList, crystal.x, crystal.goalY)
        elseif myEnnemy.type == 3 then
            orc.Update(dt, myEnnemy, alliesList, crystal.x, crystal.goalY)
        end

        if myEnnemy.isFree then
            table.remove(ennemy.ennemyList, e)
        end
    end
end

--Dessin des ennemis
ennemy.Draw = function()
    for e = 1, #ennemy.ennemyList do
        myEnnemy = ennemy.ennemyList[e]
        if myEnnemy.type == 1 then
            slime.Draw(myEnnemy)
        elseif myEnnemy.type == 2 then
            skeleton.Draw(myEnnemy)
        elseif myEnnemy.type == 3 then
            orc.Draw(myEnnemy)
        end
    end
end

return ennemy
