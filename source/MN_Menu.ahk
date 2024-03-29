; ==============================================================================
; MENU (MN) =ru= МЕНЮ (MN)
; ==============================================================================
; FileDescription: menu =ru= меню
; FileVersion: 1.0.0.0 2022-07-30 \\ (Major version).(Minor version).(Revision number).(Build number) (year)-(month)-(day)
; Author: kaiu@mail.ru \\ author of code changes 
; ProductName: Keyboard_Switcher_Kaiu \\ included in the product
; OriginalFilename: MN_Menu.ahk \\ What file is this code from
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−


MN_FileLocalization := LS_FileLocalization
MN_Tip := "Keyboard layout switcher KAIU. Version: 1.0.0; Website: kaiu.narod.ru; Avtor: Krutov A. Yu."

Menu, MN_LVSubmenu, Add, quiet, MN_SLV1
Menu, MN_LVSubmenu, Add, medium, MN_SLV2
Menu, MN_LVSubmenu, Add, loudly, MN_SLV3

Menu, MN_LVSubmenu, Uncheck, quiet
Menu, MN_LVSubmenu, Uncheck, medium
Menu, MN_LVSubmenu, Uncheck, loudly
if( LS_SoundLevelAtStartup = 1 )
{
    Menu, MN_LVSubmenu, Check, quiet
    SoundSet, 30
}
if( LS_SoundLevelAtStartup = 2 )
{   
    Menu, MN_LVSubmenu, Check, medium
    SoundSet, 50
}
if( LS_SoundLevelAtStartup = 3 )
{
    Menu, MN_LVSubmenu, Check, loudly  
    SoundSet, 70
}
    

Loop, %A_WorkingDir%\localization\*.ini
{
    fileN := A_LoopFileName
    fileN := SubStr(fileN, 1, StrLen(fileN)-4)
    Menu, MN_LgSubmenu, Add, %fileN%, MN_LGLOAD 
    if( A_LoopFileName = MN_FileLocalization )
        Menu, MN_LgSubmenu, Check, %fileN%     
}

if(A_IsCompiled <> 1) ; if not in an EXE file, then an icon =ru= если не в EXE файле, то иконку
    Menu, tray, icon, icon_ks.ico ; script icon =ru= иконка скрипта
Menu, tray, NoStandard
Menu, tray, Add, Exit, MN_Exit
Menu, tray, Add	
Menu, tray, Add, Reload, MN_Reload
Menu, tray, Add	

Menu, tray, Add, Show tooltip, MN_Show_tooltip
if( LS_ShowToolTip = 1) 
{
    Menu, tray, Check, Show tooltip
}
Else
{
    Menu, tray, Uncheck, Show tooltip
}

Menu, tray, Add, Sound for switching layouts, MN_Sound_for_switching_layouts
if( LS_PlaySound = 1) 
    Menu, tray, Check, Sound for switching layouts
Else
    Menu, tray, Uncheck, Sound for switching layouts

Menu, tray, Add, Sound level at startup, :MN_LVSubmenu
Menu, tray, Add	
Menu, tray, Add, Language, :MN_LgSubmenu
Menu, tray, Add, Hotkeys..., MN_Hotkeys
Menu, tray, Add, Help file..., MN_HelpFile
Menu, tray, Add
MN_L11 := "Settings: " LS_SETTINGSINI 
Menu, tray, Add, %MN_L11%, MN_Settings
Menu, tray, Add
Menu, tray, Add, Stop\Start, MN_Stop_Start
Menu, tray, Tip, %MN_Tip%

MN_Load_INI( MN_FileLocalization )

return

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_SLV1:
    LS_SoundLevelAtStartup := 1
    Gosub MN_SLV1_3
return

MN_SLV1_3:
    IniWrite, %LS_SoundLevelAtStartup%, %LS_SETTINGSINI%, MAIN, SoundLevelAtStartup
    Menu, MN_LVSubmenu, Uncheck, %MN_L1%
    Menu, MN_LVSubmenu, Uncheck, %MN_L2%
    Menu, MN_LVSubmenu, Uncheck, %MN_L3%
    if( LS_SoundLevelAtStartup = 1 )
    {
        Menu, MN_LVSubmenu, Check, %MN_L1%
        SoundSet, 30
    }
    if( LS_SoundLevelAtStartup = 2 )
    {
        Menu, MN_LVSubmenu, Check, %MN_L2%
        SoundSet, 50
    }
    if( LS_SoundLevelAtStartup = 3 )
    {
        Menu, MN_LVSubmenu, Check, %MN_L3%
        SoundSet, 70
    }
return

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_SLV2:
    LS_SoundLevelAtStartup := 2
    Gosub MN_SLV1_3
return

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_SLV3:
    LS_SoundLevelAtStartup := 3
    Gosub MN_SLV1_3
return



; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_LGLOAD:
    LS_FileLocalization := A_ThisMenuItem ".ini"
    IniWrite, %LS_FileLocalization%, %LS_SETTINGSINI%, MAIN, FileLocalization
    Reload
return

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_Exit:
    ExitApp
return

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_Reload:
    Reload
return

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_Show_tooltip:
    if( LS_ShowToolTip = 1 )
        LS_ShowToolTip := 0
    Else
        LS_ShowToolTip := 1
        
    IniWrite, %LS_ShowToolTip%, %LS_SETTINGSINI%, MAIN, ShowToolTip
        
    if( LS_ShowToolTip = 1)
        Menu, tray, Check, % MN_L6
    Else
        Menu, tray, Uncheck, % MN_L6
return

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_Sound_for_switching_layouts:
    if( LS_PlaySound = 1 )
        LS_PlaySound := 0
    Else
        LS_PlaySound := 1
        
    IniWrite, %LS_PlaySound%, %LS_SETTINGSINI%, MAIN, PlaySound 
    
    if( LS_PlaySound = 1) 
        Menu, tray, Check, % MN_L7
    Else
        Menu, tray, Uncheck, % MN_L7
return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_Hotkeys:
    FileHKName := "Hotkeys.txt"
    FileDelete, %FileHKName%
    txtF := ""
    if(LS_CapsLockOption >= 1 and LS_CapsLockOption <= 8 )
    {
        Nlay := LS_CapsLockOption 
        list := ""
        cnt := LS_ListL%Nlay%_Count
        Loop, %cnt%
        {
            if( Trim(LS_ListL%Nlay%[A_Index]) <> "" )
            {
                if(list <> "")
                    list := list "; "
                strHKL := Trim(LS_ListL%Nlay%[A_Index])
                idx := Format( "{:d}", KL_Index%strHKL%)
                list := list KL_LNAME%idx%
            }
        }
        txtF:= txtF "CapsLock = switch layouts: " list "`n"
    }
    else
    {
        txtF:= txtF "CapsLock = " LS_CapsLockOption "`n"
    }
    
    
    
    if(LS_LShiftOption >= 1 and LS_LShiftOption <= 8 )
    {
        Nlay := LS_LShiftOption 
        list := ""
        cnt := LS_ListL%Nlay%_Count
        Loop, %cnt%
        {
            if( Trim(LS_ListL%Nlay%[A_Index]) <> "" )
            {
                if(list <> "")
                    list := list "; "
                strHKL := Trim(LS_ListL%Nlay%[A_Index])
                idx := Format( "{:d}", KL_Index%strHKL%)
                list := list KL_LNAME%idx%
            }
        }
        txtF:= txtF "LShift   = switch layouts: " list "`n"
    }
    else
    {
        txtF:= txtF "LShift   = " LS_LShiftOption "`n"
    }
    
    
    if(LS_RShiftOption >= 1 and LS_RShiftOption <= 8 )
    {
        Nlay := LS_RShiftOption 
        list := ""
        cnt := LS_ListL%Nlay%_Count
        Loop, %cnt%
        {
            if( Trim(LS_ListL%Nlay%[A_Index]) <> "" )
            {
                if(list <> "")
                    list := list "; "
                strHKL := Trim(LS_ListL%Nlay%[A_Index])
                idx := Format( "{:d}", KL_Index%strHKL%)
                list := list KL_LNAME%idx%
            }
        }
        txtF:= txtF "RShift   = switch layouts: " list "`n"
    }
    else
    {
        txtF:= txtF "RShift   = " LS_RShiftOption "`n"
    }
    
    
    
    
    if(LS_LCtrlOption >= 1 and LS_LCtrlOption <= 8 )
    {
        Nlay := LS_LCtrlOption 
        list := ""
        cnt := LS_ListL%Nlay%_Count
        Loop, %cnt%
        {
            if( Trim(LS_ListL%Nlay%[A_Index]) <> "" )
            {
                if(list <> "")
                    list := list "; "
                strHKL := Trim(LS_ListL%Nlay%[A_Index])
                idx := Format( "{:d}", KL_Index%strHKL%)
                list := list KL_LNAME%idx%
            }
        }
        txtF:= txtF "LCtrl    = switch layouts: " list "`n"
    }
    else
    {
        txtF:= txtF "LCtrl    = " LS_LCtrlOption "`n"
    }
    
    
    if(LS_RCtrlOption >= 1 and LS_RCtrlOption <= 8 )
    {
        Nlay := LS_RCtrlOption 
        list := ""
        cnt := LS_ListL%Nlay%_Count
        Loop, %cnt%
        {
            if( Trim(LS_ListL%Nlay%[A_Index]) <> "" )
            {
                if(list <> "")
                    list := list "; "
                strHKL := Trim(LS_ListL%Nlay%[A_Index])
                idx := Format( "{:d}", KL_Index%strHKL%)
                list := list KL_LNAME%idx%
            }
        }
        txtF:= txtF "RCtrl    = switch layouts: " list "`n"
    }
    else
    {
        txtF:= txtF "RCtrl    = " LS_RCtrlOption "`n"
    }
    
    
    if(LS_LAltSpaceOption >= 1 and LS_LAltSpaceOption <= 8 )
    {
        Nlay := LS_LAltSpaceOption 
        list := ""
        cnt := LS_ListL%Nlay%_Count
        Loop, %cnt%
        {
            if( Trim(LS_ListL%Nlay%[A_Index]) <> "" )
            {
                if(list <> "")
                    list := list "; "
                strHKL := Trim(LS_ListL%Nlay%[A_Index])
                idx := Format( "{:d}", KL_Index%strHKL%)
                list := list KL_LNAME%idx%
            }
        }
        txtF:= txtF "LAlt + Space = switch layouts: " list "`n"
    }
    else
    {
        txtF:= txtF "LAlt + Space = " LS_LAltSpaceOption "`n"
    }
    
    
    txtF:= txtF "Alt + CapsLock = CapsLock" "`n"
    if(LS_LShift_RShift_CapsLock = 1)
        txtF:= txtF "LShift + RShift = CapsLock" "`n"
    
    
    

    FileAppend, %txtF%, %FileHKName%
    Run, open %FileHKName%
return

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_HelpFile:
    if(LS_HelpFile <> "")
    {
        Run, open %LS_HelpFile% 
    }  
return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_Settings:
    Run, open %LS_SETTINGSINI%
return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_Stop_Start:

    Suspend Toggle
    if A_IsPaused 
    {
        Pause Toggle
    }
    else
    {
        Pause Toggle
    }

return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
MN_Load_INI(MN_FILE_INI)
{
    global
    
    IniRead, var, localization\%MN_FILE_INI%, LIST, L1
    if( var <> "ERROR" )
    {
        MN_L1 := "quiet"
        Menu, MN_LVSubmenu, Rename, %MN_L1%,  %var%
        MN_L1 := var
    }
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L2
    if( var <> "ERROR" )
    {
        MN_L2 := "medium"
        Menu, MN_LVSubmenu, Rename, %MN_L2%,  %var%
        MN_L2 := var
    }
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L3
    if( var <> "ERROR" )
    {
        MN_L3 := "loudly"
        Menu, MN_LVSubmenu, Rename, %MN_L3%,  %var%
        MN_L3 := var
    }
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L4
    if( var <> "ERROR" )
        Menu, tray, Rename, Exit,  %var%   
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L5
    if( var <> "ERROR" )
        Menu, tray, Rename, Reload,  %var%    
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L6
    if( var <> "ERROR" )
    {
        MN_L6 := "Show tooltip"
        Menu, tray, Rename, %MN_L6%, %var% 
        MN_L6 := var 
    }
    
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L7
    if( var <> "ERROR" )
    {
        MN_L7 := "Sound for switching layouts"
        Menu, tray, Rename, %MN_L7%, %var%  
        MN_L7 := var
    }
    
    IniRead, var, localization\%MN_FILE_INI%, LIST, L8
    if( var <> "ERROR" )
        Menu, tray, Rename, Sound level at startup,  %var%
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L9
    if( var <> "ERROR" )
        Menu, tray, Rename, Help file...,  %var%
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L10
    if( var <> "ERROR" )
        Menu, tray, Rename, Stop\Start,  %var%
        
    IniRead, var, localization\%MN_FILE_INI%, LIST, L11
    if( var <> "ERROR" )
    {
        var := var " " LS_SETTINGSINI 
        Menu, tray, Rename, %MN_L11%,  %var%
        MN_L11 := var
    }
}


; ==============================================================================