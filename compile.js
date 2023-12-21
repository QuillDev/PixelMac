import { readFile, writeFile } from "fs/promises"

const paths = [
    "quill_earth_des"
];

(async () => {
    for (const path of paths) {
        let [raw, template] = await Promise.all([
            readFile("custom/" + path + ".xml.raw", { encoding: "utf-8" }),
            readFile("custom/" + path + ".xml.template", { encoding: "utf-8" })
        ]);

        if (raw.charCodeAt(0) === 0xFEFF) {
            raw = raw.substring(1);
        }

        const compiled = template.replace("<TEMPLATE_MARKER>", raw)
        await writeFile(path + ".xml", compiled, { encoding: "utf-8" });
    }
})();