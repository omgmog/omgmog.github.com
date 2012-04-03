$(function(){
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
		if(!isMobile && ($(window).width() > 480)){
        	fancy_post_header();
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
    $("a.pjax").live('click', function(e){
        if($.support.pjax) e.preventDefault();
        $(".metanav .active").removeClass("active");
    }).pjax({
        url:$(this).attr("href"),
        container:'#post',
        fragment:'#post'
    });
    $("#post")
    .on('pjax:start', function() { 
    })
    .on('pjax:end',   function() { 
        $('html,body').animate({scrollTop: ($("#post").offset().top - 46)},'slow');   
    });

    $(".pagination a").live('click',function(e){
        if($.support.pjax) e.preventDefault();
        $(".nav .active").removeClass("active");
    }).pjax({
        url: $(this).attr("href"),
        container:'.page-container',
        fragment:'.page-container'
    });
    $(".page-container")
    .on('pjax:start',function(){
        $('html,body').animate({scrollTop: ($("html").offset().top)},0);   
    })
    .on('pjax:end',function(){
    });
});


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