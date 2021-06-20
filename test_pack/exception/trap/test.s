.text
main:
	li s1, 0xf0000000
	lui s2, %hi(START_MESSAGE)
	addi s2, s2, %lo(START_MESSAGE)
P_START_MESSAGE:
	lb 	s3, 0(s2)
	beqz s3, ECALL
	sb 	s3, 0(s1)
	addi	s2, s2, 1
	j 	P_START_MESSAGE
ECALL:	
	ecall
	lui s2, %hi(CHECK_PASSED)
	addi s2, s2, %lo(CHECK_PASSED)
P_END_MESSAGE:
	lb 	s3, 0(s2)
	beqz s3, EXIT
	sb	s3, 0(s1)
	addi	s2, s2, 1
	j P_END_MESSAGE
EXIT:
	li s1, 0xff000000
	sw s0, 0(s1)

.section .rodata

START_MESSAGE:
.string "TRAP TEST\n"

CHECK_PASSED:
.string "CHECK PASSED!!\n"
