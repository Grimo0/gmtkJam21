package ui;

import h2d.Object;

class KeyButton extends h2d.Object {
	var bg : HSprite;
	
	public function new(k : String) {
		super();
		bg = new HSprite(Assets.ui, 'Key', this);

		var tf = new h2d.Text(Assets.fontPixel, this);
		tf.text = k;
		tf.textAlign = Center;
		tf.maxWidth = bg.tile.width;
	}
}