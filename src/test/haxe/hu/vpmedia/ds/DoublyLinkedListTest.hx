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
class DoublyLinkedListTest extends MatchersBase
{    
    public function new() 
    {
        super();
        // https://github.com/massiveinteractive/MassiveUnit/wiki/Working-with-test-classes
    }
    
    @Before
    public function setup():Void
    {
        // This will run before every test
    }
    
    @After
    public function tearDown():Void
    {
        // This will run after every test
    }
        
    @Test
    public function test_add():Void
    {
        var list:DoublyLinkedList<DoublyLinkedListNode> = new DoublyLinkedList<DoublyLinkedListNode>();
        var node:DoublyLinkedListNode = new DoublyLinkedListNode();
        node.data = 1;
        list.add(node);
        assertThat(list.head, sameInstance(node));
        assertThat(list.tail, sameInstance(node));
    }
      
    @Test
    public function test_remove():Void
    {
        var list:DoublyLinkedList<DoublyLinkedListNode> = new DoublyLinkedList<DoublyLinkedListNode>();
        var node:DoublyLinkedListNode = new DoublyLinkedListNode();
        node.data = 1;
        list.add(node);
        list.remove(node);
        assertThat(list.head, nullValue());
        assertThat(list.tail, nullValue());
    }
      
    @Test
    public function test_removeAll():Void
    {
        var list:DoublyLinkedList<DoublyLinkedListNode> = new DoublyLinkedList<DoublyLinkedListNode>();
        var node:DoublyLinkedListNode = new DoublyLinkedListNode();
        node.data = 1;
        list.add(node);
        list.removeAll();
        assertThat(list.head, nullValue());
        assertThat(list.tail, nullValue());
    }
    
    @Test
    public function test_iterator():Void
    {
        var list:DoublyLinkedList<DoublyLinkedListNode> = new DoublyLinkedList<DoublyLinkedListNode>();
        
        var nodes:Array<DoublyLinkedListNode> = [];
        for (i in 0...5)
        {
            var node:DoublyLinkedListNode = new DoublyLinkedListNode();
            nodes.push(node);
            list.add(node);
        }
        for (node in list)
        {
            var index:Int = Lambda.indexOf(nodes, node);
            nodes.splice(index, 1);
        }
        assertThat(nodes, emptyArray());
    }
}

@:rtti
class DoublyLinkedListNode implements IDoublyLinkedListNode<DoublyLinkedListNode>
{    
    public var next:DoublyLinkedListNode;
    public var prev:DoublyLinkedListNode;    
        
    public var data:Dynamic;
    
    //----------------------------------
    //  Constructor
    //----------------------------------
    
    public function new() 
    {           
    }
}