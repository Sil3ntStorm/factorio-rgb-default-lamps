if not global.rgb_default_tracked then
    global.rgb_default_tracked = {}
end
if global.rgb_default_lamps then
    local tmp = {}
    for _, lamp in pairs(global.rgb_default_lamps) do
        table.insert(tmp, {lamp = lamp, light = nil, glow = nil})
        table.insert(global.rgb_default_tracked, lamp.unit_number)
    end
    global.rgb_default_lamps = tmp
end
