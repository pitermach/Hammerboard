#Introduction
Hammerboard is a small configuration for the Mac OS automation program called [Hammerspoon](http://www.hammerspoon.org/) which allows you to quickly play sounds just by pressing 2 keys. It could be useful in a broadcast environment to play radio jingles or to play sound effects during a voice chat (this is the main reason why I built it). Hammerboard is optimized for Mac OS assistive technologies like VoiceOver and will provide some speech feedback when switching folders. Other than the menu bar icon used to switch audio devices there is currently no other graphics in this configuration.

#installation
download Hammerspoon and drag it to your applications folder. Run it at least once so that it generates its configuration folder. 

To install Hammerboard, you will need the hammerboard.lua file, as well as init.lua if you have never used hammerspoon. Copy both or either of the 2 into ~/.hammerspoon folder (you will need to press command-shift-G and paste in the path if you are doing this with Finder as it's a hidden folder). 

If you copied the included init.lua, then you can simply click the hammerspoon icon in the menu bar and choose the "Reload Config" option. 

If you already have an init.lua file with existing configurations, you can edit it to run hammerboard.lua (I personally do it using the dofile "hammerboard.lua" command).

#Usage

Hammerboard looks for its sounds in the sounds folder under your hammerspoon directory (~/.hammerspoon/sounds/). If this folder is missing, you will get an error message and it will be created for you. To add sounds, create a subfolder and give it a name that will help you know what kind of sounds are in it (IE, ~/.hammerspoon/sounds/simpsons) and copy any sounds that you want to use in. The sounds can be any format supported by Mac OS (wav, mp3, m4a, aac, etc). The filename determins the key that will activate the sound

For your filenames, you can use almost any name listed in [hs.keycodes.map](http://www.hammerspoon.org/docs/hs.keycodes.html#map) with the exception of left, right and escape (more keys may be reserved in the future)

After putting in a sound, you will need to reload your hammerspoon configuration.

To play a sound, press CTRL-Shift-P. You will hear an announcement telling you what folder the sounds will be played from, either with VoiceOver if it's running or the standard speech synthesizer if it isn't. You can then press any key to play its sound, the right and left arrow to choose a different folder or escape to abort without playing a sound. At any time, you can press CTRL-Shift-S to stop any playing sounds.

Finally, you can select what audio device the sounds will be played from. Hammerboard will make a new "audio device switcher" menu bar icon and you can simply click it to select a different device. The device you select is saved across restarts. This feature is designed to allow you to use hammerboard in conjunction with another program to send the audio to your voice chat/broadcasting application, such as SoundFlower or Loopback.
