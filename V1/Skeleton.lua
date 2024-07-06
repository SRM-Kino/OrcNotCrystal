local skeleton = {
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

skeleton.LoadImages = function()
     --WALK - Skeleton
     skeleton.animation.WALK.spriteSheet = love.graphics.newImage("Images/Ennemy/Skeleton/Skeleton-Walk.png")
     local nbCollumn = skeleton.animation.WALK.spriteSheet:getWidth() / skeleton.spriteSheetDimensions.spriteWidth
     local nbLines = skeleton.animation.WALK.spriteSheet:getHeight() / skeleton.spriteSheetDimensions.spriteHeight
     local l, c
     local id = 1
     skeleton.animation.WALK.spriteTexture[0] = nil
     for l = 1, nbLines do
         for c = 1, nbCollumn do
             skeleton.animation.WALK.spriteTexture[id] =
                 love.graphics.newQuad(
                 (c - 1) * skeleton.spriteSheetDimensions.spriteWidth,
                 (l - 1) * skeleton.spriteSheetDimensions.spriteHeight,
                 skeleton.spriteSheetDimensions.spriteWidth,
                 skeleton.spriteSheetDimensions.spriteWidth,
                 skeleton.animation.WALK.spriteSheet:getWidth(),
                 skeleton.animation.WALK.spriteSheet:getHeight()
             )
             id = id + 1
         end
     end
     --HURT - Skeleton
     skeleton.animation.HURT.spriteSheet = love.graphics.newImage("Images/Ennemy/Skeleton/Skeleton-Hurt.png")
     local nbCollumn = skeleton.animation.HURT.spriteSheet:getWidth() / skeleton.spriteSheetDimensions.spriteWidth
     local nbLines = skeleton.animation.HURT.spriteSheet:getHeight() / skeleton.spriteSheetDimensions.spriteHeight
     local l, c
     local id = 1
     skeleton.animation.HURT.spriteTexture[0] = nil
     for l = 1, nbLines do
         for c = 1, nbCollumn do
             skeleton.animation.HURT.spriteTexture[id] =
                 love.graphics.newQuad(
                 (c - 1) * skeleton.spriteSheetDimensions.spriteWidth,
                 (l - 1) * skeleton.spriteSheetDimensions.spriteHeight,
                 skeleton.spriteSheetDimensions.spriteWidth,
                 skeleton.spriteSheetDimensions.spriteWidth,
                 skeleton.animation.HURT.spriteSheet:getWidth(),
                 skeleton.animation.HURT.spriteSheet:getHeight()
             )
             id = id + 1
         end
     end
     --ATTACK - Skeleton
     skeleton.animation.ATTACK.spriteSheet =
         love.graphics.newImage("Images/Ennemy/Skeleton/Skeleton-Attack01.png")
     local nbCollumn = skeleton.animation.ATTACK.spriteSheet:getWidth() / skeleton.spriteSheetDimensions.spriteWidth
     local nbLines = skeleton.animation.ATTACK.spriteSheet:getHeight() / skeleton.spriteSheetDimensions.spriteHeight
     local l, c
     local id = 1
     skeleton.animation.ATTACK.spriteTexture[0] = nil
     for l = 1, nbLines do
         for c = 1, nbCollumn do
             skeleton.animation.ATTACK.spriteTexture[id] =
                 love.graphics.newQuad(
                 (c - 1) * skeleton.spriteSheetDimensions.spriteWidth,
                 (l - 1) * skeleton.spriteSheetDimensions.spriteHeight,
                 skeleton.spriteSheetDimensions.spriteWidth,
                 skeleton.spriteSheetDimensions.spriteWidth,
                 skeleton.animation.ATTACK.spriteSheet:getWidth(),
                 skeleton.animation.ATTACK.spriteSheet:getHeight()
             )
             id = id + 1
         end
     end
     --DEAD - Skeleton
     skeleton.animation.DEAD.spriteSheet = love.graphics.newImage("Images/Ennemy/Skeleton/Skeleton-Death.png")
     local nbCollumn = skeleton.animation.DEAD.spriteSheet:getWidth() / skeleton.spriteSheetDimensions.spriteWidth
     local nbLines = skeleton.animation.DEAD.spriteSheet:getHeight() / skeleton.spriteSheetDimensions.spriteHeight
     local l, c
     local id = 1
     skeleton.animation.DEAD.spriteTexture[0] = nil
     for l = 1, nbLines do
         for c = 1, nbCollumn do
             skeleton.animation.DEAD.spriteTexture[id] =
                 love.graphics.newQuad(
                 (c - 1) * skeleton.spriteSheetDimensions.spriteWidth,
                 (l - 1) * skeleton.spriteSheetDimensions.spriteHeight,
                 skeleton.spriteSheetDimensions.spriteWidth,
                 skeleton.spriteSheetDimensions.spriteWidth,
                 skeleton.animation.DEAD.spriteSheet:getWidth(),
                 skeleton.animation.DEAD.spriteSheet:getHeight()
             )
             id = id + 1
         end
     end
end

skeleton.UpdateAnimation = function(dt, e)
    --Reset de la frame en cas de changement d'état
    if e.state ~= e.previousState then
        e.frame = 1
    end

    if e.state == skeleton.STATES.WALK then
        e.maxAnimationFrame = skeleton.animation.WALK.maxFrame
    elseif e.state == skeleton.STATES.ATTACK then
        e.maxAnimationFrame = skeleton.animation.ATTACK.maxFrame
    elseif e.state == skeleton.STATES.DEAD then
        e.maxAnimationFrame = skeleton.animation.DEAD.maxFrame
    elseif e.state == skeleton.STATES.HURT then
        e.maxAnimationFrame = skeleton.animation.HURT.maxFrame
    end

    e.frame = e.frame + dt * e.animationSpeed

    if (e.frame >= e.maxAnimationFrame + 1) then
        e.frame = 1
        if e.state == skeleton.STATES.HURT then
            e.hurtAnimationDone = true
        elseif e.state == skeleton.STATES.DEAD then
            e.deadAnimationDone = true
        end
    end

    e.roundFrame = math.floor(e.frame)

    --Sécurité pour éviter le saut de frame
    e.previousState = e.state
end

local randomSpawnArea
skeleton.CreateEnnemy = function(spawns)
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
        state = skeleton.STATES.WALK,
        frame = 1,
        maxAnimationFrame = 1,
        roundFrame = 1,
        previousState = skeleton.STATES.WALK,
        isAttacking = false,
        isCharged = false,
        deadAnimationDone = false,
        hurtAnimationDone = false,
        life = 2,
        previousLife = 2,
        type = 2,
        damage = 5,
        range = 50,
        coinValue = 5,
        timerAttack = 2,
        delayAttack = 2,
        animationSpeed = 10,
        isFree = false
    }
    ennemyOnScreen = ennemyOnScreen + 1
    return myEnnemy
end

skeleton.Load = function()
    skeleton.LoadImages()
end

skeleton.CheckLifeChange = function(mySkeleton)
    --En cas de perte de vie
    if mySkeleton.life <= 0 then
        mySkeleton.state = skeleton.STATES.DEAD
    elseif mySkeleton.life ~= mySkeleton.previousLife and mySkeleton.life ~= 0 then
        mySkeleton.state = skeleton.STATES.HURT
        mySkeleton.previousLife = mySkeleton.life
    end
end

skeleton.WalkState = function(dt, mySkeleton, crystalX, crystalY, alliesList)
     --WALK
     mySkeleton.x = mySkeleton.x + mySkeleton.vx * dt * mySkeleton.direction
     mySkeleton.distanceToGoalCrystal = math.dist(mySkeleton.x, mySkeleton.y, crystalX, crystalY)
     -- Si en range du crystal
     if mySkeleton.distanceToGoalCrystal < mySkeleton.range then
        mySkeleton.state = skeleton.STATES.ATTACK
        mySkeleton.isAttackingCrystal = true
     end
     --Si un allié est à proximité
     for j = 1, #alliesList do
         a = alliesList[j]
         mySkeleton.distanceToGoalAllies = math.dist(mySkeleton.x, mySkeleton.y, a.x, a.y)
         if mySkeleton.distanceToGoalAllies < mySkeleton.range then
            mySkeleton.state = skeleton.STATES.ATTACK
            mySkeleton.isAttackingCrystal = false
         end
     end
end

skeleton.AttackState = function(dt, mySkeleton, alliesList)
     --ATTACK
    --Reset de la liste
    mySkeleton.distanceCibleList = {}
    mySkeleton.timerAttack = mySkeleton.timerAttack - dt
    if mySkeleton.timerAttack < 0 then
        mySkeleton.timerAttack = mySkeleton.delayAttack
        mySkeleton.isAttacking = true
    end
    if mySkeleton.isAttacking == true and mySkeleton.isAttackingCrystal == true then
        --Attaque du crystal
        crystalLife = crystalLife - mySkeleton.damage
        mySkeleton.isAttacking = false
    elseif mySkeleton.isAttacking == true and mySkeleton.isAttackingCrystal == false then
        --Attaque des alliés
        for j = 1, #alliesList do
            local a = alliesList[j]
            mySkeleton.distanceCibleList[j] = math.dist(mySkeleton.x, mySkeleton.y, a.x, a.y)
        end

        mySkeleton.bestCible, mySkeleton.id = FindClosestEnnemy(mySkeleton.distanceCibleList)

        if mySkeleton.bestCible == nil or mySkeleton.bestCible > mySkeleton.range then
            mySkeleton.state = skeleton.STATES.WALK
            mySkeleton.isAttacking = false
        end
        if mySkeleton.bestCible ~= nil and mySkeleton.isAttacking and mySkeleton.bestCible < mySkeleton.range then
            alliesList[mySkeleton.id].life = alliesList[mySkeleton.id].life - mySkeleton.damage
            mySkeleton.isAttacking = false
        end
    end
end

skeleton.HurtState = function(mySkeleton)
    --HURT
    if mySkeleton.hurtAnimationDone == true then
        mySkeleton.state = skeleton.STATES.WALK
        mySkeleton.isCharged = false
        mySkeleton.hurtAnimationDone = false
    end
end

skeleton.DeadState = function(mySkeleton, ID)
    if mySkeleton.deadAnimationDone == true then
        money.coins = money.coins + mySkeleton.coinValue
        ennemyOnScreen = ennemyOnScreen - 1
        mySkeleton.isFree = true
    end
end

skeleton.Update = function(dt, e, alliesList, crystalX, crystalY)
    --Vérification d'un changement de vie
    skeleton.CheckLifeChange(e)
    if e.state == skeleton.STATES.WALK then
        skeleton.WalkState(dt, e, crystalX, crystalY, alliesList)
    elseif e.state == skeleton.STATES.ATTACK then
        skeleton.AttackState(dt, e, alliesList)
    elseif e.state == skeleton.STATES.HURT then
        skeleton.HurtState(e)
    elseif e.state == skeleton.STATES.DEAD then
        skeleton.DeadState(e, i)
    end
    skeleton.UpdateAnimation(dt, e)
end

skeleton.Draw = function(e)
    if e.state == skeleton.STATES.WALK then
        love.graphics.draw(
            skeleton.animation.WALK.spriteSheet,
            skeleton.animation.WALK.spriteTexture[e.roundFrame],
            e.x,
            e.y,
            0,
            e.direction,
            2,
            skeleton.offsetImage.ox,
            skeleton.offsetImage.oy
        )
    elseif e.state == skeleton.STATES.ATTACK then
        love.graphics.draw(
            skeleton.animation.ATTACK.spriteSheet,
            skeleton.animation.ATTACK.spriteTexture[e.roundFrame],
            e.x,
            e.y,
            0,
            e.direction,
            2,
            skeleton.offsetImage.ox,
            skeleton.offsetImage.oy
        )
    elseif e.state == skeleton.STATES.HURT and e.hurtAnimationDone == false then
        love.graphics.draw(
                skeleton.animation.HURT.spriteSheet,
                skeleton.animation.HURT.spriteTexture[e.roundFrame],
                e.x,
                e.y,
                0,
                e.direction,
                2,
                skeleton.offsetImage.ox,
                skeleton.offsetImage.oy
            )
    elseif e.state == skeleton.STATES.DEAD and e.deadAnimationDone == false then
        love.graphics.draw(
            skeleton.animation.DEAD.spriteSheet,
            skeleton.animation.DEAD.spriteTexture[e.roundFrame],
            e.x,
            e.y,
            0,
            e.direction,
            2,
            skeleton.offsetImage.ox,
            skeleton.offsetImage.oy
        )
    end
end

return skeleton