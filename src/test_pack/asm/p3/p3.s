	.text
main:
	andi	$16,	$16,	0
	lui	$16,	 1

	lw	$8,	0x0($16)
	lw	$9,	0x4($16)
	add	$10,	$8,	$9
	sw	$10,	0x8($16)

	lw	$8,	0xc($16)
	lw	$9,	0x10($16)
	add	$10,	$8,	$9
	sw	$10,	0x14($16)

	lw	$8,	0x18($16)
	lw	$9,	0x1c($16)
	add	$10,	$8,	$9
	sw	$10,	0x20($16)

	lw	$8,	0x24($16)
	lw	$9,	0x28($16)
	addu	$10,	$8,	$9
	sw	$10,	0x2c($16)

	lw	$8,	0x30($16)
	lw	$9,	0x34($16)
	addu	$10,	$8,	$9
	sw	$10,	0x38($16)

	lw	$8,	0x3c($16)
	lw	$9,	0x40($16)
	addu	$10,	$8,	$9
	sw	$10,	0x44($16)

	lw	$8,	0x48($16)
	lw	$9,	0x4c($16)
	sub	$10,	$8,	$9
	sw	$10,	0x50($16)

	lw	$8,	0x54($16)
	lw	$9,	0x58($16)
	sub	$10,	$8,	$9
	sw	$10,	0x5c($16)

	lw	$8,	0x60($16)
	lw	$9,	0x64($16)
	sub	$10,	$8,	$9
	sw	$10,	0x68($16)

	lw	$8,	0x6c($16)
	lw	$9,	0x70($16)
	subu	$10,	$8,	$9
	sw	$10,	0x74($16)

	lw	$8,	0x78($16)
	lw	$9,	0x7c($16)
	subu	$10,	$8,	$9
	sw	$10,	0x80($16)

	lw	$8,	0x84($16)
	lw	$9,	0x88($16)
	subu	$10,	$8,	$9
	sw	$10,	0x8c($16)

	lw	$8,	0x90($16)
	addi    $10,	$8,	4
	sw	$10,    0x94($16)

	lw	$8,	0x98($16)
	addi    $10,	$8,	-1
	sw	$10,    0x9c($16)

	lw	$8,	0xa0($16)
	addi    $10,	$8,	4
	sw	$10,    0xa4($16)

	lw	$8,	0xa8($16)
	addi    $10,	$8,	-4
	sw	$10,    0xac($16)

	lw	$8,	0xb0($16)
	addiu   $10,	$8,	4
	sw	$10,    0xb4($16)

	lw	$8,	0xb8($16)
	addiu   $10,	$8,	-1
	sw	$10,    0xbc($16)

	lw	$8,	0xc0($16)
	addiu   $10,	$8,	4
	sw	$10,    0xc4($16)

	lw	$8,	0xc8($16)
	addiu   $10,	$8,	-4
	sw	$10,    0xcc($16)

	lw	$8,	0xd0($16)
	lw	$9,	0xd4($16)
	and	$10,	$8,	$9
	sw	$10,	0xd8($16)

	lw	$8,	0xdc($16)
	lw	$9,	0xe0($16)
	or	$10,	$8,	$9
	sw	$10,	0xe4($16)

	lw	$8,	0xe8($16)
	lw	$9,	0xec($16)
	xor	$10,	$8,	$9
	sw	$10,	0xf0($16)

	lw	$8,	0xf4($16)
	lw	$9,	0xf8($16)
	nor	$10,	$8,	$9
	sw	$10,	0xfc($16)

	lw	$8,	0x100($16)
	andi    $10,	$8,	0xf0f0
	sw	$10,    0x104($16)

	lw	$8,	0x108($16)
	ori     $10,	$8,	0xf0f0
	sw	$10,    0x10c($16)

	lw	$8,	0x110($16)
	xori    $10,	$8,	0xf0f0
	sw	$10,    0x114($16)

	lw	$8,	0x118($16)
	sll     $10,	$8,	4
	sw	$10,    0x11c($16)

	lw	$8,	0x120($16)
	srl     $10,	$8,	8
	sw	$10,    0x124($16)

	lw	$8,	0x128($16)
	sra     $10,	$8,	12
	sw	$10,    0x12c($16)

	lw	$8,	0x130($16)
	lw	$9,	0x134($16)
	sllv	$10,	$8,	$9
	sw	$10,	0x138($16)

	lw	$8,	0x13c($16)
	lw	$9,	0x140($16)
	srlv	$10,	$8,	$9
	sw	$10,	0x144($16)

	lw	$8,	0x148($16)
	lw	$9,	0x14c($16)
	srav	$10,	$8,	$9
	sw	$10,	0x150($16)

	lw	$8,	0x154($16)
	lw	$9,	0x158($16)
	slt	$10,	$8,	$8
	sw	$10,	0x15c($16)

	slt	$10,	$8,	$9
	sw	$10,	0x160($16)

	slt	$10,	$9,	$8
	sw	$10,	0x164($16)

	lw	$8,	0x168($16)
	lw	$9,	0x16c($16)
	slt	$10,	$8,	$9
	sw	$10,	0x170($16)

	slt	$10,	$9,	$8
	sw	$10,	0x174($16)

	lw	$8,	0x178($16)
	lw	$9,	0x17c($16)
	slt	$10,	$8,	$9
	sw	$10,	0x180($16)

	slt	$10,	$9,	$8
	sw	$10,	0x184($16)

	lw	$8,	0x188($16)
	lw	$9,	0x18c($16)
	sltu	$10,	$8,	$8
	sw	$10,	0x190($16)

	sltu	$10,	$8,	$9
	sw	$10,	0x194($16)

	sltu	$10,	$9,	$8
	sw	$10,	0x198($16)

	lw	$8,	0x19c($16)
	lw	$9,	0x1a0($16)
	sltu	$10,	$8,	$9
	sw	$10,	0x1a4($16)

	sltu	$10,	$9,	$8
	sw	$10,	0x1a8($16)

	lw	$8,	0x1ac($16)
	lw	$9,	0x1b0($16)
	sltu	$10,	$8,	$9
	sw	$10,	0x1b4($16)

	sltu	$10,	$9,	$8
	sw	$10,	0x1b8($16)

	lw	$8,	0x1bc($16)
	slti	$10,	$8,	3
	sw	$10,	0x1c0($16)

	slti	$10,	$8,	5
	sw	$10,	0x1c4($16)

	slti	$10,	$8,	1
	sw	$10,	0x1c8($16)

	slti	$10,	$8,	-1
	sw	$10,	0x1cc($16)

	lw	$8,	0x1d0($16)
	slti	$10,	$8,	3
	sw	$10,	0x1d4($16)

        slti	$10,	$8,	-11
	sw	$10,	0x1d8($16)

	lw	$8,	0x1dc($16)
	sltiu	$10,	$8,	3
	sw	$10,	0x1e0($16)

	sltiu	$10,	$8,	5
	sw	$10,	0x1e4($16)

	sltiu	$10,	$8,	1
	sw	$10,	0x1e8($16)

	sltiu	$10,	$8,	-1
	sw	$10,	0x1ec($16)

	lw	$8,	0x1f0($16)
	sltiu	$10,	$8,	3
	sw	$10,	0x1f4($16)

        sltiu	$10,	$8,	-11
	sw	$10,	0x1f8($16)
	
	xor	$10,	$10,	$10
	lui	$10,	0xffff
	sw	$10,	0x1fc($16)	
	
	xor	$8,	$8,	$8
	addi	$8,	$8,	3
	xor	$9,	$9,	$9
	addi	$9,	$9,	-3
	xor	$10,	$10,	$10
	ori	$10,	$10,	1

	j	L1
	sw	$10,	0x200($16)
L1:
	jal	L2
	sw	$10,	0x204($16)
	jr	$31
L2:
	ori	$10,	$10,	0x3
	jalr	$31
L3:
	beq	$8,	$8,	L4
	sw	$10,	0x208($16)
L4:
	beq	$8,	$9,	L5
	sw	$10,	0x20c($16)
L5:
	bne	$8,	$8,	L6
	sw	$10,	0x210($16)
L6:
	bne	$8,	$9,	L7
	sw	$10,	0x214($16)
L7:
	blez	$8,	L8
	sw	$10,	0x218($16)
L8:
	blez	$0,	L9
	sw	$10,	0x21c($16)
L9:
	blez	$9,	L10
	sw	$10,	0x220($16)
L10:
	bgtz	$8,	L11
	sw	$10,	0x224($16)
L11:
	bgtz	$0,	L12
	sw	$10,	0x228($16)
L12:
	bgtz	$9,	L13
	sw	$10,	0x22c($16)
L13:
	bgez	$8,	L14
	sw	$10,	0x230($16)
L14:
	bgez	$0,	L15
	sw	$10,	0x234($16)
L15:
	bgez	$9,	L16
	sw	$10,	0x238($16)
L16:
	bgezal	$8,	L17
	sw	$10,	0x23c($16)
L17:
	bgezal	$0,	L18
	sw	$10,	0x240($16)
L18:
	bgezal	$9,	L19
	sw	$10,	0x244($16)
L19:
	bgezal	$0,	L20
	sw	$10,	0x248($16)
	j	L21
L20:
	ori	$10,	$10,	0x7
	jr	$31
L21:
	bltz	$8,	L22
	sw	$10,	0x24c($16)
L22:
	bltz	$0,	L23
	sw	$10,	0x250($16)
L23:
	bltz	$9,	L24
	sw	$10,	0x254($16)
L24:
	bltzal	$8,	L25
	sw	$10,	0x258($16)
L25:
	bltzal	$0,	L26
	sw	$10,	0x25c($16)
L26:
	bltzal	$9,	L27
	sw	$10,	0x260($16)
L27:
	bltzal	$9,	L28
	sw	$10,	0x264($16)
	j	L29
L28:
	ori	$10,	$10,	0xf
	jr	$31
L29:
	beq	$0,	$0,	L29

	.data
	.word	0x3		# @10000
	.word	0x5		# @10004
	.word	0x0		# @10008
	.word	0x7fffffff	# @1000c
	.word	0x5		# @10010
	.word	0x0		# @10014
	.word	0x80000000	# @10018
	.word	0xfffffff3	# @1001c
	.word	0x0		# @10020
	.word	0x3		# @10024
	.word	0x5		# @10028
	.word	0x0		# @1002c
	.word	0x7fffffff	# @10030
	.word	0x5		# @10034
	.word	0x0		# @10038
	.word	0x80000000	# @1003c
	.word	0xfffffff3	# @10040
	.word	0x0		# @10044
	.word	0x3		# @10048
	.word	0x4		# @1004c
	.word	0x0		# @10050
	.word	0x7fffffff	# @10054
	.word	0xfffffff3	# @10058
	.word	0x0		# @1005c
	.word	0x80000000	# @10060
	.word	0x5		# @10064
	.word	0x0		# @10068
	.word	0x5		# @1006c
	.word	0x3		# @10070
	.word	0x0		# @10074
	.word	0x7fffffff	# @10078
	.word	0xfffffff3	# @1007c
	.word	0x0		# @10080
	.word	0x80000000	# @10084
	.word	0x5		# @10088
	.word	0x0		# @1008c
	.word	0x3		# @10090
	.word	0x0		# @10094
	.word	0x3		# @10098
	.word	0x0		# @1009c
	.word	0x7fffffff	# @100a0
	.word	0x0		# @100a4
	.word	0x80000000	# @100a8
	.word	0x0		# @100ac
	.word	0x3		# @100b0
	.word	0x0		# @100b4
	.word	0x3		# @100b8
	.word	0x0		# @100bc
	.word	0x7fffffff	# @100c0
	.word	0x0		# @100c4
	.word	0x80000000	# @100c8
	.word	0x0		# @100cc
	.word	0xff00ff	# @100d0
	.word	0xf0ff0f0	# @100d4
	.word	0x0		# @100d8
	.word	0xff00ff	# @100dc
	.word	0xf0ff0f0	# @100e0
	.word	0x0		# @100e4
	.word	0xff00ff	# @100e8
	.word	0xf0ff0f0	# @100ec
	.word	0x0		# @100f0
	.word	0xff00ff	# @100f4
	.word	0xf0ff0f0	# @100f8
	.word	0x0		# @100fc
	.word	0xff00ff00	# @10100
	.word	0x0		# @10104
	.word	0xff00ff00	# @10108
	.word	0x0		# @1010c
	.word	0xff00ff00	# @10110
	.word	0x0		# @10114
	.word	0xf0f00f0f	# @10118
	.word	0x0		# @1011c
	.word	0xf0f00f0f	# @10120
	.word	0x0		# @10124
	.word	0xf0f00f0f	# @10128
	.word	0x0		# @1012c
	.word	0xf0f00f0f	# @10130
	.word	0x4		# @10134
	.word	0x0		# @10138
	.word	0xf0f00f0f	# @1013c
	.word	0x8		# @10140
	.word	0x0		# @10144
	.word	0xf0f00f0f	# @10148
	.word	0xc		# @1014c
	.word	0x0		# @10150
	.word	0x3		# @10154
	.word	0x5		# @10158
	.word	0x0		# @1015c
	.word	0x0		# @10160
	.word	0x0		# @10164
	.word	0xfffffff3	# @10168
	.word	0x5		# @1016c
	.word	0x0		# @10170
	.word	0x0		# @10174
	.word	0xfffffff3	# @10178
	.word	0xfffffff5	# @1017c
	.word	0x0		# @10180
	.word	0x0		# @10184
	.word	0x3		# @10188
	.word	0x5		# @1018c
	.word	0x0		# @10190
	.word	0x0		# @10194
	.word	0x0		# @10198
	.word	0xfffffff3	# @1019c
	.word	0x5		# @101a0
	.word	0x0		# @101a4
	.word	0x0		# @101a8
	.word	0xfffffff3	# @101ac
	.word	0xfffffff5	# @101b0
	.word	0x0		# @101b4
	.word	0x0		# @101b8
	.word	0x3		# @101bc
	.word	0x0		# @101c0
	.word	0x0		# @101c4
	.word	0x0		# @101c8
	.word	0x0		# @101cc
	.word	0xffffffff	# @101d0
	.word	0x0		# @101d4
	.word	0x0		# @101d8
	.word	0x3		# @101dc
	.word	0x0		# @101e0
	.word	0x0		# @101e4
	.word	0x0		# @101e8
	.word	0x0		# @101ec
	.word	0xffffffff	# @101f0
	.word	0x0		# @101f4
	.word	0x0		# @101f8
	.word	0x0		# @101fc
	.word	0x0		# @10200
	.word	0x0		# @10204
	.word	0x0		# @10208
	.word	0x0		# @1020c
	.word	0x0		# @10210
	.word	0x0		# @10214
	.word	0x0		# @10218
	.word	0x0		# @1021c
	.word	0x0		# @10220
	.word	0x0		# @10224
	.word	0x0		# @10228
	.word	0x0		# @1022c
	.word	0x0		# @10230
	.word	0x0		# @10234
	.word	0x0		# @10238
	.word	0x0		# @1023c
	.word	0x0		# @10240
	.word	0x0		# @10244
	.word	0x0		# @10248
	.word	0x0		# @1024c
	.word	0x0		# @10250
	.word	0x0		# @10254
	.word	0x0		# @10258
	.word	0x0		# @1025c
	.word	0x0		# @10260
	.word	0x0		# @10264

