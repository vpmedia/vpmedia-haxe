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

import hu.vpmedia.entity.commons.ControlComponent;
import hu.vpmedia.entity.commons.DisplayComponent;
import hu.vpmedia.entity.commons.MotionComponent;
import hu.vpmedia.entity.commons.PositionComponent;
import hu.vpmedia.entity.commons.Position3DComponent;

import hu.vpmedia.entity.SpriteRenderComponent;
import hu.vpmedia.entity.SpriteRenderSystem;

import hu.vpmedia.entity.SimpleMotionSystem;

import hu.vpmedia.entity.Steering3DSystem;
import hu.vpmedia.entity.Steering3DComponent;

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
        world.addSystem(new SpriteRenderSystem(SystemTypes.RENDER, world));
        world.addSystem(new SimpleMotionSystem(SystemTypes.UPDATE, world));
        world.addSystem(new Steering3DSystem(SystemTypes.RESOLVE, world));
        
        var entity:BaseEntity;
        var bitmap:Bitmap;
        
        for(i in 0...10)
        {            
            bitmap = new Bitmap(openfl.Assets.getBitmapData("assets/wabbit_alpha.png"));
            entity = new BaseEntity();
            entity.addComponent(new PositionComponent({x:Std.int(Math.random()*800),y:Std.int(Math.random()*600),rotation:i}));
            entity.addComponent(new DisplayComponent({registration:AlignTypes.MIDDLE}));
            entity.addComponent(new SpriteRenderComponent(bitmap));
            entity.addComponent(new Steering3DComponent());            
            world.addEntity(entity);
        }    
                
        bitmap = new Bitmap(openfl.Assets.getBitmapData("assets/pirate.png"));
        entity = new BaseEntity();
        entity.addComponent(new PositionComponent({x:400,y:300,rotation:15}));
        entity.addComponent(new DisplayComponent({registration:AlignTypes.MIDDLE}));
        entity.addComponent(new MotionComponent({velocityX:Math.random(),velocityY:Math.random(),angularVelocity:Math.random()}));
        entity.addComponent(new SpriteRenderComponent(bitmap));
        world.addEntity(entity);    
       
    }
}
