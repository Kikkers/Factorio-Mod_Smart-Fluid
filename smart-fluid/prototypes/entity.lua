data:extend({

  {
    type = "inserter",
    name = "smart-pump-actuator",
	icon = "__smart-fluid__/graphics/smart-pump-actuator-icon.png",
	flags = {"placeable-neutral"},
	minable = {hardness = 0.2, mining_time = 0.5, result = "smart-pump"},
    max_health = 1,
    --collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    pickup_position = {0, -0.4},
    insert_position = {0, 0.4},
    energy_per_movement = 200,
    energy_per_rotation = 200,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.01 / 2.5,
      drain = "0.1kW",
    },
    extension_speed = 0.7,
    programmable = true,
    rotation_speed = 0.35,
    hand_base_picture = { filename = "__smart-fluid__/graphics/smart-pump-actuator.png", width = 0, height = 0 },
    hand_closed_picture = { filename = "__smart-fluid__/graphics/smart-pump-actuator.png", width = 0, height = 0 },
    hand_open_picture = { filename = "__smart-fluid__/graphics/smart-pump-actuator.png", width = 0, height = 0 },
    hand_base_shadow = { filename = "__smart-fluid__/graphics/smart-pump-actuator.png", width = 0, height = 0 },
    hand_closed_shadow = { filename = "__smart-fluid__/graphics/smart-pump-actuator.png", width = 0, height = 0 },
    hand_open_shadow = { filename = "__smart-fluid__/graphics/smart-pump-actuator.png", width = 0, height = 0 },
    platform_picture =
    {
      priority = "extra-high",
      width = 32,
      height = 39,
      sheet = "__smart-fluid__/graphics/smart-pump-actuator.png",
      shift = {0, 0.2},
    },
  },

  
  
  {
    type = "pump",
    name = "smart-pump-pipe",
    icon = "__smart-fluid__/graphics/smart-pump-icon.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
	minable = {hardness = 0.2, mining_time = 0.5, result = "smart-pump"},
    fast_replaceable_group = "pipe",
    max_health = 60,
    collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
    selection_box = {{-0.25, -0.25}, {0.25, 0.25}},
    fluid_box =
    {
      base_area = 1,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        { position = {0, -1}, type="output" },
        { position = {0, 1}, type="input" },
      },
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
    },
    energy_usage = "30kW",
    pumping_speed = 0.25,
    animations =
    {
      north =
      {
        filename = "__smart-fluid__/graphics/smart-pump-up.png",
        frame_width = 46,
        frame_height = 56,
        frame_count = 8,
        shift = {0.09375, 0.03125},
        animation_speed = 0.5
      },
      east =
      {
        filename = "__smart-fluid__/graphics/smart-pump-right.png",
        frame_width = 51,
        frame_height = 56,
        frame_count = 8,
        shift = {0.265625, -0.21875},
        animation_speed = 0.5
      },
      south =
      {
        filename = "__smart-fluid__/graphics/smart-pump-down.png",
        frame_width = 61,
        frame_height = 58,
        frame_count = 8,
        shift = {0.421875, -0.125},
        animation_speed = 0.5
      },
      west =
      {
        filename = "__smart-fluid__/graphics/smart-pump-left.png",
        frame_width = 56,
        frame_height = 52,
        frame_count = 8,
        shift = {0.3125, 0.0625},
        animation_speed = 0.5
      }
    }
  },



  {
    type = "container",
    name = "smart-pump-chest",
    max_health = 10000,
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    --selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    inventory_size = 1,
    picture =
    {
      filename = "__smart-fluid__/graphics/smart-pump-actuator.png",
      priority = "extra-high",
      width = 0,
      height = 0,
    }
  },

{
	type = "pipe",
    name = "smart-tank-pipe",
    max_health = 60,
    collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
	corpse = "small-remnants",
	resistances = 
	{
		{
			type = "fire",
			percent = 90
		}
	},
    fluid_box =
    {
      base_area = 1,
      pipe_connections =
      {
        { position = {0, -1} },
        { position = {1, 0} },
        { position = {0, 1} },
        { position = {-1, 0} }
      },
    },
    pictures = pipepictures(),
    horizontal_window_bounding_box = {{-0.25, -0.25}, {0.25, 0.15625}},
    vertical_window_bounding_box = {{-0.28125, -0.40625}, {0.03125, 0.125}}
}, 
{
    type = "smart-container",
    name = "smart-tank",
	icon = "__smart-fluid__/graphics/smart-tank-icon.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
	fast_replaceable_group = "pipe",
	minable = { hardness = 0.2, mining_time = 0.5, result = "smart-tank" },
	max_health = 1,
	resistances = 
	{
		{
			type = "fire",
			percent = 90
		}
	},
	--collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	inventory_size = 2,
	picture =
	{
		filename = "__smart-fluid__/graphics/smart-tank.png",
		priority = "extra-high",
		width = 31,
		height = 31,
		shift = {0.19, -0.3}
	},
	connection_point =
	{
		shadow =
		{
			red = {0.57, -0.25},
			green = {0.57, -0.25}
		},
		wire =
		{
			red = {0.17, -0.75},
			green = {0.17, -0.75}
		}
	}
},
})