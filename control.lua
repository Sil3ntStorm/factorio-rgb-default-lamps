-- Copyright 2021 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

local function updateLightEntity(surface, position, r, g, b)
    l = surface.find_entities_filtered({name='rgb-lamp-light', area={{position.x - 0.1, position.y - 0.1}, {position.x + 0.1, position.y + 0.1}}})
    for _, fml in pairs(l) do
        if r == -1 and g == -1 and b == -1 then
            fml.destroy()
        else
            fml.color = {math.max(0, r), math.max(0, g), math.max(0, b), 255}
        end
        return
    end
    if r == -1 and g == -1 and b == -1 then
        return
    end
    light = surface.create_entity{name='rgb-lamp-light', force='neutral', position=position}
    light.color = {math.max(0, r), math.max(0, g), math.max(0, b), 255}
end

local function processLamp(lamp)
    if not lamp.is_connected_to_electric_network() then
        return
    end
    signals = lamp.get_merged_signals(defines.circuit_connector_id.lamp)
    if not signals then
        updateLightEntity(lamp.surface, lamp.position, -1, -1, -1)
        return
    end
    local disabled = false
    if lamp.get_control_behavior() then
        disabled = lamp.get_control_behavior().disabled
    end
    local r = -1
    local g = -1
    local b = -1
    for _, signal in pairs(signals) do
        if (signal.signal.type == 'virtual') then
            if (signal.signal.name == 'signal-R') then
                r = math.max(0, math.min(255, signal.count))
            end
            if (signal.signal.name == 'signal-G') then
                g = math.max(0, math.min(255, signal.count))
            end
            if (signal.signal.name == 'signal-B') then
                b = math.max(0, math.min(255, signal.count))
            end
        end
    end
    updateLightEntity(lamp.surface, lamp.position, r, g, b)
end

local function onEntityDeleted(event)
    if not (event.entity and event.entity.valid) then
        log('onEntityDeleted called with an invalid entity')
        return
    end
    if event.entity.name == 'small-lamp' then
        updateLightEntity(event.entity.surface, event.entity.position, -1, -1, -1)
    end
end


script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, onEntityDeleted)

script.on_event(defines.events.on_tick, function(event)
    if (event.tick % 30 > 0) then
        return
    end

    for _, surface in pairs(game.surfaces) do
        lamps = surface.find_entities_filtered({name='small-lamp'})
        for _, lamp in pairs(lamps) do
            processLamp(lamp)
        end -- lamps on surface
    end -- surface loop
end
)
