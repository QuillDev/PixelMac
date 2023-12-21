#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

; everything utility related
class Utility
{
    ;return the color at the passed position
    static GetColor(x, y, &red := -1, &green := -1, &blue := -1)
    {
        color := PixelGetColor(x, y)
        ; color := SubStr(color, 0, 10)
        ; only bitshift if the refs actually got passed to the function
        if (red != -1) {
            red := ((color & 0xFF0000) >> 16)
        }
        if (green != -1) {
            green := ((color & 0xFF00) >> 8)
        }
        if (blue != -1) {
            blue := (color & 0xFF)
        }

        return color
    }

    ;check if BnS is the current active window
    static GameActive()
    {
        return WinActive("ahk_class UnrealWindow")
    }
}