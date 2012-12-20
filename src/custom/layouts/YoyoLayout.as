package custom.layouts
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
	
  import mx.controls.Alert;
  import mx.controls.Label;
  import mx.core.ILayoutElement;
	
  import spark.components.supportClasses.GroupBase;
  import spark.layouts.supportClasses.LayoutBase;
	
	
  public class YoyoLayout extends LayoutBase
  {
    private var _defaultSize:Number = 100;
    private var _cell_width:Array = new Array();
    private var _cell_height:Array = new Array();
    private var _grid:Array = new Array();
    private var _init:Boolean = false;
    private var _nbPerRow:Number = 0;
            
    private var _fact_gro:Number = 0.3;
    private var _attenuation:Number = 150;	
    private var _space:Number = 4;	

		
    public function YoyoLayout()
    {
      super();
    }
		
    public function MousePosition(mousePosition:Point):void
    {} /*
      // The position for the current element
      var x:Number = 0;
      var y:Number = 0;
			
      // loop through the elements
      var layoutTarget:GroupBase = target;
      var count:int = layoutTarget.numElements;
      for (var i:int = 0; i < count; i++)
      {
	// get the current element, we're going to work with the
	// ILayoutElement interface
	var element:ILayoutElement = useVirtualLayout ? 
        	layoutTarget.getVirtualElementAt(i) :
		layoutTarget.getElementAt(i);
				
	// Get de distance between mouse and element
	var size:Number = getSizeByDistance(distance(localToGlobal(getCenterPosition(element)),mousePosition));
				
	// Resize the element to its preferred size by passing
	// NaN for the width and height constraints
	element.setLayoutBoundsSize(size, size);
			
	// Find out the element's dimensions sizes.
	// We do this after the element has been already resized
	// to its preferred size.
	var elementWidth:Number = element.getLayoutBoundsWidth();
	var elementHeight:Number = element.getLayoutBoundsHeight();
				
	// Go to the next line
	if (i % _nbPerRow == 0)
	{
	  // Start from the left side
					x = 0;
					
					// Move down by elementHeight, we're assuming all 
					// elements are of equal height
					y += _maxSize;
				}
				
				// Position the element
				var position:Point = getPositionByMouse(mousePosition,_positions[i]);
				element.setLayoutBoundsPosition(position.x - elementWidth / 2 ,position.y - elementHeight / 2);
				//element.setLayoutBoundsPosition(_positions[i].x - elementWidth / 2, _positions[i].y - elementHeight / 2);
				
				// Update the current position, add a gap of 10
				x += _maxSize;
			}
 
		}*/
		
		override public function updateDisplayList(containerWidth:Number, containerHeight:Number):void
		{
		/*	// The position for the current element
			var x:Number = -1;
			var y:Number = -1;
			
	                var layoutTarget:GroupBase = target;  
		        var count:int = layoutTarget.numElements;

                        if(!_init)
                        {                               
			  // The max item per row
			  _nbPerRow = Math.round(containerWidth/_defaultSize);
			
			  // loop through the elements
		
			  for (var i:int = 0; i < count; i++)
			  {
			    // get the current element, we're going to work with the
			    // ILayoutElement interface
			    var element:ILayoutElement = useVirtualLayout ? 
					layoutTarget.getVirtualElementAt(i) :
					layoutTarget.getElementAt(i);
                                  
                            ++x;	      
                            if(i % _nbPerRow == 0)
                                 ++y;                           
        		    
                            if(y == 0)
                              _grid[x] = new Array();

                            _grid[x][y] = element;
                            _cell_width[x] = _defaultSize;
                            _cell_height[y] = _defaultSize;
                           }
                         }

                         x = y = -1;                                  
                         for (var i:int = 0; i < count; i++) 
                         {         
                                ++x;
                        	// Go to the next line
				if (x == _nbPerRow)
				{
                                        x = 0;
					++y;
				}
                              
                              
			        // Resize the element to its preferred size by passing
				// NaN for the width and height constraints
				element.setLayoutBoundsSize(100, 100);
				
				// Find out the element's dimensions sizes.
				// We do this after the element has been already resized
				// to its preferred size.
				var elementWidth:Number = element.getLayoutBoundsWidth();
				var elementHeight:Number = element.getLayoutBoundsHeight();
				
				// Position the element
				element.setLayoutBoundsPosition(x*100, y*100);
				
				var center:Point = getCenterPosition(element);
				//_positions[i] = center;
				
			}*/
		}

		 private function getCenterPosition(component:ILayoutElement):Point{
			var center:Point = new Point();
			center.x = component.getLayoutBoundsX() + (component.getLayoutBoundsWidth() / 2);
			center.y = component.getLayoutBoundsY() + (component.getLayoutBoundsHeight() / 2);
			return center;
		}
		
		private function distance(point1:Point, point2:Point):Number{
			var dx:Number = point1.x-point2.x;
			var dy:Number = point1.y-point2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		private function getSizeByDistance(distance:Number):Number{
			if(distance == 0) distance = 1;
			var size:Number = _defaultSize / distance;
			
			if(size > _defaultSize) size = _defaultSize;
			else if(size < _defaultSize) size = _defaultSize;
			
			return size;
		}
		
		private function localToGlobal(point:Point):Point{
			point.x += target.x;
			point.y += target.y;
			return point;
		}
		

		

  }               	
}