import T;


typedef FBuf = flash.Vector<Float>;

@:bitmap("res/level0.png") class Level0 extends flash.display.BitmapData {
}

@:bitmap("res/level1.png") class Level1 extends flash.display.BitmapData {
}

@:bitmap("res/buildings.png") class Buildings extends flash.display.BitmapData {
}

class World {
	
	public static inline var STRIDE = 6; // x y z nx ny nz

	public static inline var MAX_VERT = 65400;
	static inline var E = 0.001;
	
	static inline var HSCALE = (3 / 255);
	
	
	static inline var Z = 0.1;
	
	public static inline var BITS = 8;
	public static inline var SIZE = 1 << BITS;
	public static inline var MASK = SIZE - 1;
	
	public var l0 : Level0;
	public var l1 : Level1;
	var inB : Buildings;
	var l2 : flash.display.BitmapData;
	
	public var empty : FBuf;
	var gpos : Int;
	var wpos : Int;
	
	var ramps : Array<{ x : Int, y : Int, w : Int, h : Int, z : Array<Int> }>;
	
	public var ground : FBuf;
	public var walls : FBuf;
	public var indexes : IBuf;
	public var vgrounds : Array<{ b : VBuf, n : Int }>;
	public var vwalls : Array<{ b : VBuf, n : Int }>;
	
	public function new() {
		l0 = new Level0(0, 0);
		l1 = new Level1(0, 0);
		inB = new Buildings(0,0);
		l2 = new flash.display.BitmapData(SIZE, SIZE, false, 0);
		
		empty = new FBuf(MAX_VERT * STRIDE);
		initWalls();
		initGround();
		//initDetails();
	}
	
	public function hash(n) {
		for( i in 0...5 ) {
			n ^= (n << 7) & 0x2b5b2500;
			n ^= (n << 15) & 0x1b8b0000;
			n ^= n >>> 16;
			n &= 0x3FFFFFFF;
			var h = 5381;
			h = (h << 5) + h + (n & 0xFF);
			h = (h << 5) + h + ((n >> 8) & 0xFF);
			h = (h << 5) + h + ((n >> 16) & 0xFF);
			h = (h << 5) + h + (n >> 24);
			n = h & 0x3FFFFFFF;
		}
		return n;
	}
	
	function initDetails() {
		var p = 0;
		
		var nx = 0.1;
		var nz = Math.sqrt(1 - nx * nx);
		
		for( i in 0...1000 ) {
			var x = hash(p++) % (SIZE - 1);
			var y = hash(p++) % (SIZE - 1);
			
			var w = ((hash(p++) % 10) + 2) / 20;
			var h = ((hash(p++) % 10) + 2) / 20;
			
			var dz = ((w > h) ? w : h) * 0.5;
			
						
			var z = height0(x, y);
			addTri(ground, gpos, x - w, y - h, z, x, y, z + dz, x, y + h, z, -nx, 0, nz);
			gpos += STRIDE * 3;
			addTri(ground, gpos, x - w, y - h, z, x + w, y, z, x, y, z + dz, 0, -nx, nz);
			gpos += STRIDE * 3;
			addTri(ground, gpos, x + w, y + h, z, x, y + h, z, x, y, z + dz, 0, nx, nz);
			gpos += STRIDE * 3;
			addTri(ground, gpos, x + w, y, z, x + w, y + h, z, x, y, z + dz, nx, 0, nz);
			gpos += STRIDE * 3;
			
			
		}
	}
	
	function initGround() {
		ground = new FBuf();
		var marks = new flash.Vector<Int>(SIZE * SIZE);
		for( x in 0...SIZE )
			for( y in 0...SIZE ) {
				if( marks[x+(y<<BITS)] != 0 )
					continue;
				var h = height0(x, y);
				var size = 1;
				while( size < 5 ) {
					var ok = true;
					for( dx in 0...size+1 )
						if( height0(x + dx, y + size) != h || marks[((x+dx)&MASK)|(((y+size)&MASK)<<BITS)] != 0 ) {
							ok = false;
							break;
						}
					for( dy in 0...size )
						if( height0(x + size, y + dy) != h || marks[((x+size)&MASK)|(((y+dy)&MASK)<<BITS)] != 0 ) {
							ok = false;
							break;
						}
					if( !ok )
						break;
					size++;
				}
				if( size > 1 )
					size--;
				while( x + size > SIZE ) size--;
				while( y + size > SIZE ) size--;
				for( dx in 0...size )
					for( dy in 0...size )
						marks[x + dx + ((y + dy) << BITS)] = 1;
				addGround(x, y, h, size);
			}
		
		var marks = new flash.Vector<Int>(SIZE * SIZE);
		for( x in 0...SIZE )
			for( y in 0...SIZE ) {
				if( marks[x+(y<<BITS)] != 0 )
					continue;
				var h = height1(x, y);
				if( h == 0 ) {
					h = (l1.getPixel(x, y) >> 8) & 0xFF;
					// add Wall
					if( h == 0 ) continue;
					
					var hx = height0(x, y) + 3;
					addHWall(x - 1, y, hx, h);
					addHWall(x, y, h, hx);

					addVWall(x, y - 1, hx, h);
					addVWall(x, y, h, hx);
					
					l1.setPixel(x, y, h);
					l2.setPixel(x , y, hx);
					continue;
				}
				var size = 1;
				while( size < 9 ) {
					var ok = true;
					for( dx in 0...size+1 )
						if( height1(x + dx, y + size) != h || marks[((x+dx)&MASK)|(((y+size)&MASK)<<BITS)] != 0 ) {
							ok = false;
							break;
						}
					for( dy in 0...size )
						if( height1(x + size, y + dy) != h || marks[((x+size)&MASK)|(((y+dy)&MASK)<<BITS)] != 0 ) {
							ok = false;
							break;
						}
					if( !ok )
						break;
					size++;
				}
				if( size > 1 )
					size--;
				while( x + size > SIZE ) size--;
				while( y + size > SIZE ) size--;
				for( dx in 0...size )
					for( dy in 0...size )
						marks[x + dx + ((y + dy) << BITS)] = 1;
				addGround(x - E, y - E, h + E, size + E * 2);

				// add ceil
				var z = h - E;
				addTri(ground, gpos, x, y, z, x, y + size, z, x + size, y, z, 0, 0, -1);
				gpos += 3 * STRIDE;
				addTri(ground, gpos, x, y + size, z, x + size, y + size, z, x + size, y, z, 0, 0, -1);
				gpos += 3 * STRIDE;
			}

		// add ramps
		var l2 = l1.clone();
		var tramps = [];
		
		var rn = new flash.geom.Vector3D(0.5, 0.5, 1);
		rn.normalize();
		var rx = rn.x;
		var ry = rn.y;
		var rz = rn.z;
		
		for( x in 0...SIZE )
			for( y in 0...SIZE ) {
				var p = l2.getPixel(x, y);
				switch( p ) {
				case 0xFF0000:
					var w = 1, h = 1;
					while( l2.getPixel(x + w, y) == 0xFF0000 )
						w++;
					while( l2.getPixel(x, y + h) == 0xFF0000 )
						h++;
					var h0 = height(x - 1, y - 1, 256);
					var h1 = height(x + w, y - 1, 256);
					var h2 = height(x - 1, y + h, 256);
					var h3 = height(x + w, y + h, 256);
									
					tramps.push( { x : x, y : y, w : w, h : h, z : [h0, h1, h2, h3] } );
					
					addTri(ground, gpos, x, y, h0, x + w, y, h1, x, y + h, h2, rx, ry, rz);
					gpos += 3 * STRIDE;
					addTri(ground, gpos, x, y + h, h2, x + w, y, h1, x + w, y + h, h3, rx, ry, rz);
					gpos += 3 * STRIDE;
					
					// double sided

					addTri(ground, gpos, x, y, h0, x, y + h, h2, x + w, y, h1, -rx, -ry, -rz);
					gpos += 3 * STRIDE;
					addTri(ground, gpos, x, y + h, h2, x + w, y + h, h3, x + w, y, h1, -rx, -ry, -rz);
					gpos += 3 * STRIDE;
					
					for( dx in 0...w )
						for( dy in 0...h ) {
							l1.setPixel(x + dx, y + dy, 0);
							l2.setPixel(x + dx, y + dy, 0);
						}
				default:
				}
			}
		l2.dispose();
		ramps = tramps;
	}
	
	inline function max(x:Int, y:Int) {
		return x < y ? y : x;
	}
	
	function initWalls() {
		walls = new FBuf();
		for( x in 0...SIZE )
			for( y in 0...SIZE ) {
				var h = height0(x, y);
				var hx = height0(x + 1, y);
				if( h != hx ) addHWall(x, y, h, hx);
				var hy = height0(x, y + 1);
				if( h != hy ) addVWall(x, y, h, hy);
			}
		for( x in 0...SIZE )
			for( y in 0...SIZE ) {
				var h = height1(x, y);
				if( h == 0 ) continue;
				
				var hx = height1(x + 1, y);
				if( hx != 0 && h != hx ) addHWall(x, y, h, hx);
				var hy = height1(x, y + 1);
				if( hy != 0 && h != hy ) addVWall(x, y, h, hy);
			}
	}
	
	function addHWall(x, y, h, hx) {
		if( hx > h ) {
			addTri(walls, wpos, x + 1, y, h, x + 1, y +1, hx, x + 1, y + 1, h, -1, 0, 0);
			wpos += 3 * STRIDE;
			addTri(walls, wpos, x + 1, y, h, x + 1, y, hx, x + 1, y + 1, hx, -1, 0, 0);
			wpos += 3 * STRIDE;
		} else if( hx < h ) {
			addTri(walls, wpos, x + 1, y, hx, x + 1, y + 1, hx, x + 1, y +1, h, 1, 0, 0);
			wpos += 3 * STRIDE;
			addTri(walls, wpos, x + 1, y, hx, x + 1, y + 1, h, x + 1, y, h, 1, 0, 0);
			wpos += 3 * STRIDE;
		}
	}
	
	function addVWall(x, y, h, hy) {
		if( hy > h ) {
			addTri(walls, wpos, x, y + 1, h, x + 1, y + 1, h, x + 1, y + 1, hy, 0, -1, 0);
			wpos += 3 * STRIDE;
			addTri(walls, wpos, x, y + 1, h, x + 1, y + 1, hy, x, y + 1, hy, 0, -1, 0);
			wpos += 3 * STRIDE;
		} else if( hy < h ) {
			addTri(walls, wpos, x, y + 1, hy,  x + 1, y + 1, h, x + 1, y + 1, hy, 0, 1, 0);
			wpos += 3 * STRIDE;
			addTri(walls, wpos, x, y + 1, hy,  x, y + 1, h, x + 1, y + 1, h, 0, 1, 0);
			wpos += 3 * STRIDE;
		}
	}
	
	inline function addGround(x, y, z, size) {
		addTri(ground, gpos, x, y, z, x + size, y, z, x, y + size, z, 0, 0, 1);
		gpos += 3 * STRIDE;
		addTri(ground, gpos, x, y + size, z, x + size, y, z, x + size, y + size, z, 0, 0, 1);
		gpos += 3 * STRIDE;
	}
	
	inline function addTri( v : FBuf, p : Int, x1, y1, z1, x2, y2, z2, x3, y3, z3, nx, ny, nz) {
		addVert(v, p, x1, y1, z1, nx, ny, nz);
		addVert(v, p + STRIDE, x2, y2, z2, nx, ny, nz);
		addVert(v, p + STRIDE*2, x3, y3, z3, nx, ny, nz);
	}
	
	inline function addVert( v : FBuf, p : Int, x, y, z, nx, ny, nz ) {
		v[p++] = x;
		v[p++] = y;
		v[p++] = z;
		v[p++] = nx;
		v[p++] = ny;
		v[p++] = nz;
	}
	
	public function inBuilding(x, y, z:Float) {
		return inB.getPixel(x & MASK, y & MASK) == 0x00FF00 && z == height0(x,y);
	}
	
	public function getElevator(x, y, z:Float) : Null<Int> {
		var p = inB.getPixel(x & MASK, y & MASK) & 0xFF;
		if( p == 0xFF && z == realHeight(x, y, 256, 1000) )
			return -1;
		if( p == 0x80 && z < realHeight(x, y, 256, 1000) )
			return 1;
		return null;
	}
	
	public function height0(x, y) {
		var h = l0.getPixel(x & MASK, y & MASK) & 0xFF;
		if( h == 10 ) h = 5;
		return h;
	}

	public function height1(x,y) {
		return l1.getPixel(x&MASK, y&MASK) & 0xFF;
	}
	
	public function height(x,y,z:Float) {
		var h1 = height1(x, y);
		if( h1 > 0 && h1 <= z + 0.5 )
			return h1;
		var h0 = height0(x, y);
		if( h0 < h1 ) {
			var h2 = l2.getPixel(x & MASK, y & MASK) & 0xFF;
			if( h2 > 0 && h2 <= z + 0.5 ) return h1;
		}
		return h0;
	}
	
	public function realHeight(x:Float, y:Float, z:Float, dz = 3. ) {
		for( r in ramps )
			if( x >= r.x && y >= r.y && x < r.x + r.w && y < r.y + r.h ) {
				var dx = (x - r.x) / r.w;
				var dy = (y - r.y) / r.h;
				var zx0 = r.z[0] + (r.z[1] - r.z[0]) * dx;
				var zx1 = r.z[2] + (r.z[3] - r.z[2]) * dx;
				var rz = zx0 + (zx1 - zx0) * dy;
				if( Math.abs(z - rz) < dz )
					return rz;
			}
		return height(Std.int(x), Std.int(y), z);
	}
	
	public function build( c : Context ) {
		indexes = c.createIndexBuffer(MAX_VERT);
		var indices = new flash.Vector<UInt>();
		for( i in 0...MAX_VERT )
			indices[i] = i;
		indexes.uploadFromVector(indices, 0, MAX_VERT);
		vgrounds = allocVBuf(c, ground);
		vwalls = allocVBuf(c, walls);
	}
	
	function allocVBuf( c : Context, b : FBuf ) {
		var pos = 0;
		var nvert = Std.int(b.length / STRIDE);
		var bufs = [];
		var btmp = new FBuf();
		while( nvert > 0 ) {
			var vbuf = c.createVertexBuffer(MAX_VERT, STRIDE);
			var size = nvert < MAX_VERT ? nvert : MAX_VERT;
			for( i in 0...size * STRIDE )
				btmp[i] = b[pos * STRIDE + i];
			vbuf.uploadFromVector(btmp, 0, size);
			if( size < MAX_VERT )
				vbuf.uploadFromVector(empty, size, MAX_VERT - size);
			bufs.push({ b : vbuf, n : Std.int(size/3) });
			pos += size;
			nvert -= size;
		}
		return bufs;
	}
	
	
}