; Ege Özkan
; Source code for SCP: After the Masqurade project.

format MZ

stdin equ 0
stdout equ 1
stderr equ 2

cr equ 0dh ; Carriage return
lf equ 0ah ; Line feed
semicolon equ 0x3b ; The semicolon character.

main: ; our main function

        push	cs
	pop	ds

main_menu:
        
        lea     ax, [introduction]
        call     print
        lea     ax, [about]
        lea     bx, [alev_house]
        lea     cx, [exit]
        jmp     choose

about:
        
        lea      ax, [about_msg]
        call    print
        jmp     main_menu


exit:
        
        lea     ax, [exit_message]
        call    print
        mov     ah, 4CH
        int     21H

alev_house:

        lea     ax, [alevHouse]
        call    print
        lea     ax, [alev_car]
        jmp     choose

alev_car:
        
        lea     ax, [alevCar1]
        call    print
        lea     ax, [sasali_forrest_enterence]
        jmp     choose

sasali_forrest_enterence:
        
        lea     ax, [sasaliForestEnterence]
        call    print

sasali_forrest_enterence_choices:
        
        lea     ax, [sasaliForestEnterenceChoices]
        call print
        lea     ax, [explain_sarkicism]
        lea     bx, [explain_scp]
        lea     cx, [crime_scene_first]
        jmp     choose

explain_sarkicism:
        
        lea     ax, [explainSarkicism]
        call    print
        jmp     sasali_forrest_enterence_choices

explain_scp:
        
        lea     ax, [explainScp]
        call    print
        jmp     sasali_forrest_enterence_choices

crime_scene_first:
        
        lea     ax, [crimeSceneFirst]
        call    print
        lea     ax, [crime_scene_investigate]
        jmp     choose

crime_scene_investigate:
        
        lea     ax, [crimeSceneInvestigate]
        call    print
        lea     ax, [explain_identity_man]
        lea     bx, [explain_time]
        jmp     choose

explain_time:

        lea     ax, [explainIdentityMan]
        call    print
        lea     ax, [explain_body_feelings]
        lea     bx, [explain_identity_man]
        jmp     choose

explain_body_feelings:
        lea     ax, [explainBodyFeelings]
        call    print
        lea     ax, [explain_identity_man]
        jmp     choose

explain_identity_man:
        lea     ax, [explainIdentityMan]
        call    print


choose:
        push    ax ; Store ax temporarily since DOS call.
        push    bx
        push    cx
        push    dx




        lea     dx, [input] ; Print the input message
        mov     ah, 9 ; The print system call.
        int     21h 
        
        mov     ah, 01h ; Keybard IO
        int     21h ; Read character
        cmp     al, 50 ; Compare if [al] == 2

        mov     dl, lf
        mov     ah, 2
        int     21h ; Add a new line and carriage return.
        
        pop     dx ; Return the
        pop     cx ; Original values
        pop     bx ; of the
        pop     ax ; registers

        jl      short jump_to_one
        jg      short jump_to_three
        jmp     bx

jump_to_one:
        jmp     ax

jump_to_three:
        jmp     cx

print_char: ; Prints a single character.
; Argument al: Holds the character to be printed.

        push    dx;

        mov     dl, al  ; Get the character to print.
        mov     ah, 02h ; Character print call.
        int     21h;

        pop     dx;
        ret

sleep: ; Sleeps for some time.
; This is not a set amount of time, depends on CPU,
; terrible impementation, based on stackoverflow
; answer by Peter Cordes on a question about
; Sleep calls and spim.

        push    ax
        mov     ax, 25000

sleep_loop:
        cmp     ax, 0
        je      sleep_exit
        sub     ax, 1   ; Count down until zero.
        jmp     sleep_loop

sleep_exit:

        pop     ax
        ret

print: ; Prints data
; Argument ax: Holds the address to the printed message.
; Terminated with $.

        push    bx      ; Contains address for s
        mov     bx, ax  ; Since ax will be used often, get the address to ax.

print_loop: ; Loop through characters until we get $.

        mov     al, [bx] ; Load the next character.
        cmp     al, '$' ; Check if terminal character.
        je      print_ret ; Return if terminal character.
        call    print_char
        call    sleep
        
        mov     al, 0
        add     bx, 1   ; Increment address by a char.

        mov     ah, 01H         ; Check STDIN.
        int     16H             ; Interrupt to check if skip.
        jnz     print_loop_no_sleep ; Stop sleeping while print.
        jmp     print_loop
        


print_loop_no_sleep:    ; Loop through characters without sleeping

        mov     al, [bx]        ; Load the next character.
        cmp     al, '$'         ; Check if terminal character.
        je      print_ret       ; Return if terminal.
        call    print_char
        mov     al, 0
        add     bx, 1           ; Increment address.
        jmp     print_loop_no_sleep

print_ret:

        mov     al, 00h ; Eliminate the input function register.
        mov     ah, 0ch ; Flush the keyboard.
        int     21h     ; Flush the stdin... Hopefully.

        mov     dl, lf  ; Prints a new line.
        mov     ah, 2   ; To the end of the message.
        int     21H

        pop     bx

        ret


introduction    db      "Welcome to Izmir2046!", lf, "(1) About", lf, "(2) Start Game", lf, "(3) Quit", "$"
error_message   db      "No such option!", '$'
exit_message    db      "Thanks for playing Izmir2046!", "$"
input   db      "Your choice: ", "$"
about_msg       db      "The year is 2046, fifteen years have barelly passed since the Event. World is shattered, Izmir is no different. Though a long time has passed, the city is yet to recover. When an occultic murder occurs, with a note left by the killer implying more is yet to come, Detective Constable Alev Azulay is faced with the hardest case of his life...", "$"

; Lines below are generated from the twine.

alevHouse	db	"It was dark when I opened my eyes, so dark that, for a moment, I questioned why the hell was I even awake. It was then the phone rang again, hurting my ears, I sighed in disbelief.  ", '"', "The station can't wait for the morning again...", '"', ", I reached for the phone, still not fully awake ", '"', "Yes? What happened?", '"', "", lf, cr, "The response was hesistant, Almost as if the dispatcher was unsure about the news himself. ", '"', "A body was found in the forest near the City Forest, sir.", '"', " I got out of my bed, though the news of a murder was bad by its own merit, the tone of the dispatcher told me there was something more. I pressed further, ", '"', "And?", '"', " He stopped for a second, ", '"', "the Foundation is here, sir. They want to work with you specifically.", lf, cr, "(1) Get Ready", "$"
alevCar1	db	"I jump to my car, driving from the centre of the city, it takes a while to get to the Forest, outside the industrial zone, in the city's hinterlands. My mind is full of thoughts as I pass through the empty streets of the night, very little traffic, very few people, a beautiful night.. If not for, well...", lf, cr, "", '"', "Damn it...", '"', " I mutter, the SCP Foundation is at our doorstep... Ever since they appeared during the Event, we started hearing more and more cases of paranormal, nay, they call it anomalaous, but here... In Izmir, most anomalous thing we had to deal with has been a couple punk kids using anamalous art supplies to create teleporting graffiti... Whatever happened must have been serious enough to drag the Foundation to here....", lf, cr, "The trees start to apear in the sides of the road, I am close the City Forest now, as I slow down, I can see a woman in a trenchcoat is waiting for me in the side of the road.", lf, cr, "(1) Get to the Crime Scene", "$"
sasaliForestEnterence	db	"The woman greats me, ", '"', "Agent Selin Seren", '"', ", I look at the woman wearing sunglasses at night in disbelief", semicolon, " I raise an eyebrow, questioning the title of ", '"', "Agent", '"', ", wondering if she is simply drunk or someone pulling a prank", semicolon, " She smiles in return, ", '"', "From the Mobile Task Force Psi-13", '"', "", lf, cr, "I stop dead in my tracks, my suspicions disappearing, the air feel significantly cooler. A Mobile Task Force, the Foundation... what the hell is going on? ", '"', "MTF Psi-13?", '"', " Agent Seren smiles, ", '"', "Yes, the MTF responsible for containing anomalies related to Sarkicism.", '"', " ", '"', "Right.", '"', " I mumble, Sarkicism... What is Sarkicism?.", "$"
sasaliForestEnterenceChoices    db      lf, cr, "(1) What is Sarkicism ", lf, cr, "(2) What does the foundation want? ", lf, cr, "(3) Let's Go to the crime scene ", "$"
explainSarkicism	db	"", '"', "Sarkicism, well, I guess it is normal not many know of them.", '"', " Agent Seren nod, ", '"', "They are a group of people who follow  the Grand Karcist Ion... they believe they can manipulate flesh for divine purposes, to achieve Godhood.", '"', " I crank a smile, ", '"', "So they are insane then?", '"', "", lf, cr, "She does not return my smile.", lf, cr, "", "$"
explainScp	db	"", '"', "The Foundation simply wishes to make sure that the anamolous entities do not pose a threat to mankind, we contain and research anomalies.", '"', " ", '"', "Yes, I know, but why here?", '"', " She motions towards the forest, ", '"', "You will understand.", '"', "", lf, cr, "", "$"
crimeSceneFirst	db	"As we get closer to the location of the body, the smell grows sorid... After a while, within the thick three line, I see... something. My eyes see it, but my mind takes significantly longer to perceive the horrid sight in front of me, ", '"', "Is that?..", '"', ", Agent Seren confirms, ", '"', "It used to a human. ", '"', "What was in front of me was a blob of flesh, it was starting to decay just now, fluids coming out from many pores on its surface, it was spread between two trees, the size of a table, there were people in hazmat suites around it, taking sample and investigating. ", '"', "How did it died?", '"', " The agent scoffs at my question, ", '"', "'He' isn't dead yet.", '"', " I recoil a little in horror. There is sorrow in the agent's eyes...", lf, cr, "(1) We should investigate the surroundings ", "$"
crimeSceneInvestigate	db	"It is hard to look around, my mind is hazy, looking around, I can feel it missing things. I feel the perception filter of my brain falter, flail around.", lf, cr, "Around the blob of flesh are sigils, written in an alphabet I have never seen before, Agent Seren looks at them, ", '"', "Adytite... Or at least it looks like Adytite, strange, some runes are malformed.", '"', ", she observes, ", '"', "Sarkic cults use this language since their foundation", '"', ", I nod. ", '"', "Is there anything useful with the body?", '"', " I ask, Agent Seren motions to the hazmat suite guys, one of them come closer.", lf, cr, "", '"', "Doctor Croner, is there anything we should know about the body?", '"', " ", '"', "The body exhibits standard characteristics of a SK-BIO Type 7 anomolous life-form.", '"', " Looking at me, Doctor Croner further clarified ", '"', "It must have came into existence following a ritual of sorts.", '"', " I nod, Seren inquires further, ", '"', "Any cogitohazards? infohazards? Anything that will break our minds if we look at them", '"', " Croner nods, ", '"', "Only minor memetic hazard effects, you may have a hard time looking at the sigils directly, but other than that, no.", '"', " Croner looked at me, ", '"', "Anything to ask chief?", '"', "", lf, cr, "", lf, cr, "(1) Any idea on the identity of the man? ", lf, cr, "(2) How long ago do you think this occured? ", "$"
explainIdentityMan	db	"Croner spoke, ", '"', "Not a clue.", '"', " He raised his hand before I was able to speak ", '"', "and before you ask, no, no witnesses either. An old woman found the body six hours ago, by the time we arrive, we had to give the poor woman Class C Amnestics.", '"', "", lf, cr, "I sighed, taking a hand to my forehead, ", '"', "Where will we start?", '"', " I asked to myself, Seren interjeceted my train of thoughts, ", '"', "Well, has there been anything, unusual? Weird? In the city, I mean.", '"', " ", '"', "I see your point,", '"', " I continued, ", '"', "A cult like this wouldn't just apear out of thin air... You are right, let's take a look at the records in the precinct?", '"', " I motioned towards the road, where my car was, ", '"', "Do you have a car?", '"', " I asked, Seren shook her head, ", '"', "Hasn't been able to settle down yet, no.", '"', " We moved towards my car and sit.", "$"
explainTime	db	"Croner looks at his notes, ", '"', "It is very hard to tell, but the mass of the body implies that it has been like this for at least twenty hours.", '"', " I turned to Seren, ", '"', "He must have started his transformation towards the morning.", '"', " She observed, I looked at the body again, ", '"', "How long does the ritual take?", '"', " Seren shook her head ", '"', "We cannot know for certain, not unless we know the exact steps taken.", '"', " I nod, unable get my eyes off the body.", lf, cr, "", lf, cr, "(1) Does he still feel? ", lf, cr, "(2) Do we know who he is? ", "$"
explainBodyFeelings	db	"Croner sighed, ", '"', "There is a brain in there, and its neurons are firing. That's all I know.", '"', "", lf, cr, "", lf, cr, "(1) ", '"', "Do we know anything about his identity", '"', " ", "$"
