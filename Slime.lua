local slime = {
    animation = {
        WALK = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 6
        },
        ATTACK = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 6
        },
        DEAD = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 4
        }
    },
    STATES = {
        WALK = "Walk",
        HURT = "Hurt",
        ATTACK = "Attack",
        DEAD = "Dead"
    },
    --Dimensions sprites
    spriteSheetDimensions = {
        spriteWidth = 100,
        spriteHeight = 100
    },
    offsetImage = {
        sx = 1,
        ox = 50,
        oy = 50
    },
}

slime.LoadImages = function()
    --WALK - Slime
    slime.animation.WALK.spriteSheet = love.graphics.newImage("Images/Ennemy/Slime/Slime-Walk.png")
    local nbCollumn = slime.animation.WALK.spriteSheet:getWidth() / slime.spriteSheetDimensions.spriteWidth
    local nbLines = slime.animation.WALK.spriteSheet:getHeight() / slime.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    slime.animation.WALK.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
                slime.animation.WALK.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * slime.spriteSheetDimensions.spriteWidth,
                (l - 1) * slime.spriteSheetDimensions.spriteHeight,
                slime.spriteSheetDimensions.spriteWidth,
                slime.spriteSheetDimensions.spriteHeight,
                slime.animation.WALK.spriteSheet:getWidth(),
                slime.animation.WALK.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --ATTACK SLIME
    slime.animation.ATTACK.spriteSheet = love.graphics.newImage("Images/Ennemy/Slime/Slime-Attack.png")
    local nbCollumn = slime.animation.ATTACK.spriteSheet:getWidth() / slime.spriteSheetDimensions.spriteWidth
    local nbLines = slime.animation.ATTACK.spriteSheet:getHeight() / slime.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    slime.animation.ATTACK.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
                slime.animation.ATTACK.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * slime.spriteSheetDimensions.spriteWidth,
                (l - 1) * slime.spriteSheetDimensions.spriteHeight,
                slime.spriteSheetDimensions.spriteWidth,
                slime.spriteSheetDimensions.spriteWidth,
                slime.animation.ATTACK.spriteSheet:getWidth(),
                slime.animation.ATTACK.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
    --DEAD SLIME
    slime.animation.DEAD.spriteSheet = love.graphics.newImage("Images/Ennemy/Slime/Slime-Death.png")
    local nbCollumn = slime.animation.DEAD.spriteSheet:getWidth() / slime.spriteSheetDimensions.spriteWidth
    local nbLines = slime.animation.DEAD.spriteSheet:getHeight() / slime.spriteSheetDimensions.spriteHeight
    local l, c
    local id = 1
    slime.animation.DEAD.spriteTexture[0] = nil
    for l = 1, nbLines do
        for c = 1, nbCollumn do
                slime.animation.DEAD.spriteTexture[id] =
                love.graphics.newQuad(
                (c - 1) * slime.spriteSheetDimensions.spriteWidth,
                (l - 1) * slime.spriteSheetDimensions.spriteHeight,
                slime.spriteSheetDimensions.spriteWidth,
                slime.spriteSheetDimensions.spriteWidth,
                slime.animation.DEAD.spriteSheet:getWidth(),
                slime.animation.DEAD.spriteSheet:getHeight()
            )
            id = id + 1
        end
    end
end

slime.UpdateAnimation = function(dt, e)
    --Reset de la frame en cas de changement d'état
    if e.state ~= e.previousState then
        e.frame = 1
    end

    if e.state == slime.STATES.WALK then
        e.maxAnimationFrame = slime.animation.WALK.maxFrame
    elseif e.state == slime.STATES.ATTACK then
        e.maxAnimationFrame = slime.animation.ATTACK.maxFrame
    elseif e.state == slime.STATES.DEAD then
        e.maxAnimationFrame = slime.animation.DEAD.maxFrame
    end

    e.frame = e.frame + dt * e.animationSpeed

    if (e.frame >= e.maxAnimationFrame + 1) then
        e.frame = 1
        if e.state == slime.STATES.HURT then
            e.hurtAnimationDone = true
        elseif e.state == slime.STATES.DEAD then
            e.deadAnimationDone = true
        end
    end

    e.roundFrame = math.floor(e.frame)

    --Sécurité pour éviter le saut de frame
    e.previousState = e.state
end

local randomSpawnArea
slime.CreateEnnemy = function(spawns)
    randomSpawnArea = love.math.random(1, 2)
    local myEnnemy = {
        x = spawns[randomSpawnArea].x,
        y = spawns[randomSpawnArea].y,
        vx = love.math.random(5, 30),
        direction = spawns[randomSpawnArea].direction,
        distanceToGoalCrystal,
        distanceToGoalAllies,
        bestCible = nill,
        distanceCibleList = {},
        isAttackingCrystal = false,
        state = slime.STATES.WALK,
        frame = 1,
        maxAnimationFrame = 1,
        roundFrame = 1,
        previousState = slime.STATES.WALK,
        isAttacking = false,
        isCharged = false,
        deadAnimationDone = false,
        hurtAnimationDone = false,
        life = 1,
        previousLife = 1,
        type = 1,
        range = 50,
        damage = 2,
        coinValue = 1,
        timerAttack = 2,
        delayAttack = 2,
        animationSpeed = 10,
        isFree = false
    }
    ennemyOnScreen = ennemyOnScreen + 1
    return myEnnemy
end

slime.Load = function()
    slime.LoadImages()
end

slime.CheckLifeChange = function(mySlime)
    --En cas de perte de vie
    if mySlime.life <= 0 then
        mySlime.state = slime.STATES.DEAD
    elseif mySlime.life ~= mySlime.previousLife and mySlime.life ~= 0 then
        mySlime.state = slime.STATES.HURT
        mySlime.previousLife = mySlime.life
    end
end

slime.WalkState = function(dt, mySlime, crystalX, crystalY, alliesList)
     --WALK
     mySlime.x = mySlime.x + mySlime.vx * dt * mySlime.direction
     mySlime.distanceToGoalCrystal = math.dist(mySlime.x, mySlime.y, crystalX, crystalY)
     -- Si en range du crystal
     if mySlime.distanceToGoalCrystal < mySlime.range then
        mySlime.state = slime.STATES.ATTACK
        mySlime.isAttackingCrystal = true
     end
     --Si un allié est à proximité
     for j = 1, #alliesList do
         a = alliesList[j]
         mySlime.distanceToGoalAllies = math.dist(mySlime.x, mySlime.y, a.x, a.y)
         if mySlime.distanceToGoalAllies < mySlime.range then
            mySlime.state = slime.STATES.ATTACK
            mySlime.isAttackingCrystal = false
         end
     end
end

slime.AttackState = function(dt, mySlime, alliesList)
     --ATTACK
    --Reset de la liste
    mySlime.distanceCibleList = {}
    mySlime.timerAttack = mySlime.timerAttack - dt
    if mySlime.timerAttack < 0 then
        mySlime.timerAttack = mySlime.delayAttack
        mySlime.isAttacking = true
    end
    if mySlime.isAttacking == true and mySlime.isAttackingCrystal == true then
        --Attaque du crystal
        crystalLife = crystalLife - mySlime.damage
        mySlime.isAttacking = false
    elseif mySlime.isAttacking == true and mySlime.isAttackingCrystal == false then
        --Attaque des alliés
        for j = 1, #alliesList do
            a = alliesList[j]
            mySlime.distanceCibleList[j] = math.dist(mySlime.x, mySlime.y, a.x, a.y)
        end

        mySlime.bestCible, mySlime.id = FindClosestEnnemy(mySlime.distanceCibleList)

        if mySlime.bestCible == nil or mySlime.bestCible > mySlime.range then
            mySlime.state = slime.STATES.WALK
            mySlime.isAttacking = false
        end
        if mySlime.bestCible ~= nil and mySlime.isAttacking and mySlime.bestCible < mySlime.range then
            alliesList[mySlime.id].life = alliesList[mySlime.id].life - mySlime.damage
            mySlime.isAttacking = false
        end
    end
end

slime.HurtState = function(mySlime)
    --HURT
    if mySlime.hurtAnimationDone == true then
        mySlime.state = slime.STATES.WALK
        mySlime.isCharged = false
        mySlime.hurtAnimationDone = false
    end
end

slime.DeadState = function(mySlime, ID)
    if mySlime.deadAnimationDone == true then
        money.coins = money.coins + mySlime.coinValue
        ennemyOnScreen = ennemyOnScreen - 1
        mySlime.isFree = true
    end
end

slime.Update = function(dt, e, alliesList, crystalX, crystalY)
    --Vérification d'un changement de vie
    slime.CheckLifeChange(e)
    if e.state == slime.STATES.WALK then
        slime.WalkState(dt, e, crystalX, crystalY, alliesList)
    elseif e.state == slime.STATES.ATTACK then
        slime.AttackState(dt, e, alliesList)
    elseif e.state == slime.STATES.HURT then
        slime.HurtState(e)
    elseif e.state == slime.STATES.DEAD then
        slime.DeadState(e, i)
    end
    slime.UpdateAnimation(dt, e)
end

slime.Draw = function(e)
    --Walking
    if e.state == slime.STATES.WALK then
            love.graphics.draw(
                slime.animation.WALK.spriteSheet,
                slime.animation.WALK.spriteTexture[e.roundFrame],
                e.x,
                e.y,
                0,
                e.direction,
                2,
                slime.offsetImage.ox,
                slime.offsetImage.oy
            )
    elseif e.state == slime.STATES.ATTACK then
            love.graphics.draw(
                slime.animation.ATTACK.spriteSheet,
                slime.animation.ATTACK.spriteTexture[e.roundFrame],
                e.x,
                e.y,
                0,
                e.direction,
                2,
                slime.offsetImage.ox,
                slime.offsetImage.oy
            )
    elseif e.state == slime.STATES.HURT and e.hurtAnimationDone == false then
        --Une vie donc jamais ici
    elseif e.state == slime.STATES.DEAD and e.deadAnimationDone == false then
            love.graphics.draw(
                slime.animation.DEAD.spriteSheet,
                slime.animation.DEAD.spriteTexture[e.roundFrame],
                e.x,
                e.y,
                0,
                e.direction,
                2,
                slime.offsetImage.ox,
                slime.offsetImage.oy
            )
    end
end

return slime