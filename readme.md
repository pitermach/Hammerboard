# Introduction
Hammerboard is a spoon for the Mac OS automation program called [Hammerspoon](http://www.hammerspoon.org/) which allows you to quickly play sounds just by pressing 2 keys. It could be useful in a broadcast environment to play radio jingles or to play sound effects during a voice chat (this is the main reason why I built it). Hammerboard is optimized for Mac OS assistive technologies like VoiceOver and will provide some speech feedback when switching folders. Other than the menu bar icon used to switch audio devices there is currently no other graphics in this configuration.

# installation
First, download and install Hammerspoon. You can do so either [from their Github](https://github.com/Hammerspoon/hammerspoon/releases/latest), or if you have it installed, through homebrew simply by running "brew install Hammerspoon" in the terminal. Once you have it installed, run it, and follow the prompts to grant accessibility permissions (I also choose to hide the app from the dock here so it stays out of your command-tab switcher)

Once Hammerspoon is installed and configured, navigate into the folder where you cloned this repository with Finder or another file manager, and open "Hammerboard.spoon" which should cause Hammerspoon to install it into the right place. Finally, from the Hammerspoon menu extra select the open configuration option which should open your default text editor with your init.lua file. To have Hammerspoon run HammerBoard, add these 2 lines:

```lua
hs.loadSpoon("Hammerboard")
spoon.Hammerboard:start()
```

Save the file, return to the Hammerspoon menu extra but this time click the reload configuration option for your new changes to take effect. And this should be all there is to it!


# Usage

Hammerboard looks for its sounds in a Hammerboard/sounds directory in your user's Home folder. If this folder is missing, you will get an error message and it will be created for you. To add sounds, create a subfolder and give it a name that will help you know what kind of sounds are in it (IE, Hammerboard/sounds/simpsons) and paste any sounds that you want to use. The sounds can be any format supported by Mac OS (wav, mp3, m4a, aac, etc). The filename determins the key that will activate the sound

For your filenames, you can use almost any name listed in [hs.keycodes.map](http://www.hammerspoon.org/docs/hs.keycodes.html#map) with the exception of left, right and escape (more keys may be reserved in the future)

After putting in a sound, you will need to reload your hammerspoon configuration.

To play a sound, press CTRL-Shift-P. You will hear an announcement telling you what folder the sounds will be played from, either with VoiceOver if it's running or your default Mac OS voice if it isn't. You can then press any key to play its sound, the right and left arrow to choose a different folder or escape to abort without playing a sound. At any time, you can press CTRL-Shift-S to stop any playing sounds.

Finally, you can select what audio device the sounds will be played from. Hammerboard will make a new "audio device switcher" menu bar icon and you can simply click it to select a different device. The device you select is saved across restarts. This feature is designed to allow you to use hammerboard in conjunction with another program to send the audio to your voice chat/broadcasting application, such as Blackhole or Loopback.
