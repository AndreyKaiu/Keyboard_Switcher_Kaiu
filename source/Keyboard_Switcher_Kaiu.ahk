; ==============================================================================
; KEYBOARD_SWITCHER_KAIU (M)
; ==============================================================================
; FileDescription: Keyboard layout switcher, Birman layout and more  =ru= Переключатель раскладки клавиатуры, раскладка Бирмана и другое 
; FileVersion: 1.0.0.0 2022-07-30 \\ (Major version).(Minor version).(Revision number).(Build number) (year)-(month)-(day)
; Author: kaiu@mail.ru \\ author of code changes 
; ProductName: Keyboard_Switcher_Kaiu \\ included in the product
; OriginalFilename: Keyboard_Switcher_Kaiu.ahk \\ What file is this code from
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#MaxThreads 200 ; max. threads for everything =ru= максимальное кол. потоков для всего вообще
#SingleInstance ; running only one copy =ru= запуск только одной копии
SetWorkingDir %A_ScriptDir% ; working directory like a script, otherwise they change through a shortcut =ru= рабочий каталог как у скрипта, а то меняют через ярлык
SetBatchlines, -1 ; Determines the script execution speed (affects CPU usage) and by default 10ms, and now max. speed =ru= Определяет скорость выполнения скрипта (влияет на загрузку ЦП) и по умолчанию 10ms, а сейчас макс. скорость
Process, Priority, , High ; high priority for the script =ru= приоритет высокий для скрипта
#NoEnv ; skip undefined variables =ru= не заданные переменные пропускать 
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
switch_Lang_lang := "" ; what language will we switch to =ru= на какой язык переключаться будем
old_n_layout_list := 0 ; previous number active list of layouts =ru= прошлый номер активного списка раскладок 
KeyPressTime := 0 ; 0,1,2 - key time measurement status =ru= статус измерения времени нажатия клавиши
KeyCapsLockPressTime := 0 ; 0,1,2 - key time measurement status (for CapsLock) =ru= статус измерения времени нажатия клавиши (для CapsLock)
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−


; list of keyboard layouts =ru= список клавиатурных раскладок
#Include KL_list_of_Keyboard_Layouts.ahk
KL_InitLNG() 

; loading settings from the settings.ini file =ru= загрузка настроек с файла settings.ini
#Include LS_Loading_Settings.ahk


; subroutine executed at the end of the script =ru= подпрограмма выполняемая при завершении скрипта
OnExit, OnExitSub


; menu loading =ru= загрузка меню
#Include MN_Menu.ahk
return

TimerKeyPressTime:
    KeyPressTime := 2
    SetTimer, TimerKeyPressTime, off
return

TimerKeyCapsLockPressTime:
    KeyCapsLockPressTime := 0
    SetTimer, TimerKeyCapsLockPressTime, off
return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; (in any case, you can switch by pressing Alt + CapsLock)
; =ru= (в любом случае, вы можете переключить нажав Alt + CapsLock)
LAlt & CapsLock::
vkA9 & CapsLock:: ; Browser_Stop will change to RAlt
    if (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Tab", "P"))
        switch_CapsLock() ; caps lock toggle =ru= переключение CapsLock 
return


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; caps lock toggle
; =ru= переключение CapsLock 
switch_CapsLock()
{
    global
    
    
    if( KeyCapsLockPressTime = 0 ) 
    {
        KeyCapsLockPressTime = 2
        SetTimer, TimerKeyCapsLockPressTime, %LS_TimeSwitchCapsLock%               
        
        SetKeyDelay 0
        SendInput {Blind}{CapsLock Down}
        Sleep 20
        SendInput {Blind}{CapsLock Up}
        
        stCL := !GetKeyState("CapsLock", "T")
        if( stCL )
        {
            kbd_msg("off caps lock")
            if( LS_PlaySound )
            {
                SoundPlay, ""	
                SoundPlay, %A_ScriptDir%\sound\%LS_FileSoundCapsLockOFF%					
            }	
        }
        else
        {
            kbd_msg("CAPS LOCK ON")	
            if( LS_PlaySound )
            {
                SoundPlay, ""	
                SoundPlay, %A_ScriptDir%\sound\%LS_FileSoundCapsLockON%					
            }
        }
    }
    
    return
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#if ( Trim(LS_CapsLockOption) = "")
$CapsLock::
    switch_CapsLock() ; caps lock toggle =ru= переключение CapsLock 
return
#if

#if ( Trim(LS_CapsLockOption) = "Disable")
CapsLock::return
#if

#if ( Trim(LS_CapsLockOption) = "LCtrl")
CapsLock::LCtrl
#if


#if ( Trim(LS_CapsLockOption) = "Tab")
CapsLock::Tab
#if

#if ( Trim(LS_CapsLockOption) = "LShift")
CapsLock::LShift
#if

#if ( Trim(LS_CapsLockOption) = "AllLayouts")
CapsLock::
    if (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Alt", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Tab", "P"))
    {
        switch_next_Lang() ; next language in order =ru= следующий язык по порядку
    }
return
#if

#if ((LS_CapsLockOption >= 1) and (LS_CapsLockOption <= 8))
CapsLock:: 
    if (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Alt", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Tab", "P"))
    {
        switch_next_LangList( LS_CapsLockOption ) ; next language in order LAYOUT_LIST =ru= следующий язык по порядку LAYOUT_LIST
    }
return
#if






; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#if ( Trim(LS_LShiftOption) = "AllLayouts") or ( (LS_LShiftOption >= 1) and (LS_LShiftOption <= 8) )
~LShift:: 
    if (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Alt", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P"))
    {
        if( KeyPressTime = 0 )
        {
            SetTimer, TimerKeyPressTime, %LS_TimeSwitchLayout%
            KeyPressTime := 1
        }
    }
return    

~LShift Up::
    if (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Alt", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P"))
    {
        if( KeyPressTime = 1 )
        {        
            if( A_PriorKey = "LShift" )
            {
                if( LS_LShiftOption = "AllLayouts" )
                    switch_next_Lang() ; next language in order =ru= следующий язык по порядку
                else
                    switch_next_LangList( LS_LShiftOption ) ; next language in order LAYOUT_LIST =ru= следующий язык по порядку LAYOUT_LIST
            }        
        }
    }
    
    SetTimer, TimerKeyPressTime, off
    KeyPressTime := 0
return
#if


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#if ( Trim(LS_RShiftOption) = "AllLayouts") or ( (LS_RShiftOption >= 1) and (LS_RShiftOption <= 8) )
~RShift:: 
    if (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Alt", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P"))
    {
        if( KeyPressTime = 0 )
        {
            SetTimer, TimerKeyPressTime, %LS_TimeSwitchLayout%
            KeyPressTime := 1
        }
    }
return    

~RShift Up::
    if (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Alt", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P"))
    {
        if( KeyPressTime = 1 )
        {        
            if( A_PriorKey = "RShift" )
            {
                if( LS_RShiftOption = "AllLayouts" )
                    switch_next_Lang() ; next language in order =ru= следующий язык по порядку
                else
                    switch_next_LangList( LS_RShiftOption ) ; next language in order LAYOUT_LIST =ru= следующий язык по порядку LAYOUT_LIST
            }        
        }
    }
    
    SetTimer, TimerKeyPressTime, off
    KeyPressTime := 0
return
#if


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#if ( Trim(LS_LCtrlOption) = "Disable")
LCtrl::return
#if

#if ( Trim(LS_LCtrlOption) = "AllLayouts") or ( (LS_LCtrlOption >= 1) and (LS_LCtrlOption <= 8) )
~LCtrl:: 
    if (not GetKeyState("Alt", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P"))
    {
        if( KeyPressTime = 0 )
        {
            SetTimer, TimerKeyPressTime, %LS_TimeSwitchLayout%
            KeyPressTime := 1
        }
    }
return    

~LCtrl Up::
    if (not GetKeyState("Alt", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P"))
    {
        if( KeyPressTime = 1 )
        {        
            if( A_PriorKey = "LControl" )
            {
                if( LS_LCtrlOption = "AllLayouts" )
                    switch_next_Lang() ; next language in order =ru= следующий язык по порядку
                else
                    switch_next_LangList( LS_LCtrlOption ) ; next language in order LAYOUT_LIST =ru= следующий язык по порядку LAYOUT_LIST
            }        
        }    
    }
    
    SetTimer, TimerKeyPressTime, off
    KeyPressTime := 0
return
#if




; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#if ( Trim(LS_RCtrlOption) = "Disable")
RCtrl::return
#if

#if ( Trim(LS_RCtrlOption) = "RAlt")
RCtrl::RAlt
#if

#if ( Trim(LS_RCtrlOption) = "RShift")
RCtrl::RShift
#if

#if ( Trim(LS_RCtrlOption) = "AllLayouts") or ( (LS_RCtrlOption >= 1) and (LS_RCtrlOption <= 8) )
~RCtrl:: 
    if (not GetKeyState("Alt", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P"))
    {
        if( KeyPressTime = 0 )
        {
            SetTimer, TimerKeyPressTime, %LS_TimeSwitchLayout%
            KeyPressTime := 1
        }
    }
return    

~RCtrl Up::
    if (not GetKeyState("Alt", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P"))
    {
        if( KeyPressTime = 1 )
        {        
            if( A_PriorKey = "RControl" )
            {
                if( LS_RCtrlOption = "AllLayouts" )
                    switch_next_Lang() ; next language in order =ru= следующий язык по порядку
                else
                    switch_next_LangList( LS_RCtrlOption ) ; next language in order LAYOUT_LIST =ru= следующий язык по порядку LAYOUT_LIST
            }        
        }
    }
    
    SetTimer, TimerKeyPressTime, off
    KeyPressTime := 0
return
#if



; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; Toggle CapsLock by simultaneously pressing LShift + RShift (1-yes, 0-no)
; =ru= Переключать CapsLock одновременным нажатием LShift + RShift (1-да, 0-нет)
#if (LS_LShift_RShift_CapsLock = 1)
LShift & RShift::
RShift & LShift::
    if (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Alt", "P"))  and (not GetKeyState("Win", "P")) and (not GetKeyState("Tab", "P"))
        switch_CapsLock() ; caps lock toggle =ru= переключение CapsLock 		
return    
#if




; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#if ( Trim(LS_LAltSpaceOption) = "AllLayouts" )
LAlt & Space::
    if ( (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P")) )
	{
        switch_next_Lang() ; next language in order =ru= следующий язык по порядку
    }
return
#if

#if ( (LS_LAltSpaceOption >= 1) and (LS_LAltSpaceOption <= 8) )
LAlt & Space::
    if ( (not GetKeyState("Ctrl", "P")) and (not GetKeyState("Shift", "P")) and (not GetKeyState("Win", "P")) and (not GetKeyState("CapsLock", "P")) and (not GetKeyState("Tab", "P")) )
	{
        switch_next_LangList( LS_LAltSpaceOption ) ; next language in order LAYOUT_LIST =ru= следующий язык по порядку LAYOUT_LIST
    }
return
#if
    
    




; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; subroutine executed at the end of the script
; =ru= подпрограмма выполняемая при завершении скрипта
OnExitSub:	
    
    ExitApp
return





; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; next language in order LAYOUT_LIST 
; =ru= следующий язык по порядку LAYOUT_LIST
switch_next_LangList( n_layout_list )
{
    global
    SetFormat, Integer, D
    if(n_layout_list >= 1 and n_layout_list <= 8)
    {  
        Switch n_layout_list
        {
        case 1:
            LS_ListLX := LS_ListL1
            LS_ListLX_Count := LS_ListL1_Count
            LS_ListLX_N := LS_ListL1_N
        case 2:
            LS_ListLX := LS_ListL2
            LS_ListLX_Count := LS_ListL2_Count
            LS_ListLX_N := LS_ListL2_N
        case 3:
            LS_ListLX := LS_ListL3
            LS_ListLX_Count := LS_ListL3_Count
            LS_ListLX_N := LS_ListL3_N
        case 4:
            LS_ListLX := LS_ListL4
            LS_ListLX_Count := LS_ListL4_Count
            LS_ListLX_N := LS_ListL4_N
        case 5:
            LS_ListLX := LS_ListL5
            LS_ListLX_Count := LS_ListL5_Count
            LS_ListLX_N := LS_ListL5_N
        case 6:
            LS_ListLX := LS_ListL6
            LS_ListLX_Count := LS_ListL6_Count
            LS_ListLX_N := LS_ListL6_N
        case 7:
            LS_ListLX := LS_ListL7
            LS_ListLX_Count := LS_ListL7_Count
            LS_ListLX_N := LS_ListL7_N
        case 8:
            LS_ListLX := LS_ListL8    
            LS_ListLX_Count := LS_ListL8_Count
            LS_ListLX_N := LS_ListL8_N
        }    
                
        
        curlng := check_lang() ; checking which language is current =ru= проверка какой язык текущий
        LS_ListLX_N2 := 0
        Loop, %LS_ListLX_Count% 
        {
            M_LNG := LS_ListLX[ A_Index ]
            ret := ""
            ret := KL_ARLG1%M_LNG% 
            if (ret="") or (ret=)
                ret := KL_ARLG2%M_LNG% 
            M_LNG := ret
            
            if(curlng = M_LNG)
            {
                LS_ListLX_N2 := A_Index
                Break
            }
        }   
        
        if( (LS_ListLX_N2 = LS_ListLX_N) and (n_layout_list = old_n_layout_list) )
        {
            LS_ListLX_N := LS_ListLX_N + 1
            if(LS_ListLX_N > LS_ListLX_Count)
                LS_ListLX_N := 1
        }
        
        if(LS_ListLX_N < 1 OR LS_ListLX_N > LS_ListLX_Count)
            LS_ListLX_N := 1
        
        
        
        Switch n_layout_list
        {
        case 1:
            LS_ListL1_N := LS_ListLX_N
        case 2:
            LS_ListL2_N := LS_ListLX_N
        case 3:
            LS_ListL3_N := LS_ListLX_N
        case 4:
            LS_ListL4_N := LS_ListLX_N
        case 5:
            LS_ListL5_N := LS_ListLX_N
        case 6:
            LS_ListL6_N := LS_ListLX_N
        case 7:
            LS_ListL7_N := LS_ListLX_N
        case 8:
            LS_ListL8_N := LS_ListLX_N
        } 
        
     
        M_LNG := LS_ListLX[ LS_ListLX_N ]    
        ; take from variable =ru= берем из переменной
        ret := ""
        ret := KL_ARLG1%M_LNG% 
        if (ret="") or (ret=)
            ret := KL_ARLG2%M_LNG% 
        M_LNG := ret    
        
        switch_Lang(M_LNG) ; language switching =ru= переключение языка
            
        old_n_layout_list := n_layout_list ; previous number active list of layouts =ru= прошлый номер активного списка раскладок     
    }
    SetFormat, Integer, H
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; next language in order
; следующий язык по порядку	
switch_next_Lang()
{
    old_n_layout_list := 0 ; previous number active list of layouts =ru= прошлый номер активного списка раскладок
    
    ControlGetFocus, control, A	
    SendMessage 0x50, 2,, %control%, A                
    Sleep 20
    
    curlng := check_lang() ; checking which language is current =ru= проверка какой язык текущий
    
    kbd_msg(curlng)
    
    global LS_PlaySound    
    if( LS_PlaySound  ) ; if you need to say =ru= если надо озвучить
    {
        ; we take the voice acting from the file =ru= озвучку берем из файла        
        fileSnd := KL_ARSOUND%curlng%
        SoundPlay, ""    
        SoundPlay, %A_ScriptDir%\sound\%fileSnd%
    }    
    
    return
}

                
                
                

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; language switching
; =ru= переключение языка
switch_Lang(lang)
{	 
    global
    switch_Lang_lang := lang
    
    SetTimer, TimerSwitch_Lang, off
    SetTimer, TimerSwitch_Lang, 50 ; no more than 50 ms =ru= не чаще 50 мс

    return    
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; what language will we switch to
; =ru= на какой язык переключаться будем
TimerSwitch_Lang:
    Critical
    
    lang := switch_Lang_lang 
    WinGet, WinID,, A
    WinGet , WinProcessName, ProcessName, A
    
    
    ; get HKL by language =ru= получим HKL по языку   
    Lhkl := KL_ARHKL%lang%   
    
    sendswitchLang := 0
    if Lhkl <> "" 
    {
        LhklInt := (Lhkl << 32) >> 32 ; here it wants in 64 bit form =ru= тут оно хочет в 64 битном виде        

        ControlGetFocus, control, A            
        PostMessage 0x50, 2, %LhklInt%, %control%, A   
        sendswitchLang := 1
    }
    
    if(sendswitchLang = 1)
        kbd_msg(lang)

    
    Critical OFF ; disable critical section =ru= отключение критической секции
    Sleep -1 ; Critical definitely worked =ru= Critical точно отработал    
    

    global LS_PlaySound    
    if( LS_PlaySound and (sendswitchLang = 1) ) ; if you need to say =ru= если надо озвучить
    {
        ; we take the voice acting from the file =ru= озвучку берем из файла        
        fileSnd := KL_ARSOUND%lang%
        SoundPlay, ""    
        SoundPlay, %A_ScriptDir%\sound\%fileSnd%
    }
    
    SetTimer, TimerSwitch_Lang, off
return





; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; checking which language is current
; =ru= проверка какой язык текущий
check_lang()
{
    SetFormat, Integer, H
    WinGet, WinID,, A    
    return check_lang_by_window_id( WinID ) 
}

; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; return current language of 2 characters (or more if layouts are different)
; =ru= возврат текущего языка из 2 символов (или более если раскладки другие)
check_lang_by_window_id(hWnd)
{    
    if !hWnd
        return
        
    WinGetClass, winClass, A
    if (winClass != "ConsoleWindowClass") || (b := SubStr(A_OSVersion, 1, 2) = "10")
    {
        if b
        {
            WinGet, consolePID, PID
            childConhostPID := GetCmdChildConhostPID(consolePID)
            dhw_prev := A_DetectHiddenWindows
            DetectHiddenWindows, On
            hWnd := WinExist("ahk_pid " . childConhostPID)
            DetectHiddenWindows, % dhw_prev
        }
        threadId := DllCall("GetWindowThreadProcessId", Ptr, hWnd, UInt, 0)
        lyt := DllCall("GetKeyboardLayout", Ptr, threadId, UInt)        
        langID := Format("{:#x}", lyt)
    }
    else ; console window in win7 =ru= окно консольное в вин7
    {            
        WinGet, dwProcessId, PID, A 
        bResult := DllCall("AttachConsole", "uint", dwProcessId, "int")
        if(!bResult)
        {        
            langID := "" 
            ; MsgBox,,, НЕТ
        }
        else
        {
            VarSetCapacity(lyt, 16)
            DllCall("GetConsoleKeyboardLayoutName", Str, lyt)
            DllCall("FreeConsole")    
            langID := "0x" . lyt
            ; MsgBox,,, ДА
        }
    }


    langID := "" KL_FormatHEX8(langID)    
    ; take from variable =ru= берем из переменной
    ret := ""
    ret := KL_ARLG1%langID% 
    if (ret="") or (ret=)
        ret := KL_ARLG2%langID% 
        
    return ret   
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
GetCmdChildConhostPID(CmdPID)
{
   static TH32CS_SNAPPROCESS := 0x2, MAX_PATH := 260
   
   h := DllCall("CreateToolhelp32Snapshot", UInt, TH32CS_SNAPPROCESS, UInt, 0, Ptr)
   VarSetCapacity(PROCESSENTRY32, size := 4*7 + A_PtrSize*2 + (MAX_PATH << !!A_IsUnicode), 0)
   NumPut(size, PROCESSENTRY32, "UInt")
   res := DllCall("Process32First", Ptr, h, Ptr, &PROCESSENTRY32)
   while res  {
      parentPid := NumGet(PROCESSENTRY32, 4*4 + A_PtrSize*2, "UInt")
      if (parentPid = CmdPID)  {
         exeName := StrGet(&PROCESSENTRY32 + 4*7 + A_PtrSize*2, "CP0")
         if (exeName = "conhost.exe" && PID := NumGet(PROCESSENTRY32, 4*2, "UInt"))
            break
      }
      res := DllCall("Process32Next", Ptr, h, Ptr, &PROCESSENTRY32)
   }
   DllCall("CloseHandle", Ptr, h)
   Return PID
}


; −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
; display layout message
; показ сообщения о раскладке
kbd_msg(text)
{
    global LS_ShowToolTip
    if( not LS_ShowToolTip ) 
    {
        return
    }
    
    ToolTip, %text%, A_CaretX + 10, A_CaretY - 20    
    SetTimer, KbdRemoveToolTip, -1000
    return
    
    KbdRemoveToolTip:
    ToolTip, "" , 0, 0    
    ToolTip    
    return
}


; ==============================================================================
