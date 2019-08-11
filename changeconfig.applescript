on run argv
	tell application "System Preferences"
		quit
	end tell
	delay 5
	tell application "System Preferences"
		reveal pane "Network"
		activate
		tell application "System Events"
			tell process "System Preferences"
				tell window 1
					delay 2
					-- select the specified row in the service list 
					repeat with r in rows of table 1 of scroll area 1
						if (value of attribute "AXValue" of static text 1 of r as string) contains "vpn" then
							select r
						end if
					end repeat
					-- set the address & username / account name
					-- note that this is vpn specific
					tell group 1
						set focused of text field 1 to true
						keystroke " "
						set value of text field 1 to (item 1 of argv)
					end tell
					click button "Apply"
					tell group 1
						click button "Connect"
					end tell
					delay 5
				end tell
			end tell
		end tell
		quit
	end tell
end run