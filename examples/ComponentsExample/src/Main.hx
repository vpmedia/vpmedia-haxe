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

// http://haxe.org/doc/flash/as2_compare

package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextFormat;
import hu.vpmedia.components.ComponentState;
import hu.vpmedia.components.Label;
import hu.vpmedia.components.LabelSkin;
import hu.vpmedia.components.Panel;

import hu.vpmedia.components.android.Color;
import hu.vpmedia.components.android.Theme;
import hu.vpmedia.components.ThemeManager;
import hu.vpmedia.components.Button;
 
class Main extends Sprite 
{
    //----------------------------------
    //  Constructor
    //----------------------------------

    // Entry point
    public static function main () {
        Lib.current.addChild (new Main());
    }
    
    public function new()
    {
        super();
        Lib.current.addChild(this);   
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        initialize ();
    }
    
    //----------------------------------
    //  Bootstrap
    //----------------------------------

    private function initialize ():Void 
    {           
        ThemeManager.setTheme(Theme);
        
        var panel:Panel;
        var label:Label;
        var button:Button;
                
        ///*
        label = new Label(this);
        label.move(50,10);
        label.setSize(140, 40); 
        label.text = "<b>VP</b>Media";
        label.setStyleOfState("textFormat", new TextFormat("Arial", 11, Color.BLACK));
        
        label = new Label(this);
        label.move(50,25);
        label.setSize(140, 40); 
        label.text = "COMPONENT <i>DEMO</i>";
        //*/
        
        
        ///*
        panel = new Panel(this, 200, 40);
        panel.move(50,50);
        //*/
        
        ///*
        panel = new Panel(this, 200, 40);
        panel.move(50,100);
        panel.setStyleOfState("bgColor1", Color.GREEN_1);
        panel.setStyleOfState("bgColor2", Color.GREEN_2);
        //*/
        
        ///*
        button = new Button(this, 200, 40);
        button.move(50,150);
        //*/
        
       ///* 
        button = new Button(this, 200, 40);
        button.move(50,200);
        //Actuate.tween(button, 1, { width:400, height:300 } );
        button.text = "416-340-8666";
        
        button.setStyleOfState("bgColor1", Color.GREEN_1);
        button.setStyleOfState("bgColor2", Color.GREEN_2);
        button.setStyleOfState("textFormat", new TextFormat("Arial", 16, Color.BLACK));
        
        button.setStyleByState(ComponentState.OVER,"bgColor1", Color.GREEN_2);
        button.setStyleByState(ComponentState.OVER,"bgColor2", Color.GREEN_1);
        button.setStyleByState(ComponentState.OVER,"textFormat", new TextFormat("Arial", 16, Color.WHITE));
        
        button.setStyle("bgColor1:DOWN", Color.GREEN_1);
        button.setStyle("bgColor2:DOWN", Color.GREEN_1);
        button.setStyle("textFormat:DOWN", new TextFormat("Arial", 16, Color.GREY_MID_2));
        //button.setParent(this);
        //button.dispose(); 
         ThemeManager.setStyle(Type.getClassName(LabelSkin), "textFormat:DEFAULT", new TextFormat("Arial", 12, Color.GREY_LIGHT_2, true));
    //*/
        //ThemeManager.setThemeClass(Theme);
        //ThemeManager.invalidateAll();   
    }

}
