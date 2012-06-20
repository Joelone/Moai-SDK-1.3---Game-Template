-- INITIALISATION --
function init()

	screen_width=MOAIEnvironment.screenWidth
	screen_height=MOAIEnvironment.screenHeight

	adirectory=MOAIEnvironment.documentDirectory
	osbrand=MOAIEnvironment.osBrand

	if osbrand==nil then osbrand='None' end

	print ("osbrand="..osbrand)

	if screen_width==nil then screen_width=800 end
	if screen_height==nil then screen_height=480 end

	if adirectory==nil then
		assetdirectory=''
	end
	if adirectory~=nil then
		assetdirectory=adirectory..'/'
	end

	--[[
	screen_width=800
	screen_height=480
	--]]


	MOAISim.openWindow ( "test", screen_width, screen_height )

	local color = MOAIColor.new()
	color:setColor(21/255, 214/255, 249/255, 1)
	MOAIGfxDevice.setClearColor(color)

	--[[
	MOAISim.setStep ( 1 / 60 )
	MOAISim.clearLoopFlags ()
	MOAISim.setLoopFlags ( MOAISim.LOOP_FLAGS_FIXED )
	MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_ALLOW_BOOST )
	MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_LONG_DELAY )
	MOAISim.setBoostThreshold ( 0 )
	--]]

	--]]

	-- setup all layers
	layer_back = MOAILayer2D.new ()
	layer_med=MOAILayer2D.new ()
	layer_close=MOAILayer2D.new ()
	layer= MOAILayer2D.new ()
	layer_particles= MOAILayer2D.new ()
	layer_menu=MOAILayer2D.new()
	layer_hud = MOAILayer2D.new ()
	layer_splash = MOAILayer2D.new ()
	alert_layer = MOAILayer2D.new ()

	MOAISim.pushRenderPass ( layer_back )
	MOAISim.pushRenderPass ( layer_med )
	MOAISim.pushRenderPass ( layer_close )
	MOAISim.pushRenderPass ( layer )
	MOAISim.pushRenderPass ( layer_hud )
	MOAISim.pushRenderPass ( alert_layer )
	MOAISim.pushRenderPass ( layer_menu )
	MOAISim.pushRenderPass ( layer_particles )
	MOAISim.pushRenderPass ( layer_splash )

	camera=MOAICamera.new ()

	partition_menu = MOAIPartition.new ()
	layer_menu:setPartition ( partition_menu)

	viewport = MOAIViewport.new ()
	viewport:setSize ( screen_width,screen_height )
	scale=16
	viewport:setScale ( scale,0)

	viewport2 = MOAIViewport.new ()
	viewport2:setSize ( screen_width,screen_height )
	viewport2:setScale ( screen_width,screen_height)

	--[[
	if (osbrand=='iOS') then
		viewport:setRotation(90)
		viewport2:setRotation(90)
		o_screen_width=screen_width
		o_screen_height=screen_height
		screen_width=screen_height
		screen_height=o_screen_width
	end
	--]]



	--print("sh="..screen_height)

	layer_back:setViewport ( viewport )
	layer_med:setViewport ( viewport )
	layer_close:setViewport ( viewport )
	layer_particles:setViewport ( viewport )
	layer:setViewport ( viewport )
	layer_splash:setViewport ( viewport )
	layer_hud:setViewport ( viewport2 )
	alert_layer:setViewport ( viewport2 )

	--INIT GLOBAL VARIABLES
	debug=true -- turn debug draw on/off

	partition = MOAIPartition.new ()
	layer_hud:setPartition ( partition )

	actor_fixtures = {}
	actor_bodies = {}
	actor_joints = {}
	actor_sprites = {}

	mousedown=false
	gridon=true
	destroyed=0
	c=0
	mainplayer=0
	mainxoffset=0

	width=0.1
	maximumwidth=2
	game_width=40
	boundaryright=game_width
	boundaryleft=game_width*-1
	boundarytop=screen_height*2/scale
	boundarybottom=screen_height*-1/scale
	boundarybottom=-10
	camerapropy=-5

	popscorebox = {}
	popscorebox_counter=0


	usecamerabody=false
	zoomscale=10
	maxzoomscale=40
	minzoomscale=5

	treasure=0
	treasurex=0
	treasurey=0
	tick=0
	myx=0
	myy=0
	lastpicked=0
	eventcount=1
	camerax_target=0
	cameray_target=0
	mode=0
	score=0
	lastX=0
	lastY=0
	oldX=0
	oldY=0
	oldmouseX=0
	oldmouseY=0
	mouseX=0
	mouseY=0
	xFling=0
	yFling=0
	mouseXdown=0
	mouseYdown=0
	xDown=0
	yDown=0
	xLast=0
	yLast=0
	xMove=0
	yMove=0
	xUp=0
	yUp=0
	start_width=0
	start_height=0
	x=0
	y=0
	pinching=false
	pointer1x=0
	pointer2x=0
	pointer1y=0
	pointer2y=0
	soundon=false
	timerDown=0
	trackplayer=false
	mouseuptimer=0
	mousedowntimer=0
end

function loadresources()
	--LOAD GLOBAL RESOURCES



	logoGfx = MOAIGfxQuad2D.new ()
	logoGfx:setTexture ( assetdirectory.."map.png" )
	logoGfx:setRect ( -8,-5,8,5)
	map = MOAIProp2D.new ()
	map:setDeck ( logoGfx )

	update_loading(1)

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."arrow.png" )
	gfxQuad:setRect ( -1,-1,1,1 )

	arrow = MOAIProp2D.new ()
	arrow:setDeck ( gfxQuad )
	arrow.name = "arrow"

	update_loading(5)

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button4.png" )
	gfxQuad:setRect ( -1,-1,1,1 )

	button_close = MOAIProp2D.new ()
	button_close:setDeck ( gfxQuad )
	button_close.name = "button_close"

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button2.png" )
	gfxQuad:setRect ( -1,-1,1,1 )

	button_start = MOAIProp2D.new ()
	button_start:setDeck ( gfxQuad )
	button_start.name = "button_start"

	gfxQuad = MOAITileDeck2D.new ()
	gfxQuad:setTexture ( assetdirectory.."sound.png" )
	gfxQuad:setRect ( -1,-1,1,1)
	gfxQuad:setSize ( 2,1 )
	button_sound = MOAIProp2D.new ()
	button_sound:setDeck ( gfxQuad )
	button_sound.name = "button_sound"

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button5.png" )
	gfxQuad:setRect ( -1,-1,1,1 )
	button_level_exit = MOAIProp2D.new ()
	button_level_exit:setDeck ( gfxQuad )
	button_level_exit.name = "button_level_exit"

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button6.png" )
	gfxQuad:setRect ( -1,-1,1,1 )
	button_level = MOAIProp2D.new ()
	button_level:setDeck ( gfxQuad )
	button_level.name = "button_level"

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button6.png" )
	gfxQuad:setRect ( -1,-1,1,1 )
	button_level2 = MOAIProp2D.new ()
	button_level2:setDeck ( gfxQuad )
	button_level2.name = "button_level2"

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button9.png" )
	gfxQuad:setRect ( -32,-32,32,32)
	button_game_exit = MOAIProp2D.new ()
	button_game_exit:setDeck ( gfxQuad )
	button_game_exit.name = "button_game_exit"

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button2.png" )
	gfxQuad:setRect ( -32,-32,32,32)
	button_game_jump= MOAIProp2D.new ()
	button_game_jump:setDeck ( gfxQuad )
	button_game_jump.name = "button_game_jump"


	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button3.png" )
	gfxQuad:setRect ( -32,-32,32,32)
	button_game_right= MOAIProp2D.new ()
	button_game_right:setDeck ( gfxQuad )
	button_game_right.name = "button_game_right"


	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."button4.png" )
	gfxQuad:setRect ( -32,-32,32,32)
	button_game_left= MOAIProp2D.new ()
	button_game_left:setDeck ( gfxQuad )
	button_game_left.name = "button_game_left"

	--
	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."background_far.png" )
	gfxQuad:setRect ( -35,-10,35,10)
	sprite_background_far = MOAIProp2D.new ()
	sprite_background_far:setDeck ( gfxQuad )

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."background_med.png" )
	gfxQuad:setRect ( -5,-5,5,5)
	sprite_background_med = MOAIProp2D.new ()
	sprite_background_med:setDeck ( gfxQuad )

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."background_med.png" )
	gfxQuad:setRect ( -5,-5,5,5)
	sprite_background_med1 = MOAIProp2D.new ()
	sprite_background_med1:setDeck ( gfxQuad )

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."background_med.png" )
	gfxQuad:setRect ( -5,-5,5,5)
	sprite_background_med2 = MOAIProp2D.new ()
	sprite_background_med2:setDeck ( gfxQuad )

	gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( assetdirectory.."background_close.png" )
	gfxQuad:setRect ( -20,-7.5,20,7.5)
	sprite_background_close = MOAIProp2D.new ()
	sprite_background_close:setDeck ( gfxQuad )
	--]]

	update_loading(50)

	-- Particles

	particletexture1 = MOAIGfxQuad2D.new ()
	particletexture1:setTexture ( assetdirectory..'particle1.png' )
	particletexture1:setRect ( -0.8, -0.8, 0.8, 0.8)

	particletexture2= MOAIGfxQuad2D.new ()
	particletexture2:setTexture ( assetdirectory..'particle2.png' )
	particletexture2:setRect ( -1,-1,1,1)

	particletexture3= MOAIGfxQuad2D.new ()
	particletexture3:setTexture ( assetdirectory..'particle3.png' )
	particletexture3:setRect ( -1,-1,1,1)

	particletexture4= MOAIGfxQuad2D.new ()
	particletexture4:setTexture ( assetdirectory..'particle4.png' )
	particletexture4:setRect ( -1,-1,1,1)

	particletexture5 = MOAIGfxQuad2D.new ()
	particletexture5:setTexture ( assetdirectory..'particle5.png' )
	particletexture5:setRect ( -0.8, -0.8, 0.8, 0.8)

	smokeparticletexture1 = MOAIGfxQuad2D.new ()
	smokeparticletexture1:setTexture ( assetdirectory..'smokeparticle1.png' )
	smokeparticletexture1:setRect ( -0.8, -0.8, 0.8, 0.8)

	smokeparticletexture2 = MOAIGfxQuad2D.new ()
	smokeparticletexture2:setTexture ( assetdirectory..'smokeparticle2.png' )
	smokeparticletexture2:setRect ( -0.8, -0.8, 0.8, 0.8)

	smokeparticletexture3 = MOAIGfxQuad2D.new ()
	smokeparticletexture3:setTexture ( assetdirectory..'smokeparticle3.png' )
	smokeparticletexture3:setRect ( -0.8, -0.8, 0.8, 0.8)

	smokeparticletexture4 = MOAIGfxQuad2D.new ()
	smokeparticletexture4:setTexture ( assetdirectory..'smokeparticle4.png' )
	smokeparticletexture4:setRect ( -0.8, -0.8, 0.8, 0.8)

	confettitexture1 = MOAIGfxQuad2D.new ()
	confettitexture1:setTexture ( assetdirectory..'particle1.png' )
	confettitexture1:setRect ( -0.8, -0.8, 0.8, 0.8)

	loadingbar = MOAIGfxQuad2D.new ()
	loadingbar:setTexture ( assetdirectory.."loading.png" )

	loadingbar:setUVRect ( 0, 0, 1, 1 )
	loading = MOAIProp2D.new ()
	loading:setDeck ( loadingbar )

	loadingbar:setRect ( 0,-0.5,width,0.5 )

	-- Text boxes
	charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'

	font = MOAIFont.new ()
	font:loadFromTTF ( assetdirectory..'arial.TTF', charcodes, 10, 163 )

	font2 = MOAIFont.new ()
	font2:loadFromTTF ( assetdirectory..'arial.TTF', charcodes, 8, 163 )

	bigfont = MOAIFont.new ()
	bigfont:loadFromTTF ( assetdirectory..'arial.TTF', charcodes, 20, 163 )


	scorebox_shadow = MOAITextBox.new ()
	scorebox = MOAITextBox.new ()



	--[[
	MOAIUntzSystem.initialize ()
	sound1 = MOAIUntzSound.new ()
	sound1:load ( assetdirectory..'pop.wav' )
	sound1:setVolume ( 1 )
	sound1:setLooping ( false )

	sound2 = MOAIUntzSound.new ()
	sound2:load ( assetdirectory..'bounce.wav' )
	sound2:setVolume ( 1 )
	sound2:setLooping ( false )

	sound3 = MOAIUntzSound.new ()
	sound3:load ( assetdirectory..'explosion.wav' )
	sound3:setVolume ( 1 )
	sound3:setLooping ( false )

	sound4 = MOAIUntzSound.new ()
	sound4:load ( assetdirectory..'woosh.wav' )
	sound4:setVolume ( 1 )
	sound4:setLooping ( false )

	sound5 = MOAIUntzSound.new ()
	sound5:load ( assetdirectory..'boing.wav' )
	sound5:setVolume ( 1 )
	sound5:setLooping ( false )

	--]]

	-- backgrounds

	update_loading(100)
	callWithDelay ( 1, fadeoutSplash)
end

-- USEFUL FUNCTIONS --
function onLevelEvent ( x, y, z )
	--print ("level change "..x)
	viewport:setRotation(0)
	viewport2:setRotation(0)
	if y>0 then viewport:setRotation(180) end
	if y>-0.75 and y<0.75 then
		viewport:setRotation(90)
		viewport2:setRotation(90)
		if x>0 then viewport:setRotation(-90) end
	end
end

function setupRotationSensor()
	if MOAIInputMgr.device.level then

		--MOAIInputMgr.device.level:setCallback ( onLevelEvent )

	end

end


function callWithDelay ( delay, func,...)
	local timer = MOAITimer.new ()
	timer:setSpan ( delay )
	timer:setListener ( MOAITimer.EVENT_TIMER_LOOP,
	function ()
		timer:stop ()
		timer = nil
		func ( unpack ( arg ))
	end
	)
	timer:start ()
end

-- SPLASH --
function fadeinSplash()
	layer_splash:setViewport ( viewport )

	logoGfx = MOAIGfxQuad2D.new ()
	logoGfx:setTexture ( assetdirectory.."splash.jpg" )
	logoGfx:setRect ( -8,-5,8,5)
	logo = MOAIProp2D.new ()
	logo:setDeck ( logoGfx )

	layer_splash:insertProp ( logo )
	--logo:seekColor ( 0,0,0,0,0)

	--loading bar

	percent=1
	timer=0
	layer_splash:insertProp ( loading )

	--fadeinAction = logo:seekColor ( 1, 1, 1, 1, 2)
	--[[
	stab = MOAIUntzSound.new ()
	stab:load (  assetdirectory..'stab.wav' )
	stab:setVolume ( 1 )
	stab:setLooping ( false )
	stab:play ()
	--]]
	--callWithDelay ( 2, fadeoutSplash)
end

function fadeoutSplash()
	loading:seekColor ( 0,0,0,0, 3 )
	fadeoutAction = logo:seekColor ( 0,0,0,0, 3 )
	callWithDelay ( 2, game_menu)
end

-- GAME MENU --
function pointerCallback_game_menu( x, y )
	mouseX, mouseY = layer_menu:wndToWorld ( x, y )
end

function clickCallback_game_menu ( down )
	if down then
		pick = partition_menu:propForPoint ( mouseX, mouseY )
		if pick then
			if pick.name=="button_start" then
				layer_menu:clear()
				world_menu()
			end
			if pick.name=="button_sound" then
				index=button_sound:getIndex()
				if index==1 then index=2
				soundon=false
				----print "soundon=false"
			elseif
				index==2 then index=1
				soundon=true
				----print "soundon=true"
			end
			button_sound:setIndex(index)
		end
	end
end

if down==false then

end
end

function game_menu()
layer_menu:clear()
layer_splash:clear()
partition_menu:insertProp ( button_start )
layer_menu:insertProp ( button_start )
button_start:setLoc(-4,0)

partition_menu:insertProp (button_sound )
layer_menu:insertProp ( button_sound )
button_sound:setLoc(4,0)

if soundon~=true then
	button_sound:setIndex(2)
end
MOAISim.pushRenderPass ( layer_menu )

layer_menu:setViewport ( viewport )
if MOAIInputMgr.device.pointer then
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback_game_menu )
	MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback_game_menu )
else
	-- touch input
	MOAIInputMgr.device.touch:setCallback (
	function ( eventType, idx, x, y, tapCount )
		----print ("Touch event="..eventType)
		pointerCallback_game_menu ( x, y )
		if eventType == MOAITouchSensor.TOUCH_DOWN then
			clickCallback_game_menu ( true )
		elseif eventType == MOAITouchSensor.TOUCH_UP then
			clickCallback_game_menu ( false )
		end
	end
	)
end
end

-- WORLD MENU --
function pointerCallback_world_menu( x, y )
mouseX, mouseY = layer_menu:wndToWorld ( x, y )
end

function clickCallback_world_menu ( down )
if down then
	pick = partition_menu:propForPoint ( mouseX, mouseY )
	if pick then

		if pick.name=="button_level_exit" then
			layer_menu:clear()
			game_menu()
		end

		if pick.name=="button_level" then
			layer_menu:clear()
			start_level(1)
		end
		if pick.name=="button_level2" then
			layer_menu:clear()
			start_level(2)
		end
	end
end

if down==false then

end
end

function world_menu()
layer_menu:clear()

layer_menu:insertProp ( map )

partition_menu:insertProp ( button_level_exit )
layer_menu:insertProp ( button_level_exit )
button_level_exit:setLoc(-6,0)

partition_menu:insertProp ( button_level )
layer_menu:insertProp ( button_level )
button_level:setLoc(3,-3)

partition_menu:insertProp ( button_level2 )
layer_menu:insertProp ( button_level2)
button_level2:setLoc(0,2)

MOAISim.pushRenderPass ( layer_menu )

layer_menu:setViewport ( viewport )
if MOAIInputMgr.device.pointer then
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback_world_menu )
	MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback_world_menu )
else
	-- touch input
	MOAIInputMgr.device.touch:setCallback (
	function ( eventType, idx, x, y, tapCount )
		----print ("Touch event="..eventType)
		pointerCallback_world_menu ( x, y )
		if eventType == MOAITouchSensor.TOUCH_DOWN then
			clickCallback_world_menu ( true )
		elseif eventType == MOAITouchSensor.TOUCH_UP then
			clickCallback_world_menu ( false )
		end
	end
	)
end
end

-- LEVEL MENU --

-- GAME --

function update_loading(percent)
--width=maximumwidth*percent/100 -- 50% done
--loadingbar:setRect ( 0,-0.1,width,0.1 )
end

Dialog = {}

function closeDialog()
myDialog:close()
end
function Dialog:new(o)

o = o or {
	buttonnumber=4,
	description="Description of the dialog box",
	text="Level Complete?",
	button1text="Button 1",
	button1img=assetdirectory.."button1.png",
	button2text="Button 2",
	button2img=assetdirectory.."button2.png",
	button3text="Button 3",
	button3img=assetdirectory.."button3.png",
	button4text="Button 4",
	button4img=assetdirectory.."button4.png",
	startx=0-1.5*(64+8),
	starty=-128,
	width=64+8
}

setmetatable(o, self)
self.__index = self
return o
end

function Dialog:close()

alert_layer:clear()
alert_layer=nil
end

function Dialog:show()


alert_partition = MOAIPartition.new ()
alert_layer:setPartition ( alert_partition )

prop = MOAIProp2D.new ()
gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( assetdirectory.."menubackground.png")
gfxQuad:setRect ( -220,-220,220,220)
prop:setDeck ( gfxQuad )
alert_layer:insertProp ( prop )


if self.buttonnumber>0 then
	self:addButton ( self.startx+self.width*0,self.starty, 1,1, self.button1text,self.button1img)
end
if self.buttonnumber>1 then
	self:addButton ( self.startx+self.width*1,self.starty, 1,1, self.button2text,self.button2img )
end
if self.buttonnumber>2 then
	self:addButton ( self.startx+self.width*2,self.starty, 1,1, self.button3text,self.button3img )
end
if self.buttonnumber>3 then
	self:addButton ( self.startx+self.width*3,self.starty, 1,1, self.button4text,self.button4img )
end

-- add title and description
self:addText(self.text,self.description)
-- add close button in right hand corner
prop = MOAIProp2D.new ()
gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( assetdirectory.."button5.png" )
gfxQuad:setRect ( -32,-32,32,32)
prop:setDeck ( gfxQuad )
prop:setPriority ( 5 )
prop:setLoc ( 220-16,220-16 )
prop:setScl ( 1,1 )
prop.name = "dialog_close"
alert_partition:insertProp ( prop )
alert_layer:seekLoc(0,0,0,2)
--alert_layer:seekColor ( 1,1,1,1, 2 )
--
if MOAIInputMgr.device.pointer then


	-- mouse input
	MOAIInputMgr.device.pointer:setCallback (
	function (x,y)
		self:pointerCallback(x,y)
	end
	)

	MOAIInputMgr.device.mouseLeft:setCallback (
	function (eventType)
		self:clickCallback(eventType)
	end
	)
else

	-- touch input
	MOAIInputMgr.device.touch:setCallback (

	function ( eventType, idx, x, y, tapCount )

		self:pointerCallback ( x, y )

		if eventType == MOAITouchSensor.TOUCH_DOWN then
			self:clickCallback ( true )
		elseif eventType == MOAITouchSensor.TOUCH_UP then
			self:clickCallback ( false )
		end
	end
	)
end
--]]
end

function Dialog:addText(text,description)
charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'

textbox = MOAITextBox.new ()
textbox:setString ( text)
textbox:setFont ( font )
--textbox:setTextSize ( font:getScale ())
textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY)
textbox:setRect ( -100,-100,100,100 )
textbox:setLoc(0,0)
textbox:setYFlip ( true )
alert_layer:insertProp ( textbox )

--textbox:seekColor ( 0,0,0,0,0)
--textbox:seekColor ( 1, 1, 1, 1, 1)

textbox2 = MOAITextBox.new ()
textbox2:setString ( description)
textbox2:setFont ( font2 )
--textbox:setTextSize ( font:getScale ())
textbox2:setAlignment(MOAITextBox.CENTER_JUSTIFY)
textbox2:setRect ( -130,-100,130,100 )
textbox2:setLoc(0,-64)
textbox2:setYFlip ( true )
alert_layer:insertProp ( textbox2 )
--textbox2:seekColor ( 0,0,0,0,0)
--textbox2:seekColor ( 1, 1, 1, 1, 1)

end
function Dialog:addButton( x, y, xScl, yScl, name, texture )
local prop = MOAIProp2D.new ()
gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( texture )
gfxQuad:setRect ( -32,-32,32,32 )
prop:setDeck ( gfxQuad )
prop:setPriority ( 5 )
prop:setLoc ( x, y )
prop:setScl ( xScl, yScl )
prop.name = name
alert_partition:insertProp ( prop )
--prop:seekColor ( 0,0,0,0,0)
--prop:seekColor ( 1, 1, 1, 1, 1)
end

function Dialog:pointerCallback( x, y )

local oldX = mouseX
local oldY = mouseY
mouseX, mouseY = alert_layer:wndToWorld ( x, y )
end

function Dialog:clickCallback( down )

if down then
	pick = alert_partition:propForPoint ( mouseX, mouseY )

	if pick then
		--print ( pick.name )
		if pick.name=="Button 1" then
			-- exit to main menu
			alert_layer:clear()
			layer:clear()
			layer_hud:clear()
			layer_back:clear()
			layer_med:clear()
			layer_close:clear()
			layer_particles:clear()
			layer:setBox2DWorld(nil)
			world=nil
			world_menu()
		end

		if pick.name=="Button 2" then


		end

		if pick.name=="Button 3" then

		end

		if pick.name=="Button 4" then

		end

		if pick.name=="dialog_close" then
			--[[
			local action=alert_layer:seekLoc ( -900,0,0,2 )

			action:setListener ( MOAIAction.EVENT_STOP,
			function ()
				alert_layer:clear()
				point_to_game()
			end
			)
			--]]
			alert_layer:clear()
			point_to_game()
		end
	end
else
	if pick then
		pick = nil
	end
end
end


function drawHills(hillStartX,hillStartY,numberOfHills,pixelStep,hillOffsetY,hillheight)
bottom=-10
-- defining hill width, in pixels, that is the stage width divided by the number of hills
hillWidth=(screen_width*2/numberOfHills)
-- defining the number of slices of the hill. This number is determined by the width of the hill in pixels divided by the amount of pixels between two points
hillSlices=hillWidth/pixelStep
hillSliceWidth=(hillWidth/pixelStep)+1

-- looping through the hills
for i=0,numberOfHills,1 do
	-- setting a random hill height in pixels
	randomHeight=math.random()*hillheight
	-- this is necessary to make all hills (execept the first one) begin where the previous hill ended
	if(i~=0) then hillStartY=hillStartY-randomHeight end

	-- looping through hill slices
	for j=0,hillSlices,1 do

		bodytest = world:addBody ( MOAIBox2DBody.STATIC )
		-- defining the point of the hill
		x=j*pixelStep+hillWidth*i
		y=hillStartY+randomHeight*math.cos(2*math.pi/hillSlices*j)+hillOffsetY

		point4x=(j*pixelStep+hillWidth*i)/32+hillStartX
		point4y=bottom

		point3x=(j*pixelStep+hillWidth*i)/32+hillStartX
		point3y=((hillStartY+randomHeight*math.cos(2*math.pi/hillSliceWidth*j))/32)+hillOffsetY


		point2x=((j+1)*pixelStep+hillWidth*i)/32+hillStartX
		point2y=(hillStartY+randomHeight*math.cos(2*math.pi/hillSliceWidth*(j+1)))/32+hillOffsetY

		point1x=((j+1)*pixelStep+hillWidth*i)/32+hillStartX
		point1y=bottom

		--print ("point1x="..point1x.." point1y="..point1y.." point2x="..point2x.." point2y="..point2y)
		--print ("point3x="..point3x.." point3y="..point3y.." point4x="..point4x.." point4y="..point4y)
		t = { point1x,point1y,point2x,point2y,point3x,point3y,point4x,point4y }
		bodytest:addPolygon (t)

		--add_actor(x,y,pixelStep/32,pixelStep/32,0.5,0.5,0.5,"Box","Static","images/cloud.png")
	end
	-- this is also necessary to make all hills (execept the first one) begin where the previous hill ended
	hillStartY = hillStartY+randomHeight
end
end


function add_arrow(x,y,seconds)
layer:insertProp ( arrow )
arrow:setLoc(x,y)


curve1 = MOAIAnimCurve.new ()
curve1:reserveKeys ( 2 )
curve1:setKey ( 1, 0, 0 )
curve1:setKey ( 2, 1, -1 )

anim = MOAIAnim.new ()
anim:reserveLinks ( 1 )
anim:setLink ( 1, curve1, arrow, MOAIProp2D.ATTR_Y_LOC )

anim:setMode ( MOAITimer.PING_PONG )
anim:start ()

end

--particle effects
function smoke(mouseX,mouseY,Deck,sizex,sizey)

size=math.sqrt(sizex*sizey)

----print ("SMOKE!")
------------------------------
-- Particle scripts
------------------------------

-- pack registers for scripts
reg1 = MOAIParticleScript.packReg ( 1 )
reg2 = MOAIParticleScript.packReg ( 2 )
reg3 = MOAIParticleScript.packReg ( 3 )
reg4 = MOAIParticleScript.packReg ( 4 )
reg5 = MOAIParticleScript.packReg ( 5 )
CONST = MOAIParticleScript.packConst

----------
--init script
----------

sparkInitScript = MOAIParticleScript.new ()
-- this takes the registers you created above and turns them into random number generators
-- returning values between the last two parameters
sparkInitScript:randVec ( reg1, reg2, CONST(1), CONST(size) )
sparkInitScript:rand ( reg3, CONST(-90), CONST(90) )
sparkInitScript:rand ( reg4, CONST(0.5), CONST(3.0) )
sparkInitScript:rand ( reg5, CONST(0), CONST(255) )

----------
-- render script
----------
sparkRenderScript = MOAIParticleScript.new ()
--this makes the sprite appear
sparkRenderScript:sprite ()

-- this controls the amount your particle cloud will spread out over the x axis
-- and how fast / smooth it spreads. Note it is getting a random value from
-- one of the script registers
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_X, CONST(0), reg1, MOAIEaseType.SHARP_EASE_IN )
-- this does the same over the y axis
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_Y, CONST(0), reg2, MOAIEaseType.SHARP_EASE_IN )

-- resize
sparkRenderScript:ease		( MOAIParticleScript.SPRITE_X_SCL, CONST(0.5), CONST(size*2),MOAIEaseType.EASE_IN)
sparkRenderScript:ease		( MOAIParticleScript.SPRITE_Y_SCL, CONST(0.5), CONST(size*2),MOAIEaseType.EASE_IN)

-- creates sparkling color
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_RED, reg5 )
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_BLUE, reg3 )
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_GREEN, reg3 )

-- this sets a random starting rotation for each particle
sparkRenderScript:set ( MOAIParticleScript.SPRITE_ROT, reg3 )

-- this applies a random amount of rotation to each particle during its lifetime
--sparkRenderScript:ease ( MOAIParticleScript.SPRITE_ROT, CONST(0), reg3, MOAIEaseType.LINEAR )
--sparkRenderScript:ease			    ( MOAIParticleScript.SPRITE_ROT, CONST ( 0), CONST ( 360),MOAIEaseType.LINEAR)

-- this makes the particle fade out near the end of its lifetime
sparkRenderScript:ease ( MOAIParticleScript.SPRITE_OPACITY, CONST(1), CONST(0), MOAIEaseType.LINEAR )


-- this makes each particle randomly bigger or smaller than the original size
--sparkRenderScript:set	( MOAIParticleScript.SPRITE_X_SCL, reg4 )
--sparkRenderScript:set	( MOAIParticleScript.SPRITE_Y_SCL, reg4 )
------------------------------
-- Particle system
------------------------------

sparkSystem = MOAIParticleSystem.new ()
-- max num of particles, size of each
sparkSystem:reserveParticles ( 64, 10 )
-- max num of sprites
sparkSystem:reserveSprites ( 64 )
sparkSystem:reserveStates ( 1 )
-- deck can be set like a prop

--Deck= MOAIGfxQuad2D.new ()
--Deck:setTexture ( assetdirectory..image_src)
--Deck:setRect ( -1,-1,1,1)




sparkSystem:setDeck ( Deck )
sparkSystem:start ()
-- particle system can be inserted like a prop
layer_particles:insertProp ( sparkSystem )

------------------------------
-- Particle forces

------------------------------
gravity = MOAIParticleForce.new ()
gravity:initLinear ( 0, -10)
gravity:setType( MOAIParticleForce.FORCE )

radial = MOAIParticleForce.new ()
--radial:initLinear ( 100 )
radial:setType( MOAIParticleForce.FORCE )

------------------------------
-- Particle state
------------------------------
-- a state holds a particle cloud's lifetime, physics properties
-- and which scripts govern its behavior

sparkState = MOAIParticleState.new ()

-- particle lifetime, random between the two values in seconds
sparkState:setTerm ( 3,3 )
sparkState:setInitScript ( sparkInitScript )
sparkState:setRenderScript ( sparkRenderScript )
--sparkState:pushForce (radial)
--sparkState:pushForce (gravity)

-- sets the system to this state
sparkSystem:setState ( 1, sparkState )
sparkSystem:surge(8, mouseX, mouseY, 0, 0)
end

function explode(mouseX,mouseY,Deck,sizex,sizey)

sizex=sizex
sizey=sizey
------------------------------
-- Particle scripts
------------------------------

-- pack registers for scripts
reg1 = MOAIParticleScript.packReg ( 1 )
reg2 = MOAIParticleScript.packReg ( 2 )
reg3 = MOAIParticleScript.packReg ( 3 )
reg4 = MOAIParticleScript.packReg ( 4 )
reg5 = MOAIParticleScript.packReg ( 5 )
CONST = MOAIParticleScript.packConst

----------
--init script
----------

sparkInitScript = MOAIParticleScript.new ()
-- this takes the registers you created above and turns them into random number generators
-- returning values between the last two parameters
sparkInitScript:randVec ( reg1, reg2, CONST(5), CONST(sizex) )
sparkInitScript:rand ( reg3, CONST(-90), CONST(90) )
sparkInitScript:rand ( reg4, CONST(0.5), CONST(3.0) )
sparkInitScript:rand ( reg5, CONST(0), CONST(255) )

----------
-- render script
----------
sparkRenderScript = MOAIParticleScript.new ()
--this makes the sprite appear
sparkRenderScript:sprite ()

-- this controls the amount your particle cloud will spread out over the x axis
-- and how fast / smooth it spreads. Note it is getting a random value from
-- one of the script registers
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_X, CONST(0), reg1, MOAIEaseType.SHARP_EASE_IN )
-- this does the same over the y axis
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_Y, CONST(0), reg2, MOAIEaseType.SHARP_EASE_IN )

-- resize
sparkRenderScript:ease		( MOAIParticleScript.SPRITE_X_SCL, CONST(sizex/4), CONST(0.1),MOAIEaseType.EASE_IN)
sparkRenderScript:ease		( MOAIParticleScript.SPRITE_Y_SCL, CONST(sizey/4), CONST(0.1),MOAIEaseType.EASE_IN)

-- creates sparkling color
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_RED, reg5 )
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_BLUE, reg3 )
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_GREEN, reg3 )

-- this sets a random starting rotation for each particle
sparkRenderScript:set ( MOAIParticleScript.SPRITE_ROT, reg3 )

-- this applies a random amount of rotation to each particle during its lifetime
--sparkRenderScript:ease ( MOAIParticleScript.SPRITE_ROT, CONST(0), reg3, MOAIEaseType.LINEAR )
--sparkRenderScript:ease			    ( MOAIParticleScript.SPRITE_ROT, CONST ( 0), CONST ( 360),MOAIEaseType.LINEAR)

-- this makes the particle fade out near the end of its lifetime
sparkRenderScript:ease ( MOAIParticleScript.SPRITE_OPACITY, CONST(1), CONST(0), MOAIEaseType.LINEAR )


-- this makes each particle randomly bigger or smaller than the original size
--sparkRenderScript:set	( MOAIParticleScript.SPRITE_X_SCL, reg4 )
--sparkRenderScript:set	( MOAIParticleScript.SPRITE_Y_SCL, reg4 )
------------------------------
-- Particle system
------------------------------

sparkSystem = MOAIParticleSystem.new ()
-- max num of particles, size of each
sparkSystem:reserveParticles ( 64, 10 )
-- max num of sprites
sparkSystem:reserveSprites ( 64 )
sparkSystem:reserveStates ( 1 )
-- deck can be set like a prop

sparkSystem:setDeck ( Deck )
sparkSystem:start ()
-- particle system can be inserted like a prop
layer_particles:insertProp ( sparkSystem )

------------------------------
-- Particle forces

------------------------------
gravity = MOAIParticleForce.new ()
gravity:initLinear ( 0, -10 )
gravity:setType( MOAIParticleForce.FORCE )

radial = MOAIParticleForce.new ()
--radial:initLinear ( 100 )
radial:setType( MOAIParticleForce.FORCE )

------------------------------
-- Particle state
------------------------------
-- a state holds a particle cloud's lifetime, physics properties
-- and which scripts govern its behavior

sparkState = MOAIParticleState.new ()

-- particle lifetime, random between the two values in seconds
sparkState:setTerm ( 3,3 )
sparkState:setInitScript ( sparkInitScript )
sparkState:setRenderScript ( sparkRenderScript )
--sparkState:pushForce (radial)
sparkState:pushForce (gravity)

-- sets the system to this state
sparkSystem:setState ( 1, sparkState )
sparkSystem:surge(2, mouseX, mouseY, 0, 0)
end

function confetti(mouseX,mouseY,Deck,sizex,sizey)

if sizex>1 then sizex=1 end


------------------------------
-- Particle scripts
------------------------------

-- pack registers for scripts
reg1 = MOAIParticleScript.packReg ( 1 )
reg2 = MOAIParticleScript.packReg ( 2 )
reg3 = MOAIParticleScript.packReg ( 3 )
reg4 = MOAIParticleScript.packReg ( 4 )
reg5 = MOAIParticleScript.packReg ( 5 )
CONST = MOAIParticleScript.packConst

----------
--init script
----------

sparkInitScript = MOAIParticleScript.new ()
-- this takes the registers you created above and turns them into random number generators
-- returning values between the last two parameters

sparkInitScript:randVec ( reg1, reg2, CONST(1), CONST(20) )
sparkInitScript:rand ( reg3, CONST(-90), CONST(90) )
sparkInitScript:rand ( reg4, CONST(0.1), CONST(sizex) )
sparkInitScript:rand ( reg5, CONST(0), CONST(800) )
sparkInitScript:rand ( reg6, CONST(1.5), CONST(2.0) )
sparkInitScript:rand ( reg7, CONST(-90), CONST(90) )

----------
-- render script
----------
sparkRenderScript = MOAIParticleScript.new ()
--this makes the sprite appear
sparkRenderScript:sprite ()

-- this controls the amount your particle cloud will spread out over the x axis
-- and how fast / smooth it spreads. Note it is getting a random value from
-- one of the script registers
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_X, CONST(0), reg1, MOAIEaseType.SHARP_EASE_IN )
-- this does the same over the y axis
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_Y, CONST(0), reg2, MOAIEaseType.SHARP_EASE_IN )

-- resize
sparkRenderScript:ease		( MOAIParticleScript.SPRITE_X_SCL, reg4, reg6,MOAIEaseType.EASE_IN)
sparkRenderScript:ease		( MOAIParticleScript.SPRITE_Y_SCL, reg4, reg6,MOAIEaseType.EASE_IN)

-- creates sparkling color
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_RED, reg5 )
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_BLUE, reg3 )
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_GREEN, reg3 )

-- this sets a random starting rotation for each particle
sparkRenderScript:set ( MOAIParticleScript.SPRITE_ROT, reg3 )

-- this applies a random amount of rotation to each particle during its lifetime
sparkRenderScript:ease ( MOAIParticleScript.SPRITE_ROT, reg7, reg3, MOAIEaseType.LINEAR )
--sparkRenderScript:ease			    ( MOAIParticleScript.SPRITE_ROT, CONST ( 0), CONST ( 360),MOAIEaseType.LINEAR)

-- this makes the particle fade out near the end of its lifetime
sparkRenderScript:ease ( MOAIParticleScript.SPRITE_OPACITY, CONST(1), CONST(0), MOAIEaseType.LINEAR )

-- this makes each particle randomly bigger or smaller than the original size
--sparkRenderScript:set	( MOAIParticleScript.SPRITE_X_SCL, reg4 )
--sparkRenderScript:set	( MOAIParticleScript.SPRITE_Y_SCL, reg4 )
------------------------------
-- Particle system
------------------------------

sparkSystem = MOAIParticleSystem.new ()
-- max num of particles, size of each
sparkSystem:reserveParticles ( 64, 10 )
-- max num of sprites
sparkSystem:reserveSprites ( 64 )
sparkSystem:reserveStates ( 1 )
-- deck can be set like a prop

--Deck= MOAIGfxQuad2D.new ()
--Deck:setTexture ( assetdirectory..image_src)
--Deck:setRect ( -1,-1,1,1)

sparkSystem:setDeck ( Deck )
sparkSystem:start ()
-- particle system can be inserted like a prop
layer_particles:insertProp ( sparkSystem )

------------------------------
-- Particle forces

------------------------------
gravity = MOAIParticleForce.new ()
gravity:initLinear ( 0, -10)
gravity:setType( MOAIParticleForce.FORCE )

radial = MOAIParticleForce.new ()
--radial:initLinear ( 100 )
radial:setType( MOAIParticleForce.FORCE )

------------------------------
-- Particle state
------------------------------
-- a state holds a particle cloud's lifetime, physics properties
-- and which scripts govern its behavior

sparkState = MOAIParticleState.new ()

-- particle lifetime, random between the two values in seconds
sparkState:setTerm ( 3,3 )
sparkState:setInitScript ( sparkInitScript )
sparkState:setRenderScript ( sparkRenderScript )
--sparkState:pushForce (radial)
sparkState:pushForce (gravity)

-- sets the system to this state
sparkSystem:setState ( 1, sparkState )
sparkSystem:surge(16, mouseX, mouseY, 0, 0)
end

function score_particle(mouseX,mouseY,Deck,sizex,sizey)

------------------------------
-- Particle scripts
------------------------------

-- pack registers for scripts
reg1 = MOAIParticleScript.packReg ( 1 )
reg2 = MOAIParticleScript.packReg ( 2 )
reg3 = MOAIParticleScript.packReg ( 3 )
reg4 = MOAIParticleScript.packReg ( 4 )
reg5 = MOAIParticleScript.packReg ( 5 )
CONST = MOAIParticleScript.packConst

----------
--init script
----------

sparkInitScript = MOAIParticleScript.new ()
-- this takes the registers you created above and turns them into random number generators
-- returning values between the last two parameters
sparkInitScript:randVec ( reg1, reg2, CONST(1), CONST(sizex) )
sparkInitScript:rand ( reg3, CONST(-90), CONST(90) )
sparkInitScript:rand ( reg4, CONST(0.5), CONST(3.0) )
sparkInitScript:rand ( reg5, CONST(0), CONST(255) )

----------
-- render script
----------
sparkRenderScript = MOAIParticleScript.new ()
--this makes the sprite appear
sparkRenderScript:sprite ()

-- this controls the amount your particle cloud will spread out over the x axis
-- and how fast / smooth it spreads. Note it is getting a random value from
-- one of the script registers
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_X, CONST(0), reg1, MOAIEaseType.SHARP_EASE_IN )
-- this does the same over the y axis
sparkRenderScript:easeDelta	( MOAIParticleScript.PARTICLE_Y, CONST(0), reg2, MOAIEaseType.SHARP_EASE_IN )

-- resize
sparkRenderScript:ease		( MOAIParticleScript.SPRITE_X_SCL, CONST(0.5), CONST(sizex*2),MOAIEaseType.EASE_IN)
sparkRenderScript:ease		( MOAIParticleScript.SPRITE_Y_SCL, CONST(0.5), CONST(sizey*2),MOAIEaseType.EASE_IN)

-- creates sparkling color
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_RED, reg5 )
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_BLUE, reg3 )
--sparkRenderScript:set ( MOAIParticleScript.SPRITE_GREEN, reg3 )

-- this sets a random starting rotation for each particle
sparkRenderScript:set ( MOAIParticleScript.SPRITE_ROT, reg3 )

-- this applies a random amount of rotation to each particle during its lifetime
--sparkRenderScript:ease ( MOAIParticleScript.SPRITE_ROT, CONST(0), reg3, MOAIEaseType.LINEAR )
--sparkRenderScript:ease			    ( MOAIParticleScript.SPRITE_ROT, CONST ( 0), CONST ( 360),MOAIEaseType.LINEAR)

-- this makes the particle fade out near the end of its lifetime
sparkRenderScript:ease ( MOAIParticleScript.SPRITE_OPACITY, CONST(1), CONST(0), MOAIEaseType.LINEAR )


-- this makes each particle randomly bigger or smaller than the original size
--sparkRenderScript:set	( MOAIParticleScript.SPRITE_X_SCL, reg4 )
--sparkRenderScript:set	( MOAIParticleScript.SPRITE_Y_SCL, reg4 )
------------------------------
-- Particle system
------------------------------

sparkSystem = MOAIParticleSystem.new ()
-- max num of particles, size of each
sparkSystem:reserveParticles ( 64, 10 )
-- max num of sprites
sparkSystem:reserveSprites ( 64 )
sparkSystem:reserveStates ( 1 )
-- deck can be set like a prop

--Deck= MOAIGfxQuad2D.new ()
--Deck:setTexture ( assetdirectory..image_src)
--Deck:setRect ( -1,-1,1,1)




sparkSystem:setDeck ( Deck )
sparkSystem:start ()
-- particle system can be inserted like a prop
layer_particles:insertProp ( sparkSystem )

------------------------------
-- Particle forces

------------------------------
gravity = MOAIParticleForce.new ()
gravity:initLinear ( 0, -10)
gravity:setType( MOAIParticleForce.FORCE )

radial = MOAIParticleForce.new ()
--radial:initLinear ( 100 )
radial:setType( MOAIParticleForce.FORCE )

------------------------------
-- Particle state
------------------------------
-- a state holds a particle cloud's lifetime, physics properties
-- and which scripts govern its behavior

sparkState = MOAIParticleState.new ()

-- particle lifetime, random between the two values in seconds
sparkState:setTerm ( 3,3 )
sparkState:setInitScript ( sparkInitScript )
sparkState:setRenderScript ( sparkRenderScript )
--sparkState:pushForce (radial)
--sparkState:pushForce (gravity)

-- sets the system to this state
sparkSystem:setState ( 1, sparkState )
sparkSystem:surge(1, mouseX, mouseY, 0, 0)
end

--score effects

function popscore(x,y,points)

score=score+points
text = '<c:FFF>'..points..'<c>'

popscorebox = MOAITextBox.new ()
popscorebox:setString ( text )
popscorebox:setFont ( font )
popscorebox:setAlignment(MOAITextBox.CENTER_JUSTIFY)
popscorebox:setRect ( -100,-100,100,100)
popscorebox:setScl ( 0.02,0.02,0.02)

popscorebox:setLoc(x,y-1)
popscorebox:setYFlip ( true )
popscorebox:setPriority(1)

layer_splash:insertProp ( popscorebox )

popscorebox:seekScl ( 0.05,0.05,0.05,4,MOAIEaseType.LINEAR)
popscorebox:seekLoc( x,y-2,0, 4,MOAIEaseType.LINEAR )

update_score()

local action=popscorebox:seekColor ( 1,1,1,0, 4 )
action:setListener ( MOAIAction.EVENT_STOP,
function ()

	alert_layer:removeProp(popscorebox)
end
)

popscorebox_counter=popscorebox_counter+1
end

function update_score()

layer_hud:removeProp ( scorebox )
layer_hud:removeProp ( scorebox_shadow )
text = '<c:FFF>'..score..'<c>'

-- debug output here
-- text = '<c:FFF>'..MOAIEnvironment.osBrand..'<c>'


scorebox = MOAITextBox.new ()
scorebox:setString ( text )
scorebox:setFont ( bigfont )
scorebox:setAlignment(MOAITextBox.CENTER_JUSTIFY)
scorebox:setRect ( -100,-30,100,30)
scorebox:setLoc(0,(screen_height/2)-30)

scorebox:setYFlip ( true )
scorebox:setPriority(10)

text = '<c:000>'..score..'<c>'
scorebox_shadow = MOAITextBox.new ()
scorebox_shadow:setString ( text )
scorebox_shadow:setFont ( bigfont )
scorebox_shadow:setAlignment(MOAITextBox.CENTER_JUSTIFY)
scorebox_shadow:setRect ( -100,-30,100,30)
scorebox_shadow:setLoc(0+2,(screen_height/2)-30)
scorebox_shadow:setYFlip ( true )
scorebox_shadow:setPriority(1)

layer_hud:insertProp ( scorebox_shadow )
layer_hud:insertProp ( scorebox )


end

function pointerCallback ( pointerx, pointery )
x=pointerx
y=pointery
pointercalls=pointercalls+1
----print ("x="..x.."y="..y)
mouseX, mouseY = layer:wndToWorld ( x, y )
mouseX_back, mouseY_back = layer_back:wndToWorld ( x, y )
hudX,hudY=layer_hud:wndToWorld ( x, y )
pick = partition:propForPoint ( hudX,hudY )
gamepick = gamepartition:propForPoint ( mouseX,mouseY )


if mousedown==true then
	xMove=x
	yMove=y
	mousedowntime=pointercalls

	if playerpicked~=true and gamepick~=true then
		panning=true

	end

	if currentplayer then
		--dragging player
		if actor_fixtures[currentplayer].name=="Player" then
			bx,by=actor_bodies[currentplayer]:getPosition()

			if bx then
				----print ("Bodyx="..bx.." mouse x="..mouseX)
				actor_bodies[currentplayer]:setLinearVelocity((bx-mouseX)*5*-1,(by-mouseY)*5*-1)
				actor_bodies[currentplayer]:setAwake()
			end
		end

	end


	if gamepick then
		if (gamepick.name=="Player" or gamepick.name=="Player1" or gamepick.name=="Player2" or gamepick.name=="Player3" or gamepick.name=="Circle" or gamepick.name=="Circle2" or gamepick.name=="Box" or gamepick.name=="Triangle") then


		end
	end


	-- dragging camera
	if playerpicked~=true and gamepick~=true and panning==true and currentplayer==nil then
		--MOAIDialogIOS.showDialog ( "hi!", "DRAGGING CAMERA")

		cx,cy=cameraprop:getLoc()
		gotoX=cx-mouseX+mouseXdown

		--print ("gotox="..gotoX)
		gotoY=cy

		if gotoX>boundaryright then gotoX=boundaryright end
		if gotoX<boundaryleft then gotoX=boundaryleft end

		--cameraprop:setLoc(gotoX,cy)
		if (usecamerabody==false and movingcamera==false) then
			movingcamera=true

			movecamera=cameraprop:seekLoc(gotoX,cy,0.1,MOAIEaseType.LINEAR)
			movecamera:setListener ( MOAIAction.EVENT_STOP,
			function ()
				movingcamera=false
			end
			)

			--fitter:stop()
		end

		if usecamerabody==true then
			--camerabody:setTransform(cbx+gotoX,cby,0)
		end
		oldmouseX=mouseX
		oldmouseY=mouseY
	end



end
end

function clickCallback ( down )

-- pointer DOWN

if down==true then
	lastX=x
	lastY=y

	mousedowntimer=pointercalls
	mousedown=true
	mouseXdown=mouseX
	mouseYdown=mouseY
	hudXdown=hudX
	hudYdown=hudY

	cameraXdown,cameraYdown=cameraprop:getLoc()
	xDown=x
	print ("xDown="..xDown)
	yDown=y
	----print ("yDown="..yDown)


	--actor_bodies[currentplayer]:setLinearVelocity(-5,0)

	if pick then
		if pick.name=="button_game_exit" then
			cx,cy=camera:getLoc()
			--confetti(cx,cy,particletexture5,1,1)
			myDialog=Dialog:new()
			myDialog.text="TESTING!"
			myDialog.description="A new and exciting desc!"
			myDialog.buttonnumber=2
			myDialog:show()
			--add_arrow(0,-5)
		end
	end

	if pick then
		if pick.name=="button_game_jump" then
			cx,cy=camera:getLoc()
			bx,by=actor_bodies[mainplayer]:getPosition()
			vx,vy=actor_bodies[mainplayer]:getLinearVelocity()
			actor_bodies[mainplayer]:applyLinearImpulse ( 0,2,bx,by )

			anchor2:setParent ( actor_sprites[mainplayer] )

		end

		if pick.name=="button_game_left" then
			cx,cy=camera:getLoc()
			bx,by=actor_bodies[mainplayer]:getPosition()
			vx,vy=actor_bodies[mainplayer]:getLinearVelocity()
			actor_bodies[mainplayer]:applyLinearImpulse ( -1,0,bx,by )

			anchor2:setParent ( actor_sprites[mainplayer] )

		end

		if pick.name=="button_game_right" then
			cx,cy=camera:getLoc()
			bx,by=actor_bodies[mainplayer]:getPosition()
			vx,vy=actor_bodies[mainplayer]:getLinearVelocity()
			actor_bodies[mainplayer]:applyLinearImpulse ( 1,0,bx,by )

			anchor2:setParent ( actor_sprites[mainplayer] )

		end
	end

	if gamepick then
		if (gamepick.name=="Player" or gamepick.name=="Player1" or gamepick.name=="Player2" or gamepick.name=="Player3" or gamepick.name=="Player4"  or gamepick.name=="Player5") then
			currentplayer=gamepick.userdata
			--currentplayer.name=gamepick.name

		end
	end

	if gamepick==nil then
		--fitter:removeAnchor(anchor2)
		cx,cy=camera:getLoc()
		--cpx,cpy=camerabody:getPosition()
		cpx,cpy=cameraprop:getLoc()
		--camerabody:setTransform(cx,cpy,0)
		--cameraprop:setLoc(cx,cpy)
		--fitter:insertAnchor(anchor)
	end
end

-- pointer UP

if down==false then

	mouseXup=mouseX
	mouseYup=mouseY
	mouseuptimer=pointercalls-mousedowntimer

	if (mouseuptimer<10) then
		--fling

		cx,cy=cameraprop:getLoc()
		diffx=x-lastX
		diffx=diffx/16
		gotoX=cx-diffx

		--print ("cx="..cx.." lastx="..lastX.." x="..x.." Gotox="..gotoX)

		if (usecamerabody==false) then
			movecamera=cameraprop:seekLoc(gotoX,cy,1,MOAIEaseType.SMOOTH)
		end

	end
	if dragbody~=nil then
		lastdragbody=dragbody
	end
	dragbody=nil
	mousedown=false

	if currentplayer then
		if (actor_fixtures[currentplayer].name=="Player1") then

			if (MOAIEnvironment.OS_BRAND_ANDROID==1 or MOAIEnvironment.OS_BRAND_IOS==1) then
				--actor_bodies[currentplayer]:setLinearVelocity((y-lastY)/10*-1,(lastX-x)/10)
			end

			if (MOAIEnvironment.OS_BRAND_ANDROID~=1 and MOAIEnvironment.OS_BRAND_IOS~=1) then
				--actor_bodies[currentplayer]:setLinearVelocity((lastX-x)/10,(y-lastY)/10)
			end
			actor_joints[currentplayer]:destroy()

			actor_bodies[currentplayer]:setAwake()
			actor_sprites[currentplayer]:setIndex(2)
			anchor2:setParent ( actor_sprites[currentplayer] )
			fitter:insertAnchor ( anchor2 )
			--fitter:removeAnchor(anchor)
		end

		if (actor_fixtures[currentplayer].name=="Player2") then

			if (MOAIEnvironment.OS_BRAND_ANDROID==1 or MOAIEnvironment.OS_BRAND_IOS==1) then
				--actor_bodies[currentplayer]:setLinearVelocity((y-lastY)/10*-1,(lastX-x)/10)
			end

			if (MOAIEnvironment.OS_BRAND_ANDROID~=1 and MOAIEnvironment.OS_BRAND_IOS~=1) then
				--actor_bodies[currentplayer]:setLinearVelocity((lastX-x)/10,(y-lastY)/10)
			end

			print ("Clicked!")

			actor_bodies[currentplayer]:setAwake()
			actor_sprites[currentplayer]:setIndex(2)
			anchor2:setParent ( actor_sprites[currentplayer] )
			fitter:insertAnchor ( anchor2 )
			--fitter:removeAnchor(anchor)
		end

		if (actor_fixtures[currentplayer].name=="Player3") then

			if (MOAIEnvironment.OS_BRAND_ANDROID==1 or MOAIEnvironment.OS_BRAND_IOS==1) then
				--actor_bodies[currentplayer]:setLinearVelocity((y-lastY)/10*-1,(lastX-x)/10)
			end

			if (MOAIEnvironment.OS_BRAND_ANDROID~=1 and MOAIEnvironment.OS_BRAND_IOS~=1) then
				--actor_bodies[currentplayer]:setLinearVelocity((lastX-x)/10,(y-lastY)/10)
			end

			actor_bodies[currentplayer]:setLinearVelocity(5,20)

			bx,by=actor_bodies[currentplayer]:getPosition()
			confetti(bx,by,particletexture5,1,1)

			actor_bodies[currentplayer]:setAwake()
			actor_sprites[currentplayer]:setIndex(2)
			anchor2:setParent ( actor_sprites[currentplayer] )
			fitter:insertAnchor ( anchor2 )
			--fitter:removeAnchor(anchor)
		end

		if actor_fixtures[currentplayer].name=="Player" then
			actor_bodies[currentplayer]:setAwake()
			anchor2:setParent ( actor_sprites[currentplayer] )
			fitter:insertAnchor ( anchor2 )
			--fitter:removeAnchor(anchor)
		end

		currentplayer=nil
	end

	if panning then
		--cameramove=cameraprop:moveLoc(gotoX*30,gotoY,1,MOAIEaseType.SOFT)
		panning=false
	end

end



end

function point_to_game()
if MOAIInputMgr.device.pointer then
	-- mouse input
	MOAIInputMgr.device.pointer:setCallback ( pointerCallback )
	MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback )
else
	-- touch input
	--MOAIDialogIOS.showDialog ( "hi!", "TOUCH INPUT SETUP")
	MOAIInputMgr.device.touch:setCallback (
	function ( eventType, idx, x, y, tapCount )
		----print ("Touch event="..eventType)


		-- pinchzoom
		if pinching then

			if idx==0 then
				pointer1x=x
				pointer1y=y
			end
			if idx==1 then
				pointer2x=x
				pointer2y=y
			end

			if pinchstart and idx==1 then
				----print ("pointer2x="..pointer2x.." pointer1x="..pointer1x)
				start_width=pointer2x-pointer1x
				start_height=pointer2y-pointer1y
				start_distance=math.sqrt(start_width*start_width+start_height*start_height)
				old_zoomscale=zoomscale
				----print ("Set start_distance to "..start_distance)
				pinchstart=false
			end

			if pinchstart==false then
				width=pointer2x-pointer1x
				height=pointer2y-pointer1y
				distance=math.sqrt(width*width+height*height)
				diffX=distance-start_distance
				diffX=diffX/20
				zoomscale=old_zoomscale-diffX

				if zoomscale<minzoomscale then zoomscale=minzoomscale end
				if zoomscale>maxzoomscale then zoomscale=maxzoomscale end

				fitter:setMin(1*zoomscale)
			end

		end

		if idx==0 and eventType == MOAITouchSensor.TOUCH_DOWN then
			----print(" 1st finger down ")
			if pinching~=true then
				pointerCallback ( x, y )
				clickCallback ( true )
			end
		end

		if idx==0 and eventType == MOAITouchSensor.TOUCH_UP then
			----print(" 1st finger up ")
			pinching=false
			if pinching~=true then
				--pointerCallback ( x, y )
				clickCallback ( false )
			end
		end

		if idx==0 and eventType == MOAITouchSensor.TOUCH_MOVE then
			----print(" 1st finger moving ")

			if pinching~=true then
				pointerCallback ( x, y )
			end
		end

		if idx==1 and eventType == MOAITouchSensor.TOUCH_DOWN then
			----print("  2nd finger down ")
			pinchstart=true
			pinching=true
		end

		if idx==1 and eventType == MOAITouchSensor.TOUCH_MOVE then
			----print(" 2nd finger moving ")
			pinching=true
		end

		if idx==1 and eventType == MOAITouchSensor.TOUCH_UP then
			----print(" 2nd finger up ")
			pinchstart=false
			pinching=false
		end
	end
	)
end


end

function onCollide ( event, fixtureA, fixtureB, arbiter )
if event == MOAIBox2DArbiter.BEGIN then
	if fixtureA.name and fixtureB.name then
		----print( fixtureA.userdata.." "..fixtureA.name.." collided with " .. fixtureB.userdata.." "..fixtureB.name)

		if ((fixtureB.name=="Box" or fixtureB.name=="Triangle" or fixtureB.name=="Circle" or fixtureB.name=="Wall") and (fixtureA.name=="Player" or fixtureA.name=="Player1" or fixtureA.name=="Player2" or fixtureA.name=="Player3")) or
		((fixtureB.name=="Box" or fixtureB.name=="Triangle"  or fixtureB.name=="Circle") and (fixtureA.name=="Box" or fixtureA.name=="Triangle" or fixtureA.name=="Circle" or fixtureA.name=="Wall"))
		then
			collisionx,collisiony= fixtureB:getBody():getWorldCenter()

			fixtureB.health=fixtureB.health-math.abs(fixtureB:getBody():getLinearVelocity()*10)
			------print ("Health="..fixtureB.health)
			if fixtureB.health<50 then
				actor_sprites[fixtureB.userdata]:setIndex(2)
			end

			if fixtureB.health<0 then
				layer:removeProp ( actor_sprites[fixtureB.userdata] )

				explode(collisionx,collisiony,actor_fixtures[fixtureB.userdata].particletexture,actor_fixtures[fixtureB.userdata].width,actor_fixtures[fixtureB.userdata].height)
				smoke(collisionx,collisiony,actor_fixtures[fixtureB.userdata].smoketexture,actor_fixtures[fixtureB.userdata].width,actor_fixtures[fixtureB.userdata].height)
				popscore(collisionx,collisiony,fixtureB.points)
				if soundon then
					sound3:play()
				end

				fixtureB:getBody():destroy()
			end
		end

		-- treasure collision


		if ((fixtureB.name=="Treasure") and (fixtureA.name=="Player" or fixtureA.name=="Player1" or fixtureA.name=="Player2"  or fixtureA.name=="Player3"))
		then
			layer:removeProp ( actor_sprites[fixtureB.userdata] )

			confetti(collisionx,collisiony,actor_fixtures[fixtureB.userdata].particletexture,actor_fixtures[fixtureB.userdata].width,actor_fixtures[fixtureB.userdata].height)
			popscore(collisionx,collisiony,fixtureB.points)
			if soundon then
				sound3:play()
			end

			fixtureB:getBody():destroy()
		end

		if ((fixtureA.name=="Treasure") and (fixtureB.name=="Player" or fixtureB.name=="Player1" or fixtureB.name=="Player2" or fixtureB.name=="Player3"))
		then
			collisionx,collisiony= fixtureA:getBody():getWorldCenter()

			fixtureA.health=fixtureA.health-math.abs(fixtureA:getBody():getLinearVelocity()*10)
			------print ("Health="..fixtureB.health)
			if fixtureA.health<50 then
				actor_sprites[fixtureA.userdata]:setIndex(2)
			end

			if fixtureA.health<0 then
				layer:removeProp ( actor_sprites[fixtureA.userdata] )

				confetti(collisionx,collisiony,actor_fixtures[fixtureA.userdata].particletexture,actor_fixtures[fixtureA.userdata].width,actor_fixtures[fixtureA.userdata].height)
				popscore(collisionx,collisiony,fixtureA.points)
				if soundon then
					sound3:play()
				end

				fixtureA:getBody():destroy()
			end
		end

	end
end



if event == MOAIBox2DArbiter.END then



end



if event == MOAIBox2DArbiter.PRE_SOLVE then





end



if event == MOAIBox2DArbiter.POST_SOLVE then



end

end

function add_actor(x,y,width,height,density,friction,restitution,actorname,treasure,bodytype,texture_image,particle_texture,smoke_texture,welded,health,points,velocityx,velocityy)

if velocityy~=nil then print ("vely="..velocityy) end

if points==nil then points=0 end
if velocityx==nil then velocityx=0 end
if velocityy==nil then velocityy=0 end

local texture_filename=texture_image
texture_image=assetdirectory..texture_image
density=0+density
restitution=0+restitution
friction=0+friction
actor_sprites[c] = MOAIProp2D.new ()

if bodytype=="Dynamic" then
	actor_bodies[c] = world:addBody ( MOAIBox2DBody.DYNAMIC )
	actor_bodies[c].boxtype="Dynamic"
end
if bodytype=="Static" then
	actor_bodies[c] = world:addBody ( MOAIBox2DBody.STATIC )
	actor_bodies[c].boxtype="Static"
end
actor_bodies[c]:setTransform(x,y,0)
actor_bodies[c].start_x=x
actor_bodies[c].start_y=y
actor_bodies[c].userdata=c

if actorname=="Circle" then
	tileLib = MOAITileDeck2D.new ()
	tileLib:setTexture ( texture_image )
	tileLib:setSize ( 2,1 )
	tileLib:setRect ( width/2*-1,height/2*-1,width/2,height/2)
	actor_sprites[c]:setDeck ( tileLib )
	actor_fixtures[c] = actor_bodies[c]:addCircle ( 0,0,width/2)
end

if (actorname=="Player" or actorname=="Player1" or actorname=="Player2" or actorname=="Player3") then
	tileLib = MOAITileDeck2D.new ()
	tileLib:setTexture ( texture_image )
	tileLib:setSize ( 2,1 )
	tileLib:setRect ( width/2*-1,height/2*-1,width/2,height/2)
	actor_sprites[c]:setDeck ( tileLib )
	actor_fixtures[c] = actor_bodies[c]:addCircle ( 0,0,width/2)
end

if (actorname=="Player4") then
	tileLib = MOAITileDeck2D.new ()
	tileLib:setTexture ( texture_image )
	tileLib:setSize ( 2,1 )
	tileLib:setRect ( width/2*-1,height/2*-1,width/2,height/2)
	actor_sprites[c]:setDeck ( tileLib )
	actor_fixtures[c] = actor_bodies[c]:addCircle ( 0,0,width/2)
end

if (actorname=="Player5") then
	tileLib = MOAITileDeck2D.new ()
	tileLib:setTexture ( texture_image )
	tileLib:setSize ( 2,1 )
	tileLib:setRect ( width/2*-1,height/2*-1,width/2,height/2)
	actor_sprites[c]:setDeck ( tileLib )
	actor_sprites[c]:setPriority(100)
	actor_fixtures[c] = actor_bodies[c]:addCircle ( 0,0,width/2)
end

if actorname=="Box" then

	tileLib = MOAITileDeck2D.new ()
	tileLib:setTexture ( texture_image )
	tileLib:setSize ( 2,1 )
	tileLib:setRect ( width/2*-1,height/2*-1,width/2,height/2)
	actor_sprites[c]:setDeck ( tileLib )
	actor_fixtures[c] = actor_bodies[c]:addRect ( width/2*-1,height/2*-1,width/2,height/2)
end

if actorname=="Treasure" then

	tileLib = MOAITileDeck2D.new ()
	tileLib:setTexture ( texture_image )
	tileLib:setSize ( 2,1 )
	tileLib:setRect ( width/2*-1,height/2*-1,width/2,height/2)
	actor_sprites[c]:setDeck ( tileLib )
	actor_fixtures[c] = actor_bodies[c]:addRect ( width/2*-1,height/2*-1,width/2,height/2)
end

if actorname=="Wall" then

	texture = MOAIGfxQuad2D.new ()
	texture:setTexture ( texture_image )
	texture:setRect ( width/2*-1,height/2*-1,width/2,height/2)
	actor_sprites[c]:setDeck ( texture )
	actor_fixtures[c] = actor_bodies[c]:addRect ( width/2*-1,height/2*-1,width/2,height/2)
end

if actorname=="Ground" then
	offset=0.4
	texture = MOAIGfxQuad2D.new ()
	texture:setTexture ( texture_image )
	texture:setRect ( width/2*-1,height/2*-1+offset,width/2,height/2+offset)

	actor_sprites[c]:setDeck ( texture )
	actor_fixtures[c] = actor_bodies[c]:addRect ( width/2*-1,height/2*-1,width/2,height/2)
end

if actorname=="Platform" then
	offset=0.2
	texture = MOAIGfxQuad2D.new ()
	texture:setTexture ( texture_image )
	texture:setRect ( width/2*-1,height/2*-1,width/2,height/2)

	actor_sprites[c]:setDeck ( texture )
	--actor_sprites[c]:setLoc(0,offset)
	xscale,yscale=actor_sprites[c]:getScl()
	actor_sprites[c]:setScl(xscale,yscale+offset*8)
	actor_fixtures[c] = actor_bodies[c]:addRect ( width/2*-1,height/2*-1,width/2,height/2)
end

if actorname=="Triangle" then
	tileLib = MOAITileDeck2D.new ()
	tileLib:setTexture ( texture_image )
	tileLib:setSize ( 2,1 )
	tileLib:setRect ( width*-1,height*-1,width,height)
	actor_sprites[c]:setDeck ( tileLib )
	t = { 1*width,-1*width,0*width,1*width,-1*width,-1*width }
	actor_fixtures[c] = actor_bodies[c]:addPolygon (t)
end

actor_fixtures[c]:setDensity ( density )
actor_fixtures[c]:setFriction ( friction )
actor_fixtures[c]:setRestitution ( restitution)
actor_fixtures[c].userdata=c
actor_fixtures[c].name=actorname
actor_sprites[c].userdata=c
actor_sprites[c].name=actorname
actor_fixtures[c].health=health
actor_fixtures[c].points=points
actor_fixtures[c].width=width
actor_fixtures[c].height=height

actor_fixtures[c].particletexture=particle_texture
actor_fixtures[c].smoketexture=smoke_texture

actor_bodies[c]:resetMassData()
actor_fixtures[c]:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x03 )
actor_sprites[c]:setParent ( actor_bodies[c] )
actor_sprites[c].texture=texture_filename

if welded=="True" then
	fixedbody = world:addBody ( MOAIBox2DBody.STATIC )
	fixed_fixture = fixedbody:addRect ( -1999,-0.1,-2000,0.1)
	actor_joints[c]=world:addWeldJoint ( fixedbody,actor_bodies[c],x,y)
end

layer:insertProp ( actor_sprites[c] )
print ("velx="..velocityx.." vely="..velocityy)

actor_bodies[c]:setLinearVelocity(velocityx,velocityy)

c=c+1


return actor_bodies[c]
end

function loadlevel(level)

setupRotationSensor()

 

if level==1 then

 --background layer
        layer_back:setParallax ( 0.5,1 )
        sprite_background_far:setLoc(2,2)
        layer_back:insertProp ( sprite_background_far)
        layer_med:setParallax ( 0.75,1 )
        sprite_background_med:setLoc(0,-2.5)
        layer_med:insertProp ( sprite_background_med)
        sprite_background_med1:setLoc(10,-2.5)
        layer_med:insertProp ( sprite_background_med1)
        sprite_background_med2:setLoc(20,-2.5)
        layer_med:insertProp ( sprite_background_med2)
        layer_close:setParallax ( 0.95,1 )
        sprite_background_close:setLoc(10,0)
        layer_close:insertProp ( sprite_background_close)

        --add ground
        add_actor(0,-10,90,5,0.02,0.3,0,"Ground","","Static","ground.png",particletexture1,smokeparticletexture1,"False",10000000)
        add_actor(5,-10,10,15,0.02,0.3,0,"Ground","","Static","ground.png",particletexture1,smokeparticletexture1,"False",10000000)
       
        --add some player objects
        add_actor(-2,-5,0.75,0.75,0.5,0.3,0.2,"Player1","","Dynamic","face_circle_tiled1.png",particletexture1,smokeparticletexture1,"True",2000)
        mainplayer=c-1
     
        --add some treasure
        add_actor(-5,-4,1,1,0.5,0.3,0.4,"Treasure","","Dynamic","treasure_box_tiled1.png",particletexture5,smokeparticletexture1,"True",10,1000)
        fitter:insertAnchor ( anchor ) -- add camera anchor    

end

if level==2 then

        --background layer
        --add ground
        add_actor(0,-10,90,5,0.02,0.3,0,"Ground","","Static","ground.png",particletexture1,smokeparticletexture1,"False",10000000)
        --add Hills
        drawHills(-20,0,2,10,-5,256)

        --add some player objects
        add_actor(-2,-5,0.75,0.75,0.5,0.3,0.2,"Player3","","Dynamic","face_circle_tiled2.png",particletexture1,smokeparticletexture1,"False",2000)
        mainplayer=c-1
        anchor2:setParent ( actor_sprites[mainplayer] )
        fitter:insertAnchor ( anchor2 )
end
end

function start_level(currentlevel)

c=0
score=0
pointercalls=0
layer:clear()
movingcamera=false
-- set up the world and start its simulation
world = MOAIBox2DWorld.new ()
world:setGravity ( 0, -10)
--world:setUnitsToMeters ( 3 )
--world:setIterations (3,1 )
world:start ()

-- debug draw
if debug==true then layer:setBox2DWorld ( world ) end
gamepartition = MOAIPartition.new ()
layer:setPartition ( gamepartition )


--background layer

--
layer_back:setParallax ( 0.5,1 )
sprite_background_far:setLoc(2,2)
layer_back:insertProp ( sprite_background_far)

layer_med:setParallax ( 0.75,1 )
sprite_background_med:setLoc(0,-2.5)
layer_med:insertProp ( sprite_background_med)
sprite_background_med1:setLoc(10,-2.5)
layer_med:insertProp ( sprite_background_med1)
sprite_background_med2:setLoc(20,-2.5)
layer_med:insertProp ( sprite_background_med2)

layer_close:setParallax ( 0.95,1 )
sprite_background_close:setLoc(10,0)
layer_close:insertProp ( sprite_background_close)



--]]


-- setup hud

--hud button
button_game_exit:setLoc(196,screen_height/2*-1+35)
layer_hud:insertProp ( button_game_exit )

button_game_jump:setLoc(0,screen_height/2*-1+35)
layer_hud:insertProp ( button_game_jump )
button_game_right:setLoc(100,screen_height/2*-1+35)
layer_hud:insertProp ( button_game_right)
button_game_left:setLoc(-100,screen_height/2*-1+35)
layer_hud:insertProp ( button_game_left )

-- setup camera
camera = MOAICamera2D.new ()

-- setup camera fitter / tracker
fitter = MOAICameraFitter2D.new ()
fitter:setViewport ( viewport )
fitter:setCamera ( camera )
fitter:setMin(1*zoomscale)
--fitter:setFitScale(2)
fitter:setDamper(0.4)
--fitter:setBounds ( boundaryleft,boundarybottom,boundaryright,boundarytop)


-- setup camera
cameraprop = MOAIProp2D.new ()
tileLib = MOAITileDeck2D.new ()
tileLib:setTexture ( assetdirectory.."cameraprop.png" )
tileLib:setSize ( 2,1 )
tileLib:setRect (-1,-1,1,1)
--cameraprop:setDeck ( tileLib )
layer:insertProp(cameraprop)

if usecamerabody==true then
	camerabody = world:addBody ( MOAIBox2DBody.KINEMATIC)
	fixture = camerabody:addCircle( 0,0,0.1)
	fixture:setFriction ( 0 )
	fixture:setRestitution ( 0)
	--fixture:setFilter ( 0x02 ,0x02)
	fixture.userdata=-1
	camerabody:setTransform(0,-2,0)
	camerabody:resetMassData()

	cameraprop:setParent(camerabody)
end

cameraprop:setLoc(0,camerapropy)

anchor = MOAICameraAnchor2D.new ()
anchor:setRect ( -4,-4,4,4 )
anchor:setParent ( cameraprop )

anchor2 = MOAICameraAnchor2D.new ()
anchor2:setRect ( -2,-2,2,2)

--fitter:insertAnchor ( anchor )
--fitter:insertAnchor ( anchor2 )
fitter:start()

layer:setCamera ( camera )
layer_back:setCamera ( camera )
layer_med:setCamera ( camera )
layer_close:setCamera ( camera )
layer_particles:setCamera ( camera )
layer_splash:setCamera ( camera )

-- load actors
loadlevel(currentlevel)
point_to_game()

end

----------------- download assets -------------

function getFile(filename,url)

directory=MOAIEnvironment.documentDirectory
if directory~=nil then
	filename=directory.."/"..filename
end
if directory==nil then
	directory=""
	filename=filename
end

gfilename=filename

--print ("getting file"..filename)
capture=assert(curl.new());

local file=assert(io.open(filename, "wb"));

assert(capture:setopt(curl.OPT_WRITEFUNCTION, function (stream, buffer)
stream:write(buffer)
return string.len(buffer);
end));

assert(capture:setopt(curl.OPT_WRITEDATA, file));
assert(capture:setopt(curl.OPT_PROGRESSFUNCTION, function (_, dltotal, dlnow, uptotal, upnow)
end));

assert(capture:setopt(curl.OPT_NOPROGRESS, false));
assert(capture:setopt(curl.OPT_BUFFERSIZE, 5000));
--assert(c:setopt(curl.OPT_HTTPHEADER, "Connection: Keep-Alive", "Accept-Language: en-us"));
assert(capture:setopt(curl.OPT_URL, url));
assert(capture:setopt(curl.OPT_CONNECTTIMEOUT, 45));
--assert(c:perform());

capture:perform({writefunction = function(str)
end})

assert(capture:close()); -- not necessary, as will be garbage collected soon
s="abcd$%^&*()";
assert(s == assert(curl.unescape(curl.escape(s))));
file:close();

filesRemaining=filesRemaining-1
if filesRemaining>0 then downloadFile() end
capture=nil
end

function downloadFile()

if filesRemaining==1 then getFile("ground.png","http://www.innovationtech.co.uk/moai/graphics/ground.png") end
if filesRemaining==2 then getFile("meter.png","http://www.innovationtech.co.uk/moai/graphics/meter.png") end
if filesRemaining==3 then getFile("particle2.png","http://www.innovationtech.co.uk/moai/graphics/particle2.png") end
if filesRemaining==4 then getFile("background_close.png","http://www.innovationtech.co.uk/moai/graphics/background_close.png") end
if filesRemaining==5 then getFile("background_med.png","http://www.innovationtech.co.uk/moai/graphics/background_med.png") end
if filesRemaining==6 then getFile("background_far.png","http://www.innovationtech.co.uk/moai/graphics/background_far.png") end
if filesRemaining==7 then getFile("face_circle_tiled1.png","http://www.innovationtech.co.uk/moai/graphics/face_circle_tiled1.png") end
if filesRemaining==8 then getFile("face_circle_tiled2.png","http://www.innovationtech.co.uk/moai/graphics/face_circle_tiled2.png") end
if filesRemaining==9 then getFile("face_circle_tiled3.png","http://www.innovationtech.co.uk/moai/graphics/face_circle_tiled3.png") end
if filesRemaining==10 then getFile("face_box_tiled1.png","http://www.innovationtech.co.uk/moai/graphics/face_box_tiled1.png") end
if filesRemaining==11 then getFile("face_box_tiled2.png","http://www.innovationtech.co.uk/moai/graphics/face_box_tiled2.png") end
if filesRemaining==12 then getFile("face_box_tiled3.png","http://www.innovationtech.co.uk/moai/graphics/face_box_tiled3.png") end
if filesRemaining==13 then getFile("face_box_tiled4.png","http://www.innovationtech.co.uk/moai/graphics/face_box_tiled4.png") end
if filesRemaining==14 then getFile("face_triangle_tiled1.png","http://www.innovationtech.co.uk/moai/graphics/face_triangle_tiled1.png") end
if filesRemaining==15 then getFile("button1.png","http://www.innovationtech.co.uk/moai/graphics/button1.png") end
if filesRemaining==16 then getFile("button2.png","http://www.innovationtech.co.uk/moai/graphics/button2.png") end
if filesRemaining==17 then getFile("button3.png","http://www.innovationtech.co.uk/moai/graphics/button3.png") end
if filesRemaining==18 then getFile("button4.png","http://www.innovationtech.co.uk/moai/graphics/button4.png") end
if filesRemaining==19 then getFile("button5.png","http://www.innovationtech.co.uk/moai/graphics/button5.png") end
if filesRemaining==20 then getFile("button6.png","http://www.innovationtech.co.uk/moai/graphics/button6.png") end
if filesRemaining==21 then getFile("button7.png","http://www.innovationtech.co.uk/moai/graphics/button7.png") end
if filesRemaining==22 then getFile("button8.png","http://www.innovationtech.co.uk/moai/graphics/button8.png") end
if filesRemaining==23 then getFile("particle.png","http://www.innovationtech.co.uk/moai/graphics/particle.png") end
if filesRemaining==24 then getFile("face_box_tiled5.png","http://www.innovationtech.co.uk/moai/graphics/face_box_tiled5.png") end
if filesRemaining==25 then getFile("ground.png","http://www.innovationtech.co.uk/moai/graphics/ground.png") end
if filesRemaining==26 then getFile("button9.png","http://www.innovationtech.co.uk/moai/graphics/button9.png") end
if filesRemaining==27 then getFile("sound.png","http://www.innovationtech.co.uk/moai/graphics/sound.png") end
if filesRemaining==28 then getFile("face_triangle_tiled2.png","http://www.innovationtech.co.uk/moai/graphics/face_triangle_tiled2.png") end
if filesRemaining==29 then getFile("face_triangle_tiled3.png","http://www.innovationtech.co.uk/moai/graphics/face_triangle_tiled3.png") end
if filesRemaining==30 then getFile("face_triangle_tiled4.png","http://www.innovationtech.co.uk/moai/graphics/face_triangle_tiled4.png") end
if filesRemaining==31 then getFile("face_triangle_tiled5.png","http://www.innovationtech.co.uk/moai/graphics/face_triangle_tiled5.png") end
if filesRemaining==32 then getFile("treasure_box_tiled1.png","http://www.innovationtech.co.uk/moai/graphics/treasure_box_tiled1.png") end
if filesRemaining==33 then getFile("treasure_box_tiled2.png","http://www.innovationtech.co.uk/moai/graphics/treasure_box_tiled2.png") end
if filesRemaining==34 then getFile("treasure_box_tiled3.png","http://www.innovationtech.co.uk/moai/graphics/treasure_box_tiled3.png") end
if filesRemaining==35 then getFile("treasure_box_tiled4.png","http://www.innovationtech.co.uk/moai/graphics/treasure_box_tiled4.png") end
if filesRemaining==36 then getFile("treasure_box_tiled5.png","http://www.innovationtech.co.uk/moai/graphics/treasure_box_tiled5.png") end
if filesRemaining==37 then getFile("treasure_circle_tiled1.png","http://www.innovationtech.co.uk/moai/graphics/treasure_circle_tiled1.png") end
if filesRemaining==38 then getFile("treasure_circle_tiled2.png","http://www.innovationtech.co.uk/moai/graphics/treasure_circle_tiled2.png") end
if filesRemaining==39 then getFile("treasure_circle_tiled3.png","http://www.innovationtech.co.uk/moai/graphics/treasure_circle_tiled3.png") end
if filesRemaining==40 then getFile("treasure_circle_tiled4.png","http://www.innovationtech.co.uk/moai/graphics/treasure_circle_tiled4.png") end
if filesRemaining==41 then getFile("treasure_circle_tiled5.png","http://www.innovationtech.co.uk/moai/graphics/treasure_circle_tiled5.png") end
if filesRemaining==42 then getFile("level1.lua","http://www.innovationtech.co.uk/moai/graphics/level1.lua") end
if filesRemaining==43 then getFile("level2.lua","http://www.innovationtech.co.uk/moai/graphics/level2.lua") end
if filesRemaining==44 then getFile("level3.lua","http://www.innovationtech.co.uk/moai/graphics/level3.lua") end
if filesRemaining==45 then getFile("level4.lua","http://www.innovationtech.co.uk/moai/graphics/level4.lua") end
if filesRemaining==46 then getFile("level5.lua","http://www.innovationtech.co.uk/moai/graphics/level5.lua") end
if filesRemaining==47 then getFile("menubackground.png","http://www.innovationtech.co.uk/moai/graphics/menubackground.png") end
if filesRemaining==48 then getFile("particle4.png","http://www.innovationtech.co.uk/moai/graphics/particle4.png") end
if filesRemaining==49 then getFile("swipe.png","http://www.innovationtech.co.uk/moai/graphics/swipe.png") end
if filesRemaining==50 then getFile("woosh.wav","http://www.innovationtech.co.uk/moai/audio/woosh.wav") end
if filesRemaining==51 then getFile("stab.wav","http://www.innovationtech.co.uk/moai/audio/stab.wav") end
if filesRemaining==52 then getFile("level.png","http://www.innovationtech.co.uk/moai/graphics/level.png") end
if filesRemaining==53 then getFile("start.png","http://www.innovationtech.co.uk/moai/graphics/start.png") end
if filesRemaining==54 then getFile("splash.jpg","http://www.innovationtech.co.uk/moai/graphics/splash.jpg") end
if filesRemaining==55 then getFile("explosion.wav","http://www.innovationtech.co.uk/moai/audio/explosion.wav") end
if filesRemaining==56 then getFile("face_circle_tiled1.png","http://www.innovationtech.co.uk/moai/graphics/face_circle_tiled1.png") end
if filesRemaining==57 then getFile("particle1.png","http://www.innovationtech.co.uk/moai/graphics/particle1.png") end
if filesRemaining==58 then getFile("particle2.png","http://www.innovationtech.co.uk/moai/graphics/particle2.png") end
if filesRemaining==59 then getFile("particle3.png","http://www.innovationtech.co.uk/moai/graphics/particle3.png") end
if filesRemaining==60 then getFile("particle4.png","http://www.innovationtech.co.uk/moai/graphics/particle4.png") end
if filesRemaining==61 then getFile("smokeparticle1.png","http://www.innovationtech.co.uk/moai/graphics/smokeparticle1.png") end
if filesRemaining==62 then getFile("smokeparticle2.png","http://www.innovationtech.co.uk/moai/graphics/smokeparticle2.png") end
if filesRemaining==63 then getFile("smokeparticle3.png","http://www.innovationtech.co.uk/moai/graphics/smokeparticle3.png") end
if filesRemaining==64 then getFile("smokeparticle4.png","http://www.innovationtech.co.uk/moai/graphics/smokeparticle4.png") end
if filesRemaining==65 then getFile("arial.TTF","http://www.innovationtech.co.uk/moai/arial.TTF") end
if filesRemaining==66 then getFile("menubackground.png","http://www.innovationtech.co.uk/moai/graphics/menubackground.png") end
if filesRemaining==67 then getFile("map.png","http://www.innovationtech.co.uk/moai/graphics/map.png") end
if filesRemaining==68 then getFile("particle5.png","http://www.innovationtech.co.uk/moai/graphics/particle5.png") end
if filesRemaining==69 then getFile("menubackground.png","http://www.innovationtech.co.uk/moai/graphics/menubackground.png") end
if filesRemaining==70 then getFile("loading.png","http://www.innovationtech.co.uk/moai/graphics/loading.png") end
end

function assetload()
filesRemaining=70
downloadFile()
end

-- START --
--assetload()
init()
fadeinSplash()
loadresources()
--start_level()
osbrand=None
