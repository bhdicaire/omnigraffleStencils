-- export all layers to image files
-- Copyright (c) 2011, Charles-Axel Dein

-- Settings
property exportFileExtension : "png"
property CANVAS_ORIGIN = {200, 220}
property CANVAS_SIZE = {1024, 748} -- this is landscape orientation
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
	set theWindow to front window
	set theDocument to document of theWindow
	set theFilename to name of theDocument
	-- remove .graffle
	set theFilename to texts 1 thru ((offset of "." in theFilename) - 1) of theFilename
	
	set export_folder to (choose folder with prompt "Pick the destination folder") as string
	set export_folder to export_folder & theFilename & ":"
	
	-- create folder
	if file_exists(export_folder) of me then
		try
			display alert "The file already exists. Do you want to replace it?" buttons {"Cancel", "Erase"} cancel button 1
		on error errText number errNum
			if (errNum is equal to -128) then
				return
			end if
		end try

		-- deletes the folder (necessary because some layers may have been renamed
		do shell script "rm -rf " & quoted form of POSIX path of export_folder

	else
		-- creates the folder
		do shell script "mkdir -p " & quoted form of POSIX path of export_folder
	end if
	
	set canvasCount to count of canvases of theDocument
	
	set i to 0
	repeat with canvasNumber from 1 to canvasCount
		set theCanvas to canvas canvasNumber of theDocument
		set canvas_name to name of theCanvas
		set canvas of theWindow to theCanvas
		set layerCount to count of layers of theCanvas
		
		-- hide all layers, except those beginning with "*"
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
		
		set area type of current export settings to manual region
		set draws background of current export settings to false
		set include border of current export settings to false
		set origin of current export settings to CANVAS_ORIGIN
		set size of current export settings to CANVAS_SIZE

		set canvas_filename to ""
		if ADD_CANVAS_NUMBER then
			set canvas_filename to canvasNumber & "- "
		end if
		set canvas_filename to canvas_filename & canvas_name
		
		repeat with layerNumber from 1 to layerCount
			set theLayer to layer layerNumber of theCanvas
			
			if (theLayer is prints) and (class of theLayer is not shared layer) then
				set layer_name to name of theLayer as string
				set filename to canvas_filename & " - " & layer_name & "." & exportFileExtension
				set export_filename to export_folder & filename
				
				-- show the layer, export, then hide the layer
				if character 1 of layer_name is not "*" then
					set visible of theLayer to true
					save theDocument in export_filename
					set visible of theLayer to false
				end if
				
			end if
			
		end repeat
		
	end repeat
end tell

