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

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

import hu.vpmedia.entity.*;
import hu.vpmedia.entity.commons.*;

class Main extends Sprite {
    
    public var world:BaseEntityWorld;
    
    public static function main() {       
        Lib.current.addChild ( new Main() );
    }
    
    public function new()
    {
        super();
        Lib.current.addChild(this);   
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        addEventListener(Event.REMOVED_FROM_STAGE,onRemovedHandler,false,0,true);        
        stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false, 0, true);
        world = new BaseEntityWorld(this);
        world.addSystem(new H2DRenderSystem(SystemTypes.RENDER, world));  
        world.addSystem(new SimpleMotionSystem(SystemTypes.UPDATE, world)); 
    }
    
    public function onRemovedHandler(event:Event):Void
    {
        removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedHandler);
        world.dispose();
    }
    
    public function onContextCreated(event:Event):Void
    {      
        Lib.trace(this + "::" + "onContextCreated");
        
         haxe.Timer.delay(addEntities, 1000);
    }
    
    public function addEntities():Void
    {      
        var entity:BaseEntity;        
		var bitmap:Bitmap;
		var tile;
		
		bitmap = new Bitmap(openfl.Assets.getBitmapData("assets/grass.png"));
        tile = h2d.Tile.fromBitmap(bitmap.bitmapData);
		tile.setSize(800, 600);
        var texture = new h2d.Bitmap(tile);
		texture.tileWrap = true;
        
		entity = new BaseEntity();
		entity.addComponent(new PositionComponent( { x:0, y:0, rotation:0 } ));
		entity.addComponent(new DisplayComponent( {} ));		
		entity.addComponent(new H2DRenderComponent(texture));
		world.addEntity(entity);
		
		bitmap = new Bitmap(openfl.Assets.getBitmapData("assets/wabbit_alpha.png"));
		tile = h2d.Tile.fromBitmap(bitmap.bitmapData);
        for(i in 0...200)
        {     
            entity = new BaseEntity();
            entity.addComponent(new PositionComponent({x:Std.int(Math.random()*800),y:Std.int(Math.random()*600),rotation:i}));
            entity.addComponent(new DisplayComponent({registration:AlignTypes.MIDDLE}));
            entity.addComponent(new MotionComponent({velocityX:Math.random(),velocityY:Math.random(),angularVelocity:Math.random()}));
            entity.addComponent(new H2DRenderComponent(new h2d.Bitmap(tile)));
            world.addEntity(entity);
        } 
       		
        bitmap = new Bitmap(openfl.Assets.getBitmapData("assets/pirate.png"));
		tile = h2d.Tile.fromBitmap(bitmap.bitmapData);
		
        entity = new BaseEntity();
        entity.addComponent(new PositionComponent({x:400,y:300,rotation:15}));
        entity.addComponent(new DisplayComponent({registration:AlignTypes.MIDDLE}));
        entity.addComponent(new MotionComponent({velocityX:Math.random(),velocityY:Math.random(),angularVelocity:Math.random()}));
        entity.addComponent(new H2DRenderComponent(new h2d.Bitmap(tile)));
        world.addEntity(entity);
        
    }
}
