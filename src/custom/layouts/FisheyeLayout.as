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
	
	
	public class FisheyeLayout extends LayoutBase
	{
		private var _minSize:Number = 10;
		private var _maxSize:Number = 100;
		private var _spread:Number = 10;
		private var _agglomerate:Number = 100;
		private var _nbPerRow:Number;
		private var _positions:Array = new Array();
		
		
		public function set minSize(value:Number):void
		{
			this._minSize = value;
		}
		
		public function set maxSize(value:Number):void
		{
			this._maxSize = value;
		}
		
		public function set spread(value:Number):void
		{
			this._spread = value;
		}
		
		public function set agglomerate(value:Number):void
		{
			this._agglomerate = value;
		}
	
		public function FisheyeLayout()
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
				var size:Number = this.getSizeByDistance(this.distance(this.localToGlobal(this.getCenterPosition(element)),mousePosition));
				
				// Resize the element to its preferred size by passing
				// NaN for the width and height constraints
				element.setLayoutBoundsSize(size, size);
				
				// Find out the element's dimensions sizes.
				// We do this after the element has been already resized
				// to its preferred size.
				var elementWidth:Number = element.getLayoutBoundsWidth();
				var elementHeight:Number = element.getLayoutBoundsHeight();
				
				// Go to the next line
				if (i % this._nbPerRow == 0)
				{
					// Start from the left side
					x = 0;
					
					// Move down by elementHeight, we're assuming all 
					// elements are of equal height
					y += _maxSize;
				}
				
				// Position the element
				var position:Point = this.getPositionByMouse(mousePosition,this._positions[i]);
				element.setLayoutBoundsPosition(position.x - elementWidth / 2 ,position.y - elementHeight / 2);
				//element.setLayoutBoundsPosition(this._positions[i].x - elementWidth / 2, this._positions[i].y - elementHeight / 2);
				
				// Update the current position, add a gap of 10
				x += _maxSize;
			}
		}
		
		override public function updateDisplayList(containerWidth:Number,
												   containerHeight:Number):void
		{
			// The position for the current element
			var x:Number = 0;
			var y:Number = 0;
			
			// The max item per row
			this._nbPerRow = Math.round(containerWidth/this._maxSize);
			
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
				element.setLayoutBoundsSize(this._minSize, this._minSize);
				
				// Find out the element's dimensions sizes.
				// We do this after the element has been already resized
				// to its preferred size.
				var elementWidth:Number = element.getLayoutBoundsWidth();
				var elementHeight:Number = element.getLayoutBoundsHeight();
				
				// Go to the next line
				if (i % this._nbPerRow == 0)
				{
					// Start from the left side
					x = 0;
					
					// Move down by elementHeight, we're assuming all 
					// elements are of equal height
					y += _maxSize;
				}
				
				// Position the element
				element.setLayoutBoundsPosition(x - element.getLayoutBoundsWidth()/2 +_maxSize/2, y - element.getLayoutBoundsHeight()/2 + _maxSize/2);
				
				var center:Point = this.getCenterPosition(element);
				this._positions[i] = center;
				
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
			var size:Number = this._maxSize / (distance / this._spread);
			
			if(size > this._maxSize) size = this._maxSize;
			else if(size < this._minSize) size = this._minSize;
			
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
			var distance:Number = this.distance(mousePosition,elementPosition);
			
			var xTranslation:Number = this.getXFreeSpace(mousePosition,elementPosition);
			var yTranslation:Number = this.getYFreeSpace(mousePosition,elementPosition);
			
			if(mousePosition.x < elementPosition.x) xTranslation *= -1;
			if(mousePosition.y < elementPosition.y) yTranslation *= -1;
			
			var x:Number = elementPosition.x + xTranslation;
			var y:Number = elementPosition.y + yTranslation;
			return new Point(x,y);
		}
		
		private function getXFreeSpace(point1:Point,point2:Point):Number{
			var distance:Number = Math.abs(point1.x - point2.x);
			return distance / this._agglomerate;
		}
		
		private function getYFreeSpace(point1:Point,point2:Point):Number{
			var distance:Number = Math.abs(point1.y - point2.y);
			return distance / this._agglomerate;
		}
	}
}