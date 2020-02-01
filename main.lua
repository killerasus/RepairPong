-- main.lua
require "ball"
require "player"

-- State machine
State = 0 
-- 0 -- Menu
-- 1 -- Game
-- 2 -- Game Over
-- 3 -- Creditos

MenuState = 0
-- 0 -- Play
-- 1 -- Credits


function love.load()
    -- Sets the random seed
    math.randomseed( os.time() )
end

function love.draw()
    if (State == 0) then
        drawMenu()
    elseif (State == 1) then
        drawGame()
    elseif (State == 2) then
        -- drawGameOver()
    elseif (State == 3) then
        drawCredits()
    end
end

function love.update(dt)
    if (State == 0) then
        menuUpdate()
    elseif (State == 1) then
        gameUpdate( dt )
    elseif (State == 2) then
        -- gameOverUpdate(dt)
    elseif (State == 3) then
        -- creditsUpdate(dt))
    end
end

function checkBallWallCollision( )
	x, y = ball:getPosition()
	speed_x, speed_y = ball:getSpeed()
	if ball.y < 0 then -- Upper wall collision
        y = 0
        speed_y = -speed_y
    elseif ball.y + ball.size > love.graphics.getHeight() then -- Lower wall collision
        y = love.graphics.getHeight() - ball.size
        speed_y = -speed_y
    end
    

    if ball.x < 0 then -- Left wall collision (Player 1 field)
    	x = 0
        speed_x = -speed_x
        player2.score = player2.score + 1
        ball = nil
        next_player_1 = true
    elseif ball.x + ball.size > love.graphics.getWidth() then -- Right wall collision (Player 2 field)
    	x = love.graphics.getWidth() - ball.size
    	speed_x = -speed_x
    	player1.score = player1.score + 1
        ball = nil
        next_player_1 = false
    end

    if (ball) then        
        ball:setPosition(x, y)
        ball:setSpeed(speed_x, speed_y)
    end
end

function drawScores( )
    love.graphics.setColor(Colors.White)
	love.graphics.print( player1.score, 310, 0, 0, 5 )
    love.graphics.print( player2.score, 450, 0, 0, 5 )
end

function drawField()
    local rect_sizex = 10
    local rect_sizey = 40
    local space = 10
    local repeats = love.graphics.getHeight()/rect_sizey
    
    love.graphics.setColor(Colors.White)
    for i = 0, repeats do
        love.graphics.rectangle( 'fill', love.graphics.getWidth()/2 - rect_sizex/2, 
        	i*(space + rect_sizey) + 5, rect_sizex, rect_sizey)
    end
end

function setBallInGame( )
    ball = Ball:new()
    ball:setPosition( love.graphics.getWidth()/2 - ball.size/2, love.graphics.getHeight()/2 - ball.size/2 )

    if next_player_1 then
        local _, y = player1:getPosition()
        local _, height = player1:getDimensions()
        y = y + height/2
        ball:setPosition( love.graphics.getWidth()/2 - ball.size/2, y - ball.size/2)
        ball:setSpeed( ball.speed_starting, ball.speed_starting )
    else
        local _, y = player2:getPosition()
        local _, height = player2:getDimensions()
        y = y + height/2
        ball:setPosition( love.graphics.getWidth()/2 + ball.size/2, y - ball.size/2)
        ball:setSpeed( -ball.speed_starting*math.random(0.9, 1.4), ball.speed_starting*math.random(0.9, 1.4) )
    end
end

function menuUpdate( )
    if(MenuState == 0) then
        if love.keyboard.isDown("down") then
            MenuState = 1
        elseif love.keyboard.isDown("return") then
            unloadMenu()
            loadGame()
        end
    elseif(MenuState == 1) then
        if love.keyboard.isDown("up") then
            MenuState = 0
        elseif love.keyboard.isDown("return") then
            unloadMenu()
            loadCredits()
        end
    end
end

function drawMenu( )
    love.graphics.setColor(Colors.White)
    love.graphics.print("Repair Pong", 0, 0, 0, 1)

    local color = {}

    if(MenuState == 0) then
        color = Colors.Orange
    else
        color = Colors.SmokyGray
    end
    love.graphics.print({color, "Play"}, 0, 30, 0, 1)

    if(MenuState == 1) then
        color = Colors.Orange
    else
        color = Colors.SmokyGray
    end
    love.graphics.print({color, "Credits"}, 0, 60, 0, 1)
end

function drawGame( )
    drawScores()
    drawField()
    player1:draw()
    player2:draw()

    if (ball) then
       ball:draw()
    end
end

function gameUpdate( dt )
    player1:update( dt )
    player2:update( dt )
    
    if (ball) then
        ball:update( dt )
        ball:checkPlayerCollision( player1 )
        ball:checkPlayerCollision( player2 )
        checkBallWallCollision( )
    else
        if love.keyboard.isDown("space") then
            setBallInGame()
        end
    end
end

function unloadMenu( )
    MenuState = 0
end

function loadGame( )
    State = 1

    -- Declare actors
    player1 = Player:new()
    player2 = Player:new()
    ball = nil
    next_player_1 = true
    
    local width
    local height
    width, height = player1:getDimensions()
    y = love.graphics.getHeight()/2 - height/2

    player1:setPosition( 20, y )
    player2:setPosition( love.graphics.getWidth() - width - 20 , y )
    player2:setUpKey( "i" )
    player2:setDownKey( "k" )
    player2:setRepairKey( "m" )
end

function unloadGame( )
    State = 0
end

function love.keyreleased(key)
    if key == "escape" then
        if (State == 0) then
            love.event.quit()
        elseif (State == 1) then
            unloadGame()
        elseif (State == 3) then
            unloadCredits()
        end
   end
end

function loadCredits( )
    State = 3
end

function unloadCredits( )
    State = 0
end

function drawCredits( )
    love.graphics.setColor(Colors.White)
    love.graphics.print("Repair Pong", 0, 0, 0, 1)
    love.graphics.print("Global Game Jam 2020 - PUC-Rio - Rio de Janeiro, Brazil", 0, 30, 0, 1)
    love.graphics.print("Programmer and game designer - Bruno Baère", 0, 60, 0, 1)
    love.graphics.print({Colors.White, "Icon is a derivative work of ", Colors.Green, "Freepik", Colors.White, " (",
        Colors.Blue, "https://www.flaticon.com/authors/freepik", Colors.White, ") from ", Colors.Green,
        "Flaticon", Colors.White, " (", Colors.Blue, "https://www.flaticon.com/", Colors.White, ")"}, 0, 90, 0, 1)
end