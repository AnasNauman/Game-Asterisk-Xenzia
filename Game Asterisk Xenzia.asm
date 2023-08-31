[org 0x0100]
mov [cs:DataSegment],ds
jmp start

     Seconds: db 0
     Minutes: db 0
   TickCount: db 0
 oldTimerISR: dd 0
    OldKbISR: dd 0
 DataSegment: dw 0
  isFinished: db 0
     Message: db 'THIS IS YOUR SCORE: ',0
    startmsg: db 'Press Any Key To Start!',0
     StarPos: dw 2000
    GameOver: db 'GAME OVER. PRESS ANY ARROW KEY TO EXIT',0
        Time: db'Time: ',0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clrscrn:
       push es
       push ax
       push cx
       push di

       mov ax,0xb800
       mov es,ax
       xor di,di
       mov ax,0x0720
       mov cx,2000

       cld  
       rep stosw
   
       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntstr:
       push bp
       mov  bp,sp
       push es
       push ax
       push cx
       push si
       push di
  
       mov es,[cs:DataSegment]

       mov   di,[bp+4]
       mov   cx,0xffff
       xor   al,al
       repne scasb
       mov   ax,0xffff
       sub   ax,cx 
       dec   ax
       
       mov cx,ax
       mov ax,0xb800   
       mov es,ax
       mov al,80
       mul byte[bp+8]
       add ax,[bp+10]
       shl ax,1
       mov di,ax
       mov si,[bp+4]
       mov ah,[bp+6]

       cld

nxtchar:
       lodsb
       stosw
       loop nxtchar
   
      pop di
      pop si
      pop cx
      pop ax
      pop es
      pop bp

      ret 8 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntdgt:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di

       mov ax,0xb800
       mov es,ax

       mov ax,[bp+4]
       mov bx,10
       mov cx,0

nxtdgt:
       mov  dx,0
       div  bx
       add  dl,0x30
       push dx     
       inc  cx
       cmp  ax,0
       jnz  nxtdgt
         
        cmp  cx,1
        jne  below1
        mov  dx,0x0030
        push dx
        inc  cx

below1: cmp cx,2
        jne  below2
        mov  dx,0x0030
        push dx
        inc  cx


below2:
         mov di,[bp+6]

nxtpos:
       pop dx
       mov dh,byte[bp+8]
       mov [es:di],dx
       add di,2
       loop nxtpos

       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop bp
       
       ret 6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

kbisr:
     push ax
     push es
     push si
     push di
     push bx

     mov ax,0xb800
     mov es,ax

     xor si,si
     xor di,di
     mov bx,0x0E2A

    in al,0x60

   cmp al,0x48                 ;UP SCANCODE
   jne nextcmp1
      mov di,[StarPos]
      sub di,160
      cmp di,158
      jbe near exitfalse
      call clrscrn
       mov cx,140              ; LOAD POSITION ON STACK
       push cx
      call printClock
      mov [es:di],bx
      mov [StarPos],di
    jmp nokeymatch

nextcmp1:
     cmp al,0x50               ; DOWN SCANCODE
     jne  nextcmp2 
        mov di,[StarPos]
        add di,160
        cmp di,3840
        jae exitfalse
        call clrscrn
        mov cx,140             ; LOAD POSITION ON STACK
        push cx
        call printClock
        mov [es:di],bx
        mov [StarPos],di
     jmp nokeymatch

 nextcmp2:
      cmp al,0x4B               ; LEFT SCANCODE
      jne  nextcmp3
         mov di,[StarPos]
        sub di,2
        push di
        call cmpleftside
        cmp  si,1
        je exitfalse
        call clrscrn
        mov cx,140            ; LOAD POSITION ON STACK
        push cx
        call printClock
        mov [es:di],bx
        mov [StarPos],di
     jmp nokeymatch

nextcmp3:
      cmp al,0x4D              ; RIGHT SCANCODE
     jne nokeymatch
        mov di,[StarPos]
        add di,2
        push di
        call cmprightside
        cmp  si,1
        je exitfalse
        call clrscrn
        mov cx,140             ; LOAD POSITION ON STACK
        push cx
        call printClock
        mov [es:di],bx
        mov [StarPos],di
     jmp nokeymatch

nokeymatch:

     pop bx
     pop di
     pop si
     pop es
     pop ax

     jmp far [cs:OldKbISR]

keymatched:
    mov al,0x20
    out 0x20,al

     pop bx
     pop di
     pop si
     pop es
     pop ax

    iret

exitfalse:
    mov al,0x20
    out 0x20,al

    mov  dx,8
    mov  bx,20                ; load x position
    push bx                   ; push x position
    push dx                   ; push y position
    mov  bx,0x000C            ; pink on blackattribute
    push bx                   ; push attribute
    mov  bx,GameOver          ; load string address
    push bx                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov byte[cs:isFinished],1

     pop bx
     pop di
     pop si
     pop es
     pop ax

    iret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmprightside:
  push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di

       xor si,si
       mov ax,[bp+4]
 
cmp ax,4000
jne cmpR1
 jmp exitfalseright

cmpR1:
  cmp ax,3678
  jne cmpR2
  jmp exitfalseright

 
cmpR2:
  cmp ax,3518
  jne cmpR3
  jmp exitfalseright
 
cmpR3:
  cmp ax,3358
  jne cmpR4
  jmp exitfalseright

cmpR4:
  cmp ax,3198
  jne cmpR5
  jmp exitfalseright

cmpR5:
  cmp ax,3038
  jne cmpR6
  jmp exitfalseright

cmpR6:
  cmp ax,2878
  jne cmpR7
  jmp exitfalseright

cmpR7:
  cmp ax,2718
  jne cmpR8
  jmp exitfalseright

cmpR8:
  cmp ax,2558
  jne cmpR9
  jmp exitfalseright

cmpR9:
  cmp ax,2398
  jne cmpR10
  jmp exitfalseright

cmpR10:
  cmp ax,2238
  jne cmpR11
  jmp exitfalseright

cmpR11:
  cmp ax,2078
  jne cmpR12
  jmp exitfalseright

cmpR12:
  cmp ax,1918
  jne near cmpL13
  jmp exitfalseright

cmpR13:
  cmp ax,1758
  jne cmpR14
  jmp exitfalseright


cmpR14:
  cmp ax,1598
  jne cmpR15
  jmp exitfalseright

cmpR15:
  cmp ax,1438
  jne cmpR16
  jmp exitfalseright

cmpR16:
  cmp ax,1278
  jne cmpR17
  jmp exitfalseright

cmpR17:
  cmp ax,1118
  jne cmpR18
  jmp exitfalseright

cmpR18:
  cmp ax,958
  jne cmpR19
  jmp exitfalseright

cmpR19:
  cmp ax,798
  jne cmpR20
  jmp exitfalseright

cmpR20:
  cmp ax,638
  jne cmpR21
  jmp exitfalseright

cmpR21:
  cmp ax,478
  jne cmpR22
  jmp exitfalseright

cmpR22:
  cmp ax,318
  jne cmpR23
  jmp exitfalseright

cmpR23:
  cmp ax,158
  jne cmpR24
  jmp exitfalseright

cmpR24:
  cmp ax,0
  jne exittrueright

exitfalseright:
 mov si,1

exittrueright:
	        pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp

		ret 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmpleftside:
        push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di

       xor si,si
       mov ax,[bp+4]
 
cmp ax,3840
jne cmpL1
 jmp exitfalseleft

cmpL1:
  cmp ax,3680
  jne cmpL2
  jmp exitfalseleft

 
cmpL2:
  cmp ax,3520
  jne cmpL3
  jmp exitfalseleft
 
cmpL3:
  cmp ax,3360
  jne cmpL4
  jmp exitfalseleft

cmpL4:
  cmp ax,3200
  jne cmpL5
  jmp exitfalseleft

cmpL5:
  cmp ax,3040
  jne cmpL6
  jmp exitfalseleft

cmpL6:
  cmp ax,2880
  jne cmpL7
  jmp exitfalseleft

cmpL7:
  cmp ax,2720
  jne cmpL8
  jmp exitfalseleft

cmpL8:
  cmp ax,2560
  jne cmpL9
  jmp exitfalseleft

cmpL9:
  cmp ax,2400
  jne cmpL10
  jmp exitfalseleft

cmpL10:
  cmp ax,2240
  jne cmpL11
  jmp exitfalseleft

cmpL11:
  cmp ax,2080
  jne cmpL12
  jmp exitfalseleft

cmpL12:
  cmp ax,1920
  jne cmpL13
  jmp exitfalseleft

cmpL13:
  cmp ax,1760
  jne cmpL14
  jmp exitfalseleft


cmpL14:
  cmp ax,1600
  jne cmpL15
  jmp exitfalseleft

cmpL15:
  cmp ax,1440
  jne cmpL16
  jmp exitfalseleft

cmpL16:
  cmp ax,1280
  jne cmpL17
  jmp exitfalseleft

cmpL17:
  cmp ax,1120
  jne cmpL18
  jmp exitfalseleft

cmpL18:
  cmp ax,960
  jne cmpL19
  jmp exitfalseleft

cmpL19:
  cmp ax,800
  jne cmpL20
  jmp exitfalseleft

cmpL20:
  cmp ax,640
  jne cmpL21
  jmp exitfalseleft

cmpL21:
  cmp ax,480
  jne cmpL22
  jmp exitfalseleft

cmpL22:
  cmp ax,320
  jne cmpL23
  jmp exitfalseleft

cmpL23:
  cmp ax,160
  jne cmpL24
  jmp exitfalseleft

cmpL24:
  cmp ax,0
  jne exittrueleft

exitfalseleft:
 mov si,1

exittrueleft:
	        pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp

		ret 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
timer:
     push ax

     inc byte [cs:TickCount]
     
     cmp byte[cs:TickCount],18
     jne exitTimer
     inc byte[cs:Seconds]
     mov byte [cs:TickCount],0

     mov ax,140                    ; LOAD POSITION ON STACK
     push ax
     call printClock

exitTimer:
     mov al, 0x20
     out 0x20, al

     pop ax
     iret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printClock:
        push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di

	mov ax, 0xb800
	mov es, ax
 
    call printboundry   
 
      mov di,[bp+4]
      sub di,2

      mov ax,0x073A     ; ASCII for :(colon) character
      mov [es:di],ax

      cmp byte[cs:Seconds],60
      jb prntSecondsNormal
      
      sub byte[cs:Seconds],60
      inc byte[cs:Minutes]

prntSecondsNormal:
       xor ax,ax
       mov al, byte[cs:Seconds]
       mov bx, 10
       mov cx, 0

nextdigitSec:	
          mov dx, 0
	  div bx
	  add dl, 0x30
	  push dx
	  inc cx
	  cmp ax, 0
	  jnz nextdigitSec

          cmp cx,1
          jne prntSec    
          mov dx,0x0030
          push dx
          inc cx

prntSec:
	mov di,[bp+4]

nextposSec:	
        pop dx
	mov dh, 0x07
	mov [es:di], dx
	add di, 2
	loop nextposSec

        xor ax,ax
	mov al,byte[cs:Minutes]
	mov bx, 10
	mov cx, 0

nextdigitMin:	
           mov dx, 0
	   div bx
	   add dl, 0x30
	   push dx
	   inc cx
	   cmp ax, 0
	   jnz nextdigitMin

          cmp cx,1
          jne prntMin    
          mov dx,0x0030
          push dx
          inc cx

prntMin:
	mov di,[bp+4]
        sub di,6

nextposMin:	
        pop dx
	mov dh, 0x07
	mov [es:di], dx
	add di, 2
	loop nextposMin





    mov  dx,0
    mov  bx,60                ; load x position
    push bx                   ; push x position
    push dx                   ; push y position
    mov  bx,0x0004            ; pink on blackattribute
    push bx                   ; push attribute
    mov  bx,Time              ; load string address
    push bx                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING



		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp

		ret 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clearBoundry:
 push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di

	mov ax, 0xb800
	mov es, ax
       
       mov ax,0x0720
       mov cx,80
       xor di,di
       rep stosw
       
       mov ax,0x0720
       mov cx,80
       mov di,3840
       rep stosw

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp

		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printboundry:
        push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di

	mov ax, 0xb800
	mov es, ax
       
       mov ax,0x73AE
       mov cx,80
       xor di,di
       rep stosw
       
       mov ax,0x73AF
       mov cx,80
       mov di,3840
       rep stosw

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp

		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       MAIN FUNCTION         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:

      call clrscrn

    mov  dx,20
    mov  bx,26                ; load x position
    push bx                   ; push x position
    push dx                   ; push y position
    mov  bx,0x00F0            ; pink on blackattribute
    push bx                   ; push attribute
    mov  bx,startmsg          ; load string address
    push bx                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

      mov ah,0
      int 0x16

     call clrscrn
 
     mov ax,0xb800
     mov es,ax
     mov ax,0x0E2A
     mov [es:2000],ax

      xor ax, ax
      mov es, ax

      mov ax,[es:9*4]          ; get  offset  of oldKbISR
      mov [cs:OldKbISR],ax     ; save offset  of oldKbISR
      mov ax,[es:9*4+2]        ; get  segment of oldKbISR
      mov [cs:OldKbISR+2],ax   ; save segment of oldKbISR

      mov ax,[es:8*4]
      mov [cs:oldTimerISR],ax
      mov ax,[es:8*4+2]
      mov [cs:oldTimerISR+2],ax

      cli
      mov word[es:9*4],kbisr   ; store offset at n*4
      mov [es:9*4+2],cs        ; store segment at n*4+2
      mov word [es:8*4],timer  ; store offset at n*4
      mov [es:8*4+2],cs        ; store segment at n*4+2
      sti                      ; enable interrupts


loopesc:
      cmp byte[cs:isFinished],1
      je exit
      mov ah,0
      int 0x16
      cmp byte[cs:isFinished],1
      je exit
      cmp al,27
      jne loopesc
exit:

   call clrscrn

    mov  dx,10
    mov  bx,20                ; load x position
    push bx                   ; push x position
    push dx                   ; push y position
    mov  bx,0x000E            ; pink on blackattribute
    push bx                   ; push attribute
    mov  bx,Message           ; load string address
    push bx                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov ax,1686                   ; LOAD POSITION ON STACK
    push ax
    call printClock
    
    call clearBoundry

      mov ax,[cs:OldKbISR]     ; read old offset in ax
      mov bx,[cs:OldKbISR+2]   ; read old segment in bx

    xor dx, dx
    mov es, dx

      cli                      ; disable interrupts
      mov [es:9*4],ax          ; store offset at n*4
      mov [es:9*4+2],bx        ; store segment at n*4+2
      sti                      ; enable interrupts

      mov ax,[cs:oldTimerISR]
      mov bx,[cs:oldTimerISR+2]

    xor dx, dx
    mov es, dx

      cli
      mov [es:8*4],ax
      mov [es:8*4+2],bx
      sti



mov ax, 0x4c00
int 0x21
