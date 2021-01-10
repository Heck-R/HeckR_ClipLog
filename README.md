# HeckR_ClipLog

HeckR_ClipLog is not only a log as it's name would suggest, but a full fledged clipboard manager which can be controlled through hotkeys.

# Functionallity & Usage

In HeckR_ClipLog there are 2 types of clipboard groups

## 1. Standard clipboard history

Here you can navigate through your clipboard history, since everything you copy is saved here

The clips are numbered in the history (0 is the latest, and the number increases as you go further back)

### Hotkeys

Change clipboard content, while moving across the history, and showing the preview of the clip ([note](#Previews))

- **Win + (LeftArrow / LeftClick / MouseForward / ScrollDown)**: Go one position back in the history
- **Win + (RightArrow / RightClick / MouseBackward / ScrollUp)**: Go one position forward in the history
- **Win + (UpArrow / DownArrow / MiddleMouseButton)**: Only show the preview of the current clip ([note](#Preview-of-current-clip))
- **Win + \<Any number\>**: Go to the clip with the number pressed

In some cases you might want to reuse the few latest clips, but you dont want to switch to them before copying. In this case, you can just instant copy them

- **Win + Alt + \<Any number\>**: Instantly paste the clip from the history without changing the content on the clipboard ([note](#Instant-paste-delay))

While the default purpose of the history is what its name suggests (containing the history), there are a few other ways available to add clips to the history

- **Win + Shift + Enter**: A small window pops up, where you can enter some text you wish to save to the history. If you press the OK button, the text will be copied to the clipboard and will be saved to the history. (Note, that there is no autosave, thus the content inside the windows will only be saved if you press the OK button)
- **Win + Shift + \<Any number\>**: Add the quickClip indexed with the pressed number (if it exists) to the history and put it on the clipboard

It is also possible to delete clips from the history, which can be useful in case there is some sensitive data on them, or a few large clips take up too much space etc. When a clip in the history gets deleted all of the older clips' indexes become one less. This also applies to the selected clip  
___For example___: if we delete index 2, the old index 3 will become the new index 2, the old index 4 will become the new index 3 and so on...

- **Win + Shift + Alt + (LeftArrow / LeftClick / MouseForward)**: Delete the older neighbour of the currently selected clip (if it exists)  
  - ___For example___: If the currently selected clip is the one indexed with 3 then the clip indexed with 4 will be deleted
- **Win + Shift + Alt + (RightArrow / RightClick / MouseBackward)**: Delete the younger neighbour of the currently selected clip (if it exists)  
  - ___For example___: If the currently selected clip is the one indexed with 3 then the clip indexed with 2 will be deleted. The selected clip will remain the same, but its index is being lowered by one since it is one index younger now (it becomes the new index 2)
- **Win + Shift + Alt + (DownArrow / UpArrow / MiddleMouseButton)**: Delete the currently selected clip (if there is one selected)  
  - ___For example___: If the currently selected clip is the one indexed with 3 then it will be deleted and the selected clip will be modified in one of the following ways
    -  If the ___DownArrow___ or the ___MiddleMouseButton___ was used:  
    The selected clip will still be on the same index, thus it becomes the deleted clip's older neighbour (so its content chages but it remains index 3)
    -  If the ___UpArrow___ was used:  
    The selected clip will become the deleted clip's younger neighbour along with its index (so basically we select index 2)
- **Win + Shift + Alt + \<Any number\>**: Delete the clip with the same index as the number which is being pressed (if it exists)  
  - ___For example___: If the pressed number is 3, then the clip indexed with 3 will be deleted. The selected clip will shift accordingly
    - If the selected clip's index is < 3: It will remain the same
    - If the selected clip's index is > 3: It will remain the same and it's index will lower with 1
    - If the selected clip's index is = 3: It will change to the clip with 1 less index (2 in this case)

## 2. Quick clipboard

Here you can distinguish a few dedicated clips from the others, so they will not get buried in history

### Quick Clip Tables

Quick clip tables are a collection of 10 dedicated quick clip slots, that can be used to store clipboard data

There are 2 types of quick clip tables:
- **Numbered**  \
  There are 10 numbered quick clip tables by default (0-9)  \
  These are always available without any additional prior configuration
- **Named (custom)**  \
  In addition, there are a custom number of named quick clip tables based on the configuration file (for details, see the [Settings](#Settings))  \
  Regardless of the configuration, one named quick clip table is always available, called `default`  \
  As its name suggests, the default table is selected on startup

### Hotkeys

- **Shift + Alt + \<Any number\>**: Change to the associated quick clip table
- **Shift + Alt + Tab**: Step through the named quick clip tables (for details, see the `customQuickClipTables` key under the [Settings](#Settings))
- **Win + Shift + Ctrl + \<Any number\>**: Save the current clipboard data to the quick clip at the position of the number you pressed
- **Win + Shift + Ctrl + Enter**: A small window pops up, where you can enter some text you wish to save to one of the quickClip slots. You can select the quickClip slot by selecting a number in the dropdown list at the bottom right (0 by default). If you press the OK button, the text will be saved to the selected quickClip slot. (Note, that there is no autosave, thus the content inside the windows will only be saved if you press the OK button)
- **Win + Shift + Ctrl + Alt + \<Any number\>**: Delete the clipboard data to the the quick clip at the position of the number you pressed ([note](#Microsoft's-Office-hotkey-interference))
- **Win + Ctrl + \<Any number\>**: Open a preview of the quick clip at the position of the number you pressed
- **Win + Ctrl + Alt + \<Any number\>**: Instant paste the quck clip at the position of the number you pressed (without adding it to the history) ([note](#Instant-paste-delay))

## Additional functionallities

### Hotkeys

- **Win + Shift + L**: Turns on/off the logging of the clipboard and the other hotkeys of this script (a tooltip shows wether the functionallities are turned on or off). When turning it back on, anything on the clipboard is deleted, and if there was a selected clip in the history before turning the script off, the clipboard resets to that clip (the previous position in the history is also being retained)
- **Win + H**: Shows a helping tooltip about all of the availbale hotkeys

# Settings

There are a few configuration options available for this script. All of these must be located in a configuration ini with the same name as the script (HeckR_ClipLog.ini)

As the extension suggests, the configuration file must be in `.ini` format  \
Every setting must be placed under the `settings` section

The existence of the configuration ini is semi-mandatory  \
While it is not necessary to configure anything for the script to be functional, the configuration file will be created on the script's startup if it does not exist

## Keys

- **maxNumberOfClipFiles**  \
  *Description*: The maximum number of clip files to store in the history  \
  *Format*: `Integer`  \
  *Default*: `1000`

- **customQuickClipTables**  \
  *Description*: A list of custom quick clip table names to be available  \
  *Format*: A comma separated string  \
  *Default*: \<empty string\>

# Notes

## Previews

Any kind of preview of message will open via a tooltip below the cursor (or if that's not possible, then at the top of the screen), and it remains open as long as you hold down the modifier keys needed for the hotkey you used (modifier keys include: Win, Shift, Ctrl, Alt)

## Preview of current clip

While the UpArrow, DownArrow and the MiddleMouseButton can usually be used interchangeably for previewing the current clip, there is a slight difference in functionallity

- DownArrow: Nothing is loaded, the preview is created from the actual clipboard data
- UpArrow and MiddleMouseButton: Before the preview is created, the clip data is loaded from the file with the current index. This is usually unnecessary, but there is an [exception](#Loading-back-the-last-saved-clip-after-starting-HeckR_ClipLog)

## Instant paste delay

There is a normally unnoticable delay before you can do something again, which is due to this functionallity should not really be possible, thus it uses a little workaround

## Loading back the last saved clip after starting HeckR_ClipLog

The intended use of this script is having it automatically started my windows, but in this case it is not possible to automatically load the last clip, since windows locks the files until the user logs in. This means that even if there is a clip in the history with the current index, it is not loaded yet. This is automatically fixed if something is being copied, or any functionallity is being used which loads a clip

## Microsoft's Office hotkey interference

Microsoft recently put an inbuilt hotkey into Windows, which you have to manually disable if you do not wish to have MS Office pop up every time. You can find some information about this on the following page: [HowToGeek - How to Remap the Office Key on Your Keyboard](https://www.howtogeek.com/445318/how-to-remap-the-office-key-on-your-keyboard/)

The method I recommend is using the `REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32` command in your PowerShell console.

## Responsibility
Only use or do anything at your own risk. I do not take responsibility for any damage which occours from using or following anything here in any way, shape or form

## Key namings

### MiddleMouseButton

Clicking on the mouse wheel

### MouseForward

On better / gaming mouses there are usually 2 extra buttons at the thumb. This is usually the one closer to the user

### MouseBackward

On better / gaming mouses there are usually 2 extra buttons at the thumb. This is usually the one further from the user

# Dependencies

If you wish to use / play around with the scripts instead of the built version, you need some dependencies  
All of the dependencies can be found in the following repository: [HeckR_AUH-Lib](https://github.com/Heck-R/HeckR_AUH-Lib)

The dependencies should be placed anywhere where they can be imported using the angle bracket syntax (e.g.: \<modulname\>). One possibility is to put them directly inside a folder named "Lib" next to the main script (HeckR_ClipLog.ahk)

Some of these might be 3rd party scripts. The original authors and sources are linked in the repository provided above

- AutoXYWH.ahk
- GDIP_All.ahk
- GDIPHelper.ahk
- HeckerFunc.ahk

# Donate

I'm making tools like this in my free time, but since I don't have much of it, I can't give all of them the proper attention.

If you like this tool, you consider it useful or it made you life easier, please do not hesitate to thank/encourage me to continue working on it with any amount you see fit. (You know, buy me a cup of coffee / gallon of lemonade / 5-course gourmet dish / whatever you think I deserve 🙂)

<a href="https://www.paypal.com/paypalme/HeckR9000">
    <img 
        width="200px"
        src="https://gist.githubusercontent.com/Heck-R/20e9c45c2242467a028c107929187789/raw/cde2167d941416815d0e6f90638d85e2f289c988/donate.svg">
</a>
