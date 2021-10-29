global.rgb_default_lamps = {}
for _, surface in pairs(game.surfaces) do
    lamps = surface.find_entities_filtered({name='small-lamp'})
    for _, lamp in pairs(lamps) do
        table.insert(global.rgb_default_lamps, lamp)
    end
end
log('0.2.1145 -> Tracking ' .. #global.rgb_default_lamps .. ' lamps')
