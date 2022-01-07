-- export all files opened in Omnigraffle to PDF
-- Copyright (c) 2011, Charles-Axel Dein

-- Settings
property exportFileExtension : "pdf"
-- End of Settings

tell application "OmniGraffle Professional 5"
	set export_folder to (choose folder with prompt "Pick the destination folder") as string
	
	set area type of current export settings to entire document
	set draws background of current export settings to false
	
	repeat with theWindow in windows
		set theDocument to document of theWindow
		log "In window " & name of theWindow
		
		-- check if this a true document
		set hasDocument to true
		try
			set theFilename to name of theDocument
		on error
			set hasDocument to false
		end try
		
		if hasDocument then
			set exportFilename to export_folder & theFilename & "." & exportFileExtension
			log "Exporting " & theFilename
			save theDocument in exportFilename
		end if
		
	end repeat
	
end tell