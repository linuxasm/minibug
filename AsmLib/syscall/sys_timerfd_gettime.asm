;--------------------------------------------------------------
;>1 syscall
; sys_timerfd_gettime - kernel function                     
;
;    INPUTS 
;     see AsmRef function -> sys_timerfd_gettime                                 
;
;    Note: functon call consists of four instructions
;          
;          sys_timerfd_gettime:                              
;              mov  eax,326    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_timerfd_gettime
sys_timerfd_gettime:
	mov	eax,326
	int	byte 80h
	or	eax,eax
	ret