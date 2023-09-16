.INCLUDE "format.i"
.INCLUDE "registers.i"
.INCLUDE "defines.i"

;Timing, as always, is rather tight.
;We nail a Sprite x periodically based on where boxes and goals should be shown
;Then, the only thing we need to worry about is whether or not to strobe on precise spots
;Level dimensions are pickily decided to make each strobe fall on an integer, while keeping the level as large as possible

;Here's the screen breakdown:
;Box 1 starts on TIA clock 78  (CPU clock 26)
;Box 2 starts on TIA clock 96  (CPU clock 32)
;Box 3 starts on TIA clock 114 (CPU clock 38)
;Box 4 starts on TIA clock 132 (CPU clock 44)
;Box 5 starts on TIA clock 150 (CPU clock 50)
;Box 6 starts on TIA clock 168 (CPU clock 56)
;Box 7 starts on TIA clock 186 (CPU clock 62)
;Box 8 starts on TIA clock 204 (CPU clock 68)

;...we have 6 cycles. Enough for a branch and a store
;Or, we could have this stored in RAM.

;Notes:
        ;Box player is double-sized, to be 16 pixels wide
        ;For each spot, we will draw either a box, a goal, a wall, or nothing
        ;If goals are shaded boxes, and walls solid boxes, we can ignore the playfield and the ball
                ;then the only concern for each box is color and strobing
                ;Thankfully, this is 3 colors, and we have 3 registers!

;Storage opcodes are $84, $85, $86, and $87. These correspond to Y, A, X, and AX, respectively.
;Therefore, A and X have to be chosen such that A&X is dark and matches the background


.ORG $800
RamDrawRoutine:
;Example
  STX COLUPF       ;Wall
  STX COLUPF       ;Wall
.db  $87 COLUPF    ;Nothing
.db  $87 COLUPF    ;Nothing
  STA COLUPF       ;Box
  NOP
  STY COLUPF       ;Goal
  NOP
  STX COLUPF       ;Wall
  NOP
.db  $87 COLUPF    ;Nothing
.db  $87 COLUPF    ;Nothing
  STA COLUPF       ;Box
  NOP
  STY COLUPF       ;Goal
  JMP HBlank

;During horizontal blank, we need to figure out the following:
        ;Which row of player graphics to draw
        ;Which row of box graphics to draw
;Periodically, we are "between" level rows, and can spend the time refilling the RAM draw routine
;Fill next line of graphics
HBlank:
  LDA (GraphPos-ColorWall,X) ;6  6
  STA GRP0                   ;3  9
  LDA (GraphPos),Y           ;6  15
  STA PF1                    ;3  18
  STA PF2                    ;3  22
  LDA #ColorBox              ;2  24
  DEC GraphPos               ;5  29
;End of drawing this level row?
  BMI EndOfRow               ;2  31
  JMP DrawRoutine

;Jump into the kernel exactly when the beam is right
StartNewLine:
  STA WSYNC
  LDX #$0C
-
  DEX
  BNE -
  LDX #ColorWall
  LDY #ColorGoal
  JMP HBlank

.db  $87 COLUPF    ;Nothing
EndOfRow:
;Level row ended
;Thankfully, we have a few blank lines to load in valuable data with
  ;End of screen?
  DEC LineCounter
  BEQ EndOfScreen
  ;Player data
    ;If player is this row, turn on graphics
  LDA PlayerY
  CMP LineCounter
  BEQ +
  LDA #>GraphicPlayerHide
  BNE ++
+
  LDA #>GraphicPlayerShow
++
  STA GraphPos+1
  LDA #<GraphicPlayerHide
  STA GraphPos
  ;Level data
  
;Return to drawing next level row
  JMP StartNewLine
EndOfScreen:
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  LDA #$02
  STA VBLANK
  STA VSYNC
  LDA #$09
  STA LineCounter
  LDA #$00
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA VSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA VBLANK
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  STA WSYNC
  ;Position the player on screen
  LDA PlayerX           ;3
  STA PlayerPosCode     ;3
  ASL PlayerPosCode     ;5
  JMP (PlayerPosCode)   ;5

.SECTION "Player Position" ALIGN $100 FREE
;Delay function for player positioning
PosPlayer:
  BPL PlayerPos0
  BPL PlayerPos1
  BPL PlayerPos2
  BPL PlayerPos3
  BPL PlayerPos4
  BPL PlayerPos5
  BPL PlayerPos6
  BPL PlayerPos7
PlayerPos7:     ;5
  INC DummyWrite
PlayerPos6:     ;6
  CMP (DummyWrite,X)
PlayerPos5:     ;5
  INC DummyWrite
PlayerPos4:     ;5
  INC DummyWrite
PlayerPos3:     ;5
  INC DummyWrite
PlayerPos2:     ;6
  CMP (DummyWrite,X)
PlayerPos1:     ;5
  INC DummyWrite
PlayerPos0:     ;4
  NOP
  NOP
  STA RESP0
  STA WSYNC
  JMP EndOfRow

.ENDS
