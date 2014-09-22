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
package hu.vpmedia.entity;

import h3d.Engine;
import h2d.Scene;
import h2d.Sprite;
import h2d.Layers;

import hu.vpmedia.ds.DoublyLinkedSignalList;

import flash.geom.Matrix;
import flash.geom.Point;

class H2DRenderSystem extends BaseEntitySystem
{
    public var nodeList:Dynamic;
    public var canvas:Sprite;
    public var system:Engine;
    public var scene:Scene;    
    public var layers:Array<H2DLayer>;    
    public var camera:BaseCamera2D;
    
    public function new(priority:Int, world:BaseEntityWorld) 
    {
        super(priority, world);
        
        camera = new BaseCamera2D(800,600);
                
        nodeList = world.getNodeList(H2DRenderNode);
        nodeList.nodeAdded.add(onNodeAdded);
        nodeList.nodeRemoved.add(onNodeRemoved);
        
        system = new Engine();
        system.debug = true;
        system.backgroundColor = 0x202020;
        system.onReady = onSystemStart;
        system.init();        
    } 
    
    public function onSystemStart() 
    {          
        layers=new Array();
        scene = new Scene();    
        canvas = new Sprite(scene);    
    }
    
    public function onNodeAdded(node:H2DRenderNode) 
    {        
        while (node.display.layerIndex >= canvas.numChildren)
        {
            var id:Int=layers.length;
            var layer:H2DLayer = new H2DLayer(id);
            layer.parallaxFactorX=node.display.parallaxFactorX;
            layer.parallaxFactorY=node.display.parallaxFactorY;
            canvas.addChild(layer);
            layers.push(layer);
            //trace("\tLayer", layer.id, "created");
        }
        node.display.zIndex = layers[node.display.layerIndex].numChildren;
        
        layers[node.display.layerIndex].addChild(node.h2drender.skin);
        
        node.h2drender.skin.x = node.position.x;
        node.h2drender.skin.y = node.position.y;
        node.h2drender.skin.rotation = node.position.rotation;        
    }
    
    public function onNodeRemoved(node:H2DRenderNode) 
    {        
        node.h2drender.skin.parent.removeChild(node.h2drender.skin);
    }
    
    override function step(timeDelta:Float) 
    {      
        system.render(scene);
        
        // update canvas by camera target
        if (camera.target)
        {
            canvas.x = camera.x;
            canvas.y = camera.y;
        }
        
         // update layers
        var n:Int=layers.length;
        var layer:H2DLayer;
        for (i in 0...n)
        {
            layer=layers[i];
            layer.x=-canvas.x * (1 - layer.parallaxFactorX);
            layer.y=-canvas.y * (1 - layer.parallaxFactorY);
        }
        
        var node:H2DRenderNode = nodeList.head;
        while(node != null) 
        {     
            if (node.h2drender.skin == null)
            {
                return;
            }
            // validate by visibility
            if (!node.display.visible)
            {
                return;
            }
            // update position and inverted scale
            var nX:Float=node.position.x;
            var nY:Float = node.position.y;
            // invert
            if (node.display.inverted)
            {
                node.h2drender.skin.scaleX=-1;
            }
            // position
            node.h2drender.skin.x=nX;
            node.h2drender.skin.y=nY;
            // rotation
            node.h2drender.skin.rotation = node.position.rotation;
            // iterate over next
            node = node.next;            
        }
    }
    
}

class H2DLayer extends Layers
{
    public var id:Int;
    public var parallaxFactorX:Float;
    public var parallaxFactorY:Float;  
    
    public function new(id:Int) 
    {
        this.id = id;
        super();
        parallaxFactorX = parallaxFactorY = 1;
    }
}
