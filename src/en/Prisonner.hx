package en;

class Prisonner extends Unit {
	public function new(ldtkEnt : LDtkMap.LDtkMap_Entity) {
		super(ldtkEnt.identifier);
		spr.set(ldtkEnt.identifier);
		spr.setCenterRatio(ldtkEnt.pivotX, ldtkEnt.pivotY);
		setPosCell(ldtkEnt.cx, ldtkEnt.cy);
	}

	override function preUpdate() {
		super.preUpdate();
	}
}