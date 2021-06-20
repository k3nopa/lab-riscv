	.text    # text section
main:
    # main program
    add x16, x0, x0
    li  x16, 0x80010000

    csrr x8, mvendorid
    sw  x8, 0x4(x16)

    csrr x8, marchid
    sw  x8, 0x8(x16)

    csrr x8, mimpid
    sw  x8, 0xc(x16)

    csrr x8, mhartid
    sw  x8, 0x10(x16)

    csrr x8, mstatus
    sw  x8, 0x14(x16)

    csrr x8, misa
    sw  x8, 0x18(x16)

    csrr x8, mie
    sw  x8, 0x1c(x16)

    csrr x8, mtvec
    sw  x8, 0x20(x16)

    csrr x8, mcounteren
    sw  x8, 0x24(x16)

    csrr x8, mscratch
    sw  x8, 0x28(x16)

    csrr x8, mepc
    sw  x8, 0x2c(x16)

    csrr x8, mcause
    sw  x8, 0x30(x16)

    csrr x8, mtval
    sw  x8, 0x34(x16)

    csrr x8, mip
    sw  x8, 0x38(x16)

    # Prepare data
    lhu  x18, 0x0(x16)
    lhu  x19, 0x2(x16)
    lw   x20, 0x0(x16)

    # csrrw
    csrrw x22, mscratch, x18
    sw  x22, 0x3c(x16)

    # csrrwi
    csrrwi x22, mscratch, 4
    sw x22, 0x40(x16)

    # csrrs
    csrrs x22, mscratch, x19
    sw  x22, 0x44(x16)

    # csrrsi
    csrrsi x22, mscratch, 8
    sw  x22, 0x48(x16)

    # csrrc
    csrrc x22, mscratch, x20
    sw  x22, 0x4c(x16)

    # csrrci
    csrrci x22, mscratch, 12
    sw  x22, 0x50(x16)

    csrr x22, mscratch
    sw  x22, 0x54(x16)

loop:
	li	x30, 0xff000000
	sw	x0, 0x0(x30)
	beq	x0,	x0,	loop

    # 80010000 :01 02 81 82 data
    # 80010004 :00 00 00 00 mvendorid
    # 80010008 :00 00 00 00 marchid
    # 8001000c :00 00 00 00 mimpid
    # 80010010 :00 00 00 00 mhartid
    # 80010014 :00 00 18 08 mstatus
    # 80010018 :40 00 01 00 misa
    # 8001001c :00 00 00 00 mie
    # 80010020 :00 00 00 04 mtvec
    # 80010024 :00 00 00 00 mcounteren
    # 80010028 :00 00 00 00 mscratch
    # 8001002c :00 00 00 00 mepc
    # 80010030 :00 00 00 00 mcause
    # 80010034 :00 00 00 00 mtval
    # 80010038 :00 00 00 00 mip
    # 8001003c :00 00 00 00
    # 80010040 :00 00 81 82
    # 80010044 :00 00 00 04
    # 80010048 :00 00 01 06
    # 8001004c :00 00 01 0e
    # 80010050 :00 00 00 0c
    # 80010054 :00 00 00 00

	.data    # data section
    .word   0x1028182   # @10000
