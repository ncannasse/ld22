class Boot {

	public static function main() {
		var vreg = ~/^[^ ]+ ([0-9]+),([0-9]+),([0-9]+)/;
		vreg.match(flash.system.Capabilities.version);
		var maj = Std.parseInt(vreg.matched(1));
		if( maj < 11 )
			haxe.Log.trace("This game requires Flash Player 11+, please install it from http://get.adobe.com/flash", null);
		else {
			var l = new flash.display.Loader();
			flash.Lib.current.stage.addChild(l);
			l.load(new flash.net.URLRequest("ld22.swf"));
		}
	}
	
}