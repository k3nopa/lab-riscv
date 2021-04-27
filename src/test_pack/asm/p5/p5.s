	.text
main:
	andi	$16,	$16,	0
	lui	$16,	 1

	xor	$8,	$8,	$8
	addi	$8,	$8,	3	# $8 = 3
	xor	$9,	$9,	$9
	addi	$9,	$9,	-3	# $9 = -3
	xor	$10,	$10,	$10	# $10 = 0

	addi	$10,	$10,	1	# $10 = 0x1
	
	j	L01
	sb	$10,	0x0($16)
L01:
	addi	$10,	$10,	1	# $10 = 0x2	
	jal	L02
	sw	$31,	0x1c($16)
	sb	$10,	0x2($16)
	jr	$31
L02:
	addi	$10,	$10,	1	# $10 = 0x3
	sw	$31,	0x20($16)
	sb	$10,	0x3($16)
	jalr	$31
L03:
	addi	$10,	$10,	1	# $10 = 0x4
	beq	$8,	$8,	L04     # Taken
	sb	$10,	0x4($16)
L04:
	addi	$10,	$10,	1	# $10 = 0x5
	beq	$8,	$9,	L05     # Not Taken
	sb	$10,	0x5($16)
L05:
	addi	$10,	$10,	1	# $10 = 0x6
	bne	$8,	$8,	L06     # Not Taken
	sb	$10,	0x6($16)
L06:
	addi	$10,	$10,	1	# $10 = 0x7
	bne	$8,	$9,	L07     # Taken
	sb	$10,	0x7($16)
L07:
	addi	$10,	$10,	1	# $10 = 0x8
	blez	$8,	L08             # Not Taken
	sb	$10,	0x8($16)
L08:
	addi	$10,	$10,	1	# $10 = 0x9
	blez	$0,	L09             # Taken
	sb	$10,	0x9($16)
L09:
	addi	$10,	$10,	1	# $10 = 0xa
	blez	$9,	L0a             # Taken
	sb	$10,	0xa($16)
L0a:
	addi	$10,	$10,	1	# $10 = 0xb
	bgtz	$8,	L0b             # Taken
	sb	$10,	0xb($16)
L0b:
	addi	$10,	$10,	1	# $10 = 0xc
	bgtz	$0,	L0c             # Not Taken
	sb	$10,	0xc($16)
L0c:
	addi	$10,	$10,	1	# $10 = 0xd
	bgtz	$9,	L0d             # Not Taken
	sb	$10,	0xd($16)
L0d:
	addi	$10,	$10,	1	# $10 = 0xe
	bgez	$8,	L0e             # Taken
	sb	$10,	0xe($16)
L0e:
	addi	$10,	$10,	1	# $10 = 0xf
	bgez	$0,	L0f             # Taken
	sb	$10,	0xf($16)
L0f:
	addi	$10,	$10,	1	# $10 = 0x10
	bgez	$9,	L10             # Not Taken
	sb	$10,	0x10($16)
L10:
	addi	$10,	$10,	1	# $10 = 0x11
	bgezal	$8,	L11             # Taken
	sb	$10,	0x11($16)
L11:
	addi	$10,	$10,	1	# $10 = 0x12
	sw	$31,	0x24($16)
	bgezal	$0,	L12             # Taken
	sb	$10,	0x12($16)
L12:
	addi	$10,	$10,	1	# $10 = 0x13
	sw	$31,	0x28($16)
	bgezal	$9,	L13             # Not Taken
	sb	$10,	0x13($16)
L13:
	addi	$10,	$10,	1	# $10 = 0x14
	sw	$31,	0x2c($16)
	bltz	$8,	L14             # Not Taken
	sb	$10,	0x14($16)
L14:
	addi	$10,	$10,	1	# $10 = 0x15
	bltz	$0,	L15             # Not Taken
	sb	$10,	0x15($16)
L15:
	addi	$10,	$10,	1	# $10 = 0x16
	bltz	$9,	L16             # Taken
	sb	$10,	0x16($16)
L16:
	addi	$10,	$10,	1	# $10 = 0x17
	bltzal	$8,	L17             # Not Taken
	sb	$10,	0x17($16)
L17:
	addi	$10,	$10,	1	# $10 = 0x18
	sw	$31,	0x30($16)
	bltzal	$0,	L18             # Not Taken
	sb	$10,	0x18($16)
L18:
	addi	$10,	$10,	1	# $10 = 0x19
	sw	$31,	0x34($16)
	bltzal	$9,	L19             # Taken
	sb	$10,	0x19($16)
L19:
	sw	$31,	0x38($16)
Loop:
	beq	$0,	$0,	Loop

