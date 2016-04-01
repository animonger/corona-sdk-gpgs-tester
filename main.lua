--[[
 The MIT License (MIT)
 
 Copyright (c) 2016 Warren Fuller, animonger.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ]]

print('[Lua main] Corona GPGS Plugin Tester Launch')
print('[Lua main] pixelWidth = ' .. tostring(display.pixelWidth) .. '   pixelHeight = ' .. tostring(display.pixelHeight))
print('[Lua main] actualContentWidth = ' .. tostring(display.actualContentWidth) .. '   actualContentHeight = ' .. 
tostring(display.actualContentHeight))
print('[Lua main] contentWidth = ' .. tostring(display.contentWidth) .. '   contentHeight = ' .. 
tostring(display.contentHeight))
print('[Lua main] contentCenterX = ' .. tostring(display.contentCenterX) .. '   contentCenterY = ' .. 
tostring(display.contentCenterY))
print('[Lua main] contentScaleX = ' .. tostring(display.contentScaleX) .. '   contentScaleY = ' .. 
tostring(display.contentScaleY))
print('[Lua main] screenOriginX = ' .. tostring(display.screenOriginX) .. '   screenOriginY = ' .. 
tostring(display.screenOriginY))
print('')

local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
bg:setFillColor( 0.9, 0.9, 0.9 )
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local composerM = require('composer')
composerM.gameNetwork = require('gameNetwork')
composerM.contentCenterX = display.contentCenterX
composerM.contentCenterY = display.contentCenterY

composerM.isGPGServicesConnected = false
composerM.localPlayerID = 'nil'
composerM.localPlayerAlias = 'nil'
composerM.friends = nil  -- local player's gpgs friends table
composerM.selectedRealTimePlayerIDs = nil
composerM.minAutoMatchPlayers = 0
composerM.maxAutoMatchPlayers = 0
composerM.currentRealTimePlayers = nil
composerM.currentRealTimeRoomID = 'nil'
composerM.createRoom = false
composerM.joinRoom = false
composerM.achievementOneID = 'CgkIpdacz_oHEAIQAQ'
composerM.AchievementTwoID = 'CgkIpdacz_oHEAIQAg'
composerM.leaderboardOneID = 'CgkIpdacz_oHEAIQBg'

local function onSystemEvent(e) 
    if( e.type == 'applicationStart' ) then
        print( '[Lua main] onSystemEvent applicationStart called' )
        print( '[Lua main] VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV' )
    end
    return true
end

local function onKeyEvent(e)
    if(('back' == e.keyName) and (e.phase == 'up')) then
        print('[main] e.keyName = ' .. tostring(e.keyName) .. '  e.phase = ' .. tostring(e.phase))
        local currentScene = composerM.getSceneName('current')
        print('[main] currentScene = ' .. tostring(currentScene))
        local previousScene = composerM.getSceneName('previous')
        print('[main] previousScene = ' .. tostring(previousScene))
        
        if(currentScene == 'SceneMainMenu') then
            native.requestExit() -- exit app
        else
            composerM.gotoScene(previousScene, {effect = 'fade', time = 500})
        end
        return true -- return true overides the native back button event
    end
end

Runtime:addEventListener( 'system', onSystemEvent )
Runtime:addEventListener('key', onKeyEvent)

composerM.gotoScene('SceneMainMenu', {effect = 'fade', time = 500})
