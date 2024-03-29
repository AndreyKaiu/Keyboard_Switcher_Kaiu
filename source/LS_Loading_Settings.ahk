; ==============================================================================
; LOADING SETTINGS (LS) =ru= ЗАГРУЗКА НАСТРОЕК (LS)
; ==============================================================================
; FileDescription: loading settings from the settings.ini file =ru= загрузка настроек с файла settings.ini
; FileVersion: 1.0.0.0 2022-07-30 \\ (Major version).(Minor version).(Revision number).(Build number) (year)-(month)-(day)
; Author: kaiu@mail.ru \\ author of code changes 
; ProductName: Keyboard_Switcher_Kaiu \\ included in the product
; OriginalFilename: LS_Loading_Settings.ahk \\ What file is this code from
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−

; file from which settings are loaded
; =ru= файл с которого производится загрузка настроек
LS_SETTINGSINI := "settings.ini"

; the first command line parameter can be the name of a settings file
; =ru= первый параметр командной строки может быть именем файла настроек
if( A_Args[1] <> "" )
{
    LS_SETTINGSINI := A_Args[1]
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; localization file from "localization" directory (program language)
; =ru= файл локализации из каталога "localization" (язык программы)
LS_FileLocalization=Russian.ini
IniRead, var, %LS_SETTINGSINI%, MAIN, FileLocalization
if( var <> "ERROR" )
{
    LS_FileLocalization := var
}
else 
{    
    IniWrite, %LS_FileLocalization%, %LS_SETTINGSINI%, MAIN, FileLocalization
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Help file (*.jpg or *.txt or *.pdf or ...)
; =ru= Файл справки (*.jpg or *.txt or *.pdf or ...)
LS_HelpFile := ""
IniRead, var, %LS_SETTINGSINI%, MAIN, HelpFile
if( var <> "ERROR" )
{
    LS_HelpFile := var
}
else 
{    
    IniWrite, %LS_HelpFile%, %LS_SETTINGSINI%, MAIN, HelpFile
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; all your layouts in the system (on each line there is one entry like: HKL, ISO, Name, Sound, INPUT_LNG, LAYOUT_NAME)
; =ru= все ваши раскладки в системе (на каждой строке одна запись вида: HKL, ISO, Name, Sound, INPUT_LNG, LAYOUT_NAME)
LS_ALLkeyboards := ""
IniRead, var, %LS_SETTINGSINI%, KEYBOARDS
if( (var <> "ERROR") and (var <> "") )
{    
    var := StrSplit(var, "`n")
    
    SetFormat, Integer, D
    Loop, % var.Count()
    {
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valHKL := valMas[1]
        LgUp := valMas[3] ; Name
        KL_ARSOUND%LgUp% := valMas[4] ; Sound 
        KL_ARLG1%valHKL% := LgUp
        KL_ARHKL%LgUp% := valHKL 
        if(valN <> "")
        {   
            idx := Format("{:d}", KL_Index%valHKL%)
            if(idx <> "")
            {
                KL_NAME%idx% := LgUp   
                KL_SOUND%idx% := valMas[4] ; Sound 
            }
        }
    }
    
    IniDelete %LS_SETTINGSINI%, KEYBOARDS
    IniWrite, [KEYBOARDS], %LS_SETTINGSINI%, PLACE_FOR_SECTION_KEYBOARDS
    
    sp := "" 
    SetFormat, Integer, D    
    Loop, %KL_Count%
    {
        if(sp<>"") 
            sp := sp "`n"
        sp := sp KL_HKL%A_Index% ", " KL_ISO%A_Index% ", " KL_NAME%A_Index%  
        sp := sp ", " KL_SOUND%A_Index%
        sp := sp ", " KL_ILNAME%A_Index% ", " KL_LNAME%A_Index%
    }
    IniWrite, %sp%, %LS_SETTINGSINI%, KEYBOARDS
}
else
{   
    sp := ""    
    SetFormat, Integer, D 
    Loop, %KL_Count%
    {
        if(sp<>"") 
            sp := sp "`n"
        sp := sp KL_HKL%A_Index% ", " KL_ISO%A_Index% ", " KL_NAME%A_Index%    
        sp := sp ", " KL_SOUND%A_Index%
        sp := sp ", " KL_ILNAME%A_Index% ", " KL_LNAME%A_Index%
    }
    IniWrite, %sp%, %LS_SETTINGSINI%, KEYBOARDS
}



; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Is language tooltip allowed (1-yes, 0-no)
; =ru= Разрешена ли всплывающая подсказка по языку (1-да, 0-нет)
LS_ShowToolTip := 1
IniRead, var, %LS_SETTINGSINI%, MAIN, ShowToolTip
if( var <> "ERROR" )
{
    LS_ShowToolTip := var
}
else 
{    
    IniWrite, %LS_ShowToolTip%, %LS_SETTINGSINI%, MAIN, ShowToolTip
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Is it allowed to play the layout switching sound
; =ru= Разрешено ли проигрывать звук переключения раскладки
LS_PlaySound := 0
IniRead, var, %LS_SETTINGSINI%, MAIN, PlaySound
if( var <> "ERROR" )
{
    LS_PlaySound := var
}
else 
{    
    IniWrite, %LS_PlaySound%, %LS_SETTINGSINI%, MAIN, PlaySound
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Sound level at startup =ru= Уровень звука при запуске
; =1 or 2 or 3
LS_SoundLevelAtStartup:=1
IniRead, var, %LS_SETTINGSINI%, MAIN, SoundLevelAtStartup
if( var <> "ERROR" )
{
    LS_SoundLevelAtStartup := var
}
else 
{    
    IniWrite, %LS_SoundLevelAtStartup%, %LS_SETTINGSINI%, MAIN, SoundLevelAtStartup
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; time to switch layout [ms] (200 ... 500)
; =ru= время на переключение раскладки [mS] (200 ... 500)
LS_TimeSwitchLayout := 500
IniRead, var, %LS_SETTINGSINI%, MAIN, TimeSwitchLayout
if( var <> "ERROR" )
{
    LS_TimeSwitchLayout := var
}
else 
{    
    IniWrite, %LS_TimeSwitchLayout%, %LS_SETTINGSINI%, MAIN, TimeSwitchLayout
}



; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Toggle CapsLock by simultaneously pressing LShift + RShift (1-yes, 0-no)
; =ru= Переключать CapsLock одновременным нажатием LShift + RShift (1-да, 0-нет)
LS_LShift_RShift_CapsLock = 1
IniRead, var, %LS_SETTINGSINI%, MAIN, LShift_RShift_CapsLock
if( var <> "ERROR" )
{
    LS_LShift_RShift_CapsLock := var
}
else 
{    
    IniWrite, %LS_LShift_RShift_CapsLock%, %LS_SETTINGSINI%, MAIN, LShift_RShift_CapsLock
}

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; time to switch CapsLock [ms] (300 ... 500)
; =ru= время на переключение CapsLock [mS] (300 ... 500)
LS_TimeSwitchCapsLock := 500
IniRead, var, %LS_SETTINGSINI%, MAIN, TimeSwitchCapsLock
if( var <> "ERROR" )
{
    LS_TimeSwitchCapsLock := var
}
else 
{    
    IniWrite, %LS_TimeSwitchCapsLock%, %LS_SETTINGSINI%, MAIN, TimeSwitchCapsLock
}

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; sound files for voicing CapsLock switching
; =ru= звуковые файлы для озвучивания переключения CapsLock 
LS_FileSoundCapsLockON := "CapsLockON.wav"
LS_FileSoundCapsLockOFF := "CapsLockOFF.wav"
IniRead, var, %LS_SETTINGSINI%, MAIN, FileSoundCapsLockON
if( var <> "ERROR" )
{
    LS_FileSoundCapsLockON := var
}
else 
{    
    IniWrite, %LS_FileSoundCapsLockON%, %LS_SETTINGSINI%, MAIN, FileSoundCapsLockON
}
IniRead, var, %LS_SETTINGSINI%, MAIN, FileSoundCapsLockOFF
if( var <> "ERROR" )
{
    LS_FileSoundCapsLockOFF := var
}
else 
{    
    IniWrite, %LS_FileSoundCapsLockOFF%, %LS_SETTINGSINI%, MAIN, FileSoundCapsLockOFF
}





; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Alternative 1 list of layouts (one entry per line: HKL, ISO)
; =ru= Альтернативный 1 список раскладок  (на каждой строке одна запись вида: HKL, ISO)
LS_ListL1 := ""
LS_ListL1_Count := 0
LS_ListL1_N := 0
IniRead, var, %LS_SETTINGSINI%, LAYOUT_LIST_1
if( (var <> "ERROR") and (var <> "") )
{
    var := StrSplit(var, "`n")
    LS_ListL1_Count := var.Count()
    Loop, %LS_ListL1_Count%
    {        
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valN := valMas[1]
        
        if(valN <> "")
        {
            if(LS_ListL1 <> "")
                LS_ListL1 := LS_ListL1 ";"
            LS_ListL1 := LS_ListL1 valN
        }
    }
    LS_ListL1 := StrSplit(LS_ListL1, ";")
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Alternative 2 list of layouts (one entry per line: HKL, ISO)
; =ru= Альтернативный 2 список раскладок  (на каждой строке одна запись вида: HKL, ISO)
LS_ListL2 := ""
LS_ListL2_Count := 0
LS_ListL2_N := 0
IniRead, var, %LS_SETTINGSINI%, LAYOUT_LIST_2
if( (var <> "ERROR") and (var <> "") )
{
    var := StrSplit(var, "`n")
    LS_ListL2_Count := var.Count()
    Loop, %LS_ListL2_Count%
    {        
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valN := valMas[1]
        
        if(valN <> "")
        {
            if(LS_ListL2 <> "")
                LS_ListL2 := LS_ListL2 ";"
            LS_ListL2 := LS_ListL2 valN
        }
    }
    LS_ListL2 := StrSplit(LS_ListL2, ";")
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Alternative 3 list of layouts (one entry per line: HKL, ISO)
; =ru= Альтернативный 3 список раскладок  (на каждой строке одна запись вида: HKL, ISO)
LS_ListL3 := ""
LS_ListL3_Count := 0
LS_ListL3_N := 0
IniRead, var, %LS_SETTINGSINI%, LAYOUT_LIST_3
if( (var <> "ERROR") and (var <> "") )
{
    var := StrSplit(var, "`n")
    LS_ListL3_Count := var.Count()
    Loop, %LS_ListL3_Count%
    {        
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valN := valMas[1]
        
        if(valN <> "")
        {
            if(LS_ListL3 <> "")
                LS_ListL3 := LS_ListL3 ";"
            LS_ListL3 := LS_ListL3 valN
        }
    }
    LS_ListL3 := StrSplit(LS_ListL3, ";")
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Alternative 1 list of layouts (one entry per line: HKL, ISO)
; =ru= Альтернативный 1 список раскладок  (на каждой строке одна запись вида: HKL, ISO)
LS_ListL4 := ""
LS_ListL4_Count := 0
LS_ListL4_N := 0
IniRead, var, %LS_SETTINGSINI%, LAYOUT_LIST_4
if( (var <> "ERROR") and (var <> "") )
{
    var := StrSplit(var, "`n")
    LS_ListL4_Count := var.Count()
    Loop, %LS_ListL4_Count%
    {        
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valN := valMas[1]
        
        if(valN <> "")
        {
            if(LS_ListL4 <> "")
                LS_ListL4 := LS_ListL4 ";"
            LS_ListL4 := LS_ListL4 valN
        }
    }
    LS_ListL4 := StrSplit(LS_ListL4, ";")
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Alternative 1 list of layouts (one entry per line: HKL, ISO)
; =ru= Альтернативный 1 список раскладок  (на каждой строке одна запись вида: HKL, ISO)
LS_ListL5 := ""
LS_ListL5_Count := 0
LS_ListL5_N := 0
IniRead, var, %LS_SETTINGSINI%, LAYOUT_LIST_5
if( (var <> "ERROR") and (var <> "") )
{
    var := StrSplit(var, "`n")
    LS_ListL5_Count := var.Count()
    Loop, %LS_ListL5_Count%
    {        
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valN := valMas[1]
        
        if(valN <> "")
        {
            if(LS_ListL5 <> "")
                LS_ListL5 := LS_ListL5 ";"
            LS_ListL5 := LS_ListL5 valN
        }
    }
    LS_ListL5 := StrSplit(LS_ListL5, ";")
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Alternative 1 list of layouts (one entry per line: HKL, ISO)
; =ru= Альтернативный 1 список раскладок  (на каждой строке одна запись вида: HKL, ISO)
LS_ListL6 := ""
LS_ListL6_Count := 0
LS_ListL6_N := 0
IniRead, var, %LS_SETTINGSINI%, LAYOUT_LIST_6
if( (var <> "ERROR") and (var <> "") )
{
    var := StrSplit(var, "`n")
    LS_ListL6_Count := var.Count()
    Loop, %LS_ListL6_Count%
    {        
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valN := valMas[1]
        
        if(valN <> "")
        {
            if(LS_ListL6 <> "")
                LS_ListL6 := LS_ListL6 ";"
            LS_ListL6 := LS_ListL6 valN
        }
    }
    LS_ListL6 := StrSplit(LS_ListL6, ";")
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Alternative 1 list of layouts (one entry per line: HKL, ISO)
; =ru= Альтернативный 1 список раскладок  (на каждой строке одна запись вида: HKL, ISO)
LS_ListL7 := ""
LS_ListL7_Count := 0
LS_ListL7_N := 0
IniRead, var, %LS_SETTINGSINI%, LAYOUT_LIST_7
if( (var <> "ERROR") and (var <> "") )
{
    var := StrSplit(var, "`n")
    LS_ListL7_Count := var.Count()
    Loop, %LS_ListL7_Count%
    {        
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valN := valMas[1]
        
        if(valN <> "")
        {
            if(LS_ListL7 <> "")
                LS_ListL7 := LS_ListL7 ";"
            LS_ListL7 := LS_ListL7 valN
        }
    }
    LS_ListL7 := StrSplit(LS_ListL7, ";")
}



; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Alternative 8 list of layouts (one entry per line: HKL, ISO)
; =ru= Альтернативный 8 список раскладок  (на каждой строке одна запись вида: HKL, ISO)
LS_ListL8 := ""
LS_ListL8_Count := 0
LS_ListL8_N := 0
IniRead, var, %LS_SETTINGSINI%, LAYOUT_LIST_8
if( (var <> "ERROR") and (var <> "") )
{
    var := StrSplit(var, "`n")
    LS_ListL8_Count := var.Count()
    Loop, %LS_ListL8_Count%
    {        
        valN := var[A_Index]
        valMas := StrSplit(valN, ", ")
        valN := valMas[1]
        
        if(valN <> "")
        {
            if(LS_ListL8 <> "")
                LS_ListL8 := LS_ListL8 ";"
            LS_ListL8 := LS_ListL8 valN
        }
    }
    LS_ListL8 := StrSplit(LS_ListL8, ";")
}






; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Ability to change the default behavior of CapsLock
; (in any case, you can switch by pressing Alt + CapsLock)
; Can only take one of the following values:
; =ru= Возможность изменить стандартное поведение CapsLock
; =ru= (в любом случае, вы можете переключить нажав Alt + CapsLock)
; =ru= Может принимать только одно из значений:

; =    - empty or do not change =ru= пустое или не менять
; =Disable - disable =ru= отключить
; =LCtrl - like LCtrl =ru= как LCtrl
; =LShift - like LShift =ru= как LShift
; =Tab - like Tab =ru= как Tab
; =AllLayouts - switch all layouts =ru= переключать все раскладки
; =1 or 2 ... 8 (LAYOUT_LIST_1 or LAYOUT_LIST_2...LAYOUT_LIST_8)  switching from an alternative list of layouts =ru= переключение из альтернативного списка раскладок
LS_CapsLockOption := "LCtrl"
IniRead, var, %LS_SETTINGSINI%, CAPSLOCK_OPTIONS, CapsLockOption
if( var <> "ERROR" )
{
    LS_CapsLockOption := var
}
else 
{    
    IniWrite, %LS_CapsLockOption%, %LS_SETTINGSINI%, CAPSLOCK_OPTIONS, CapsLockOption
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−   
; Ability to change the default behavior of LShift
; Can only take one of the following values:
; =ru= Возможность изменить стандартное поведение LShift
; =ru= Может принимать только одно из значений:

; =    - empty or do not change =ru= пустое или не менять
; =AllLayouts - switch all layouts =ru= переключать все раскладки
; =1 or 2 ... 8 (LAYOUT_LIST_1 or LAYOUT_LIST_2...LAYOUT_LIST_8)  switching from an alternative list of layouts =ru= переключение из альтернативного списка раскладок
LS_LShiftOption := 1
IniRead, var, %LS_SETTINGSINI%, LSHIFT_OPTIONS, LShiftOption
if( var <> "ERROR" )
{
    LS_LShiftOption := var
}
else 
{    
    IniWrite, %LS_LShiftOption%, %LS_SETTINGSINI%, LSHIFT_OPTIONS, LShiftOption
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−   
; Ability to change the default behavior of RShift
; Can only take one of the following values:
; =ru= Возможность изменить стандартное поведение RShift
; =ru= Может принимать только одно из значений:

; =    - empty or do not change =ru= пустое или не менять
; =AllLayouts - switch all layouts =ru= переключать все раскладки
; =1 or 2 ... 8 (LAYOUT_LIST_1 or LAYOUT_LIST_2...LAYOUT_LIST_8)  switching from an alternative list of layouts =ru= переключение из альтернативного списка раскладок
LS_RShiftOption := 2
IniRead, var, %LS_SETTINGSINI%, RSHIFT_OPTIONS, RShiftOption
if( var <> "ERROR" )
{
    LS_RShiftOption := var
}
else 
{    
    IniWrite, %LS_RShiftOption%, %LS_SETTINGSINI%, RSHIFT_OPTIONS, RShiftOption
}



; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−   
; Ability to change the default behavior of LCtrl
; Can only take one of the following values:
; =ru= Возможность изменить стандартное поведение LCtrl
; =ru= Может принимать только одно из значений:

; =    - empty or do not change =ru= пустое или не менять
; =Disable - disable =ru=  отключить
; =AllLayouts - switch all layouts =ru= переключать все раскладки
; =1 or 2 ... 8 (LAYOUT_LIST_1 or LAYOUT_LIST_2...LAYOUT_LIST_8)  switching from an alternative list of layouts =ru= переключение из альтернативного списка раскладок

LS_LCtrlOption := ""
IniRead, var, %LS_SETTINGSINI%, LCTRL_OPTIONS, LCtrlOption
if( var <> "ERROR" )
{
    LS_LCtrlOption := var
}
else 
{    
    IniWrite, %LS_LCtrlOption%, %LS_SETTINGSINI%, LCTRL_OPTIONS, LCtrlOption
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−   
; Ability to change the default behavior of RCtrl
; Can only take one of the following values:
; =ru= Возможность изменить стандартное поведение RCtrl
; =ru= Может принимать только одно из значений:

; =    - empty or do not change =ru= пустое или не менять
; =Disable - disable =ru=  отключить
; =RAlt - like RAlt =ru=  как RAlt
; =RShift - like RShift =ru=  как RShift
; =AllLayouts - switch all layouts =ru= переключать все раскладки
; =1 or 2 ... 8 (LAYOUT_LIST_1 or LAYOUT_LIST_2...LAYOUT_LIST_8)  switching from an alternative list of layouts =ru= переключение из альтернативного списка раскладок

LS_RCtrlOption := ""
IniRead, var, %LS_SETTINGSINI%, RCTRL_OPTIONS, RCtrlOption
if( var <> "ERROR" )
{
    LS_RCtrlOption := var
}
else 
{    
    IniWrite, %LS_RCtrlOption%, %LS_SETTINGSINI%, RCTRL_OPTIONS, RCtrlOption
}



; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−  
; Ability to change the default behavior of LAlt + Space
; Can only take one of the following values:
; =ru= Возможность изменить стандартное поведение LAlt + Space
; =ru= Может принимать только одно из значений:

; =    - empty or do not change =ru= пустое или не менять
; =AllLayouts - switch all layouts =ru= переключать все раскладки
; =1 or 2 ... 8 (LAYOUT_LIST_1 or LAYOUT_LIST_2...LAYOUT_LIST_8)  switching from an alternative list of layouts =ru= переключение из альтернативного списка раскладок
LS_LAltSpaceOption := "AllLayouts"
IniRead, var, %LS_SETTINGSINI%, LALT_SPACE_OPTIONS, LAltSpaceOption
if( var <> "ERROR" )
{
    LS_LAltSpaceOption := var
}
else 
{    
    IniWrite, %LS_LAltSpaceOption%, %LS_SETTINGSINI%, LALT_SPACE_OPTIONS, LAltSpaceOption
}



; ==============================================================================
