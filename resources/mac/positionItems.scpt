on run argv
tell application "Finder" 
	set f to POSIX file (item 1 of argv as string) as alias
		tell folder f
		   open
		   tell container window
	              set toolbar visible to false
	              set statusbar visible to false
	              set current view to icon view
		      delay 1
	              set the bounds to {50, 100, 1000, 1000}
	           end tell
	           delay 1
	           set icon size of the icon view options of container window to 128
	           set arrangement of the icon view options of container window to not arranged
	           set background picture of the icon view options of container window to file ".background:background.png"
	           set position of item "@APPNAME@.app" to {150, 140}
	           set position of item "Applications" to {410, 140}
	           set the bounds of the container window to {50, 100, 600, 400}
	           update without registering applications
	           delay 5
	           close
		end tell
		delay 5
	end tell
end run