(function () {
  'use strict';

  if (!'fetch' in window) return;
  const comments_element = document.getElementById('comments');
  const comments_issue = comments_element.dataset.issue;
  const issues_url = "https://api.github.com/repos/omgmog/omgmog.github.com/issues/";
  const issue_url = `${issues_url}${comments_issue}`;

  const comment_template = document.getElementById('comment-template');

  const tpl = (string, data) => {
    for (var token in data) {
      var value = data[token];
      string = string.replace(new RegExp('%' + token + '%', 'g'), value);
    }
    return string;
  };

  // First determine if comments are open or closed
  const github_api = "application/vnd.github.v3.full+json";
  window
    .fetch(issue_url, {Accept: github_api, cache: "force-cache"})
    .then(response => {
      if (!response.ok) {
        console.log(response.status);
      } else {
        response.json().then(issue => {
          if (issue.state === "closed") {
            document.querySelector('.comments-closed').style.display = 'inline';
            document.querySelector('.comments-open').remove();
          }
          if (issue.comments > 0) {
            document.querySelector('.no-comments').remove();
            window
              .fetch(issue.comments_url, {Accept: github_api, cache: "force-cache"})
              .then(response => response.json())
              .then(comments => {
                  comments.forEach((comment) => {
                    // console.log(comment);
                    let comment_markup = tpl(comment_template.innerHTML, {
                      avatar: `${comment.user.avatar_url}&size=60`,
                      author: comment.user.login,
                      author_url: comment.user.html_url,
                      body: marked(comment.body),
                      comment_class: comment.author_association.toLowerCase(),
                      who: comment.author_association === 'OWNER' ? 'Author' : 'Guest',
                      date: comment.created_at,
                      date_fmt: new Intl.DateTimeFormat('default', {
                        year: 'numeric', 
                        month: 'short', 
                        day: 'numeric'
                      }).format(new Date(comment.created_at)),
                      url: comment.html_url
                    });
                    comments_element.innerHTML += comment_markup;
                  });
              });
          }
        });
      }
    });


}());
