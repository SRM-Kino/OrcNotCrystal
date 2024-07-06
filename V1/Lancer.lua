--TODO repos après une charge
local lancer = {
    animation = {
        sx = 2,
        sy = 2,
        IDLE = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 6
        },
        ATTACK = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 8
        },
        HURT = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 4
        },
        DEAD = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 4
        }
    },
    STATES = {
        IDLE = "Idle",
        HURT = "Hurt",
        ATTACK = "Attack",
        RECHARGE = "Recharging attack",
        DEAD = "Dead"
    },
    spriteSheetDimensions = {
        spriteWidth = 100,
        spriteHeight = 100
    },
    lifeDraw = {
        yOffset = 54,
        width = 25,
        height = 5
    },
    rechargeDraw = {
        yOffset = 64
    }
}
local securitySelection = 900
local offsetCharge = 50
local offsetHitBox = 5

lancer.LoadImages = function()
    --IDLE - lancer
    lancer.animation.IDLE.spriteSheet = love.graphics.newImage("Images/Allies/Lancer/Lancer-Idle.png")
    local nbCollumn = lancer.animation.IDLE.spriteSheet:getWidth() / lancer.spriteSheetDimensions.spriteWidth
    local nbLines = lancer.animation.IDLE.spriteSheet:getHeight() / lancer.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    lancer.animation.IDLE.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            lancer.animation.IDLE.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * lancer.spriteSheetDimensions.spriteWidth,
                (l - 1) * lancer.spriteSheetDimensions.spriteHeight,
                lancer.spriteSheetDimensions.spriteWidth,
                lancer.spriteSheetDimensions.spriteHeight,
                lancer.animation.IDLE.spriteSheet:getWidth(),
                lancer.animation.IDLE.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --ATTACK - lancer
    lancer.animation.ATTACK.spriteSheet = love.graphics.newImage("Images/Allies/Lancer/Lancer-Attack03.png")
    local nbCollumn = lancer.animation.ATTACK.spriteSheet:getWidth() / lancer.spriteSheetDimensions.spriteWidth
    local nbLines = lancer.animation.ATTACK.spriteSheet:getHeight() / lancer.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    lancer.animation.ATTACK.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            lancer.animation.ATTACK.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * lancer.spriteSheetDimensions.spriteWidth,
                (l - 1) * lancer.spriteSheetDimensions.spriteHeight,
                lancer.spriteSheetDimensions.spriteWidth,
                lancer.spriteSheetDimensions.spriteHeight,
                lancer.animation.ATTACK.spriteSheet:getWidth(),
                lancer.animation.ATTACK.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --HURT - lancer
    lancer.animation.HURT.spriteSheet = love.graphics.newImage("Images/Allies/Lancer/Lancer-Hurt.png")
    local nbCollumn = lancer.animation.HURT.spriteSheet:getWidth() / lancer.spriteSheetDimensions.spriteWidth
    local nbLines = lancer.animation.HURT.spriteSheet:getHeight() / lancer.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    lancer.animation.HURT.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            lancer.animation.HURT.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * lancer.spriteSheetDimensions.spriteWidth,
                (l - 1) * lancer.spriteSheetDimensions.spriteHeight,
                lancer.spriteSheetDimensions.spriteWidth,
                lancer.spriteSheetDimensions.spriteHeight,
                lancer.animation.HURT.spriteSheet:getWidth(),
                lancer.animation.HURT.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --DEAD - lancer
    lancer.animation.DEAD.spriteSheet = love.graphics.newImage("Images/Allies/Lancer/Lancer-Death.png")
    local nbCollumn = lancer.animation.DEAD.spriteSheet:getWidth() / lancer.spriteSheetDimensions.spriteWidth
    local nbLines = lancer.animation.DEAD.spriteSheet:getHeight() / lancer.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    lancer.animation.DEAD.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            lancer.animation.DEAD.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * lancer.spriteSheetDimensions.spriteWidth,
                (l - 1) * lancer.spriteSheetDimensions.spriteHeight,
                lancer.spriteSheetDimensions.spriteWidth,
                lancer.spriteSheetDimensions.spriteHeight,
                lancer.animation.DEAD.spriteSheet:getWidth(),
                lancer.animation.DEAD.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
end
--Animation
local animationSpeed = 10
lancer.UpdateAnimation = function(dt, e)
    --Reset de la frame en cas de changement d'état
    if e.state ~= e.previousState then
        e.frame = 1
    end

    if e.state == lancer.STATES.IDLE or e.state == lancer.STATES.RECHARGE then
        e.maxAnimationFrame = lancer.animation.IDLE.maxFrame
    elseif e.state == lancer.STATES.ATTACK then
        e.maxAnimationFrame = lancer.animation.ATTACK.maxFrame
    elseif e.state == lancer.STATES.HURT then
        e.maxAnimationFrame = lancer.animation.HURT.maxFrame
    elseif e.state == lancer.STATES.DEAD then
        e.maxAnimationFrame = lancer.animation.DEAD.maxFrame
    end

    e.frame = e.frame + dt * animationSpeed

    if (e.frame >= e.maxAnimationFrame + 1) then
        e.frame = 1
        if e.state == lancer.STATES.HURT then
            e.hurtAnimationDone = true
        elseif e.state == lancer.STATES.DEAD then
            e.deadAnimationDone = true
        end
    end

    e.roundFrame = math.floor(e.frame)

    --Sécurité pour éviter le saut de frame
    e.previousState = e.state
end

--Prévisualisation de l'archer sur la souris pour le placement
lancer.needToPlace = false
lancer.lancerPlacing = {
    x,
    y,
    direction
}

local mouseState
local oldMouseState = true
lancer.PlaceWithMouse = function(mouseX, mouseY)
    mouseState = love.mouse.isDown(1)
    lancer.lancerPlacing.x = mouseX
    lancer.lancerPlacing.y = mouseY
    --Direction du sprite
    if mouseX <= screenWidth * 0.5 then
        lancer.lancerPlacing.direction = -lancer.animation.sx
    else
        lancer.lancerPlacing.direction = lancer.animation.sx
    end
    --Création de l'archer
    if mouseState and mouseState ~= oldMouseState and lancer.needToPlace then
        lancer.needToPlace = false
        lancer.creation = true
    end
    oldMouseState = mouseState
end

--Création de l'archer
lancer.Create = function(mouseX, direction)
    local myLancer = {
        x = mouseX,
        y = 275,
        vx = 60,
        direction = direction,
        state = lancer.STATES.IDLE,
        previousState = lancer.STATES.IDLE,
        range = 900,
        frame = 1,
        distanceCibleList = {},
        bestCible,
        cibleX,
        idBestCible,
        maxAnimationFrame = 1,
        distanceToGoal,
        roundFrame = 1,
        damage = 2,
        isAttacking = false,
        deadAnimationDone = false,
        hurtAnimationDone = false,
        timerRecharge = 3,
        delayRecharge = 3,
        lifeDrawWidth,
        life = 50,
        maxLife = 50,
        percentLife = 100,
        previousLife = 50,
        isCharging = false,
        isFree = false,
        type = 2,
    }
    return myLancer
end

lancer.CheckLifeChange = function(myLancer)
    --Calcul de la vie pour le draw
    myLancer.percentlife = (myLancer.life * 100) / myLancer.maxLife
    myLancer.lifeDrawWidth = (lancer.lifeDraw.width * myLancer.percentlife) / 100
    --Sécurité pour le heal
    if myLancer.life > myLancer.maxLife then
        myLancer.life = myLancer.maxLife
    end
    --En cas de perte de vie
    if myLancer.life <= 0 then
        myLancer.lifeDrawWidth = 0
        myLancer.state = lancer.STATES.DEAD
    elseif myLancer.life ~= myLancer.previousLife and myLancer.life ~= 0 then
        myLancer.state = lancer.STATES.HURT
        myLancer.previousLife = myLancer.life
    end
end

lancer.IdleState = function(myLancer, ennemyList)
    for j = 1, #ennemyList do
        e = ennemyList[j]
        --Detection
        myLancer.distanceToGoal = math.dist(myLancer.x, myLancer.y, e.x, e.y)
        if myLancer.distanceToGoal <= myLancer.range then
            myLancer.state = lancer.STATES.ATTACK
        end
    end
end

lancer.AttackState = function(dt, myLancer, ennemyList)
    --ATTACK
    --Reset de la liste
    myLancer.distanceCibleList = {}
    --Sauveguarde de la distance de tout les ennemis si on charge pas déjà un ennemi
    if myLancer.isCharging == false then
        for j = 1, #ennemyList do
            e = ennemyList[j]
            --Detection Gauche
            myLancer.distanceCibleList[j] = math.dist(myLancer.x, myLancer.y, e.x, e.y)
        end
        --On vient chercher l'ennemi le plus loin et on reprends son ID
        myLancer.bestCible, myLancer.id = FindFarthestEnnemy(myLancer.distanceCibleList)
        if myLancer.bestCible == nill or myLancer.bestCible > myLancer.range then
            myLancer.state = lancer.STATES.IDLE
        end
        if myLancer.bestCible ~= nill then
            if ennemyList[myLancer.id].x > myLancer.x then
                myLancer.direction = lancer.animation.sx
            elseif ennemyList[myLancer.id].x < myLancer.x then
                myLancer.direction = -lancer.animation.sx
            end
            --Charge et enregistrement de la coordonnée au début de la charge
            myLancer.cibleX = ennemyList[myLancer.id].x
            myLancer.isCharging = true
        end
    end
    if myLancer.isCharging == true then
        --Si je charge comment ?
        myLancer.x = myLancer.x + myLancer.vx * dt * myLancer.direction
        for j = 1, #ennemyList do
            e = ennemyList[j]
            if e.x <= myLancer.x + offsetHitBox and e.x >= myLancer.x - offsetHitBox and e.isCharged == false then
                e.life = e.life - myLancer.damage
                e.isCharged = true
            end
        end
        if
            (myLancer.direction > 0 and myLancer.x >= myLancer.cibleX + offsetCharge) or
                (myLancer.direction < 0 and myLancer.x <= myLancer.cibleX - offsetCharge)
            then
            myLancer.isCharging = false
            myLancer.state = lancer.STATES.RECHARGE
        end
    end
end

lancer.RechargeState = function(dt, myLancer)
    myLancer.timerRecharge = myLancer.timerRecharge - dt
    if myLancer.timerRecharge <= 0 then
        myLancer.timerRecharge = myLancer.delayRecharge
        myLancer.state = lancer.STATES.IDLE
    end
end

lancer.HurtState = function(myLancer)
    --HURT
    if myLancer.hurtAnimationDone == true then
        myLancer.state = lancer.STATES.IDLE
        myLancer.hurtAnimationDone = false
    end
end

lancer.DeadState = function(myLancer)
    --DEAD
    if myLancer.deadAnimationDone == true then
        myLancer.isFree = true
    end
end

--Chargement du lancer
lancer.Load = function()
    lancer.LoadImages()
end

lancer.Update = function(dt, a, ennemyList)
    lancer.CheckLifeChange(a)
    if a.state == lancer.STATES.IDLE then
        lancer.IdleState(a, ennemyList)
    elseif a.state == lancer.STATES.ATTACK then
        lancer.AttackState(dt, a, ennemyList)
    elseif a.state == lancer.STATES.RECHARGE then
        lancer.RechargeState(dt, a)
    elseif a.state == lancer.STATES.HURT then
        lancer.HurtState(a)
    elseif a.state == lancer.STATES.DEAD then
        lancer.DeadState(a)
    end
    lancer.UpdateAnimation(dt, a)
end

lancer.Draw = function(a)
    if lancer.needToPlace then
        --Draw sur la souris
        love.graphics.draw(
            lancer.animation.IDLE.spriteSheet,
            lancer.animation.IDLE.spriteTexture[1],
            lancer.lancerPlacing.x,
            lancer.lancerPlacing.y,
            0,
            lancer.lancerPlacing.direction,
            lancer.animation.sy,
            lancer.spriteSheetDimensions.spriteWidth * 0.5,
            lancer.spriteSheetDimensions.spriteHeight * 0.5
        )
    end

    if a == nil then return end
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
        "fill",
        a.x - lancer.lifeDraw.width * 0.5,
        a.y - lancer.lifeDraw.yOffset,
        a.lifeDrawWidth,
        lancer.lifeDraw.height
    )
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "line",
        a.x - lancer.lifeDraw.width * 0.5,
        a.y - lancer.lifeDraw.yOffset,
        lancer.lifeDraw.width,
        lancer.lifeDraw.height
    )

    if a.state == lancer.STATES.IDLE then
        love.graphics.draw(
            lancer.animation.IDLE.spriteSheet,
            lancer.animation.IDLE.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            lancer.animation.sy,
            lancer.spriteSheetDimensions.spriteWidth * 0.5,
            lancer.spriteSheetDimensions.spriteHeight * 0.5
        )
    elseif a.state == lancer.STATES.ATTACK then
        love.graphics.draw(
            lancer.animation.ATTACK.spriteSheet,
            lancer.animation.ATTACK.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            lancer.animation.sy,
            lancer.spriteSheetDimensions.spriteWidth * 0.5,
            lancer.spriteSheetDimensions.spriteHeight * 0.5
        )
    elseif a.state == lancer.STATES.RECHARGE then
        --Montrer que le personnage est en recharge
        love.graphics.setColor(1, 0, 0)
        love.graphics.print(lancer.STATES.RECHARGE, a.x, a.y + lancer.rechargeDraw.yOffset)
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(
            lancer.animation.IDLE.spriteSheet,
            lancer.animation.IDLE.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            lancer.animation.sy,
            lancer.spriteSheetDimensions.spriteWidth * 0.5,
            lancer.spriteSheetDimensions.spriteHeight * 0.5
        )
    elseif a.state == lancer.STATES.HURT then
        love.graphics.draw(
            lancer.animation.HURT.spriteSheet,
            lancer.animation.HURT.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            lancer.animation.sy,
            lancer.spriteSheetDimensions.spriteWidth * 0.5,
            lancer.spriteSheetDimensions.spriteHeight * 0.5
        )
    elseif a.state == lancer.STATES.DEAD then
        love.graphics.draw(
            lancer.animation.DEAD.spriteSheet,
            lancer.animation.DEAD.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            lancer.animation.sy,
            lancer.spriteSheetDimensions.spriteWidth * 0.5,
            lancer.spriteSheetDimensions.spriteHeight * 0.5
        )
    end
end

return lancer
