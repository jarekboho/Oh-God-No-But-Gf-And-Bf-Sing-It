package;

import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.addons.text.FlxTypeText;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	
	#if desktop
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var floatshit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camOther:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;

	var fc:Bool = true;

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	
	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	var red:FlxSprite;

	var gfEvil:FlxSprite;

	var transform:FlxSound;

	var bgLimo:FlxSprite;

	var playerStrumsx0:Float = 0;
	var playerStrumsx1:Float = 0;
	var playerStrumsx2:Float = 0;
	var playerStrumsx3:Float = 0;
	var strumLineNotesx0:Float = 0;
	var strumLineNotesx1:Float = 0;
	var strumLineNotesx2:Float = 0;
	var strumLineNotesx3:Float = 0;

	var bgFade:FlxSprite;
	var box:FlxSprite;

	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	var portraitgf2:FlxSprite;

	var blackBarThingie:FlxSprite;

	var timeBeat:Float = 1;
	var totalBeat:Int = 0;

	var blackOGNThingie:FlxSprite;

	var shaderOGN:Float = 0;

	override public function create()
	{

		if (FlxG.save.data.etternaMode)
			Conductor.safeFrames = 5;
		else
			Conductor.safeFrames = 10;


		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if desktop

		detailsPausedText = "Paused - " + detailsText;

		DiscordClient.changePresence(detailsText + " " + SONG.song + "" + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , 'girlfriend');
		#end

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camOther);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('oh-god-no');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					bgLimo = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
					}

				blackOGNThingie = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				blackOGNThingie.setGraphicSize(Std.int(blackOGNThingie.width * 10));
				blackOGNThingie.alpha = 0;
				add(blackOGNThingie);

		boyfriend = new Boyfriend(770, 450, 'bf');
		add(boyfriend);

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));

		transform = new FlxSound().loadEmbedded(Paths.sound('transform'));
		FlxG.sound.list.add(transform);

		gf = new Character(400, 130, 'gf-car');
		gf.scrollFactor.set(0.95, 0.95);

					var demongf:Character = new Character(0, 0, 'demongf');
					add(demongf);
					demongf.alpha = 0.00001;
					var girlfriendcar:Character = new Character(0, 0, 'girlfriend-car');
					add(girlfriendcar);
					girlfriendcar.alpha = 0.00001;
					var bfcar:Boyfriend = new Boyfriend(0, 0, 'bf-car');
					add(bfcar);
					bfcar.alpha = 0.00001;

		dad = new Character(100, 100, 'girlfriend');

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'girlfriend':
				camPos.x += 400;
			case "girlfriend-car":
			    dad.x += 120;
				dad.y -= 30;
			case "demongf":
			    dad.x += 87;
				dad.y += 70;
		}

		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				dad.y -= 30;
				dad.x -= 80;

				resetFastCar();
				add(fastCar);
		}

		add(gf);

		if (curStage == 'limo')
			add(limo);

		add(dad);
		dad.flipX = true;
		boyfriend.flipX = true;
		boyfriend.scrollFactor.set(0.4, 0.4);

		dad.x = 1030;
		dad.y = -175;
		boyfriend.x = 225;
		boyfriend.y = 175;

		red = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

				add(red);
				red.alpha = 0;

		gfEvil = new FlxSprite();
	    gfEvil.frames = Paths.getSparrowAtlas('weeb/gfCrazy');
     	gfEvil.animation.addByPrefix('idle', 'Animation', 24, false);
						add(gfEvil);
						gfEvil.alpha = 0;
		gfEvil.flipX = true;
		gfEvil.x = dad.x;
		gfEvil.y = dad.y;

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		bgFade.visible = false;

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [6], "", 24);
				box.setGraphicSize(Std.int(box.width * 0.2));
				box.updateHitbox();
				box.y = 450;
				box.x = 0;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		box.visible = false;

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);
		dropText.visible = false;

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		swagDialogue.visible = false;

		portraitgf2 = new FlxSprite(650, 150);
		portraitgf2.frames = Paths.getSparrowAtlas('weeb/GFPortrait');
		portraitgf2.animation.addByPrefix('enter', 'gf portrait mad', 24, false);
		add(portraitgf2);
		portraitgf2.flipX = true;
		portraitgf2.visible = false;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set(0.4, 0.4);
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition)
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,"Oh God No", 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFF66FF33, 0xFFFF0000);
		add(healthBar);

		var kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,"Oh God No" + " - KE " + "1.4" + " - " + (FlxG.save.data.etternaMode ? "E.Mode" : "FNF"), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
			{
				add(replayTxt);
			}

		iconP1 = new HealthIcon('bf', true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon('girlfriend', false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

			blackBarThingie = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			blackBarThingie.setGraphicSize(Std.int(blackBarThingie.width * 10));
			blackBarThingie.alpha = 0;
			add(blackBarThingie);

			boyfriend.shader = new SilhouetteShader(49,176,209);
			dad.shader = new SilhouetteALTShader(165,0,77);

		blackBarThingie.cameras = [camOther];
		bgFade.cameras = [camOther];
		box.cameras = [camOther];
		dropText.cameras = [camOther];
		swagDialogue.cameras = [camOther];
		portraitgf2.cameras = [camOther];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		startingSong = true;

		startCountdown();

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function transformation():Void
	{
		gfEvil.x = dad.x;
		gfEvil.y = dad.y;
				red.alpha = 1;
				gfEvil.alpha = 1;
		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
								gfEvil.animation.play('idle');
								transform.play();
						});
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		playerStrumsx0 = playerStrums.members[0].x + 250;
		playerStrumsx1 = playerStrums.members[1].x + 250;
		playerStrumsx2 = playerStrums.members[2].x + 250;
		playerStrumsx3 = playerStrums.members[3].x + 250;
		strumLineNotesx0 = strumLineNotes.members[0].x + 150;
		strumLineNotesx1 = strumLineNotes.members[1].x + 150;
		strumLineNotesx2 = strumLineNotes.members[2].x + 150;
		strumLineNotesx3 = strumLineNotes.members[3].x + 150;

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

		if (isStoryMode)
		{
			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}
		}

			swagCounter += 1;
		}, 5);

		camHUD.visible = false;
		camZooming = false;
		playerStrums.members[0].visible = false;
		playerStrums.members[1].visible = false;
		playerStrums.members[2].visible = false;
		playerStrums.members[3].visible = false;
		strumLineNotes.members[0].visible = false;
		strumLineNotes.members[1].visible = false;
		strumLineNotes.members[2].visible = false;
		strumLineNotes.members[3].visible = false;
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
			{
				remove(songPosBG);
				remove(songPosBar);
				remove(songName);

				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);

				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, songLength - 1000);
				songPosBar.numDivisions = 1000;
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,"Oh God No", 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);

				songPosBG.cameras = [camHUD];
				songPosBar.cameras = [camHUD];
				songName.cameras = [camHUD];
			}

		#if desktop
		DiscordClient.changePresence(detailsText + " " + SONG.song + "" + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , 'girlfriend');
		#end

		playerStrums.members[0].x = strumLineNotesx0;
		playerStrums.members[1].x = strumLineNotesx1;
		playerStrums.members[2].x = strumLineNotesx2;
		playerStrums.members[3].x = strumLineNotesx3;
		strumLineNotes.members[0].x = playerStrumsx0;
		strumLineNotes.members[1].x = playerStrumsx1;
		strumLineNotes.members[2].x = playerStrumsx2;
		strumLineNotes.members[3].x = playerStrumsx3;
		playerStrums.members[0].visible = true;
		playerStrums.members[1].visible = true;
		playerStrums.members[2].visible = true;
		playerStrums.members[3].visible = true;
		strumLineNotes.members[0].visible = true;
		strumLineNotes.members[1].visible = true;
		strumLineNotes.members[2].visible = true;
		strumLineNotes.members[3].visible = true;
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0;
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2;
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2;
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			babyArrow.scrollFactor.set(0.4, 0.4);
			}
			else
			babyArrow.scrollFactor.set(0.8, 0.4);

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on " + SONG.song + "" + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , 'girlfriend');
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + "" + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, 'girlfriend', true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + "" + generateRanking(), 'girlfriend');
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText + " " + SONG.song + "" + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , 'girlfriend');
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}

	function generateRanking():String
	{
		var ranking:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0)
			ranking = "(MFC)";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1)
			ranking = "(GFC)";
		else if (misses == 0)
			ranking = "(FC)";
		else if (misses < 10)
			ranking = "(SDCB)";
		else
			ranking = "(Clear)";

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935,
			accuracy >= 99.980,
			accuracy >= 99.970,
			accuracy >= 99.955,
			accuracy >= 99.90,
			accuracy >= 99.80,
			accuracy >= 99.70,
			accuracy >= 99,
			accuracy >= 96.50,
			accuracy >= 93,
			accuracy >= 90,
			accuracy >= 85,
			accuracy >= 80,
			accuracy >= 70,
			accuracy >= 60,
			accuracy < 60
		];

		for(i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch(i)
				{
					case 0:
						ranking += " AAAAA";
					case 1:
						ranking += " AAAA:";
					case 2:
						ranking += " AAAA.";
					case 3:
						ranking += " AAAA";
					case 4:
						ranking += " AAA:";
					case 5:
						ranking += " AAA.";
					case 6:
						ranking += " AAA";
					case 7:
						ranking += " AA:";
					case 8:
						ranking += " AA.";
					case 9:
						ranking += " AA";
					case 10:
						ranking += " A:";
					case 11:
						ranking += " A.";
					case 12:
						ranking += " A";
					case 13:
						ranking += " B";
					case 14:
						ranking += " C";
					case 15:
						ranking += " D";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		floatshit += 0.1;
		#if !debug
		perfectMode = false;
		#end

		#if !debug
		perfectMode = false;
		#end

		if (currentFrames == FlxG.save.data.fpsCap)
		{
			for(i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else
			currentFrames++;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play('bf');
			else
				iconP1.animation.play('bf-old');
		}

		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));

		super.update(elapsed);

		if (!offsetTesting)
		{
			if (FlxG.save.data.accuracyDisplay)
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + (FlxG.save.data.etternaMode ? Math.max(0,etternaModeScore) + " (" + songScore + ")" : "" + songScore) + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
			}
			else
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + songScore;
			}
		}
		else
		{
			scoreTxt.text = "Suggested Offset: " + offsetTest;

		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			if (FlxG.random.bool(0.1))
			{
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

        if (dad.curCharacter == "demongf"){
			dad.y += Math.sin(floatshit);
		}

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP1.width - iconOffset);

		iconP1.flipX = true;
		iconP2.flipX = true;

		if (health < 0)
			health = 0;

		if (healthBar.percent < 20)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (camFollow.x != dad.getMidpoint().x - 100 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				defaultCamZoom = 0.90;
				camFollow.setPosition(dad.getMidpoint().x - 200, dad.getMidpoint().y + 150);

				switch (dad.curCharacter)
				{
					case 'demongf':
						camFollow.x = dad.getMidpoint().x - 300;
						camFollow.y = dad.getMidpoint().y + 125;
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x + 150)
			{
				defaultCamZoom = 1.30;
				camFollow.setPosition(boyfriend.getMidpoint().x + 150, boyfriend.getMidpoint().y - 100);
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		if (loadRep)
			{
				FlxG.watch.addQuick('rep rpesses',repPresses);
				FlxG.watch.addQuick('rep releases',repReleases);
			}

		if (health >= 2)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + "" + generateRanking(),"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , 'girlfriend');
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	
					if (daNote.mustPress)
					{
					daNote.x = playerStrums.members[daNote.noteData].x;

					if (daNote.isSustainNote)
					{
					daNote.x = playerStrums.members[daNote.noteData].x + 35;
					}

					daNote.scrollFactor.set(0.4, 0.4);
					}
					if (!daNote.mustPress)
					{
					daNote.x = strumLineNotes.members[daNote.noteData].x;

					if (daNote.isSustainNote)
					{
					daNote.x = strumLineNotes.members[daNote.noteData].x + 35;
					}

					daNote.scrollFactor.set(0.8, 0.4);
					}
					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;
	
						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
	
						dad.holdTimer = 0;

						if (gfEvil.alpha == 1)
						{
						red.alpha = 0;
						gfEvil.alpha = 0;
						transform.stop();
						playerStrums.members[0].visible = true;
						playerStrums.members[1].visible = true;
						playerStrums.members[2].visible = true;
						playerStrums.members[3].visible = true;
						strumLineNotes.members[0].visible = true;
						strumLineNotes.members[1].visible = true;
						strumLineNotes.members[2].visible = true;
						strumLineNotes.members[3].visible = true;
						}
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
	
					if (FlxG.save.data.downscroll)
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));
					else
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));
	
					if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{
							health += 0.075;
							vocals.volume = 0;
							if (theFunne)
								noteMiss(daNote.noteData, daNote);
						}
	
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}


		if (!inCutscene)
			keyShit();

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
			}
		}

		dropText.text = swagDialogue.text;
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay();

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), 1);
			#end
		}

		if (offsetTesting)
		{
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
				FlxG.switchState(new PlayState());
		}
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health += 0.2;
					ss = false;
					shits++;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health += 0.06;
					ss = false;
					bads++;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health >= 0)
						health -= 0.04;
				case 'sick':
					if (health >= 0)
						health -= 0.1;
					sicks++;
			}

			if (FlxG.save.data.etternaMode)
				etternaModeScore += Math.round(score / wife);

			if (daRating != 'shit' || daRating != 'bad')
				{

			songScore += Math.round(score);
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
	
			
			var msTiming = truncateFloat(noteDiff, 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			add(rating);
	
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));

				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
	
			coolText.text = Std.string(seperatedScore);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

	private function keyShit():Void
	{
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		if (loadRep)
		{
			up = false;
			down = false;
			right = false;
			left = false;
			
			if (repPresses < rep.replay.keyPresses.length && repReleases < rep.replay.keyReleases.length)
			{
				upP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "up";
				rightP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "right";
				downP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "down";
				leftP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "left";	

				upR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "up";
				rightR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition  && rep.replay.keyReleases[repReleases].key == "right";
				downR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "down";
				leftR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "left";

				upHold = upP ? true : upR ? false : true;
				rightHold = rightP ? true : rightR ? false : true;
				downHold = downP ? true : downR ? false : true;
				leftHold = leftP ? true : leftR ? false : true;
			}
		}
		else if (!loadRep)
		{
			if (upP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "up"});
			if (rightP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "right"});
			if (downP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "down"});
			if (leftP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "left"});

			if (upR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "up"});
			if (rightR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "right"});
			if (downR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "down"});
			if (leftR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "left"});
		}
		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
			{
				repPresses++;
				boyfriend.holdTimer = 0;
	
				var possibleNotes:Array<Note> = [];
	
				var ignoreList:Array<Int> = [];
	
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
					{
						possibleNotes.push(daNote);
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
						ignoreList.push(daNote.noteData);
					}
				});
	
				
				if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];

					if (possibleNotes.length >= 2)
					{
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{

								if (controlArray[coolNote.noteData])
									goodNoteHit(coolNote);
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
							if (loadRep)
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
									daNote.rating = "shit";
								else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
									daNote.rating = "bad";
								else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
									daNote.rating = "good";
								else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
									daNote.rating = "sick";

								if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
								{
									goodNoteHit(daNote);
								}
								else
									noteCheck(controlArray, daNote);
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
								if (loadRep)
									{
										if (NearlyEquals(coolNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
										{
											var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);

											if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
												coolNote.rating = "shit";
											else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
												coolNote.rating = "bad";
											else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
												coolNote.rating = "good";
											else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
												coolNote.rating = "sick";
											goodNoteHit(coolNote);
										}
										else
											noteCheck(controlArray, daNote);
									}
								else
									noteCheck(controlArray, coolNote);
							}
						}
					}
					else
					{	
						if (loadRep)
						{
							if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
									daNote.rating = "shit";
								else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
									daNote.rating = "bad";
								else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
									daNote.rating = "good";
								else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
									daNote.rating = "sick";

								goodNoteHit(daNote);
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
							noteCheck(controlArray, daNote);
					}
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
			}
	
			if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && loadRep && generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						switch (daNote.noteData)
						{
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
				});
			}
	
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.playAnim('idle');
				}
			}
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 2:
							if (loadRep)
							{
							}
							else
							{
								if (upP && spr.animation.curAnim.name != 'confirm' && !loadRep)
								{
									spr.animation.play('pressed');
								}
								if (upR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 3:
							if (loadRep)
								{
								}
							else
							{
								if (rightP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (rightR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}	
						case 1:
							if (loadRep)
								{
								}
							else
							{
								if (downP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (downR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 0:
							if (loadRep)
								{
								}
							else
							{
								if (leftP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (leftR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
					}
					
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();

				});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health += 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			totalNotesHit += wife;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			if (boyfriend.curCharacter != 'bf')
			{
			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
			}

			updateAccuracy();
		}
	}

	function updateAccuracy() 
		{
			if (misses > 0 || accuracy < 96)
				fc = false;
			else
				fc = true;
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = [];

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
				note.rating = "shit";
			else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
				note.rating = "bad";
			else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
				note.rating = "good";
			else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
				note.rating = "sick";

			if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note);
					}
				}
			}
			else if (controlArray[note.noteData])
				{
					for (b in controlArray) {
						if (b)
							mashing++;
					}

					if (mashing <= getKeyPresses(note) && mashViolations < 2)
					{
						mashViolations++;
						
						goodNoteHit(note, (mashing <= getKeyPresses(note)));
					}
					else
					{
						playerStrums.members[0].animation.play('static');
						playerStrums.members[1].animation.play('static');
						playerStrums.members[2].animation.play('static');
						playerStrums.members[3].animation.play('static');
						health += 0.2;
					}

					if (mashing != 0)
						mashing = 0;
				}
		}

		var nps:Int = 0;

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
					note.rating = "shit";
				else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
					note.rating = "bad";
				else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
					note.rating = "good";
				else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
					note.rating = "sick";

				if (!note.isSustainNote)
					notesHitArray.push(Date.now());

				if (resetMashViolation)
					mashViolations--;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					if (boyfriend.curCharacter != 'bf')
					{
					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
					}
		
					if (!loadRep)
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(note.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
						});
		
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	public function transitionOGN(inOut:Bool, imgonnakillsomeone:Bool)
	{
		if (inOut)
		{
			shaderOGN += 0.05;
			boyfriend.shader.data.amount.value[0] += 0.05;
			dad.shader.data.amount.value[0] += 0.05;

			if (imgonnakillsomeone)
			{
				new FlxTimer().start(1.05, function(tmr:FlxTimer)
				{
					shaderOGN += 0.04999;
					boyfriend.shader.data.amount.value[0] += 0.04999;
					dad.shader.data.amount.value[0] += 0.04999;
				});
			}

			if (shaderOGN < 0.95)
			{
				new FlxTimer().start(0.05, function(tmr:FlxTimer)
				{
					transitionOGN(true, false);
				});
			}
		}
		else
		{
			shaderOGN -= 0.05;
			boyfriend.shader.data.amount.value[0] -= 0.05;
			dad.shader.data.amount.value[0] -= 0.05;

			if (imgonnakillsomeone)
			{
				new FlxTimer().start(1.05, function(tmr:FlxTimer)
				{
					shaderOGN -= 0.04999;
					boyfriend.shader.data.amount.value[0] -= 0.04999;
					dad.shader.data.amount.value[0] -= 0.04999;
				});
			}

			if (shaderOGN > 0.05)
			{
				new FlxTimer().start(0.05, function(tmr:FlxTimer)
				{
					transitionOGN(false, false);
				});
			}
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (curStep == 1)
		{
		swagDialogue.resetText('You thought-a rapper worked alone?!');
		swagDialogue.start(0.04, true);
		bgFade.visible = true;
		box.visible = true;
		dropText.visible = true;
		swagDialogue.visible = true;
		portraitgf2.visible = true;
		}

		if (curStep == 24)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curStep == 27)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curStep == 30)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curStep == 32)
		{
		changeBFCharacter("bf-car");
		changeDadCharacter("girlfriend-car");
		bgFade.visible = false;
		box.visible = false;
		dropText.visible = false;
		swagDialogue.visible = false;
		portraitgf2.visible = false;
		camHUD.visible = true;
		camZooming = true;
		bgLimo.animation.play('drive');
		limo.animation.play('drive');
		}

		if (curStep == 159)
		{
		totalBeat = 32;
		timeBeat = 1;
		}

		if (curStep == 287)
		{
		totalBeat = 16;
		timeBeat = 2;
		}

		if (curStep == 415)
		{
		totalBeat = 64;
		timeBeat = 1;
		}

		if (curStep == 427)
		{
		changeBFCharacter("bf");
		}

		if (curStep == 428)
		{
		boyfriend.playAnim('hey');
		}

		if (curStep == 430)
		{
		changeBFCharacter("bf-car");
		}

		if (curStep == 443)
		{
		changeBFCharacter("bf");
		}

		if (curStep == 444)
		{
		boyfriend.playAnim('hey');
		}

		if (curStep == 446)
		{
		changeBFCharacter("bf-car");
		}

		if (curStep == 671)
		{
		transitionOGN(true, true);
		FlxTween.tween(blackOGNThingie, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(gf, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(limo, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
		}

		if (curStep == 799)
		{
		transitionOGN(false, true);
		FlxTween.tween(blackOGNThingie, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(gf, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(limo, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 831)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 847)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 856)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 863)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 895)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 912)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 918)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 924)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 927)
		{
		totalBeat = 112;
		timeBeat = 1;
		}

		if (curStep == 1188)
		{
		FlxTween.tween(blackBarThingie, {alpha: 1}, 1);
		}

		if (curStep == 1215)
		{
			changeDadCharacter("demongf");
		FlxTween.tween(blackBarThingie, {alpha: 0}, 0.5);
			transformation();
		playerStrums.members[0].visible = false;
		playerStrums.members[1].visible = false;
		playerStrums.members[2].visible = false;
		playerStrums.members[3].visible = false;
		strumLineNotes.members[0].visible = false;
		strumLineNotes.members[1].visible = false;
		strumLineNotes.members[2].visible = false;
		strumLineNotes.members[3].visible = false;
		}

		if (curStep == 1221)
		{
			//changeDadCharacter("demongf");
		}

		if (curStep == 1380)
		{
			changeDadCharacter("demongf");
		FlxTween.tween(blackBarThingie, {alpha: 1}, 1);
		FlxTween.tween(camHUD, {alpha: 0}, 1);
		}

		#if desktop
		songLength = FlxG.sound.music.length;

		DiscordClient.changePresence(detailsText + " " + SONG.song + "" + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , 'girlfriend',true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}

		if(totalBeat > 0){
		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % timeBeat == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		totalBeat -= 1;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		switch (curStage)
		{
			case 'limo':
		if (curBeat >= 8)
		{
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
		}
		}
	}

	var curLight:Int = 0;

	function changeDadCharacter(id:String)
	{				
		var olddadx = dad.x;
		var olddady = dad.y;
		remove(dad);
		dad = new Character(olddadx, olddady, id);
		add(dad);
		dad.flipX = true;
		if (id == 'girlfriend-car')
		{
		dad.x -= 275;
		dad.y -= 25;
		}
		if (id == 'demongf')
		{
		iconP2.changeIcon('demongf');
			    dad.x += 87;
				dad.y += 70;
		}
		dad.shader = new SilhouetteALTShader(165,0,77);
	}
	function changeBFCharacter(id:String)
	{				
		var oldboyfriendx = boyfriend.x;
		var oldboyfriendy = boyfriend.y;
		remove(boyfriend);
		boyfriend = new Boyfriend(oldboyfriendx, oldboyfriendy, id);
		add(boyfriend);
		insert(members.indexOf(grpLimoDancers), boyfriend);
		boyfriend.flipX = true;
		boyfriend.scrollFactor.set(0.4, 0.4);
		boyfriend.shader = new SilhouetteShader(49,176,209);
	}
}
