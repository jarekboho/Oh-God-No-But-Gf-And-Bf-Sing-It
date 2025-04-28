package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				tex = Paths.getSparrowAtlas('GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Dancing Beat', 24, false);
				animation.addByPrefix('singLEFT', 'GF Dancing Beat', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Dancing Beat', 24, false);
				animation.addByPrefix('singUP', 'GF Dancing Beat', 24, false);
				animation.addByPrefix('singDOWN', 'GF Dancing Beat', 24, false);
				animation.addByIndices('sad', 'GF Dancing Beat', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF Dancing Beat', 24);

				addOffset('cheer', 0, -9);
				addOffset('sad', 0, -9);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, -9);
				addOffset("singRIGHT", 0, -9);
				addOffset("singLEFT", 0, -9);
				addOffset("singDOWN", 0, -9);
				addOffset('hairBlow', 0, -9);
				addOffset('hairFall', 0, -9);

				addOffset('scared', 0, -9);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", 1, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 29, -6);
				addOffset("singDOWN", -23, -41);
				addOffset("singUPmiss", 1, 19);
				addOffset("singRIGHTmiss", -30, 16);
				addOffset("singLEFTmiss", 29, 17);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", -3, 4);
				addOffset('firstDeath', -2, 5);
				addOffset('deathLoop', -3, 0);
				addOffset('deathConfirm', -2, 52);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

				setGraphicSize(Std.int(width * 0.75));

			case 'bf-car':
				var tex = Paths.getSparrowAtlas('bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -1, 27);
				addOffset("singRIGHT", -33, -5);
				addOffset("singLEFT", 31, -4);
				addOffset("singDOWN", -24, -42);
				addOffset("singUPmiss", -3, 22);
				addOffset("singRIGHTmiss", -33, 17);
				addOffset("singLEFTmiss", 28, 18);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;

				setGraphicSize(Std.int(width * 0.9));

			case 'girlfriend':
				tex = Paths.getSparrowAtlas('Girlfriend/Girlfriend');
				frames = tex;
				animation.addByPrefix('idle', 'Girlfriend idle dance', 24);
				animation.addByPrefix('singUP', 'Girlfriend Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Girlfriend Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Girlfriend Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Girlfriend Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 40);
				addOffset("singRIGHT", 10, -23);
				addOffset("singLEFT", 30, 30);
				addOffset("singDOWN", 20, -40);

				playAnim('idle');

			case 'girlfriend-car':
				tex = Paths.getSparrowAtlas('Girlfriend/GirlfriendCar');
				frames = tex;

				animation.addByPrefix('idle', "Girlfriend Idle", 24, false);
				animation.addByPrefix('singUP', "Girlfriend Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "Girlfriend DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Girlfriend Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Girlfriend Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 60);
				addOffset("singRIGHT", -38, -21);
				addOffset("singLEFT", 55, -70);
				addOffset("singDOWN", 3, -205);

				playAnim('idle');

			case 'demongf':
				tex = Paths.getSparrowAtlas('Girlfriend/Demon');
				frames = tex;

				animation.addByPrefix('idle', "Demon Idle", 24, false);
				animation.addByPrefix('singUP', "Demon Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "Demon DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Demon Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Demon Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", -43, -5);
				addOffset("singLEFT", 89, -29);
				addOffset("singRIGHT", -185, -26);
				addOffset("singDOWN", 139, -171);

				playAnim('idle');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('DADDY_DEAREST','shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			if (!curCharacter.startsWith('bf'))
			{
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}

			if (curCharacter.startsWith('bf'))
			{
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
		if (!isPlayer)
		{
			if (curCharacter.startsWith('girlfriend') || curCharacter == 'demongf')
			{
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
