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
import hu.vpmedia.ds.IDoublyLinkedListNode;

import haxe.rtti.CType;
import haxe.rtti.XmlParser;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class BaseEntityFamily<T:BaseEntityNode<T>> implements IDoublyLinkedListNode<BaseEntityFamily<T>> {
    public var next:BaseEntityFamily<T>;
    public var prev:BaseEntityFamily<T>;

    public var nodeClass:Class<Dynamic>;

    public var nodeList:DoublyLinkedSignalList<T>;
    public var entityMap:Map<BaseEntity, T>;
    public var componentMap:Map<String, Class<Dynamic>>;

//----------------------------------
//  Constructor
//----------------------------------

    public function new(nodeClass:Class<Dynamic>) {
        this.nodeClass = nodeClass;
        initialize();
    }

    private function initialize():Void {
        nodeList = new DoublyLinkedSignalList<T>();
        entityMap = new Map();
        componentMap = new Map();

        var node:Class<Dynamic> = Type.getClass(Type.createEmptyInstance(nodeClass));
        var rstr:String = Reflect.field(node, "__rtti");
        flash.Lib.trace(this + "::initialize" + node + "::" + rstr);
        if (rstr != null) {
            var x = Xml.parse(rstr).firstElement();
            var parser:XmlParser = new XmlParser();
            var infos = parser.processElement(x);
            var c:Classdef = null;
            switch(infos)
            {
                case TClassdecl(c):
                    for (f in c.fields) {
//flash.Lib.trace(f.name+","+f.type);
                        if (f.name != "entity" && f.name != "prev" && f.name != "next") {
                            var type:String = Std.string(f.type);
                            var arr:Array<String> = type.split("(");
                            arr.shift();
                            type = arr.pop();
                            arr = type.split(",");
                            arr.pop();
                            var classname:String = arr.pop();
                            if (classname == "{}" || classname == "Void")
                                continue;
                            var newClass:Class<Dynamic> = Type.resolveClass(classname);

                            var className:String = Type.getClassName(newClass);
                            componentMap.set(className, newClass);
                        }
                    }
                default:
            }
        }
    }

    public function dispose():Void {
        nodeList.removeAll();
        nodeList = null;
        entityMap = null;
        componentMap = null;
    }

    public function removeEntityIfNotMatch(entity:BaseEntity):Bool {
        if (hasEntity(entity) == false) {
            return false;
        }

        for (value in componentMap.iterator()) {
            if (!entity.hasComponent(value)) {
                removeEntity(entity);
                return true;
            }
        }

        return false;
    }

    public function addEntityIfMatch(entity:BaseEntity):Bool {
//flash.Lib.trace(this+"::"+"addEntityIfMatch"+"::"+entity);

        if (hasEntity(entity) == true) {
            return false;
        }

        for (value in componentMap.iterator()) {
//flash.Lib.trace("\t"+value+"::"+entity.hasComponent( value ));
            if (!entity.hasComponent(value)) {
                return false;
            }
        }


//flash.Lib.trace(this+"::"+"addEntityIfMatch->True"+"::"+entity);

        var node:T = Type.createEmptyInstance(nodeClass);
        node.entity = entity;

        for (key in componentMap.keys()) {
            var fieldName:String = key;
            fieldName = fieldName.split(".").pop();
            fieldName = fieldName.toLowerCase();
            fieldName = fieldName.split("component").join("");
            Reflect.setField(node, fieldName, entity.getComponent(Type.resolveClass(key)));
        }

        nodeList.add(node);
        entityMap.set(entity, node);
        return true;
    }

    public function removeEntity(entity:BaseEntity):Void {
        nodeList.remove(entityMap.get(entity));
        entityMap.remove(entity);
    }

    public function hasEntity(entity:BaseEntity):Bool {
        if (nodeList == null) {
            return false;
        }
        var node:T = nodeList.head;
        while (node != null) {
            if (node.entity == entity) {
                return true;
            }
            node = node.next;
        }
        return false;
    }
}