import h2d.Bitmap;
import h2d.Tile;

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
	public var pxWid(get, never) : Int; inline function get_pxWid() return currLevel.pxWid;
	public var pxHei(get, never) : Int; inline function get_pxHei() return currLevel.pxHei;

	public function new() {
		super(game);
		createRootInLayers(game.scroller, Const.GAME_SCROLLER_LEVEL);
	}

	public inline function isValid(cx, cy) return cx >= 0 && cx < cWid && cy >= 0 && cy < cHei;

	public inline function coordId(cx, cy) return cx + cy * cWid;

	public inline function hasCollision(cx, cy) : Bool
		return false; // TODO: collision with entities and obstacles

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
		layerRendered = currLevel.l_PropsShadowAutoLayer.render();
		layerRendered.alpha = currLevel.l_PropsShadowAutoLayer.opacity;
		layerRendered.setScale(2);
		root.add(layerRendered, Const.GAME_LEVEL_FLOOR);
		layerRendered = currLevel.l_Props.render();
		layerRendered.alpha = currLevel.l_Props.opacity;
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

		// Layers - ceiling
		layerRendered = currLevel.l_PropsAutoLayer.render();
		layerRendered.alpha = currLevel.l_PropsAutoLayer.opacity;
		layerRendered.setScale(2);
		root.add(layerRendered, Const.GAME_LEVEL_CEILING);
		
		/* var rootLayer = Const.GAME_LEVEL_FLOOR;
		for (i in 0...currLevel.allUntypedLayers.length) {
			var layer = currLevel.allUntypedLayers[currLevel.allUntypedLayers.length - 1 - i];
			if (!layer.visible) continue;
			if (layer.type == Entities) {
				rootLayer = Const.GAME_LEVEL_CEILING;
				continue;
			}

			root.add(currLevel.l_Floor.render(), rootLayer);
		} */

		// Player
		for (p in currLevel.l_Entities.getAllUntyped()) { // TODO: Change getAllUntyped for your alls
			// Create the entity
			var pEnt = new en.Entity(Assets.entities);
			pEnt.spr.set(p.identifier);
			pEnt.spr.tile.setCenterRatio(p.pivotX, p.pivotY);
			pEnt.spr.tile.scaleToSize(p.width, p.height);
			pEnt.setPosCell(p.cx, p.cy);
		};
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
