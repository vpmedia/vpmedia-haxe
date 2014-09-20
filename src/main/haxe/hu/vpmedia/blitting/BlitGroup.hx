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
package hu.vpmedia.blitting;

import flash.display.BitmapData;

/**
 * TBD
 * @author Andras Csizmadia
 */
class BlitGroup {
    public var currentSequence:BlitClip;

    public var sequences:Array<BlitClip>;

    public function new(defaultSequence:BlitClip = null) {
        sequences = new Array<BlitClip>();
        if (defaultSequence != null)
            addSequence(defaultSequence);
    }

    public function play(animationName:String):Void {
        var newSequence:BlitClip = getSequenceByName(animationName);
        if (newSequence == null || newSequence.name == currentSequence.name)
            return;
        currentSequence = newSequence;
        currentSequence.currentFrame = 0;
    }

    public function addSequence(bitmapSequence:BlitClip):Void {
        sequences.push(bitmapSequence);
        if (currentSequence == null)
            currentSequence = bitmapSequence;
    }

    public function getSequenceByName(name:String):BlitClip {
        for (sequence in sequences) {
            if (sequence.name == name)
                return sequence;
        }
        return null;
    }

    public function setCanvas(value:BitmapData):Void {
        for (sequence in sequences) {
            sequence.canvas = value;
        }
    }

    public function step(timeDelta:Float):Void {
        currentSequence.step(timeDelta);
    }
}