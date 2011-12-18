import T;

class TerminalShader extends Shader {
	
	static var SRC = {
		var input : {
			pos : Float3,
			normal : Float3,
		};
		var fog : Float;
		var tn : Float3;
		var li : Float;
		function vertex( mproj : M44, mrot : M44, light : Float3 ) {
			var tmp = pos.xyzw;
			tmp.xy *= 1 - tmp.z;
			var tpos = tmp * mproj;
			li = normal.dot(light).sat() * 0.5 + 0.5;
			fog = (1 - (tpos.z * 0.0035).sqrt().sat());
			tn = (pos * mrot * mproj).normalize().sat();
			out = tpos;
		}
		function fragment( color : Int, fogColor : Int ) {
			var tmp = color;
			tmp.rgb *= tn;
			tmp = tmp * 0.3 + fogColor * 0.7;
			tmp.rgb *= li;
			tmp.a *= fog;
			out = tmp;
		}
	}
}

class StarShader extends Shader {
	
	static var SRC = {
		var input : {
			pos : Float3,
		};
		var fog : Float;
		function vertex( mproj : M44, maxDist : Float ) {
			var tpos = pos.xyzw * mproj;
			fog = (1 - (tpos.z * 0.0035).sqrt().sat()) * (1 - pos.xyz.length() / maxDist);
			out = tpos;
		}
		function fragment( color : Int ) {
			var tmp = color;
			tmp.a *= fog;
			out = tmp;
		}
	}
}

class LightShader extends Shader {
	
	static var SRC = {
		var input : {
			pos : Float3,
			alpha : Float,
		};
		var fog : Float;
		function vertex( mproj : M44, t : Float ) {
			var tpos = pos.xyzw * mproj;
			fog = (1 - (tpos.z * 0.0035).sqrt().sat()) * (alpha + t * alpha * 0.5).sin().abs();
			out = tpos;
		}
		function fragment( color : Int ) {
			var tmp = color;
			tmp.a *= fog;
			out = tmp;
		}
	}
	
}

class SnowShader extends Shader {
	
	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
		};
		var tuv : Float2;
		function vertex( mproj : M44 ) {
			var tmp = pos.xyzw * mproj;
			out = tmp;
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv);
		}
	}
	
}

class GroundShader extends Shader {

	static var SRC = {
		var input : {
			pos : Float3,
			normal : Float3,
		};
		var fog : Float;
		var rn : Float3;
		var uv : Float2;
				
		function vertex( mproj : M44, t : Float ) {
			var tpos = pos.xyzw * mproj;
			rn = normal;
			uv = (pos.xy + [t,t*2]) / 255.99;
			fog = (tpos.z * 0.0035).sqrt().sat();
			out = tpos;
		}
		function fragment( fogColor : Int, light : Float3, tex : Texture ) {
			var li = light.dot(rn) * 0.5 + 1;
			out = (tex.get(uv,wrap) * li) * (1 - fog) + fog * fogColor;
		}
	};

}

class WallShader extends Shader {

	static var SRC = {
		var input : {
			pos : Float3,
			normal : Float3,
		};
		var fog : Float;
		var rn : Float3;
				
		function vertex( mproj : M44, cam : Float3, t : Float ) {
			var tpos = pos.xyzw * mproj;
			var n = normal;
			n.z -= (pos.z - cam.z) * 0.03;
			n.x += ((pos.x + t) * 0.3).sin() * 0.5;
			n.y += ((pos.y + t) * 0.3).sin() * 0.5;
			rn = n.normalize();
			fog = (tpos.z * 0.0035).sqrt().sat();
			out = tpos;
		}
		function fragment( color : Int, fogColor : Int, light : Float3 ) {
			var li = light.dot(rn).sat() * 0.6 + 0.4;
			out = (color * li) * (1 - fog) + fog * fogColor;
		}
	};

}
