ents = {}

ents.ents = {}
ents.updateList = {}
ents.drawingList = {}
ents.objpath = "states/game/entities/"

local register = {}
local id = 0

function ents:load()
end

function ents:register(name)
	if not register[name] then
		register[name] = love.filesystem.load( ents.objpath .. name .. ".lua" )
	end
end

function ents:inherit(name)
	return love.filesystem.load( ents.objpath .. name .. ".lua" )()
end

function ents:add(name, ...)
	if register[name] then
		id = id + 1
		local ent = register[name]()
		ent:load(unpack(arg))
		ent.type = name
		ent.id = id
		if (ent.draw) then
			table.insert(self.drawingList, ent)
			table.sort(self.drawingList, function (a,b) return a:getZ() > b:getZ() end)
		end
		if ent.update then
			self.updateList[id] = ent
		end
		self.ents[id] = ent
		return self.ents[id]
	else
		print("Error: Entity " .. name .. " does not exist! Snap!")
		return false;
	end
end

function ents:destroy(id)
	if self.updateList[id] then
		if self.updateList[id].die then
			self.updateList[id]:die()
		end
		for i=#self.drawingList, 1, -1 do
			if self.drawingList[i].id == id then 
				table.remove(self.drawingList, i) 
			end 
		end
		
		self.updateList[id] = nil
	end
end

function ents:update(dt)
	for i, ent in pairs(self.updateList) do
		if ent.update then
			if ent.alive then
				ent:update(dt)
			else
				self:destroy(ent.id)
			end
		end
	end
end

function ents:draw()
	for i, ent in ipairs(self.drawingList) do
		if ent.alive then
			ent:draw()
		end
	end
end

function ents:getEntity( id )
	if (id <= #self.updateList) then
		return self.updateList[id]
	end
	return nil
end

function ents:getEntities( name )
	name_ents = {}
	for i, ent in pairs(self.updateList) do
		if ent.type == name then
			table.insert(name_ents, ent)
		end
	end
	return name_ents
end

function ents:reset() 
	for i, ent in pairs(self.ents) do
		ents:destroy(ent.id)
	end
	for k in pairs (self.ents) do
		self.ents[k] = nil
	end
	for k in pairs (self.updateList) do
		self.updateList[k] = nil
	end
	for k in pairs (self.drawingList) do
		self.drawingList[k] = nil
	end
end

return ents