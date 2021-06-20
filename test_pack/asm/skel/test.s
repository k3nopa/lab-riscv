	.text
main:
	li	x1,	1
	li	x2,	5

loop:
    addi x3, x3, 1
    bne x3, x2, loop
    
stop:
    li  x30, 0xff000000
    sw  x0, 0x0(x30)

