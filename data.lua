local light = table.deepcopy(data.raw['lamp']['small-lamp']['picture_on'])
light.name = 'rgb-lamp-light'
light.type = 'sprite'

if settings.startup['rgb-default-lamps-invisSub'].value then
    local substation = data.raw['electric-pole']['substation']
    substation['pictures']['layers'][1]['height'] = 1
    substation['pictures']['layers'][1]['hr_version']['height'] = 1
end

data:extend{
    light
}
