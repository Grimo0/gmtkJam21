package en;

import h2d.Bitmap;

class Unit extends Entity {
	public var id(default, null) : String;

	var hearts = new Array<h2d.Bitmap>();

	public var maxLife(default, set) : Int;
	public function set_maxLife(v : Int) {
		if (v > maxLife) { // Add hearts
			for (i in maxLife...v) {
				var heart = new h2d.Bitmap(Assets.ui.getTile("Heart"), spr);
				hearts.push(heart);
			}
		} else { // Remove hearts
			for (i in v...hearts.length) {
				hearts[i].remove();
			}
			hearts.resize(v);
		}

		if (hearts.length > 0) {
			var space = -2;
			var x = -hearts.length * .5 * (hearts[0].tile.width + space) + space;
			var y = -spr.frameData.hei * .5 - hearts[0].tile.height;
			var s = .3;
			for (h in hearts) {
				h.x = x;
				h.y = y + s * hearts[0].tile.height;
				x += hearts[0].tile.width + space;
				s = -s;
			}
		}

		return maxLife = v;
	}
	public var life(default, set) : Int;
	public function set_life(v : Int) {
		if (v > maxLife)
			v = Std.int(maxLife);
		// Gaining life
		for (i in life...v) {
			hearts[i].visible = true;
		}
		for (i in v...life) {
			hearts[i].visible = false;
		}
		return life = v;
	}

	public var lastDmgSource(default, null) : Null<Entity> = null;

	public function new(id : String) {
		super(Assets.entities);
		this.id = id;
		spr.set(id);

		reset();
	}

	public function reset() {
		life = maxLife;
	}

	public inline function isDead() {
		return life <= 0;
	}

	public function hit(dmg : Int, from : Null<Entity>) {
		if (isDead() || dmg <= 0)
			return;

		life = M.iclamp(life - dmg, 0, Std.int(maxLife));
		lastDmgSource = from;
		onDamage(dmg, from);
		if (life <= 0)
			onDie();
	}

	public function kill(by : Null<Entity>) {
		if (!isDead())
			hit(life, by);
	}

	function onDamage(dmg : Int, from : Entity) {}

	function onDie() {
		// destroy();
	}
}
