local boss = {
    animation = {
        P1Idle = {
            spriteTexture = {},
            maxFrame = 6
        },
        P1Attack = {
            spriteTexture = {},
            maxFrame = 19
        },
        P1Transform = {
            spriteTexture = {},
            maxFrame = 11
        },
        P2Idle = {
            spriteTexture = {},
            maxFrame = 6
        },
        P2Attack1 = {
            spriteTexture = {},
            maxFrame = 11
        },
        P2Attack2 = {
            spriteTexture = {},
            maxFrame = 13
        },
        P2Charge = {
            spriteTexture = {},
            maxFrame = 5
        },
        P2Teleportation = {
            spriteTexture = {},
            maxFrame = 16
        },
        P2Death = {
            spriteTexture = {},
            maxFrame = 10
        }
    },
    STATES = {
        PHASE1 = "Human",
        P1Idle = "Phase 1 Idle",
        P1Teleportation = "Phase 1 Teleportation",
        P1Attack = "Phase 1 Attack", -- Enchainement Attack 1 et 2 "Combo"
        P1Transform = "Transform to demon",
        PHASE2 = "Demon",
        P2Idle = " Phase 2 Idle",
        P2Attack1 = "Demon attack1", --Sprite attack 1
        P2Attack2 = "Demon attack2", --Sprite attack 3
        P2Charge = "Demon Charge",
        P2Teleportation = "Demon teleportation",
        P2Death = "Demon death"
    }
}
--Chargement des images
boss.LoadImages = function()
    --Phase 1
    --Idle
    boss.animation.P1Idle.spriteTexture[0] = nil
    for i = 1, boss.animation.P1Idle.maxFrame do
        boss.animation.P1Idle.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase1/Idle/Zodd_Idle_" .. i .. ".png")
    end
    --Attack 1
    boss.animation.P1Attack.spriteTexture[0] = nil
    for i = 1, boss.animation.P1Attack.maxFrame do
        boss.animation.P1Attack.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase1/Attack/Zodd_Attack1_" .. i .. ".png")
    end
    --Transform to phase 2
    boss.animation.P1Transform.spriteTexture[0] = nil
    for i = 1, boss.animation.P1Transform.maxFrame do
        boss.animation.P1Transform.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase1/Transform/Zodd_Transform_" .. i .. ".png")
    end
    -- Phase 2
    --Idle
    boss.animation.P2Idle.spriteTexture[0] = nil
    for i = 1, boss.animation.P2Idle.maxFrame do
        boss.animation.P2Idle.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase2/Idle/Zodd_Transformed_Idle_" .. i .. ".png")
    end
    -- Attack 1
    boss.animation.P2Attack1.spriteTexture[0] = nil
    for i = 1, boss.animation.P2Attack1.maxFrame do
        boss.animation.P2Attack1.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase2/Attack1/Zodd_Transformed_Attack1_" .. i .. ".png")
    end
    -- Attack 2
    boss.animation.P2Attack2.spriteTexture[0] = nil
    for i = 1, boss.animation.P2Attack2.maxFrame do
        boss.animation.P2Attack2.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase2/Attack2/Zodd_Transformed_Attack3_" .. i .. ".png")
    end
    --Charge
    boss.animation.P2Charge.spriteTexture[0] = nil
    for i = 1, boss.animation.P2Charge.maxFrame do
        boss.animation.P2Charge.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase2/Charge/Zodd_Transformed_Charge_" .. i .. ".png")
    end
    --Teleportation
    boss.animation.P2Teleportation.spriteTexture[0] = nil
    for i = 1, boss.animation.P2Teleportation.maxFrame do
        boss.animation.P2Teleportation.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase2/Teleportation/Zodd_Transformed_Attack2_" .. i .. ".png")
    end
    --Death
    boss.animation.P2Death.spriteTexture[0] = nil
    for i = 1, boss.animation.P2Death.maxFrame do
        boss.animation.P2Death.spriteTexture[i] =
            love.graphics.newImage("Images/Boss/Phase2/Death/Zodd_Transformed_Death_" .. i .. ".png")
    end
end
--MAJ des animations
boss.UpdateAnimation = function(dt)
end

--Creation du boss
boss.Create = function(spawns)
    local randomSpawnArea = love.math.random(1, 2)
    myBoss = {
        type = "Boss",
        x = spawns[randomSpawnArea].x,
        y = spawns[randomSpawnArea].y,
        direction = spawns[randomSpawnArea].direction,
        ennemyDistanceList = {},
        idleTime = 2,
        idleTimer = 2,
        frame = 1,
        roundFrame = 1,
        maxAnimationFrame = 1,
        lifeP1 = 25,
        lifeP2 = 75,
        attackCrystalPos,
        bestCible,
        bestCibleID,
        isAttackingCrystal = false,
        isAttacking = false,
        isCharged = false,
        deadAnimationDone = false,
        hurtAnimationDone = false,
        state = boss.STATES.P1Idle,
        previousState = boss.STATES.P1Idle,
        phase = boss.STATES.PHASE1
    }
    return myBoss
end

--State IDLE Phase 1
boss.P1IdleState = function(dt, myBoss, alliesList)
    myBoss.phase = boss.STATES.PHASE1
    --Temps IDLE minimum
    myBoss.idleTimer = myBoss.idleTimer - dt

    if myBoss.idleTimer <= 0 then
        myBoss.ennemyDistanceList = {}
        --On cherche les alliés les plus loins
        for j = 1, #alliesList do
            e = alliesList[j]
            myBoss.ennemyDistanceList[j] = math.dist(myBoss.x, myBoss.y, e.x, e.y)
        end
        myBoss.bestCible, myBoss.id = FindFarthestEnnemy(myBoss.ennemyDistanceList)

        if myBoss.bestCible ~= nill then
            myBoss.isAttackingCrystal = false
            myBoss.state = boss.STATES.P1Teleportation
        else
            --Téléportation au Crystal
            myBoss.isAttackingCrystal = true
            myBoss.state = boss.STATES.P1Teleportation
        end
        myBoss.idleTimer = myBoss.idleTime
    end
end

--State Teleportation Phase 1
local right = 1
local left = 2
boss.P1TeleportationState = function(myBoss)
    --Teleportation Animation + Orientation
    if myBoss.isAttackingCrystal then
        --A droite ou à gauche du crystal
        myBoss.attackCrystalPos = love.math.random(right, left)
    else
    end
end

--Chargement du boss
boss.Load = function()
    boss.LoadImages()
end

--Update du boss
boss.Update = function(dt, myBoss, alliesList)
    if myBoss.state == boss.STATES.P1Idle then
        boss.P1IdleState(dt, myBoss, alliesList)
    elseif myBoss.state == boss.STATES.P1Teleportation then
    elseif myBoss.state == boss.STATES.P1Attack then
    elseif myBoss.state == boss.STATES.P1Transform then
    elseif myBoss.state == boss.STATES.P2Idle then
        myBoss.phase = boss.STATES.PHASE2
    elseif myBoss.state == boss.STATES.P2Attack1 then
    elseif myBoss.state == boss.STATES.P2Attack2 then
    elseif myBoss.state == boss.STATES.P2Charge then
    elseif myBoss.state == boss.STATES.P2Teleportation then
    elseif myBoss.state == boss.STATES.P2Death then
    end
end

--Dessin du boss
boss.Draw = function(myBoss)
    love.graphics.draw(
        orc.animation.WALK.spriteTexture[myBoss.roundFrame],
        e.x,
        e.y,
        0,
        e.direction,
        2,
        orc.offsetImage.ox,
        orc.offsetImage.oy
    )
end

return boss
