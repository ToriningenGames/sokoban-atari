.INCLUDE "defines.i"

.SECTION "GraphicsPlayerHide" ALIGN $100 FREE

.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00000000
GraphicPlayerHide:
.db %00000000   ;Player Hide ends here

.ENDS

.DEFINE BoxOffset (ColorGoal-17)

.SECTION "GraphicsBoxHide" OFFSET BoxOffset AFTER "GraphicsPlayerHide"

GraphicBox:
.db %11111111
.db %11111111
.db %11111111
.db %11111111
.db %10011001
.db %10011001
.db %10011001
.db %11011101
.db %11011101
.db %10111011
.db %10111011
.db %10011001
.db %10011001
.db %10011001
.db %11111111
.db %11111111
.db %11111111
.db %11111111

.ENDS

.SECTION "GraphicsPlayerShow" ALIGN $100 FREE

.db %00000000
.db %00000000
.db %00000000
.db %00000000
.db %00100100
.db %00100100
.db %00100100
.db %00111100
.db %00111100
.db %00011000
.db %01011010
.db %01011010
.db %01111110
.db %01111110
.db %00111100
.db %00011000
.db %00011000
.db %00111100
.db %00111100
.db %00011000
GraphicPlayerShow:
.db %00000000   ;Player Show ends here

.ENDS

.SECTION "GraphicsBoxShow" OFFSET BoxOffset AFTER "GraphicsPlayerShow"

GraphicBox2:
.db %11111111
.db %11111111
.db %11111111
.db %11111111
.db %10011001
.db %10011001
.db %10011001
.db %11011101
.db %11011101
.db %10111011
.db %10111011
.db %10011001
.db %10011001
.db %10011001
.db %11111111
.db %11111111
.db %11111111
.db %11111111

.ENDS
