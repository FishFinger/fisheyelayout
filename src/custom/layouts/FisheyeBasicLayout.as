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
	
	
	public class FisheyeBasicLayout extends LayoutBase
	{
		private var _minSize:Number = 10;
		private var _maxSize:Number = 100;
		private var _spread:Number = 10;
		private var _agglomerate:Number = 50;
		private var _nbPerRow:Number;
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
		
		public function set agglomerate(value:Number):void
		{
			_agglomerate = value;
		}
	
		public function FisheyeBasicLayout()
		{
			super();
		}
		
		public function MousePosition(mousePosition:Point):void
		{
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
		}
		
		override public function updateDisplayList(containerWidth:Number,
												   containerHeight:Number):void
		{
			// The position for the current element
			var x:Number = 0;
			var y:Number = _maxSize * -1;
			
			// The max item per row
			_nbPerRow = Math.round(containerWidth/_maxSize);
			
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
				
				// Resize the element to its preferred size by passing
				// NaN for the width and height constraints
				element.setLayoutBoundsSize(_minSize, _minSize);
				
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
				element.setLayoutBoundsPosition(x - element.getLayoutBoundsWidth()/2 +_maxSize/2, y - element.getLayoutBoundsHeight()/2 + _maxSize/2);
				
				var center:Point = getCenterPosition(element);
				_positions[i] = center;
				
				// Update the current position, add a gap of 10
				x += _maxSize;
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
			point.x += target.x;
			point.y += target.y;
			return point;
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