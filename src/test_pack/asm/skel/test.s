	.text    # text section
main:
        # main program
	lui	$8,	0xff00
	sw	$0,	0($8)

	.data    # data section
