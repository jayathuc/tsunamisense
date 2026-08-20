# TsunamiSense — App Logo & Icons

## The logo
A flat, ocean-themed app mark: a **deep-blue → teal gradient** (the sea), a bold **white wave** at the base (the tsunami / coast), and a **green location pin** (a *safe shelter*) sitting above the water with a soft beacon glow. Reads instantly at 48 px, ties to the app's brand colours, and says "a safe place, above the wave."

**Brand colours**
| Role | Hex |
|---|---|
| Deep blue (trust) | `#0D47A1` |
| Primary blue | `#1565C0` |
| Teal (ocean) | `#00BCD4` |
| Safe green (shelter pin) | `#4CAF50` |
| White (wave) | `#FFFFFF` |

## Source files (vector — edit these)
| File | Purpose |
|---|---|
| `app_icon.svg` | **Master** icon, full-bleed 1024² (used for iOS, legacy Android, web, store) |
| `app_icon_background.svg` | Android **adaptive background** (gradient + waves, full bleed) |
| `app_icon_foreground.svg` | Android **adaptive foreground** (pin only, centred in the safe zone) |
| `wordmark.svg` / `wordmark_dark.svg` | Horizontal lockup (icon + "TsunamiSense" + "Powered by GETRA"), for light / dark backgrounds |
| `playstore_icon_512.png` | 512² store icon |

## Generated app icons (do NOT hand-edit — regenerate instead)
Produced by **`flutter_launcher_icons`** (config in `pubspec.yaml`) from the PNGs in this folder:
- Android legacy: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- Android adaptive: `mipmap-anydpi-v26/ic_launcher.xml` + `drawable-*/ic_launcher_foreground.png` + `…_background.png`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/*`
- Web: `web/icons/Icon-*.png`, `web/favicon.png`

### Regenerate after any logo change
```bash
# 1. re-rasterise the SVGs to PNG (needs librsvg: brew install librsvg)
cd assets/icon
rsvg-convert -w 1024 -h 1024 app_icon.svg            -o app_icon.png
rsvg-convert -w 1024 -h 1024 app_icon_foreground.svg -o app_icon_foreground.png
rsvg-convert -w 1024 -h 1024 app_icon_background.svg -o app_icon_background.png
# 2. regenerate every platform icon from those PNGs
cd ../.. && dart run flutter_launcher_icons
```

## In-app wordmark (optional, ready to use)
`assets/images/logo_wordmark.png` (dark text, light bg) and `assets/images/logo_wordmark_dark.png` (white text, dark bg) — drop into the About dialog or a splash screen, e.g. `Image.asset('assets/images/logo_wordmark.png', height: 64)`.

---

## Reference: required icon sizes (for manual / store work)
| Platform | Sizes |
|---|---|
| Android launcher | 48, 72, 96, 144, 192 px (mdpi→xxxhdpi) |
| Android adaptive | 108 dp drawable, **inner 72 dp = safe zone** (keep the pin inside it) |
| iOS AppIcon | 20–1024 pt @1×/2×/3× (the tool fills the whole set) |
| Play Store | icon **512²**, feature graphic **1024×500** |
| App Store | **1024²**, no alpha, no rounded corners |
| Web / PWA | 192², 512², maskable 192²/512², favicon |

---

## Optional: generate an *illustrated* variant with Gemini "nano banana" (via Antigravity)

The current logo is a clean **flat vector** mark (recommended for app icons — crisp at every size). If you also want a richer **illustrated** option to compare, hand these prompts to **Gemini 2.5 Flash Image ("nano banana")** in Antigravity. Notes that matter:
- nano banana outputs **~1024² raster**. Generate the **symbol only** — do **not** ask it to render the words "TsunamiSense" (image models garble text; use `wordmark.svg` for type).
- Ask for **no text**, **flat / minimal**, **centred**, **full-bleed square** so it works as an icon.
- After it saves the image, run the **Regenerate** command above to rebuild all platform icons.

**Prompt A — primary app icon (full-bleed master → `assets/icon/app_icon.png`, 1024×1024)**
> Design a modern, flat mobile **app icon**, 1024×1024 px, full-bleed square, no rounded corners, **no text**. A smooth diagonal ocean gradient from deep navy blue `#0D47A1` (top-left) to bright teal `#00BCD4` (bottom-right). At the bottom, two layered **clean white waves** (a stylised calm sea). Centred above the water, a single bold **green map location pin** `#4CAF50` with a white circular hole in its head and a soft white beacon glow behind it. Minimal, geometric, high contrast, flat vector style, no gradients on the pin, no drop shadows except a subtle one under the pin, no photorealism, no lettering. Save as `app_icon.png`.

**Prompt B — alternative concept: shielded wave (compare)**
> Flat **app icon**, 1024×1024, full-bleed square, **no text**. Ocean blue-to-teal gradient background. A centred white **shield** outline containing a single stylised **wave curl**, with a small **green check or pin** at the top of the shield to signal safety. Minimal, geometric, flat vector, high contrast, no photorealism, no words.

**Prompt C — adaptive foreground (transparent pin → `assets/icon/app_icon_foreground.png`, 1024×1024)**
> A single **green map location pin** `#4CAF50` with a white circular hole in the head, centred on a **fully transparent background**, occupying the middle ~55% of a 1024×1024 canvas, flat vector, soft shadow under the tip, **no text, no background**. (Pair with `app_icon_background.png`, the gradient+waves, for the Android adaptive icon.)

**Prompt D — notification / monochrome glyph (optional)**
> A simple **white** silhouette of a location pin above a small wave, on a transparent background, 1024×1024, centred, flat, single colour white, **no text** — for an Android status-bar notification icon.

**Handoff one-liner for Antigravity:**
> "Generate the image from Prompt A at 1024×1024 and save it to `tsunamisense_app/assets/icon/app_icon.png` (overwrite). Then in `tsunamisense_app/` run `dart run flutter_launcher_icons` to rebuild all Android/iOS/web icons."
