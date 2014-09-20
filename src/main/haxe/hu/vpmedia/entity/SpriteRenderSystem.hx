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
package hu.vpmedia.entity;

import hu.vpmedia.ds.DoublyLinkedSignalList;
import hu.vpmedia.entity.commons.AlignTypes;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.display.Sprite;

class SpriteRenderSystem extends BaseEntitySystem {
    public var nodeList:Dynamic;
    public var canvas:Sprite;
    public var layers:Array<SpriteLayer>;
    public var camera:BaseCamera2D;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);

        camera = new BaseCamera2D(800, 600);

        layers = new Array();
        canvas = new Sprite();
        world.context.addChild(canvas);
        nodeList = world.getNodeList(SpriteRenderNode);
        nodeList.nodeAdded.add(onNodeAdded);
        nodeList.nodeRemoved.add(onNodeRemoved);
    }

    public function onNodeAdded(node:SpriteRenderNode) {
        while (node.display.layerIndex >= canvas.numChildren) {
            var id:Int = layers.length;
            var layer:SpriteLayer = new SpriteLayer(id);
            canvas.addChild(layer);
            layers.push(layer);
            layer.parallaxFactorX = node.display.parallaxFactorX;
            layer.parallaxFactorY = node.display.parallaxFactorY;
//trace("\tLayer", layer.id, "created");
        }
// assign display z-index
        node.display.zIndex = layers[node.display.layerIndex].numChildren;
// add to display list
        layers[node.display.layerIndex].addChild(node.spriterender.skin);

//canvas.addChild(node.spriterender.skin);
        node.spriterender.skin.x = node.position.x;
        node.spriterender.skin.y = node.position.y;
        node.spriterender.skin.rotation = node.position.rotation;

/*if (Std.is(node.spriterender.skin, AnimatedSprite))
        {
            var movieClip:AnimatedSprite=cast(node.spriterender.skin, AnimatedSprite);
            if (node.display.animation != null)
            {
                movieClip.showBehavior(node.display.animation); 
            }               
        }*/
    }

    public function onNodeRemoved(node:SpriteRenderNode) {
        node.spriterender.skin.parent.removeChild(node.spriterender.skin);
    }

    override function step(timeDelta:Float) {
        camera.step(timeDelta);

// update canvas by camera target
        if (camera.target) {
            canvas.x = camera.x;
            canvas.y = camera.y;
        }
// update layers
        var n:Int = layers.length;
        var layer:SpriteLayer;
        for (i in 0...n) {
            layer = layers[i];
            layer.x = -canvas.x * (1 - layer.parallaxFactorX);
            layer.y = -canvas.y * (1 - layer.parallaxFactorY);
        }

        var node:SpriteRenderNode = nodeList.head;
        while (node != null) {
//trace(this, entity, timeDelta);
            if (node.spriterender.skin == null) {
                return;
            }
// validate by visibility
            node.spriterender.skin.visible = node.display.visible;
            if (!node.display.visible) {
                return;
            }
// update rotation (first we reset to get proper center point)
// TODO: refactor to get this just once for all at addition level
            node.spriterender.skin.rotation = 0;
//skin.rotation=child.rotation;
//trace(skin.width/2, skin.height/2,child.rotation)
// update position and inverted scale
            var nX:Float = node.position.x + node.display.offsetX;
            var nY:Float = node.position.y + node.display.offsetY;
            if (node.display.inverted) {
                nX += node.spriterender.skin.width;
                node.spriterender.skin.scaleX = -1;
            }
            else {
                node.spriterender.skin.scaleX = 1;
            }
            if (node.display.registration == AlignTypes.MIDDLE) {
                nX -= node.spriterender.skin.width * 0.5;
                nY -= node.spriterender.skin.height * 0.5;
            }
// position
            node.spriterender.skin.x = nX;
            node.spriterender.skin.y = nY;
// rotation
            if (node.display.registration == AlignTypes.MIDDLE) {
                var matrix:Matrix = node.spriterender.skin.transform.matrix.clone();
                rotateAroundInternalPoint(matrix, node.spriterender.skin.width / 2, node.spriterender.skin.height / 2, node.position.rotation);
                node.spriterender.skin.transform.matrix = matrix;
            }
            else {
                node.spriterender.skin.rotation = node.position.rotation;
            }
// SpriteSheet step
/*if (Std.is(node.spriterender.skin, AnimatedSprite))
            {
                var movieClip:AnimatedSprite=cast(node.spriterender.skin, AnimatedSprite);
                if (node.display.animation != null && (movieClip.currentBehavior == null || movieClip.currentBehavior.name != node.display.animation))
                {
                    movieClip.showBehavior(node.display.animation); 
                }               
                movieClip.update(Std.int(timeDelta*1000));
            }*/
            node = node.next;
        }
    }

    public static function rotateAroundInternalPoint(m:Matrix, x:Float, y:Float, angleDegrees:Float):Void {
        var point:Point = new Point(x, y);
        point = m.transformPoint(point);
        m.tx -= point.x;
        m.ty -= point.y;
        m.rotate(angleDegrees * (Math.PI / 180));
        m.tx += point.x;
        m.ty += point.y;
    }

}

class SpriteLayer extends Sprite {
    public var parallaxFactorX:Float;
    public var parallaxFactorY:Float;
    public var id:Int;

    public function new(id:Int) {
        parallaxFactorX = 1;
        parallaxFactorY = 1;
        this.id = id;
        super();
    }

    public function getId():Int {
        return id;
    }
}