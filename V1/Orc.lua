local orc = {
    animation = {
        WALK = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 8
        },
        ATTACK = {
            spriteSheet,
            spriteTexture = {},
            maxFrame = 6
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

orc.LoadImages = function()
     --WALK - Orc
     orc.animation.WALK.spriteSheet = love.graphics.newImage("Images/Ennemy/Orc/Orc-Walk.png")
     local nbCollumn = orc.animation.WALK.spriteSheet:getWidth() / orc.spriteSheetDimensions.spriteWidth
     local nbLines = orc.animation.WALK.spriteSheet:getHeight() / orc.spriteSheetDimensions.spriteHeight
     local l, c
     local id = 1
     orc.animation.WALK.spriteTexture[0] = nil
     for l = 1, nbLines do
         for c = 1, nbCollumn do
             orc.animation.WALK.spriteTexture[id] =
                 love.graphics.newQuad(
                 (c - 1) * orc.spriteSheetDimensions.spriteWidth,
                 (l - 1) * orc.spriteSheetDimensions.spriteHeight,
                 orc.spriteSheetDimensions.spriteWidth,
                 orc.spriteSheetDimensions.spriteWidth,
                 orc.animation.WALK.spriteSheet:getWidth(),
                 orc.animation.WALK.spriteSheet:getHeight()
             )
             id = id + 1
         end
     end
     --ATTACK - Orc
     orc.animation.ATTACK.spriteSheet = love.graphics.newImage("Images/Ennemy/Orc/Orc-Attack01.png")
     local nbCollumn = orc.animation.ATTACK.spriteSheet:getWidth() / orc.spriteSheetDimensions.spriteWidth
     local nbLines = orc.animation.ATTACK.spriteSheet:getHeight() / orc.spriteSheetDimensions.spriteHeight
     local l, c
     local id = 1
     orc.animation.ATTACK.spriteTexture[0] = nil
     for l = 1, nbLines do
         for c = 1, nbCollumn do
             orc.animation.ATTACK.spriteTexture[id] =
                 love.graphics.newQuad(
                 (c - 1) * orc.spriteSheetDimensions.spriteWidth,
                 (l - 1) * orc.spriteSheetDimensions.spriteHeight,
                 orc.spriteSheetDimensions.spriteWidth,
                 orc.spriteSheetDimensions.spriteWidth,
                 orc.animation.ATTACK.spriteSheet:getWidth(),
                 orc.animation.ATTACK.spriteSheet:getHeight()
             )
             id = id + 1
         end
     end
      --HURT - Orc
     orc.animation.HURT.spriteSheet = love.graphics.newImage("Images/Ennemy/Orc/Orc-Hurt.png")
     local nbCollumn = orc.animation.HURT.spriteSheet:getWidth() / orc.spriteSheetDimensions.spriteWidth
     local nbLines = orc.animation.HURT.spriteSheet:getHeight() / orc.spriteSheetDimensions.spriteHeight
     local l, c
     local id = 1
     orc.animation.HURT.spriteTexture[0] = nil
     for l = 1, nbLines do
         for c = 1, nbCollumn do
             orc.animation.HURT.spriteTexture[id] =
                 love.graphics.newQuad(
                 (c - 1) * orc.spriteSheetDimensions.spriteWidth,
                 (l - 1) * orc.spriteSheetDimensions.spriteHeight,
                 orc.spriteSheetDimensions.spriteWidth,
                 orc.spriteSheetDimensions.spriteWidth,
                 orc.animation.HURT.spriteSheet:getWidth(),
                 orc.animation.HURT.spriteSheet:getHeight()
             )
             id = id + 1
         end
     end
     --DEAD - Orc
     orc.animation.DEAD.spriteSheet = love.graphics.newImage("Images/Ennemy/Orc/Orc-Death.png")
     local nbCollumn = orc.animation.DEAD.spriteSheet:getWidth() / orc.spriteSheetDimensions.spriteWidth
     local nbLines = orc.animation.DEAD.spriteSheet:getHeight() / orc.spriteSheetDimensions.spriteHeight
     local l, c
     local id = 1
     orc.animation.DEAD.spriteTexture[0] = nil
     for l = 1, nbLines do
         for c = 1, nbCollumn do
             orc.animation.DEAD.spriteTexture[id] =
                 love.graphics.newQuad(
                 (c - 1) * orc.spriteSheetDimensions.spriteWidth,
                 (l - 1) * orc.spriteSheetDimensions.spriteHeight,
                 orc.spriteSheetDimensions.spriteWidth,
                 orc.spriteSheetDimensions.spriteWidth,
                 orc.animation.DEAD.spriteSheet:getWidth(),
                 orc.animation.DEAD.spriteSheet:getHeight()
             )
             id = id + 1
         end
     end
end

orc.UpdateAnimation = function(dt, e)
    --Reset de la frame en cas de changement d'état
    if e.state ~= e.previousState then
        e.frame = 1
    end

    if e.state == orc.STATES.WALK then
        e.maxAnimationFrame = orc.animation.WALK.maxFrame
    elseif e.state == orc.STATES.ATTACK then
        e.maxAnimationFrame = orc.animation.ATTACK.maxFrame
    elseif e.state == orc.STATES.DEAD then
        e.maxAnimationFrame = orc.animation.DEAD.maxFrame
    elseif e.state == orc.STATES.HURT then
        e.maxAnimationFrame = orc.animation.HURT.maxFrame
    end

    e.frame = e.frame + dt * e.animationSpeed

    if (e.frame >= e.maxAnimationFrame + 1) then
        e.frame = 1
        if e.state == orc.STATES.HURT then
            e.hurtAnimationDone = true
        elseif e.state == orc.STATES.DEAD then
            e.deadAnimationDone = true
        end
    end

    e.roundFrame = math.floor(e.frame)

    --Sécurité pour éviter le saut de frame
    e.previousState = e.state
end

local randomSpawnArea
orc.CreateEnnemy = function(spawns)
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
        state = orc.STATES.WALK,
        frame = 1,
        maxAnimationFrame = 1,
        roundFrame = 1,
        previousState = orc.STATES.WALK,
        isAttacking = false,
        isCharged = false,
        deadAnimationDone = false,
        hurtAnimationDone = false,
        life = 5,
        previousLife = 5,
        type = 3,
        damage = 5,
        range = 50,
        coinValue = 10,
        timerAttack = 3,
        delayAttack = 3,
        animationSpeed = 6,
        isFree = false,
    }
    ennemyOnScreen = ennemyOnScreen + 1
    return myEnnemy
end

orc.Load = function()
    orc.LoadImages()
end

orc.CheckLifeChange = function(myOrc)
    --En cas de perte de vie
    if myOrc.life <= 0 then
        myOrc.state = orc.STATES.DEAD
    elseif myOrc.life ~= myOrc.previousLife and myOrc.life ~= 0 then
        myOrc.state = orc.STATES.HURT
        myOrc.previousLife = myOrc.life
    end
end

orc.WalkState = function(dt, myOrc, crystalX, crystalY, alliesList)
     --WALK
     myOrc.x = myOrc.x + myOrc.vx * dt * myOrc.direction
     myOrc.distanceToGoalCrystal = math.dist(myOrc.x, myOrc.y, crystalX, crystalY)
     -- Si en range du crystal
     if myOrc.distanceToGoalCrystal < myOrc.range then
        myOrc.state = orc.STATES.ATTACK
        myOrc.isAttackingCrystal = true
     end
     --Si un allié est à proximité
     for j = 1, #alliesList do
         local a = alliesList[j]
         myOrc.distanceToGoalAllies = math.dist(myOrc.x, myOrc.y, a.x, a.y)
         if myOrc.distanceToGoalAllies < myOrc.range then
            myOrc.state = orc.STATES.ATTACK
            myOrc.isAttackingCrystal = false
         end
     end
end

orc.AttackState = function(dt, myOrc, alliesList)
     --ATTACK
    --Reset de la liste
    myOrc.distanceCibleList = {}
    myOrc.timerAttack = myOrc.timerAttack - dt
    if myOrc.timerAttack < 0 then
        myOrc.timerAttack = myOrc.delayAttack
        myOrc.isAttacking = true
    end
    if myOrc.isAttacking == true and myOrc.isAttackingCrystal == true then
        --Attaque du crystal
        crystalLife = crystalLife - myOrc.damage
        myOrc.isAttacking = false
    elseif myOrc.isAttacking == true and myOrc.isAttackingCrystal == false then
        --Attaque des alliés
        for j = 1, #alliesList do
            local a = alliesList[j]
            myOrc.distanceCibleList[j] = math.dist(myOrc.x, myOrc.y, a.x, a.y)
        end

        myOrc.bestCible, myOrc.id = FindClosestEnnemy(myOrc.distanceCibleList)
        
        if myOrc.bestCible == nil or myOrc.bestCible > myOrc.range then
            myOrc.state = orc.STATES.WALK
            myOrc.isAttacking = false
        end
        if myOrc.bestCible ~= nil and myOrc.isAttacking and myOrc.bestCible < myOrc.range then
            alliesList[myOrc.id].life = alliesList[myOrc.id].life - myOrc.damage
            myOrc.isAttacking = false
        end
    end
end

orc.HurtState = function(myOrc)
    --HURT
    if myOrc.hurtAnimationDone == true then
        myOrc.state = orc.STATES.WALK
        myOrc.isCharged = false
        myOrc.hurtAnimationDone = false
    end
end

orc.DeadState = function(myOrc, ID)
    if myOrc.deadAnimationDone == true then
        money.coins = money.coins + myOrc.coinValue
        ennemyOnScreen = ennemyOnScreen - 1
        myOrc.isFree = true
    end
end

orc.Update = function(dt, e, alliesList, crystalX, crystalY)      
    --Vérification d'un changement de vie
    orc.CheckLifeChange(e)
    if e.state == orc.STATES.WALK then
        orc.WalkState(dt, e, crystalX, crystalY, alliesList)
    elseif e.state == orc.STATES.ATTACK then
        orc.AttackState(dt, e, alliesList)
    elseif e.state == orc.STATES.HURT then
        orc.HurtState(e)
    elseif e.state == orc.STATES.DEAD then
        orc.DeadState(e, i)
    end
    orc.UpdateAnimation(dt, e)
end

orc.Draw = function(e)
    --Walking
    if e.state == orc.STATES.WALK then
        love.graphics.draw(
            orc.animation.WALK.spriteSheet,
            orc.animation.WALK.spriteTexture[e.roundFrame],
            e.x,
            e.y,
            0,
            e.direction,
            2,
            orc.offsetImage.ox,
            orc.offsetImage.oy
        )
    elseif e.state == orc.STATES.ATTACK then
        love.graphics.draw(
            orc.animation.ATTACK.spriteSheet,
            orc.animation.ATTACK.spriteTexture[e.roundFrame],
            e.x,
            e.y,
            0,
            e.direction,
            2,
            orc.offsetImage.ox,
            orc.offsetImage.oy
        )
    elseif e.state == orc.STATES.HURT and e.hurtAnimationDone == false then
        love.graphics.draw(
            orc.animation.HURT.spriteSheet,
            orc.animation.HURT.spriteTexture[e.roundFrame],
            e.x,
            e.y,
            0,
            e.direction,
            2,
            orc.offsetImage.ox,
            orc.offsetImage.oy
            )
    elseif e.state == orc.STATES.DEAD and e.deadAnimationDone == false then
        love.graphics.draw(
            orc.animation.DEAD.spriteSheet,
            orc.animation.DEAD.spriteTexture[e.roundFrame],
            e.x,
            e.y,
            0,
            e.direction,
            2,
            orc.offsetImage.ox,
            orc.offsetImage.oy
        )
    end
end

return orc