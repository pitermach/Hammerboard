Hammerboard={}
Hammerboard.name="Hammerboard"
Hammerboard.author="Pitermach"
Hammerboard.version=1.1


require ("hs.osascript", "hs.sound", "hs.audiodevice", "hs.fs", "hs.hotkey", "hs.menubar")
local synth=hs.speech.new()
function say(text) --a helper function to speak something with either VoiceOver or speech synthesis if it's not running
	if hs.application.get("VoiceOver") ~=nil then
		
		hs.osascript.applescript("tell application \"VoiceOver\" to output \"" ..text .."\"")
	else --VoiceOver is not running, use speech synthesis
		synth:speak(text)
	end --VoiceOver running check
end --function


local board={}
local counter=0
local loadedSounds={}
local stack=1
local deviceID=""
local devices=hs.audiodevice.allOutputDevices()
local menu={}
local playKey={}
local StopKey={}
function setDevice()
	local deviceUid=hs.audiodevice.findOutputByName(deviceID):uid()
	for i,soundobj in ipairs(loadedSounds) do
		soundobj:device(deviceUid)
	end --for
end --setDevice function


function writeDevice()
	local file=io.open("device.dat", "w")
	file:write(deviceID)
	file:close()
	
end --writeDevice function


function buildMenu()	--Build the menu items for every device
	local menuTable={}
	for i, deviceObj in pairs(devices) do
		
		table.insert(menuTable, {title=deviceObj:name(), fn=nil, checked=false})
		
	end --menu building for loop
	for num, i in pairs(menuTable) do
		if i.title==deviceID then
			i.checked=true
		end --if
		i.fn=function()
			deviceID=hs.audiodevice.findOutputByName(i.title):name()
			setDevice()
			writeDevice()
			
		end --callback function
	end --second menu for loop to set checkmark and callback
	
	return menuTable
end --buildMenu function



function loadSound(path)
	path=hs.fs.pathToAbsolute(path)
	local soundobj=hs.sound.getByFile(path)
	if soundobj~=nil then
		--		print(path.." was loaded.")
		table.insert(loadedSounds, soundobj)
		
		return soundobj
		
	else
		print(path.." failed to load.")
	end --if
end --function

local modals={}
function nextStack()
	stack=stack+1
	if stack<=counter then--it's not out of bounds, so we can switch safely
		modals[stack-1]:exit()
		modals[stack]:enter()
		say(board[stack]["name"])
	else--last stack
		stack=stack-1
		hs.osascript.applescript("beep")--there's no way to get the default system sound in hammerspoon natively
	end --if
end --function
function previousStack()
	stack=stack-1
	if stack>0 then--it's not out of bounds, so we can switch safely
		modals[stack+1]:exit()
		modals[stack]:enter()
		say(board[stack]["name"])
	else--last stack
		stack=1
		hs.osascript.applescript("beep")--there's no way to get the default system sound in hammerspoon natively
	end --if
end --function



function Hammerboard.init()
	file=io.open("device.dat")
	if file==nil then
		deviceID=hs.audiodevice.defaultOutputDevice():name()
		writeDevice()
	else
		deviceID=file:read("a")
		file:close()
	end --if
	if hs.fs.attributes("~/Hammerboard/sounds")==nil then --the sounds folder doesn't exist and should be created.
		hs.fs.mkdir("~/Hammerboard/sounds")
		hs.osascript.applescript("display alert \"Hammerboard error\" message \"You do not have a sounds folder. One has just been created and you can put in subfolders with sounds into it. Consult the readme for details.\" as critical")
		else--load the sounds
			for file in hs.fs.dir("~/Hammerboard/sounds") do
				print("checking ", file)
				if file ~="." and file ~=".." and file ~= ".DS_Store"and hs.fs.attributes("~/Hammerboard/sounds/"..file, "mode")=="directory" then
					counter=counter+1
					board[counter]={["name"]=file, sounds={}}
					--		print(file.." will be loaded.")
				end --Add to the array of folders that will be looped through
			end --for loop checking for folders
			
			for i, currentDirdir in ipairs(board) do
				for file in hs.fs.dir("~/Hammerboard/sounds/"..board[i]["name"]) do
					path="~/Hammerboard/sounds/"..board[i]["name"].."/"..file
					--			print("checking "..path)
					if file ~="." and file ~= ".." and file ~= ".DS_Store" and hs.fs.attributes(path, "mode")=="file" then
						board[i]["sounds"][file]=loadSound(path)
						
					end --if it's a file, load it
				end --loop through files in a folder
			end --loop through folders
			print(#loadedSounds.." sounds in " ..#board.." folders loaded successfully!")
		end --the big if that adds sounds and checks for the sounds folder
		
		for i in ipairs(board) do
			modals[i]=hs.hotkey.modal.new()--make a modal for each folder
			
			for name, soundobj in pairs(board[i]["sounds"]) do--loop through every sound in a folder and bind keys
				keystr=string.gsub(name, "....$", "")
				--				print("binding " .. keystr)
				if keystr ~="left" and keystr~="right" and keystr~="escape" then --don't bind sounds to special keys
					local key=modals[i]:bind({}, keystr, function()
						soundobj:play()
						modals[stack]:exit()end) --inline function for every bound key
						
					end--if loop binding the keys if they're not a special key
				end --for loop for the array
				modals[i]:bind({}, "right", nextStack)
				modals[i]:bind({}, "left", previousStack)
				modals[i]:bind({}, "escape", function()modals[stack]:exit()end)
			end --for loop for the modal creation and setup
			
			menu=hs.menubar.new(false)
			menu:setTitle("audio device switcher")
			menu:setMenu(buildMenu)
			
		end --Init function
		
		function Hammerboard.start()
			setDevice()--make sure it's using a device that was just read from the config
			playKey=hs.hotkey.bind({"ctrl","shift"}, "p", function()modals[stack]:enter()
				say("Play from " ..board[stack]["name"])end)
				stopKey=hs.hotkey.bind({"ctrl","shift"},"s", function()
					for i, soundobj in ipairs(loadedSounds) do
						if soundobj:isPlaying() then
							soundobj:stop()
						end --if it's playing
					end --for loop
				end)
				menu:returnToMenuBar()
				menu:setTitle("audio device switcher")
			end --start function
			
			function Hammerboard.stop()
				menu:removeFromMenuBar()
				playKey:delete()
				stopKey:delete()
			end --stop function
			
			return Hammerboard