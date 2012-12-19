
window.onload = function(){main()};
var tab;
var cell_width;
var cell_height;
var width = 100;
var height = 100;
var space = 8;
var list;
var MODE_SQUARE = true;

var fact_gro = 0.8;

function main()
{
    var e = document.getElementById("canevas");
    init(e);
    window.addEventListener("mousemove", souris, false);
    window.addEventListener("mouseout", souris_out, false); 
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

    for(var i=1; i<85; ++i)
    {
        var div = document.createElement('div');
        div.setAttribute("class", "fish");
        div.style.width = width + "px";
        div.style.height = height + "px";
        e.appendChild(div);
    }
    
    list = e.getElementsByTagName('div');

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
            
            if(old_y_pos == null)
                old_y_pos = d.top;

            if(old_y_pos != d.top)
            {
                x = 0;
                tab[++y] = new Array();
                old_y_pos = d.top;
            }

            d.yy = y;
            d.xx = x;
            tab[y][x] = d;
            cell_height[y] = height;
            cell_width[x] = width;
            ++x;
        }
    }

    for(var i in list)
    {
        var div = list[i];
        if(div.style != null)
            div.style.position = "absolute";
    }

}

function distance(x,y)
{
    return Math.abs(x-y);
}

/*function distance(x1,y1,x2,y2)
{
    return Math.floor(Math.sqrt(Math.pow(x1-x2,2)+Math.pow(y1-y2,2)));
}*/


function souris(event)
{

    var mouse_x = event.clientX;
    var mouse_y = event.clientY;
    document.getElementById('coordonnes').value = mouse_x + ', ' + mouse_y;

    var dist = 0;
    var sup;
 
    for(var y in tab)
    {
        dist =  distance(mouse_y, (tab[0][0].top + y*(height+space) + height/2));
        sup = parseInt(((fact_gro)/(Math.pow(dist/100,2)+0.33)-(fact_gro))*100);
        cell_height[y] = height + sup;
    }

    for(var x in tab[0])
    {
        dist =  Math.abs(mouse_x - (tab[0][0].left + x*(width+space) + width/2));
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
    var hacky = ((1+tab.length)*height - pos_y) / tab.length; 


    pos_x = tab[0][0].left;
    pos_y = tab[0][0].top;
    var img_w;
    var img_h;
    var ww;
    for(var y in tab)
    {
        for(var x in tab[y])
            {
                div = tab[y][x];
                w = cell_width[div.xx] + hackx;
                h = cell_height[div.yy] + hacky;
                div.style.top =  (pos_y) + "px";
                div.style.left = (pos_x) + "px";
                
                if(MODE_SQUARE)
                {
                    if(w > h)
                        ww = h;
                    else
                        ww = w;
                    
                    div.style.width = (ww-space) + "px";
                    div.style.height =  (ww-space) + "px";
                    div.style.top = (pos_y + (h-ww)/2) + "px";
                    div.style.left = (pos_x + (w-ww)/2) + "px";
                    
                }
                else
                {
                    div.style.width = (w-space) + "px";
                    div.style.height =  (h-space) + "px";
                }
                /*img =  div.childNodes[0];
                img.style.width = (w-8) + "px";
                img.style.height = (h-8) + "px";*/

                /*img_w = img.width;
                img_h = img.height;
                if(w < h)
                {
                    img.style.width = (w-10) + "px";
                    img_h = ((w-10)* (img_h/img_w));
                    img.style.height = img_w + "px";
                    img.style.position = "relative";
                    img.style.top = (((h-10) - img_w)/2) + "px";
                }
                else
                {
                    img.style.height = (h-10) + "px";
                    img.style.width = ((h-10)* (img_w/img_h)) + "px";
                }*/
       
                pos_x += w + space;
            }
        pos_y += h + space;
        pos_x = tab[0][0].left;
    }

}



function souris_out(e)
{
    mouseX = e.pageX;
    mouseY = e.pageY;
    if ((mouseY >= 0 && mouseY <= window.innerHeight)
    	&& (mouseX >= 0 && mouseX <= window.innerWidth))
    	return;
    
    for(var i in list)
    {
        var div = list[i];
        if(div.style != null)
        {
            div.style.top = div.top + "px";
            div.style.left = div.left + "px";
            div.style.width = width + "px";
            div.style.height = height + "px";
        }
    }
}
