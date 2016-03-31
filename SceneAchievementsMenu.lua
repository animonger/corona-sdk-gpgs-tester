local composerM = require('composer')
local scene = composerM.newScene()
local widget = require( 'widget' )

local function onUnlockGPGServicesAchievementCallback(e)
    print( '[SceneAchievementsMenu] onUnlockGPGServicesAchievementCallback e.name = ' .. e.name )
    print( '[SceneAchievementsMenu] onUnlockGPGServicesAchievementCallback e.type = ' .. e.type )
    print( '[SceneAchievementsMenu] onUnlockGPGServicesAchievementCallback e.data.achievementId = ' .. e.data.achievementId )
    return true
end

local function onLoadGPGServicesAchievementsCallback(e)
    print( '[SceneAchievementsMenu] onLoadGPGServicesAchievementsCallback e.name = ' .. e.name )
    print( '[SceneAchievementsMenu] onLoadGPGServicesAchievementsCallback e.type = ' .. e.type )
    local achievementCount = #e.data
    print( '[SceneScoreLeaderboardMenu] onLoadGPGServicesAchievementsCallback achievementCount = ' .. tostring(achievementCount) )
    for i = 1, achievementCount do
        print('[SceneAchievementsMenu] achievement ' .. tostring(i) .. ' title = ' .. e.data[i].title )
        print('[SceneAchievementsMenu] achievement ' .. tostring(i) .. ' identifier = ' .. e.data[i].identifier )
        print('[SceneAchievementsMenu] achievement ' .. tostring(i) .. ' description = ' .. e.data[i].description )
        print('[SceneAchievementsMenu] achievement ' .. tostring(i) .. ' isCompleted = ' .. tostring(e.data[i].isCompleted) )
        print('[SceneAchievementsMenu] achievement ' .. tostring(i) .. ' isHidden = ' .. tostring(e.data[i].isHidden) )
        print('[SceneAchievementsMenu] achievement ' .. tostring(i) .. ' lastReportedDate = ' .. tostring(e.data[i].lastReportedDate) )
        print('^^^^^')
    end
    return true
end

local function onReleaseShowGPGServicesAchievementsUI_Btn(e)
    print( '[SceneAchievementsMenu] Show Google Play Game Services Achievements UI Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.show( 'achievements' )
    else
        print( '[SceneAchievementsMenu] Can not show because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseUnlockGPGServicesAchievementOneBtn(e)
    print( '[SceneAchievementsMenu] Unlock Google Play Game Services Achievement One Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'unlockAchievement', { achievement={identifier=composerM.achievementOneID}, 
        listener=onUnlockGPGServicesAchievementCallback} )
    else
        print( '[SceneAchievementsMenu] Can not unlock because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseUnlockGPGServicesAchievementTwoBtn(e)
    print( '[SceneAchievementsMenu] Unlock Google Play Game Services Achievement Two Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'unlockAchievement', { achievement={identifier=composerM.AchievementTwoID}, 
        listener=onUnlockGPGServicesAchievementCallback} )
    else
        print( '[SceneAchievementsMenu] Can not unlock because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseLoadGPGServicesAchievementsBtn(e)
    print( '[SceneAchievementsMenu] Load Google Play Game Services Achievements Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'loadAchievements', { listener=onLoadGPGServicesAchievementsCallback } )
    else
        print( '[SceneAchievementsMenu] Can not load because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseLoadGPGServicesAchievementDescriptionsBtn(e)
    print( '[SceneAchievementsMenu] Load Google Play Game Services Achievement Descriptions Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'loadAchievementDescriptions', { listener=onLoadGPGServicesAchievementsCallback } )
    else
        print( '[SceneAchievementsMenu] Can not load because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseBackBtn(e)
    print( '[SceneAchievementsMenu] Back Button Released' )
    composerM.gotoScene('SceneMainMenu', {effect = 'fade', time = 500})
    return true
end

function scene:create(e)
    local sceneGroup = self.view
    
    local showGPGServicesAchievementsUI_Btn = widget.newButton {
        label = 'Show GPGS Achievements UI',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseShowGPGServicesAchievementsUI_Btn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    showGPGServicesAchievementsUI_Btn.x = composerM.contentCenterX
    showGPGServicesAchievementsUI_Btn.y = 84
    sceneGroup:insert(showGPGServicesAchievementsUI_Btn)
    
    local unlockGPGServicesAchievementOneBtn = widget.newButton {
        label = 'Unlock GPGS Achievement One',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseUnlockGPGServicesAchievementOneBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    unlockGPGServicesAchievementOneBtn.x = composerM.contentCenterX
    unlockGPGServicesAchievementOneBtn.y = 180
    sceneGroup:insert(unlockGPGServicesAchievementOneBtn)
    
    local unlockGPGServicesAchievementTwoBtn = widget.newButton {
        label = 'Unlock GPGS Achievement Two',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseUnlockGPGServicesAchievementTwoBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    unlockGPGServicesAchievementTwoBtn.x = composerM.contentCenterX
    unlockGPGServicesAchievementTwoBtn.y = 276
    sceneGroup:insert(unlockGPGServicesAchievementTwoBtn)
    
    local loadGPGServicesAchievementsBtn = widget.newButton {
        label = 'Load GPGS Achievements',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoadGPGServicesAchievementsBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loadGPGServicesAchievementsBtn.x = composerM.contentCenterX
    loadGPGServicesAchievementsBtn.y = 372
    sceneGroup:insert(loadGPGServicesAchievementsBtn)
    
    local loadGPGServicesAchievementDescriptionsBtn = widget.newButton {
        label = 'Load GPGS Achievement Desc.',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoadGPGServicesAchievementDescriptionsBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loadGPGServicesAchievementDescriptionsBtn.x = composerM.contentCenterX
    loadGPGServicesAchievementDescriptionsBtn.y = 468
    sceneGroup:insert(loadGPGServicesAchievementDescriptionsBtn)
    
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
        -- Called when the scene is still off screen but is about to come on screen.
        -- Populate text fields, etc.
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

function scene:destroy(e)
    print('[SceneAchievementsMenu] !!!!!!!!!!! destroy called !!!!!!!!!!!')
end

-- Scene Listener setup
scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene