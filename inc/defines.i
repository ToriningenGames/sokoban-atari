;Univeral Defines

.DEFINE DrawRoutine     $80
.DEFINE HRoutine        DrawRoutine     +<HBlank
.DEFINE ActiveLevel     HRoutine        +<StartNewLine-<HBlank
.DEFINE LineCounter     ActiveLevel     +$40
.DEFINE LevelIndex      LineCounter     +$01
.DEFINE GraphPos        LevelIndex      +$01

;Storage opcodes are $84, $85, $86, and $87. These correspond to Y, A, X, and AX, respectively.
;Therefore, A and X have to be chosen such that A&X is dark and matches the background
;See kernel for details on why that matters
.DEFINE ColorBox  %11110100    ;Box            A
.DEFINE ColorGoal %11011110    ;Goal           Y
.DEFINE ColorWall %10001010    ;Wall           X
.DEFINE ColorBkg  %10000000    ;Background     AX
