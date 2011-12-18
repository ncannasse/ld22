import T;
import Shaders;

typedef K = flash.ui.Keyboard;

typedef Save = {
	px : Float,
	py : Float,
	pz : Float,
	angle : Float,
	showMap : Bool,
	scenario : Int,
	starFound : Array<Bool>,
	termAccess : Array<Bool>,
}


class Main {

	static var DEBUG = true;
	
	static var SCENARIO = [
		{ text : "Welcome to TheCity, we hope you enjoy your stay ! (please move around)", x : 152, y : 69 },
		{ text : "Access terminal #01-MAY", x : 178, y : 77 },
		{ text : "Find your first STAR in neighbour building", x : 197, y : 75 },
		{ text : "Please return to terminal #01-MAY", x : 178, y : 77 },
		{ text : "Find two more stars", x : 139, y : 100 },
		{ text : "Find one more star", x : 208, y : 199 },
		{ text : "Access terminal #02-ROG", x : 209, y : 62 },
		{ text : "Find the other stars and terminals. Learn the secrets of TheCity", x : -1, y : -1 },
		{ text : "", x : -1, y : -1 },
	];
	
	static var TERMINALS = [
		{ x : 178, y : 77, z : 33, req : 1, name : "MAY", person : "Mark Johnes - Mayor of TheCity", text : "
I came to TheCity because I was supposed to become the Mayor here.

But I don't want to be the Mayor of some deserted city !

I know that a lot of people are living here, but they are hiding themselves, and I can't even actually talk to them... How a Mayor is supposed to rule such a city ?

Did I made a mistake by making the choice to come here ?

Maybe I'll just turn off the switch...

No...

That's too hard...
"  },

		{ x : 209, y : 62, z : 33, req : 3, name : "ROG", person : "Roger Horns", text : "
Sometimes went I spent a very long time looking at the dome, I can remember some very old memories.

I was walking in the grass, with my parents. The sky was blue, there was life all around.

And death as well.

I'm happy to be here now.

I think.
" },

		{ x : 194, y : 58, z : 33, req : 5, name : "BET", person : "Betty Holypop", text : "
I'm sooooo happy to be here, finally !

So many years of suffering, so many pain in my whole body.

And now : I'm free !

Of course, I feel a bit lonely, but I'm sure I'll find many other different people so we can share some time together !
" },
		{ x : 59, y : 110, z : 33, req : 6, name : "KIT", person : "Kitten", text : "Nyaaaaa ?" },
		
		{ x : 27, y : 37, z : 33, req : 7, name : "BOB", person : "Bob Beluga", text : "
If I didn't won this lotery, I would have never have enough money to pay TheCorp and come here.

But I'm not sure if that was a good choice after all...

I'm feeling a bit strange, very different from how I was before.

I was supposed to be happy forever, so why this strange feeling ?

Of course, I can't go back, even if I want.
" },
				
		{ x : 71, y : 68, z : 33, req : 10, name : "OPE", person : "TheCorp Operator", text : "
I am not allowed to give you any information regarding TheCity.

I am not allowed to connect you to anybody you knew before coming here.

I am not allowed to help you with your relations with other residents.

I am not allowed to help you if you feel depressed.

Please remember that all of these were clearly stated when you signed the contract with our company.
" },

		{ x : 214, y : 78, z : 121, req : 12, name : "MIT", person : "Man in the Tower", text : "
Once you remember exactly who you are and why you came to TheCity, you start losing your soul.

You also get granted a great power, the power to change the world.

But since it only affects your own version of the world and not other people one, then what's the point ?

Living REALLY by yourself is not so as nice as I was thinking.... before.
" },

		{ x : 104, y : 83, z : 41, req : 15, name : "MKJ", person : "Mickael J.", text : "
Before coming the TheCity I was a rock star !

People were waiting for hours to see or ear me playing.

Now I don't feel anymore like writing music, I even no longer know how I did before !

But this is not important, since people here don't listen to music anyway.

When was the last time I did myself ?
" },

		{ x : 7, y : 144, z : 9, req : 18, name : "PRT", person : "I am the Prototype", text : "
The original.

I was the first one to come to TheCity, the first one to live here.

What I have seen in all these centuries are humans lured by eternal life.

They forget that they are just simulations running on TheCorp computer cloud.

They are conscious, they keep the whole memory of the time before being here, but they are no longer alive.

No longer human.

There is only one exit, but they are too much afraid of losing eternity.
" },
		
		{ x : 122, y : 116, z : 181, req : 0, name : "SWT", person : "Switch button", text : "
You need to collect all the STARs the activate the switch.

Be careful ! Once turned OFF there is no turn back !

DISCLAIMER : No refunding or any other request will be processed by users who have activated the switch while they were clearly told NOT to do so !

DISCLAIMER (bis) : This switch may damage your hardware, software, memory, hard drive, web browser, mouse, and all other either electrical or biological matter in a 100km radius around you.

Use with care.

You were warned.
" },
	];
	
	static var WIN_TEXT = "
Congratulations !

You have done what thousands of souls trapped in this inhuman world were afraid to do.

You have PRESSED THE SWITCH !

You have reached enough level of consciousness to understand that living forever is not good for human beings.

We will now completely erase you from the TheCity simulation.

Thank you for playing.



- The Director @ncannasse
";

	
	static var STARS = [
		{ x : 197, y : 75, z : 32 },
		
		{ x : 139, y : 100, z : 32 },
		
		{ x : 213, y : 61, z : 32 },
		
		{ x : 208, y : 199, z : 62 },
		
		{ x : 214, y : 44, z : 120 },
		
		{ x : 215, y : 25, z : 110 },
		
		{ x : 116, y : 45, z : 0 },
		
		{ x : 9, y : 138, z : 9 },
		
		{ x : 170, y : 153, z : 36 },
		
		{ x : 33, y : 38, z : 118 },
		
		{ x : 43, y : 219, z : 25 },
		
		{ x : 70, y : 170, z : 32 },
		
		{ x : 26, y : 85, z : 64 },
		
		{ x : 208, y : 171, z : 35 },
		
		{ x : 164, y : 226, z : 42 },
		
		{ x : 123, y : 159, z : 137 },
		
		{ x : 54, y : 122, z : 32 },
		
		{ x : 201, y : 125, z : 32 },
		
		{ x : 16, y : 233, z : 0 },
		
		{ x : 195, y : 234, z : 11 },
	];
	
	static inline var SNOW_COUNT = 1000;
	static inline var LIGHT_COUNT = 10;
	
	var fogColor : Int;

	
	var stage : flash.display.Stage;
	var s3d : flash.display.Stage3D;
	var ctx : flash.display3D.Context3D;
	var gshader : GroundShader;
	var wshader : WallShader;
	var lshader : LightShader;
	var sshader : StarShader;
	var tshader : TerminalShader;
	var t : Float;
	var keys : Array<Bool>;
	var showMap : Bool;

	var elevator : Null<Float>;
	
	var lastFrame : Int;
	
	var camera : Camera;
	var world : World;
	
	var px : Float;
	var py : Float;
	var pz : Float;
	var angle : Float;
	var lookup : Float;
	var falling : Float;
	
	var root : flash.display.Sprite;
	var cross : flash.display.Sprite;
	var debug : flash.text.TextField;
	var scenTF : flash.text.TextField;
	
	var save : flash.net.SharedObject;
	var lastSave : Save;
	var lastKill : { x : Float, y : Float, count : Int };
	
	var term : flash.display.Sprite;

	var map : flash.display.Sprite;
	var mapContent : flash.display.Sprite;
	var cursor : flash.display.Sprite;
	var blips : Array<flash.display.Sprite>;
	
	var triCount : Int;
	var lock : Bool;
	
	var gtexture : Texture;
	var lastKey : Int;
	
	var fadeMC : flash.display.Sprite;
	var onFadeDone : Void -> Void;
	
	var scenario : Int;
	var starFound : Array<Bool>;
	var termAccess : Array<Bool>;
	
	var rndSeed : Int;
	
	var star : GeoSphere;
	var starParts : Polygon;
	var terminal : Cube;
	
	var vsnow : VBuf;
	var ssnow : SnowShader;
	var tsnow : Texture;
	var vlight : VBuf;
	
	var ctexture : CubeTexture;
	
	var ui : flash.display.Sprite;
	var termText : flash.text.TextField;
	var starText : flash.text.TextField;
	
	var gameOver : Null<Float>;
	
	function new(root) {
		this.root = root;
		t = 0;
		
		falling = 0;
		rndSeed = 546451;
		lookup = 0;
		
		keys = [];
		world = new World();
		lastKill = { x : 0., y : 0., count : 0 };
		save = flash.net.SharedObject.getLocal("save");
		var sv : Save = save.data;
		if( Math.isNaN(sv.px) ) {
			px = SCENARIO[0].x + 0.5;
			py = SCENARIO[0].y + 0.5;
			pz = world.height0(Std.int(px),Std.int(py));
			angle = 0;
			showMap = true;
			scenario = 0;
			starFound = [];
			termAccess = [];
		} else {
			px = sv.px;
			py = sv.py;
			pz = sv.pz;
			angle = sv.angle;
			showMap = sv.showMap;
			scenario = sv.scenario;
			starFound = sv.starFound;
			termAccess = sv.termAccess;
			if( starFound == null ) starFound = [];
			if( termAccess == null ) termAccess = [];
		}
				
		stage = root.stage;
		s3d = stage.stage3Ds[0];
		s3d.addEventListener( flash.events.Event.CONTEXT3D_CREATE, onReady );
		stage.addEventListener( flash.events.KeyboardEvent.KEY_DOWN, callback(onKey,true) );
		stage.addEventListener( flash.events.KeyboardEvent.KEY_UP, callback(onKey,false) );
		stage.addEventListener( flash.events.Event.RESIZE, onResize );
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, update);
		
		scenTF = newText(root);
		var fmt = scenTF.defaultTextFormat;
		fmt.align = flash.text.TextFormatAlign.CENTER;
		scenTF.defaultTextFormat = fmt;
		
		debug = new flash.text.TextField();
		debug.visible = false;
		debug.textColor = 0xFFFFFF;
		debug.selectable = false;
		debug.mouseEnabled = false;
		debug.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		debug.width = 1000;
		debug.height = 1000;
		root.addChild(debug);
		
		cursor = new flash.display.Sprite();
		var g = cursor.graphics;
		g.beginFill(0xFFFFFF, 0.8);
		g.drawCircle(0, 0, 3);
		g.endFill();
		g.lineStyle(1, 0xFFFFFF);
		g.moveTo(3, 0);
		g.lineTo(5, 0);
		
		cross = new flash.display.Sprite();
		var g = cross.graphics;
		g.lineStyle(1, 0xFFFFFF, 0.2);
		var s = 3, l = 5;
		g.moveTo(0, s);
		g.lineTo(0, s + l);
		g.moveTo(0, -s);
		g.lineTo(0, -s - l);
		g.moveTo(s, 0);
		g.lineTo(s + l, 0);
		g.moveTo(-s, 0);
		g.lineTo(-s - l, 0);
		root.addChild(cross);
		
		s3d.requestContext3D();
	}

	function newText( ?text : String,  ?x : Float, ?y : Float, ?mc : flash.display.Sprite ) {
		var tf = new flash.text.TextField();
		tf.textColor = 0xFFFFFF;
		tf.selectable = false;
		tf.mouseEnabled = false;
		tf.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		tf.width = 1000;
		if( x != null ) tf.x = x;
		if( y != null ) tf.y = y;
		if( mc != null ) mc.addChild(tf);
		if( text != null ) tf.text = text;
		return tf;
	}
	
	function starCount()
	{
		var scount = 0;
		for( f in starFound )
			if( f )
				scount++;
		return scount;
	}
	
	function initTerm( title, text, req : Int ) {
		if( term != null ) {
			term.visible = true;
			return;
		}
		
		
		term = new gfx.Terminal();
		newText(title, -222, -170, term);
		var t = newText(-207, -126, term);
		t.multiline = true;
		t.wordWrap = true;
		t.width = 400;
		t.height = 1000;
		t.text = text;
		
		if( starCount() < req ) {
			t.textColor = 0xFF8080;
			if( !DEBUG )
				t.text = "ACCESS DENIED\n\nREQUIRE " + (req == 1 ? "ONE STAR" : req+ " STARS")+" CREDENTIALS";
		}
		
		term.x = root.stage.stageWidth >> 1;
		term.y = root.stage.stageHeight >> 1;
		root.addChild(term);
	}
	
	function initMap() {
		map = new flash.display.Sprite();
		root.addChild(map);
		
		var bmp = new flash.display.BitmapData(World.SIZE * 3,World.SIZE * 3);
		for( x in 0...World.SIZE )
			for( y in 0...World.SIZE ) {
				var h = Std.int(world.realHeight(x, y, 256, 1000));
				bmp.setPixel(x, y, h | (h << 8) | (h << 16));
			}
			
		for( t in TERMINALS )
			bmp.setPixel(t.x, t.y, 0xFF0000);
		for( s in STARS )
			bmp.setPixel(s.x, s.y, 0xFFFF00);
			
		bmp.copyPixels(bmp, bmp.rect, new flash.geom.Point(World.SIZE, 0));
		bmp.copyPixels(bmp, bmp.rect, new flash.geom.Point(World.SIZE*2, 0));
		bmp.copyPixels(bmp, bmp.rect, new flash.geom.Point(0, World.SIZE));
		bmp.copyPixels(bmp, bmp.rect, new flash.geom.Point(0, World.SIZE*2));
		
		mapContent = new flash.display.Sprite();
		
		var mask = new flash.display.Sprite();
		mask.graphics.beginFill(0xFF0000);
		mask.graphics.drawCircle(0, 0, World.SIZE >> 2);
		mapContent.mask = mask;
		
		var b = new flash.display.Bitmap(bmp, flash.display.PixelSnapping.ALWAYS);
		b.x = -World.SIZE;
		b.y = -World.SIZE;
		mapContent.addChild(b);

		blips = [];
		for( dx in -1...2 )
			for( dy in -1...2 ) {
				var b = new gfx.Blip();
				mapContent.addChild(b);
				blips.push(b);
			}
		
		map.addChild(mapContent);
		map.addChild(mask);
		map.addChild(cursor);
		mapContent.alpha = 0.5;
		cursor.alpha = 0.5;
	}
	
	function initUI() {
		ui = new flash.display.Sprite();
		root.addChild(ui);
		var sicon = new gfx.Star();
		sicon.scaleX = sicon.scaleY = 0.5;
		sicon.x = 15;
		sicon.y = 15;
		starText = newText(30, 5, ui);
		ui.addChild(sicon);
		
		var ticon = new gfx.Term();
		ticon.filters = [new flash.filters.GlowFilter(0, 0.2, 2, 2, 30)];
		ticon.x = 80;
		ticon.y = 15;
		ticon.scaleX = ticon.scaleY = 0.6;
		termText = newText(95, 5, ui);
		ui.addChild(ticon);
	}
	
	
	function updateMap() {
		var bmp = flash.Lib.as(mapContent.getChildAt(0), flash.display.Bitmap).bitmapData;
		for( s in 0...STARS.length ) {
			if( !starFound[s] ) continue;
			var s = STARS[s];
			var h = Std.int(world.realHeight(s.x, s.y, 256, 1000));
			for( dx in 0...3 )
				for( dy in 0...3 )
					bmp.setPixel(s.x+dx*World.SIZE,s.y+dy*World.SIZE,h | (h << 8) | (h << 16));
		}
		starText.text = starCount() + " / " + STARS.length;
		var tcount = 0;
		for( i in 0...TERMINALS.length )
			if( termAccess[i] )
				tcount++;
		termText.text = tcount + " / " + TERMINALS.length;
	}
	
	function onKey( down, e : flash.events.KeyboardEvent ) {
		if( down ) lastKey = e.keyCode;
		keys[e.keyCode] = down;
	}
	
	function onResize(_) {
		if( ctx == null ) return;
		ctx.dispose();
		ctx = null;
		s3d.requestContext3D();
	}
	
	function updateScenario() {
		var s = SCENARIO[scenario];
		scenTF.text = s.text;
		scenTF.textColor = 0xFFFFFF;
		var b = 0;
		for( dx in -1...2 )
			for( dy in -1...2 ) {
				var b = blips[b++];
				b.visible = s.x >= 0;
				b.x = s.x + dx * World.SIZE;
				b.y = s.y + dy * World.SIZE;
			}
	}


	function onReady( _ ) {

		if( map == null ) {
			initMap();
			initUI();
			updateMap();
		}
		
		var w = stage.stageWidth, h = stage.stageHeight;
		ctx = s3d.context3D;
		ctx.enableErrorChecking = true;
		ctx.configureBackBuffer( w, h, 0, true );

		updateScenario();
		
		debug.y = h - 100;
		
		scenTF.y = h - 30;
		scenTF.width = w;
		
		sshader = new StarShader(ctx);
		lshader = new LightShader(ctx);
		wshader = new WallShader(ctx);
		gshader = new GroundShader(ctx);
		
		camera = new Camera();
		camera.zNear = 0.01;
		camera.zFar = 512;
		camera.fov = 80;
		camera.ratio = w / h;
		
		cross.x = w >> 1;
		cross.y = h >> 1;
		
		map.visible = showMap;
		var s = (h / 2) / World.SIZE;
		map.scaleX = map.scaleY = s;
		map.x = w - World.SIZE * s * 0.25 - 10;
		map.y = h - World.SIZE * s * 0.25 - 10;
		
		ui.y = h - 30;
		
		var size = 256;
		var bmp = new flash.display.BitmapData(size, size, true);
		bmp.perlinNoise(64, 64, 4, 0, true, true, 7);
		
		var s = 0.45;
		var ds = (1 - s) * 0.5;
		
		bmp.applyFilter(bmp, bmp.rect, new flash.geom.Point(0, 0), new flash.filters.ColorMatrixFilter([
			s, ds, ds, 0, 0,
			ds, s, ds, 0, 0,
			ds, ds, s, 0, 0,
			0, 0, 0, 1, 0,
		]));
		
		fogColor = 0xFF758E7F;
		
		gtexture = ctx.createTexture(size, size, TextureFormat.BGRA, false);
		gtexture.uploadFromBitmapData(bmp);
		
		initSnow();
		initLight();
		
		world.build(ctx);
		
		star = new GeoSphere(5);
		star.scale(0.5);
		star.alloc(ctx);
				
		starParts = new Polygon([]);
		for( i in 0...100 ) {
			var a = Math.random() * Math.PI * 2;
			var b = Math.random() * Math.PI * 2;
			var r = 1 + (Math.random() * 0.3 + 0.85);
			var x = r * Math.cos(a) * Math.sin(b);
			var y = r * Math.sin(a) * Math.sin(b);
			var z = r * Math.cos(b);
			starParts.points.push(new Vector(0, 0, 0));
			starParts.points.push(new Vector(x, y, z));
			a += (Math.random() * 2 - 1) * 0.2;
			b += (Math.random() * 2 - 1) * 0.2;
			var x = r * Math.cos(a) * Math.sin(b);
			var y = r * Math.sin(a) * Math.sin(b);
			var z = r * Math.cos(b);
			starParts.points.push(new Vector(x, y, z));
			
			starParts.idx.push(i * 3);
			starParts.idx.push(i * 3 + 1);
			starParts.idx.push(i * 3 + 2);
		}
		starParts.alloc(ctx);
		
		terminal = new Cube();
		terminal.translate( -0.5, -0.5, 0);
		terminal.scale3(0.8, 0.8, 0.7);
		terminal.unindex();
		terminal.addNormals();
		
		tshader = new TerminalShader(ctx);
		terminal.alloc(ctx);
		
		var size = 256;
		ctexture = ctx.createCubeTexture(size, TextureFormat.BGRA, false);
		var bmp = new flash.display.BitmapData(size, size, true, fogColor);
		for( i in 0...Std.int(size * size * 0.05) ) {
			var x = Std.random(size);
			var y = Std.random(size);
			bmp.setPixel32(x, y, 0xFFFFFFFF);
		}
		for( i in 0...6 ) {
			ctexture.uploadFromBitmapData(bmp, i);
			var s = size >> 1;
			var mip = 1;
			while( s > 0 ) {
				var b = new flash.display.BitmapData(s, s, true, 0);
				b.draw(bmp, new flash.geom.Matrix(s / size, 0, 0, s / size));
				ctexture.uploadFromBitmapData(b, i, mip++);
				s >>= 1;
			}
		}
		
	}

	function initSnow() {
		ssnow = new SnowShader(ctx);
		
		tsnow = ctx.createTexture(32, 32, TextureFormat.BGRA, false);
		var bsnow = new flash.display.BitmapData(32, 32, true, 0);
		bsnow.draw(new gfx.Snow());
		tsnow.uploadFromBitmapData(bsnow);
		
		var bsnow = new flash.Vector<Float>();
		var p = 0;
		var count = SNOW_COUNT;
		for( x in 0...count ) {
			var x = Math.random() * 100;
			var y = Math.random() * 100;
			var z = Math.random() * 100;
			bsnow[p++] = x;
			bsnow[p++] = y;
			bsnow[p++] = z;
			bsnow[p++] = 0;
			bsnow[p++] = 0;

			bsnow[p++] = x + 1;
			bsnow[p++] = y;
			bsnow[p++] = z;
			bsnow[p++] = 1;
			bsnow[p++] = 0;
			

			bsnow[p++] = x;
			bsnow[p++] = y + 1;
			bsnow[p++] = z;
			bsnow[p++] = 0;
			bsnow[p++] = 1;
		}
		vsnow = ctx.createVertexBuffer(World.MAX_VERT, 5);
		vsnow.uploadFromVector(bsnow, 0, count * 3);
		vsnow.uploadFromVector(world.empty, count * 3, World.MAX_VERT - (count * 3));
	}
	
	function rnd(v) {
		return world.hash(rndSeed++) % v;
	}
	
	function initLight() {
		var b = new flash.Vector<Float>();
		var p = 0;
		var count = LIGHT_COUNT;
		for( i in 0...count ) {
			var x, y, w, h, z0;
			var ok;
			do {
				ok = true;
				x = rnd(World.SIZE);
				y = rnd(World.SIZE);
				if( rnd(3) < 2 ) {
					w = 5 + rnd(5);
					h = 0;
				} else {
					w = 0;
					h = 5 + rnd(5);
				}
				
				z0 = world.height(x, y, 256);
				for( dy in 0...h+1 )
					for( dx in 0...w+1 )
						if( world.height(x + dx, y + dy, 256) != z0 ) {
							ok = false;
							break;
						}
			} while( !ok );
			
			var z = World.SIZE * 2;
			var dx = 50 + w * 30;
			var dy = 50 + h * 30;
			if( w == 0 ) dx = 0;
			if( h == 0 ) dy = 0;
			var alpha = rnd(100) / 200 + 50;
			
			b[p++] = x + dx;
			b[p++] = y + dy;
			b[p++] = z;
			b[p++] = alpha;
			
			b[p++] = x + w;
			b[p++] = y + h;
			b[p++] = z0;
			b[p++] = alpha;

			b[p++] = x;
			b[p++] = y;
			b[p++] = z0;
			b[p++] = alpha;
			
			b[p++] = x + dx;
			b[p++] = y + dy;
			b[p++] = z;
			b[p++] = alpha;
			
			b[p++] = x + w;
			b[p++] = y + h;
			b[p++] = z0;
			b[p++] = alpha;

			b[p++] = x + dx + (w>>1);
			b[p++] = y + dy + (h>>1);
			b[p++] = z;
			b[p++] = alpha;
		}
		vlight = ctx.createVertexBuffer(World.MAX_VERT, 4);
		vlight.uploadFromVector(b, 0, count * 6);
		vlight.uploadFromVector(world.empty, count * 6, World.MAX_VERT - (count * 6));
	}
	
	function calcHFront() {
		var h = 0.;
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);
		var k = 0.8;
		for( i in 0...10 )
			h += world.realHeight(px + cos * i * k, py + sin * i * k, pz, k * i + 3) * Math.pow(0.5,i+1);
		return h;
	}
	
	function recall(v:Float,r:Float) {
		var rec = false;
		for( i in 0...16 ) {
			var dx = Math.cos((i / 16) * Math.PI * 2) * v;
			var dy = Math.sin((i / 16) * Math.PI * 2) * v;
			var z = world.realHeight(px + dx, py + dy, pz, 0);
			if( z > pz + v * 2 ) {
				px -= dx * r / v;
				py -= dy * r / v;
				rec = true;
			}
		}
		if( rec && v > 0.01 )
			recall(v * 0.8, r);
	}
	
	function fade(color,alpha=1.,?onDone) {
		if( fadeMC == null ) {
			fadeMC = new flash.display.Sprite();
			root.addChild(fadeMC);
		} else {
			var old = onFadeDone;
			if( old != null ) {
				onFadeDone = null;
				old();
				fade(color, alpha, onDone);
				return;
			}
		}
		var g = fadeMC.graphics;
		g.beginFill(color,alpha);
		g.drawRect(0, 0, root.stage.stageWidth, root.stage.stageHeight);
		onFadeDone = onDone;
	}
	
	function kill() {
		lock = true;
		fade(0xFF0000, 0.5, function() {
			var same = lastSave != null && Math.abs(lastKill.x - lastSave.px) < 1 && Math.abs(lastKill.y - lastSave.py) < 1;
			if( lastSave == null || (same && lastKill.count >= 1) ) {
				px = SCENARIO[0].x + 0.5;
				py = SCENARIO[0].y + 0.5;
				pz = world.realHeight(px,py,256);
			} else {
				px = lastSave.px;
				py = lastSave.py;
				pz = lastSave.pz;
			}
			lastKill.x = px;
			lastKill.y = py;
			if( same ) lastKill.count++ else lastKill.count = 0;
			lock = false;
			var texts = ["You Died ! (maybe)", "Ooops !", "Be carefull ! ", "Watch your steps"];
			var t = texts[Std.random(texts.length)];
			if( Std.random(20) == 0 ) t = "Did you found the kitten already ?";
			scenTF.text = t;
			scenTF.textColor = 0xFF8080;
			haxe.Timer.delay(updateScenario, 3000);
		});
	}
	
	function update(_) {
		if( ctx == null ) return;

		var now = flash.Lib.getTimer();
		var dt = (now - lastFrame) / 16.667;
		lastFrame = now;
		if( dt > 6 ) dt = 6;
		
		
		t += 0.01;
		
		if( gameOver != null ) {
			gameOver += dt * 0.003;
			var a = gameOver;
			if( a > 1 ) {
				a = 1;
				if( fadeMC == null ) {
					fade(0,1,function() {
						newText("Connection Closed", 5, 5, root).textColor = 0xFF8080;
						ctx = null;
					});
					fadeMC.alpha = 0;
				}
			}
			var r = 0x75 * (1 - a) + 0xFF * a;
			var g = 0x8E * (1 - a) + 0xFF * a;
			var b = 0x7F * (1 - a) + 0xFF * a;
			fogColor = 0xFF000000 | (Std.int(r) << 16) | (Std.int(g) << 8) | Std.int(b);
		}
		
		var inbuilding = world.inBuilding(Std.int(px), Std.int(py), pz);
		
		var move = 0.;
		var changed = false;

		if( !lock ) {
			if( keys[K.UP] || keys["Z".code] || keys["W".code] ) {
				changed = true;
				move = 1;
			}
			if( keys[K.DOWN] || keys["S".code]  ) {
				changed = true;
				move = -1;
			}
			
			if( lastKey == "K".code ) {
				scenario = 0;
				starFound = [];
				termAccess = [];
				updateScenario();
				updateMap();
				kill();
			}
			
			if( lastKey == Std.int(K.TAB) )
				debug.visible = !debug.visible;
				
			if( lastKey == "M".code ) {
				showMap = !showMap;
				map.visible = showMap;
			}

			if( DEBUG && lastKey == "T".code ) {
				px = mapContent.mouseX % World.SIZE;
				py = mapContent.mouseY % World.SIZE;
				if( px < 0 ) px += World.SIZE;
				if( py < 0 ) py += World.SIZE;
				pz = world.height0(Std.int(px), Std.int(py));
			}
			
			if( DEBUG && keys["U".code] )
				pz = world.realHeight(px, py, 256);
		}
		
		if( !lock || elevator != null ) {
			if( keys[K.LEFT] || keys["Q".code] || keys["A".code] ) {
				changed = true;
				angle -= 0.1 * dt;
			}
			if( keys[K.RIGHT] || keys["D".code] ) {
				changed = true;
				angle += 0.1 * dt;
			}
		}
			
		var speed = 0.1 * dt;
		if( inbuilding ) speed *= 0.5;
		px += Math.cos(angle) * move * speed;
		py += Math.sin(angle) * move * speed;
		
		recall(speed,0.05);
		
		px %= World.SIZE;
		py %= World.SIZE;
		angle %= Math.PI * 2;
		if( px < 0 ) px += World.SIZE;
		if( py < 0 ) py += World.SIZE;
		
		if( !lock ) {
			if( scenario == 0 && new flash.geom.Vector3D(px - SCENARIO[0].x, py - SCENARIO[0].y).length > 10 ) {
				fade(0xFFFFFF,0.3);
				scenario++;
				updateScenario();
			}
		}
		
		var hfront = calcHFront();
		var h = world.realHeight(px, py, elevator == null ? pz : (elevator > 0 ? 256 : 0) );
		if( elevator != null ) {
			pz += 0.1 * dt * elevator;
			elevator *= Math.pow(1.006, dt);
			if( (elevator < 0 && pz < h) || (elevator > 0 && pz > h) ) {
				pz = h;
				elevator = null;
				lock = false;
			}
		} else if( h < pz ) {
			pz -= 0.6 * dt;
			falling += 0.6 * dt;
			if( pz < h ) {
				pz = h;
				if( falling > 20 ) kill();
				falling = 0;
			}
		} else {
			falling = 0;
			pz = h;
			elevator = world.getElevator(Std.int(px), Std.int(py), pz);
			if( elevator != null )
				lock = true;
		}
		
		
		if( changed && falling == 0 && !lock ) {
			lastSave = {
				px : px,
				py : py,
				pz : pz,
				angle : angle,
				showMap : showMap,
				scenario : scenario,
				starFound : starFound,
				termAccess : termAccess,
			};
			for( f in Reflect.fields(lastSave) )
				save.setProperty(f, Reflect.field(lastSave, f));
			try save.flush() catch( e : Dynamic ) { };
		}
		
		
		mapContent.x = -px;
		mapContent.y = -py;
		cursor.rotation = angle * 180 / Math.PI;
		
		var viewZ = pz + 2;
		var lookupTarget = Math.sqrt(Math.abs(hfront - h)) * 0.5;
		var ltMax = 0.8;
		if( lookupTarget > ltMax ) lookupTarget = ltMax;
		if( h > hfront ) lookupTarget *= -1;
		if( lookupTarget > 0.5 ) lookupTarget = 0.5;
		if( lookupTarget > 0 && inbuilding )
			lookupTarget = -0.3;
		if( elevator != null )
			lookupTarget = elevator * 0.3;
		lookup = lookup * 0.95 + lookupTarget * 0.05;
		var ldist = 0.3;
		if( lookup < 0 )
			ldist += lookup * 0.01;
		var cx = px - Math.cos(angle) * ldist;
		var cy = py - Math.sin(angle) * ldist;
		camera.pos.set(cx, cy, viewZ);
		camera.target.set(cx + Math.cos(angle), cy + Math.sin(angle), viewZ + lookup);
		camera.update();
		
		triCount = 0;
		
		ctx.clear( ((fogColor>>16) & 0xFF) / 255 , ((fogColor>>8)&0xFF)/255,  (fogColor&0xFF)/255, 1);
		ctx.setDepthTest( true, Compare.LESS );
		ctx.setBlendFactors(Blend.ONE, Blend.ZERO);
		ctx.setCulling( Face.BACK );

		if( term != null )
			term.visible = false;
		
		render(0, 0);
		for( dx in -1...2 )
			for( dy in -1...2 )
				if( dx != 0 || dy != 0 )
					render(dx, dy);
					
		if( term != null && !term.visible ) {
			term.parent.removeChild(term);
			term = null;
		}
				
		ctx.setCulling( Face.NONE );
		ctx.setBlendFactors(Blend.SOURCE_ALPHA, Blend.ONE);
		ctx.setDepthTest(false, Compare.LESS);
				
		for( dx in -1...2 )
			for( dy in -1...2 )
				renderFX(dx, dy);
				
/*
		ssnow.init( { mproj : camera.m.toMatrix(), t : t * 5 }, { tex : tsnow } );
		ssnow.bind(vsnow);
		ctx.setCulling( Face.NONE );
//		ctx.setDepthTest(false, Compare.ALWAYS);
		ctx.setBlendFactors(Blend.SOURCE_ALPHA, Blend.ONE);
		draw(ssnow, vsnow, SNOW_COUNT);
		ssnow.unbind();
*/


		ctx.present();
		
		var starget = SCENARIO[scenario];
		var p = 0;
		for( dx in -1...2 )
			for( dy in -1...2 ) {
				var b = blips[p++];
				var dx = px - (starget.x + dx * World.SIZE);
				var dy = py - (starget.y + dy * World.SIZE);
				var dist = Math.sqrt(dx * dx + dy * dy);
				if( dist > 70 ) dist = 70;
				if( dist < 6 ) dist = 6;
				if( scenario == 0 ) dist = 0;
				b.scaleX = dist / 37;
				b.scaleY = dist / 37;
			}
		
		
		function float(f:Float) return Std.int(f * 100) / 100;
		debug.text = [
			"pos = " + float(px)+"  "+ float(py)+ "  "+ float(pz),
			"angle = " + Std.int(angle * 180 / Math.PI),
			"scenario = "+scenario,
			"triangles = "+triCount,
		].join("\n");
		
		if( fadeMC != null ) {
			fadeMC.alpha -= gameOver == null ? 0.06 : -0.01;
			if( fadeMC.alpha <= 0 || fadeMC.alpha == 1 ) {
				if( gameOver == null ) fadeMC.parent.removeChild(fadeMC);
				fadeMC = null;
				var old = onFadeDone;
				if( old != null ) {
					onFadeDone = null;
					old();
				}
			}
		}
		
		lastKey = 0;
	}
	
	function render(dx, dy) {
		var project = camera.m.toMatrix();
		project.prependTranslation(dx * World.SIZE, dy * World.SIZE, 0);
				
		var light = new flash.geom.Vector3D(2, 3, -4);
		light.normalize();
		
		wshader.init(
			{ mproj : project, cam : new flash.geom.Vector3D(px,py,pz), t : t * 5 },
			{ color : 0xFF808080, fogColor : fogColor, light : light }
		);
		
		for( b in world.vwalls )
			draw(wshader, b.b, b.n);
			
		wshader.unbind();
		
		gshader.init(
			{ mproj : project, t : t * 10 },
			{ fogColor : fogColor, light : light, tex : gtexture }
		);
			
		for( b in world.vgrounds )
			draw(gshader, b.b, b.n);
			
		gshader.unbind();
		
		
		var tpos = null, dmin = 0., sdist = 0.;
		for( t in TERMINALS ) {
			var dx = t.x + 0.5 + dx * World.SIZE - px;
			var dy = t.y + 0.5 + dy * World.SIZE - py;
			var dz = t.z + 0.5 - pz;
			var d = dx * dx + dy * dy + dz * dz;
			if( tpos == null || d < dmin ) {
				tpos = t;
				dmin = d;
				sdist = (dx * Math.cos(angle) + dy * Math.sin(angle)) / (dx * dx + dy * dy);
			}
		}
		if( dmin < 3.5 && sdist > 0.8  ) {
			var index = Lambda.indexOf(TERMINALS, tpos);
			var pos = ""+(index + 1);
			if( pos.length == 1 ) pos = "0" + pos;
			var access = tpos.req <= starCount();
			if( index == 0 && (scenario == 1 || scenario == 3) ) {
				if( access )
					scenario = 4;
				else
					scenario = 2;
				updateScenario();
			}
			if( index == 1 && scenario == 6 && access ) {
				scenario++;
				updateScenario();
				haxe.Timer.delay(function() { scenario++; updateScenario(); }, 30000);
			}
			if( access && !termAccess[index] ) {
				termAccess[index] = true;
				updateMap();
			}
			
			if( index == TERMINALS.length - 1 && starCount() == STARS.length * (DEBUG ? 0 : 1) ) {
				initTerm("Victory !", StringTools.trim(WIN_TEXT).split("\r\n").join("\n"), 0);
				gameOver = 0;
			} else
				initTerm("Terminal #"+pos+"-"+tpos.name, tpos.person+"\n\n"+StringTools.trim(tpos.text).split("\r\n").join("\n"), tpos.req);
		}
			
		project.prependTranslation(tpos.x + 0.5, tpos.y + 0.5, tpos.z);
		var mrot = new flash.geom.Matrix3D();
		mrot.prependRotation( -t * 100, new flash.geom.Vector3D(0.3, -0.5, 0.6));
		var light = new flash.geom.Vector3D( -0.3, 0.5, -2);
		light.normalize();
		tshader.init( { mproj : project, mrot : mrot, light : light }, { color : fogColor, fogColor : fogColor } );
		tshader.draw(terminal.vbuf, terminal.ibuf);
	}
	
	function renderFX(dx, dy) {
		var project = camera.m.toMatrix();
		project.prependTranslation(dx * World.SIZE, dy * World.SIZE, 0);
		
		lshader.init( { mproj : project, t : t * 0.1 + 100 }, { color : 0x20FFFFFF } );
		draw(lshader, vlight, LIGHT_COUNT * 2);
		lshader.unbind();
		
		var spos = null, dmin = 0.;
		for( si in 0...STARS.length ) {
			if( starFound[si] )
				continue;
			var s = STARS[si];
			var dx = s.x + 0.5 + dx * World.SIZE - px;
			var dy = s.y + 0.5 + dy * World.SIZE - py;
			var dz = s.z + 0.5 - pz;
			var d = dx * dx + dy * dy + dz * dz;
			if( spos == null || d < dmin ) {
				spos = s;
				dmin = d;
			}
		}
		
		if( spos != null ) {
			
			if( dmin < 0.8 && falling == 0 && !lock ) {
				starFound[Lambda.indexOf(STARS, spos)] = true;
				updateMap();
				fade(0xFFFF00, 0.5);
				if( scenario == 2 ) {
					scenario++;
					updateScenario();
				}
				if( scenario == 4 || scenario == 5 ) {
					scenario++;
					updateScenario();
				}
			}
					
			project.prependTranslation(spos.x+0.5, spos.y+0.5, spos.z + 1);
			project.prependRotation(t * 30, new flash.geom.Vector3D(0.3, -0.5, 0.6));
			sshader.init( { mproj : project, maxDist : 1000. }, { color : 0x00FFFFFF } );
			ctx.setDepthTest(true, Compare.LESS);
			sshader.draw(star.vbuf, star.ibuf);
			
			ctx.setDepthTest(false, Compare.LESS);
			project.prependRotation(-t * 50, new flash.geom.Vector3D(0.3, -0.5, 0.6));
			sshader.init( { mproj : project, maxDist : 1.8 }, { color : 0x20FFFF00 } );
			sshader.draw(starParts.vbuf, starParts.ibuf);
		}
	}
	
	function draw( shader : Shader, b : VBuf, ntri : Int ) {
		shader.bind(b);
		ctx.drawTriangles(world.indexes, 0, ntri);
		triCount += ntri;
	}
	

	static function main() {
		haxe.Log.setColor(0xFF0000);
		var inst = new Main(flash.Lib.current);
	}

}