#SingleInstance Force
#Include %A_ScriptDir%\classes\earth_destroyer.ahk
#Include %A_ScriptDir%\lib\utility.ahk
#Include %A_ScriptDir%\lib\spec.ahk

KeyHistory 0
ListLines 0
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay -1

DebugMode := { Use: false, Check: false }
DELAY := 7

global current_spec := spec_type.LIST[1]

^F10:: {
    Reload()
    MsgBox("Script Reloaded", "Reloaded")
}
^F8::Pause
^F9:: ExitApp()
; Spec Selection
^+j:: {
    selection_gui := Gui()
    dropdown := selection_gui.AddDropDownList(, spec_type.LIST)
    submit := selection_gui.AddButton(, "Submit")
    submit.OnEvent("Click", OnClick)
    selection_gui.Show()

    OnClick(*) {
        global current_spec := spec_type.LIST[dropdown.Value]
        MsgBox(current_spec, "Choice")
        selection_gui.Destroy()
    }
}

F1:: {
    if (WinActive("ahk_class UnrealWindow")) {
        mouseX := 0
        mouseY := 0
        MouseGetPos(&mouseX, &mouseY)

        r := 0
        g := 0
        b := 0
        color := Utility.GetColor(mouseX, mouseY, &r, &g, &b)
        ToolTip("Coordinate " mouseX "," mouseY "`nHex " color " (" r "," g "," b ")")
        A_Clipboard := "Utility.GetColor(" mouseX ", " mouseY ") == `"" color "`""
        SetTimer () => ToolTip(), -5000
    }
    return
}

bnsclazz := earth_destroyer()
$XButton1:: {
    While (Utility.GameActive() && GetKeyState("XButton1", "p"))
    {
        bnsclazz.DoRotation()
    }
    return
}

WriteLog(text) {
    FileAppend(A_NowUTC ": " text "`n", "logfile.txt")
}