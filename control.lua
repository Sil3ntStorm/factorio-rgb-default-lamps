-- Copyright 2021 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

require("utils.utils")

local function updateLight(entry, r, g, b)
    if r <= 0 and g <= 0 and b <= 0 then
        if entry.light then
            rendering.destroy(entry.light)
            global.rgb_default_lamps[entry.lamp.unit_number].light = nil
        end
        if entry.glow then
            rendering.destroy(entry.glow)
            global.rgb_default_lamps[entry.lamp.unit_number].glow = nil
        end
        return
    end
    local color = {math.max(0, math.min(255, r)), math.max(0, math.min(255, g)), math.max(0, math.min(255, b))}
    if entry.light then
        rendering.set_color(entry.light, color)
    else
        entry.light = rendering.draw_light{
            sprite = 'utility/light_small',
            color = color,
            target = entry.lamp,
            surface = entry.lamp.surface,
            scale = 8
        }
    end
    if entry.glow then
        rendering.set_color(entry.glow, color)
    else
        entry.glow = rendering.draw_sprite{
            sprite = 'rgb-lamp-light',
            tint = color,
            render_layer = 'light-effect',
            target = entry.lamp,
            surface = entry.lamp.surface,
            x_scale = 1.1,
            y_scale = 1.1
        }
    end
end

local function processLamp(lamp)
    if not lamp or not lamp.valid then
        return
    end
    if not lamp.is_connected_to_electric_network() then
        updateLight(global.rgb_default_lamps[lamp.unit_number], -1, -1, -1)
        return
    end
    if not lamp.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.lamp) and not lamp.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.lamp) then
        -- Not connected to any circuit wire
        updateLight(global.rgb_default_lamps[lamp.unit_number], -1, -1, -1)
        return
    end
    local r = lamp.get_merged_signal({type='virtual', name='signal-R'}, defines.circuit_connector_id.lamp)
    local g = lamp.get_merged_signal({type='virtual', name='signal-G'}, defines.circuit_connector_id.lamp)
    local b = lamp.get_merged_signal({type='virtual', name='signal-B'}, defines.circuit_connector_id.lamp)

    updateLight(global.rgb_default_lamps[lamp.unit_number], r, g, b)
end

local function initEntity(entity)
    if not (entity and entity.valid) then
        log('initEntity called with an invalid entity')
        return
    end
    table.insert(global.rgb_default_tracked, entity.unit_number)
    local epole = nil
    if settings.startup['rgb-default-lamps-lampsHavePoles'].value then
        epole = entity.surface.create_entity{
            name = 'rgb-default-lamp-tiny-pole',
            position = entity.position,
            force = entity.force
        }
    end
    global.rgb_default_lamps[entity.unit_number] = {lamp = entity, light = nil, glow = nil, pole = epole}
end

local function cleanupEntity(destroyed_unit_number)
    if destroyed_unit_number == nil or global.rgb_default_lamps[destroyed_unit_number] == nil then
        log('cleanupEntity called with invalid / untracked entity')
        return
    end
    if global.rgb_default_lamps[destroyed_unit_number].light then
        rendering.destroy(global.rgb_default_lamps[destroyed_unit_number].light)
    end
    if global.rgb_default_lamps[destroyed_unit_number].glow then
        rendering.destroy(global.rgb_default_lamps[destroyed_unit_number].glow)
    end
    if global.rgb_default_lamps[destroyed_unit_number].pole then
        global.rgb_default_lamps[destroyed_unit_number].pole.destroy()
    end
    global.rgb_default_lamps[destroyed_unit_number] = nil
    ArrayRemove(global.rgb_default_tracked, function(t,i,j)
        return t[i] ~= destroyed_unit_number
    end)
end

local function onEntityCreated(event)
    if (event.created_entity.valid and event.created_entity.name == 'small-lamp') then
        initEntity(event.created_entity)
    end
end

local function onEntityDeleted(event)
    if not (event.entity and event.entity.valid) then
        log('onEntityDeleted called with an invalid entity')
        return
    end

    local destroyed_unit_name = event.entity.name
    local destroyed_unit_number = event.entity.unit_number
    if destroyed_unit_name == 'small-lamp' then
        cleanupEntity(destroyed_unit_number)
    end
end

local function onSettingsChanged(data)
    if data.mod_startup_settings_changed then
        local copied = {}
        for k, v in pairs(global.rgb_default_lamps) do
            copied[k] = v
        end
        for _, lamp in pairs(copied) do
            cleanupEntity(lamp.lamp.unit_number)
            initEntity(lamp.lamp)
        end
    end
end

script.on_init(function()
    if not global.rgb_default_lamps then
        global.rgb_default_lamps = {}
    end
    if not global.rgb_default_tracked then
        global.rgb_default_tracked = {}
    end
    for _, surface in pairs(game.surfaces) do
        lamps = surface.find_entities_filtered({name='small-lamp'})
        for _, lamp in pairs(lamps) do
            table.insert(global.rgb_default_tracked, lamp.unit_number)
            global.rgb_default_lamps[lamp.unit_number] = {lamp = lamp, light = nil, glow = nil, pole = nil}
        end
    end
    log('Tracking ' .. #global.rgb_default_lamps .. ' existing lamps')
end)

script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died, defines.events.script_raised_destroy}, onEntityDeleted)
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, onEntityCreated);
script.on_configuration_changed(onSettingsChanged)

script.on_event(defines.events.on_tick, function(event)
    if event.tick % settings.global['rgb-default-lamps-nthTick'].value > 0 then
        return
    end
    -- this should've already happened / been initialized by migration / on_init...
    -- But the game doesn't seem to run those (or not before on_tick), so we'll do this again here...
    if not global.rgb_default_lamps then
        global.rgb_default_lamps = {}
    end
    if not global.rgb_default_tracked then
        global.rgb_default_tracked = {}
    end
    local lastIt = global.rgb_default_lamps_last or 1
    local target = math.min(#global.rgb_default_tracked, lastIt + settings.global['rgb-default-lamps-perTick'].value)
    for i = lastIt, target, 1 do
        if global.rgb_default_lamps[global.rgb_default_tracked[i]] then
            processLamp(global.rgb_default_lamps[global.rgb_default_tracked[i]].lamp)
        end
    end
    target = target + 1
    if target >= #global.rgb_default_tracked then
        target = 1
    end
    global.rgb_default_lamps_last = target
end
)
