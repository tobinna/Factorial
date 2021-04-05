
	; Lab 3 Tentative Solution
	area	tcd,code,readonly
	export	__main
__main

	ldr	r5,=nums					; Array is stored in r5
	ldr	r4, =memory					; Space we have allocated is in r4
	mov r0, #0						; Just making sure no stuff in the registers
	mov r1, #0
	mov r2, #0
	mov r7, #0
	
	bl yuppa						; Branch to the array iterating function
	
done b done							; Finito!!!



yuppa
	ldr	r6,[r5],#4					; Get next number in the Array
	cmp r6, #0						; Compare the array number with 0
	beq done						; If its 0, youve finished the array
	mov r0, r6						; place the array number into r0
	b	fact						; Head to the factorial function
	
	
fact
	CMP R0, #0 						; if argument n is 0, return 1
	MOVEQ R0, #1
	beq muli						; Head to the multiply function
	MOV R3, R0 						; Otherwise, save argument n into R3
	SUB R0, R0, #1 					; and perform recursive call on R3 - 1
	ADD SP, SP, #-8 				; 1] decrement the stack pointer by 8 byte, and thus      
									; allocating space to save 2 words 
	STR LR, [SP,#4] 				; push/save the current link Register into the 1st space 
	STR R3,[SP]     				; push/save the current value of R3 into the 2nd space 
	BL fact							; Loop through the function again to get next layer
	
muli 
	LDR R3, [SP]   					; restore the  value of R3 that I saved on the stack in                        
    cmp r3, #0						; the most recent iteration. 
	beq store						; When there is nothing left to multiply, go to store the digits
	umull r0, r7, r3, r0			; Long multiply the two numbers together
	umull r1, r2, r3, r1
	cmp r2, #0						; if there is anything in the third digit, we have gone too high
	bhi above_max					; go to above max to reset the value
	add  r1, r7, r1					; Add the registers in the big bit from 1st operation and small bit from 2nd
	
	LDR LR, [SP,#4] 				; restore the value of Link Register that I saved on the  
									; stack in the most recent iteration.  
	ADD SP,SP,#8    				; 1] After restoring the desired values, deallocate their  
									; memory space on the stack by incrementing the stack   
									; pointer by the same 8 bytes. 
	b muli  						; and return
 



store
	str r0, [r4],#4					; Stores the values of r1 and r0 in memory
	str r1, [r4],#4
	mov r0, #0						; Just resetting the value of r1 and r0 before they go back into the 
	mov r1, #0						; function
		
	b	yuppa

above_max
	mov r0, r0
	ldr r0, =0						; Resetting numbers to 0 if the value goes above 64 bits
	ldr r1, =0
	ldr r2, =0
	ldr r3, =0
	mov SP,#0x4000000 
	b done
	

	area	tcdsdd,data,readonly	
nums dcd 5							;My array of the four numbers
	 dcd 14
	 dcd 20
	 dcd 30

	area	tcdsd,data,readwrite		
memory	space	32					;enough space to store the 4 64 bit numbers
	
	
	end


