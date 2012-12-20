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
      Alert.show("Construct");
    }
		
    public function MousePosition(mousePosition:Point):void
    {
      // The position for the current element
      var x:Number = -1;
      var y:Number = -1;
      
      resetCellSize();			

      // loop through the elements
      var layoutTarget:GroupBase = target;
      var count:int = layoutTarget.numElements;
      for (var i:int = 0; i < count; i++)
      {
            x += 1;	      
                            if(x == _nbPerRow)
                            {
                                 y += 1;     
                                 x = 0;   
                            }   
					
	// Get de distance between mouse and element
	var size:Number = getSizeByDistance(distance(localToGlobal(getCenterPosition(x,y)),mousePosition));
        _cell_width[x] = size;
        _cell_height[y] = size;	
			
				
	// Find out the element's dimensions sizes.
	// We do this after the element has been already resized
	// to its preferred size.
	var elementWidth:Number = element.getLayoutBoundsWidth();
	var elementHeight:Number = element.getLayoutBoundsHeight();
				
        refresh();
      }
	// Go to the next line
	/*if (i % _nbPerRow == 0)
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
			}*/
                        
 
		}
		
		override public function updateDisplayList(containerWidth:Number, containerHeight:Number):void
		{
			// The position for the current element
			var x:Number = -1;
			var y:Number = -1;
		

                        if(!_init)
                        {                           

                        	
	                var layoutTarget:GroupBase = target;  
		        var count:int = layoutTarget.numElements;
                        var i:int;
                        var element:ILayoutElement;    
			  // The max item per row
			  _nbPerRow = Math.round(containerWidth/_defaultSize);
                          for(i = 0; i < count ; i++)
                             _grid[i] = new Array();
			
			  // loop through the elements
		
			  for (i = 0; i < count; i++)
			  {
			    // get the current element, we're going to work with the
			    element = useVirtualLayout ? 
					layoutTarget.getVirtualElementAt(i) :
					layoutTarget.getElementAt(i);
                                  
                            x += 1;	      
                            if(x == _nbPerRow)
                            {
                                 y += 1;     
                                 x = 0;   
                            }                   

                            _grid[x][y] = element;
                            _cell_width[x] = _defaultSize;
                            _cell_height[y] = _defaultSize;
                           }
                           _init = true;
                         }

                    
		}

                private function refresh():void
                {
                     var x:Number;
                     var y:Number;
                     x = y = -1;            
	
	                var layoutTarget:GroupBase = target;  
		        var count:int = layoutTarget.numElements;
                        var i:int;
                        var element:ILayoutElement;                      
                         for (i = 0; i < count; i++) 
                         {         
                                
                                ++x;
                        	// Go to the next line
				if (x == _nbPerRow)
				{
                                        x = 0;
					++y;
				}

                                // get the current element, we're going to work with the
			         element = useVirtualLayout ? 
					layoutTarget.getVirtualElementAt(i) :
					layoutTarget.getElementAt(i);
                                                              
			        // Resize the element to its preferred size by passing
				element.setLayoutBoundsSize(_cell_width[x], _cell_height[y]);
				
				// Find out the element's dimensions sizes.
				// We do this after the element has been already resized
				// to its preferred size.
				var elementWidth:Number = element.getLayoutBoundsWidth();
				var elementHeight:Number = element.getLayoutBoundsHeight();
				
				// Position the element
				element.setLayoutBoundsPosition(x*(_defaultSize+_space), y*(_space+_defaultSize));
			}
                }               


		 private function getCenterPosition(x:int,y:int):Point{
			var center:Point = new Point();
			center.x = _defaultSize*x + _defaultSize / 2;
			center.y = _defaultSize*y + _defaultSize / 2;
			return center;
		}
		
		private function distance(point1:Point, point2:Point):Number{
			var dx:Number = point1.x-point2.x;
			var dy:Number = point1.y-point2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		private function getSizeByDistance(distance:Number):Number{
                        
                        distance = distance / _attenuation;
                        var size:Number = _defaultSize + 
                            (_fact_gro/((distance*distance)+0.33)-(_fact_gro))*100;

			return size;
		}
		
		private function localToGlobal(point:Point):Point{
			point.x += target.x;
			point.y += target.y;
			return point;
		}

                private function resetCellSize():void
                {
                        var i:int;
                        for(i = 0; i< _cell_width.length; i++)
                           _cell_width[i] = 0;
                           
                        for(i = 0; i< _cell_height.length; i++)
                           _cell_height[i] = 0;
                }
		

		

  }               	
}