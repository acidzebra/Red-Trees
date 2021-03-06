--Kaeza's Internationalization Library support
	-- Boilerplate to support localized strings if intllib mod is installed.
	local S
	if minetest.get_modpath("intllib") then
		S = intllib.Getter()
	else
		-- If you don't use insertions (@1, @2, etc) you can use this:
		S = function(s) return s end
	end

minetest.register_node("sakuragi:stree", {
	description = S("Cherry Blossom Tree"),
	tiles = {"sakuragi_tree_top.png", "sakuragi_tree_top.png", "sakuragi_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("sakuragi:swood", {
	description = S("Cherry Blossom Wood Planks"),
	tiles = {"sakuragi_wood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=10,wood=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("sakuragi:ssapling", {
	description = S("Cherry Blossom Tree Sapling"),
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"sakuragi_sapling.png"},
	inventory_image = "sakuragi_sapling.png",
	wield_image = "sakuragi_sapling.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=10,attached_node=1,sapling=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("sakuragi:sleaves", {
	description = S("Cherry Blossom Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"sakuragi_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3, leafdecay=3, flammable=10, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"sakuragi:ssapling"},
				rarity = 20,
			},
			{
				items = {"sakuragi:sleaves"},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = sakuragi.after_place_leaves,
})

default.register_leafdecay({
	trunks = {"sakuragi:stree"},
	leaves = {"sakuragi:sleaves"},
	radius = 3,
})

stairs.register_stair_and_slab("swood", "sakuragi:swood",
		{choppy=2,oddly_breakable_by_hand=2,flammable=10,wood=1},
		{"sakuragi_wood.png"},
		S("Cherry Blossom Wood Stair"),
		S("Cherry Blossom Wood Slab"),
		default.node_sound_wood_defaults())
		
doors.register_door("sakuragi:tobira", {
		tiles = {{ name = "sakuragi_door_full.png", backface_culling = true }},
		description = S("Japanese Tobira"),
		inventory_image = "sakuragi_door.png",
		protected = true,
		groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
		recipe = {
			{"default:stick",  "default:paper"},
			{"default:paper",  "default:stick"},
			{"sakuragi:stree", "sakuragi:stree"}
		}
})
default.register_fence("sakuragi:sfence", {
	description = S("Cherry Blossom Wood Fence"),
	texture = "sakuragi_wood.png",
	material = "sakuragi:swood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults()
})
doors.register_fencegate("sakuragi:sfencegate", {
	description = S("Cherry Blossom Wood Fence Gate"),
	texture = "sakuragi_wood.png",
	material = "sakuragi:swood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2}
})
--[[minetest.register_node("sakuragi:cherry", {
	description = "Cherry",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"sakuragi_cherry.png"},
	inventory_image = "sakuragi_cherry.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name = "sakuragi:cherry", param2 = 1})
		end
	end,
})]]
