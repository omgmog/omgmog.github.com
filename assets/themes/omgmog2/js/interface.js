$(function(){
    // bind left/right for going between posts
    $(document).keydown(function(e){
        if (e.keyCode == 37) { 
            $('.prev a').click();
        }
        if(e.keyCode == 39) {
            $('.next a').click();
        }
    });
    // make left/right arrows follow the mouse on y-axis
    var arrow_height = $('.pagination ul li').height()/2;
    $(document).on('mousemove', function(e){
        var offset = $(document).scrollTop();
        var actualypos = e.pageY;

        var ypos = (actualypos-offset)-arrow_height;

        if(ypos>47){
            $('.pagination ul li').css('top',ypos);
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