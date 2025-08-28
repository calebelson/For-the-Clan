# For The Clan WoW Addon

A World of Warcraft addon that automatically yells and plays sounds when you receive major haste/heroism effects. Perfect for announcing important raid buffs and roleplay activities!

## Features

- **LibDBIcon Minimap Button**: Minimap integration
- **Multi-Language Support**: Sounds and yells available in 10 languages
- **Haste Effect Detection**: Monitors important raid buffs like Bloodlust, Heroism, Time Warp
- **Customizable Audio**: Select from language-specific "For the Horde!" sound clips
- **Customizable Yells**: Choose yell messages in different languages
- **Version Compatible**: Works in MoP Classic and Retail WoW
- **Options Integration**: Appears in WoW's Interface/AddOns options panel
- **Saved Settings**: Your preferences persist between sessions

## Installation

### CurseForge (Recommended)
Search "For The Clan" on CurseForge or [go here](https://www.curseforge.com/wow/addons/for-the-clan) to download directly.

### Manual Installation
1. Download the addon files from the GitHub repository
2. Extract to your WoW AddOns folder:
   - **Retail**: `World of Warcraft/_retail_/Interface/AddOns/ForTheClan/`
   - **MoP Classic**: `World of Warcraft/_classic_/Interface/AddOns/ForTheClan/`
3. Restart WoW or reload UI (`/reload`)
4. Look for the red Horde symbol minimap button

## Usage

### Basic Controls
- **Minimap Button**: Left-click to open configuration
- **Slash Commands**: 
  - `/ftc` - Open configuration
  - `/fortheclan` - Open configuration
- **Options Panel**: Found in Interface → AddOns → For The Clan

### Configuration
1. Click the minimap button or use a slash command
2. **Yell**: Select your preferred language for yell messages
3. **Sound**: Choose a language for the "For the Horde!" sound clip
4. **Show Minimap Button**: Toggle minimap button visibility
5. Settings save automatically when changed

### How It Works
- The addon monitors your character for haste/heroism effects
- When you receive a monitored buff, it automatically:
  - Plays the selected "For the Horde!" sound
  - Sends the chosen yell message to /yell chat
- Only triggers once per buff application
- **Note**: Yell messages are restricted outside of instances by Blizzard

## Monitored Buffs

The addon automatically detects these haste/heroism effects:
- Ancient Hysteria
- Bloodlust  
- Drums of Fury
- Drums of the Mountain
- Heroism
- Netherwinds
- Time Warp
- Mallet of Thunderous Skins
- Drums of the Maelstrom
- Drums of Deathly Ferocity
- Fury of the Aspects
- Primal Rage
- Feral Hide Drums
- Timeless Drums
- Lightning Shield
- Thunderous Drums

## Available Languages

Both sounds and yells are available in:
- **Chinese** (中文) - "为了部落"
- **English** - "For The Horde!"
- **French** (Français) - "Pour la Horde!"
- **German** (Deutsch) - "Für die Horde!"
- **Italian** (Italiano) - "Per l'Orda"
- **Korean** (한국어) - "호드를 위하여!"
- **Portuguese** (Português) - "Pela Horda!"
- **Russian** (Русский) - "За Орду!!"
- **Spanish** (Español) - "¡Por la Horda!"
- **Nothing** - Disables sound/yell

## Project Structure

```
ForTheClan/
├── assets/
│   ├── sounds/
│   │   ├── ForTheHordeBR.mp3   # Portuguese
│   │   ├── ForTheHordeCN.mp3   # Chinese
│   │   ├── ForTheHordeDE.mp3   # German
│   │   ├── ForTheHordeEN.mp3   # English
│   │   ├── ForTheHordeES.mp3   # Spanish
│   │   ├── ForTheHordeFR.mp3   # French
│   │   ├── ForTheHordeIT.mp3   # Italian
│   │   ├── ForTheHordeKR.mp3   # Korean
│   │   ├── ForTheHordeLA.mp3   # Latin America
│   │   └── ForTheHordeRU.mp3   # Russian
│   └── HordeSymbolIcon64.tga   # Custom minimap icon
├── libs/
│   ├── LibStub/
│   ├── CallbackHandler-1.0/
│   ├── LibDataBroker-1.1/
│   └── LibDBIcon-1.0/
├── ForTheClan.lua              # Main addon code
├── ForTheClan.toc              # Addon metadata
└── README.md                   # This file
```

## Technical Details

- **Libraries Used**: LibStub, CallbackHandler-1.0, LibDataBroker-1.1, LibDBIcon-1.0
- **Event Handling**: UNIT_AURA for buff detection, ADDON_LOADED for initialization
- **API Compatibility**: Uses UnitBuff() for MoP Classic/Retail compatibility
- **Settings Storage**: ForTheClanDB saved variable with minimap position persistence

## Troubleshooting

- **Addon not loading**: Verify files are in the correct AddOns folder and restart WoW
- **No minimap button**: Check if hidden in configuration, try `/reload`
- **Black minimap icon**: Ensure HordeSymbolIcon64.tga is in the assets folder
- **Sounds not playing**: Verify sound files are in assets/sounds/ folder
- **No yells in the open world**: This is a Blizzard restriction, yells work in instances

## Requirements

- **WoW Version**: MoP Classic (5.4.0) or Retail
- **Dependencies**: All required libraries are included (no external dependencies)
- **Permissions**: Addon must be able to save variables for settings persistence

## Version History

- **1.1.3**: Bug fix
  - Fixed "Nothing" yell option to properly disable yells instead of sending "Nothing"
- **1.1.2**: Sound system improvement
  - Fixed sound play button functionality on initial configuration load
- **1.1.1**: UI enhancements
  - Added immediate minimap button toggle functionality
  - Improved user interface responsiveness
- **1.1.0**: Enhanced user experience
  - Added sound preview functionality with play button
  - Added yell text display with quotes for better clarity
  - Improved configuration window layout
- **1.0.1**: Compatibility update
  - Updated interface version for latest WoW compatibility
- **1.0.0**: Initial release
  - LibDBIcon minimap integration
  - Multi-language sound and yell support
  - Professional configuration UI
  - Buff detection for major haste effects
  - Options panel integration

## Development

### Customization
- **Adding Buffs**: Edit `buffList` in ForTheClan.lua
- **Adding Languages**: Add entries to `soundList` and `yellList` arrays
- **Custom Sounds**: Place .mp3 files in assets/sounds/ and update soundList

### Contributing
The addon follows standard WoW addon development practices with proper library integration and clean code organization.
