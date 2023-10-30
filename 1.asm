.686    				
.model flat, stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\masm32.lib


.data
; prompts para escrita no console

    successMessage db "Arquivo aberto com sucesso",0
    promptMessage db "Digite o nome do arquivo BMP: ", 0
    promptMessagePontoX db "Digite a coordenada X: ", 0
    promptMessagePontoY db "Digite a coordenada Y: ", 0
    promptMessageLargura db "Digite a largura da censura: ", 0 
    promptMessageAltura db "Digite a altura da censura: ", 0 
    destinationFileName db "censura.bmp", 0


; variaveis para uso interno no programa 
    
    fileName db 32 dup(0)
    auxString db 15 dup(0) ; auxiliar para conversão de string para inteiro
    auxString2 db 15 dup(0) ; auxiliar para conversão de string para inteiro
    pontoX    dd 0
    pontoY    dd 0
    larguraMax dd 0
    atualX      dd 0
    atualY      dd 0
    largura   dd 0
    altura    dd 0
    readCount dd 0
    writeCount dd 0
    buffer db 6480 dup(0) ; Declara um buffer de 4096 bytes, preenchido com zeros
    

; variaveis de controle (libs externas)

    inputHandle   dd 0
    outputHandle  dd 0
    fileHandle    dd 0
    fileDHandle   dd 0
    console_count dd 0

.code
    terminateStringAtCR:
            push ebp
            mov ebp, esp

            search_CR:
                mov al, [esi]           ; Carregue o caractere atual em AL
                inc esi                 ; Aponte para o próximo caractere
                cmp al, 13              ; Compare com o caractere CR (ASCII 13)
                je found_CR             ; Se for igual, encontrou o CR
                jnz search_CR           ; Se não for o final, continue a busca

            found_CR:   
                dec esi                 ; Aponte para o caractere anterior onde o CR foi encontrado
                xor al, al              ; ASCII 0, terminado de string
                mov [esi], al           ; Inserir ASCII 0 no lugar do ASCII CR
                mov esp, ebp
                pop ebp
                ret 

        CopyFileContent:
            push ebp
            mov ebp, esp

            ; Ler os primeiros 18 bytes do arquivo de entrada e escrevê-los no arquivo de saída
            invoke ReadFile, fileHandle, addr buffer, 18, addr readCount, NULL
            invoke WriteFile, fileDHandle, addr buffer, 18, addr writeCount, NULL

            ; Ler os próximos 4 bytes referentes à largura da imagem e salvar na pilha
            invoke ReadFile, fileHandle, addr buffer, 4, addr readCount, NULL
            invoke WriteFile, fileDHandle, addr buffer, 4, addr writeCount, NULL
            mov ebx, DWORD PTR [buffer] ; Mova o valor do buffer para o registrador ebx
            mov [ebp-12], eax
            mov larguraMax, ebx
            ; Mova o valor de EBX para EAX
            mov eax, ebx
            ; Converta EAX em uma string
            invoke dwtoa, eax, addr auxString; 10 

            ; Ler os 32 bytes restantes do cabeçalho do arquivo de entrada e escrevê-los no arquivo de saída
            invoke ReadFile, fileHandle, addr buffer, 32, addr readCount, NULL
            invoke WriteFile, fileDHandle, addr buffer, 32, addr writeCount, NULL


            loop_start:
                invoke ReadFile, fileHandle, addr buffer, 3, addr readCount, NULL
                cmp readCount, 0
                je exit_label

                mov eax, pontoY
                mov ebx, atualY
                cmp ebx, eax
                jge censura
                jmp escrita

                censura: 
                   mov eax, pontoY
                   mov ebx, altura
                   add eax, ebx
                   sub eax, 1
                   mov ebx, atualY
                   cmp ebx, eax
                   jg escrita
                   mov eax, pontoX
                   mov ebx, atualX
                   cmp ebx, eax
                   jge censuraX
                   jmp escrita

                   censuraX:
                   mov eax, pontoX
                   mov ebx, largura
                   add eax, ebx
                   sub eax, 1
                   mov ebx, atualX
                   cmp ebx, eax
                   jg escrita

                    
                    ; Dentro da região de censura, defina os pixels como preto
                    mov byte ptr [buffer], 0  ; Defina o componente de cor azul como 0 (preto)
                    mov byte ptr [buffer+1], 0  ; Defina o componente de cor verde como 0 (preto)
                    mov byte ptr [buffer+2], 0  ; Defina o componente de cor vermelho como 0 (preto)
                    jmp escrita
                    
                
                        

                escrita:

                invoke atodw, addr auxString
                mov ebx, atualX
                sub eax, 1
                cmp ebx, eax
                je incY
                jmp incX

                incY:
                   inc atualY
                   mov atualX, 0
                   jmp escritaArquivo
                incX:
                   inc atualX
                   jmp escritaArquivo

                escritaArquivo:    
                    invoke WriteFile, fileDHandle, addr buffer, 3, addr writeCount, NULL
                    jmp loop_start

            exit_label:
                mov esp, ebp
                pop ebp
                ret

    start: 
        invoke GetStdHandle, STD_INPUT_HANDLE
        mov inputHandle, eax
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov outputHandle, eax

        invoke WriteConsole, outputHandle, addr promptMessage, sizeof promptMessage, addr console_count, NULL
        invoke ReadConsole, inputHandle, addr fileName, sizeof fileName, addr console_count, NULL

        mov esi, offset fileName  ; Configura ESI para o início da string
        call terminateStringAtCR ; função para terminar a string em auxString no caractere CR

        mov edi, offset fileHandle
        mov edi, eax  ; Copia o valor de ebx para inputNameArquivo
        
        invoke WriteConsole, outputHandle, addr promptMessagePontoX, sizeof promptMessagePontoX, addr console_count, NULL
        invoke ReadConsole, inputHandle, addr auxString, sizeof auxString, addr console_count, NULL

        mov esi, offset auxString  ; Configura ESI para o início da string
        call terminateStringAtCR ; função para terminar a string em auxString no caractere CR
    
        invoke atodw, addr auxString ; Chame a função de conversão

        mov pontoX, eax 

        invoke WriteConsole, outputHandle, addr promptMessagePontoY, sizeof promptMessagePontoY, addr console_count, NULL
        invoke ReadConsole, inputHandle, addr auxString, sizeof auxString, addr console_count, NULL        
        
        mov esi, offset auxString  ; Configura ESI para o início da string
        call terminateStringAtCR ; função para terminar a string em auxString no caractere CR
    
        invoke atodw, addr auxString ; Chame a função de conversão

        mov pontoY, eax

        invoke WriteConsole, outputHandle, addr promptMessageLargura, sizeof promptMessageLargura, addr console_count, NULL
        invoke ReadConsole, inputHandle, addr auxString, sizeof auxString, addr console_count, NULL        
        
        mov esi, offset auxString  ; Configura ESI para o início da string
        call terminateStringAtCR ; função para terminar a string em auxString no caractere CR
    
        invoke atodw, addr auxString ; Chame a função de conversão

        mov largura, eax 

        invoke WriteConsole, outputHandle, addr promptMessageAltura, sizeof promptMessageAltura, addr console_count, NULL
        invoke ReadConsole, inputHandle, addr auxString, sizeof auxString, addr console_count, NULL        
        
        mov esi, offset auxString  ; Configura ESI para o início da string
        call terminateStringAtCR ; função para terminar a string em auxString no caractere CR
    
        invoke atodw, addr auxString ; Chame a função de conversão

        mov altura, eax 

        invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL, NULL
        mov fileHandle, eax

        ; Abre o arquivo de destino para escrita
        invoke CreateFile, addr destinationFileName, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0
        mov fileDHandle, eax


        ; Chame a função CopyFileContent
        call CopyFileContent

        ; Fechar o arquivo de leitura
        invoke CloseHandle, fileHandle

        ; Fechar o arquivo de escrita
        invoke CloseHandle, fileDHandle
        
        jmp exit
        
        exit:
            invoke ExitProcess, 0

        invoke ExitProcess, 0
        
    end start


   




