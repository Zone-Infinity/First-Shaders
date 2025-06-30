# First-Shaders

```
Template pack which includes most of the basic files, but none of them actually do anything. Using #version 330. Also intended for MC 1.17+.
Made by Bálint
```

### Requirements

- **Minecraft** with Fabric Loader
- **Iris Shaders** (latest version recommended)
- **Sodium** (optional but recommended for better fps)

### Features
- Lighting and shadows
- Translucent colored shadows for glass blocks
- Fog (if enabled)

### Installation

    1. Download this repository as a ZIP or clone it:
   ```bash
   git clone https://github.com/your-username/your-shader-repo.git
   ```
        (Recommended to clone in the shader folder)
    2.	Place the shaderpack folder into: `.minecraft/shaderpacks/`
        (If you can't find the folder, go to 3. and there should be Shader Pack Folder in last step)
    3.	Launch Minecraft → Options → Video Settings → Shaders → Select this pack.

### Customization

- Open `composite.fsh` and turn on `debugMode` just above the main function to compare with and without shaders.
- Open `composite1.fsg` and comment out line 41 for fog.
- Tones of color effects in `composite.fsh`

