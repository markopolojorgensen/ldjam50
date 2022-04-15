extends NPC


# 0 - 7
export(int, 7) var npc_id = 0

# true for where they are originally found
export(bool) var flip_active = false

var celebration_musings = 0

var hint_phrase = ""
var always_phrases = [
	"...",
	"Thanks for inviting me!",
	"Not much of a dancer, are you? No worries, I get it.",
	"Nice shoes!",
	"Yo, let me know if you need me to run and get anything.",
	"Have you heard those 'end-of-the-party' conspiracies? I guess the aztecs saw it coming ages ago.",
	"So, what are you up to these days?",
	"Congratulations on the fantastic party!",
	"Huh? What's that?",
	"Hey! How's life?",
	"It's really nice to kick back and unwind.",
	"Played any good games recently?",
]

var likes_list = [
	"music",       # 0
	"balloons",    # 1
	"bundles",     # 2
	"hats",        # 3
	"bunting",     # 4
	"streamers",   # 5
	"banners",     # 6
	"disco balls", # 7
]

var squash = true
var teleported = false

const coin_scene = preload("res://cycle/coin.tscn")

func _ready():
	# don't have to call ._ready()?
	if randf() < 0.5:
		squash = false
	fancy_update()
	add_to_group("generic_npcs")
	$teleport_timer.connect("timeout", self, "queue_free")

func _process(_delta):
	if $player_proximity_detector.is_player_near():
		$sprite.frame = (npc_id * 2) + 1
	else:
		$sprite.frame = npc_id * 2


func beat():
	.beat()
	var invited = (npc_id in global.invited_npcs)
	if teleported or not invited:
		return
	
	if squash:
		$sprite.flip_h = true
		$sprite_animation_player.play("squash")
	else:
		$sprite.flip_h = false
		$sprite_animation_player.play("stretch")
	squash = not squash

func activate():
	.activate()
	if not is_showing_dialogue():
		if teleported:
			return
		show_dialogue(pick_phrase())
	else:
		hide_dialogue()

func fancy_update():
	if teleported:
		return
	
	var invited = (npc_id in global.invited_npcs)
	
	if (invited and not flip_active) or (not invited and flip_active):
		if not activatable:
			$sprite_animation_player.play_backwards("teleport")
			activatable = true
			show()
	else:
		activatable = false
		hide()

class PhraseAction:
	var text = ""
	var callback_name
	var priority = 0
	var weight = 1

func pick_phrase():
	var phrase_actions = []
	
	var like = likes_list[npc_id]
	if like in global.items_purchased:
		if npc_id in global.invited_npcs:
			# massive series of conditionals goes here
			for phrase in always_phrases:
				var phrase_action = PhraseAction.new()
				phrase_action.text = phrase
				phrase_actions.append(phrase_action)
			
			if global.chip_in_timers[npc_id] <= 0:
				var phrase_action = PhraseAction.new()
				phrase_action.priority = 10
				phrase_action.callback_name = "chip_in"
				phrase_action.text = "Hey, I haven't chipped in for a while, let me fix that."
				phrase_actions.append(phrase_action)
			else:
				var phrase_action = PhraseAction.new()
				phrase_action.text = "I'm pretty strapped for cash right now, thanks for hosting!"
				phrase_actions.append(phrase_action)
			
			var phrase_action = PhraseAction.new()
			phrase_action.callback_name = "increment_celebration_musings"
			match celebration_musings:
				0:
					phrase_action.text = "So, what are we celebrating?"
					phrase_actions.append(phrase_action)
				1:
					phrase_action.text = "I guess we don't need a reason, just curious."
					phrase_action.priority = 9
					phrase_actions.append(phrase_action)
			
			# comments about tunes
			phrase_action = PhraseAction.new()
			if "music" in global.items_purchased:
				if (npc_id % 4) == 0:
					phrase_action.text = "Isn't the music a little loud?"
				else:
					phrase_action.text = "I love this song, turn it up!"
				
				phrase_action = PhraseAction.new()
				phrase_action.text = "What a bop!"
				phrase_actions.append(phrase_action)
				phrase_action = PhraseAction.new()
				phrase_action.text = "What a banger!"
				phrase_actions.append(phrase_action)
			else:
				phrase_action.text = "Could really do with some music, don't you think?"
			phrase_actions.append(phrase_action)
			
			# comments about time
			if global.current_cycle.cycle_time < 15:
				phrase_action = PhraseAction.new()
				phrase_action.priority = 1
				phrase_action.text = "Got a minute? No, I suppose not."
				phrase_actions.append(phrase_action)
				
				phrase_action = PhraseAction.new()
				phrase_action.priority = 1
				phrase_action.text = "Don't you have somewhere to be?"
				phrase_actions.append(phrase_action)
				
				phrase_action = PhraseAction.new()
				phrase_action.priority = 1
				phrase_action.text = "Cutting it a little close, aren't you?"
				phrase_actions.append(phrase_action)
			elif 60 < global.current_cycle.cycle_time:
				phrase_action = PhraseAction.new()
				phrase_action.text = "Feels like we've got all the time in the world!"
				phrase_actions.append(phrase_action)
				phrase_action = PhraseAction.new()
				phrase_action.text = "Stay awhile, and listen!"
				phrase_actions.append(phrase_action)
			
			if global.currency < 10:
				phrase_action = PhraseAction.new()
				phrase_action.text = "Best of luck on the balloon hunt!"
				phrase_actions.append(phrase_action)
			elif 30 < global.currency:
				phrase_action = PhraseAction.new()
				phrase_action.text = "Woah, high roller coming through!"
				phrase_actions.append(phrase_action)
			
			if global.pickups_acquired.size() <= 1:
				phrase_action = PhraseAction.new()
				phrase_action.text = "Keep an eye out for hourglasses, they'll permanently increase the party timer."
				phrase_actions.append(phrase_action)
			elif 4 < global.pickups_acquired.size():
				phrase_action = PhraseAction.new()
				phrase_action.text = "Nice hourglass collection!"
				phrase_actions.append(phrase_action)
			
			if global.piggybank_pickups_acquired.size() <= 1:
				phrase_action = PhraseAction.new()
				phrase_action.text = "I hear there's some piggy banks full of cash floating around."
				phrase_actions.append(phrase_action)
			elif 4 < global.piggybank_pickups_acquired.size():
				phrase_action = PhraseAction.new()
				phrase_action.text = "Wow, really brought home the bacon, huh? Nice work!"
				phrase_actions.append(phrase_action)
			
			if global.items_purchased.size() <= 2:
				phrase_action = PhraseAction.new()
				phrase_action.text = "It's still a nice party, even without a ton of decorations."
				phrase_actions.append(phrase_action)
			elif 4 <= global.items_purchased.size():
				phrase_action = PhraseAction.new()
				var thing = global.pick_random_from_list(global.items_purchased)
				if thing == "music":
					thing = "speakers"
				phrase_action.text = "I really dig the %s, where'd you get them?" % thing
				phrase_actions.append(phrase_action)
				phrase_action = PhraseAction.new()
				phrase_action.text = "You really went all out with decorations! This is great."
				phrase_actions.append(phrase_action)
			
			if global.invited_npcs.size() <= 2:
				phrase_action = PhraseAction.new()
				phrase_action.text = "Hey, do you mind if I call some friends?"
				phrase_actions.append(phrase_action)
			elif 6 <= global.invited_npcs.size():
				phrase_action = PhraseAction.new()
				phrase_action.text = "Nice and crowded, just like all good parties!"
				phrase_actions.append(phrase_action)
			
			if 60 < global.discussion_timers[npc_id]:
				phrase_action = PhraseAction.new()
				phrase_action.priority = 11
				phrase_action.text = "Been a while! How are things?"
				phrase_actions.append(phrase_action)
			
			
#			phrase_action = PhraseAction.new()
#			phrase_action.priority = 9
#			phrase_action.text = "%.1f on chip-in timer" % global.chip_in_timers[npc_id]
#			phrase_actions.append(phrase_action)
			
			
			
			
			
		else:
			# bought their like but haven't invited yet
			var phrase_action = PhraseAction.new()
			phrase_action.text = "You've got %s? That's my favorite! I'm there!" % like
			phrase_action.callback_name = "do_invite"
			phrase_action.priority = 100
			phrase_actions.append(phrase_action)
	else:
		# haven't bought their like
		var phrase_action = PhraseAction.new()
		phrase_action.text = "I'll come to the party once you buy some %s." % like
		phrase_action.priority = 100
		phrase_actions.append(phrase_action)
	
	var top_priority = -INF
	for pa in phrase_actions:
		if top_priority < pa.priority:
			top_priority = pa.priority
	
	var top_priority_pas = []
	for pa in phrase_actions:
		if pa.priority == top_priority:
			top_priority_pas.append(pa)
	
	var phrase_action = global.pick_random_from_list(top_priority_pas)
	if phrase_action.callback_name != null:
		call_deferred(phrase_action.callback_name)
	
	global.discussion_timers[npc_id] = 0
	
	return phrase_action.text

func do_invite():
	if npc_id in global.invited_npcs:
		print("what, npc already invited????")
	else:
		global.invited_npcs.append(npc_id)
		teleported = true
		get_tree().call_group("generic_npcs", "fancy_update")
		$sprite_animation_player.play("teleport")
		$teleport_timer.start()

func chip_in():
	global.chip_in_timers[npc_id] = 120
	for _i in range(5):
		var coin = coin_scene.instance()
		$coin_spawn_position.add_child(coin)
		coin.apply_central_impulse(Vector2.UP.rotated(rand_range(-PI, PI)) * 100)

func increment_celebration_musings():
	celebration_musings += 1













