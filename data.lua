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

if settings.startup['rgb-default-lamps-upgradePipes'].value then
    data:extend{
        {
            type = 'custom-input',
            name = 'rgb-default-lamp-toggle-upgrade',
            key_sequence = 'CONTROL + U',
            action = 'spawn-item',
            item_to_spawn = 'rgb-default-lamp-upgplan',
            technology_to_unlock = 'optics',
        },
        {
            type = 'selection-tool',
            name = 'rgb-default-lamp-upgplan',
            icon = '__base__/graphics/icons/shortcut-toolbar/mip/new-upgrade-planner-x32-white.png',
            icon_size = 32,
            flags = {'only-in-cursor', 'hidden', 'spawnable'},
            stack_size = 1,
            stackable = false,
            toggleable = false,
            show_in_library = false,
            subgroup = 'tool',
            selection_mode = {'any-entity', 'avoid-rolling-stock'},
            selection_color = { g = 1, b = 1 },
            selection_cursor_box_type = 'entity',
            entity_filter_mode = 'whitelist',
            entity_type_filters = {'entity-ghost', 'pipe'},
            alt_selection_mode = {'any-entity', 'avoid-rolling-stock'},
            alt_selection_color = { r = 1 },
            alt_selection_cursor_box_type = 'entity',
            alt_entity_filter_mode = 'whitelist',
            alt_entity_type_filters = {'entity-ghost', 'lamp'},
        },
        {
            type = 'shortcut',
            name = 'rgb-default-lamp-upgrade',
            associated_control_input = 'rgb-default-lamp-toggle-upgrade',
            action = 'spawn-item',
            item_to_spawn = 'rgb-default-lamp-upgplan',
            technology_to_unlock = 'optics',
            icon =
            {
                filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-upgrade-planner-x32-white.png",
                priority = "extra-high-no-scale",
                size = 32,
                scale = 0.5,
                mipmap_count = 2,
                flags = {"gui-icon"}
            },
            small_icon =
            {
                filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-upgrade-planner-x24-white.png",
                priority = "extra-high-no-scale",
                size = 24,
                scale = 0.5,
                mipmap_count = 2,
                flags = {"gui-icon"}
            },
            disabled_small_icon =
            {
                filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-upgrade-planner-x24-white.png",
                priority = "extra-high-no-scale",
                size = 24,
                scale = 0.5,
                mipmap_count = 2,
                flags = {"gui-icon"}
            }
        }
    }
end
