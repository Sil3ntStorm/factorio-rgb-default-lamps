log('Migration for 0.6.1145, resetting tracking and search all lamps')
if global.rgb_default_lamps then
    for i,v in pairs(global.rgb_default_lamps) do
        if v.glow then
            render.destroy(v.glow)
        end
        if v.light then
            render.destroy(v.light)
        end
    end
end
global.rgb_default_lamps = {}
global.rgb_default_tracked = {}
for _, surface in pairs(game.surfaces) do
    lamps = surface.find_entities_filtered({name='small-lamp'})
    for _, lamp in pairs(lamps) do
        table.insert(global.rgb_default_tracked, lamp.unit_number)
        global.rgb_default_lamps[lamp.unit_number] = {lamp = lamp, light = nil, glow = nil}
    end
end
log('Tracking ' .. #global.rgb_default_tracked .. ' existing lamps')
