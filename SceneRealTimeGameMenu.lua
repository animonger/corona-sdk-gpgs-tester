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

-- test callback event
local function printCallbackEvent(e)
    for k, v in pairs(e) do
        if(type(v) == 'table') then
            for key, value in pairs( v ) do
                print('[SceneRealTimeGameMenu] printCallbackEvent ' .. tostring(k) .. ' k = ' .. tostring(key) .. '  v = ' .. tostring(value))
            end
        else
            print('[SceneRealTimeGameMenu] printCallbackEvent k = ' .. tostring(k) .. '  v = ' .. tostring(v))
        end
    end
    return true
end

local function onRealTimeGPGServicesInvitationsUI_Callback(e)
    print( '%%%%%' )
    printCallbackEvent(e)
    print( '[SceneRealTimeGameMenu] onRealTimeGPGServicesInvitationsUI_Callback event.name = ' .. e.name )
    print( '[SceneRealTimeGameMenu] onRealTimeGPGServicesInvitationsUI_Callback event.type = ' .. e.type )
    print( '[SceneRealTimeGameMenu] onRealTimeGPGServicesInvitationsUI_Callback e.data.isError = ' .. tostring(e.data.isError) )
    print( '[SceneRealTimeGameMenu] onRealTimeGPGServicesInvitationsUI_Callback e.data.phase = ' .. e.data.phase )
    if(e.data.phase == 'selected') then
        print( '[SceneRealTimeGameMenu] onRealTimeGPGServicesInvitationsUI_Callback e.data.roomID = ' .. e.data.roomID )
        composerM.currentRealTimeRoomID = e.data.roomID
        -- goto real-time game screen and join room
        composerM.joinRoom = true
        composerM.gotoScene('SceneRealTimeGame', {effect = 'fade', time = 500})
    elseif(e.data.phase == 'cancelled') then
        print( '[SceneRealTimeGameMenu] onRealTimeGPGServicesInvitationsUI_Callback UI cancelled' )
    end
    return true
end

local function onRealTimeInvitationReceivedGPGServicesCallback(e)
    print( '%%%%%' )
    printCallbackEvent(e)
    print( '[SceneRealTimeGameMenu] onRealTimeInvitationReceivedGPGServicesCallback event.name = ' .. e.name )
    print( '[SceneRealTimeGameMenu] onRealTimeInvitationReceivedGPGServicesCallback event.type = ' .. e.type )
    print( '[SceneRealTimeGameMenu] onRealTimeInvitationReceivedGPGServicesCallback RECEIVED REAL-TIME GAME INVITATION >' )
    print( '[SceneRealTimeGameMenu] onRealTimeInvitationReceivedGPGServicesCallback e.data.roomID = ' .. e.data.roomID )
    -- this seems to be the only place we can get the inviting opponent's playerID
    composerM.currentRealTimePlayers = {}
    composerM.currentRealTimePlayers[1] = {playerID = e.data.playerID, alias = e.data.alias}
    print('[SceneRealTimeGameMenu] opponent player ' .. tostring(1) .. ' playerID = ' .. composerM.currentRealTimePlayers[1].playerID )
    print('[SceneRealTimeGameMenu] opponent player ' .. tostring(1) .. ' alias = ' .. composerM.currentRealTimePlayers[1].alias )
    composerM.gameNetwork.show( 'invitations', { listener=onRealTimeGPGServicesInvitationsUI_Callback } )
    return true
end

local function onLoadGPGServicesPlayersCallback(e)
    print( '%%%%%' )
    printCallbackEvent(e)
    print( '[SceneRealTimeGameMenu] onLoadGPGServicesPlayersCallback event.name = ' .. e.name )
    print( '[SceneRealTimeGameMenu] onLoadGPGServicesPlayersCallback event.type = ' .. e.type )
    print( '[SceneRealTimeGameMenu] onLoadGPGServicesPlayersCallback #e.data = ' .. tostring(#e.data) )
    local playersCount = #e.data
    print( '[SceneRealTimeGameMenu] onLoadGPGServicesPlayersCallback playerCount = ' .. tostring(playersCount) )
    -- playersCount == 0 is a hack for less than 2 players returned, e.data.playerID not e.data[1].playerID
    if(playersCount == 0) then 
        print('******')
        composerM.currentRealTimePlayers = {}
        composerM.currentRealTimePlayers[1] = {playerID = e.data.playerID, alias = e.data.alias}
        print('[SceneRealTimeGameMenu] opponent player ' .. tostring(1) .. ' playerID = ' .. composerM.currentRealTimePlayers[1].playerID )
        print('[SceneRealTimeGameMenu] opponent player ' .. tostring(1) .. ' alias = ' .. composerM.currentRealTimePlayers[1].alias )
    else
        composerM.currentRealTimePlayers = e.data
        for i = 1, playersCount do
            print('vvvvvv')
            print('[SceneRealTimeGameMenu] opponent player ' .. tostring(i) .. ' playerID = ' .. composerM.currentRealTimePlayers[i].playerID )
            print('[SceneRealTimeGameMenu] opponent player ' .. tostring(i) .. ' alias = ' .. composerM.currentRealTimePlayers[i].alias )
        end
    end
    print( '[SceneRealTimeGameMenu] onLoadGPGServicesFriendsCallback END-OF-PLAYERS-LIST^')
    return true   
end

local function onRealTimeSelectPlayersGPGServicesCallback(e)
    print( '%%%%%' )
    printCallbackEvent(e)
    print( '[SceneRealTimeGameMenu] onRealTimeSelectPlayersGPGServicesCallback event.name = ' .. e.name )
    print( '[SceneRealTimeGameMenu] onRealTimeSelectPlayersGPGServicesCallback event.type = ' .. e.type )
    print( '[SceneRealTimeGameMenu] onRealTimeSelectPlayersGPGServicesCallback e.data.phase = ' .. e.data.phase )
    if(e.data.phase == 'selected') then
        print( '[SceneRealTimeGameMenu] onRealTimeSelectPlayersGPGServicesCallback e.data.minAutoMatchPlayers = ' .. e.data.minAutoMatchPlayers )
        print( '[SceneRealTimeGameMenu] onRealTimeSelectPlayersGPGServicesCallback e.data.maxAutoMatchPlayers  = ' .. e.data.maxAutoMatchPlayers  )
        -- below determines if there are auto match players or not, an auto match only game will pass an empty 
        -- selectedRealTimePlayerIDs table to the playerIDs prams of the createRoom command
        composerM.minAutoMatchPlayers = e.data.minAutoMatchPlayers
        composerM.maxAutoMatchPlayers = e.data.maxAutoMatchPlayers
        composerM.selectedRealTimePlayerIDs = {}
        local selectedPlayerCount = #e.data
        print( '[SceneRealTimeGameMenu] onRealTimeSelectPlayersGPGServicesCallback selectedPlayerCount = ' .. tostring(selectedPlayerCount) )
        if(selectedPlayerCount > 0) then
            for i = 1, selectedPlayerCount do
                print('[SceneScoreLeaderboardMenu] selected player ' .. tostring(i) .. ' playerID = ' .. e.data[i] )
                print('^^^^^')
                composerM.selectedRealTimePlayerIDs[i] = e.data[i]
            end
            composerM.gameNetwork.request( 'loadPlayers', { playerIDs=composerM.selectedRealTimePlayerIDs, listener=onLoadGPGServicesPlayersCallback } )
        end
        -- goto real-time game screen and create room
        composerM.createRoom = true
        composerM.gotoScene('SceneRealTimeGame', {effect = 'fade', time = 500})
    elseif(e.data.phase == 'cancelled') then
        print( '[SceneRealTimeGameMenu] onRealTimeSelectPlayersGPGServicesCallback UI cancelled' )
    end
    return true
end

local function onReleaseSetRealTimeInvitationReceivedListenerBtn(e)
    print( '[SceneRealTimeGameMenu] Set Real-Time Invitation Received Listener Button Released' )
    if(composerM.isGPGServicesConnected == true) then
        composerM.gameNetwork.request( 'setInvitationReceivedListener', { listener=onRealTimeInvitationReceivedGPGServicesCallback } )
    else
        print( '[SceneRealTimeGameMenu] Can not set because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseShowGPGServicesRealTimeInvitationsUI_Btn(e)
    print( '[SceneRealTimeGameMenu] Show Real-Time Invitations UI Button Released' )
    if(composerM.isGPGServicesConnected == true) then
        composerM.gameNetwork.show( 'invitations', { listener=onRealTimeGPGServicesInvitationsUI_Callback } )
    else
        print( '[SceneRealTimeGameMenu] Can not show because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseShowGPGServicesRealTimeSelectPlayersUI_Btn(e)
    print( '[SceneRealTimeGameMenu] Show GPGS Real-Time Select Players UI Button Released' )
    if(composerM.isGPGServicesConnected == true) then
        composerM.gameNetwork.show( 'selectPlayers', { minPlayers=1, maxPlayers=2, 
        listener=onRealTimeSelectPlayersGPGServicesCallback } )
    else
        print( '[SceneRealTimeGameMenu] Can not show because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseRealTimeGameScreenBtn(e)
    print( '[SceneRealTimeGameMenu] Real-Time Game Screen Button Released' )
    composerM.gotoScene('SceneRealTimeGame', {effect = 'fade', time = 500})
    return true
end

local function onReleaseBackBtn(e)
    print( '[SceneRealTimeGameMenu] Back Button Released' )
    composerM.gotoScene('SceneMainMenu', {effect = 'fade', time = 500})
    return true
end

function scene:create(e)
    local sceneGroup = self.view
    
    local setRealTimeInvitationReceivedListenerBtn = widget.newButton {
        label = 'Set RT Invitation Received Listener',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseSetRealTimeInvitationReceivedListenerBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    setRealTimeInvitationReceivedListenerBtn.x = composerM.contentCenterX
    setRealTimeInvitationReceivedListenerBtn.y = 84
    sceneGroup:insert(setRealTimeInvitationReceivedListenerBtn)
    
    local showGPGServicesRealTimeInvitationsUI_Btn = widget.newButton {
        label = 'Show GPGS RT Invitations UI',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseShowGPGServicesRealTimeInvitationsUI_Btn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    showGPGServicesRealTimeInvitationsUI_Btn.x = composerM.contentCenterX
    showGPGServicesRealTimeInvitationsUI_Btn.y = 180
    sceneGroup:insert(showGPGServicesRealTimeInvitationsUI_Btn)
    
    local showGPGServicesRealTimeSelectPlayersUI_Btn = widget.newButton {
        label = 'Show GPGS RT Select Players UI',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseShowGPGServicesRealTimeSelectPlayersUI_Btn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    showGPGServicesRealTimeSelectPlayersUI_Btn.x = composerM.contentCenterX
    showGPGServicesRealTimeSelectPlayersUI_Btn.y = 276
    sceneGroup:insert(showGPGServicesRealTimeSelectPlayersUI_Btn)
    
    local realTimeGameScreenBtn = widget.newButton {
        label = 'RT Game Screen',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseRealTimeGameScreenBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    realTimeGameScreenBtn.x = composerM.contentCenterX
    realTimeGameScreenBtn.y = 1002
    sceneGroup:insert(realTimeGameScreenBtn)
    
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
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start listeners, start timers, begin animation, play audio, etc.
    end
end

function scene:hide(e)
--    local sceneGroup = self.view
    if (e.phase == 'will') then
        
    elseif (e.phase == 'did' ) then
        -- Called immediately after scene goes off screen.
    end
end

-- destroy event is dispatched before sceneGroup (self.view) is removed entirely, 
-- including its scene object which can be automatically in low memory situations, 
-- or explicitly via a call to composerM.removeScene().
function scene:destroy(e)
    print('[SceneRealTimeGameMenu] !!!!!!!!!!! destroy called !!!!!!!!!!!')
end

-- Scene Listener setup
scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene