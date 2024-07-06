local projectile = require("Projectile")
local iceWall = require("IceWall")
local heal = require("Heal")

local player = {}

player.spriteSheetDimensions = {
    spriteWidth = 100,
    spriteHeight = 100
}
player.animation = {
    frame = 1,
    spriteSheet = {}, --[1] IDLE, etc...
    IDLE = {
        spriteSheet,
        spriteTexture = {},
        maxFrame = 6
    },
    WALK = {
        spriteSheet,
        spriteTexture = {},
        maxFrame = 8
    },
    HURT = {
        spriteSheet,
        spriteTexture = {},
        maxFrame = 4
    },
    ATTACK = {
        spriteSheet,
        spriteTexture = {},
        maxFrame = 6
    },
    DEATH = {
        spriteSheet,
        spriteTexture = {},
        maxFrame = 4
    }
}
player.offsetImage = {
    ox = 50,
    oy = 50,
    sx = 1
}
player.states = {
    IDLE = "Idle",
    WALK = "Walk",
    HURT = "Hurt",
    ATTACK = "Attack",
    DEATH = "Dead"
}
local roundFrame
local maxAnimationFrame
local previousState

--Chargement des images
player.LoadImages = function()
    --IDLE
    player.animation.IDLE.spriteSheet = love.graphics.newImage("Images/Player/Wizard-IDLE.png")
    local nbCollumn = player.animation.IDLE.spriteSheet:getWidth() / player.spriteSheetDimensions.spriteWidth
    local nbLines = player.animation.IDLE.spriteSheet:getHeight() / player.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    player.animation.IDLE.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            player.animation.IDLE.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * player.spriteSheetDimensions.spriteWidth,
                (l - 1) * player.spriteSheetDimensions.spriteHeight,
                player.spriteSheetDimensions.spriteWidth,
                player.spriteSheetDimensions.spriteHeight,
                player.animation.IDLE.spriteSheet:getWidth(),
                player.animation.IDLE.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --WALK
    player.animation.WALK.spriteSheet = love.graphics.newImage("Images/Player/Wizard-WALK.png")
    nbCollumn = player.animation.WALK.spriteSheet:getWidth() / player.spriteSheetDimensions.spriteWidth
    nbLines = player.animation.WALK.spriteSheet:getHeight() / player.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    player.animation.WALK.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            player.animation.WALK.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * player.spriteSheetDimensions.spriteWidth,
                (l - 1) * player.spriteSheetDimensions.spriteHeight,
                player.spriteSheetDimensions.spriteWidth,
                player.spriteSheetDimensions.spriteHeight,
                player.animation.WALK.spriteSheet:getWidth(),
                player.animation.WALK.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --HURT
    player.animation.HURT.spriteSheet = love.graphics.newImage("Images/Player/Wizard-HURT.png")
    local nbCollumn = player.animation.HURT.spriteSheet:getWidth() / player.spriteSheetDimensions.spriteWidth
    local nbLines = player.animation.HURT.spriteSheet:getHeight() / player.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    player.animation.HURT.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            player.animation.HURT.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * player.spriteSheetDimensions.spriteWidth,
                (l - 1) * player.spriteSheetDimensions.spriteHeight,
                player.spriteSheetDimensions.spriteWidth,
                player.spriteSheetDimensions.spriteHeight,
                player.animation.HURT.spriteSheet:getWidth(),
                player.animation.HURT.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --DEATH
    player.animation.DEATH.spriteSheet = love.graphics.newImage("Images/Player/Wizard-DEATH.png")
    local nbCollumn = player.animation.DEATH.spriteSheet:getWidth() / player.spriteSheetDimensions.spriteWidth
    local nbLines = player.animation.DEATH.spriteSheet:getHeight() / player.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    player.animation.DEATH.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            player.animation.DEATH.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * player.spriteSheetDimensions.spriteWidth,
                (l - 1) * player.spriteSheetDimensions.spriteHeight,
                player.spriteSheetDimensions.spriteWidth,
                player.spriteSheetDimensions.spriteHeight,
                player.animation.DEATH.spriteSheet:getWidth(),
                player.animation.DEATH.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --ATTACK
    player.animation.ATTACK.spriteSheet = love.graphics.newImage("Images/Player/Wizard-ATTACK.png")
    local nbCollumn = player.animation.ATTACK.spriteSheet:getWidth() / player.spriteSheetDimensions.spriteWidth
    local nbLines = player.animation.ATTACK.spriteSheet:getHeight() / player.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    player.animation.ATTACK.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            player.animation.ATTACK.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * player.spriteSheetDimensions.spriteWidth,
                (l - 1) * player.spriteSheetDimensions.spriteHeight,
                player.spriteSheetDimensions.spriteWidth,
                player.spriteSheetDimensions.spriteHeight,
                player.animation.ATTACK.spriteSheet:getWidth(),
                player.animation.ATTACK.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
end
--Update des images
player.UpdateAnimation = function(dt)
    --Réglage max frame en fonction de l'état
    if player.actualState == player.states.IDLE then
        maxAnimationFrame = player.animation.IDLE.maxFrame
    elseif player.actualState == player.states.WALK then
        maxAnimationFrame = player.animation.WALK.maxFrame
    elseif player.actualState == player.states.HURT then
        maxAnimationFrame = player.animation.HURT.maxFrame
    elseif player.actualState == player.states.DEATH then
        maxAnimationFrame = player.animation.DEATH.maxFrame
    elseif player.actualState == player.states.ATTACK then
        maxAnimationFrame = player.animation.ATTACK.maxFrame
    end

    --Mise à jour de la frame -- Sécurité pour éviter le saut de frame
    player.animation.frame = player.animation.frame + dt * 10
    if (player.animation.frame >= maxAnimationFrame + 1) or (player.actualState ~= previousState) then
        player.animation.frame = 1
    end
    roundFrame = math.floor(player.animation.frame)

    --Sécurité pour éviter le saut de frame
    previousState = player.actualState
end
local canInvokeIce
--Chargement
player.Load = function()
    print("Chargement du joueur ...")
    player.LoadImages()
    heal.Load()
    player.x = 500
    player.vx = 0
    player.y = 275
    player.moveSpeed = 50
    player.actualState = player.states.IDLE
    canInvokeIce = true
    canInvokeHeal = true
    print("Chargement du joueur terminé ...")
end
--Déplacement
player.Move = function(dt, direction)
    player.vx = player.moveSpeed * dt * direction
    player.x = player.x + player.vx
    if player.vx ~= 0 then
        player.actualState = player.states.WALK
    end
end

--Attaque
local delayAttack = 3
local timerAttack = 3
local canAttack = false
local speedOffset = 6
--IceWall


player.Attack = function(dt, mouseX, mouseY, type)
    --Sécurité
    if type == nil then
        return
    end
    player.actualState = player.states.ATTACK

    --Fireball
    if type == "fireball" then
        --Timer d'attaque
        timerAttack = timerAttack - dt * speedOffset
        if timerAttack <= 0 then
            timerAttack = delayAttack
            canAttack = true
        end
        if canAttack then
            projectile.Create("fireball", mouseX, mouseY, player.x, player.y)
            player.isAttacking = false
            canAttack = false
        end
    elseif type == "iceWall" then
        canInvokeIce = false
        iceWall.CreateIceWall(mouseX)
    elseif type == "heal" then
        canInvokeHeal = false
        heal.CreateHeal(mouseX, mouseY)
    end
end

local mouseX, mouseY
player.Update = function(dt)
    --Récupération position de la souris
    mouseX, mouseY = love.mouse.getPosition()

    --CoolDown IceWall
    if canInvokeIce == false then 
        iceWall.timerCoolDown = iceWall.timerCoolDown - dt
    end
    if iceWall.timerCoolDown <= 0 then
        canInvokeIce = true
        iceWall.timerCoolDown = iceWall.coolDown
    end
    --Cooldown Heal
    if canInvokeHeal == false then 
        heal.timerCoolDown = heal.timerCoolDown - dt
    end
    if heal.timerCoolDown <= 0 then
        canInvokeHeal = true
        heal.timerCoolDown = heal.coolDown
    end

    --Déplacement du joueur
    if love.keyboard.isDown("d") then
        player.direction = 1
        player.Move(dt, player.direction)
    elseif love.keyboard.isDown("q") then
        player.direction = -1
        player.Move(dt, player.direction)
    else
        player.actualState = player.states.IDLE
    end
    --Attaque du joueur
    if love.keyboard.isDown("space") then
        player.Attack(dt, mouseX, mouseY, "fireball")
    end
    --Mur de glace
    if love.keyboard.isDown("w") and canInvokeIce == true then
        canInvokeIce = false
        player.Attack(dt, mouseX, mouseY, "iceWall")
    end
    --Heal
    if love.keyboard.isDown("h") and canInvokeHeal == true then
        canInvokeHeal = false
        player.Attack(dt, mouseX, mouseY, "heal")
    end
    --Animations
    heal.Update(dt)
    player.UpdateAnimation(dt)
end

player.Draw = function()
    --Direction de la souris
    if mouseX > player.x then
        player.offsetImage.sx = 2
    else
        player.offsetImage.sx = -2
    end
    --Draw player
    if player.actualState == player.states.IDLE then
        love.graphics.draw(
            player.animation.IDLE.spriteSheet,
            player.animation.IDLE.spriteTexture[roundFrame],
            player.x,
            player.y,
            0,
            player.offsetImage.sx,
            2,
            player.offsetImage.ox,
            player.offsetImage.oy
        )
    elseif player.actualState == player.states.WALK then
        love.graphics.draw(
            player.animation.WALK.spriteSheet,
            player.animation.WALK.spriteTexture[roundFrame],
            player.x,
            player.y,
            0,
            player.offsetImage.sx,
            2,
            player.offsetImage.ox,
            player.offsetImage.oy
        )
    elseif player.actualState == player.states.HURT then
        love.graphics.draw(
            player.animation.HURT.spriteSheet,
            player.animation.HURT.spriteTexture[roundFrame],
            player.x,
            player.y,
            0,
            player.offsetImage.sx,
            2,
            player.offsetImage.ox,
            player.offsetImage.oy
        )
    elseif player.actualState == player.states.DEATH then
        love.graphics.draw(
            player.animation.DEATH.spriteSheet,
            player.animation.DEATH.spriteTexture[roundFrame],
            player.x,
            player.y,
            0,
            player.offsetImage.sx,
            2,
            player.offsetImage.ox,
            player.offsetImage.oy
        )
    elseif player.actualState == player.states.ATTACK then
        love.graphics.draw(
            player.animation.ATTACK.spriteSheet,
            player.animation.ATTACK.spriteTexture[roundFrame],
            player.x,
            player.y,
            0,
            player.offsetImage.sx,
            2,
            player.offsetImage.ox,
            player.offsetImage.oy
        )
    end
    heal.Draw()
end

return player
