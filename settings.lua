-- Copyright 2021 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

data:extend({
    {
        name = 'rgb-default-lamps-perTick',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 50,
        minimum_value = 1,
        maximum_value = 2000
    },
    {
        name = 'rgb-default-lamps-nthTick',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 15,
        minimum_value = 5,
        maximum_value = 900
    },
})
