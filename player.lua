-- player.lua

Player = { }
Player.__index = Player;

function Player:new( )
	local this = {	
		bar = { 
			height = 80,
			width = 20,
			position = {
				x = 0,
				y = 0
			}
		},
		control = {
			keyboard = {
				up = "w",
				down = "s"
			}
		},
		health = 100,
		score = 0,
		color = { 255, 255, 255, 255 }
	}
	setmetatable(this, self)
	return this
end

function Player:getDimensions( )
	return self.bar.width, self.bar.height
end

function Player:setPosition( x, y )
	self.bar.position.x = x;
	self.bar.position.y = y;
end

function Player:getPosition( )
	return self.bar.position.x, self.bar.position.y
end

function Player:setUpKey( up )
	self.control.keyboard.up = up
end

function Player:getUpKey( )
	return self.control.keyboard.up
end

function Player:setDownKey( down )
	self.control.keyboard.down = down
end

function Player:getDownKey( )
	return self.control.keyboard.down
end

function Player:setColor( t )
	self.color = t;
end

function Player:draw( )
	love.graphics.setColor( self.color )
	love.graphics.rectangle( 'fill', self.bar.position.x, self.bar.position.y, self.bar.width, self.bar.height)
end

function Player:update( dt )
	x, y = self:getPosition()

	if love.keyboard.isDown(self.control.keyboard.up) then
		y = y - 200*dt
    end
    
    if love.keyboard.isDown(self.control.keyboard.down) then
    	y = y + 200*dt
    end
    
    -- Check for boundaries
    if y < 0 then
        y = 0
    elseif y + self.bar.height > love.graphics.getHeight() then
        y = love.graphics.getHeight() - self.bar.height
    end

    self:setPosition(x, y)
end