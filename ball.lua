-- ball.lua

Ball = { }
Ball.__index = Ball;

function Ball:new( )
	local this = { 
		x = 0,
		y = 0,
		speed = {
			x = 100,
			y = 100
		},
		size = 16, -- pixels
		color = { 255, 255, 255, 255 } -- r, g, b, a
	}
	setmetatable(this, self)
	return this
end

function Ball:setPosition( x, y )
	self.x = x
	self.y = y
end

function Ball:getPosition( )
	return self.x, self.y
end

function Ball:setSpeed( x, y )
	self.speed.x = x
	self.speed.y = y
end

function Ball:getSpeed( )
	return self.speed.x, self.speed.y
end

function Ball:setColor( t )
	self.color = t;
end

function Ball:draw( )
	love.graphics.setColor( self.color )
	love.graphics.rectangle( 'fill', self.x, self.y, self.size, self.size) 
end

function Ball:update( dt )
	self:setPosition( self.x + self.speed.x*dt, self.y + self.speed.y*dt )
end

function Ball:checkPlayerCollision( player )
	speed_x, speed_y = self:getSpeed()

	if self.x + self.size > player.bar.position.x and self.x < player.bar.position.x + player.bar.width and
	    self.y + self.size > player.bar.position.y and self.y < player.bar.position.y + player.bar.height then
	    speed_x = -speed_x
	end

	self:setSpeed(speed_x, speed_y)
end