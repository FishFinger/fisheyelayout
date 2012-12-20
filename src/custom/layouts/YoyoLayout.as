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
	private var _square_mod:Boolean = false;
	
    private var _space:Number = 4;	

    private var _nb_line:Number = 0;
    private var _nb_col:Number = 0;
	
	public function set factGro(value:Number):void
	{
		_fact_gro = value;
	}
	
	public function set attenuation(value:Number):void
	{
		_attenuation = value;
	}
	
	public function set squareMod(value:Boolean):void
	{
		_square_mod = value;
	}
	
	public function majFactGro(value:Number):void
	{
		_fact_gro = value;
	}
	
	public function majAttenuation(value:Number):void
	{
		_attenuation = value;
	}
	
	public function majSquareMod(value:Boolean):void
	{
		_square_mod = value;
	}

		
    public function YoyoLayout()
    {
      super();
     
    }
		
    public function MousePosition(mousePosition:Point):void
    {
      // The position for the current element
      var x:Number = -1;
      var y:Number = 0;
      
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
        if(_cell_width[x] < size)
          _cell_width[x] = size;

        if(_cell_height[y] < size)
          _cell_height[y] = size;	
			
        refresh();
      }
      }
		
		override public function updateDisplayList(containerWidth:Number, containerHeight:Number):void
		{
			// The position for the current element
			var x:Number = -1;
			var y:Number = 0;
		

                        if(!_init)
                        {                           

                        	
	                var layoutTarget:GroupBase = target;  
		        var count:int = layoutTarget.numElements;
                        var i:int;
                        var element:ILayoutElement;    
			  // The max item per row
			  _nbPerRow = Math.round(containerWidth/(_defaultSize+_space*2));
                          for(i = 0; i < 12 ; i++)
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
                            if(x > _nb_col)
                               _nb_col = x;
                           }
                           _init = true;
                           _nb_line = y;
                         }
                         _nb_col++;
                         _nb_line++;

                    
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
                     
                     var pos_x:Number = 0;
                     var pos_y:Number = 0;   
                    
                    for(i = 0; i < _nb_col; i++)
                       pos_x += _cell_width[i];
    
                    var hackx:Number = (_defaultSize*_nb_col - pos_x) / _nb_col; 
                    

                    for(i = 0; i < _nb_line; i++)
                       pos_y += _cell_height[i];
        
                    var hacky:Number = (_defaultSize*_nb_line - pos_y) / _nb_line; 


                    pos_x = 0;
                    pos_y = target.y;   
                   
                        var h:Number;
                        var w:Number;
                      
                        for( x = 0; x < _grid.length; x++)
                        {
                          for( y = 0; y < _grid[x].length; y++)
                          {
                                w = _cell_width[x] + hackx;
                                h = _cell_height[y] + hacky;
                                // get the current element, we're going to work with the
		                element = _grid[x][y];
                               
                               
                                if(_square_mod)
                                {
                                 var size:int;
                                  size = min(w,h);
                    
                                     element.setLayoutBoundsSize(size,size);
                                 
                                        // Position the element
			        element.setLayoutBoundsPosition(
                                   pos_x + (w-size)/2, 
                                   pos_y + (h-size)/2
                                   );
                    
                                }
                                else
                                {
                                                                                            
		                     // Resize the element to its preferred size by passing
			             element.setLayoutBoundsSize(w, h);
                                     // Position the element
			        element.setLayoutBoundsPosition(
                                   pos_x, 
                                   pos_y
                                   );
                                 }
				
			        // Find out the element's dimensions sizes.
			        // We do this after the element has been already resized
			        // to its preferred size.
			        var elementWidth:Number = element.getLayoutBoundsWidth();
			        var elementHeight:Number = element.getLayoutBoundsHeight();
				
			     
			
                                pos_y += h + 2*_space;
                           }
                         pos_x += w + 2*_space;
                         pos_y = target.y;                          
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
		
                private function min(x:int, y:int):int
                {               
                  return (x<y)? x : y;
                }
		

  }               	
}