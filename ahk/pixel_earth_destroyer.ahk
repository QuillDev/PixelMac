#SingleInstance Force
#Include %A_ScriptDir%\lib\utility.ahk

KeyHistory 0
ListLines 0
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay -1

DebugMode := { Use: false, Check: false }

^F10:: Reload()
^F11::Pause
^F12:: ExitApp()

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

$XButton1:: {
    While (Utility.GameActive() && GetKeyState("XButton1", "p"))
    {
        Rotations.FullRotation(true)
    }
    return
}

class Skill {
    ; Rotation Skills
    static WRATH_3 := "WRATH_3"
    static WRATH := "WRATH"
    static CLEAVE := "CLEAVE"
    static MIGHTY_CLEAVE := "MIGHTY_CLEAVE"

    ; Status Skills
    static EMBERSTOMP := "EMBERSTOMP"
    static SMASH := "SMASH"
    static FURY := "FURY"

    ; Misc Skills
    static STONE_WEDGE := "STONE_WEDGE"

    ; Awk Skills
    static AWK_CLEAVE := "AWK_CLEAVE"
    static AWK_MIGHTY_CLEAVE := "AWK_MIGHTY_CLEAVE"

    static Up(sid) {
        if (DebugMode.Check == true) {
            WriteLog("Checking " sid)
        }

        switch sid {
            case Skill.WRATH_3:
                return Utility.GetColor(1233, 928) == "0x27262E"
            case Skill.WRATH:
                return Utility.GetColor(1075, 930) == "0xA3783A"
            case Skill.CLEAVE:
                return Utility.GetColor(1120, 930) == "0x904144"
            case Skill.MIGHTY_CLEAVE:
                return Utility.GetColor(1114, 768) == "0xDB7527"
            case Skill.EMBERSTOMP:
                return Utility.GetColor(1232, 931) == "0xD9AA48"
            case Skill.SMASH:
                return Utility.GetColor(1236, 928) == "0x48474B"
            case Skill.FURY:
                return Utility.GetColor(772, 929) == "0x9B8269"
            case Skill.STONE_WEDGE:
                return Utility.GetColor(1077, 928) == "0x796F59"
            case Skill.AWK_CLEAVE:
                return false
            case Skill.AWK_MIGHTY_CLEAVE:
                return false
        }
        return false
    }

    static Use(sid) {
        if (DebugMode.Use == true) {
            WriteLog("Casting " sid)
        }
        switch (sid) {
            case Skill.WRATH_3:
                SendInput("g")
                return
            case Skill.WRATH:
                SendInput("r")
                return
            case Skill.CLEAVE:
                SendInput("t")
                return
            case Skill.MIGHTY_CLEAVE:
                SendInput("g")
                return
            case Skill.EMBERSTOMP:
                SendInput("3")
                return
            case Skill.SMASH:
                SendInput("x")
                return
            case Skill.FURY:
                SendInput("e")
                return
            case Skill.AWK_CLEAVE:
                SendInput("t")
                return
            case Skill.AWK_MIGHTY_CLEAVE:
                SendInput("g")
                return
        }

        return
    }

    static UseIfUp(sid) {
        if (Skill.Up(sid)) {
            Skill.Use(sid)
            return true
        }
        return false
    }
}

class Rotations
{
    static Default(useDpsPhase)
    {

        ; Use Fury if it's Available
        if (Skill.UseIfUp(Skill.FURY)) {
            Sleep 10
        }

        ; Break out of stone wedge effect
        if (Skill.Up(Skill.STONE_WEDGE)) {
            while (Skill.Up(Skill.STONE_WEDGE)) {
                Skill.Use(Skill.CLEAVE)
                Sleep 10
            }
        }

        if (Skill.Up(Skill.MIGHTY_CLEAVE)) {
            While (Skill.UseIfUp(Skill.MIGHTY_CLEAVE)) {
                Sleep 10
            }

            ; Smash
            While (!Skill.Up(Skill.MIGHTY_CLEAVE) && Skill.UseIfUp(Skill.SMASH)) {
                Sleep 10
            }

            ; Emberstomp
            While (!Skill.Up(Skill.MIGHTY_CLEAVE) && Skill.UseIfUp(Skill.EMBERSTOMP)) {
                Sleep 10
            }
        }
        else {
            if (Skill.Up(Skill.AWK_MIGHTY_CLEAVE)) {
                While (Skill.UseIfUp(Skill.AWK_MIGHTY_CLEAVE)) {
                    Sleep 10
                }

                ; Use smash
                While (!Skill.Up(Skill.AWK_MIGHTY_CLEAVE) && Skill.UseIfUp(Skill.SMASH)) {
                    Sleep 10
                }

                ; Use Emberstomp
                While (!Skill.Up(Skill.AWK_MIGHTY_CLEAVE) && Skill.UseIfUp(Skill.EMBERSTOMP)) {
                    Sleep 10
                }
            } else {
                if (Skill.Up(Skill.WRATH_3) && Skill.Up(Skill.AWK_CLEAVE)) {
                    While (Skill.Up(Skill.WRATH_3) && Skill.UseIfUp(Skill.AWK_CLEAVE)) {
                        Sleep 10
                    }
                } else {
                    if (Skill.Up(Skill.WRATH_3) && !Skill.Up(Skill.AWK_CLEAVE)) {
                        While (Skill.UseIfUp(Skill.WRATH_3)) {
                            Sleep 10
                        }

                        Sleep 45
                        While (Skill.UseIfUp(Skill.CLEAVE)) {
                            Sleep 10
                        }
                    } else {
                        ; spam wrath
                        Skill.Use(Skill.WRATH)
                        Sleep 5
                    }
                }
                return
            }
        }
    }

    static FullRotation(useDpsPhase)
    {
        Rotations.Default(useDpsPhase)
        return
    }
}

WriteLog(text) {
    FileAppend(A_NowUTC ": " text "`n", "logfile.txt")
}