* = $E000

viaInit
	lda #$FF
	sta $8002
	sta $8003
	lda #$00
	sta $8000
	sta $8001

countStart
	ldy #$00

firstDigit
	tya
	ldx #$04
shiftLoop
	lsr
	dex
	bne shiftLoop
	and #$0F
	tax
	lda digitCodes,x
	sta $8000

secondDigit
	tya
	and #$0F
	tax
	lda digitCodes,x
	sta $8000

delay
	ldx #$FF
delayLoop
	dex
	bne delayLoop

countFwd
	iny
	tya
	and #$0F
	bne secondDigit
	jmp firstDigit

digitCodes
	.byte $3F
	.byte $06
	.byte $5B
	.byte $4F
	.byte $66
	.byte $6D
	.byte $7D
	.byte $07
	.byte $7F
	.byte $6F
	.byte $77
	.byte $7C
	.byte $39
	.byte $5E
	.byte $79
	.byte $71