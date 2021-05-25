	.text    # text section
main:
	li	x1,	0x2
	li	x1,	0x3
	jal	x3,	calc

stop:
	li	x8,	0xff000000
	sw	x0,	0(x8)

calc:
	add	x4,	x1,	x2
	jr	x3

	.data    # data section
	.word	0x01028182
