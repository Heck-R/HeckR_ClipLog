# HeckR_ClipLog

HeckR_ClipLog is not only a log as it's name would suggest, but a full fledged clipboard manager which can be controlled through hotkeys.

## Functionality & Usage

In HeckR_ClipLog there are 2 types of clipboard groups

### 1. Standard clipboard history

Here you can navigate through your clipboard history, since everything you copy is saved here

The clips are numbered in the history (0 is the latest, and the number increases as you go further back)

#### Hotkeys

Change clipboard content, while moving across the history, and showing the preview of the clip ([note](#Previews))

- **Win + (LeftArrow / LeftClick / MouseForward / ScrollDown)**: Go one position back in the history
- **Win + (RightArrow / RightClick / MouseBackward / ScrollUp)**: Go one position forward in the history
- **Win + (UpArrow / DownArrow / MiddleMouseButton)**: Only show the preview of the current clip
- **Win + \<Any number\>**: Go to the clip with the number pressed

In some cases you might want to reuse the few latest clips, but you dont want to switch to them before copying. In this case, you can just instant copy them

- **Win + Alt + \<Any number\>**: Instantly paste the clip from the history without changing the content on the clipboard ([note](#Instant-paste-delay))

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

### 2. Quick clipboard

Here you can distinguish a few dedicated clips from the others, so they will not get buried in history

There are 10 quick clip slots available (0-9)

#### Hotkeys

- **Win + Shift + Ctrl + \<Any number\>**: Save the current clipboard data to the the quick clip at the position of the number you pressed
- **Win + Shift + Ctrl + Alt + \<Any number\>**: Delete the clipboard data to the the quick clip at the position of the number you pressed ([note](#Microsoft's-Office-hotkey-interference))
- **Win + Ctrl + \<Any number\>**: Open a preview of the quck clip at the position of the number you pressed
- **Win + Ctrl + Alt + \<Any number\>**: Instant paste the quck clip at the position of the number you pressed (without adding it to the history) ([note](#Instant-paste-delay))

### Notes

#### Previews

Any kind of preview of message will open via a tooltip below the cursor (or if that's not possible, then at the top of the screen), and it remains open as long as you hold down the modifier keys needed for the hotkey you used (modifier keys include: Win, Shift, Ctrl, Alt)

#### Instant paste delay

There is a normally unnoticable delay before you can do something again, which is due to this functionallity should not really be possible, thus it uses a little workaround

#### Microsoft's Office hotkey interference

Microsoft recently put an inbuilt hotkey into Windows, which you have to manually disable if you do not wish to have MS Office pop up every time. You can find some information about this on the following page: [HowToGeek - How to Remap the Office Key on Your Keyboard](https://www.howtogeek.com/445318/how-to-remap-the-office-key-on-your-keyboard/)  
The method I recommend is using the `REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32` command in your PowerShell console.

#### Responsibility
Only use or do anything at your own risk. I do not take responsibility for any damage which occours from using or following anything here in any way, shape or form

#### Key namings

##### MiddleMouseButton

Clicking on the mouse wheel

##### MouseForward

On better / gaming mouses there are usually 2 extra buttons at the thumb. This is usually the one closer to the user

##### MouseBackward

On better / gaming mouses there are usually 2 extra buttons at the thumb. This is usually the one further from the user

## Dependencies

All of the dependencies can be found in the following repository: [HeckR_AUH-Lib](https://github.com/Heck-R/HeckR_AUH-Lib)  
Some of these might be 3rd party scripts. The original authors and sources are linked in the repository provided above

- GDIP_All.ahk
- GDIPHelper.ahk
