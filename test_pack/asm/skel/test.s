	.text    # text section
main:
	lui	x1,	0x4
	lui	x2,	0x8

	add	x3,	x1,	x2

	lui	x8,	0xff000000
	sw	x0,	0(x8)

	.data    # data section
