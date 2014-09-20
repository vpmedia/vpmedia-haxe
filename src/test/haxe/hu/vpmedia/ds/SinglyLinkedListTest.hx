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
class SinglyLinkedListTest extends MatchersBase
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
        var list:SinglyLinkedList<SinglyLinkedListNode> = new SinglyLinkedList<SinglyLinkedListNode>();
        var node:SinglyLinkedListNode = new SinglyLinkedListNode();
        node.data = 1;
        list.add(node);
        assertThat(list.head, sameInstance(node));
    }
      
    @Test
    public function test_remove():Void
    {
        var list:SinglyLinkedList<SinglyLinkedListNode> = new SinglyLinkedList<SinglyLinkedListNode>();
        var node:SinglyLinkedListNode = new SinglyLinkedListNode();
        node.data = 1;
        list.add(node);
        list.remove(node);
        assertThat(list.head, nullValue());
    }
      
    @Test
    public function test_removeAll():Void
    {
        var list:SinglyLinkedList<SinglyLinkedListNode> = new SinglyLinkedList<SinglyLinkedListNode>();
        var node:SinglyLinkedListNode = new SinglyLinkedListNode();
        node.data = 1;
        list.add(node);
        list.removeAll();
        assertThat(list.head, nullValue());
    }

}

@:rtti
class SinglyLinkedListNode implements ISinglyLinkedListNode<SinglyLinkedListNode>
{    
    public var next:SinglyLinkedListNode;
        
    public var data:Dynamic;
    
    //----------------------------------
    //  Constructor
    //----------------------------------
    
    public function new() 
    {           
    }
}