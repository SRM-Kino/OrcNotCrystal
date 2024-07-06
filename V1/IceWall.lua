local iceWall = {
    unlocked = false,
    iceWallList = {},
    Animation = {
        frame = 1,
        maxFrame = 5,
        maxFrameSpawning = 3,
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
    timerCoolDown = 10
}
--Chargement des images
iceWall.LoadImages = function()
    iceWall.Animation.spriteSheet = love.graphics.newImage("Images/Projectiles/Wizard-Attack01_Effect.png")
    local nbCollumns = iceWall.Animation.spriteSheet:getWidth() / iceWall.imageDimensions.WIDTH
    local nbLines = iceWall.Animation.spriteSheet:getHeight() / iceWall.imageDimensions.HEIGHT
    local l, c
    local id = 1
    for l = 1, nbLines do
        for c = 1, nbCollumns do
            iceWall.Animation.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * iceWall.imageDimensions.WIDTH,
                (l - 1) * iceWall.imageDimensions.HEIGHT,
                iceWall.imageDimensions.WIDTH,
                iceWall.imageDimensions.HEIGHT,
                iceWall.Animation.spriteSheet
            )
            id = id + 1
        end
    end
end

--Update des animation
iceWall.UpdateAnimation = function(dt)
    for i = 1, #iceWall.iceWallList do
        w = iceWall.iceWallList[i]
        -- Si pas encore hit
        if w.spawningPhase == true then
            w.frame = w.frame + dt * w.animationSpeed
            if (w.frame >= iceWall.Animation.maxFrameSpawning + 1) then
                w.frame = iceWall.Animation.maxFrameSpawning
                w.spawningPhase = false
            end
        elseif w.life <= 0 then
            w.frame = w.frame + dt * w.animationSpeed
            if (w.frame >= iceWall.Animation.maxFrame + 1) then
                w.frame = iceWall.Animation.maxFrame
                w.isDestroy = true
            end
        end
        w.roundFrame = math.floor(w.frame)
    end
end

--Création du mur de glace
iceWall.CreateIceWall = function(mouseX)
    if iceWall.unlocked == true then
        myIcewall = {
            life = 25,
            y = 278,
            x = mouseX,
            isDestroy = false,
            spawningPhase = true,
            frame = 1,
            roundFrame = 1,
            animationSpeed = 5
        }
        table.insert(iceWall.iceWallList, myIcewall)
    end
end

--Chargement des images et suppression de la liste
iceWall.Load = function()
    iceWall.iceWallList = {}
    iceWall.LoadImages()
end

--Update
iceWall.Update = function(dt, ennemyList)
    for i = #iceWall.iceWallList, 1, -1 do
        local w = iceWall.iceWallList[i]
        if w.isDestroy == true then
            w.isFree = true
            table.remove(iceWall.iceWallList, i)
        end
    end
    iceWall.UpdateAnimation(dt)
end

--Dessin
iceWall.Draw = function()
    for i = 1, #iceWall.iceWallList do
        local o = iceWall.iceWallList[i]
        love.graphics.draw(
            iceWall.Animation.spriteSheet,
            iceWall.Animation.spriteTexture[o.roundFrame],
            o.x,
            o.y,
            0,
            1,
            1,
            iceWall.imageDimensions.ox,
            iceWall.imageDimensions.oy
        )
    end
end

return iceWall
