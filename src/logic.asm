.INCLUDE "defines.i"

.SECTION "Logic" FREE

LoadLevel:
;Player pointer
  LDX LevelIndex
  LDA LevelPlayer.w,X
  AND #$0F
  STA PlayerX
  LDA LevelPlayer.w,X
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
  ROL A
  ASL LevelPointer
  ROL A
  ASL LevelPointer
  ROL A
  ASL LevelPointer
  ROL A
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

MovePlayerRight:
  LDA PlayerX
  ADC #$00
  TAX
  LDA PlayerY
  ASL A
  ASL A
  ASL A
  ADC PlayerX
  TAY
  INY
  LDA ActiveLevel,Y
  CMP #$86
  BEQ + ;Wall?
  CMP #$85
  BNE ++ ;Box?
  ;The tile beyond must accept a box
  LDA ActiveLevel+1,Y
  CMP #$86
  BEQ + ;Wall?
  CMP #$85
  BEQ + ;Box?
  ;'Tis a ground or goal beyond
  LDA #$85
  STA ActiveLevel+1,Y
  JSR FinishMove
  STX PlayerX
  RTS
MovePlayerLeft:
  LDA PlayerX
  SBC #$01
  TAX
  LDA PlayerY
  ASL A
  ASL A
  ASL A
  ADC PlayerX
  TAY
  DEY
  LDA ActiveLevel,Y
  CMP #$86
  BEQ + ;Wall?
  CMP #$85
  BNE ++ ;Box?
  ;The tile beyond must accept a box
  LDA ActiveLevel-1,Y
  CMP #$86
  BEQ + ;Wall?
  CMP #$85
  BEQ + ;Box?
  ;'Tis a ground or goal beyond
  LDA #$85
  STA ActiveLevel-1,Y
  JSR FinishMove
++
  STX PlayerX
+
  RTS
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
FinishMove:
  ;Remove the box from the target tile
  ;Was it on a goal?
  TYA
  PHA
    LSR A
    LSR A
    TAY
    LDA (LevelPointer),Y
    STA Temp
  PLA
  TAY
  AND #$03
  BEQ +++
-
  ASL Temp
  ASL Temp
  SEC
  SBC #$01
  BNE -
+++
  LDA Temp
  AND #$C0
  EOR #$80      ;Place whatever was there back
  BEQ +++
;Background
  LDA #$03
+++
;Goal
  CLC
  ADC #$84
  STA ActiveLevel,Y
  RTS
MovePlayerDown:
  LDA PlayerY
  SBC #$01
  TAX
  ASL A
  ASL A
  ASL A
  ADC PlayerX
  TAY
  LDA ActiveLevel,Y
  CMP #$86
  BEQ + ;Wall?
  CMP #$85
  BNE ++ ;Box?
  ;The tile beyond must accept a box
  LDA ActiveLevel-8,Y
  CMP #$86
  BEQ + ;Wall?
  CMP #$85
  BEQ + ;Box?
  ;'Tis a ground or goal beyond
  LDA #$85
  STA ActiveLevel-8,Y
  ;Remove the box from the target tile
  JSR FinishMove
  STX PlayerY
  RTS
MovePlayerUp:
  LDA PlayerY
  ADC #$00
  TAX
  ASL A
  ASL A
  ASL A
  ADC PlayerX
  TAY
  LDA ActiveLevel,Y
  CMP #$86
  BEQ + ;Wall?
  CMP #$85
  BNE ++ ;Box?
  ;The tile beyond must accept a box
  LDA ActiveLevel+8,Y
  CMP #$86
  BEQ + ;Wall?
  CMP #$85
  BEQ + ;Box?
  ;'Tis a ground or goal beyond
  LDA #$85
  STA ActiveLevel+8,Y
  ;Remove the box from the target tile
  JSR FinishMove
++
  STX PlayerY
+
  RTS

CheckWin:
;Look for unfilled goal spots
  LDX #$3F
  LDY #$00
-
  LDA ActiveLevel,X
  CMP #$84
  BNE +
  INY
+
  DEX
  BPL -
  TYA
  RTS

.ENDS
