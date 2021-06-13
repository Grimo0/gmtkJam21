import en.Prisonner;
import h2d.Bitmap;
import h2d.Tile;
import LDtkMap;

class Level extends dn.Process {
	var game(get, never) : Game; inline function get_game() return Game.ME;
	var fx(get, never) : Fx; inline function get_fx() return game.fx;

	public var currLevel(default, set) : LDtkMap.LDtkMap_Level;
	public function set_currLevel(l : LDtkMap.LDtkMap_Level) {
		currLevel = l;
		Const.GRID = gridSize;
		initLevel();
		return currLevel;
	}

	public var gridSize(get, never) : Int;
	inline function get_gridSize() return currLevel.l_Floor.gridSize * 2;

	public var cWid(get, never) : Int; inline function get_cWid() return currLevel.l_Floor.cWid;
	public var cHei(get, never) : Int; inline function get_cHei() return currLevel.l_Floor.cHei;
	public var pxWid(get, never) : Int; inline function get_pxWid() return currLevel.pxWid * 2;
	public var pxHei(get, never) : Int; inline function get_pxHei() return currLevel.pxHei * 2;

	public function new() {
		super(game);
		createRootInLayers(game.scroller, Const.GAME_SCROLLER_LEVEL);
	}

	public inline function isValid(cx, cy) return cx >= 0 && cx < cWid && cy >= 0 && cy < cHei;

	public inline function coordId(cx, cy) return cx + cy * cWid;

	public inline function hasCollision(cx, cy) : Bool 
		return currLevel.l_Floor.getInt(cx, cy) >= 3 // Walls
			|| currLevel.l_Props.getInt(cx, cy) > 0; // Any props

	public inline function getFloor(cx, cy) : Int
		return currLevel.l_Floor.getInt(cx, cy);

	override function init() {
		super.init();

		if (root != null)
			initLevel();
	}

	public function initLevel() {
		game.scroller.add(root, Const.GAME_SCROLLER_LEVEL);
		root.removeChildren();

		// Get level background image
		if (currLevel.hasBgImage()) {
			var background = currLevel.getBgBitmap();
			root.add(background, Const.GAME_LEVEL_BG);
		} else {
			root.add(new Bitmap(Tile.fromColor(currLevel.bgColor, pxWid, pxHei)), Const.GAME_LEVEL_BG);
		}

		// Layers - floor
		var layerRendered = currLevel.l_Floor.render();
		layerRendered.alpha = currLevel.l_Floor.opacity;
		layerRendered.setScale(2);
		root.add(layerRendered, Const.GAME_LEVEL_FLOOR);

		layerRendered = currLevel.l_FloorShadowAutoLayer.render();
		layerRendered.alpha = currLevel.l_FloorShadowAutoLayer.opacity;
		layerRendered.setScale(2);
		root.add(layerRendered, Const.GAME_LEVEL_FLOOR);

		layerRendered = currLevel.l_FloorAutoLayer.render();
		layerRendered.alpha = currLevel.l_FloorAutoLayer.opacity;
		layerRendered.setScale(2);
		root.add(layerRendered, Const.GAME_LEVEL_FLOOR);

		layerRendered = currLevel.l_PropsShadowAutoLayer.render();
		layerRendered.alpha = currLevel.l_PropsShadowAutoLayer.opacity;
		layerRendered.setScale(2);
		root.add(layerRendered, Const.GAME_LEVEL_FLOOR);

		layerRendered = currLevel.l_Props.render();
		layerRendered.alpha = currLevel.l_Props.opacity;
		layerRendered.setScale(2);
		root.add(layerRendered, Const.GAME_LEVEL_FLOOR);

		// Layers - ceiling
		layerRendered = currLevel.l_PropsAutoLayer.render();
		layerRendered.alpha = currLevel.l_PropsAutoLayer.opacity;
		layerRendered.setScale(2);
		root.add(layerRendered, Const.GAME_LEVEL_CEILING);

		// Player
		var p1 = new en.Prisonner(currLevel.l_Entities.all_Prisonner1[0]);
		var p2 = new en.Prisonner(currLevel.l_Entities.all_Prisonner2[0]);
		p1.compagnon = p2;
		p2.compagnon = p1;
	}

	override function onResize() {
		if (currLevel == null)
			return;
		super.onResize();
	}

	public function render() {}

	override function postUpdate() {
		super.postUpdate();

		render();
	}
}
