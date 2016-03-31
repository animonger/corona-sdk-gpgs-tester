local composerM = require('composer')
local scene = composerM.newScene()
local widget = require( 'widget' )

local function onLoadLocalPlayerCallback(e)
    print( '[SceneMainMenu] onLoadLocalPlayerCallback event.name = ' .. e.name )
    print( '[SceneMainMenu] onLoadLocalPlayerCallback event.type = ' .. e.type )
    composerM.localPlayerID = e.data.playerID
    composerM.localPlayerAlias = e.data.alias
    print( '[SceneMainMenu] onLoadLocalPlayerCallback localPlayerID = ' .. composerM.localPlayerID )
    print( '[SceneMainMenu] onLoadLocalPlayerCallback localPlayerAlias = ' .. composerM.localPlayerAlias )
    print( '****')
    return true
end

local function onLoginGPGServicesCallback(e)
    print( '[SceneMainMenu] onLoginGPGServicesCallback event.name = ' .. e.name )
    print( '[SceneMainMenu] onLoginGPGServicesCallback event.type = ' .. e.type )
    composerM.isGPGServicesConnected = composerM.gameNetwork.request( 'isConnected' )
    if(composerM.isGPGServicesConnected == true) then
        composerM.gameNetwork.request( 'loadLocalPlayer', { listener=onLoadLocalPlayerCallback } )
        print( '[SceneMainMenu] onLoginGPGServicesCallback *** Login Success ***' )
        print( '[SceneMainMenu] onLoginGPGServicesCallback isGPGServicesConnected = ' .. tostring(composerM.isGPGServicesConnected) )
    else
        print( '[SceneMainMenu] onLoginGPGServicesCallback isGPGServicesConnected = ' .. tostring(composerM.isGPGServicesConnected) )
    end
    return true
end

local function onInitGPGServicesCallback(e)
    print( '[SceneMainMenu] onInitGPGServicesCallback event.name = ' .. e.name )
    print( '[SceneMainMenu] onInitGPGServicesCallback event.type = ' .. e.type )
    if(e.isError) then
        print( '[SceneMainMenu] onInitGPGServicesCallback event.errorCode = ' .. tostring(e.errorCode) )
        print( '[SceneMainMenu] onInitGPGServicesCallback event.errorMessage = ' .. e.errorMessage )
        native.showAlert( 'Init Failed!', e.errorMessage, { 'OK' } )
        composerM.isGPGServicesConnected = false
    else
        print( '[SceneMainMenu] onInitGPGServicesCallback +++ Init Success +++' )
        composerM.gameNetwork.request( 'login', { userInitiated=true, listener=onLoginGPGServicesCallback } )
    end
    return true
end

local function onReleaseLoginGPGServicesBtn(e)
    print( '[SceneMainMenu] Login Google Play Game Services Button Released!!' )
    composerM.gameNetwork.init( 'google', onInitGPGServicesCallback )
    return true
end

local function onReleaseLogoutGPGServicesBtn(e)
    print( '[SceneMainMenu] Logout Google Play Game Services Button Released!!' )
    composerM.gameNetwork.request( 'logout' )
    composerM.isGPGServicesConnected = composerM.gameNetwork.request( 'isConnected' )
    print( '[SceneMainMenu] onReleaseLogoutGPGServicesBtn isGPGServicesConnected = ' .. tostring(composerM.isGPGServicesConnected) )
    return true
end

local function onReleaseAchievementsMenuBtn(e)
    print( '[SceneMainMenu] Achievements Menu Button Released' )
    composerM.gotoScene('SceneAchievementsMenu', {effect = 'fade', time = 500})
    return true
end

local function onReleaseScoreLeaderboardMenuBtn(e)
    print( '[SceneMainMenu] Scores and Leaderboards Menu Button Released' )
    composerM.gotoScene('SceneScoreLeaderboardMenu', {effect = 'fade', time = 500})
    return true
end

local function onReleasePlayersMenuBtn(e)
    print( '[SceneMainMenu] Players Menu Button Released' )
    composerM.gotoScene('ScenePlayersMenu', {effect = 'fade', time = 500})
    return true
end

local function onReleaseRealTimeGameMenuBtn(e)
    print( '[SceneMainMenu] Real-Time Game Menu Button Released' )
    composerM.gotoScene('SceneRealTimeGameMenu', {effect = 'fade', time = 500})
    return true
end


function scene:create(e)
    local sceneGroup = self.view
    
    local loginGPGServicesBtn = widget.newButton {
        label = 'Login Google Play Game Services',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoginGPGServicesBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loginGPGServicesBtn.x = composerM.contentCenterX
    loginGPGServicesBtn.y = 84
    sceneGroup:insert(loginGPGServicesBtn)
    
    local logoutGPGServicesBtn = widget.newButton {
        label = 'Logout Google Play Game Services',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLogoutGPGServicesBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    logoutGPGServicesBtn.x = composerM.contentCenterX
    logoutGPGServicesBtn.y = 180
    sceneGroup:insert(logoutGPGServicesBtn)
    
    local achievementsMenuBtn = widget.newButton {
        label = 'Achievements Menu',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseAchievementsMenuBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    achievementsMenuBtn.x = composerM.contentCenterX
    achievementsMenuBtn.y = 276
    sceneGroup:insert(achievementsMenuBtn)
    
    local scoreLeaderboardMenuBtn = widget.newButton {
        label = 'Scores and Leaderboards Menu',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseScoreLeaderboardMenuBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    scoreLeaderboardMenuBtn.x = composerM.contentCenterX
    scoreLeaderboardMenuBtn.y = 372
    sceneGroup:insert(scoreLeaderboardMenuBtn)
    
    local playersMenuBtn = widget.newButton {
        label = 'Players Menu',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleasePlayersMenuBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    playersMenuBtn.x = composerM.contentCenterX
    playersMenuBtn.y = 468
    sceneGroup:insert(playersMenuBtn)
    
    local realTimeGameMenuBtn = widget.newButton {
        label = 'Real-Time Game Menu',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseRealTimeGameMenuBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    realTimeGameMenuBtn.x = composerM.contentCenterX
    realTimeGameMenuBtn.y = 564
    sceneGroup:insert(realTimeGameMenuBtn)
    
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
    print('[SceneMainMenu] !!!!!!!!!!! destroy called !!!!!!!!!!!')
end

-- Scene Listener setup
scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene