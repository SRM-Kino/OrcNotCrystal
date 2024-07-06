local archer = {
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
            maxFrame = 12
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
        DEAD = "Dead"
    },
    spriteSheetDimensions = {
        spriteWidth = 100,
        spriteHeight = 100
    },
    lifeDraw = {
        yOffset = 32,
        width = 25,
        height = 5
    }
}
local securitySelection = 900

archer.LoadImages = function()
    --IDLE - Archer
    archer.animation.IDLE.spriteSheet = love.graphics.newImage("Images/Allies/Archer/Archer-Idle.png")
    local nbCollumn = archer.animation.IDLE.spriteSheet:getWidth() / archer.spriteSheetDimensions.spriteWidth
    local nbLines = archer.animation.IDLE.spriteSheet:getHeight() / archer.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    archer.animation.IDLE.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            archer.animation.IDLE.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * archer.spriteSheetDimensions.spriteWidth,
                (l - 1) * archer.spriteSheetDimensions.spriteHeight,
                archer.spriteSheetDimensions.spriteWidth,
                archer.spriteSheetDimensions.spriteHeight,
                archer.animation.IDLE.spriteSheet:getWidth(),
                archer.animation.IDLE.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --ATTACK - Archer
    archer.animation.ATTACK.spriteSheet = love.graphics.newImage("Images/Allies/Archer/Archer-Attack02.png")
    local nbCollumn = archer.animation.ATTACK.spriteSheet:getWidth() / archer.spriteSheetDimensions.spriteWidth
    local nbLines = archer.animation.ATTACK.spriteSheet:getHeight() / archer.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    archer.animation.ATTACK.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            archer.animation.ATTACK.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * archer.spriteSheetDimensions.spriteWidth,
                (l - 1) * archer.spriteSheetDimensions.spriteHeight,
                archer.spriteSheetDimensions.spriteWidth,
                archer.spriteSheetDimensions.spriteHeight,
                archer.animation.ATTACK.spriteSheet:getWidth(),
                archer.animation.ATTACK.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --HURT Archer
    archer.animation.HURT.spriteSheet = love.graphics.newImage("Images/Allies/Archer/Archer-Hurt.png")
    local nbCollumn = archer.animation.HURT.spriteSheet:getWidth() / archer.spriteSheetDimensions.spriteWidth
    local nbLines = archer.animation.HURT.spriteSheet:getHeight() / archer.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    archer.animation.HURT.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            archer.animation.HURT.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * archer.spriteSheetDimensions.spriteWidth,
                (l - 1) * archer.spriteSheetDimensions.spriteHeight,
                archer.spriteSheetDimensions.spriteWidth,
                archer.spriteSheetDimensions.spriteHeight,
                archer.animation.HURT.spriteSheet:getWidth(),
                archer.animation.HURT.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --DEAD Archer
    archer.animation.DEAD.spriteSheet = love.graphics.newImage("Images/Allies/Archer/Archer-Death.png")
    local nbCollumn = archer.animation.DEAD.spriteSheet:getWidth() / archer.spriteSheetDimensions.spriteWidth
    local nbLines = archer.animation.DEAD.spriteSheet:getHeight() / archer.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    archer.animation.DEAD.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
            archer.animation.DEAD.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * archer.spriteSheetDimensions.spriteWidth,
                (l - 1) * archer.spriteSheetDimensions.spriteHeight,
                archer.spriteSheetDimensions.spriteWidth,
                archer.spriteSheetDimensions.spriteHeight,
                archer.animation.DEAD.spriteSheet:getWidth(),
                archer.animation.DEAD.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
end
local animationSpeed = 10
archer.UpdateAnimation = function(dt, e)
    --Reset de la frame en cas de changement d'état
    if e.state ~= e.previousState then
        e.frame = 1
    end

    if e.state == archer.STATES.IDLE then
        e.maxAnimationFrame = archer.animation.IDLE.maxFrame
    elseif e.state == archer.STATES.ATTACK then
        e.maxAnimationFrame = archer.animation.ATTACK.maxFrame
    elseif e.state == archer.STATES.HURT then
        e.maxAnimationFrame = archer.animation.HURT.maxFrame
    elseif e.state == archer.STATES.DEAD then
        e.maxAnimationFrame = archer.animation.DEAD.maxFrame
    end

    e.frame = e.frame + dt * animationSpeed

    if (e.frame >= e.maxAnimationFrame + 1) then
        e.frame = 1
        if e.state == archer.STATES.HURT then
            e.hurtAnimationDone = true
        elseif e.state == archer.STATES.DEAD then
            e.deadAnimationDone = true
        end
    end

    e.roundFrame = math.floor(e.frame)

    --Sécurité pour éviter le saut de frame
    e.previousState = e.state
end

--Prévisualisation de l'archer sur la souris pour le placement
archer.needToPlace = false
archer.archerPlacing = {
    x,
    y,
    direction
}
local mouseState
local oldMouseState = true
--Placement avec la souris
archer.PlaceWithMouse = function(mouseX, mouseY)
    mouseState = love.mouse.isDown(1)
    archer.archerPlacing.x = mouseX
    archer.archerPlacing.y = mouseY
    --Direction du sprite
    if mouseX <= screenWidth * 0.5 then
        archer.archerPlacing.direction = -archer.animation.sx
    else
        archer.archerPlacing.direction = archer.animation.sx
    end
    --Création de l'archer
    if mouseState and mouseState ~= oldMouseState and archer.needToPlace then
        archer.needToPlace = false
        archer.creation = true
    end
    oldMouseState = mouseState
end

--Création de l'archer
archer.Create = function(mouseX, direction)
    local myArcher = {
        x = mouseX,
        y = 275,
        direction = direction,
        state = archer.STATES.IDLE,
        previousState = archer.STATES.IDLE,
        range = 300,
        frame = 1,
        distanceCibleList = {},
        bestCible,
        idBestCible,
        maxAnimationFrame = 1,
        distanceToGoal,
        roundFrame = 1,
        damage = 1,
        isAttacking = false,
        deadAnimationDone = false,
        hurtAnimationDone = false,
        timerAttack = 1.3,
        delayAttack = 1.3,
        lifeDrawWidth,
        life = 100,
        maxLife = 100,
        percentLife = 100,
        previousLife = 100,
        isFree = false,
        type = 1
    }
    return myArcher
end

archer.CheckLifeChange = function(myArcher)
    myArcher.percentlife = (myArcher.life * 100) / myArcher.maxLife
    myArcher.lifeDrawWidth = (archer.lifeDraw.width * myArcher.percentlife) / 100
    --Sécurité pour le heal
    if myArcher.life >= myArcher.maxLife then
        myArcher.life = myArcher.maxLife
    end
    --En cas de perte de vie
    if myArcher.life <= 0 then
        myArcher.lifeDrawWidth = 0
        myArcher.state = archer.STATES.DEAD
    elseif myArcher.life ~= myArcher.previousLife and myArcher.life ~= 0 then
        myArcher.state = archer.STATES.HURT
        myArcher.previousLife = myArcher.life
    end
end

archer.IdleState = function(myArcher, ennemyList)
    for j = 1, #ennemyList do
        e = ennemyList[j]
        if myArcher.direction > 0 then
            --Detection droite
            if e.x > myArcher.x then
                myArcher.distanceToGoal = math.dist(myArcher.x, myArcher.y, e.x, e.y)
                if myArcher.distanceToGoal <= myArcher.range then
                    myArcher.state = archer.STATES.ATTACK
                end
            end
        end
        if myArcher.direction < 0 then
            --Detection Gauche
            if e.x < myArcher.x then
                myArcher.distanceToGoal = math.dist(myArcher.x, myArcher.y, e.x, e.y)
                if myArcher.distanceToGoal <= myArcher.range then
                    myArcher.state = archer.STATES.ATTACK
                end
            end
        end
    end
end

archer.AttackState = function(dt, myArcher, ennemyList)
    --ATTACK
    --Reset de la liste
    myArcher.distanceCibleList = {}
    --Sauveguarde de la distance de tout les ennemis
    for j = 1, #ennemyList do
        e = ennemyList[j]
        if myArcher.direction < 0 then
            --Detection Gauche
            if e.x < myArcher.x then
                myArcher.distanceCibleList[j] = math.dist(myArcher.x, myArcher.y, e.x, e.y)
            else
                --Chiffre bidon pour éviter une liste coupée
                myArcher.distanceCibleList[j] = securitySelection
            end
        elseif myArcher.direction > 0 then
            --Detection Gauche
            if e.x > myArcher.x then
                myArcher.distanceCibleList[j] = math.dist(myArcher.x, myArcher.y, e.x, e.y)
            else
                --Chiffre bidon pour éviter une liste coupée
                myArcher.distanceCibleList[j] = securitySelection
            end
        end
    end
    --On vient chercher l'ennemi le plus proche et on reprends son ID
    myArcher.bestCible, myArcher.id = FindClosestEnnemy(myArcher.distanceCibleList)

    if myArcher.bestCible == nill or myArcher.bestCible > myArcher.range then
        myArcher.state = archer.STATES.IDLE
    end

    myArcher.timerAttack = myArcher.timerAttack - dt
    if myArcher.timerAttack < 0 and myArcher.bestCible ~= nill then
        myArcher.timerAttack = myArcher.delayAttack
        ennemyList[myArcher.id].life = ennemyList[myArcher.id].life - myArcher.damage
    end
end

archer.HurtState = function(myArcher)
    if myArcher.hurtAnimationDone == true then
        myArcher.state = archer.STATES.IDLE
        myArcher.hurtAnimationDone = false
    end
end

archer.DeadState = function(myArcher)
    if myArcher.deadAnimationDone == true then
        myArcher.isFree = true
    end
end

--Chargement de l'archer
archer.Load = function()
    archer.LoadImages()
end

archer.Update = function(dt, a, ennemyList)
    archer.CheckLifeChange(a)
    --IDLE
    if a.state == archer.STATES.IDLE then
        archer.IdleState(a, ennemyList)
    elseif a.state == archer.STATES.ATTACK then
        archer.AttackState(dt, a, ennemyList)
    elseif a.state == archer.STATES.HURT then
        --HURT
        archer.HurtState(a)
    elseif a.state == archer.STATES.DEAD then
        --DEAD
        archer.DeadState(a)
    end
    archer.UpdateAnimation(dt, a)
end

archer.Draw = function(a)
    if archer.needToPlace then
        --Draw sur la souris
        love.graphics.draw(
            archer.animation.IDLE.spriteSheet,
            archer.animation.IDLE.spriteTexture[1],
            archer.archerPlacing.x,
            archer.archerPlacing.y,
            0,
            archer.archerPlacing.direction,
            archer.animation.sy,
            archer.spriteSheetDimensions.spriteWidth * 0.5,
            archer.spriteSheetDimensions.spriteHeight * 0.5
        )
    end

    --Faire uniquement une partie du draw
    if a == nil then
        return
    end
    --Dessin de l'archer
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
        "fill",
        a.x - archer.lifeDraw.width * 0.5,
        a.y - archer.lifeDraw.yOffset,
        a.lifeDrawWidth,
        archer.lifeDraw.height
    )
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "line",
        a.x - archer.lifeDraw.width * 0.5,
        a.y - archer.lifeDraw.yOffset,
        archer.lifeDraw.width,
        archer.lifeDraw.height
    )

    if a.state == archer.STATES.IDLE then
        love.graphics.draw(
            archer.animation.IDLE.spriteSheet,
            archer.animation.IDLE.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            archer.animation.sy,
            archer.spriteSheetDimensions.spriteWidth * 0.5,
            archer.spriteSheetDimensions.spriteHeight * 0.5
        )
    elseif a.state == archer.STATES.ATTACK then
        love.graphics.draw(
            archer.animation.ATTACK.spriteSheet,
            archer.animation.ATTACK.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            archer.animation.sy,
            archer.spriteSheetDimensions.spriteWidth * 0.5,
            archer.spriteSheetDimensions.spriteHeight * 0.5
        )
    elseif a.state == archer.STATES.HURT then
        love.graphics.draw(
            archer.animation.HURT.spriteSheet,
            archer.animation.HURT.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            archer.animation.sy,
            archer.spriteSheetDimensions.spriteWidth * 0.5,
            archer.spriteSheetDimensions.spriteHeight * 0.5
        )
    elseif a.state == archer.STATES.DEAD then
        love.graphics.draw(
            archer.animation.DEAD.spriteSheet,
            archer.animation.DEAD.spriteTexture[a.roundFrame],
            a.x,
            a.y,
            0,
            a.direction,
            archer.animation.sy,
            archer.spriteSheetDimensions.spriteWidth * 0.5,
            archer.spriteSheetDimensions.spriteHeight * 0.5
        )
    end
end

return archer
