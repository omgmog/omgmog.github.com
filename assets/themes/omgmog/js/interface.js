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

    // sort tags
    var tags = [];
    var lis = $("ul.tags_list li");
    $("ul.tags_list li").each(function(){
        tags.push($(this).html());
    });
    tags.sort();
    $("ul.tags_list li").each(function(i){
        $(this).html(tags[i]);
    });

    // sort lists
    var list = [];
    var ids = [];
    var sections = $("section.tag_posts");
    $("section.tag_posts").each(function(){
        list.push($(this).html());
        ids.push($(this).attr("id"));
    });
    list.sort();
    ids.sort();
    $("section.tag_posts").each(function(i){
        $(this).html(list[i]);
        $(this).removeAttr("id").attr("id",ids[i]);
    });



    $("ul.tags_list a").on('click',function(e){
        e.preventDefault();
        var hash = $(this).attr('href');
            hash = hash.split('#');
            hash = '#'+hash[1];
        $('html,body').animate({scrollTop:($(hash).offset().top)},0);
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