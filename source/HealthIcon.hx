package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-old', [2, 3], 0, false, isPlayer);
		animation.add('girlfriend', [4, 5], 0, false, isPlayer);
		animation.add('girlfriend-car', [4, 5], 0, false, isPlayer);
		animation.add('demongf', [6, 7], 0, false, isPlayer);
		animation.add('dad', [8, 9], 0, false, isPlayer);
		animation.play(char);
		scrollFactor.set();
	}

	public function changeIcon(char:String, ?isPlayer:Bool = false)
	{
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-old', [2, 3], 0, false, isPlayer);
		animation.add('girlfriend', [4, 5], 0, false, isPlayer);
		animation.add('girlfriend-car', [4, 5], 0, false, isPlayer);
		animation.add('demongf', [6, 7], 0, false, isPlayer);
		animation.add('dad', [8, 9], 0, false, isPlayer);
		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
