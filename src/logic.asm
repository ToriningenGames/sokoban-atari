.INCLUDE "defines.i"

.SECTION "Logic" FREE

LoadLevel:
  RTS

MovePlayer:
;Move is valid, move the player
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
