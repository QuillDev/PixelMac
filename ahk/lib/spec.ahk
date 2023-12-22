#Requires AutoHotkey v2.0

class spec_type {
    static EARTH_DESTROYER := "Earth Destroyer"

    static LIST := [
        spec_type.EARTH_DESTROYER
    ]
}

class bns_class {
    DoRotation() => Any
}

class skill_set {
    binds := Map()

    is_skill_ready(sid) {
        skill := this.binds.Get(sid, 0)
        if (skill == 0) {
            return false
        }
        result := skill.check.Call()
        WriteLog("Check SID: " sid " Result: " result)
        return result
    }

    try_while_ready(sid) {
        if (this.is_skill_ready(sid)) {
            while (this.is_skill_ready(sid)) {
                this.use(sid)
            }
            return true
        }

        return false
    }

    use(sid) {
        skill := this.binds.Get(sid, 0)
        if (skill == 0) {
            return
        }

        if (DebugMode.Use) {
            WriteLog("Skill Id: " sid " Key: " skill.key)
        }
        SendInput(skill.key)
    }

    try_use(sid) {
        if (this.is_skill_ready(sid)) {
            this.use(sid)
            return true
        }
        return false
    }

    register(sid, skill) {
        this.binds.Set(sid, skill)
    }
}


class skill {
    __New(key, check) {
        this.key := key
        this.check := check
    }
}