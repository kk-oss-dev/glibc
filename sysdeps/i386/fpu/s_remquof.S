/*
 * Public domain.
 */

#include <machine/asm.h>
#include <libm-alias-float.h>

#define PARMS	4		/* no space for saved regs */
#define DVDND	PARMS
#define DVSOR	DVDND+4
#define QUOP	DVSOR+4

	.text
ENTRY (__remquof)

	flds	DVSOR(%esp)
	flds	DVDND(%esp)
1:	fprem1
	fstsw	%ax
	sahf
	jp	1b
	fstp	%st(1)
	/* Compute the congruent of the quotient.  */
	movl	%eax, %ecx
	shrl	$8, %eax
	shrl	$12, %ecx
	andl	$4, %ecx
	andl	$3, %eax
	orl	%eax, %ecx
	leal	(%ecx,%ecx,2),%ecx
	movl	$0xef2a60, %eax
	shrl	%cl, %eax
	andl	$7, %eax
	movl	QUOP(%esp), %ecx
	movl	DVDND(%esp), %edx
	xorl	DVSOR(%esp), %edx
	testl	$0x80000000, %edx
	jz	1f
	negl	%eax
1:	movl	%eax, (%ecx)

	ret
END (__remquof)
libm_alias_float (__remquo, remquo)
