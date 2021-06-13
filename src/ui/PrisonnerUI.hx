package ui;

import hxd.Key;
import en.Prisonner;
import h2d.Object;

@:access(en.Prisonner)
class PrisonnerUI extends Object {
	
	public var p(default, set) : en.Prisonner;
	public function set_p(p : en.Prisonner) {
		this.p = p;
		updateKeys();
		return this.p;
	}

	var hearts = new Array<h2d.Bitmap>();

	public function new(parent) {
		super(parent);
	}

	public function updateHearts() {
		if (p.maxLife > hearts.length) { // Add hearts
			for (i in hearts.length...p.maxLife) {
				var heart = new h2d.Bitmap(Assets.ui.getTile("Heart"), this);
				hearts.push(heart);
			}
		} else { // Remove hearts
			for (i in p.maxLife...hearts.length) {
				hearts[i].remove();
			}
			hearts.resize(p.maxLife);
		}

		if (hearts.length > 0) {
			var space = -2;
			var x = -hearts.length * (hearts[0].tile.width + space) + space;
			var y = 0.;
			var s = .3;
			for (h in hearts) {
				h.x = x;
				h.y = y + s * hearts[0].tile.height;
				x += hearts[0].tile.width + space;
				s = -s;
			}
		}

		for (i in p.life...hearts.length) {
			hearts[i].visible = false;
		}
		for (i in 0...p.life) {
			hearts[i].visible = true;
		}
	}

	public function updateKeys() {
		var x = 25.;
		var y = 0.;
		for (d in p.mvKeys) {
			var padKey = switch d {
				case UP(k): k;
				case DOWN(k): k;
				case LEFT(k): k;
				case RIGHT(k): k;
				case _: null;
			};
			var key = Main.ME.controller.getPrimaryKey(padKey);
			var keyName = switch key {
				case Key.A: 'A';
				case Key.Z: 'Z';
				case Key.Q: 'Q';
				case Key.S: 'S';
				case Key.D: 'D';
				case Key.W: 'W';
				case Key.I: 'I';
				case Key.J: 'J';
				case Key.K: 'K';
				case Key.L: 'L';
				case _: '';
			};
			var keyBtn = new KeyButton(keyName);
			keyBtn.setScale(2);
			addChild(keyBtn);
			if (y <= 0) {
				y -= keyBtn.getSize().height * .5;
				keyBtn.x = x;
				keyBtn.y = y;
				x -= keyBtn.getSize().width;
				y += keyBtn.getSize().height;
			} else {
				keyBtn.x = x;
				keyBtn.y = y;
				x += keyBtn.getSize().width;
			}
		}
	}
}