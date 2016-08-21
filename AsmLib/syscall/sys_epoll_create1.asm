;--------------------------------------------------------------
;>1 syscall
; sys_epoll_create1 - kernel function                       
;
;    INPUTS 
;     see AsmRef function -> sys_epoll_create1                                   
;
;    Note: functon call consists of four instructions
;          
;          sys_epoll_create1:                                
;              mov  eax,329    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_epoll_create1
sys_epoll_create1:
	mov	eax,329
	int	byte 80h
	or	eax,eax
	ret