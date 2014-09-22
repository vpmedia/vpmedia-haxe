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
import h3d.scene.Scene;
import h3d.Vector;

import flash.Lib;

import hu.vpmedia.ds.DoublyLinkedSignalList;

import flash.geom.Matrix;
import flash.geom.Point;

class H3DRenderSystem extends BaseEntitySystem
{
    public var nodeList:Dynamic;
    public var system:Engine;
    public var scene:Scene;
    
    public function new(priority:Int, world:BaseEntityWorld) 
    {
        super(priority, world);
        
        nodeList = world.getNodeList(H3DRenderNode);
        
        nodeList.nodeAdded.add(onNodeAdded);
        nodeList.nodeRemoved.add(onNodeRemoved);
        
        createSystem();
    } 
    
    function createSystem() 
    {
        system = new Engine();
        system.debug = true;
        system.backgroundColor = 0x000000;
        system.onReady = onSystemStart;
        system.init();
    }
    
    public function onSystemStart() 
    {          
        scene = new Scene();
        scene.addPass(new Axis());
        //scene.camera.target = new Vector(0, 0, 0);
        scene.camera.pos.set(3, 3, 3, 1);
        //trace(scene.camera.pos);
    }
    
    public function onNodeAdded(node:H3DRenderNode) 
    {            
        scene.addChild(node.h3drender.mesh);
        
        node.h3drender.mesh.x=node.position3d.x;
        node.h3drender.mesh.y=node.position3d.y;
        node.h3drender.mesh.z=node.position3d.z;
        
        //node.h3drender.mesh.rotate(node.position3d.rotationX, node.position3d.rotationY, node.position3d.rotationZ);
    }
    
    public function onNodeRemoved(node:H3DRenderNode) 
    {        
        scene.removeChild(node.h3drender.mesh);
    }
    
    override function step(timeDelta:Float) 
    {           
        //scene.camera.zoom += 0.001;
        //scene.camera.fov += 0.1;
        //scene.camera.pos.x += 0.1;
        system.render(scene);
                
        var node:H3DRenderNode = nodeList.head;
        while(node != null) 
        {                
            node.h3drender.mesh.x=node.position3d.x;
            node.h3drender.mesh.y=node.position3d.y;
            node.h3drender.mesh.z=node.position3d.z;
            
            //node.h3drender.mesh.rotate(node.position3d.rotationX, node.position3d.rotationY, node.position3d.rotationZ);
            
            node = node.next;            
        }
    }
    
}

class Axis implements h3d.IDrawable {

    public function new() {
    }
    
    public function render( engine : h3d.Engine ) {
        engine.line(0, 0, 0, 50, 0, 0, 0xFFFF0000);
        engine.line(0, 0, 0, 0, 50, 0, 0xFF00FF00);
        engine.line(0, 0, 0, 0, 0, 50, 0xFF0000FF);
    }
    
}