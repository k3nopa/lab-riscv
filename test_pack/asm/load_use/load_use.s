	.text
main:
    # x16 is used to determine
    # data memory address to store data
	li	x16,	0x80010000

    # load sext(00) into x8
	lb	x8,	0x0(x16)
    # load sext(00) into x9
	lb	x9,	0x1(x16)
    # x10 = x8 + x9 = 0000_0000
	add	x10,	x8,	x9
    # store 0000 into 80010002
	sh	x10,	0x2(x16)

    # =====
    # x8: 0000_0000
    # x9: 0000_0000
    # x10: 0000_0000
    # 80010000: 00 00 00 00
    # ======

    # x10 = x10 - 1 = ffff_ffff
	addi	x10,	x10,	-1
    # store ffff_ffff into 80010004
	sw	x10,	0x4(x16)

    # =====
    # x8: 0000_0000
    # x9: 0000_0000
    # x10: ffff_ffff
    # 80010004: ff ff ff ff
    # ======

    # load sext(00) into x8
	lb	x8,	0x8(x16)
    # load ext(00) into x9
	lbu	x9,	0x9(x16)
    # x10 = x8 + x9 = 0000_0000
	add	x10,	x8,	x9
    # store 0000 into 8001000a
	sh	x10,	0xa(x16)

    # =====
    # x8: 0000_0000
    # x9: 0000_0000
    # x10: 0000_0000
    # 80010008: 00 00 00 00
    # 8001000c: 00 00 00 00
    # ======

    # x10 = x10 - 1 = ffff_fff5
	addi	x10,	x10,	-11
    # store ffff_fff5 into 8001000c
	sw	x10,	0xc(x16)
	
    # =====
    # x8: 0000_0000
    # x9: 0000_0000
    # x10: ffff_fff5
    # 8001000c: ff ff ff f5
    # ======

    # load ext(0123) into x8
	lhu	x8,	0x10(x16)
    # load sext(ffff) into x9
	lh	x9,	0x12(x16)
    # x10 = x8 - x9 = 0000_0124
	sub	x10,	x8,	x9
    # store 0000_0124 into 80010014
	sw	x10,	0x14(x16)

    # =====
    # x8: 0000_0123
    # x9: ffff_ffff
    # x10: 0000_0124
    # 80010010: ff ff 01 23
    # 80010014: 00 00 01 24
    # 80010018: 01 23 24 00
    # 8001001c: ff 00 f0 f0
    # ======

    # load sext(2400) into x8
	lh	x8,	0x18(x16)
    # load sext(23) into x9
	lb	x9,	0x1a(x16)
    # x10 = x8 - x9 = 0000_23dd
	sub	x10,	x8,	x9
    # store dd into 8001001b
	sb	x10,	0x1b(x16)

    # =====
    # x8: 0000_2400
    # x9: 0000_0023
    # x10: 0000_23dd
    # 80010018: dd 23 24 00
    # ======

    # 8001001c: ff 00 f0 f0
    # load sext(f0f0) into x8
	lh	x8,	0x1c(x16)
    # load sext(ff00) into x9
	lh	x9,	0x1e(x16)
    # x10 = x8 && x9 = ffff_f000
	and	x10,	x8,	x9
    # store ffff_f000 into 80010020
	sw	x10,	0x20(x16)

    # =====
    # x8: ffff_f0f0
    # x9: ffff_ff00
    # x10: ffff_f000
    # 80010020: ff ff f0 00
    # ======
	
    # x10 = x10 and ffffff00 = fffff000
	andi	x10,	x10,	0xffffff00
	sw	x10,	0x24(x16)

    # =====
    # x10: ffff_f000
    # 80010024: ff ff f0 00
    # ======

    # 8001001c: ff 00 f0 f0
    # load ext(f0f0) into x8
	lhu	x8,	0x1c(x16)
    # load ext(ff00) into x9
	lhu	x9,	0x1e(x16)
    # x10 = x8 || x9 = 0000_fff0
	or	x10,	x8,	x9
    # store 0000_fff0 into 80010028
	sw	x10,	0x28(x16)
    # load ffff_f00f into x30
	li	x30, 	0xfffff00f
    # x10 = 0000_fff0 || fffff00f = ffff_ffff
	or	x10,	x10,	x30
    # store ffff_ffff into 8001002c
	sw	x10,	0x2c(x16)

    # =====
    # x8: 0000_f0f0
    # x9: 0000_ff00
    # x10: ffff_ffff
    # 8001001c: ff 00 f0 f0
    # 80010020: ff ff f0 00
    # 80010024: ff ff f0 00
    # 80010028: 0000_fff0
    # 8001002c: ffff_ffff
    # ======

	lh	x8,	0x1c(x16)
	lhu	x9,	0x1e(x16)
	xor	x10,	x8,	x9
	sw	x10,	0x30(x16)

    # =====
    # x8: ffff_f0f0
    # x9: 0000_ff00
    # x10: ffff_0ff0
    # 80010030: ff ff 0f f0
    # ======

	xori	x10,	x10,	0xffffff00
	sw	x10,	0x34(x16)

    # =====
    # x10: 0000_f0f0
    # 80010034: 00 00 f0 f0
    # ======

	lhu	x8,	0x1c(x16)
	lhu	x9,	0x1e(x16)
	or	x10,	x8,	x9
	xori x10, x10, 0xffffffff
	sw	x10,	0x38(x16)

    # =====
    # x8: 0000_f0f0
    # x9: 0000_ff00
    # x10: ffff_000f
    # 80010038: ff ff 00 0f
    # ======

	lw	x8,	0x3c(x16)
	slli	x10,	x8,	4
	sw	x10,	0x40(x16)

    # =====
    # x8: f0f0_0f00
    # x10: 0f00_f000
    # 80010040: 0f 00 f0 00
    # ======

	srli	x10,	x8,	4
	sw	x10,	0x44(x16)

    # =====
    # x10: 0f0f_00f0
    # 80010044: 0f 0f 00 f0
    # ======

    # NOTE: this is srai? (immediate)
	sra	x10,	x8,	4
	sw	x10,	0x48(x16)

    # =====
    # x10: ffff_f0f0
    # 80010048: ff ff f0 f0
    # ======

	lh	x8,	0x3e(x16)
	srai	x10,	x8,	4
	sw	x10,	0x4c(x16)

    # =====
    # x8: ffff_f0f0
    # x10: ffff_ff0f
    # 8001004c: ff ff ff 0f
    # ======

	lw	x8,	0x3c(x16)
	xor	x9,	x9,	x9
	ori	x9,	x9,	4
	sll	x10,	x8,	x9
	sw	x10,	0x50(x16)

    # =====
    # x8: f0f0_0f00
    # x9: 0000_0004
    # x10: 0f00_f000
    # 80010050: 0f 00 f0 00
    # =====

	srl	x10,	x8,	x9
	sw	x10,	0x54(x16)

    # =====
    # x10: 0f0f_00f0
    # 80010054: 0f 0f 00 f0
    # =====

	sra	x10,	x8,	x9
	sw	x10,	0x58(x16)

    # =====
    # x10: ff0f_00f0
    # 80010058: ff 0f 00 f0
    # =====

	lh	x8,	0x3e(x16)
	sra	x10,	x8,	x9
	sw	x10,	0x5c(x16)

    # =====
    # x8: ffff_f0f0
    # x10: ffff_ff0f
    # 8001005c: ff ff ff 0f
    # =====

	lb	x8,	0x60(x16)
	lb	x9,	0x61(x16)
	slt	x10,	x8,	x8
	sb	x10,	0x64(x16)
	sltu	x10,	x8,	x8
	sb	x10,	0x65(x16)
	slt	x10,	x8,	x9
	sb	x10,	0x66(x16)
	sltu	x10,	x8,	x9
	sb	x10,	0x67(x16)
	lb	x8,	0x62(x16)
	slt	x10,	x8,	x9
	sb	x10,	0x68(x16)
	sltu	x10,	x8,	x9
	sb	x10,	0x69(x16)
	lb	x9,	0x63(x16)
	slt	x10,	x8,	x9
	sb	x10,	0x6a(x16)
	sltu	x10,	x8,	x9
	sb	x10,	0x6b(x16)

    # =====
    # x8: ffff_fff5 (-11)
    # x9: ffff_fff3 (-13)
    # 80010064: 00 00 00 00
    # x8: 0000_0005
    # 80010068: xx xx 01 00
    # x9: 0000_0003
    # 80010068: 00 00 01 00
    # =====

	xor	x10,	x10,	x10
	sw	x10,	0x6c(x16)
	sw	x10,	0x70(x16)
	sw	x10,	0x74(x16)
	sw	x10,	0x78(x16)
	sw	x10,	0x7c(x16)
	sw	x10,	0x80(x16)
	sw	x10,	0x84(x16)
	ori	x10,	x10,	0x1

    # ====
    # 80010000 :00 00 00 00
    # 80010004 :ff ff ff ff
    # 80010008 :00 00 00 00
    # 8001000c :ff ff ff f5
    # 80010010 :ff ff 01 23
    # 80010014 :00 00 01 24
    # 80010018 :dd 23 24 00
    # 8001001c :ff 00 f0 f0
    # 80010020 :ff ff f0 00
    # 80010024 :ff ff f0 00
    # 80010028 :00 00 ff f0
    # 8001002c :ff ff ff ff
    # 80010030 :ff ff 0f f0
    # 80010034 :00 00 f0 f0
    # 80010038 :ff ff 00 0f
    # 8001003c :f0 f0 0f 00
    # 80010040 :0f 00 f0 00
    # 80010044 :0f 0f 00 f0
    # 80010048 :ff 0f 00 f0
    # 8001004c :ff ff ff 0f
    # 80010050 :0f 00 f0 00
    # 80010054 :0f 0f 00 f0
    # 80010058 :ff 0f 00 f0
    # 8001005c :ff ff ff 0f
    # 80010060 :03 05 f3 f5
    # 80010064 :00 00 00 00
    # 80010068 :00 00 01 00
    # 8001006c :00 00 00 00
    # 80010070 :00 00 00 00
    # 80010074 :00 00 00 00
    # 80010078 :00 00 00 00
    # 8001007c :00 00 00 00
    # 80010080 :00 00 00 00
    # 80010084 :00 00 00 00
    # =====

loop:
	li	x30, 0xFF000000
	sw	x0, 0x0(x30)
	beq	x0,	x0,	loop

	.data
	.word	0x3040000	# @10000
	.word	0x0		# @10004
	.word	0x9ff0000	# @10008
	.word	0x0		# @1000c
	.word	0xffff0123	# @10010
	.word	0x0		# @10014
	.word	0x1232400	# @10018
	.word	0xff00f0f0	# @1001c
	.word	0x0		# @10020
	.word	0x0		# @10024
	.word	0x0		# @10028
	.word	0x0		# @1002c
	.word	0x0		# @10030
	.word	0x0		# @10034
	.word	0x0		# @10038
	.word	0xf0f00f00	# @1003c
	.word	0x0		# @10040
	.word	0x0		# @10044
	.word	0x0		# @10048
	.word	0x0		# @1004c
	.word	0x0		# @10050
	.word	0x0		# @10054
	.word	0x0		# @10058
	.word	0x0		# @1005c
	.word	0x305f3f5	# @10060
	.word	0x0		# @10064
	.word	0x0		# @10068

