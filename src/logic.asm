.INCLUDE "defines.i"

.SECTION "Logic" FREE

LoadLevel:
;Player pointer
  LDX LevelIndex
  LDA LevelPlayers.w,X
  AND #$0F
  STA PlayerX
  LDA LevelPlayers.w,X
  AND #$F0
  LSR A
  LSR A
  LSR A
  LSR A
  STA PlayerY
;Level Data
  STX LevelPointer
  LDA #$00
  ASL LevelPointer
  ASL A
  ASL LevelPointer
  ASL A
  ASL LevelPointer
  ASL A
  ASL LevelPointer
  ASL A
  STA LevelPointer+1
  LDA #<LevelData
  ADC LevelPointer
  STA LevelPointer
  LDA #>LevelData
  ADC LevelPointer+1
  STA LevelPointer+1
  LDY #$0F
  LDX #$3F
-
  LDA (LevelPointer),Y
  AND #$03
  JSR TileConv
  STA ActiveLevel,X
  DEX
  LDA (LevelPointer),Y
  AND #$0C
  LSR A
  LSR A
  JSR TileConv
  STA ActiveLevel,X
  DEX
  LDA (LevelPointer),Y
  AND #$30
  LSR A
  LSR A
  LSR A
  LSR A
  JSR TileConv
  STA ActiveLevel,X
  DEX
  LDA (LevelPointer),Y
  ROL A
  ROL A
  ROL A
  AND #$03
  JSR TileConv
  STA ActiveLevel,X
  DEX
  DEY
  BPL -
  RTS

TileConv:
  STY ActiveLevel
  TAY
  LDA TileConvTable,Y
  LDY ActiveLevel
  RTS

TileConvTable:
.db $87,$85,$84,$86

MovePlayer:
  LDA ButtonsChange
  ROL
  BCS MovePlayerRight
  ROL
  BCS MovePlayerLeft
  ROL
  BCS MovePlayerDown
  ROL
  BCS MovePlayerUp
;Player did not move
  RTS
MovePlayerRight:
  LDA PlayerX
  ADC #$00
  AND #$07
  STA PlayerX
  RTS
MovePlayerUp:
  LDA PlayerY
  ADC #$00
  AND #$07
  STA PlayerY
  RTS
MovePlayerLeft:
  LDA PlayerX
  SBC #$01
  AND #$07
  STA PlayerX
  RTS
MovePlayerDown:
  LDA PlayerY
  SBC #$01
  AND #$07
  STA PlayerY
  RTS

CheckBox:
  RTS

MoveBox:
  RTS

CheckWin:
  RTS

.ENDS
