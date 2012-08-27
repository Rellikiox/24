local ents = require("states/game/entities")
local map = {}

map.img = nil
map.width = 0
map.height = 0

function map:loadMap(filename)
	self.img = love.image.newImageData(filename)
	self.width = self.img:getWidth()
	self.height = self.img:getHeight()
	
	for i = 0, self.width - 1, 1 do
		for j = 0, self.height - 1, 1 do
			local r, g, b, a = self.img:getPixel( i, j )
			local name = self:processPixel( i, j, r, g, b, a )
			if ( name == "enemy" ) then			-- add enemy
				ents:add("enemy", i * 10, j * 10, 5 + math.random(-3, 6))
			elseif ( name == "wall" ) then		-- add wall
				ents:add("wall", i * 10, j * 10 )
			elseif ( name == "player" ) then	-- add player
				ents:add("player", i * 10, j * 10 )
			elseif ( name == "damage" ) then	-- damage powerup
				ents:add( "powerup", i * 10, j * 10, "damage" )
			elseif ( name == "life" ) then		-- life powerup
				ents:add( "powerup", i * 10, j * 10, "life" )
			elseif ( name == "speed" ) then		-- speed powerup
				ents:add( "powerup", i * 10, j * 10, "speed" )
			elseif ( name == "end" ) then		-- spawner
				ents:add( "end", i * 10, j * 10 )
			end		
		end
	end
end

function map:processPixel( x, y, r, g, b, a )
	if ( r == 0 and g == 0 and b == 0 and a == 255 ) then			-- add enemy
		return "enemy"
	elseif ( r == 52 and g == 52 and b == 52 and a == 255) then		-- add wall
		return "wall"
	elseif ( r == 100 and g == 100 and b == 100 and a == 255 ) then	-- add player
		return "player"
	elseif ( r == 255 and g == 0   and b == 0 ) then				-- damage powerup
		return "damage" 
	elseif ( r == 0   and g == 255 and b == 0 ) then				-- life powerup
		return "life" 
	elseif ( r == 0   and g == 0   and b == 255 ) then				-- speed powerup
		return "speed" 
	elseif ( r == 255   and g == 0 and b == 255 ) then				-- spawner
		return "end" 
	end
end

return map