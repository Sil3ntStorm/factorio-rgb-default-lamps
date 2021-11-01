local light = table.deepcopy(data.raw["lamp"]["small-lamp"]['picture_on'])
light.name = 'rgb-lamp-light'
light.type = 'sprite'

data:extend{
	light
}
