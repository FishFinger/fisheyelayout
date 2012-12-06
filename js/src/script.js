
window.onload = function(){main()};

function main()
{

     var e = document.getElementById("canevas");
    init(e);
    e.addEventListener("mousemove", souris, false);
     
}

function init(e)
{
   var cpt = 0;

    for(var i=1; i<67; ++i)
    {
        var img = document.createElement('img');
        img.src = "../res/" + ((i%8)+1) + ".jpg";
        img.setAttribute("class", "fish");
        e.appendChild(img);
        
    }
    
    var list = e.getElementsByTagName('img');

    for each (var i in list)
    {
       if(i.style != null)
        {
            if(i.offsetLeft == null)
            {
                i.style.left = "0px";
                i.left = 0;
            }
            else
            {
                i.left = i.offsetLeft;
                i.style.left = i.offsetLeft+"px";
            }
            
            if(i.offsetTop == null)
            {
                i.top = 0;
                i.style.top = "0px";
            }
            else
            {
                i.top = i.offsetTop;
                i.style.top = i.offsetTop+"px" ;
            }
            
            i.innerHTML = ++cpt +"--"+ i.offsetLeft+", "+i.offsetTop;
  
        }
    }

    for each (var i in list)
    {
        if(i.style != null)
            i.style.position = "absolute";
    }
    

}

function distance(x1,y1,x2,y2)
{
    return Math.floor(Math.sqrt(Math.pow(x1-x2,2)+Math.pow(y1-y2,2)));
}


function souris(event)
{

  var x = event.clientX;
  var y = event.clientY;
  document.getElementById('coordonnes').value = x + ', ' + y;

  var e = document.getElementById("canevas");
  var width = 100;
  var height = 100;
    var dist = 0;
    var sup;
     for each (var i in e.getElementsByTagName('img'))
    {
        if(i.style != null)
        {
            width = 100;
            height = 100;
            dist =  distance(i.left+width/2, i.top+height/2 ,x,y);
            sup = Math.max((200 - (dist/2)),0);
            width = sup + 100;
            height = sup + 100;

            i.style.top = (parseInt(i.top) - (sup/2)) + "px";
            i.style.left = (parseInt(i.left) - (sup/2)) + "px";

            i.style.zIndex = sup;
            i.style.width = width + "px";
            i.style.height = height + "px";
        }
    }
}
