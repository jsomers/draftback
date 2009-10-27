// This is the implementation of SimpleSwap
// by Jehiah Czebotar
// Version 1.1 - June 10, 2005
// Distributed under Creative Commons
//
// Include this script on your page
// then make image rollovers simple like:
// <img src="/images/ss_img.gif" oversrc="/images/ss_img_over.gif">
//
// http://jehiah.com/archive/simple-swap
// 


function SimpleSwap(el,which){
  el.src=el.getAttribute(which || "origsrc");
}

function SimpleSwapSetup(){
  var x = document.getElementsByTagName("img");
  for (var i=0;i<x.length;i++){
    var oversrc = x[i].getAttribute("oversrc");
    if (!oversrc) continue;
      
    // preload image
    // comment the next two lines to disable image pre-loading
    x[i].oversrc_img = new Image();
    x[i].oversrc_img.src=oversrc;
    // set event handlers
    x[i].onmouseover = new Function("SimpleSwap(this,'oversrc');");
    x[i].onmouseout = new Function("SimpleSwap(this);");
    // save original src
    x[i].setAttribute("origsrc",x[i].src);
  }
}

var PreSimpleSwapOnload =(window.onload)? window.onload : function(){};
window.onload = function(){PreSimpleSwapOnload(); SimpleSwapSetup();}

