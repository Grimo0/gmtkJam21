package en;

import ui.SuccessScreen;
import dn.heaps.GamePad.PadKey;
import ui.PrisonerUI;

enum EDirection {
	UP(k:PadKey);
	DOWN(k:PadKey);
	LEFT(k:PadKey);
	RIGHT(k:PadKey);
}

class Prisoner extends Unit {
	
	public var ui(get, never) : PrisonerUI;
	public inline function get_ui() : PrisonerUI {
		if (entityType == Prisoner1)
			return game.hud.p1UI;
		return game.hud.p2UI;
	}

	var entityType : LDtkMap.EntityEnum;
	var mvKeys = new Array<EDirection>();
	var mvBeforeX : Int;
	var mvBeforeY : Int;
	var mvToX : Int;
	var mvToY : Int;
	var mvSpd = .2;
	var frameToReact = 0.;
	public var mvDirection : EDirection = null;
	public var compagnon : Prisoner = null;

	override function set_maxLife(v:Int):Int {
		super.set_maxLife(v);
		ui.updateHearts();
		return maxLife;
	}
	override function set_life(v:Int):Int {
		super.set_life(v);
		ui.updateHearts();
		return life;
	}

	public function new(ldtkEnt : LDtkMap.LDtkMap_Entity) {
		entityType = ldtkEnt.entityType;
		if (ldtkEnt.entityType == Prisoner1) {
			mvKeys.push(UP(AXIS_LEFT_Y_POS));
			mvKeys.push(LEFT(AXIS_LEFT_X_NEG));
			mvKeys.push(DOWN(AXIS_LEFT_Y_NEG));
			mvKeys.push(RIGHT(AXIS_LEFT_X_POS));
			game.hud.p1UI.p = this;
		} else {
			mvKeys.push(UP(AXIS_RIGHT_Y_POS));
			mvKeys.push(LEFT(AXIS_RIGHT_X_NEG));
			mvKeys.push(DOWN(AXIS_RIGHT_Y_NEG));
			mvKeys.push(RIGHT(AXIS_RIGHT_X_POS));
			game.hud.p2UI.p = this;
		}

		super(ldtkEnt.identifier);

		spr.setCenterRatio(ldtkEnt.pivotX, ldtkEnt.pivotY);
		setPosCell(ldtkEnt.cx, ldtkEnt.cy);

		frictX = 1;
		frictY = 1;
		maxLife = 5;
		life = maxLife;
		frameToReact = .4 / mvSpd;
	}

	function stopMove(canceled : Bool) {
		mvDirection = null;
		mvToX = mvToY = 0;
		dx = dy = 0;
		if (canceled) {
			cx = mvBeforeX;
			cy = mvBeforeY;
		}
		xr = yr = .5;
		cd.unset('compagnonFollowed');
	}

	override function onDie() {
		game.gameOver();
	}

	override function preUpdate() {
		super.preUpdate();

		if (mvDirection != null)
			return;

		mvBeforeX = cx;
		mvBeforeY = cy;
		mvToX = cx;
		mvToY = cy;

		for (d in mvKeys) {
			var k = d.getParameters()[0];
			if (!game.ca.isPressed(k)) continue;
			switch d {
				case UP(k): 
					mvToY = cy - 1;
				case DOWN(k): 
					mvToY = cy + 1;
				case LEFT(k): 
					mvToX = cx - 1;
				case RIGHT(k): 
					mvToX = cx + 1;
			}
			
			mvDirection = d;

			if (mvToY > cy)
				dy = mvSpd;
			else if (mvToY < cy)
				dy = -mvSpd;
			if (mvToX > cx)
				dx = mvSpd;
			else if (mvToX < cx)
				dx = -mvSpd;

			// Can't move
			if (level.hasCollision(mvToX, mvToY)) {
				if (level.getFloor(mvToX, mvToY) == 4) { // door
					game.sucess();
					return;
				} else {
					mvToX = mvToY = 0;
					cd.setF('compagnonFollowed', frameToReact * .5);
					cd.onComplete('compagnonFollowed', () -> {
						stopMove(true);
						compagnon.stopMove(true);
					});
					continue;
				}
			}

			// The compagnon didn't move or they didn't went the same way
			cd.setF('compagnonFollowed', frameToReact);
			cd.onComplete('compagnonFollowed', () -> {
				if (compagnon != null) {
					if (compagnon.mvDirection == null) {
						stopMove(true);
						compagnon.stopMove(true);
						// The compagnon is dragged down -1HP for them
						compagnon.hit(1, this);
					} else if (compagnon.mvDirection.getIndex() != d.getIndex()) {
						stopMove(true);
						compagnon.stopMove(true);
						// The compagnon and I collides -1HP for both
						hit(1, this);
						compagnon.hit(1, compagnon);
					} else if (compagnon.dx == 0 && compagnon.dy == 0) {
						stopMove(true);
						compagnon.stopMove(true);
					}
				}
			});

			break;
		}
	}

	override function update() {
		super.update();

		if (mvDirection == null)
			return;

		if (dy < 0) {
			if (cy == mvToY && yr <= .5) {
				stopMove(false);
			}
		} else if (dy > 0) {
			if (cy == mvToY && yr >= .5) {
				stopMove(false);
			}
		}

		if (dx < 0) {
			if (cx == mvToX && xr <= .5) {
				stopMove(false);
			}
		} else if (dx > 0) {
			if (cx == mvToX && xr >= .5) {
				stopMove(false);
			}
		}
	}
}