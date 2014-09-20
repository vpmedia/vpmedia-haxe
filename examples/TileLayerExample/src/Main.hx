/*
 * =BEGIN MIT LICENSE
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2012-2014 Andras Csizmadia
 * http://www.vpmedia.eu
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * =END MIT LICENSE
 */
package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

import hu.vpmedia.entity.BaseEntity;
import hu.vpmedia.entity.BaseEntityComponent;
import hu.vpmedia.entity.BaseEntityWorld;
import hu.vpmedia.entity.commons.AlignTypes;
import hu.vpmedia.entity.commons.SystemTypes;

import hu.vpmedia.entity.commons.DisplayComponent;
import hu.vpmedia.entity.commons.MotionComponent;
import hu.vpmedia.entity.commons.PositionComponent;

import hu.vpmedia.entity.TileLayerRenderComponent;
import hu.vpmedia.entity.TileLayerRenderSystem;
import aze.display.SparrowTilesheet;
import aze.display.TileClip;
import aze.display.TileLayer;

import hu.vpmedia.entity.SimpleMotionSystem;

class Main extends Sprite {
    
    public var world:BaseEntityWorld;
    
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
        world.dispose();
        //bitmapTileSheet.bitmapData.dispose();
    }
    
    public function initialize():Void
    {
        // static space
        var bgBitmap:Bitmap = new Bitmap(openfl.Assets.getBitmapData("assets/grass.png"));
        var bgSprite:Sprite = new Sprite();
        bgSprite.graphics.beginBitmapFill(bgBitmap.bitmapData);
        bgSprite.graphics.drawRect(0, 0, 800, 600);
        bgSprite.graphics.endFill();
        addChild(bgSprite);
        
        // living world
        world = new BaseEntityWorld(this);
        //world.backgroundColor = #if neko { rgb:0, a:0 } #else 0x00000000 #end;
                
       //bitmapTileSheet = new Bitmap(openfl.Assets.getBitmapData("assets/test_tilesheet_640x400.png"));
        var tilesheet:SparrowTilesheet = new SparrowTilesheet(
        openfl.Assets.getBitmapData("assets/RunnerMark.png"), openfl.Assets.getText("images/RunnerMark.xml"));
        world.addSystem(new TileLayerRenderSystem(SystemTypes.RENDER, world, tilesheet));
        
        world.addSystem(new SimpleMotionSystem(SystemTypes.PRE_RESOLVE, world));
        
        var entity:BaseEntity;    
        var skin:TileClip;        
          
        for(i in 0...25)
        {
            skin = new TileClip("Runner");
            entity = new BaseEntity();
            entity.addComponent(new PositionComponent({x:Std.int(Math.random()*800),y:400+Std.int(Math.random()*200)}));
            entity.addComponent(new TileLayerRenderComponent(skin));
            entity.addComponent(new DisplayComponent());
            entity.addComponent(new MotionComponent({velocityX:1,velocityY:0}));
            world.addEntity(entity);
        }    
        for(i in 0...25)
        {
            skin = new TileClip("Enemy");
            entity = new BaseEntity();
            entity.addComponent(new PositionComponent({x:Std.int(Math.random()*800),y:200+Std.int(Math.random()*200), rotation:Math.random()}));
            entity.addComponent(new TileLayerRenderComponent(skin));
            entity.addComponent(new DisplayComponent());
            entity.addComponent(new MotionComponent({velocityX:-1,velocityY:0}));
            world.addEntity(entity);
        }    
        for(i in 0...25)
        {
            skin = new TileClip("cloud");
            entity = new BaseEntity();
            entity.addComponent(new PositionComponent({x:Std.int(Math.random()*800),y:Std.int(Math.random()*200)}));
            entity.addComponent(new TileLayerRenderComponent(skin));
            entity.addComponent(new DisplayComponent());
            entity.addComponent(new MotionComponent({velocityX:0.5,velocityY:0, angularVelocity:0.001}));
            world.addEntity(entity);
        }            
        for(i in 0...2)
        {
            skin = new TileClip("groundTop");
            entity = new BaseEntity();
            entity.addComponent(new PositionComponent({x:Std.int(Math.random()*800),y:600}));
            entity.addComponent(new TileLayerRenderComponent(skin));
            entity.addComponent(new DisplayComponent());
            entity.addComponent(new MotionComponent({velocityX:-0.5,velocityY:0, angularVelocity:0}));
            world.addEntity(entity);
        }
    }
}
