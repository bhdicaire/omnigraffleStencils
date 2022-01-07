-- export all layers to image files
-- Copyright (c) 2011, Charles-Axel Dein

-- Settings
property exportFileExtension : "png"
property ADD_CANVAS_NUMBER : true
-- End of Settings

on file_exists(FileOrFolderToCheckString)
	try
		alias FileOrFolderToCheckString
		return true
	on error
		return false
	end try
end file_exists

tell application "OmniGraffle Professional 5"
	set theDocument to front document
	set _path to path of theDocument
	
	set area type of current export settings to current canvas
	set draws background of current export settings to false
	set include border of current export settings to false
	
	
	-- Get filename without extension
	tell application "Finder"
		set {theFilename, _extension, _ishidden} to the Â
			{displayed name, name extension, extension hidden} Â
				of ((the _path as POSIX file) as alias)
	end tell
	if (_extension ­ missing value) then
		set theFilename to texts 1 thru -((length of _extension) + 2) of theFilename
	end if
	
	set export_folder to (choose folder with prompt "Pick the destination folder") as string
	set export_folder to export_folder & theFilename & ":"
	
	-- Create folder if does not exist, remove it otherwise
	-- Shell script should not be executed inside tell application block
	tell me
		if file_exists(export_folder) of me then
			try
				display alert "The file already exists. Do you want to replace it?" buttons {"Cancel", "Erase"} cancel button 1
			on error errText number errNum
				if (errNum is equal to -128) then
					return
				end if
			end try
			
			-- Delete the folder
			do shell script "rm -rf " & quoted form of POSIX path of export_folder
			
		else
			-- Create the folder
			do shell script "mkdir -p " & quoted form of POSIX path of export_folder
		end if
	end tell
	
	set canvasCount to count of canvases of theDocument
	
	set canvasNumber to 1
	repeat with theCanvas in every canvas of theDocument
		-- Activate the canvas
		set canvas of front window to theCanvas
		set canvas_name to name of theCanvas
		set layerCount to count of layers of theCanvas
		
		-- Prepare filename
		set canvasFilename to ""
		set canvasFilename to ""
		if ADD_CANVAS_NUMBER then
			set canvasFilename to canvasNumber & "- "
		end if
		set canvasFilename to canvasFilename & canvas_name
		
		-- Hide all layers, except those beginning with "*"
		-- also check if there is only one layer to be exported
		repeat with layerNumber from 1 to layerCount
			set theLayer to layer layerNumber of theCanvas
			set number_of_layer_to_be_exported to 0
			
			if theLayer is prints and class of theLayer is not shared layer then
				set layer_name to name of theLayer as string
				if character 1 of layer_name is not "*" then
					set visible of theLayer to false
					set number_of_layer_to_be_exported to number_of_layer_to_be_exported + 1
				else
					set visible of theLayer to true
				end if
			end if
		end repeat
		
		-- Export each layer
		repeat with layerNumber from 1 to layerCount
			set theLayer to layer layerNumber of theCanvas
			
			if (theLayer is prints) and (class of theLayer is not shared layer) then
				set layer_name to name of theLayer as string
				set filename to canvasFilename & " - " & layer_name & "." & exportFileExtension
				set exportFilename to export_folder & filename
				
				-- show the layer, export, then hide the layer
				if character 1 of layer_name is not "*" then
					set visible of theLayer to true
					save theDocument in file exportFilename
					set visible of theLayer to false
				end if
				
			end if
			
		end repeat
		
		set canvasNumber to canvasNumber + 1
		
	end repeat
end tell
