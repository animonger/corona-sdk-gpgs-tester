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

local composerM = require('composer')
local scene = composerM.newScene()
local widget = require( 'widget' )

-- need to load playerIDs of players of the game, friend playerIDs who don't have the game won't work
local playerOnePlayerID = 'Your-Player-GPGS-PlayerID'
local playerTwoPlayerID = 'Your-Player-GPGS-PlayerID'
local players = nil

local function onLoadLocalPlayerCallback(e)
    print( '[ScenePlayersMenu] onLoadLocalPlayerCallback event.name = ' .. e.name )
    print( '[ScenePlayersMenu] onLoadLocalPlayerCallback event.type = ' .. e.type )
    print( '[ScenePlayersMenu] onLoadLocalPlayerCallback localPlayerID = ' .. e.data.playerID )
    print( '[ScenePlayersMenu] onLoadLocalPlayerCallback localPlayerAlias = ' .. e.data.alias )
    return true
end

local function onLoadGPGServicesFriendsCallback(e)
    print( '[ScenePlayersMenu] onLoadGPGServicesFriendsCallback event.name = ' .. e.name )
    print( '[ScenePlayersMenu] onLoadGPGServicesFriendsCallback event.type = ' .. e.type )
    composerM.friends = e.data
    local friendsCount = #composerM.friends
    print( '[ScenePlayersMenu] onLoadGPGServicesFriendsCallback friendsCount = ' .. tostring(friendsCount) )
    for i = 1, friendsCount do
        print('vvvvvv')
        print('[ScenePlayersMenu] friend ' .. tostring(i) .. ' playerID = ' .. composerM.friends[i].playerID )
        print('[ScenePlayersMenu] friend ' .. tostring(i) .. ' alias = ' .. composerM.friends[i].alias )
    end
    print( '[ScenePlayersMenu] onLoadGPGServicesFriendsCallback END-OF-FRIENDS-LIST^')
    return true
end

local function onLoadGPGServicesPlayersCallback(e)
    print( '[ScenePlayersMenu] onLoadGPGServicesPlayersCallback event.name = ' .. e.name )
    print( '[ScenePlayersMenu] onLoadGPGServicesPlayersCallback event.type = ' .. e.type )
    print( '[ScenePlayersMenu] onLoadGPGServicesPlayersCallback #e.data = ' .. tostring(#e.data) )
    local playersCount = #e.data
    print( '[ScenePlayersMenu] onLoadGPGServicesPlayersCallback playerCount = ' .. tostring(playersCount) )
    -- playersCount == 0 is a hack for less than 2 players returned, e.data.playerID not e.data[1].playerID
    if(playersCount == 0) then 
        print('******')
        players = {}
        players[1] = {playerID = e.data.playerID, alias = e.data.alias}
        print('[ScenePlayersMenu] player ' .. tostring(1) .. ' playerID = ' .. players[1].playerID )
        print('[ScenePlayersMenu] player ' .. tostring(1) .. ' alias = ' .. players[1].alias )
    else
        players = e.data
        for i = 1, playersCount do
            print('vvvvvv')
            print('[ScenePlayersMenu] player ' .. tostring(i) .. ' playerID = ' .. players[i].playerID )
            print('[ScenePlayersMenu] player ' .. tostring(i) .. ' alias = ' .. players[i].alias )
        end
    end
    print( '[ScenePlayersMenu] onLoadGPGServicesFriendsCallback END-OF-PLAYERS-LIST^')
    return true   
end

local function onReleaseLoadLocalPlayerBtn(e)
    print( '[ScenePlayersMenu] Load Local Player Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'loadLocalPlayer', { listener=onLoadLocalPlayerCallback } )
    else
        print( '[ScenePlayersMenu] Can not load because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseLoadGPGServicesFriendsBtn(e)
    print( '[ScenePlayersMenu] Load GPGS Friends Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'loadFriends', { listener=onLoadGPGServicesFriendsCallback } )
    else
        print( '[ScenePlayersMenu] Can not load because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseLoadGPGServicesPlayersBtn(e)
    print( '[ScenePlayersMenu] Load GPGS Players Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        -- need to load playerIDs of players of the game, friend playerIDs who don't have the game won't work
        composerM.gameNetwork.request( 'loadPlayers', { playerIDs={playerOnePlayerID, playerTwoPlayerID}, 
        listener=onLoadGPGServicesPlayersCallback } )
    else
        print( '[ScenePlayersMenu] Can not load because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseBackBtn(e)
    print( '[ScenePlayersMenu] Back Button Released' )
    composerM.gotoScene('SceneMainMenu', {effect = 'fade', time = 500})
    return true
end

function scene:create(e)
    local sceneGroup = self.view
    
    local loadLocalPlayerBtn = widget.newButton {
        label = 'Load Local Player',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoadLocalPlayerBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loadLocalPlayerBtn.x = composerM.contentCenterX
    loadLocalPlayerBtn.y = 84
    sceneGroup:insert(loadLocalPlayerBtn)
    
    local loadGPGServicesFriendsBtn = widget.newButton {
        label = 'Load GPGS Friends',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoadGPGServicesFriendsBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loadGPGServicesFriendsBtn.x = composerM.contentCenterX
    loadGPGServicesFriendsBtn.y = 180
    sceneGroup:insert(loadGPGServicesFriendsBtn)
    
    local loadGPGServicesPlayersBtn = widget.newButton {
        label = 'Load GPGS Players',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoadGPGServicesPlayersBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loadGPGServicesPlayersBtn.x = composerM.contentCenterX
    loadGPGServicesPlayersBtn.y = 276
    sceneGroup:insert(loadGPGServicesPlayersBtn)
    
    local backBtn = widget.newButton {
    label = '<  Back',
    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
    fontSize = 35,
    onRelease = onReleaseBackBtn,
    shape = 'roundedRect',
    width = 160,
    height = 56,
    cornerRadius = 2,
    fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
    strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
    strokeWidth = 4
    }
    backBtn.x = 140
    backBtn.y = 1194
    sceneGroup:insert(backBtn)
    
end

function scene:show(e)
--    local sceneGroup = self.view
    if(e.phase == 'will') then
        
    elseif(e.phase == 'did') then
        
    end
end

function scene:hide(e)
--    local sceneGroup = self.view
    if (e.phase == 'will') then
        
    elseif (e.phase == 'did' ) then
        -- Called immediately after scene goes off screen.
    end
end

function scene:destroy(e)
    print('[ScenePlayersMenu] !!!!!!!!!!! destroy called !!!!!!!!!!!')
end

-- Scene Listener setup
scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene