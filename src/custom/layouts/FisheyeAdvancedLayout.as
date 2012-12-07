package custom.layouts
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.core.ILayoutElement;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.supportClasses.LayoutBase;
	
	
	public class FisheyeAdvancedLayout extends LayoutBase
	{
		private var _minSize:Number = 10;
		private var _maxSize:Number = 100;
		private var _spread:Number = 10;
		private var _agglomerate:Number = 100;
		private var _gap:Number = 10;
		private var _nbPerRow:Number;
		
		private var _components:Array = new Array();
		private var _positions:Array = new Array();
		
		
		public function set minSize(value:Number):void
		{
			_minSize = value;
		}
		
		public function set maxSize(value:Number):void
		{
			_maxSize = value;
		}
		
		public function set spread(value:Number):void
		{
			_spread = value;
		}
		
		public function set gap(value:Number):void
		{
			_gap = value;
		}
		
		public function set agglomerate(value:Number):void
		{
			_agglomerate = value;
		}
	
		public function FisheyeAdvancedLayout()
		{
			super();
		}
		
		public function MousePosition(mousePosition:Point):void
		{
			var dist:Number = -1;
			var component:ILayoutElement;
			var noRow:int;
			var noCol:int;
			var c:ILayoutElement;
						
			for (var row:int = 0; row < _positions.length; row++) 
			{
				for (var col:int = 0; col < _positions[row].length; col++)
				{
					var center:Point = localToGlobal(_positions[row][col]);
					center.x += _minSize / 2;
					center.y += _minSize / 2;
					var tmpdist:Number = distance(mousePosition,center);
					
					c = _components[row][col];
					c.setLayoutBoundsPosition(_positions[row][col].x,_positions[row][col].y);
					c.setLayoutBoundsSize(_minSize,_minSize);
					
					
					if(dist < 0 || dist > tmpdist){
						dist = tmpdist;
						component = c;
						noRow = row;
						noCol = col;
					}
				}
			}
			setElementSize(component,getSizeByDist(dist), getSizeByDist(dist));
			
			doCol(noRow,noCol);
		}
		
		private function getSizeByDist(dist:int):int
		{
			if(dist < 1) dist = 1;
			var size:int = _maxSize / (dist / 40);
			//if(size < _minSize) size = _minSize;
			//if(size > _maxSize) size = _maxSize;
			return size;
		}
		

		private function doCol(noRow:int, noCol:int):void
		{
			var row:int;
			var component:ILayoutElement = _components[noRow][noCol];
			var initialSize:Number = component.getLayoutBoundsWidth();
			var coeff:Number = 1.5;
			var c:ILayoutElement;
			var previousComponent:ILayoutElement;
			var PCwidth:int;
			var PCy:int;
			var y:int;
			var shiftY:int;
			
			doRow(noRow,noCol,0);
			
			var size:Number = initialSize;
			for(row = noRow + 1; row < _components.length; row++){
				size /= coeff;
				c = _components[row][noCol];
				setElementSize(c,size,size);
				
				// Positionning
				if(row - 1 > -1)
				{
					previousComponent = _components[row-1][noCol];
					PCwidth = previousComponent.getLayoutBoundsWidth();
					PCy = previousComponent.getLayoutBoundsY();
					
					y = PCy + _gap + PCwidth;
					shiftY = y - c.getLayoutBoundsY();
					c.setLayoutBoundsPosition(c.getLayoutBoundsX(),y);
					doRow(row,noCol,shiftY);
				}
			}
			size = initialSize;
			for(row = noRow - 1; row > -1; row--){
				size /= coeff;
				c = _components[row][noCol];
				setElementSize(c,size,size);
				
				// Positionning
				if(row + 1 < _components.length)
				{
					previousComponent = _components[row+1][noCol];
					PCwidth = previousComponent.getLayoutBoundsWidth();
					PCy = previousComponent.getLayoutBoundsY();
					
					y = PCy - _gap - size;
					shiftY = y - c.getLayoutBoundsY();
					c.setLayoutBoundsPosition(c.getLayoutBoundsX(), y);
					
					doRow(row,noCol,shiftY);
				}
			}
		}
		
		private function doRow(noRow:int, noCol:int, shiftY:int):void
		{
			var col:int;
			var component:ILayoutElement = _components[noRow][noCol];
			var initialSize:Number = component.getLayoutBoundsWidth();
			var coeff:Number = 1.5;
			var c:ILayoutElement;
			var previousComponent:ILayoutElement;
			var PCwidth:int;
			var PCx:int;
			var x:int;
			
			
			var size:Number = initialSize;
			for(col = noCol - 1; col > -1; col--){
				size /= coeff;
				c = _components[noRow][col];
				setElementSize(c,size,size);
				
				// Positionning
				if(col + 1 < _components[noRow].length)
				{
					previousComponent = _components[noRow][col+1];
					PCwidth = previousComponent.getLayoutBoundsWidth();
					PCx = previousComponent.getLayoutBoundsX();
					
					x = PCx - _gap - size;
					c.setLayoutBoundsPosition(x,c.getLayoutBoundsY() + shiftY);
				}
			}
			size = initialSize;
			for(col = noCol + 1; col < _components[noRow].length; col++){
				size /= coeff;
				c = _components[noRow][col];
				setElementSize(c,size,size);
				
				// Positionning
				if(col - 1 > -1)
				{
					previousComponent = _components[noRow][col-1];
					PCwidth = previousComponent.getLayoutBoundsWidth();
					PCx = previousComponent.getLayoutBoundsX();
					
					x = PCx + _gap + PCwidth;
					c.setLayoutBoundsPosition(x,c.getLayoutBoundsY() + shiftY);
				}
			}
		}
		
		private function setElementSize(component:ILayoutElement, width:int, height:int):void
		{
			var oldwidth:int = component.getLayoutBoundsWidth();
			var oldheight:int = component.getLayoutBoundsHeight();
			
			component.setLayoutBoundsSize(width,height);
			
			var x:int = component.getLayoutBoundsX();
			var y:int = component.getLayoutBoundsY();
			
			if(oldwidth < width)
				x -= (width - oldwidth) / 2;
			else
				x += (oldwidth - width) / 2;
			
			if(oldheight < height)
				y -= (height - oldheight) / 2;
			else
				y += (oldheight - height) / 2;
			
			component.setLayoutBoundsPosition(x,y);
		}
		
		override public function updateDisplayList(containerWidth:Number,
												   containerHeight:Number):void
		{
			// The position for the current element
			var x:Number = 0;
			var y:Number = 0;
			
			// The max item per row
			_nbPerRow = Math.round(containerWidth/(_minSize+_gap));
			
			// loop through the elements
			var layoutTarget:GroupBase = target;
			var count:int = layoutTarget.numElements;
			
			var noRow:int = 0;
			var noCol:int = 0;
			_components[noRow] = new Array();
			_positions[noRow] = new Array();
			for (var i:int = 0; i < count; i++)
			{
				// get the current element, we're going to work with the
				// ILayoutElement interface
				var element:ILayoutElement = useVirtualLayout ? 
					layoutTarget.getVirtualElementAt(i) :
					layoutTarget.getElementAt(i);
				
				// Resize the element to its preferred size by passing
				// NaN for the width and height constraints
				element.setLayoutBoundsSize(_minSize, _minSize);
				
				if (i % _nbPerRow == 0)
				{
					// Start from the left side
					x = 0;
					noCol = 0;
					
					// Move down by elementHeight, we're assuming all 
					// elements are of equal height
					y += _minSize+_gap;
					noRow++;
					_components[noRow] = new Array();
					_positions[noRow] = new Array();
				}
				
				// Position the element
				element.setLayoutBoundsPosition(x, y);
				_positions[noRow][noCol] = new Point(x,y);
				_components[noRow][noCol] = element;
				
				// Update the current position, add a gap of 10
				x += _minSize+_gap;
				noCol++;
			}
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
			var size:Number = _maxSize / (distance / _spread);
			
			if(size > _maxSize) size = _maxSize;
			else if(size < _minSize) size = _minSize;
			
			return size;
		}
		
		private function localToGlobal(point:Point):Point{
			var retour:Point = point.clone();
			retour.x += target.x;
			retour.y += target.y;
			return retour;
		}
		
		private function getPositionByMouse(mousePosition:Point,elementPosition:Point):Point{
			var distanceX:Number = Math.abs(mousePosition.x - elementPosition.x);
			var distanceY:Number = Math.abs(mousePosition.y - elementPosition.y);
			var distance:Number = distance(mousePosition,elementPosition);
			
			var xTranslation:Number = getXFreeSpace(mousePosition,elementPosition);
			var yTranslation:Number = getYFreeSpace(mousePosition,elementPosition);
			
			if(mousePosition.x < elementPosition.x) xTranslation *= -1;
			if(mousePosition.y < elementPosition.y) yTranslation *= -1;
			
			var x:Number = elementPosition.x + xTranslation;
			var y:Number = elementPosition.y + yTranslation;
			return new Point(x,y);
		}
		
		private function getXFreeSpace(point1:Point,point2:Point):Number{
			var distance:Number = Math.abs(point1.x - point2.x);
			return distance / _agglomerate;
		}
		
		private function getYFreeSpace(point1:Point,point2:Point):Number{
			var distance:Number = Math.abs(point1.y - point2.y);
			return distance / _agglomerate;
		}
	}
}