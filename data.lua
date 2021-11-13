local light = table.deepcopy(data.raw['lamp']['small-lamp']['picture_on'])
light.name = 'rgb-lamp-light'
light.type = 'sprite'
data:extend{
    light
}

if settings.startup['rgb-default-lamps-invisSub'].value then
    local substation = data.raw['electric-pole']['substation']
    substation['pictures']['layers'][1]['height'] = 1
    substation['pictures']['layers'][1]['hr_version']['height'] = 1
end

local pole = table.deepcopy(data.raw['electric-pole']['small-electric-pole'])
pole.flags = { 'not-on-map',
               'not-blueprintable',
               'not-deconstructable',
               'hidden',
               'hide-alt-info',
               'not-flammable',
               'not-repairable',
               'not-upgradable',
               'no-copy-paste',
               'not-rotatable',
               'not-in-kill-statistics',
               'not-selectable-in-game'
             }
pole.minable = nil
pole.operable = false
pole.maximum_wire_distance = 3.5
pole.supply_area_distance = 0.5
pole.selection_box = nil
pole.draw_copper_wires = false
pole.draw_circuit_wires = false
pole.collision_box = nil
pole.light = nil
pole.fast_replaceable_group = nil
pole.name = 'rgb-default-lamp-tiny-pole'
pole.pictures.layers[1].filename = '__rgb-default-lamps__/graphics/empty.png'
pole.pictures.layers[1].direction_count = 1
pole.pictures.layers[1].width = 32
pole.pictures.layers[1].height = 32
pole.pictures.layers[1].hr_version.filename = '__rgb-default-lamps__/graphics/empty.png'
pole.pictures.layers[1].hr_version.direction_count = 1
pole.pictures.layers[1].hr_version.width = 32
pole.pictures.layers[1].hr_version.height = 32
pole.pictures.layers[2] = nil
pole.connection_points = {
    {
        wire = {
            copper = {0.45, 0.43} -- {0, -2.578125}
        },
        shadow = {
            copper = {0.68, 0.71} -- {3.078125, 0.078125}
        }
    }
}
data:extend{pole}
