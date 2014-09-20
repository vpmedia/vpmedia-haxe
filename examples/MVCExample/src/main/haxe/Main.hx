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

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flash.text.TextFormat;

import hu.vpmedia.signals.SignalLite;

import app.ApplicationModel; 
import app.ApplicationView; 
import app.ApplicationController; 
import app.ApplicationContext; 
import app.StartContext; 
import app.StartView;
import app.StartController;
import hu.vpmedia.framework.IBaseTransmitter;

/**
 * ...
 * @author Andras Csizmadia
 */
class Main extends Sprite 
{
    var context:ApplicationContext;
        
    //----------------------------------
    //  Constructor
    //----------------------------------

    public function new()
    {
        super();
        initialize ();
    }
    
    // Entry point
    public static function main () {
        Lib.current.addChild (new Main());
    } 
    
    //----------------------------------
    //  Bootstrap
    //----------------------------------

    private function initialize ():Void 
    {      
        addEventListener (Event.ADDED_TO_STAGE, stageHandler, false, 0, true);

        //Lib.current.addChild(this);
    }

    private function stageHandler (event:Event):Void 
    {
        #if debug
        Lib.trace("stageHandler:"+event.type);
        #end 
        
        #if neko
        #end 
        
        #if cpp
        cpp.vm.Profiler.start("log.txt");
        #end         

        if(event.type == Event.ADDED_TO_STAGE)
        {
            startup(); 
        } 
        else if(event.type == Event.REMOVED_FROM_STAGE)
        {
            shutdown();
        }
    } 

    public function startup():Void 
    {        
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
                
        removeEventListener (Event.ADDED_TO_STAGE, stageHandler); 
        addEventListener (Event.REMOVED_FROM_STAGE, stageHandler, false, 0, true);  
            
        context = new ApplicationContext(this);
        context.model.signal.add(applicationChangeHandler);
        context.model.startup(context);
                            
        // fps
        //var fps:FPS = new FPS();
        //addChild(fps);
        
        context.model.router.setState("/start/");    
        
        //Sound1 = Assets.getSound ("sounds/sound84.wav");
    }
    
    private function applicationChangeHandler(code:String, data:Dynamic=null, level:String=null, source:IBaseTransmitter=null):Void 
    {     
        #if debug
        Lib.trace(code+"::"+data+"::"+level+"::"+source);
        #end  
    }

    public function shutdown():Void 
    {     
        removeEventListener (Event.REMOVED_FROM_STAGE, stageHandler); 
        context.dispose();
        //removeChildren();
        while(numChildren > 0)
        {
            removeChildAt(0);
        }
        Lib.current.removeChild(this);
    }
}
