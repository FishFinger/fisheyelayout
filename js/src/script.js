
window.onload = function(){main()};
var tab;
var cell_width;
var cell_height;
var width = 100;
var height = 100;
var list;

var fact_gro = 0.9;

function main()
{

     var e = document.getElementById("canevas");
    init(e);
    window.addEventListener("mousemove", souris, false);
    
    window.addEventListener("mouseout", souris_out, false);
    // window.onmouseout = souris_out;
}

function init(e)
{
    var cpt = 0;
    tab = new Array();
    tab[0] = new Array();
    col_size = new Array();
    line_size = new Array();
    cell_width = new Array();
    cell_height = new Array();

    for(var i=1; i<106; ++i)
    {
        var img = document.createElement('img');
        img.src = "../res/" + ((i%8)+1) + ".jpg";
        img.setAttribute("class", "fish");
        e.appendChild(img);
    }
    
    list = e.getElementsByTagName('img');

    var x = 0;
    var y = 0;
    var old_y_pos = null;

    for(var i in list)
    {
       var d = list[i];
       if(d.style != null)
        {
            
            if(d.offsetLeft == null)
            {
                d.style.left = "0px";
                d.left = 0;
            }
            else
            {
                d.left = d.offsetLeft;
                d.style.left = d.offsetLeft+"px";
            }
            
            if(d.offsetTop == null)
            {
                d.top = 0;
                d.style.top = "0px";
            }
            else
            {
                d.top = d.offsetTop;
                d.style.top = d.offsetTop+"px" ;
            }
            
            //e.innerHTML = ++cpt +"--"+ e.offsetLeft+", "+e.offsetTop;
            if(old_y_pos == null)
                old_y_pos = d.top;

            if(old_y_pos != d.top)
            {
                x = 0;
                ++y;
                tab[y] = new Array();
                old_y_pos = d.top;
            }

            d.yy = y;
            d.xx = x;
            d.innerHTML = x + "," + y;
            tab[y][x] = d;
            ++x;
            cell_height[y] = height;
            cell_width[x] = width;
        }
    }

    for(var j in list)
    {
        var i = list[j];
        if(i.style != null)
            i.style.position = "absolute";
    }

    
    

}

function distance(x1,y1,x2,y2)
{
    return Math.floor(Math.sqrt(Math.pow(x1-x2,2)+Math.pow(y1-y2,2)));
}


function souris_out(e)
{
    mouseX = e.pageX;
    mouseY = e.pageY;
    if ((mouseY >= 0 && mouseY <= window.innerHeight)
    	&& (mouseX >= 0 && mouseX <= window.innerWidth))
    	return;
    //alert("out");
    var e = document.getElementById("canevas");
    
    var list = e.getElementsByTagName('img');
    for(var j in list)
    {
        var i = list[j];
        if(i.style != null)
        {
            i.style.top = i.top + "px";
            i.style.left = i.left + "px";

            i.style.zIndex = 1;
            i.style.width = width + "px";
            i.style.height = height + "px";
        }
    }
}

function souris(event)
{

  var mouse_x = event.clientX;
  var mouse_y = event.clientY;
  document.getElementById('coordonnes').value = x + ', ' + y;


  var dist = 0;
  var sup;
 
    for(var y in tab)
    {
        dist =  Math.abs(mouse_y - (tab[0][0].top + y*height + height/2));
        sup = parseInt(((fact_gro)/(Math.pow(dist/100,2)+0.33)-(fact_gro))*100);
        cell_height[y] = height + sup;
    }

    for(var x in tab[0])
    {
        dist =  Math.abs(mouse_x - (tab[0][0].left + x*width + width/2));
        sup = parseInt(((fact_gro)/(Math.pow(dist/100,2)+0.33)-(fact_gro))*100);
        cell_width[x] = width + sup;
    }

   /*for(var j in list)
     {
         var i = list[j];
         if(i.style != null)
         {
             var titi = i.xx;
             var w = cell_width[i.xx];
             var h = cell_height[i.yy];
             i.style.top = (parseInt(i.top) - (h/2)) + "px";
             i.style.left = (parseInt(i.left) - (w/2)) + "px";
             
             i.style.zIndex = w+h;
             
             i.style.width = w + "px";
             i.style.height = h + "px";
         }
     }*/

    var pos_x = 0;
    var pos_y = 0;
    var w;
    var h;
    var div;
    
    for(var x in tab[0])
        {
            pos_x += cell_width[x];
        }
    var hackx = ((1+tab[0].length)*width - pos_x) / tab[0].length; 

    for(var y in tab)
        {
            pos_y += cell_height[y];
        }
    var hacky = ((0.5+tab.length)*height - pos_y) / tab.length; 


    pos_x = tab[0][0].left;
    pos_y = tab[0][0].top;
    for(var y in tab)
    {
        for(var x in tab[y])
            {
                div = tab[y][x];
                w = cell_width[div.xx] + hackx;
                h = cell_height[div.yy] + hacky;
                div.style.top =  (pos_y+4) + "px";
                //div.offsetLeft = 0;
                div.style.left = (pos_x+4) + "px";
                //div.offsetTop = 0;
                
                div.style.width = (w-8) + "px";
                div.style.height =  (h-8) + "px";
               
                pos_x += w;
            }
        pos_y += h;
        pos_x = tab[0][0].left;
    }

}
