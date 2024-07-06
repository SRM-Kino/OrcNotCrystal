local fireball = require("Fireball")
local projectile = {}

projectile.projectileList = {}

projectile.Create = function(type, mouseX, mouseY, playerX, playerY)
    if type == "fireball" then
        fireball.CreateFireball(mouseX, mouseY, playerX, playerY)
    end
end

projectile.Load = function()
    projectile.projectileList = {}
    fireball.Load()
end

projectile.Update = function(dt, ennemyList)
    projectile.projectileList = {}
    --Transfert des fireball dans la liste des projectiles
    for f = 1, #fireball.fireballList do
        table.insert(projectile.projectileList, fireball.fireballList[f])
    end
    fireball.Update(dt, ennemyList)
end

projectile.Draw = function()
    fireball.Draw()
end

return projectile
