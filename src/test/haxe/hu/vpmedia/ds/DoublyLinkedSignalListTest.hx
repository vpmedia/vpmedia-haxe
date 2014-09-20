/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
 * http://www.vpmedia.eu
 *
 * For information about the licensing and copyright please
 * contact Andras Csizmadia at andras@vpmedia.eu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */
package hu.vpmedia.ds;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.hamcrest.MatchersBase;

/**
* TBD
*/
class DoublyLinkedSignalListTest extends MatchersBase
{    
    public function new() 
    {
        super();
        // https://github.com/massiveinteractive/MassiveUnit/wiki/Working-with-test-classes
    }
        
    @AsyncTest
    public function test_addedSignal(factory:AsyncFactory):Void
    {
        var list:DoublyLinkedSignalList<DoublyLinkedSignalListNode> = new DoublyLinkedSignalList<DoublyLinkedSignalListNode>();
        list.nodeAdded.addOnce(factory.createHandler(this, function(node:Dynamic) {}));
        
        var node:DoublyLinkedSignalListNode = new DoublyLinkedSignalListNode();
        node.data = 1;
        list.add(node);
    }
      
    @AsyncTest
    public function test_removedSignal(factory:AsyncFactory):Void
    {
        var list:DoublyLinkedSignalList<DoublyLinkedSignalListNode> = new DoublyLinkedSignalList<DoublyLinkedSignalListNode>();
        list.nodeRemoved.addOnce(factory.createHandler(this, function(node:Dynamic) {}));
        
        var node:DoublyLinkedSignalListNode = new DoublyLinkedSignalListNode();
        node.data = 1;
        list.add(node);
        list.remove(node);
    }
}

@:rtti
class DoublyLinkedSignalListNode implements IDoublyLinkedListNode<DoublyLinkedSignalListNode>
{    
    public var next:DoublyLinkedSignalListNode;
    public var prev:DoublyLinkedSignalListNode;    
        
    public var data:Dynamic;
    
    //----------------------------------
    //  Constructor
    //----------------------------------
    
    public function new() 
    {           
    }
}