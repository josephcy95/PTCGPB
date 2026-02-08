#NoEnv
#SingleInstance Force
SetWorkingDir, %A_ScriptDir%

configsDir := A_ScriptDir . "\Configs"
settingsPath := A_ScriptDir . "\Settings.ini"

FileCreateDir, %configsDir%

Gui, Add, DropDownList, vConfigChoice w320, % BuildConfigList()
Gui, Add, Button, w100 gSaveConfig, Save Config
Gui, Add, Button, x+10 w100 gLoadConfig, Load Config
Gui, Add, Button, x+10 w100 gDeleteConfig, Delete Config
Gui, Show,, Config Switcher
Return

SaveConfig:
InputBox, newName, Save Config, Enter a name for this config:
if ErrorLevel
    Return
newName := Trim(newName)
if (newName = "")
    Return
if (SubStr(newName, StrLen(newName) - 3) = ".ini")
    newName := SubStr(newName, 1, StrLen(newName) - 4)
if (newName = "")
    Return
if !FileExist(settingsPath)
{
    MsgBox, 48, Save Config, Settings.ini not found.
    Return
}
destPath := configsDir . "\" . newName . ".ini"
if FileExist(destPath)
{
    MsgBox, 4, Save Config, A config named "%newName%" already exists.`nOverwrite it?
    IfMsgBox, No
        Return
}
FileCopy, %settingsPath%, %destPath%, 1
GuiControl,, ConfigChoice, % BuildConfigList()
Return

LoadConfig:
GuiControlGet, ConfigChoice
if (ConfigChoice = "Select Config")
    Return
srcPath := configsDir . "\" . ConfigChoice . ".ini"
if !FileExist(srcPath)
{
    MsgBox, 48, Load Config, Selected config was not found.
    Return
}
MsgBox, 4, Load Config, This will overwrite Settings.ini.`nSave first if needed.`nContinue?
IfMsgBox, No
    Return
FileCopy, %srcPath%, %settingsPath%, 1
Return

DeleteConfig:
GuiControlGet, ConfigChoice
if (ConfigChoice = "Select Config")
    Return
delPath := configsDir . "\" . ConfigChoice . ".ini"
if !FileExist(delPath)
{
    MsgBox, 48, Delete Config, Selected config was not found.
    Return
}
MsgBox, 4, Delete Config, Delete "%ConfigChoice%"?
IfMsgBox, No
    Return
FileDelete, %delPath%
GuiControl,, ConfigChoice, % BuildConfigList()
Return

BuildConfigList()
{
    global configsDir
    list := "Select Config||"
    Loop, Files, %configsDir%\*.ini
    {
        SplitPath, A_LoopFileFullPath,,,, nameNoExt
        list .= nameNoExt . "|"
    }
    return list
}

GuiClose:
ExitApp
