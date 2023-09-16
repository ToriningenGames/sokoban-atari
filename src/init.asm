.INCLUDE "format.i"
.INCLUDE "registers.i"
.INCLUDE "defines.i"

.BANK 0 SLOT 0

;Vector table
.ORG $FFC
.dw Start       ;Reset
.dw Start       ;Break

.ORG $F00
Start:
;Zero all RAM and TIA registers
 .db $AB,$00    ;LAX #$00       ;This is safe to use here, because we're setting A and X to 0, so no bits can be dropped
-
  DEX
  TXS
  PHA
  BNE -
  CLD
;Initialize the various video registers
  LDA #$05
  STA NUSIZ0
  STA NUSIZ1
  LDA #$64
  STA COLUP0
  LDA #ColorWall
  STA COLUPF
  LDA #ColorBkg
  STA COLUBK
  LDA #$01
  STA CTRLPF
  LDA #$00
  STA PF0
  STA PF1
  STA PF2
;DEBUG: Initialize the RAM Draw routine
  LDX #ActiveLevel-DrawRoutine
-
  LDA RamDrawRoutine.w,X
  STA DrawRoutine,X
  DEX
  BPL -
;Initialize the various important RAM registers
  LDA #$01
  STA LevelIndex
  LDA #>PosPlayer
  STA PlayerPosCode+1
  JSR LoadLevel
  JMP EndOfScreen
 
