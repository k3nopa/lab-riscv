	.text
main:
	li	x16,	0x80010000
	li	x17,	8
	add	x15, 	x16,	x17

	
	li	x30, 0xff000000
	sw	x0, 0x0(x30)

	.data
	.word	0x1028182	# @10000

