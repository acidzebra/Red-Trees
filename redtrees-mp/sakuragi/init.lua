--Red Trees (AKA Fiery Trees)
--Put together by Glory!.
--Uses code modified from Default and Tiny Trees (bas080)
sakuragi = {}
----------------------------------
dofile(minetest.get_modpath("sakuragi").."/nodes.lua")
dofile(minetest.get_modpath("sakuragi").."/crafting.lua")
--BEGIN TREE GROWING PROCESS!
local random = math.random

local function can_grow(pos)
	local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	local is_soil = minetest.get_item_group(name_under, "soil")
	if is_soil == 0 then
		return false
	end
	return true
end

--SAPLINGS!!!
minetest.register_abm({
	nodenames = {"sakuragi:ssapling"},
	interval = 10,
	chance = 50,
	action = function(pos, node)
		if not can_grow(pos) then
			return
		end

		--minetest.log("action", "A cherry blossom sapling grows into a cherry tree at "..
		--		minetest.pos_to_string(pos))
		sakuragi.grow_tree(pos, random(1, 4) == 1)
	end
})

--DEFAULT CODE!!!
local function add_trunk_and_leaves(data, a, pos, tree_cid, leaves_cid,
		height, size, iters)
	local x, y, z = pos.x, pos.y, pos.z
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_cherry = minetest.get_content_id("defaut:apple")

	--TRUNK!!! EXCITEMENT!!!
	for y_dist = 0, height - 1 do
		local vi = a:index(x, y + y_dist, z)
		local node_id = data[vi]
		if y_dist == 0 or node_id == c_air or node_id == c_ignore
		or node_id == leaves_cid then
			data[vi] = tree_cid
		end
	end

	--CodeSins: Overhype over leaves.
	for z_dist = -1, 1 do
	for y_dist = -size, 1 do
		local vi = a:index(x - 1, y + height + y_dist, z + z_dist)
		for x_dist = -1, 1 do
			if data[vi] == c_air or data[vi] == c_ignore then
				data[vi] = leaves_cid
			end
			vi = vi + 1
		end
	end
	end

	--Random 2^3 leaf clusters
	for i = 1, iters do
		local clust_x = x + random(-size, size - 1)
		local clust_y = y + height + random(-size, 0)
		local clust_z = z + random(-size, size - 1)

		for xi = 0, 1 do
		for yi = 0, 1 do
		for zi = 0, 1 do
			local vi = a:index(clust_x + xi, clust_y + yi, clust_z + zi)
			if data[vi] == c_air or data[vi] == c_ignore then
					if random(1, 64) == 1 then data[vi] = c_cherry end
			end
		end
		end
		end
	end
end

--MAKE TREE!!
sakuragi.grow_tree = function(pos)
	if bad then
		error("Deprecated use of forked default.grow_tree")
	end

	local x, y, z = pos.x, pos.y, pos.z
	local height = random(4, 5)
	local c_tree = minetest.get_content_id("sakuragi:stree")
	local c_leaves = minetest.get_content_id("sakuragi:sleaves")

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = pos.x - 4, y = pos.y, z = pos.z - 4},
		{x = pos.x + 4, y = pos.y + height + 1, z = pos.z + 4}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	add_trunk_and_leaves(data, a, pos, c_tree, c_leaves, height, 2, 8,true)

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end

--SUDO PLACE TREE!!!
biome_lib:register_generate_plant({
    surface = "default:dirt_with_grass",
    max_count = 30,
    avoid_nodes = {"group:tree", "default:sand"},
    avoid_radius = 10,
    rarity = 75,
    seed_diff = 666,
    min_elevation = 12,
    max_elevation = 134,
    plantlife_limit = -0.5,
    check_air = false,
    humidity_max = -2,
    humidity_min = 2,
    temp_max = -0.8,
    temp_min = 0.8,
  },
  'sakuragi.grow_tree'
)
