local composerM = require('composer')
local scene = composerM.newScene()
local widget = require( 'widget' )
local mimeM = require ('mime')

local inputTxtField = nil
local isRealTimeMessageReceivedListenerRegistered = false
local realTimeParticipantIDs = nil

-- test callback event
local function printCallbackEvent(e)
    for k, v in pairs(e) do
        if(type(v) == 'table') then
            for key, value in pairs( v ) do
                print('[SceneRealTimeGame] printCallbackEvent ' .. tostring(k) .. ' k = ' .. tostring(key) .. '  v = ' .. tostring(value))
            end
        else
            print('[SceneRealTimeGame] printCallbackEvent k = ' .. tostring(k) .. '  v = ' .. tostring(v))
        end
    end
    return true
end

local function onRealTimeMessageReceivedGPGServicesCallback(e)
    print( 'vvvvv' )
    printCallbackEvent(e)
    print( '[SceneRealTimeGame] onRealTimeMessageReceivedGPGServicesCallback e.name = ' .. e.name )
    print( '[SceneRealTimeGame] onRealTimeMessageReceivedGPGServicesCallback e.type = ' .. e.type )
    print( '[SceneRealTimeGame] onRealTimeMessageReceivedGPGServicesCallback e.data.participantId = ' .. e.data.participantId )
    print( '[SceneRealTimeGame] onRealTimeMessageReceivedGPGServicesCallback e.data.message = ' .. e.data.message )
    local dataStr = mimeM.unb64(e.data.message) -- base64 decoding
    local messageReceived = 'participantId: ' .. e.data.participantId .. '\n' .. 'messageData: ' .. dataStr
    native.showAlert( 'Message Received', messageReceived, { 'OK' } )
    return true
end

local function onRealTimeWaitingRoomGPGServicesCallback(e)
    print( 'vvvvv' ) 
    printCallbackEvent(e)
    print( '[SceneRealTimeGame] onRealTimeWaitingRoomGPGServicesCallback event.name = ' .. e.name )
    print( '[SceneRealTimeGame] onRealTimeWaitingRoomGPGServicesCallback event.type = ' .. e.type )
    print( '[SceneRealTimeGame] onRealTimeWaitingRoomGPGServicesCallback e.data.isError = ' .. tostring(e.data.isError) )
    if(e.data.phase == 'cancel') then
        print( '[SceneRealTimeGame] onRealTimeWaitingRoomGPGServicesCallback UI cancelled' )
        native.showAlert( 'Match Cancelled', 'By exiting the Waiting Room you have quit the Real-Time match.', { 'OK' } )
    else
        print( '[SceneRealTimeGame] onRealTimeWaitingRoomGPGServicesCallback start game' )
    end
end

local function onRealTimeRoomGPGServicesCallback(e)
    print( 'vvvvv' ) 
    printCallbackEvent(e)
    print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback e.name = ' .. e.name )
    print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback e.type = ' .. e.type )
    print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback e.data.isError = ' .. tostring(e.data.isError) )
    
    if(e.type == 'createRoom') then
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback createRoom' )
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback createRoom e.data.roomID = ' .. e.data.roomID )
        composerM.currentRealTimeRoomID = e.data.roomID
        composerM.gameNetwork.show( 'waitingRoom', { roomID=composerM.currentRealTimeRoomID, minPlayers=2, 
        listener=onRealTimeWaitingRoomGPGServicesCallback } )
    elseif(e.type == 'joinRoom') then
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback joinRoom' )
        composerM.gameNetwork.show( 'waitingRoom', { roomID=composerM.currentRealTimeRoomID, minPlayers=2, 
        listener=onRealTimeWaitingRoomGPGServicesCallback } )
    elseif(e.type == 'leaveRoom') then
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback leaveRoom' )
    elseif(e.type == 'connectedRoom') then
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback connectedRoom' )
        composerM.gameNetwork.request( 'setMessageReceivedListener', { listener=onRealTimeMessageReceivedGPGServicesCallback } )
        print( '[SceneRealTimeGame] request setMessageReceivedListener')
        isRealTimeMessageReceivedListenerRegistered = true
        native.showAlert( 'Start Game', 'Send some Real-Time Game data messages!', { 'OK' } )
    elseif(e.type == 'peerAcceptedInvitation') then
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback peerAcceptedInvitation' )
        realTimeParticipantIDs = {}
        local participantCount = #e.data
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback participantCount = ' .. tostring(participantCount) )
        for i = 1, participantCount do
            print('[SceneRealTimeGame] participant ' .. tostring(i) .. ' participantID = ' .. e.data[i] )
            print('^^^^^')
            realTimeParticipantIDs[i] = e.data[i]
        end
    elseif(e.type == 'peerDeclinedInvitation') then
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback peerDeclinedInvitation' )
    elseif(e.type == 'peerLeftRoom') then
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback peerLeftRoom' )
    elseif(e.type == 'peerDisconnectedFromRoom') then
        print( '[SceneRealTimeGame] onRealTimeRoomGPGServicesCallback peerDisconnectedFromRoom' )
    end
    return true
end

local function onUserInputTxtField(e)
    if ( e.phase == 'began' ) then
        native.setKeyboardFocus( e.target )
        --print( '[SceneRealTimeGame] Input Text = began' )
    end
    return true
end

local function onReleaseCancelTextInputBtn(e)
    print( '[SceneRealTimeGame] Cancel Text Input Button Released' )
    native.setKeyboardFocus(nil)
    inputTxtField.text = ''
    return true
end

local function onReleaseSendGPGServicesRealTimeReliableMessageBtn(e)
    print( '[SceneRealTimeGame] Send Google Play Game Services Real Time Reliable Message Button Released' )
    native.setKeyboardFocus(nil)
    local dataStr = inputTxtField.text
    print( '[SceneRealTimeGame] isRealTimeMessageReceivedListenerRegistered = ' .. tostring(isRealTimeMessageReceivedListenerRegistered) )
    if( isRealTimeMessageReceivedListenerRegistered == true ) then
        if( composerM.isGPGServicesConnected == true ) then
            if( dataStr ~= '' ) then
                local dataB64 = mimeM.b64(dataStr) -- base64 encoding
                composerM.gameNetwork.request( 'sendMessage', { roomID=composerM.currentRealTimeRoomID, 
                playerIDs=realTimeParticipantIDs, message=dataB64, reliable=true } )
                print( '[SceneRealTimeGame] request sendMessage')
            end
        else
            print( '[SceneRealTimeGame] Can not send because isGPGServicesConnected = false' )
        end
    else
        print( '[SceneRealTimeGame] Can not send because isRealTimeMessageReceivedListenerRegistered = false' )
    end
    inputTxtField.text = ''
    return true
end

local function onReleaseSendGPGServicesRealTimeUnreliableMessageBtn(e)
    print( '[SceneRealTimeGame] Send Google Play Game Services Real Time Unreliable Message Button Released' )
    native.setKeyboardFocus(nil)
    local dataStr = inputTxtField.text
    print( '[SceneRealTimeGame] isRealTimeMessageReceivedListenerRegistered = ' .. tostring(isRealTimeMessageReceivedListenerRegistered) )
    if( isRealTimeMessageReceivedListenerRegistered == true ) then
        if( composerM.isGPGServicesConnected == true ) then
            if( dataStr ~= '' ) then
                local dataB64 = mimeM.b64(dataStr) -- base64 encoding
                composerM.gameNetwork.request( 'sendMessage', { roomID=composerM.currentRealTimeRoomID, 
                playerIDs=realTimeParticipantIDs, message=dataB64, reliable=false } )
                print( '[SceneRealTimeGame] request sendMessage')
            end
        else
            print( '[SceneRealTimeGame] Can not send because isGPGServicesConnected = false' )
        end
    else
        print( '[SceneRealTimeGame] Can not send because isRealTimeMessageReceivedListenerRegistered = false' )
    end
    inputTxtField.text = ''
    return true
end


local function onReleaseLeaveGPGServicesRealTimeRoomBtn(e)
    print( '[SceneRealTimeGame] Leave GPGS Real-Time Game Room Button Released' )
    if(composerM.isGPGServicesConnected == true) then
        if(composerM.currentRealTimeRoomID ~= 'nil') then
            composerM.gameNetwork.request( 'leaveRoom', { roomID=composerM.currentRealTimeRoomID } )
            composerM.currentRealTimeRoomID = 'nil'
        else
            print( '[SceneRealTimeGame] Can not leave because currentRealTimeRoomID = nil' )
        end
    else
        print( '[SceneRealTimeGame] Can not leave because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseBackBtn(e)
    print( '[SceneRealTimeGame] Back Button Released' )
    composerM.gotoScene('SceneRealTimeGameMenu', {effect = 'fade', time = 500})
    return true
end

function scene:create(e)
    local sceneGroup = self.view
    
    local textBg = display.newRoundedRect( composerM.contentCenterX, 84, 600, 56, 12 )
    textBg.strokeWidth = 3
    textBg:setFillColor( 1, 1, 1 )
    textBg:setStrokeColor( 0.8, 0.8, 0.8 )
    sceneGroup:insert(textBg)
    
    local cancelTextInputBtn = widget.newButton {
        label = 'Cancel Text Input',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseCancelTextInputBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    cancelTextInputBtn.x = composerM.contentCenterX
    cancelTextInputBtn.y = 180
    sceneGroup:insert(cancelTextInputBtn)
    
    local sendGPGServicesRealTimeReliableMessageBtn = widget.newButton {
        label = 'Send GPGS RT Reliable Message',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseSendGPGServicesRealTimeReliableMessageBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    sendGPGServicesRealTimeReliableMessageBtn.x = display.contentCenterX
    sendGPGServicesRealTimeReliableMessageBtn.y = 276
    sceneGroup:insert(sendGPGServicesRealTimeReliableMessageBtn)
    
    local sendGPGServicesRealTimeUnreliableMessageBtn = widget.newButton {
        label = 'Send GPGS RT Unreliable Message',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseSendGPGServicesRealTimeUnreliableMessageBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    sendGPGServicesRealTimeUnreliableMessageBtn.x = display.contentCenterX
    sendGPGServicesRealTimeUnreliableMessageBtn.y = 372
    sceneGroup:insert(sendGPGServicesRealTimeUnreliableMessageBtn)
    
    
    local leaveGPGServicesRealTimeRoomBtn = widget.newButton {
        label = 'Leave GPGS RT Room',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLeaveGPGServicesRealTimeRoomBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    leaveGPGServicesRealTimeRoomBtn.x = display.contentCenterX
    leaveGPGServicesRealTimeRoomBtn.y = 1002
    sceneGroup:insert(leaveGPGServicesRealTimeRoomBtn)
    
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
    if(e.phase == 'will') then
    	if((composerM.createRoom == true) or (composerM.joinRoom == true)) then
            if(composerM.isGPGServicesConnected == true) then
            	if(composerM.createRoom == true) then
                    composerM.gameNetwork.request( 'createRoom', { playerIDs=composerM.selectedRealTimePlayerIDs, 
                    minAutoMatchPlayers=composerM.minAutoMatchPlayers, maxAutoMatchPlayers=composerM.maxAutoMatchPlayers,
                    listener=onRealTimeRoomGPGServicesCallback } )
                    print( '[SceneRealTimeGame] request createRoom')
                elseif(composerM.joinRoom == true) then
                    composerM.gameNetwork.request( 'joinRoom', { roomID=composerM.currentRealTimeRoomID, 
                    listener=onRealTimeRoomGPGServicesCallback } )
                    print( '[SceneRealTimeGame] request joinRoom')
                end
            else
            	print( '[SceneRealTimeGame] Can not set because isGPGServicesConnected = false' )
            end
        else
            print( '[SceneRealTimeGame] Can not start real-time game because createRoom or joinRoom = false' )
        end
    elseif(e.phase == 'did') then
        inputTxtField = native.newTextField( composerM.contentCenterX, 84, 580, 56 )
        inputTxtField.font = native.newFont(native.systemFont, 30)
        inputTxtField:setTextColor(0, 0, 0)
        inputTxtField.align = 'left'
        inputTxtField.hasBackground = false
        inputTxtField.placeholder = 'Input mock game data'
        inputTxtField:addEventListener( 'userInput', onUserInputTxtField )
    end
end

function scene:hide(e)
    if (e.phase == 'will') then
    	inputTxtField:removeEventListener( 'userInput', onUserInputTxtField )
        inputTxtField:removeSelf()
        inputTxtField = nil
    elseif (e.phase == 'did' ) then
        -- Called immediately after scene goes off screen.
    end
end

function scene:destroy(e)
    print('[SceneRealTimeGame] !!!!!!!!!!! destroy called !!!!!!!!!!!')
end

-- Scene Listener setup
scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene