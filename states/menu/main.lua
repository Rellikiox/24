
function load()
	TLbind,control = love.filesystem.load("libs/TLbind.lua")()
	require("libs/TEsound")
	
	play_on_btn = love.graphics.newImage("textures/play_on.png")
	play_off_btn = love.graphics.newImage("textures/play_off.png")
	exit_on_btn = love.graphics.newImage("textures/exit_on.png")
	exit_off_btn = love.graphics.newImage("textures/exit_off.png")
	
	title_font = love.graphics.newFont("fonts/munro_small.ttf", 100)
	love.graphics.setFont(title_font)
	buttons = {
		play = {is_on = false, imgOn = play_on_btn, imgOff = play_off_btn, sound_on = "sounds/blip.wav", sound_click = "sounds/start.wav", x = 400, y = 390, w = 200, h = 100},
		quit = {is_on = false, imgOn = exit_on_btn, imgOff = exit_off_btn, sound_on = "sounds/blip.wav", sound_click = "sounds/start.wav", x = 400, y = 500, w = 200, h = 100}
	}
	
	love.graphics.setBackgroundColor( 95, 186, 221 )
end

function love.draw()
	love.graphics.setColor( 255, 255, 255, 255 )
	
	draw_button(buttons.play)
	draw_button(buttons.quit)
	
	love.graphics.setColor(6, 143, 176)
	love.graphics.printf("GROWTH", 400, 100, 0, "center")
end

function love.update(dt)
	if insideBox(love.mouse.getX(), love.mouse.getY(), buttons.play.x - buttons.play.w / 2, buttons.play.y - buttons.play.h / 2, buttons.play.w, buttons.play.h ) then
		if not buttons.play.is_on then
			TEsound.play(buttons.play.sound_on)
		end
		buttons.play.is_on = true
		buttons.quit.is_on = false
	elseif insideBox(love.mouse.getX(), love.mouse.getY(), buttons.quit.x - buttons.quit.w / 2, buttons.quit.y - buttons.quit.h / 2, buttons.quit.w, buttons.quit.h ) then
		if not buttons.quit.is_on then
			TEsound.play(buttons.quit.sound_on)
		end
		buttons.play.is_on = false
		buttons.quit.is_on = true
	else
		buttons.play.is_on = false
		buttons.quit.is_on = false
	end
end

function love.focus(bool)
end

function love.keypressed( key, unicode )
end

function love.keyreleased( key, unicode )
	if (key == "escape") then
		love.event.quit()
	end
end

function love.mousepressed( x, y, button )
	if ( button == "l" ) then
		if insideBox(x, y, buttons.play.x - buttons.play.w / 2, buttons.play.y - buttons.play.h / 2, buttons.play.w, buttons.play.h ) then
			TEsound.play(buttons.play.sound_click)
			loadState("game")
		elseif insideBox(x, y, buttons.quit.x - buttons.quit.w / 2, buttons.quit.y - buttons.quit.h / 2, buttons.quit.w, buttons.quit.h ) then
			TEsound.play(buttons.quit.sound_click)
			love.event.quit()
		end
	end
end

function love.mousereleased( x, y, button )
end

function love.quit()
end

function draw_button(btn)
	love.graphics.setColor( 255, 255, 255, 255 )
		
	if btn.is_on then
		love.graphics.draw( btn.imgOn, btn.x, btn.y, 0, 1, 1, (btn.w/2), (btn.h/2) )
	else
		love.graphics.draw( btn.imgOff, btn.x, btn.y, 0, 1, 1, (btn.w/2), (btn.h/2) )
	end
end

function insideBox( px, py, x, y, wx, wy )
	if px > x and px < x + wx then
		if py > y and py < y + wy then
			return true
		end
	end
	return false
end