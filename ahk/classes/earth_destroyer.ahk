#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\lib\spec.ahk
#Include %A_ScriptDir%\lib\utility.ahk

delay := 7
class earth_destroyer extends bns_class {
    __New() {
        this.skillset := skill_set()
        this.skillset.register("fury",
            skill("e", () => Utility.GetColor(771, 930) == "0x080808"))
        this.skillset.register("emberstomp",
            skill("3", () => Utility.GetColor(1233, 928) == "0xAD6B2D"))
        this.skillset.register("smash",
            skill("x", () => Utility.GetColor(1236, 925) == "0x66625E"))
        this.skillset.register("mighty_cleave",
            skill("g", () => Utility.GetColor(1114, 768) == "0xDB7527"))
        this.skillset.register("cleave",
            skill("t", () => Utility.GetColor(1115, 928) == "0xC9601B"))
        this.skillset.register("stone_wedge",
            skill("r", () => Utility.GetColor(1074, 929) == "0xA5A18A"))
        this.skillset.register("awk_mighty_cleave",
            skill("g", () => false))
        this.skillset.register("awk_cleave",
            skill("g", () => Utility.GetColor(1129, 937) == "0x149DB0"))
        this.skillset.register("wrath_3",
            skill("g", () => Utility.GetColor(1231, 926) == "0x78726C"))
        this.skillset.register("wrath",
            skill("r", () => Utility.GetColor(1232, 932) == "0x443F40"))

    }

    DoRotation() {
        ; Break out of stone wedge effect
        if (this.skillset.is_skill_ready("stone_wedge")) {
            while (this.skillset.is_skill_ready("stone_wedge")) {
                this.skillset.use("cleave")
                Sleep(delay)
            }
            return
        }

        if (this.skillset.try_use("fury")) {
            Sleep(delay)
        }

        if (this.skillset.try_use("smash")) {
            Sleep(delay)
        }

        if (this.skillset.try_use("emberstomp")) {
            Sleep(delay)
        }

        ; On W3 use cleave or Awk Cleave
        if (this.skillset.is_skill_ready("wrath_3")) {
            sid := this.skillset.is_skill_ready("awk_cleave") ? "awk_cleave" : "cleave"
            while (this.skillset.is_skill_ready("wrath_3")) {
                this.skillset.use(sid)
                Sleep(delay)
            }
        }

        this.skillset.use("wrath")
        Sleep(delay)
    }
}