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
package hu.vpmedia.components;
import hu.vpmedia.components.shapes.IBaseShape;
import hu.vpmedia.components.shapes.GradientFill;
import hu.vpmedia.components.shapes.GradientItem;
import hu.vpmedia.components.shapes.GradientStroke;
import hu.vpmedia.components.shapes.RoundedRectangleShape;

/**
 * Panel
 */
class PanelSkin extends BaseSkin {
    public var background:IBaseShape;
    public var fill:GradientFill;
    public var stroke:GradientStroke;

//--------------------------------------
//  Constructor
//--------------------------------------
/**
    * Constructor
    */

    public function new(owner:BaseComponent) {
        super(owner);
    }

    override function createChildren():Void {
        super.createChildren();

        var fillArray:Array<GradientItem> = [];
        fillArray.push(new GradientItem(1, owner.getStyleValue("bgColor1", true), 0));
        fillArray.push(new GradientItem(1, owner.getStyleValue("bgColor2", true), 255));
        var strokeArray:Array<GradientItem> = [];
        strokeArray.push(new GradientItem(1, owner.getStyleValue("borderColor1", true), 0));
        strokeArray.push(new GradientItem(1, owner.getStyleValue("borderColor2", true), 255));
        fill = new GradientFill(fillArray);
        stroke = new GradientStroke(strokeArray);
        background = new RoundedRectangleShape(owner.canvas, 0, 0, owner.width, owner.height, owner.getStyleValue("ellipse"), fill, stroke, false);
    }

    override public function updateStyle():Void {
        fill.gradientColors[0] = owner.getStyleValue("bgColor1", true);
        fill.gradientColors[1] = owner.getStyleValue("bgColor2", true);
        stroke.gradientColors[0] = owner.getStyleValue("borderColor1", true);
        stroke.gradientColors[1] = owner.getStyleValue("borderColor2", true);

// L.info("draw" + fill.gradientColors[0] + ":" + fill.gradientColors[1]);

//background.width = owner.width;
//background.height = owner.height;

        background.draw();

        super.updateStyle();
    }

    override public function updateSize():Void {
        background.width = owner.width;
        background.height = owner.height;

        background.draw();

        super.updateSize();
    }
/*override function draw():Void
    {        
        fill.gradientColors[0] = owner.getStyleValue("bgColor1",true);
        fill.gradientColors[1] = owner.getStyleValue("bgColor2",true);
        stroke.gradientColors[0] = owner.getStyleValue("borderColor1",true);
        stroke.gradientColors[1] = owner.getStyleValue("borderColor2",true);
        
        L.info("draw" + fill.gradientColors[0] + ":" + fill.gradientColors[1]);
        
        background.width = owner.width;
        background.height = owner.height;        
        
        background.draw();
    }*/
}