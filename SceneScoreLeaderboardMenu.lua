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

local inputTxtField = nil

local function onSetGPGServicesHighScoresCallback(e)
    print( '[SceneScoreLeaderboardMenu] onSetGPGServicesHighScoresCallback e.name = ' .. e.name )
    print( '[SceneScoreLeaderboardMenu] onSetGPGServicesHighScoresCallback e.type = ' .. e.type )
    print( '[SceneScoreLeaderboardMenu] onSetGPGServicesHighScoresCallback e.data.playerID = ' .. e.data.playerID )
    print( '[SceneScoreLeaderboardMenu] onSetGPGServicesHighScoresCallback e.data.category = ' .. e.data.category )
    print( '[SceneScoreLeaderboardMenu] onSetGPGServicesHighScoresCallback e.data.value = ' .. tostring(e.data.value) )
    print( '[SceneScoreLeaderboardMenu] onSetGPGServicesHighScoresCallback e.data.formattedValue = ' .. e.data.formattedValue )
    return true
end

local function onLoadGPGServicesScoresCallback(e)
    print( '[SceneScoreLeaderboardMenu] onLoadGPGServicesScoresCallback e.name = ' .. e.name )
    print( '[SceneScoreLeaderboardMenu] onLoadGPGServicesScoresCallback e.type = ' .. e.type )
    local scoresCount = #e.data
    print( '[SceneScoreLeaderboardMenu] onLoadGPGServicesScoresCallback scoresCount = ' .. tostring(scoresCount) )
    for i = 1, scoresCount do
        print('[SceneScoreLeaderboardMenu] score ' .. tostring(i) .. ' playerID = ' .. e.data[i].playerID )
        print('[SceneScoreLeaderboardMenu] score ' .. tostring(i) .. ' category = ' .. e.data[i].category )
        print('[SceneScoreLeaderboardMenu] score ' .. tostring(i) .. ' rank = ' .. tostring(e.data[i].rank) )
        print('[SceneScoreLeaderboardMenu] score ' .. tostring(i) .. ' formattedValue = ' .. e.data[i].formattedValue )
        print('[SceneScoreLeaderboardMenu] score ' .. tostring(i) .. ' value = ' .. tostring(e.data[i].value) )
        print('[SceneScoreLeaderboardMenu] score ' .. tostring(i) .. ' unixTime = ' .. tostring(e.data[i].unixTime) )
        print('[SceneScoreLeaderboardMenu] score ' .. tostring(i) .. ' date = ' .. e.data[i].date )
        print('^^^^^')
    end
    return true
end

local function onLoadGPGServicesLeaderboardCategoriesCallback(e) 
    print( '[SceneScoreLeaderboardMenu] onLoadGPGServicesLeaderboardCategoriesCallback event.name = ' .. e.name )
    print( '[SceneScoreLeaderboardMenu] onLoadGPGServicesLeaderboardCategoriesCallback event.type = ' .. e.type )
    local leaderboardsCount = #e.data
    print( '[SceneScoreLeaderboardMenu] onLoadGPGServicesLeaderboardCategoriesCallback leaderboardsCount = ' .. tostring(leaderboardsCount) )
    for i = 1, leaderboardsCount do
        print('[SceneScoreLeaderboardMenu] leaderboard ' .. tostring(i) .. ' title = ' .. e.data[i].title )
        print('[SceneScoreLeaderboardMenu] leaderboard ' .. tostring(i) .. ' category = ' .. e.data[i].category )
        print('^^^^^')
    end
    return true
end

local function onReleaseShowGPGServicesLeaderboardsUI_Btn(e)
    print( '[SceneScoreLeaderboardMenu] Show Google Play Game Services Leaderboards Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.show( 'leaderboards' )
    else
        print( '[SceneAchieveChallengeMenu] Can not show because isGPGServicesConnected = false' )
    end
    return true
end

local function onUserInputTxtField(e)
	if ( e.phase == 'began' ) then
        native.setKeyboardFocus( e.target )
        --print( '[SceneScoreLeaderboardMenu] Input Text = began' )
    end
    return true
end

local function onReleaseCancelTextInputBtn(e)
    print( '[SceneScoreLeaderboardMenu] Cancel Text Input Button Released' )
    native.setKeyboardFocus(nil)
    inputTxtField.text = ''
    return true
end

local function onReleaseSetGPGServicesHighScoreBtn(e)
    print( '[SceneScoreLeaderboardMenu] Set Google Play Game Services High Score Button Released' )
    native.setKeyboardFocus(nil)
    local score = tonumber(inputTxtField.text)
    print( '[SceneScoreLeaderboardMenu] score = ' .. tostring(score) )
    if( composerM.isGPGServicesConnected == true ) then
        if( score ~= nil ) then
            composerM.gameNetwork.request( 'setHighScore', { localPlayerScore={category=composerM.leaderboardOneID, 
            value=score}, listener=onSetGPGServicesHighScoresCallback }  )
        end
    else
        print( '[SceneScoreLeaderboardMenu] Can not set because isGPGServicesConnected = false' )
    end
    inputTxtField.text = ''
    return true
end

local function onReleaseLoadGlobalGPGServicesScoresBtn(e)
    print( '[SceneScoreLeaderboardMenu] Load Global Google Play Game Services Scores Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'loadScores', { leaderboard={category=composerM.leaderboardOneID, 
        playerScope='Global', timeScope='AllTime', range={1,10}, playerCentered=false }, 
        listener=onLoadGPGServicesScoresCallback }  )
    else
        print( '[SceneScoreLeaderboardMenu] Can not load because composerM.isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseLoadFriendsGPGServicesScoresBtn(e)
    print( '[SceneScoreLeaderboardMenu] Load Friends Google Play Game Services Scores Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'loadScores', { leaderboard={category=composerM.leaderboardOneID, 
        playerScope='FriendsOnly', timeScope='AllTime', range={1,10}, playerCentered=true }, 
        listener=onLoadGPGServicesScoresCallback }  )
    else
        print( '[SceneScoreLeaderboardMenu] Can not load because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseLoadGPGServicesLeaderboardCategoriesBtn(e)
    print( '[SceneScoreLeaderboardMenu] Load Google Play Game Services Leaderboard Categories Button Released' )
    if( composerM.isGPGServicesConnected == true ) then
        composerM.gameNetwork.request( 'loadLeaderboardCategories', { listener=onLoadGPGServicesLeaderboardCategoriesCallback } )
    else
        print( '[SceneScoreLeaderboardMenu] Can not load because isGPGServicesConnected = false' )
    end
    return true
end

local function onReleaseBackBtn(e)
    print( '[SceneScoreLeaderboardMenu] Back Button Released' )
    composerM.gotoScene('SceneMainMenu', {effect = 'fade', time = 500})
    return true
end

function scene:create(e)
    local sceneGroup = self.view
    
    local showGPGServicesLeaderboardsUI_Btn = widget.newButton {
        label = 'Show GPGS Leaderboards UI',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseShowGPGServicesLeaderboardsUI_Btn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    showGPGServicesLeaderboardsUI_Btn.x = composerM.contentCenterX
    showGPGServicesLeaderboardsUI_Btn.y = 84
    sceneGroup:insert(showGPGServicesLeaderboardsUI_Btn)
    
    local textBg = display.newRoundedRect( composerM.contentCenterX, 180, 600, 56, 12 )
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
    cancelTextInputBtn.y = 276
    sceneGroup:insert(cancelTextInputBtn)
    
    local setGPGServicesHighScoreBtn = widget.newButton {
        label = 'Set GPGS High Score',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseSetGPGServicesHighScoreBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    setGPGServicesHighScoreBtn.x = composerM.contentCenterX
    setGPGServicesHighScoreBtn.y = 372
    sceneGroup:insert(setGPGServicesHighScoreBtn)
    
    local loadGlobalGPGServicesScoresBtn = widget.newButton {
        label = 'Load Global GPGS Scores',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoadGlobalGPGServicesScoresBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loadGlobalGPGServicesScoresBtn.x = composerM.contentCenterX
    loadGlobalGPGServicesScoresBtn.y = 468
    sceneGroup:insert(loadGlobalGPGServicesScoresBtn)
    
    local loadFriendsGPGServicesScoresBtn = widget.newButton {
        label = 'Load Friends GPGS Scores',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoadFriendsGPGServicesScoresBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loadFriendsGPGServicesScoresBtn.x = composerM.contentCenterX
    loadFriendsGPGServicesScoresBtn.y = 564
    sceneGroup:insert(loadFriendsGPGServicesScoresBtn)
    
    local loadGPGServicesLeaderboardCategoriesBtn = widget.newButton {
        label = 'Load GPGS Leaderboard Categories',
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 35,
        onRelease = onReleaseLoadGPGServicesLeaderboardCategoriesBtn,
        shape = 'roundedRect',
        width = 600,
        height = 56,
        cornerRadius = 4,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4
    }
    loadGPGServicesLeaderboardCategoriesBtn.x = composerM.contentCenterX
    loadGPGServicesLeaderboardCategoriesBtn.y = 660
    sceneGroup:insert(loadGPGServicesLeaderboardCategoriesBtn)
    
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
        inputTxtField = native.newTextField( composerM.contentCenterX, 180, 580, 56 )
        inputTxtField.font = native.newFont(native.systemFont, 30)
        inputTxtField:setTextColor(0, 0, 0)
        inputTxtField.align = 'left'
        inputTxtField.hasBackground = false
        inputTxtField.placeholder = 'Input mock score data'
        inputTxtField:addEventListener( 'userInput', onUserInputTxtField )
    end
end

function scene:hide(e)
--    local sceneGroup = self.view
    if (e.phase == 'will') then
    	inputTxtField:removeEventListener( 'userInput', onUserInputTxtField )
        inputTxtField:removeSelf()
        inputTxtField = nil
    elseif (e.phase == 'did' ) then
        -- Called immediately after scene goes off screen.
    end
end

function scene:destroy(e)
    print('[SceneScoreLeaderboardMenu] !!!!!!!!!!! destroy called !!!!!!!!!!!')
end

-- Scene Listener setup
scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene