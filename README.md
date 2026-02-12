# ShadowManor 3D

A thrilling 3D survival horror game built with **Godot Engine 4.3**.

![ShadowManor 3D](https://img.shields.io/badge/Godot-4.3-blue?logo=godot-engine) 

## Overview

**ShadowManor 3D** is a first-person horror game where you must navigate through a haunted mansion filled with undead enemies. Avoid zombies, collect keys from hidden chests, and escape the ShadowManor to survive!

## Features

- **3D First-Person Gameplay**: Immersive first-person perspective with smooth camera controls
- **Intelligent AI Zombies**: Enemy zombies with advanced pathfinding, detection, and attack mechanics
  - Wander randomly when idle
  - Chase the player when detected
  - Perform melee attacks when in range
  - Give up and return to wandering if player escapes
- **Health System**: Start with 100 health and manage damage from zombie attacks
- **Interactive Objects**: Open chests to find keys needed for progression
- **Multiple Levels**: Progress through increasingly challenging levels
- **Pause Menu**: Toggle settings menu in-game to resume or exit
- **Atmospheric Audio**: Background music and sound effects for immersion
- **Dynamic HUD**: Health bar and death/escape notifications

##  Gameplay Mechanics

### Player Controls

| Key | Action |
|-----|--------|
| **W** | Move Forward |
| **S** | Move Backward |
| **A** | Move Left |
| **D** | Move Right |
| **Space** | Jump |
| **Shift** | Sprint (increased movement speed) |
| **E** | Interact (open chests, trigger actions) |
| **ESC** | Toggle Pause Menu |
| **Mouse** | Look Around (captured mouse mode) |

### Objective

1. Navigate through the ShadowManor levels
2. Avoid and escape from zombie enemies
3. Collect keys from chests scattered throughout the mansion
4. Reach the exit to escape the ShadowManor and win!

### Enemy Behavior

**Zombie AI States:**
- **Idle/Wandering**: Walks around randomly with a 50-unit radius
- **Detection Range**: Alerts and begins chasing when you enter a 12-unit radius
- **Chasing**: Pursues you using pathfinding until you escape 18+ units away
- **Attack**: Performs melee attacks every 2 seconds when in 2-unit range
- **Cooldown**: Brief recovery time between attacks

## Screenshots:

<img width="1138" height="646" alt="SM Start" src="https://github.com/user-attachments/assets/a4528daa-ce9b-4ec6-b707-1771ae0d84bc" />

<img width="1138" height="648" alt="Screenshot 2026-02-11 222958" src="https://github.com/user-attachments/assets/4383262a-b5f2-47d0-86ef-09db2c5258a8" />





##  Technical Details

### Technology Stack
- **Engine**: Godot Engine 4.3
- **Physics**: 3D RigidBody and CharacterBody systems
- **AI**: NavigationAgent3D for pathfinding
- **Graphics**: Forward+ rendering pipeline
- **Audio**: Godot's AudioStreamPlayer system


##  Getting Started

### Prerequisites
- **Godot Engine 4.3** or later
- Windows, macOS, or Linux

### Installation

1. Clone the repository:
```bash
git clone https://github.com/JungCyx/ShadowManor3D.git
cd ShadowManor3D
```

2. Open the project in Godot Engine:
   - Launch Godot 4.3
   - Click "Open Project"
   - Navigate to the project folder
   - Click "Select Current Folder"

3. Press **F5** to run the game



##  Game Flow

```
Main Menu (Start/Exit)
    ↓
Level 1 (Navigate & Survive)
    ↓
Level 2 (More Challenging)
    ↓
Level 3 (Final Challenge)
    ↓
Reach Exit → Victory!
    ↓
Return to Main Menu
```

##  Assets Used

- **3D Models**:
  - Rogue character model with animations
  - Zombie NPC models 
  - Furniture and building components 
  - Environmental objects (barrels, chests, tables, etc.)

- **Textures**:
  - Dungeon textures
  - Character textures (diffuse and normal maps)
  - Tile-based floor textures

- **Audio**:
  - Background music (horror-themed)
  - Grunt and zombie sound effects
  - Damage sound effects
  - Unlock/interaction sounds

- **Font**:
  - Minecraftia font for UI

## 🐛 Known Issues / Future Improvements

### Potential Enhancements
- [ ] Additional zombie variations and attack types
- [ ] Weapon system for player combat
- [ ] Collectible items and inventory system
- [ ] More detailed level environments
- [ ] Difficulty settings (Easy, Normal, Hard)
- [ ] Leaderboard system
- [ ] Multiplayer co-op mode
- [ ] Enhanced graphics options and accessibility settings






---

**First Time Creating a Game for a project ( Grateful to my teammates !**)
