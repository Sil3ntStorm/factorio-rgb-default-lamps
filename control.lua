-- Copyright 2021 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

local function updateLightEntity(surface, position, r, g, b)
    l = surface.find_entities_filtered({name='rgb-lamp-light', area={{position.x - 0.1, position.y - 0.1}, {position.x + 0.1, position.y + 0.1}}})
    for _, fml in pairs(l) do
        if r <= 0 and g <= 0 and b <= 0 then
            fml.destroy()
        else
            fml.color = {math.max(0, math.min(255, r)), math.max(0, math.min(255, g)), math.max(0, math.min(255, b)), 255}
        end
        return
    end
    if r <= 0 and g <= 0 and b <= 0 then
        return
    end
    light = surface.create_entity{name='rgb-lamp-light', force='neutral', position=position}
    light.color = {math.max(0, math.min(255, r)), math.max(0, math.min(255, g)), math.max(0, math.min(255, b)), 255}
end

local function processLamp(lamp)
    if not lamp.is_connected_to_electric_network() then
        updateLightEntity(lamp.surface, lamp.position, -1, -1, -1)
        return
    end
    if not lamp.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.lamp) and not lamp.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.lamp) then
        -- Not connected to any circuit wire
        updateLightEntity(lamp.surface, lamp.position, -1, -1, -1)
        return
    end
    local r = lamp.get_merged_signal({type='virtual', name='signal-R'}, defines.circuit_connector_id.lamp)
    local g = lamp.get_merged_signal({type='virtual', name='signal-G'}, defines.circuit_connector_id.lamp)
    local b = lamp.get_merged_signal({type='virtual', name='signal-B'}, defines.circuit_connector_id.lamp)

    updateLightEntity(lamp.surface, lamp.position, r, g, b)
end

local function onEntityCreated(event)
    if (event.created_entity.valid and event.created_entity.name == 'small-lamp') then
        table.insert(global.rgb_default_lamps, event.created_entity);
    end
end

local function onEntityDeleted(event)
    if not (event.entity and event.entity.valid) then
        log('onEntityDeleted called with an invalid entity')
        return
    end

    local destroyed_unit_name = event.entity.name
    local destroyed_unit_number = event.entity.unit_number
    local destroyed_unit_surface = event.entity.surface
    local destroyed_unit_position = event.entity.position
    if destroyed_unit_name == 'small-lamp' then
        updateLightEntity(destroyed_unit_surface, destroyed_unit_position, -1, -1, -1)
        for i = #global.rgb_default_lamps, 1, -1 do
            if (global.rgb_default_lamps[i].unit_number == destroyed_unit_number) then
                table.remove(global.rgb_default_lamps, i)
            end
        end
    end
end

script.on_init(function()
    for _, surface in pairs(game.surfaces) do
        lamps = surface.find_entities_filtered({name='small-lamp'})
        for _, lamp in pairs(lamps) do
            table.insert(global.rgb_default_lamps, lamp)
        end
    end
    log('Tracking ' .. #global.rgb_default_lamps .. ' lamps')
end
)

script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, onEntityDeleted)
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, onEntityCreated);

script.on_event(defines.events.on_tick, function(event)
    if event.tick % settings.global['rgb-default-lamps-nthTick'].value > 0 then
        return
    end
    local lastIt = global.rgb_default_lamps_last or 1
    local target = math.min(#global.rgb_default_lamps, lastIt + settings.global['rgb-default-lamps-perTick'].value)

    for i = lastIt, target, 1 do
        processLamp(global.rgb_default_lamps[i])
    end
    target = target + 1
    if target >= #global.rgb_default_lamps then
        target = 1
    end
    global.rgb_default_lamps_last = target
end
)
