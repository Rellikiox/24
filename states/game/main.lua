
local camera = require ("libs/camera")
local HC = require("libs/HardonCollider")
local map = require ("states/game/map")
local WIDTH = 800
local HEIGHT = 600
local zoom = { }
zoom.value = 1
zoom.min_val = 0.4
zoom.max_val = 2
zoom.tick_val = 0.1

fps = 9001
last_update = love.timer.getMicroTime()
zoom.tickDown = function () 
		zoom.value = math.min(zoom.value + zoom.tick_val, zoom.max_val)
		--camera:setScale(zoom.value, zoom.value)
	end
zoom.tickUp = function () 
		zoom.value = math.max(zoom.value - zoom.tick_val, zoom.min_val) 
		--camera:setScale(zoom.value, zoom.value)
	end

last_update = love.timer.getMicroTime()
prev_fram = 0
fps = 9001
player = nil

restart_timer = 0
credits_time = 5

levels = {
	[1] = "maps/1.png",
	[2] = "maps/2.png",
	[3] = "maps/3.png",
	[4] = "maps/4.png",
	[5] = "maps/5.png"
}

local current_level = 1

function load()

	love.graphics.setBackgroundColor(200,200,200)
	TLbind,control = love.filesystem.load("libs/TLbind.lua")()
	require("libs/TEsound")
	require("states/game/entities")
	
	Collider = HC(10, collision)
	
	caption_font = love.graphics.newFont("fonts/munro_small.ttf", 20)
	
	ents:register("player")
	ents:register("wave")
	ents:register("enemy")
	ents:register("wall")
	ents:register("bullet")
	ents:register("powerup")
	ents:register("text")
	ents:register("ray")
	ents:register("end")
	
	map:loadMap(levels[1])
	player = ents:getEntities("player")[1]
	
	cad1 = "This is you\nUse WASD to move around"
	cad2 = "This is an enemy\nAim and shoot with the mouse"
	cad3 = "These are powerups. You can only pick up one\nYour color reflects your current powers"
	cad4 = "Enemies may drop aditional powerups"
	cad5 = "This is the goal\nTouch it to finish the level"
	black = {52,52,52}
	
	ents:add("text", 220, 20, black, cad1, "normal", 3600)
	ents:add("text", 220, 90, black, cad2, "normal", 3600)
	ents:add("text", 220, 160, black, cad3, "normal", 3600)
	ents:add("text", 220, 300, black, cad4, "normal", 3600)
	ents:add("text", 220, 400, black, cad5, "normal", 3600)
	
end

function restartLevel()
	TEsound.play("sounds/start.wav")
	Collider:clear()
	ents:reset()
	camera:reset()
	map:loadMap(levels[current_level])
	player = ents:getEntities("player")[1]
end

function loadNextLevel()
	TEsound.play("sounds/start.wav")
	Collider:clear()
	ents:reset()
	camera:reset()
	
	current_level = current_level + 1
	if current_level == 6 then
		restart_timer = love.timer.getMicroTime()
	else
		map:loadMap(levels[current_level])
		player = ents:getEntities("player")[1]
	end
end

function love.draw()
	camera:set()
	
	ents:draw()
	
	if current_level == 6 then
		love.graphics.print("Where there is age there is evolution,", -120, -100)
		love.graphics.print("where there is life there is growth", -108, -70)
		love.graphics.print("The End", 0, 20)
	else
		love.graphics.setColor(52, 52, 52)
		love.graphics.print("Level " .. current_level .. " (press 'r' to restart the level)", 0, -20)
	end
	camera:unset()
	
end

function love.update(dt)

	if current_level == 6 and love.timer.getMicroTime() - restart_timer > credits_time then
		love.event.quit()
	end

	if (love.timer.getMicroTime() - last_update > 1) then
		fps = math.floor(1 / love.timer.getDelta())
		last_update = love.timer.getMicroTime()
	end
	ents:update(dt)
	Collider:update(dt)
	
	TLbind:update()
	
	-- Update camera position
	if player then
		local x, y = player.shape:center()
		camera:setPosition(x - 400, y - 300)
	else
		restartLevel()
	end		
	
	if control.tap.exit then
		love.event.quit()
	elseif control.tap.reload then
		restartLevel()
	end
end

-- bump.lua

function collision(dt, obj1, obj2, dx, dy)
	obj1.parent:collision(obj2,  dx,  dy)
	obj2.parent:collision(obj1, -dx, -dy)
end

-- more love callbacks

function love.focus(bool)
end

function love.keypressed( key, unicode )
end

function love.keyreleased( key, unicode )
end

function love.mousepressed( x, y, button )
end

function love.mousereleased( x, y, button )
end

function love.quit()
end
