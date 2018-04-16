*-----------------------------------------------------------
* Title      : Zork
* Written by : Josh Tyrrell Browne
* Date       : March 2018
* Description: Comp Arch Project
*-----------------------------------------------------------
     org $1000

*-------------------------------------------------------
*Choose to be Evil Wizard or New Romancers
*-------------------------------------------------------

*-------------------------------------------------------
*Validation values to be used, modify as needed
*Add additional validation values as required
*-------------------------------------------------------
exit        EQU 0      used to exit assembly program
min_feed    EQU 100    min feed requirement
min_horses  EQU 1      min number of horses
max_horses  EQU 9      max number of horses
min_soldier EQU 6      min soldiers
min_charge  EQU 1      min rate of fuel use based of speed (oats for horses)
max_charge  EQU 5      max rate e.g. Flank       
hit_point   EQU 5      points accumilated on castle (objective) strike
miss_point  EQU 8      points deducted for ordinace miss

mine_loc    EQU 100    example for a hit


*Start of Game
start:
    move.b  #100,$4000 put score/health in memory location $4000
    lea     $4000,A3   assign address A3 to that memory location


    bsr     welcome    branch to the welcome subroutine
    bsr     input      branch to the input subroutine
    bsr     game       branch to the game subroutine
*Game loop
    org     $3000      the rest of the program is to be located from 3000 onwards

*-------------------------------------------------------
*-------------------Game Subroutine---------------------
*-------------------------------------------------------
game:
    bsr     gameloop   branch to gameloop subroutine
    rts                return from game: subroutine
          
end:
    simhalt

*-------------------------------------------------------
*-------------------Welcome Subroutine------------------
*-------------------------------------------------------
welcome:
    bsr     endl            branch to endl subroutine
    lea     welcome_msg,A1  assign message to address register A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15             trap and interpret value in D0
   * bsr     endl            branch to endl subroutine
    rts                     return from welcome: subroutine

*-------------------------------------------------------
*---------Gameplay Input Values Subroutine--------------
*-------------------------------------------------------    
input:
    MOVE.B #4, D0           take input (1 or 2)
    TRAP #15
    
  
   * move.b  D1,D3           move answer into d3
    MOVE.L  #1,D2           MOVE NUMBER 1 INTO D2 (TO COMPARE)
    CMP D1,D2
    BLT exit
    BEQ gameBegins          GREATER THAN 
       

    bsr     feed            branch to feed input subroutine
    bsr     horses          branch to ship input subroutine
    bsr     rate            branch to rate (charging speed) input subroutine
    bsr     distance        branch to mission distance/location input subroutine
    bsr     soldiers        branch to soldiers input subroutine
    rts

*-------------------------------------------------------
*---------Game Start------------------------------------
*-------------------------------------------------------
gameBegins:
    LEA start_msg, A1       displays start msg
    MOVE.B  #14,D0
    TRAP #15
    
    bsr     endl
    
    LEA towninfo_msg, A1    displays the message about town
    MOVE.B  #14,D0
    TRAP #15

    bsr     endl

    LEA direction_choice, A1    etc..
    MOVE.B  #14,D0
    TRAP #15

    MOVE.B #4, D0           take input (1 or 2)
    TRAP #15

    MOVE.L  #1,D2           MOVE NUMBER 1 INTO D2 (TO COMPARE)
    CMP D1,D2
    BEQ valley

*-------------------------------------------------------
valley:
    bsr     clear_screen    clears the screen         
    
    LEA beginjourney, A1    displays the message
    MOVE.B  #14,D0
    TRAP #15

    MOVE.B #4, D0           take input (1 or 2)
    TRAP #15

    MOVE.B D1,D7            stores answer in D7 (lamp OR DAGGER)
    
    bsr     endl
    
    LEA leavehomeval, A1    displays the message
    MOVE.B  #14,D0
    TRAP #15
    
    MOVE.B #4, D0           take input (1 or 2)
    TRAP #15

    CMP #2,D1
    BEQ nighttravel
    BLT camp


    bsr replay

*--------------------------------------------------------
camp:
    bsr     clear_screen    clears the screen         
    
    LEA camp_msg, A1    displays the message
    MOVE.B  #14,D0
    TRAP #15

    rts
*-------------------------------------------------------
nighttravel:
    bsr     clear_screen    clears the screen         
    
    LEA nighttravelmsglamp, A1    displays the message
    MOVE.B  #14,D0
    TRAP #15
    
    bsr replay

    
*-------------------------------------------------------
*----------------Gameloop (main loop)-------------------
*------------------------------------------------------- 
gameloop:
    bsr     update          branch to update game subroutine 
    bsr     clear_screen    clears the screen         
    bsr     draw            branch to draw screen subroutine
    bsr     clear_screen    clears the screen
    bsr     gameplay        branch to gameplay subroutine
    bsr     clear_screen    clears the screen
    bsr     hud             branch to display HUD subroutine
    bsr     clear_screen    clears the screen
    bsr     replay          branch to replay game subroutine
    bsr     clear_screen    clears the screen
    rts                     return from gameloop: subroutine

*-------------------------------------------------------
*---------------Update Mission Progress-----------------
*  Move to battle location, engage enemy, fire and take
*  fire, complete mission and return to base
*------------------------------------------------------- 
update:
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    lea     update_msg,A1   
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts
*-------------------------------------------------------
*---------------Draw Mission Updates--------------------
* Draw the game progress information, status regarding
* mission
*------------------------------------------------------- 
draw:
    bsr     endl
    bsr     decorate
    lea     draw_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts
*-------------------------------------------------------
*-----------------------Horse feed-----------------------
* Input the feed load for each horse. Feed costs money
* For an advanced mark you need to manage this resource
*------------------------------------------------------- 
feed:
    bsr     endl
    bsr     decorate
    lea     feed_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*--------------------Horses Inventory---------------------
* Number of horses to be allocated to a mission 
*------------------------------------------------------- 
horses:
    bsr     endl
    bsr     decorate
    lea     horses_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*-------------------Horse(s) Charge Speed---------------
* horses speed to and from a mission
*------------------------------------------------------- 
rate:
    bsr     endl
    bsr     decorate
    lea     rate_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*------------------Mission Distance---------------------
* Distance to battle location
*------------------------------------------------------- 
distance:
    bsr     endl
    bsr     decorate
    lea     distance_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Soldiers----------------------
* Number of soldiers
*-------------------------------------------------------   
soldiers:
    bsr     endl
    bsr     decorate
    lea     soldiers_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*---Game Play (Mission Progress, Battle Maneuvers)------
*------------------------------------------------------- 
gameplay:
    bsr     endl
    bsr     decorate
    lea     gameplay_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    bsr     collision
    rts

*-------------------------------------------------------
*-----------------Heads Up Display (Score)--------------
* Retrieves the score from memory location
*-------------------------------------------------------   
hud:

    bsr     endl
    bsr     decorate
    lea     hud_msg,A1
    move.b  #14,D0
    trap    #15
    move.b  (A3),D1     retrieve the value A3 point to and move to D1
    move.b  #3,D0       move literal 3 to D0
    trap    #15         intrepret value in D0, which 3 which displays D1
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Taking Fire---------------------
* This could be used for collision detection, if 
*-------------------------------------------------------
collision:
    move.b  #mine_loc,D1
    cmp     #100,D1 is( x == 100)?
	bne     collision_miss if x is equal to 100, then hit
collision_hit:
    *hit
    lea     hit_msg,A1
    move    #14,D0
    trap    #15
    rts
    
collision_miss:
    *miss
    lea     miss_msg,A1
    move    #14,D0
    trap    #15
    rts

*-------------------------------------------------------
*--------------------------Loop-------------------------
*-------------------------------------------------------
loop:
    move.b  #5, D3 loop counter D3=5
next:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     next    repeat until D0=0

*-------------------------------------------------------
*------------------Screen Decoration--------------------
*-------------------------------------------------------
decorate:
    move.b  #60, D3
    bsr     endl
out:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     out	    repeat until D0=0
    bsr     endl
    rts
    
clear_screen: 
    move.b  #11,D0      clear screen
    move.w  #$ff00,D1
    trap    #15
    rts
*-------------------------------------------------------
*------------------------Replay-------------------------
*-------------------------------------------------------
replay:
    bsr     endl
    lea     replay_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4,D0
    trap    #15

    cmp     #exit,D1
    beq     end         if SR Z register contains 1 beq => Branch Equals
    bsr     gameloop

endl:
    movem.l D0/A1,-(A7)
    move    #14,D0
    lea     crlf,A1
    trap    #15
    movem.l (A7)+,D0/A1
    rts
    
*-------------------------------------------------------
*-------------------Data Delarations--------------------
*-------------------------------------------------------


crlf:           dc.b    $0D,$0A,0
welcome_msg:    dc.b    '********************************************************************************'
                dc.b    $0D,$0A
                dc.b    'ZorkQuest: Assault on Egreth Castle'
                dc.b    $0D,$0A
                dc.b    '*********************************************************************************'
                dc.b    $0D,$0A
                dc.b    'Hello adventurer! Welcome to the wonderful and mystical land of Egreth. Here '
                dc.b    $0D,$0A 
                dc.b    'you will explore the land and take on quests! Your first quest will be to '
                dc.b    $0D,$0A 
                dc.b    'prepare and successfully attack Egreth castle and defeat the Evil King! '
                dc.b    $0D,$0A 
                dc.b    'To successfully defeat the Kings army, you will need to hire Knights and '
                dc.b    $0D,$0A 
                dc.b    'Horses to fight by your side!'
                dc.b    $0D,$0A 
                dc.b    'Would you like to begin your Quest?'
                dc.b    $0D,$0A 
                dc.b    'Enter 1 for yey, 2 for ney:'
                dc.b    $0D,$0A,0
                
start_msg:      dc.b    'You awake in your small and cramped hut, a blinding ray of light hits your '
                dc.b    $0D,$0A 
                dc.b    'eyes as you open the door. This immediatly brings on a headache caused by last '
                dc.b    $0D,$0A 
                dc.b    'nights drinking. You have become a drunk from the pain of your fathers death!'
                dc.b    $0D,$0A 
                dc.b    'Your father was a noble farmer who was hanged by order of the Evil King. He '
                dc.b    $0D,$0A 
                dc.b    'was hanged for a crime he did not commit! His last wish was for his only son '
                dc.b    $0D,$0A 
                dc.b    'to one day avenge his death.... Today will be the day you set out to travel to '
                dc.b    $0D,$0A 
                dc.b    'to Egreth Castle and get vengence for your fathers murder.'
                dc.b    $0D,$0A,0

towninfo_msg:   dc.b    'You must travel a long journey north to reach Egreth castle. There is a small '
                dc.b    $0D,$0A 
                dc.b    'town just south of the castle called Ferncombe. The people of Ferncombe have '
                dc.b    $0D,$0A 
                dc.b    'been bullied by the Evil King for years so you should be able to round up a '
                dc.b    $0D,$0A 
                dc.b    'few locals to help you take down the King. They wont help you for free though '
                dc.b    $0D,$0A 
                dc.b    'so in order to gain help from the townspeople and their weapons and horses, you '
                dc.b    $0D,$0A 
                dc.b    'must pay them with gold!'
                dc.b    $0D,$0A,0
                
direction_choice: dc.b  'There are two routes to get to the town of Ferncombe, either through the valley '
                dc.b    $0D,$0A 
                dc.b    'or over the mountain. In the valley you will be more likely to find wild horses'
                dc.b    $0D,$0A 
                dc.b    'which could help you on your quest! But the mountain has caves and ruins where'
                dc.b    $0D,$0A 
                dc.b    'you may find gold! Which path will you choose?'
                dc.b    $0D,$0A 
                dc.b    'Enter 1 for Valley or 2 for Mountain:'
                dc.b    $0D,$0A,0
                
beginjourney:   dc.b    'Good choice! Before you set off on your journey you must decide on what items'
                dc.b    $0D,$0A 
                dc.b    'to bring. After you fill your bag with enough food and water to last the trip,'
                dc.b    $0D,$0A 
                dc.b    'there is only enough room for one more item. You must choose to bring either '
                dc.b    $0D,$0A 
                dc.b    'your fathers dagger or your oil lamp.'
                dc.b    $0D,$0A 
                dc.b    'Enter 1 for the dagger or 2 for the lamp:'
                dc.b    $0D,$0A,0

leavehomeval:   dc.b    'You set off on your journey.....'
                dc.b    $0D,$0A 
                dc.b    'After a many hours of travelling you finally reach the valley, the sun is '
                dc.b    $0D,$0A 
                dc.b    'now fading and it will be night soon. Will you set up camp and sleep'
                dc.b    $0D,$0A 
                dc.b    'or travel through the night? (it would be unwise to travel at night without'
                dc.b    $0D,$0A 
                dc.b    'a lamp to light the way)'
                dc.b    $0D,$0A 
                dc.b    'Enter 1 for camp or 2 to carry on:'
                dc.b    $0D,$0A,0

camp_msg:       dc.b    'You set up camp near a river and refill your water supplies. You fall'
                dc.b    $0D,$0A 
                dc.b    'asleep easily after a long day of walking.....'
                dc.b    $0D,$0A 
                dc.b    'You wake up feeling fresh, you pack up and head on with your journey.'
                dc.b    $0D,$0A,0
               
nighttravelmsglamp: dc.b    'You travel through the night but your lamp breaks, alone in the'
                dc.b    $0D,$0A 
                dc.b    'dark you wander off a steep hill and break your leg, with nobody around'
                dc.b    $0D,$0A 
                dc.b    'to help you, you eventually die. Game Over.'

               
feed_msg:       dc.b    'Feed load (each horse needs at least 100 units of feed)'
                dc.b    $0D,$0A
                dc.b    'Enter feed load : ',0
horses_msg:      dc.b    'Number of horses : ',0
rate_msg:       dc.b    'One Third[1], Two Thirds[2], Standard Charge[3], ' 
                dc.b    $0D,$0A
                dc.b    'Full Charge[4], Flank Charge[5] units feed per click'
                dc.b    $0D,$0A
                dc.b    'Enter Speed : ',0
distance_msg:   dc.b    'Mission distance e.g. 40 (with 100 units of feed  '
                dc.b    $0D,$0A
                dc.b    'One Third speed 20 units remain for manuvouirs) horses '
                dc.b    $0D,$0A
                dc.b    'Horses without feed are lost.'
                dc.b    $0D,$0A
                dc.b    'Enter mission distance : ',0
soldiers_msg:       dc.b    'Each horses need at least 1 Knight and an Stable Hand'
                dc.b    $0D,$0A
                dc.b    'minimum requirement is 2 i.e. Stable Hand x 1 and Knight x 1.'
                dc.b    $0D,$0A
                dc.b    'Enter # of soldiers : ',0
gameplay_msg:   dc.b    'Add Gameplay !',0
update_msg:     dc.b    'Update Gameplay !',0
draw_msg:       dc.b    'Draw Screen !',0
hit_msg:        dc.b    'Strike!',0
miss_msg:       dc.b    'Miss!',0
loop_msg:       dc.b    '.',0
replay_msg:     dc.b    'Enter 0 to Quit any other number to replay : ',0
hud_msg:        dc.b    'Score : ',0

health:     ds.w    1
score:      ds.w    1 reserve space for score

    end start






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
