local ennemy = require("Ennemy")

local wave = {}

wave.Load = function()
    wave.waveNumber = 0
    wave.baseEnnemyCount = 5
    wave.difficultyMultiplier = 1.5
end
--TODO Wave séquencées en plusieurs petites waves, Pourcentage de chances par ennemis
wave.GenerateWave = function()
    wave.waveNumber = wave.waveNumber + 1
    --Nombre d'ennemies de base * (difficulté ^ nombre de wave - 1)
    local ennemyCount = math.floor(wave.baseEnnemyCount * (wave.difficultyMultiplier ^ (wave.waveNumber - 1)))
    --Sélection des ennemis pifomètre style
    for n = 1, ennemyCount do
        local idEnnemy = math.random(1, ennemy.ennemyTypes)
        ennemy.CreateEnnemy(idEnnemy)
    end
end

return wave
