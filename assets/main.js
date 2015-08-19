(function(window, $) {
    'use strict';
    var sections = ['.featured-posts', '.recent-posts', '.recent-reviews'];

    var console = window.console;

    var tpl = function(template, data) {
        for (var token in data) {
            var value = data[token];
            template = template.replace(new RegExp("{" + token + "}", "g"), value);
        }
        return template;
    };

    var handle_data = function(data) {
        $.each(sections, function(i, v) {
            var $this = $(v);
            var key = v.split('.')[1];
            var dataset = data[key];

            if ($this.length) {
                var html = '';
                $.each(dataset, function() {
                    html += tpl('<li><a href="{link}" title="Published on {published}">{title}</a></li>', this);
                });

                $this.html(html);
            }
        });

    };

    var fetch_feed = function() {
        var url = '/posts.json';

        $.ajax(url).done(handle_data);
    };

    $(function() {
        fetch_feed();
    });
}(window, window.jQuery));
