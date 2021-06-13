package ui;

class SuccessScreen extends dn.Process {
	
	public var pxWid(get, never) : Int;
	function get_pxWid() return M.ceil(w() / Const.SCALE);

	public var pxHei(get, never) : Int;
	function get_pxHei() return M.ceil(h() / Const.SCALE);

	var ca : dn.heaps.Controller.ControllerAccess;
	var group = new h2d.Object();
	var level : Level;

	public function new() {
		super(Game.ME);

		createRootInLayers(Game.ME.root, Const.MAIN_LAYER_UI);

		Game.ME.level.root.alpha = 0;
		Game.ME.hud.root.visible = false;

		level = new Level();
		level.currLevel = Assets.world.all_levels.LevelGameOver;

		root.addChild(group);

		var tf = new h2d.Text(Assets.fontLarge, group);
		tf.text = Lang.t._('You did it you found liberty !\nYOUHOU !!!\nPress Escape to try again.');
		tf.textAlign = Center;
		
		ca = Main.ME.controller.createAccess("GameOver", true);
		
		dn.Process.resizeAll();
	}

	override function onDispose() {
		super.onDispose();
		ca.dispose();
		level.destroy();
		Game.ME.level.root.alpha = 1;
		Game.ME.hud.root.visible = true;
	}

	override function onResize() {
		super.onResize();
		root.scale(Const.SCALE);
		group.x = pxWid * .5;
		group.y = pxHei * .25;
	}

	override function postUpdate() {
		super.postUpdate();
	}

	override function update() {
		super.update();
		if (ca.bPressed() || ca.isKeyboardPressed(hxd.Key.ESCAPE))
			close();
	}

	function onClose() {
		delayer.addF(Main.ME.startGame, 1);
	}

	public function close() {
		if (!destroyed) {
			destroy();
			onClose();
		}
	}
}