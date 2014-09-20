////////////////////////////////////////////////////////////////////////////////
//=BEGIN MIT LICENSE
//
// The MIT License
// 
// Copyright (c) 2012-2013 Andras Csizmadia
// http://www.vpmedia.eu
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//=END MIT LICENSE
////////////////////////////////////////////////////////////////////////////////
package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import hu.vpmedia.blitting.BitmapClip;
import hu.vpmedia.blitting.BlitAtlas;
import hu.vpmedia.blitting.BlitFactory;
import openfl.Assets;

class Main extends Sprite {
        
	var clip1:BitmapClip;
	var clip2:BitmapClip;
	var clip3:BitmapClip;
	var fixedTS:Float = 1 / 60;
	
    public function new()
    {
        super();
        Lib.current.addChild(this);   
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        addEventListener(Event.REMOVED_FROM_STAGE,onRemovedHandler,false,0,true);
        initialize();
    }
    
    public function onRemovedHandler(event:Event):Void
    {
        removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedHandler);
    }
    
    public function initialize():Void
    {	
		var spritesheet:BitmapData;
        var spritesheetXML:Xml;
        var atlas:BlitAtlas;
        
        // #1
        spritesheet = Assets.getBitmapData("assets/test_tilesheet_640x400.png");
		atlas = new BlitAtlas(spritesheet);
		atlas.addArea("f1", new Rectangle(0, 0, 132, 132));
		atlas.addArea("f2", new Rectangle(132*1, 0, 132, 132));
		atlas.addArea("f3", new Rectangle(132*2, 0, 132, 132));
		atlas.addArea("f4", new Rectangle(132*3, 0, 132, 132));		
		atlas.addArea("f5", new Rectangle(0, 132, 132, 132));
		
		clip1 = new BitmapClip(atlas, 132, 132, "f");
		addChild(clip1);
		clip1.x = -64 + (800 * 0.5);
		clip1.y = -64 + (600 * 0.5);
        
        // #2
        spritesheet = Assets.getBitmapData("assets/RunnerMark.png");
        spritesheetXML = Xml.parse(Assets.getText("images/RunnerMark.xml"));
		atlas = new BlitAtlas(spritesheet);
        BlitFactory.parse(spritesheetXML, atlas);
		clip2 = new BitmapClip(atlas, 90, 110, "Enemy.swf");
		addChild(clip2);
		clip2.x = -64 + (800 * 0.5);
		clip2.y = -64 + (300 * 0.5);
        
        // #3
		clip3 = new BitmapClip(atlas, 90, 160, "Runner.swf");
		addChild(clip3);
		clip3.x = -64 + (400 * 0.5);
		clip3.y = -64 + (300 * 0.5);
        
		addEventListener(Event.ENTER_FRAME,enterFrameHandler,false,0,true);
    }
	
	public function enterFrameHandler(event:Event):Void
    {
        clip1.step(fixedTS);
        clip2.step(fixedTS);
        clip3.step(fixedTS);
    }
}
