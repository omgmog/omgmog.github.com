$(function(){
    $(".page-container").fadeTo('fast',1,function(){
        $("#disqus_thread").show();
    });
	var isMobile = false;

	// Identify if visitor on mobile with lame sniffing to remove parallaxing title
	if( navigator.userAgent.match(/Android/i) ||
	    navigator.userAgent.match(/webOS/i) ||
	    navigator.userAgent.match(/iPhone/i) ||
	    navigator.userAgent.match(/iPod/i) ||
	    navigator.userAgent.match(/iPad/i) ||
	    navigator.userAgent.match(/BlackBerry/)
	){
	  isMobile = true;
	}
	$header = $(".fancy-post-header");
	$header_inner = $(".fancy-post-header-inner");
	$(window).scroll(function() {
        if($('.fancy-post-header:in-viewport').length){
            if(!isMobile && ($(window).width() > 480)){
                fancy_post_header();
            }
        }
    });

    if($(".page-container").height()<$(window).height()){
        $(".page-container").css('min-height',$(window).height());
    }
    $(window).on('resize',function(){
        if($(".page-container").height()<$(window).height()){
            $(".page-container").css('min-height',$(window).height());
        }
    });

    $(".pagination li:not('.disabled') a").on('click',function(e){
        if($.support.pjax) e.preventDefault();
        var url = $(this).attr("href")
        $(".active").removeClass("active");
        $.pjax({
            url: url,
            container: '.page-container',
            fragment: '.page-container'
        });
    });

    $(".page-container")
    .on('pjax:beforeSend',function(){
        // tidy up before we load then
        $('iframe:not(".yt-embed"), script[src*="disqus"], link[href*="disqus"], script[src*="ga.js"]').remove();
        $("#disqus_thread").hide();
    })
    .on('pjax:start',function(){
        $('html,body').animate({scrollTop: ($("html").offset().top)},0);   
        $(".page-container").fadeTo('fast',0.5);
    });



    sortstuff("ul.tags_list li");
    sortstuff("section.tag_posts","id");

    $("ul.tags_list a").on('click',function(e){
        e.preventDefault();
        var hash = $(this).attr('href');
            hash = hash.split('#');
            hash = '#'+hash[1];
        $('html,body').animate({scrollTop:($(hash).offset().top)},0);
    });
});


function sortstuff(selector,attribute){
    var $selector = $(selector);
    var matches = [];
    var attrs = [];
    $selector.each(function(){
        matches.push($(this).html());
        if(attribute){
            attrs.push($(this).attr(attribute));
        }
    });

    matches.sort();
    if(attribute){
        attrs.sort();
    }

    $selector.each(function(i){
        $(this).html(matches[i]);
        if(attribute){
            $(this).removeAttr(attribute).attr(attribute,attrs[i]);
        }
    });
}
function fancy_post_header(){
	var windowScroll = $(this).scrollTop();
    var scale_amt = windowScroll*0.01;
	$header_inner.css({
      'margin-bottom' : (windowScroll/3)+"px",
      'opacity' : 1-(windowScroll/410),
      '-moz-transform' : 'scale(' + (1+((scale_amt)>0?scale_amt:0)) + ')',
      '-webkit-transform' : 'scale(' + (1+((scale_amt)>0?scale_amt:0)) + ')',
      'transform' : 'scale(' + (1+((scale_amt)>0?scale_amt:0)) + ')'
    });
    $header.css({
      'background-position' : 'center ' + (-windowScroll/3)+"px"
    });
}