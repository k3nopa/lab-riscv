	.text    # text section
main:
    # main program
    add x16, x0, x0
    li  x16, 0x80010000

    # write address of check_mepc to mepc
    lla x9, check_mepc
    csrw mepc, x9

    # record mstatus value before mret
    csrr x8, mstatus
    sw  x8, 0x0(x16)

    # perform mret
    mret

loop:
    li  x30, 0xff000000
    sw  x0, 0x0(x30)
    beq x0, x0, loop

check_mepc:
    # read and store value of mstatus to 80010000
    csrr x8, mstatus
    sw  x8, 0x4(x16)

    # stop program
    j   loop

    # 80010000 :00 00 18 08
    # 80010004 :00 00 18 80

	.data    # data section
