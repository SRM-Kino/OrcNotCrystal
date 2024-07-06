local fireball = {
    fireballList = {},
    Animation = {
        frame = 1,
        maxFrame = 7,
        spriteSheet,
        spriteTexture = {}
    },
    imageDimensions = {
        WIDTH = 100,
        HEIGHT = 100,
        ox = 50,
        oy = 50
    }
}
--Chargement des images
fireball.LoadImages = function()
    fireball.Animation.spriteSheet = love.graphics.newImage("Images/Projectiles/Wizard-Attack02_Effect.png")
    local nbCollumns = fireball.Animation.spriteSheet:getWidth() / fireball.imageDimensions.WIDTH
    local nbLines = fireball.Animation.spriteSheet:getHeight() / fireball.imageDimensions.HEIGHT
    local l, c
    local id = 1
    for l = 1, nbLines do
      for c = 1, nbCollumns do
        fireball.Animation.spriteTexture[id] =
          love.graphics.newQuad(
          (c - 1) * fireball.imageDimensions.WIDTH,
          (l - 1) * fireball.imageDimensions.HEIGHT,
          fireball.imageDimensions.WIDTH,
          fireball.imageDimensions.HEIGHT,
          fireball.Animation.spriteSheet
        )
        id = id + 1
      end
    end
end
--Update des animation
fireball.UpdateAnimation = function(dt)
    for i = 1, #fireball.fireballList do
        f = fireball.fireballList[i]
        -- Si pas encore hit
        if f.hasHit == false then
           f.frame = 1
        else
            --Si hit
            f.frame = f.frame + dt * f.animationSpeed
            if (f.frame >= fireball.Animation.maxFrame + 1) then
                f.hasExplode = true
                f.frame = 1
            end
        end
        f.roundFrame = math.floor(f.frame)
    end
end
--Création de la boule de feu
fireball.CreateFireball = function(mouseX, mouseY, playerX, playerY)
    local myFireBall = {
        x = playerX,
        y = playerY,
        frame = 1,
        roundFrame = 1,
        animationSpeed = 10,
        distanceEnnemy,
        vx = 100,
        vy = 100,
        gravity = 125,
        damage = 1,
        hitBox = 20,
        hasHit = false,
        hasExplode = false,
        angle = math.angle(playerX, playerY, mouseX, mouseY),
    }
    table.insert(fireball.fireballList, myFireBall)
end
--Chargement des images et suppression de la liste
fireball.Load = function()
    fireball.LoadImages()
    fireball.fireballList = {}
end

fireball.Update = function(dt, ennemyList)
    for p = #fireball.fireballList, 1, -1 do
        local o = fireball.fireballList[p]
        --Application de la gravité
        if o.angle <= 0 then
            o.vy = o.vy - o.gravity * dt
        else
            o.vy = o.vy + o.gravity * dt
        end
        --Collision avec un ennemi
        for i = 1, #ennemyList do
            local e = ennemyList[i]
            local distanceEnnemy = math.dist(o.x, o.y, e.x, e.y)

            --Collision d'un projectile Player avec un ennemy
            if (distanceEnnemy <= o.hitBox) and o.hasHit == false then
                o.hasHit = true
                e.life = e.life - o.damage
            end
        end
        --Limite des projectiles
        if o.y > 290 or o.y < 0 or o.x < 0 or o.x > screenWidth then
            o.hasHit = true
        end

        if o.hasExplode == true then
            table.remove(fireball.fireballList, p)
        end

        if o.hasHit == false then
            o.x = o.x + o.vx * math.cos(o.angle) * dt
            o.y = o.y + o.vy * math.sin(o.angle) * dt
        end
    end
    fireball.UpdateAnimation(dt)
end

fireball.Draw = function()
    for p = 1, #fireball.fireballList do
        local o = fireball.fireballList[p]
        love.graphics.draw(
            fireball.Animation.spriteSheet,
            fireball.Animation.spriteTexture[o.roundFrame],
            o.x,
            o.y,
            o.angle,
            1,
            1,
            fireball.imageDimensions.ox,
            fireball.imageDimensions.oy
        )
    end
end

return fireball