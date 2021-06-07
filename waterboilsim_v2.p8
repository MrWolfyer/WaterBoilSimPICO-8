pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--water boiling simulator
--main

function _init()
	has_reset = false
	sfx(0)
	--create the random stars only
	--once
	create_stars()
end

function _update60()
	if has_reset then
		has_reset = false
		sfx(23)
	end
	update_game()
end

function _draw()
	cls()
	draw_game()
	camera()
	--print(game.timer,0,7,7)
	--print(game.d_s,0,14,7)
end
-->8
--draw
cam_x = 128
resetfade = true

function draw_game()
	--splashscreen
	if game.state == "ss" then
		print(text.ss, hcenter(text.ss), vcenter(text.ss),7)
		if time() - s_end_t >= 1 then
			draw_fade_out()
		end
	end
	
	--titlescreen and transition
	if game.state == "ts" or game.state == "tr_pr" then
		doshake()
		if game.state == "tr_pr" then
			draw_fade_out()
			fadeinperc = 1
		else
			draw_fade_in()
			fadeoutperc = 0
		end
		--draw the title logo
		--"water"
		sspr((64 % 16) * 8,(64 \ 16) * 8, 34,13,47,30)
		--"boiling"
		sspr((96 % 16) * 8,(96 \ 16) * 8, 47,12,41,45)
		--"simulator"
		sspr((69 % 16) * 8,(69 \ 16) * 8, 62,9,33,62)
		
		--draw text
		--prompt to start
		print(text.ts_p,hcenter(text.ts_p), 92,7)
		--hard mode
		if h_m then
			print(text.ts_h,hcenter(text.ts_h), 120,8)
		else
		 print(text.ts_h,hcenter(text.ts_h), 120,7)
		end
		--disable loud noises
		if l_n then
			print(text.ts_non,hcenter(text.ts_non), 3,7)
	 else
	 	print(text.ts_noff,hcenter(text.ts_noff), 3,11)
	 end
	end
	
	--prologue
	if game.state == "pr" or game.state == "pr_w" or game.state == "pr_stv" or game.state == "tr_mg" then
		if game.state == "tr_mg" then
			draw_fade_out()
			fadeinperc = 1
		else
			draw_fade_in()
			fadeoutperc = 0
		end
		--background
		rectfill(0,0,128,128,13)
		--pan
		sspr((2 % 16) * 8,(2 \ 16) * 8, 32,32,48,48)
	 --stove sprite (stv)
	 spr(game.stv, 70, 70)
	 
	 if game.state == "pr_w" and s_w_s == false then
	 	print(text.pr_w,hcenter(text.pr_w),108,7)
	 	--reusing flag to play sfx
	 	if s_end_f == false then
	 		sfx(3)
	 		s_end_f = true
	 	end
	 end
	 
	 if game.state == "pr_stv" and s_f_s == false then
	 	--print the text
	 	print(text.pr_stv,hcenter(text.pr_stv),108,7)
	 	--reusing flag to play sfx
	 	if s_end_f == false then
	 		sfx(3)
	 		s_end_f = true
	 	end
	 end
	 draw_water()
	end

	--text before main game
	if game.state == "txt_mg_1" then
		if h_m then
			text.txt_mg = "when it shows it's face..."
		end
		if txt_mg_t == 300 then
			draw_fade_out()
			fadeinperc = 1
			if fadeoutperc >= 1 then
				game.state="txt_mg_2"
				txt_mg_t = 0
			end
		else
			draw_fade_in()
			fadeoutperc = 0
			txt_mg_t += 2
		end
		print(text.txt_mg,hcenter(text.txt_mg),vcenter(text.txt_mg),7)
	end
	if game.state == "txt_mg_2" then
		if h_m then
			text.txt_mg = "show yours until it goes away."
		else
			text.txt_mg = "but beware..."
		end
		if txt_mg_t == 300 then
			draw_fade_out()
			fadeinperc = 1
			if fadeoutperc >= 1 then
				game.state="mg"
				txt_mg_t = 0
			end
		else
			draw_fade_in()
			fadeoutperc = 0
			txt_mg_t += 2
		end
		print(text.txt_mg,hcenter(text.txt_mg),vcenter(text.txt_mg),7)
	end
	
	--main game
	if game.state == "mg" or game.state == "c" or game.state == "tr_w"then
		if game.state == "tr_w" then
			draw_fade_out()
			fadeinperc = 1
			if fadeoutperc >=1 then
				game.state = "w"
			end
		else
			draw_fade_in()
			fadeoutperc = 0
		end
		camera()
		camera(cam_x, 0)
		map(0, 0, 0, 0, 128, 32)
		--center
			--draw pan and stove
			sspr((2 % 16) * 8,(2 \ 16) * 8, 32,32,176,48)
		 sspr((102 % 16) * 8,(102 \ 16) * 8, 32,8,176,80)
		 spr(game.stv, 198, 70)
		 draw_water()
		 --draw the stove flames
		 sspr((game.fs % 16) * 8,(game.fs \ 16) * 8, 12,5,48+10+128,48+17)
		 --windows
		 rectfill(131,0,190,39,0)
			line(130,40,191,40,7)
			
			line(191,39,191,0,6)
			line(130,39,130,0,7)
			circfill(141,2,2,7)
			 --stars
			 pset(w.s1x,w.s1y,7)
				pset(w.s2x,w.s2y,7)
				pset(w.s3x,w.s3y,7)
				pset(w.s4x,w.s4y,7)
				pset(w.s5x,w.s5y,7)
				pset(w.s6x,w.s6y,7)
			--cabinet and handle
			line(217,32,256,32,1)
	 	line(218,33,256,33,1)
			circfill(250,1,2,2)
			circfill(250,0,2,7)
			--sink
			rectfill(130,80,173,100,1)
			line(131,81,172,81,0)
			line(131,82,172,82,0)
			line(132,101,173,101,13)
 	 line(174,101,174,80,13)
			sspr((8 % 16) * 8,(8 \ 16) * 8,10,28,146,53)
			--board
			--circfill(225,116,4,6)
			--arrows
			if l == true or r == true or game.state == "c" then
 			
 		else
 			line(a1.x1+128+a_c_r,a1.y1,a1.x2+128+a_c_r,a1.y2,7)
 			line(a2.x1+128+a_c_r,a2.y1,a2.x2+128+a_c_r,a2.y2,7)
 
 			line(a3.x1+128+a_c_l,a3.y1,a3.x2+128+a_c_l,a3.y2,7)
 			line(a4.x1+128+a_c_l,a4.y1,a4.x2+128+a_c_l,a4.y2,7)
 		end
		--left side
			--bg
	 	rectfill(0,0,127,128,5)
	 	--end of hall
	 	rectfill(48,0,79,79,1)
	 	--floor
		 	--floor corners
		 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,0,112)
		 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,16,96)
		 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,32,80)
		 	
		 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,112,112,16,16,true)
		 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,96,96,16,16,true)
		 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,80,80,16,16,true)
		 	--floor ground
		 	rectfill(48,80,79,128,13)
		 	rectfill(32,96,96,111,13)
		 	rectfill(16,111,111,127,13)
		 --wall
		 	--wall corners
		  sspr((10 % 16) * 8,(10 \ 16) * 8,16,16,-1,112,16,16,true)
		 	sspr((10 % 16) * 8,(10 \ 16) * 8,16,16,15,96,16,16,true)
		 	sspr((10 % 16) * 8,(10 \ 16) * 8,16,16,31,80,16,16,true)
		 	--wall ground
		 	rectfill(-1,0,47,79,6)
		 	rectfill(-1,80,30,96,6)
		 	rectfill(-1,96,14,112,6)
		 --window
		 rectfill(53,18,75,43,0)
		 sspr((132 % 16) * 8,(132 \ 16) * 8,32,32,48,15)
		 --painting
		 sspr((106 % 16) * 8,(106 \ 16) * 8,16,16,93,35)
		 --bench
		 sspr((128 % 16) * 8,(128 \ 16) * 8,32,32,48,51)	
			--arrows
			if l == true or r == true or game.state == "c" then
				
			else
				line(a1.x1+a_c_r,a1.y1,a1.x2+a_c_r,a1.y2,7)
 			line(a2.x1+a_c_r,a2.y1,a2.x2+a_c_r,a2.y2,7)
			end
	--right side
		--bg
 	rectfill(256,0,384,128,5)
 	--end of door
 	rectfill(303,0,336,79,0)
 	--floor
	 	--floor corners
	 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,256,112)
	 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,272,96)
	 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,288,80)
	 	
	 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,368,112,16,16,true)
	 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,352,96,16,16,true)
	 	sspr((42 % 16) * 8,(42 \ 16) * 8,16,16,336,80,16,16,true)
	 	--wall corners
	  sspr((10 % 16) * 8,(10 \ 16) * 8,16,16,369,112)
	 	sspr((10 % 16) * 8,(10 \ 16) * 8,16,16,353,96)
	 	sspr((10 % 16) * 8,(10 \ 16) * 8,16,16,337,80)
	 	--wall ground
	 	rectfill(337,0,383,79,6)
	 	rectfill(353,80,383,96,6)
	 	rectfill(369,97,383,112,6)
	 	--floor ground
	 	rectfill(304,80,335,128,13)
	 	rectfill(288,96,352,111,13)
	 	rectfill(272,111,367,127,13)
	 	--painting
	 	sspr((12 % 16) * 8,(12 \ 16) * 8,16,16,349,35)
	 	--door
	 	sspr((44 % 16) * 8,(44 \ 16) * 8,16,16,290,80)
	 	rectfill(290,0,306,79,2)
	 	rectfill(288,0,289,95,4)
	 	circfill(294,40,2,1)
	 	circfill(295,40,2,6)
	 	--end of cabinet
	 	sspr((77 % 16) * 8,(77 \ 16) * 8,16,16,256,16)
	 	sspr((77 % 16) * 8,(77 \ 16) * 8,8,16,270,9)
	 	rectfill(256,0,277,16,4)
	 	line(256,30,277,20,2)
	 	line(256,31,277,21,2)
	  line(278,20,278,0,2)
	 	line(256,32,277,22,1)
	 	line(256,33,276,23,1)
	 	circfill(261,1,2,2)
			circfill(262,0,2,7)
	 --arrows
	 	if l == true or r == true or game.state == "c" then

			else
				line(a3.x1+256+a_c_l,a3.y1,a3.x2+256+a_c_l,a3.y2,7)
 			line(a4.x1+256+a_c_l,a4.y1,a4.x2+256+a_c_l,a4.y2,7)
			end
		--render demon
		--left side
		if game.d_m == 1 then
			if d_p == 1 then
				pset(61,30,8)
				pset(66,30,8)
				spr(143,56,40)
				spr(143,64,40,1,1,true)
				if f_d_c then
					game.d_c += 1
					f_d_c = false
				end
			--right side
			elseif d_p == 2 then
				pset(318,18,8)
				pset(323,18,8)
				spr(159,332,25)
				spr(159,332,36)
				if f_d_c then
					game.d_c += 1
					f_d_c = false
				end
			elseif d_p == 3 then
				pset(154,23,8)
				pset(159,23,8)
				if f_d_c then
					game.d_c += 1
					f_d_c = false
				end
			end
		else
			if d_p == 1 and game.state == "mg" then
				shake = 0.025
				doshake()
				zspr(140,3,4,61,28,0.5)
			elseif d_p == 2 and game.state == "mg" then
				shake = 0.025
				doshake()
				zspr(140,3,4,318,16,0.5)
			elseif d_p == 3 and game.state == "mg" then
				shake = 0.025
				doshake()
				zspr(140,3,4,154,21,0.5)
			end
		end
		draw_smoke()
		if game.timer >= 500 then
			if tutorial_txt_f and cam_x == 128 then
				print("press ❎ to concentrate",hcenter("press ❎ to concentrate")+128,120,0)
			end
		end
		--concentrate state
		camera()
		blink()
		if game.state == "c" then
			--only render text after blink
			--animation
			if c_txt_f == false then
				if b.y1 >= 64 then
					shake = 0.08
					if resetfade then
						fadeinperc = 1
						resetfade = false
					end
					draw_fade_in()
					if c_t >= 300 then
						doshake()
						print(story.text2,hcenter(story.text2),vcenter(story.text2),5)
						doshake()
						print(story.text2,hcenter(story.text2),vcenter(story.text2),6)
						camera()
						print(story.text2,hcenter(story.text2),vcenter(story.text2),7)
					else
						doshake()
						print(story.text1,hcenter(story.text1),vcenter(story.text1),5)
						doshake()
						print(story.text1,hcenter(story.text1),vcenter(story.text1),6)
						camera()
						print(story.text1,hcenter(story.text1),vcenter(story.text1),7)
					end
					if tutorial_txt_f then
						print("press ❎ to go back",hcenter("press ❎ to go back"),120,7)
					end
				end
			end
		end
	end
	
	--jumpscare lol
	if game.state == "js" then
		s = "you can't"
		shake = 0.01
		doshake()
		for i=0,25,1 do
			for b=0,5,1 do
				print(s,b*(#s*4),i*5,2)
			end
		end
		camera()
		circfill(64,64,16,0)
		if js_t >= 180 then
			zspr(140,2,1,rnd(128),rnd(128),flr(rnd(4)) + 1)
			zspr(156,2,1,rnd(128),rnd(128),flr(rnd(4)) + 1)
			zspr(172,2,1,rnd(128),rnd(128),flr(rnd(4)) + 1)
		else
			zspr(140,3,4,j_x,j_y,j_scale)
			shake = 0.1
			doshake()
		end
	end
	
	if game.state == "d" then
		print("you died.",1+hcenter("you died."),50,8)
		print("press ❎ to restart",hcenter("press ❎ to restart"),70,7)
	end

	if game.state == "w" then
		draw_fade_in()
		fadeoutperc = 0
		print("the water is boiling!",hcenter("the water is boiling"),100,11)
		print("press ❎ to restart",hcenter("press ❎ to restart"),115,7)
		--render stove with boiling animation
		sspr((2 % 16) * 8,(2 \ 16) * 8, 32,32,48,48)
		sspr((102 % 16) * 8,(102 \ 16) * 8, 32,8,48,80)
		spr(game.stv, 70, 70)
		draw_water()
		zspr(b_spr,4,1,48,44,1)
		--draw the stove flames
		sspr((game.fs % 16) * 8,(game.fs \ 16) * 8, 12,5,48+10,48+17)
		draw_smoke()
	end
end
-->8
--update

--attention: some game state
--changes may happen in the
--fade out or fade in functions

--flag that makes the splash
--end timer recieve the current
--time (it's also the sfx flag)
s_end_f = false
--splash end timer
s_end_t = 0
--loud noises flag
l_n = true
--hard mode
h_m = false

--flag that makes the prologue
--start timer recieve the
--current time only when i want
pr_t_f = false
--prologue start timer
pr_t_s = 0
--transition timer from water
--to stove
pr_w_t = 0 
--start water stream
s_w_s = false
--txt_mg timer 
txt_mg_t = 0

--stove flag to start turning the
--stove
s_f_s = false

--flame timer
f_t = 0

--flame sfx timer
f_s_t = 0

--arrow flag
a_f = false

--arrow counter
a_c_l = 0
a_c_r = 0

--cam movement
camscroll = 1
--flags that indicate if you're
---moving or not
l = false
r = false
--camera acceleration
cam_ac = 0

--concentrate
c = false
--concentrate timer
c_t = 0

--demon timer
d_t = 0
--where demon appears
d_p = 0
--demon place flag
d_p_f = false

--jumpscare timer
js_t = 0
--jumpscare image scale and
--coordinates
j_scale = 1
j_x = 56
j_y = 51
--sfx flags
--demon encounter
d_sfx_f = false
--demon move
dm_sfx_f = false
--ambient sounds
rnd_sfx_f = false
--sfx in gameover screen
dead_sfx_f = false
--sfx when you win
won_sfx = false
--gameoverscreen timer to reset
--sfx
go_timer = 0
--boiling animation spr
b_spr = 136
--smoke enabled
s_e = false
--concentrate txt flag
c_txt_f = false
--tutorial flag
tutorial_txt_f = true

--hard mode mechanics

--demon face timer
face_t = 0
--demon face move
face_move = false
--demon counter flag
f_d_c = true
function update_game()
	--splashscreen
	if game.state == "ss" then
		--when starting/restarting the
		--game, make the timer that
		--counts till the "ts" reset
		if s_end_f == false then
			s_end_t = time()
			s_end_f = true
		end
		--if 2 seconds passes, then
		--the game goes to the title
		--screen (ts)
		if time() - s_end_t >= 2 then
			game.state = "ts"
		end
	end
	
	--titlescreen
	if game.state == "ts" then
		--loud noises on or off
		if l_n then
			if btnp(➡️) then
				sfx(6)
				l_n = false
			end
		else
			if btnp(⬅️) then
				sfx(6)
				l_n = true
			end
		end
		--hard mode
		if h_m then
			if btnp(🅾️) then
				sfx(17)
				h_m = false
			end
		else
			if btnp(🅾️) then
				sfx(16)
				shake+=0.5
				h_m = true
			end
		end
		--start game transition
		if btnp(❎) then
			game.state = "tr_pr"
		end
	end
	
	--transition to start the
	--actual game
	if game.state == "tr_pr" then
		if fadeoutperc >= 1 then
			game.state = "pr"
		end
		--reset timer to play sfx
		s_end_f = false
	end
	
	--prologue (put water and
	--turn on the stove)
	if game.state == "pr" or game.state == "pr_w" or game.state == "pr_stv" then
		--timer to know when to show
		--text
		if pr_t_f == false then
			pr_t_s = time()
			pr_t_f = true
		end
		--after 1.5 seconds show the
		--first prompt
		--only recieve the water
		--state if the game isn't
		--on the stove state (loop
		--problems)
		if game.state ~= "pr_stv" then
			if time() - pr_t_s >= 1.5 then
				game.state = "pr_w"
			end
		end
		--if the game is in the "put
		--water" stage
		if game.state == "pr_w" then
			if btnp(❎) then
				s_w_s = true
				music(0)
			end
			--if the player presses ❎,
			--the game will render the
			--water stream
			if s_w_s then
				if game.w_s < 48 then
					--increases the line
					--height
					game.w_s += 2
				else
				--will add one to the length
				--until it reaches 10 (max
				--pan length)
				 if game.w_l < 10 then
				 	game.w_l += 1
				 end
				 if game.w_s_e < 50 then
				 	game.w_s_e += 2
				 else
				 	--timer to transition
				 	--to other fase
				 	if pr_w_t > 100 then
				 		s_end_f = false
				 		game.state = "pr_stv"
				 	else
				 		pr_w_t += 2
				 	end
				 end
				end
			end
		end
		--if the game is in the "turn
		--on the stove" stage
		if game.state == "pr_stv" then
			--if i press left to turn
			--on the stove then
			music(-1)
			if btnp(⬅️) then
				s_f_s = true
			end
			turnstove()
		end
	end
	
	if game.state == "tr_mg" then
		--start flame sfx as soon as
		--transitions ends
		f_s_t = 20
		if fadeoutperc >= 1 then
			game.state = "txt_mg_1"
		end
		s_end_f = false
	end
	
	--main game
	if game.state == "mg" or game.state == "c" then
		game.timer +=2
		--enable smoke
		if game.timer > 30000 then
			s_e = true
  end
  --update the smoke
  if s_e then
  	if rnd(20)<1 then
    make_smoke(192,48)
    make_smoke(195,48)
    make_smoke(189,48)
  	end
  	update_smoke()
  end
		--increase ai as time passes
		if h_m == false then
			if game.timer == 3000 then
				game.ai = 1
			elseif game.timer == 6000 then
				game.ai = 5
			elseif game.timer == 15000 then
				game.ai = 10
			elseif game.timer == 24000 then
				game.ai = 15
			elseif game.timer == 30000 then
				game.ai = 20
   end
  else
  	game.ai = 20
  	if game.timer == 3000 then
				game.d_d = 450
			elseif game.timer == 24000 then
				game.d_d = 300
   end
		end
		--end game after 7 min.
		if game.timer == 42000 then
			game.state = "tr_w"
		end
		
		--flame animation cycle
		if f_t == 1 then
			if game.fs >= 54 then
				game.fs = 6
			else
				game.fs += 16
			end
			f_t = 0
		else
			f_t +=0.5
		end
		--flame sfx loop
		f_s_t += 1
		if f_s_t >= 20 then
			sfx(8)
			f_s_t = 0
		end
		--arrow animation loop
		if a_f == false then
			a_c_l -= 0.25
			a_c_r += 0.25
		else
			a_c_l += 0.25
			a_c_r -= 0.25
		end
		if a_c_r == 3 then
			a_f = true
		elseif a_c_r == 0 then
			a_f = false
		end
		--camera movement
		--only move if not concentrating
		if game.state ~= "c" then
			if l == false and r == false then
	  	if (btn(⬅️) and cam_x > 0) then
	  		l = true
	  	elseif (btn(➡️) and cam_x < 256) then
	  		r = true
	  	end
	  end
  end
  if l then
  	--smooth scrolling left
  	--center to left
  	if camscroll == 1 then
  		if cam_x <= 64 then
  			if cam_ac > 0 then
  				cam_ac -= 2
  			end
  		else
  			cam_ac += 2
  		end
  		cam_x -= cam_ac
  	--right to center
  	elseif camscroll == 2 then
  		if cam_x <= 192 then
  			if cam_ac > 0 then
  				cam_ac -= 2
  			end
  		else
  			cam_ac += 2
  		end
  		cam_x -= cam_ac
  	end
 	elseif r then
 	--smooth scrolling right
 	--center to right
  	if camscroll == 1 then
  		if cam_x >= 192 then
  			if cam_ac > 0 then
  				cam_ac -= 2
  			end
  		else
  			cam_ac += 2
  		end
  		cam_x += cam_ac
  	--left to center
  	elseif camscroll == 0 then
  		if cam_x >= 64 then
  			if cam_ac > 0 then
  				cam_ac -= 2
  			end
  		else
  			cam_ac += 2
  		end
  		cam_x += cam_ac
  	end	
  end
  --verify if you reached the
  --corners of the screen when
  --scrolling
  if camscroll == 1 then
  	if cam_x == 0 then
  		l = false
  		camscroll = 0
  		cam_ac = 0
  		--play demon sfx if it's
  		--there
  		if d_p == 1 then
  			if d_sfx_f == false then
  				if game.d_m == 1 then
  					sfx(20)
  				else
  					sfx(21)
  				end
  				
  				if l_n then
  					sfx(9)
  				else
  					sfx(22)
  				end
  				c_txt_f = false
  				d_sfx_f = true
  			end
  		end
  	end
  elseif camscroll == 2 then
  	if cam_x == 128 then
  		l = false
  		camscroll = 1
  		cam_ac = 0
  		--play demon sfx if it's
  		--there
  		if d_p == 3 then
  			if d_sfx_f == false then
  				if game.d_m == 1 then
  					sfx(20)
  				else
  					sfx(21)
  				end
  				
  				if l_n then
  					sfx(9)
  				else
  					sfx(22)
  				end
      c_txt_f = false
  				d_sfx_f = true
  			end
  		end
  	end
  end
  if camscroll == 0 then
  	if cam_x == 128 then
  		r = false
  		camscroll = 1
  		cam_ac = 0
  		--play demon sfx if it's
  		--there
  		if d_p == 3 then
  			if d_sfx_f == false then
  				if game.d_m == 1 then
  					sfx(20)
  				else
  					sfx(21)
  				end
  				
  				if l_n then
  					sfx(9)
  				else
  				 sfx(22)
  				end
  				c_txt_f = false
  				d_sfx_f = true
  			end
  		end
  	end
  elseif camscroll == 1 then
  	if cam_x == 256 then
  		r = false
  		camscroll = 2
  		cam_ac = 0
  		--play demon sfx if it's
  		--there
  		if d_p == 2 then
  			if d_sfx_f == false then
  				if game.d_m == 1 then
  					sfx(20)
  				else
  					sfx(21)
  				end
  				
  				if l_n then
  					sfx(9)
  				else
  					sfx(22)
  				end
  				c_txt_f = false
  				d_sfx_f = true
  			end
  		end
  	end
  end
  --concentrate mechanic
 	--can only concentrate if
 	--looking at the center
  if game.state == "c" then
			if btnp(❎) then
  			c_t = 0
  			game.state = "mg"
  			c_txt_f = true
  			tutorial_txt_f = false
  			resetfade = true
  	end
  	--blink animation
  	--stop increasing the y when
  	--they hit each other (half
  	--of the screen)
  	if b.y1 < 64 then
  		b.y1 += 4
  		b.y2 -= 4
  	end
  	--increase concentrate timer
  	c_t +=2
  	
  	--text to show
  	--hard mode doesn't have text
			if h_m == false then
				checktext()--see what text
				--to show now
		 end
  elseif camscroll == 1 and l == false and r == false then
  	if btnp(❎) then
  			game.state = "c"
  	end
  end
  --blink animation pt.2
  --stop decreasing the y when
  --both hit the bottom of the
  --screen
  if game.state == "mg" then
  	if b.y1 > 0 then
  		b.y1 -= 4
  		b.y2 += 4
  	end
  end
  
  --demon ai
  if game.d_m == 2 or game.state == "c" then
  	d_t = 0 
  else
  	d_t += 2
  end
  --hardmode
  if h_m then
  	if game.state == "c" then
  		if game.d_m == 2 then
  			if c_t >= 150 then
  	 		sfx(-1)
  	 	 game.state = "js"
  	 	end
  		elseif game.d_s == 2 then
  	 	if c_t >= 200 + ((1+flr(rnd(2)))*10) then
  	 		--reset demon
  	 		sfx(-1)
  	 		sfx(8)
  	 		game.d_s = 0
  	 		d_t = 0
  	 		d_p = 0
  	 		d_p_f = false
  	 		d_sfx_f = false
  	 		dm_sfx_f = false
  	 		f_d_c = true
  	 	end
  	 else
  	 	--die if you concentrate
  	 	--when demon is not around
  	 	if c_t >= 500 then
  	 		sfx(-1)
  	 	 game.state = "js"
  	 	end
  	 end 
  	elseif d_t >= 300 then
  		--if demon is in face mode
  		--then don't advance it
  		if game.d_m == 2 then
  		
  		elseif 1+flr(rnd(23)) <= game.ai then
  			game.d_s += 1
  		end
  		d_t = 0
  	end
  --normal mode
  else
  	--avoid demon
  	--only move demon if not
  	--concentrating
  	if game.state == "c" then
  		if game.d_s == 2 then
  	 	if c_t >= 200 + ((1+flr(rnd(2)))*10) then
  	 		--reset demon
  	 		--reset demon
  	 		sfx(-1)
  	 		sfx(8)
  	 		game.d_s = 0
  	 		d_t = 0
  	 		d_p = 0
  	 		d_p_f = false
  	 		d_sfx_f = false
  	 		dm_sfx_f = false
  	 		f_d_c = true
  	 	end
  	 else
  	 	--die if you concentrate
  	 	--when demon is not around
  	 	if c_t >= 1000 then
  	 		sfx(-1)
  	 	 game.state = "js"
  	 	end
  	 end
  	--random ambient sfx
  	elseif d_t == 400 then
  		if 1+flr(rnd(23)) <= game.ai then
  			temp_var = 1 + flr(rnd(2))
  			if rnd_sfx_f == false then
  				if temp_var == 1 then
  					sfx(11)
  				else
  					sfx(12)
  				end
  				rnd_sfx_f = true
  			end
  		end
  	--demon update tick
  	elseif d_t >= 600 then
  		--reset rnd_sfx_f var to
  		--false here because it's
  		--intervals matches
  		rnd_sfx_f = false
  		if 1+flr(rnd(23)) <= game.ai then
  			game.d_s += 1
  		end
  		d_t = 0
  	end
  end
  
  --where demon will appear
  if game.d_s == 2 then
  	if h_m then
  		if d_p_f == false then
	  		d_p_f = true
	  		--if demon will show eyes or
	  		--face 
	  		game.d_m = flr(rnd(2)) + 1
	  		d_p = flr(rnd(3)) + 1
	  	end
  	else
	  	if d_p_f == false then
	  		d_p_f = true
	  		--if demon will appear left(1)
	  		--or right(2)
	  		d_p = flr(rnd(2)) + 1
	  	end
	  end
	 	if dm_sfx_f == false then
	   temp_var = flr(rnd(2)) + 1
	   if temp_var == 1 then
	   	sfx(10)
	   else
	   	sfx(13)
	   end
	   dm_sfx_f = true
	  end
  end
  
  --hard mode demon face
  --mechanics
  if game.d_m == 2 then
  	face_t += 2
  	if face_t >= 300 then
  		face_move = true
  		face_t = 0
  	end
  	if face_move then
  		if d_p == 1 and camscroll == 0 then
 				d_t = 0
 				game.d_m = flr(rnd(2)) + 1
 				while d_p == 1 do
 					d_p = flr(rnd(3)) + 1
 				end
 			elseif d_p == 2 and camscroll == 2 then
 				d_t = 0
 				game.d_m = flr(rnd(2)) + 1
 				while d_p == 2 do
 					d_p = flr(rnd(3)) + 1
 				end
 			elseif d_p == 3 and camscroll == 1 then
 				d_t = 0
 				game.d_m = flr(rnd(2)) + 1
 				while d_p == 3 do
 					d_p = flr(rnd(3)) + 1
 				end
 			else
 				game.state = "js"
  		end
  		face_move = false
  	end
  	
  	--sfx when demon appears
  	--and you're already there
  	if d_sfx_f == false then
	  	if d_p == 1 and camscroll == 0 then
 				if game.d_m == 1 then
 					sfx(20)
 				else
 					sfx(21)
 				end
 				if l_n then
 					sfx(9)
 				else
 					sfx(22)
 				end
 				c_txt_f = false
 				d_sfx_f = true
	 		elseif d_p == 2 and camscroll == 2 then
	 			if game.d_m == 1 then
	 				sfx(20)
	 			else
	 				sfx(21)
	 			end
	 			if l_n then
	 				sfx(9)
	 			else
	 				sfx(22)
	 			end
	 			c_txt_f = false
	 			d_sfx_f = true
	 		elseif d_p == 3 and camscroll == 1 then
 				if game.d_m == 1 then
 					sfx(20)
 				else
 					sfx(21)
 				end
 				if l_n then
 					sfx(9)
 				else
 					sfx(22)
 				end
 				d_sfx_f = true
 				c_txt_f = false
	 		end
 		end
  end
  
  --death
  if game.d_s >= 3 then
  	game.state = "js"
  end
	end
	
	--jumpscare and transition to
	--game over screen
	if game.state == "js" then
		if s_end_f == false then
			sfx(-1)
			s_end_f = true
			if l_n then
				sfx(14)
			end
			sfx(15)
		end
		if js_t >= 225 then
			game.state = "d"
			sfx(-1)
		end
		js_t += 2
	end
	
	--play sfx sound in game over
	--screen
	if game.state == "d" then
		go_timer += 2
		if dead_sfx_f == false then
			sfx(19)
			dead_sfx_f = true
		end
		if go_timer >= 400 then
			dead_sfx_f = false
			go_timer = 0
		end
		--reset the game
		if btnp(❎) then
			resetgame()
		end
	end
	if game.state == "w" or game.state == "tr_w" then
		if won_sfx == false then
			sfx(7)
			won_sfx = true
		end
		if rnd(20)<1 then
   make_smoke(64,43)
   make_smoke(67,43)
   make_smoke(61,43)
  end
 	update_smoke()
 	
 	--flame animation cycle
 	--and boiling animation cycle
		if f_t == 1 then
			if game.fs >= 54 then
				game.fs = 6
				b_spr = 136
			else
				game.fs += 16
				b_spr += 16
			end
			f_t = 0
		else
			f_t +=0.25
		end
		--reset the game
		if btnp(❎) then
			resetgame()
		end
	end
end
-->8
--extra details
fadeoutperc = 0
fadeinperc = 1
shake = 0
--stove timer
s_t = 0

--fade in and out
function fadepal(_perc)
 -- 0 means normal
 -- 1 is completely black
 local p=flr(mid(0,_perc,1)*100)
 local kmax,col,dpal,j,k
 dpal={0,1,1, 2,1,13,6,
          4,4,9,3, 13,1,13,14}
 for j=1,15 do
  col = j
  kmax=(p+(j*1.46))/22
  for k=1,kmax do
   col=dpal[col]
  end
  --change palette
  pal(j,col)
 end
end

function draw_fade_in()
	fadeinperc -= 0.025
	if fadeinperc ~= 1 then
		fadepal(fadeinperc)
	end
end

function draw_fade_out()
	fadeoutperc += 0.025
	if fadeoutperc ~= 0 then
		fadepal(fadeoutperc)
	end
end

--center text
function hcenter(s)
  return 64-#s*2
end

function vcenter(s)
  return 61
end

--shake camera
function doshake()
 -- this function does the
 -- shaking
 -- first we generate two
 -- random numbers between
 -- -16 and +16
 local shakex=16-rnd(32)
 local shakey=16-rnd(32)

 -- then we apply the shake
 -- strength
 shakex*=shake
 shakey*=shake
 
 -- then we move the camera
 -- this means that everything
 -- you draw on the screen
 -- afterwards will be shifted
 -- by that many pixels
 if game.state == "mg" then
 	camera(shakex+cam_x,shakey)
 else
 	camera(shakex,shakey)
 end
 -- finally, fade out the shake
 -- reset to 0 when very low
 shake = shake*0.95
 if (shake<0.05) shake=0
end

--draw water
function draw_water()
	if game.w_s >= 48 then
		line(63,-1+game.w_s_e,63,game.w_s,12)
		if game.w_s_e >= 48 then
			line(64,-1+game.w_s_e,64,game.w_s,12)
			line(65,-1+game.w_s_e,65,game.w_s,12)
		else
			line(64,-1+game.w_s_e+2,64,game.w_s,12)
			line(65,-1+game.w_s_e+4,65,game.w_s,12)
		end
		--will only render the water
		--on the pan when the w_l
		--value is higher than 0
		--(this causes a delay)
		if game.w_l >= 0 then
			if game.w_l >= 10 then
				if game.state == "mg" or game.state == "c" then
					line(63-game.w_l+128,49,65+game.w_l-1+128,49,12)
				else
					line(63-game.w_l,49,65+game.w_l-1,49,12)
				end   
   else
    line(63-game.w_l,49,65+game.w_l,49,12)
   end		
		end
	else
		line(63,-1+game.w_s_e,63,game.w_s-1,12)
		line(64,-1+game.w_s_e,64,game.w_s,12)
		line(65,-1+game.w_s_e,65,game.w_s-2,12)	
	end
end

--func to turn on the
--stove
--and go to the main game
function turnstove()
	if s_f_s then
		if s_t == 30 then
			sfx(6)
			game.stv = 49
			game.state = "tr_mg"
		elseif s_t == 15 then
			sfx(6)
			game.stv = 33
		elseif s_t == 0 then
			sfx(6)
			game.stv = 17
		end
		s_t += 1
	end
end

--randomly generated stars
function create_stars()
	w = {
		s1x = 131+rnd(55),
		s2x = 131+rnd(55),
		s3x = 131+rnd(55),
		s4x = 131+rnd(55),
		s5x = 131+rnd(55),
		s6x = 131+rnd(55),
		s1y = rnd(35),
		s2y = rnd(35),
		s3y = rnd(35),
		s4y = rnd(35),
		s5y = rnd(35),
		s6y = rnd(35)
	}
end

--concentrating "transition"
function blink()
	if b.y1 > 1 then
		rectfill(0,0,384,b.y1,0)
		rectfill(0,128,384,b.y2,0)
	end
end

--easier sspr
function zspr(n,w,h,dx,dy,dz)
  sx = 8 * (n % 16)
  sy = 8 * flr(n / 16)
  sw = 8 * w
  sh = 8 * h
  dw = sw * dz
  dh = sh * dz
  sspr(sx,sy,sw,sh, dx,dy,dw,dh)
end

--smoke particles

smoke = {}
function make_smoke(startx, starty)
 
 --this section holds all the properties of a particle
 --such as x,y,speed,duration,etc
 --you can add as many properties as you want
 local smoke_particle = {
   --the location of the particle
   x=startx,
   y=starty,
   --what percentage 'dead'is the particle
   t = 0,
   --how long before the particle fades
   life_time=40+rnd(10),
   --how big is the particle,
   --and how large will it grow?
   size = 1,
   max_size = 1+rnd(3),
   
   --'delta x/y' is the movement speed,
   --or the change per update in position
   --randomizing it gives variety to particles
   dy = rnd(0.2) * -1,
   dx = rnd(0.3) - 0.2,
   --'ddy' is a kind of acceleration
   --increasing speed each step
   --this makes the particle seem to float
   ddy = -0.01,
   --what color is the particle
   col = 7
 }
 --after making the particle, add it to the list 'smoke'   
 add(smoke,smoke_particle)
end

--[[
this function needs to be called every update
in order for the smoke to move
--]]
function update_smoke()
  --perform actions on every particle
  for p in all(smoke) do
    --move the smoke
    p.y += p.dy
    p.x += p.dx
    p.dy+= p.ddy
    --increase the smoke's life counter
    --so that it lives the correct number of steps
    p.t += 1/p.life_time
    --grow the smoke particle over time
    --(but not smaller than its starting size)
    p.size = max(p.size, p.max_size * p.t )
    --make fading smoke particles a darker color
    --gives the impression of fading
    --change color if over 70% of time passed
    if p.t > 0.7  then
      p.col = 6
    end
    if p.t > 0.9 then
      p.col = 5
    end
    --if the particle has expired,
    --remove it from the 'smoke' list
    if p.t > 1 then
      del(smoke,p)
    end
  end
end

--call during draw function to
--draw the smoke
function draw_smoke()
  --draw each particle
  for p in all(smoke) do
    --draw a circle to be the smoke
    --replace this with whatever you want
    --your smoke to look like
    circfill(p.x, p.y, p.size, p.col)
  end
end

--check what text to show
--when player is concentrating
function checktext()
	if game.d_c == 0 then
		story.text1 = text.mg[1]
		story.text2 =	text.mg[2]
	elseif game.d_c == 1 then
		story.text1 = text.mg[3]
		story.text2 =	text.mg[4]
	elseif game.d_c == 2 then
		story.text1 = text.mg[5]
		story.text2 =	text.mg[6]
	elseif game.d_c == 3 then
		story.text1 = text.mg[7]
		story.text2 =	text.mg[8]
	elseif game.d_c == 4 then
		story.text1 = text.mg[9]
		story.text2 =	text.mg[10]
	elseif game.d_c == 5 then
		story.text1 = text.mg[11]
		story.text2 =	text.mg[12]
	elseif game.d_c == 6 then
		story.text1 = text.mg[13]
		story.text2 =	text.mg[14]
	elseif game.d_c == 7 then
		story.text1 = text.mg[15]
		story.text2 =	text.mg[16]
	elseif game.d_c == 8 then
		story.text1 = text.mg[17]
		story.text2 =	text.mg[18]
	elseif game.d_c == 9 then
		story.text1 = text.mg[19]
		story.text2 = text.mg[19]
	else
		story.text1 = ""
		story.text2 = ""
	end
end

--reset the game
function resetgame()
	has_reset = true
	
	create_stars()
	
	game.state = "ss"
	game.stv = 1
	game.fs = 6
	game.w_s = -1
	game.w_s_e = -60
	game.w_l = -20
	game.ai = 0
	game.d_s = 0
	game.d_d = 500
	game.d_m = 1
	game.d_c = 0
	game.timer = 0
	
	story.text1 = ""
	story.text2 = ""
	
	text.txt_mg = "the water is heating up..."
	
	b.y1 = 0
	b.y2 = 128
	
	fadeoutperc = 0
	fadeinperc = 1
	shake = 0
	s_t = 0
	
	cam_x = 128
	resetfade = true
	
	f_d_c = true
	s_end_f = false
	s_end_t = 0
	l_n = true
	h_m = false
	pr_t_f = false
	pr_t_s = 0
	pr_w_t = 0 
	s_w_s = false
	txt_mg_t = 0
	s_f_s = false
	f_t = 0
	f_s_t = 0
	a_f = false
	a_c_l = 0
	a_c_r = 0
	camscroll = 1
	l = false
	r = false
	cam_ac = 0
	c = false
	c_t = 0
	d_t = 0
	d_p = 0
	d_p_f = false
	js_t = 0
	j_scale = 1
	j_x = 56
	j_y = 51
	d_sfx_f = false
	dm_sfx_f = false
	rnd_sfx_f = false
	dead_sfx_f = false
	won_sfx = false
	go_timer = 0
	b_spr = 136
	s_e = false
	c_txt_f = false
	tutorial_txt_f = true
	face_t = 0
	face_move = false
end
-->8
---vars
game = {
	state = "ss",
	--ss = splashscreen
	--ts = titlescreen
	--tr_pr = transition prologue
	--pr = prologue
	--pr_w = put water
	--pr_stv = turn on stove
	--txt_mg_1 = text 1 before mg
	--txt_mg_2 = text 2 before mg
	--tr_mg = transition to maingame
	--mg = main game
	--c = concentrate
	--js = jumpscare
	--d = dead
	--tr_w = win transition
	--w = win
	
	--stv = stove sprites
	stv = 1,
	--fs = flame sprites
	fs = 6,
	--w_s = water stream
	w_s = -1,
	--w_s_e = water stream end
	w_s_e = -60,
	--water length
	w_l = -20,
	
	--demon ai
	ai = 0,
	--demon state
	d_s = 0,
	--hard mode demon delay
	d_d = 500,
	
	--hard mode demon mode
	d_m = 1,
	-- 1 = eyes
	-- 2 = face
	
	--demon encounter counter
	d_c = 0,
	
	--time
	timer = 0
}

text = {
	ss = "a game by mrwolfyer",
	--title screen prompt
	ts_p = "press ❎ to start",
	ts_h = "press 🅾️ for hard mode",
	ts_non = "loud noises:  on ➡️",
	ts_noff = "loud noises: ⬅️ off",
	pr_w = "press ❎ to put water",
	pr_stv = "press ⬅️ to turn on the stove",
	txt_mg = "the water is heating up...",
	mg = {
		"you'll be safe here...",
		"but don't stay for long.",
	
		"you might think it's real...",
		"but it's all in your head.",
	
		"trust in yourself.",
		"it will be different this time.",
	
		"if you keep being afraid...",
		"you won't achieve anything",
	
		"but you have potential.",
		"you are great.",
	
		"you shouldn't care about him.",
		"he never cared about you.",
	
		"you were always there...",
		"but... he prefered others.",
	
		"other people believe in you!",
		"it won't hurt to try...",
	
		"i trust in you.",
		"i really do.",
	
		"you can do this."
	}
}

--arrows coordinates (because
--they're just lines)
a1 = {
	 x1 = 113,
	 y1 = 43,
	 x2 = 124,
	 y2 = 54
	}
	a2 = {
	 x1 = 113,
	 y1 = 65,
	 x2 = 124,
	 y2 = 54
	}
	a3 = {
	 x1 = 14,
	 y1 = 43,
	 x2 = 3,
	 y2 = 54
	}
	a4 = {
	 x1 = 14,
	 y1 = 65,
	 x2 = 3,
	 y2 = 54
	}
	
--blink animation coordinates
b = {
	y1 = 0,
	y2 = 128
}

--gameover text
g_txt = {
	"◆█⧗♥░⧗☉🐱",
	"y🅾️u c█n'⧗",
	"☉ 🐱█♪'⧗ ⬇️🅾️ ☉⧗",
	"you'll never be like them",
	"you'll never be like him",
	"you can't",
}

story = {
	text1 = "",
	text2 = ""
}
__gfx__
000000000005500000006666666666666666666666670000faf0ff9f0f9f00000007760000000000666666666666666644400000000000006666666644444444
0000000000655700066665555555555555555555555676700900008000a00000007666600000000006666666666666664cc44400000000006666666644444444
00700700066556706606667777777777666676666666606708a00a8009800000006606700000000000666666666666664c7ccc44900000006666666644444444
000770000665566060066666666666666666666666666007009449844a000000006606700000000000066666666666664c77ccccc94900006666666644444444
0007700006666660660666666666666666666666666660672222222222220000006606700000000000006666666666664ccccccccccc99906666666644444444
0070070006666660066666666666666666666666666666600000000000000000006606700000000000000666666666664ccccc7cccccccc96666666644444444
0000000000666600000666666666666666666666666670000000000000000000066606600000000000000066666666664c3ccc77ccccccc96666666644444444
000000000000000000066666666666666666666666667000000000000000000006600660000000000000000666666666433bccccccc7ccc96666666644444444
566666550000000000066666666666666666666666667000fff0ffff0fff0000066006600000000000000000666666664333ccccccc77cc92244444422444444
5566676505567700000666666666666666666666666670000a0000a000900000066006700000000000000000066666664333bccc3bccccc42244444422444444
556676660555667000066666666666666666666666667000098009a00a8000000660067000000000000000000066666643333cc33bbcccc92244444422444444
5556666706555660000666666666666666666666666670000094489448000000dddd06600000000000000000000666660444333333b3ccc92244444422444444
5555666606656660000666666666666666666666666660002222222222220000dddd06600000000000000000000066660000444333333bc42244444422444444
55555766066666600006666666666666666666666666700000000000000000000000066000000000000000000000066600000004443333b92244444422444444
55555666006666000006666666666666666666666666600000000000000000000000066000000000000000000000006600000000004443342222222222444444
55555666000000000006666666666666666666666666600000000000000000000000066000000000000000000000000600000000000004442222222222444444
555556670000000000006666666666666666666666660000f8f0ff8f0faf00000000066000000000000000000000000d22222222222222224444444411111111
5555566700667700000006666666666666666666666000000a0000a000900000000006600000000000000000000000dd22222222222222204444444411111111
55555666066666700000001111000000000000111100000009a008900890000000000660000000000000000000000ddd22222222222222004444444411111111
555556665555666000000111000000000000000011100000008449844a0000000000066000000000000000000000dddd22222222222220004444444411111111
5555566655556660000011100000055555500000011100002222222222220000000006600000000000000000000ddddd22222222222200004444444411111111
555555660666666000111111111111111111111111111100000000000000000000000660060000000000000000dddddd22222222222000004444444411111111
55555555006666000111111111111111111111111111111000000000000000000000066006000000000000000ddddddd22222222220000002222222211111111
55555555000000000111111111111111111111111111111000000000000000000000066dd600000000000000dddddddd22222222200000002222222211111111
555555550000000001111111111111111111111111111110fff0ffff0fff00000000066d660000000000000ddddddddd22222222000000007777777766666666
55555555006677000111111111111111111111111111111009000090008000000000066000000000000000dddddddddd22222220000000007777777766666666
555555550666667001111111111111111111111111111110098009800a800000000006d00000000000000ddddddddddd22222200000000007777777777777777
77676115066566600111111111111111111111111111111000a44a944900000000000dd0000000000000dddddddddddd22222000000000007777777777777777
66666661065556600111111111111111111111111111111022222222222200000000000000000000000ddddddddddddd22220000000000007777777777777777
6666666105556660001111111111111111111111111111000000000000000000000000000000000000dddddddddddddd22200000000000007777777777777777
555166610556660000011100000000000000000000111000000000000000000000000000000000000ddddddddddddddd22000000000000007777777777777777
55551115000000000000100000000000000000000001000000000000000000000000000000000000dddddddddddddddd20000000000000007777777777777777
cc000cc00cccc00cccccc0ccccc0ccccc00000000777700777777077000770770077077000007777007777770077770077777000444444444444444400000000
cc000cc0cccccc0cccccc0ccccc0cccccc0000007777770777777077707770770077077000077777707777770777777077777700444444444444444400000000
cc000cc0cc0ccc0c0cc0c0cc0000cc0ccc0000007700770007700077777770770077077000077007700077000770077077007700444444444444444400000000
cc0c0cc0cc00cc0c0cc000ccccc0cc00cc0000007777700007700077777770770077077000077007700077000770077077007700444444444444444400000000
ccccccc0cccccc0c0cc000ccccc0ccccc00000000777770007700077777770770077077000077777700077000770077077777000444444444444444400000000
ccccccc0cccccc000cc000cc0c00cccccc0000000000770007700077070770770077077000077777700077000770077077777700444444444444444400000000
ccccccc0cc0ccc000cc000cc0000ccc0cc0000007700770007700077000770770077077000077007700077000770077077007700444444444444444400000000
ccccccc0cc00cc000cc000ccccc0cc00cc0000007777770777777077000770777777077777077007700077000777777077007700444444444444444400000000
cc0c0cc0cc00cc000cc000ccccc0cc00cc0000000777700777777077000770077770077777077007700077000077770077007700444444444444444400000000
c00c00c00c000c000c0000cc0c00c000cc0000000000000000000000000000000000000000000000000000000000000000000000444444444444440000000000
c00000000c0000000c0000c00c00c0000c0000000000000000000000000000000000000000000000000000000000000000000000444444444444000000000000
c00000000c000000000000000000c0000c0000000000000000000000000000000000000000000000000000000000000000000000444444444400000000000000
c00000000c00000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000000000444444440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444400000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000440000000000000000000000
6000000000006000006000000000000000000006000000000dddddddddddddddddddddddddddddd0444000000000000066666666777777777777777777777777
600600006000006000000600000006000060000000060000dddddddddddddddddddddddddddddddd411444000000000066666666777777777777777777777777
6600000066006060606006000006060600600006060660600dddddddddddddddddddddddddddddd0417111449000000077777766777777776667766667677766
66666000666660666666066000066666606600660666666000000000000000000000000000000000411111111949000077777766777777776666666666666666
66666606666660666666066000066666606660660666666000000000000000000000000000000000411111111111999077777766777777776dddddddddddddd6
6600660660066000660006600000066000666066066006600000000000000000000000000000000041171333311111197777776677777777d77777777777777d
66666606600660006600066000000660006666660660600000000000000000000000000000000000411113333317111977777766666666667777777777777777
66666006600660006600066000000660006666660660666000000000000000000000000000000000411111333311111977777766666666667777777777777777
66006606606660606600066006060660006666660660666066666666555555556677777777777766411111121111171977777766667777770000000000000000
660666066066606066060660660606606066066606600660666666665555555566777777777777664dd111221111111477777766667777770000000000000000
666666066666606666660666660666666066006606666660667777775555555566777777777777664ddd55522111111977777766667777770000000000000000
66666000666600666666066666066666606600660066660066777777555555556677777777777766044455555111111977777766667777770000000000000000
000000000000000000000000000000000000000000000000667777775555555566777777777777660000444555dddd1477777766667777770000000000000000
000000000000000000000000000000000000000000000000667777775555555566777777777777660000000444ddddd977777766667777770000000000000000
000000000000000000000000000000000000000000000000667777775555555566777777777777660000000000444dd466666666666666660000000000000000
00000000000000000000000000000000000000000000000066777777555555556677777777777766000000000000044466666666666666660000000000000000
00000000000000000000000000000000240000000000000000000000000000420000000000000000000000000000000000000008888000000000000000000000
00000000000000000000000000000000244000000000000000000000000004420000000000000000000000000000000000000088888800000000000000000000
00000000000000000000000000a0a0a0244444444444444444444444444444420000000000000000000000000000000000000888888888000000000000000000
00000000000000000000000000aaaaa02244400000000000000000000004442200000000000000c0000c00000000000000000888888888800000000000222220
000000000000000000000000000aaa0024244000000000000007000000044242000000cc00000ccc000cc0000c00000000008888888888880000000002222220
000000000000000000000000000030002442400000000000000000000004244200000cccccccccccccccccccccc0000000088888888888888000000002020200
00000000000000000000000000003000244420000000000000000000000244420000000000000000000000000000000000088888888888888000000002020200
00000000000000000000000000003000244440007000000000000000000444420000000000000000000000000000000000008888888888888000000002020200
00000000000000000000000000088e00224440000000000000000000000444220000000000000000000000000000000000008888888008888000000000000000
00000000000000000000000000088e00242240000000000000000000000422420000000000000000000000000000000000000888880000888000000000002200
000000000000000000000000008888e0244420000000000000007000000244420000000000000000000000000000000088800888888888888000000000022022
0000000000000000000000000088888024444000000000000000000000044442000000000000c000000000000000000008800888888888888000000000022200
0000007700077000000000000088888024444000000000000000000000044442000000000cc0c00c0000cc000c00000008800888888888888000000000022022
022227777677772222222222228888802224400000000000000000000004422200000cccccccccccccccccccccc0000008800888888888888000000000022200
22223333333333322222222222288822244220070000000000000000000224420000000000000000000000000000000088800888888888880000000000022022
44444444444444444444444444444444244440000000000000000000000444420000000000000000000000000000000008800008888888880000000000000000
44444444444444444444444444444444244440000000000000000000700444420000000000000000000000000000000000800080088888800000000000000000
44444444444444444444444444444444244220000000000000000000000224420000000000000000000000000000000000000888888888800000000000000000
44200000000000000000000000000244222440000000000000000000000442220000000000000000000000000000000000000888888888800000000000000000
4420000000000000000000000000024424444000000000000000000000044442000000c00000000000c000000000000000000888888888800000000000000000
442000000000000000000000000002442444400000000000000000000004444200000cc0000c000c00c000cc0000000000000888888888000000000000000000
442000000000000000000000000002442444200000000000000000000002444200000cccccccccccccccccccccc0000000000088008888000000000000000000
44200000000000000000000000000244242240000000000000000000000422420000000000000000000000000000000000000000088880000000000000000000
44200000000000000000000000000244224440000000000000000000000444220000000000000000000000000000000000000088888880000000000000000000
44200000000000000000000000000244244440000000000000000000000444420000000000000000000000000000000000000888888800000000000000000000
44200000000000000000000000000244244420000000000000000000000244420000000000000000000000000000000000000088888000000000000000000000
42000000000000000000000000000024244240000000000000000000000424420000000000000000000000000000000000000008880000000000000000000000
4200000000000000000000000000002424244000000000000000000000044242000000c0000c000000000c000000000000000000000000000000000000000000
420000000000000000000000000000242244400000000000000000000004442200000cccc00c0c00c000ccc000c0000000000000000000000000000000000000
420000000000000000000000000000242444444444444444444444444444444200000cccccccccccccccccccccc0000000000000000000000000000000000000
44200000000000000000000000000244244000000000000000000000000004420000000000000000000000000000000000000000000000000000000000000000
44200000000000000000000000000244240000000000000000000000000000420000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000cc000cc00cccc00cccccc0ccccc0ccccc000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000cc000cc0cccccc0cccccc0ccccc0cccccc00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000cc000cc0cc0ccc0c0cc0c0cc0000cc0ccc00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000cc0c0cc0cc00cc0c0cc000ccccc0cc00cc00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000ccccccc0cccccc0c0cc000ccccc0ccccc000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000ccccccc0cccccc000cc000cc0c00cccccc00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000ccccccc0cc0ccc000cc000cc0000ccc0cc00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000ccccccc0cc00cc000cc000ccccc0cc00cc00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000cc0c0cc0cc00cc000cc000ccccc0cc00cc00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000c00c00c00c000c000c0000cc0c00c000cc00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000c00000000c0000000c0000c00c00c0000c00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000c00000000c000000000000000000c0000c00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000c00000000c00000000000000000000000c00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000600000000000600000600000000000000000000600000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000600600006000006000000600000006000060000000060000000000000000000000000000000000000000000
00000000000000000000000000000000000000000660000006600606060600600000606060060000606066060000000000000000000000000000000000000000
00000000000000000000000000000000000000000666660006666606666660660000666666066006606666660000000000000000000000000000000000000000
00000000000000000000000000000000000000000666666066666606666660660000666666066606606666660000000000000000000000000000000000000000
00000000000000000000000000000000000000000660066066006600066000660000006600066606606600660000000000000000000000000000000000000000
00000000000000000000000000000000000000000666666066006600066000660000006600066666606606000000000000000000000000000000000000000000
00000000000000000000000000000000000000000666660066006600066000660000006600066666606606660000000000000000000000000000000000000000
00000000000000000000000000000000000000000660066066066606066000660060606600066666606606660000000000000000000000000000000000000000
00000000000000000000000000000000000000000660666066066606066060660660606606066066606600660000000000000000000000000000000000000000
00000000000000000000000000000000000000000666666066666606666660666660666666066006606666660000000000000000000000000000000000000000
00000000000000000000000000000000000000000666660006666006666660666660666666066006600666600000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000007777007777770770007707700770770000077770077777700777700777770000000000000000000000000000000000
00000000000000000000000000000000077777707777770777077707700770770000777777077777707777770777777000000000000000000000000000000000
00000000000000000000000000000000077007700077000777777707700770770000770077000770007700770770077000000000000000000000000000000000
00000000000000000000000000000000077777000077000777777707700770770000770077000770007700770770077000000000000000000000000000000000
00000000000000000000000000000000007777700077000777777707700770770000777777000770007700770777770000000000000000000000000000000000
00000000000000000000000000000000000007700077000770707707700770770000777777000770007700770777777000000000000000000000000000000000
00000000000000000000000000000000077007700077000770007707700770770000770077000770007700770770077000000000000000000000000000000000
00000000000000000000000000000000077777707777770770007707777770777770770077000770007777770770077000000000000000000000000000000000
00000000000000000000000000000000007777007777770770007700777700777770770077000770000777700770077000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0000000000000000000000000000000077777777777777777777771f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777771f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777771f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777771e2e2e2e2e2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e370000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e6b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000007777771077777777763f3f3f3f3f3f6c460000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000007777772030777777783e3e6e6f3e3e79400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000077777777777777777d6d6d6d6d6d6d7c400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000007777777777777777783e3e3e3e3e3e79750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
150f000000200002002325027250232502825014200102000c2000920006200052000320002200012000120001200002000020000200002000020000200002000020000200002000020000200002000020000200
901000000061002610006100061002610006100061003610006100061000610036100061000610046100061000600006000060000600006000060000600006000060000600006000060000600006000060000600
910700000162003620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07030000137401f74017740137401f740007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
090c00000061000610006100061000610006100061000100031000710003100051000040000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e0c00000060000600006000060000600006100061000610006100061000610006100061000610006000060500600006000060000600006000060000600006000060000600006000060000600006000060000600
0104000013033240332f0330803300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003
162200000f23216230112301b230162321f232132301b23227232272220f2300f2351b2000e2000c200162000f2001120013200162000f2001b200162000c2000f200112001320218200182000a2000720201202
971300000061003610006100061003610006100061000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1603000003452074520a452114521d7523a6523a7523a7523a6523a7523a7523a7523a7523a7523a6523a7523a7523a7523a7523a6523a7523a6523a7523a7520040200402004020040200402004020040200402
d70b0000006010f611116121361200605006010060111611136111661100601006010060100601006010060100601006010060100601006010060100601006010060100601006010060100601006010060100601
a70500002471029710247000070024710297102470000700007000070024700247102971024700007002471029710247000070000700007000070000700007000070000700007000070000700007000070000700
d6100000036310e631136310a63113631136310c63113631056310063100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001
940900000541018611052110f610050120a6150551500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1e0700000f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2510f2511c67015670126700a67015670
670700000f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2210f2211b63015630126300a63015630
3002000003750057500a7500f750167501f75027750226501d650136500f7500a6500565003655006530065300750007500375003750037500375000750007500075000700007000070003700037000370003700
000700000275403754077540d6540d65407754037540075401704007040070400704226042b6042e604247041f7041b704167040f7040a7040570403704007040070400004000040000400004000040000400004
1711000029242322420020028240002002924000200002002924000200002003024232240002003224500200342443224034243342433224000200002003224000200002002f2423024028240002002824300200
9019000013514135211353113521135111352113531135211351113521135311352513500125002f5001250013500135001350013500135001350013500135001650016500135001350010500135001350016500
01120000050000500005000050730507305000050000500005000050730507305000050011b001050050507305073050000500005000050000507305073000001b00005000050000507305073050000500005000
1010011d050000500005000050730507305000050000507305073050000500005073050731b000050050507305073050000500005073050730500005000050730507305000050000507305073050000500005000
1603000003422074220a422114221d7223a6223a7223a7223a6223a7223a7223a7223a7223a7223a6223a7223a7223a7223a7223a6223a7223a6223a7223a7220000000000000000000000000000000000000000
151000002325427254232542825400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004
__music__
00 04054344
00 52544344

