	.text
main:
	li	x1, 0x1
	li	x2, 0x5
	jal	loop

stop:
	li	x22, 0xFF000000
	sw	x0, 0x0(x22)

loop:
	addi	x3,	x1,	0x1
	bne	x3,	x2,	loop
	ret

	.data

