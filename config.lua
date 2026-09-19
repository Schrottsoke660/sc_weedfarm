Config = {}

Config.Locale = GetConvar('esx:locale', 'en')

Config.Blip = false
Config.Blipumrandung = false
Config.RequiredPolice = 0
Config.Eventname = 'sc_weedfarm'
Config.Prop = 'prop_weed_02'
Config.DropItem = true
Config.RandomItemCount = true

--No Random Items
Config.Item = 'weed'

--Random Items
Config.RandomItems = true
Config.ItemChances = {
	{ itemName = "weed", chancePercent = 50 },
	{ itemName = "canabis", chancePercent = 50 }
}

Config.CircleZones = {
	FarmField = {coords = vector3(163.5598, 1799.3694, 202.3280), name = TranslateCap('blip_farmfield'), color = 25, sprite = 496, radius = 80.0},
}

Config.Heights = {188.0, 189.0, 190.0, 191.0, 192.0, 193.0, 194.0, 195.0, 196.0, 197.0, 198.0, 199.0, 200.0, 201.0, 202.0, 203.0, 204.0, 205.0, 206.0, 207.0, 208.0, 209.0, 210.0, 211.0, 212.0, 213.0, 214.0, 215.0, 216.0, 217.0}
Config.Returner = 193.0