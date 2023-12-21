import { readFile, writeFile } from "fs/promises"

(async () => {
    let [raw, template] = await Promise.all([
        readFile("quills_earth_raw.xml", { encoding: "utf-8" }),
        readFile("quills_earth_template.xml", { encoding: "utf-8" })
    ]);

    if (raw.charCodeAt(0) === 0xFEFF) {
        raw = raw.substring(1);
    }

    const compiled = template.replace("<TEMPLATE_MARKER>", raw)
    await writeFile("quills_earth.xml", compiled, { encoding: "utf-8" });
})();