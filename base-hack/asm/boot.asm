.definelabel dataStart, 0x01FED020
.definelabel dataRDRAM, 0x807FF800
.definelabel musicInfo, 0x01FFF000
.definelabel itemROM, 0x01FF3000
.definelabel codeEnd, 0x805FAE00
.definelabel itemdatasize, 0x30

START:
	displacedBootCode:
		// Load Variable Space
		lui $a0, hi(dataStart)
		lui $a1, hi(dataStart + 0x200)
		addiu $a1, $a1, lo(dataStart + 0x200)
		addiu $a0, $a0, lo(dataStart)
		lui $a2, 0x807F
		jal dmaFileTransfer
		ori $a2, $a2, 0xF800 //RAM location to copy to
		
		// Load item data
		lui $a0, hi(itemROM)
		lui $a1, hi(itemROM + itemdatasize)
		addiu $a1, $a1, lo(itemROM + itemdatasize)
		addiu $a0, $a0, lo(itemROM)
		lui $a2, hi(APName)
		jal dmaFileTransfer
		addiu $a2, $a2, lo(APName)
    
		//
		lui $v0, 0x8001
		addiu $v0, $v0, 0xDCC4

		lui $t3, 0
		lui $t4, 1
		lui $t5, static_code_upper
		lui $t9, static_data_upper
		lui $t8, multi_code_upper
		j 0x80000784
		lui $t6, multi_data_upper
		//end of boot code
		/////////////////////////////////////////////////////

initHook:
	J 	initCode
	NOP

getObjectArrayAddr:
	// a0 = initial address
	// a1 = common object size
	// a2 = index
	MULTU 	a1, a2
	MFLO	a1
	JR 		ra
	ADD 	v0, a0, a1

getFloatUpper:
	; f12 = Float Value
	mfc1 	$v0, $f12
	sra 	$v0, $v0, 16
	JR 		ra
	andi 	$v0, $v0, 0xFFFF

callFunc:
	addi $sp, $sp, -8
	sw $ra, 0x4 ($sp)
	jalr $a0
	or $a0, $a1, $zero
	lw $ra, 0x4 ($sp)
	jr $ra
	addiu $sp, $sp, 8
	
.align 0x10
END: