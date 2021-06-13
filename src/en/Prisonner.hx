package en;

import dn.heaps.GamePad.PadKey;

enum Directions {
	UP(k:PadKey);
	DOWN(k:PadKey);
	LEFT(k:PadKey);
	RIGHT(k:PadKey);
}

class Prisonner extends Unit {
	var keys = new Array<Directions>();
	var mvToX : Int;
	var mvToY : Int;
	var mvSpd = .5;

	public function new(ldtkEnt : LDtkMap.LDtkMap_Entity) {
		super(ldtkEnt.identifier);
		spr.set(ldtkEnt.identifier);
		spr.setCenterRatio(ldtkEnt.pivotX, ldtkEnt.pivotY);
		setPosCell(ldtkEnt.cx, ldtkEnt.cy);

		keys.push(UP(AXIS_LEFT_Y_POS));
		keys.push(DOWN(AXIS_LEFT_Y_NEG));
		keys.push(LEFT(AXIS_LEFT_X_NEG));
		keys.push(RIGHT(AXIS_LEFT_X_POS));

		frictX = 1;
		frictY = 1;
	}

	override function preUpdate() {
		super.preUpdate();

		for (d in keys) {
			var k = d.getParameters()[0];
			if (!game.ca.isPressed(k)) continue;
			switch d {
				case UP(k): 
					if (level.hasCollision(cx, cy - 1))
						continue;
					dy = -mvSpd;
					mvToY = cy - 1;
				case DOWN(k): 
					if (level.hasCollision(cx, cy + 1))
						continue;
					dy = mvSpd;
					mvToY = cy + 1;
				case LEFT(k): 
					if (level.hasCollision(cx - 1, cy))
						continue;
					dx = -mvSpd;
					mvToX = cx - 1;
				case RIGHT(k): 
					if (level.hasCollision(cx + 1, cy))
						continue;
					dx = mvSpd;
					mvToX = cx + 1;
			}
		}
	}

	override function update() {
		super.update();

		if (dy < 0) {
			if (cy == mvToY && yr <= .5) {
				yr = .5;
				dy = 0;
			}
		} else if (dy > 0) {
			if (cy == mvToY && yr >= .5) {
				yr = .5;
				dy = 0;
			}
		} else if (dx < 0) {
			if (cx == mvToX && xr <= .5) {
				xr = .5;
				dx = 0;
			}
		} else if (dx > 0) {
			if (cx == mvToX && xr >= .5) {
				xr = .5;
				dx = 0;
			}
		}
	}
}