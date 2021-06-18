OUTPUT_FORMAT("elf32-littleriscv")
OUTPUT_ARCH(riscv:rv32)
ENTRY(main)
MEMORY{
	IMEM(rxai): ORIGIN = 0x0, LENGTH = 7934464
	DMEM(wxai): ORIGIN = 0x80000000, LENGTH = 7934464
}
SECTIONS
{
	.text : {
		*(.text.startup .text.startup.*)
		*(.text)
        *(.text.*)
	} > IMEM
	.data : {
		*(.rodata)
        *(.rodata.*)
		*(.sdata)
		*(.sdata.*)
		*(.data)
        *(.data.*)
		. = ALIGN(4);
		__bss_start = .;
		*(.sbss)
		*(.sbss.*)
		*(.bss)
        *(.bss.*)
		__bss_end = . ;
	} > DMEM
}
