	.text    # text section
main:
	li	x16,	0x80010000
	li	x10,	0x0
	li	x10,	0x5
	li	x10,	0x3
	lw	x11,	0x0(x16)

	j	L1

	sb	x10,	0x4(x16)
	nop
L1:
	jal	L2
	sb	x10,	0x8(x16)
	ret
L2:
	ori	x10,	x10,	0x3
	jalr	x1
L3:
	xor	x8,	x8,	x8
	addi	x8,	x8,	0x03
	xor	x9,	x9,	x9
	addi	x9,	x9,	-1
	beq	x8,	x8,	stop
	sb	x10,	0x6e(x16)

stop:
	li	x30,	0xff000000
	sw	x0,	0x0(x30)

	.data    # data section
	.word	0x01028182
