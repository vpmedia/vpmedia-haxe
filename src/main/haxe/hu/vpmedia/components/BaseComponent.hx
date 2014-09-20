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

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import hu.vpmedia.framework.BaseDisplayObject;
import hu.vpmedia.statemachines.hfsm.State;
import hu.vpmedia.statemachines.hfsm.StateMachine;
import hu.vpmedia.statemachines.hfsm.IState;
import hu.vpmedia.signals.SignalLite;

/*
TODO:
- tooltips
- enable/disable
- runtime skin changes
- layouts
- signals
- icons
*/

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class BaseComponent extends BaseDisplayObject {
    var _changedPropertyGroups:Map<String, ComponentChange>;

    var _styleSheet:BaseStyleSheet;

    var _parent:BaseComponent;

    public var skin:BaseSkin;
    public var skinClass:Class<BaseSkin>;
    public var skinClassName:String;
    public var skinGroupName:String;

    public var behaviors:Array<BaseBehavior>;

    public var stateMachine:StateMachine;

    public var isDisposed:Bool;

    public var type:ComponentName;
    public var name:String;

    public var signal:Signal;

//----------------------------------
//  Constructor
//----------------------------------

    public function new(?parent:Dynamic = null, ?width:Float = 100, ?height:Float = 20) {
        super();

        _width = width;
        _height = height;

        preInitialize();

        if (parent != null) {
            setParent(parent);
            addToParentDisplayList();
        }
    }

//----------------------------------
//  LifeCycle
//----------------------------------

    public function preInitialize():Void {
        signal = new Signal();

        _styleSheet = new BaseStyleSheet();
        behaviors = new Array();
        _changedPropertyGroups = new Map();
    }

    override function addChilds():Void {
        initialize();
    }

    public function initialize():Void {
// ThemeManager.register(this);
        initStateMachine();
        initStates();
        initSkin();
    }

    public function dispose():Void {
        isDisposed = true;
        if (_parent != null) {
            _parent.skin.componentPartList.remove(this);
        }
        skin.dispose();
        removeFromParent();
        removeBehaviors();
        _parent = null;
    }

//----------------------------------
//  Parent
//----------------------------------

    public function getParent():BaseComponent {
        return _parent;
    }

    public function setParent(parent:Dynamic):Void {
        if (_parent != null) {
            removeFromParent();
        }
        if (parent != null && Std.is(parent, DisplayObjectContainer)) {
            cast(parent, DisplayObjectContainer).addChild(_canvas);
        }
        if (parent != null && Std.is(parent, BaseComponent)) {
            _parent = parent;
            _parent.skin.componentPartList.push(this);
        }
    }

    public function addToParentDisplayList():Void {
        if (_parent != null && Std.is(_parent, BaseComponent)) {
            cast(_parent, BaseComponent).addChild(_canvas);
        }
    }

//----------------------------------
//  Skinning
//----------------------------------

    function initSkin():Void {

        skinClassName = Type.getClassName(skinClass);

        skin = Type.createInstance(skinClass, [this]);
        ThemeManager.register(skin);
        skin.initialize();
        initBehaviors();
//if(_parent == null)
        invalidate();
    }

//----------------------------------
//  Behaviors
//----------------------------------

    function initBehaviors():Void {
// abstract
    }

    function addBehavior(value:BaseBehavior):Void {
        behaviors.push(value);
    }

    function removeBehavior(value:BaseBehavior):Void {
        behaviors.remove(value);
    }

    function getBehaviorByClass(value:Class<BaseBehavior>):BaseBehavior {
        var valueClassName:String = Type.getClassName(value);
        var n:Int = behaviors.length;
        for (i in 0...n) {
            if (Type.getClassName(Type.getClass(behaviors[i])) == valueClassName) {
                return behaviors[i];
            }
        }
        return null;
    }

    function removeBehaviors():Void {
        var n:Int = behaviors.length;
        for (i in 0...n) {
            behaviors[i].dispose();
        }
        behaviors = [];
    }

//----------------------------------
//  Invalidation
//----------------------------------

/**
     *
     */

    public function validate(type:ComponentChange):Void {
        if (type == ComponentChange.ALL) {
            _changedPropertyGroups = new Map();
        }
        else {
            _changedPropertyGroups.remove(Std.string(type));
        }
    }

/**
     *
     */

    public function invalidate(?type:ComponentChange = null, ?drawAfter:Bool = true, ?waitFrame:Bool = true):Void {
        if (type == null) {
            type = ComponentChange.ALL;
        }
/* #if debug
        L.info("invalidate:"+type+"::"+skinClass+", parent:"+_parent);
        #end*/
        _changedPropertyGroups.set(Std.string(type), type);
        if (drawAfter && !waitFrame) {
            draw();
        }
        else if (drawAfter && waitFrame) {
            drawLater();
        }
    }

/**
     *
     */

    public function isInvalid(type:ComponentChange):Bool {
        if (_changedPropertyGroups.exists(Std.string(type))) {
            return true;
        }
        else if (_changedPropertyGroups.exists(Std.string(ComponentChange.ALL))) {
            return true;
        }
        return false;
    }

//----------------------------------
//  Style sheet
//----------------------------------

/**
     * Getter/setter
     */

    public function setStyleSheet(value:BaseStyleSheet, drawAfter:Bool = true):BaseStyleSheet {
        _styleSheet = value;
        invalidate(ComponentChange.STYLE, drawAfter);
        return _styleSheet;
    }

    public function getStyleSheet():BaseStyleSheet {
        return _styleSheet;
    }

//----------------------------------
//  Style properties
//----------------------------------

    public function setStyle(name:String, value:Dynamic, drawAfter:Bool = true, ?waitFrame:Bool = true, appendCurrentStateName:Bool = false):Void {
//
// appends current state to id
        if (appendCurrentStateName) {
            name = name + ":" + stateMachine.getStateName();
        }
        _styleSheet.setStyle(name, value);

        invalidate(ComponentChange.STYLE, drawAfter, waitFrame);
    }

    public function setStyleToChilds(name:String, value:Dynamic, drawAfter:Bool = true, ?waitFrame:Bool = true, appendCurrentStateName:Bool = false):Void {
        var n:Int = skin.componentPartList.length;
/*#if debug
        L.info("setStyleToChilds:" + name+"::"+value+"::"+n);
        #end  */
        for (i in 0...n) {
/*#if debug
            L.info("copy style to child:" + skin.componentPartList[i]);
            #end*/
            skin.componentPartList[i].setStyle(name, value, drawAfter, false, false);
        }
    }

    public function setStyleOfState(name:String, value:Dynamic, drawAfter:Bool = true, ?waitFrame:Bool = true, appendCurrentStateName:Bool = false, ?copyStyleToChilds:Bool = false):Void {
        setStyle(name, value, drawAfter, waitFrame, true);
    }

    public function setStyleByState(state:ComponentState, name:String, value:Dynamic, drawAfter:Bool = true, ?waitFrame:Bool = true, appendCurrentStateName:Bool = false, ?copyStyleToChilds:Bool = false):Void {
        var nameAndState:String = name + ":" + Std.string(state);
        setStyle(nameAndState, value, drawAfter, waitFrame, false);
    }

/**
     * Internal helper
     */

    public function getStyleValue(name:String, appendCurrentStateName:Bool = false):Dynamic {
// appends current state to id
        if (appendCurrentStateName) {
            name = name + ":" + stateMachine.getStateName();
        }
/*#if debug
        L.debug("getStyleValue:"+name);
        #end*/
// style by instance style
        if (hasStyle(name)) {
            return getStyle(name);
        }
// style by parent instance or class style
        if (_parent != null) {
            var p:BaseComponent = _parent;
            while (p != null) {
                if (p.hasStyle(name)) {
// style by parent instance style
                    return p.getStyle(name);
                }
                else if (ThemeManager.hasStyle(p.skinClassName, name)) {
// style by parent class style
                    return ThemeManager.getStyle(p.skinClassName, name);
                }
                p = _parent.getParent();
            }
        }
// style by group name
        if (name != null && ThemeManager.hasStyle(name, name)) {
            return ThemeManager.getStyle(skinGroupName, name);
        }
// style by name
        if (skinGroupName != null && ThemeManager.hasStyle(skinGroupName, name)) {
            return ThemeManager.getStyle(skinGroupName, name);
        }
// style by class name
        return ThemeManager.getStyle(skinClassName, name);
    }

    public function hasStyle(name:String, appendCurrentStateName:Bool = false):Bool {
// appends current state to id
        if (appendCurrentStateName) {
            name = name + ":" + stateMachine.getStateName();
        }
/*#if debug
        L.debug("hasStyle:"+name+"::"+_styleSheet.getStyle(name));
        #end*/
        if (_styleSheet.getStyle(name) != null) {
            return true;
        }
        return false;
    }

    public function getStyle(name:String, appendCurrentStateName:Bool = false):Dynamic {
// appends current state to id
        if (appendCurrentStateName) {
            name = name + ":" + stateMachine.getStateName();
        }
        if (_styleSheet.getStyle(name) != null) {
            return _styleSheet.getStyle(name);
        }
        return null;
    }


//----------------------------------
//  Draw
//----------------------------------

    public function draw() {
        if (skin != null && !isDisposed)
            skin.draw();
    }

    public function drawLater():Void {
//if(!_canvas.hasEventListener(Event.ENTER_FRAME))
        addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    function enterFrameHandler(event:Event):Void {
        removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        draw();
    }

//----------------------------------
//  State Machine
//----------------------------------

/*    function init():Void
        {
            // Override
        }*/

    function initStateMachine():Void {
        stateMachine = new StateMachine();
        stateMachine.addState(new State(Std.string(ComponentState.DEFAULT)));
        stateMachine.setInitialState(Std.string(ComponentState.DEFAULT));
        stateMachine.completed.add(stateChangeHandler);
    }

    function initStates():Void {
// abstract
    }

    function stateChangeHandler(state:String):Void {
//L.debug(this, skin, event.type, event.fromState, event.currentState, event.toState);
        if (state != null) {
            invalidate(ComponentChange.STATE);
            invalidate(ComponentChange.STYLE);
        }
    }

    public function getState():ComponentState {
        return Type.createEnum(ComponentState, stateMachine.getStateName());
    }

    public function setState(value:ComponentState):Void {
        var nextState:String = Std.string(value);
        if (!stateMachine.canChangeStateTo(nextState)) {
/*#if debug
            L.debug("Error! Cannot change to state:"+ value);    
            #end*/
            return;
        }
/*#if debug
        L.info("setState:" + nextState+"::"+_parent); 
        #end*/
        stateMachine.changeState(nextState);
    }

    public function addState(value:ComponentState, params:Dynamic = null):Void {
/*#if debug
        L.info("addState:" + value+"::"+parent); 
        #end*/
        stateMachine.addState(new State(Std.string(value), params));
    }

    public function addStatesFrom(value:BaseComponent):Void {
        var states:Map<String, IState> = value.stateMachine.getStates();
        for (s in states) {
            stateMachine.addState(s);
        }
    }

//----------------------------------
//  Layout
//----------------------------------


//----------------------------------
//  getter/setter
//----------------------------------

    override function setSize(width:Float, height:Float) {
        this.width = width;
        this.height = height;
        invalidate(ComponentChange.SIZE);
    }


    override function set_width(value:Float):Float {
        invalidate(ComponentChange.SIZE);
        return _width = value;
    }

    override function set_height(value:Float):Float {
        invalidate(ComponentChange.SIZE);
        return _height = value;
    }

}