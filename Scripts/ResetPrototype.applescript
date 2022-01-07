-- shows some layers, hides others to set the prototype to its blank state
-- Copyright (c) 2011, Charles-Axel Dein

-- Settings
property settingsFirstScreenName : "First screen" -- case insensitive 
property settingsFirstScreenPrefix : "1"
property settingsAlwaysVisibleLayerPrefix : "*"
-- End of Settings

tell application "OmniGraffle Professional 5"
	set theWindow to front window
	set theDocument to document of theWindow
	
	set canvasCount to count of canvases of theDocument
	
	repeat with canvasNumber from 1 to canvasCount
		set theCanvas to canvas canvasNumber of theDocument
		set layerCount to count of layers of theCanvas
		set couldBeShownLayersCount to 0
		set firstScreenIsPresent to false
		
		repeat with layerNumber from 1 to layerCount
			set theLayer to layer layerNumber of theCanvas
			set layerName to name of theLayer as string
			
			-- non-printable layers should be hidden
			if theLayer is not prints then
				
				set visible of theLayer to false
				
				-- shared layers should always be shown
			else if class of theLayer is shared layer or (character 1 of layerName is settingsAlwaysVisibleLayerPrefix) Â
				then
				
				set visible of theLayer to true
				
				-- first screen should be shown
			else if (character 1 of layerName is settingsFirstScreenPrefix) or (layerName is settingsFirstScreenName) then
				
				set visible of theLayer to true
				set firstScreenIsPresent to true
				
				-- all remaining layers should be hidden
			else
				
				set couldBeShownLayersCount to couldBeShownLayersCount + 1
				set couldBeShownLayer to theLayer
				
				set visible of theLayer to false
			end if
		end repeat
		
		-- if there's only one layer that could be shown, then we show it
		if (couldBeShownLayersCount = 1) and (firstScreenIsPresent is false) then
			set visible of couldBeShownLayer to true
		end if
	end repeat
end tell
