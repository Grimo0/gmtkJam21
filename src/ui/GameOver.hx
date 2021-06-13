package ui;

class GameOver extends dn.Process {

	var ca : dn.heaps.Controller.ControllerAccess;
	var group = new h2d.Object();
	
	public var pxWid(get, never) : Int;
	function get_pxWid() return M.ceil(w() / Const.SCALE);

	public var pxHei(get, never) : Int;
	function get_pxHei() return M.ceil(h() / Const.SCALE);

	public function new() {
		super(Game.ME);

		createRootInLayers(Game.ME.root, Const.MAIN_LAYER_UI);

		Game.ME.level.root.alpha = 0;

		var level = new Level();
		level.currLevel = Assets.world.all_levels.LevelGameOver;
		var tombs = Assets.ui.getBitmap('gameOver', level.root);
		tombs.setScale(2);
		tombs.x = (level.pxWid - tombs.tile.width * tombs.scaleX) * .5;
		tombs.y = level.pxHei * 7/8 - tombs.tile.height * tombs.scaleY;

		root.addChild(group);

		var tf = new h2d.Text(Assets.fontLarge, group);
		tf.text = Lang.t._('You didn\'t found liberty.\nPress Escape to try again.');
		tf.textAlign = Center;
		
		ca = Main.ME.controller.createAccess("GameOver", true);
		
		dn.Process.resizeAll();
	}

	override function onDispose() {
		super.onDispose();
		ca.dispose();
		Game.ME.level.root.alpha = 1;
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