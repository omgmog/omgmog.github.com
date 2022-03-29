(function () {
    'use strict';
    if (!'fetch' in window) return;

    const GH_FETCH_OPTS = {Accept: "application/vnd.github.v3.full+json", cache: "force-cache"};
  
    const TYPES = {
        'comment': {
            template: document.getElementById('tpl-reply').innerHTML,
            element: '#comments',
            attributes: {
                verb: 'commented',
                author_name: ['user', 'login'],
                author_avatar_url: ['user', 'avatar_url'],
                author_url: ['user', 'html_url'],
                date: ['created_at'],
                body: ['body'],
                url: ['html_url'] 
            }
        },
        'reply': {
            template: document.getElementById('tpl-reply').innerHTML,
            element: '#replies',
            attributes: {
                verb: 'replied',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                author_url: ['author', 'url'],
                date: ['published'],
                body: ['content', 'text'],
                url: ['url']
            }
        },
        'like': {
            template: document.getElementById('tpl-like').innerHTML,
            element: '#likes',
            attributes: {
                verb: 'Liked',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '❤️'
            }
        },
        'bookmark': {
            template: document.getElementById('tpl-bookmark').innerHTML,
            element: '#bookmarks',
            attributes: {
                verb: 'Bookmarked',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '⭐'
            }
        },
        'repost': {
            template: document.getElementById('tpl-repost').innerHTML,
            element: '#reposts',
            attributes: {
                verb: 'reposted',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '🔁'
            }
        },
        'mention': {
            template: document.getElementById('tpl-mention').innerHTML,
            element: '#mentions',
            attributes: {
                verb: 'Mentioned',
                url: ['url'] 
            }
        }
    };

    const pageURL_base64 = btoa(pageURL);

    const module = {};

    module.fetchGithubIssue = async issueID => await fetch(`https://api.github.com/repos/omgmog/omgmog.github.com/issues/${issueID}`, GH_FETCH_OPTS).then(response => response.json());

    module.fetchGithubComments = async issueData => await fetch(issueData.comments_url, GH_FETCH_OPTS).then(response => response.json());

    module.fetchWebmentions = async url => await fetch(`https://webmention.io/api/mentions.jf2?target=${url}`).then(response => response.json());

    module.renderThing = (type, data) => {
        let template = type.template;
        const attributes = Object.keys(type.attributes);
        for (const index in attributes) {
            const attribute = attributes[index];
            let value = data[type.attributes[attribute]];
            if (!value) {
                value = type.attributes[attribute];
            }
            if (!value || (typeof value !== 'string')) {
                value = data[type.attributes[attribute][0]];
            }
            if (!value || (typeof value !== 'string')) {
                value = data[type.attributes[attribute][0]][type.attributes[attribute][1]];
            }

            if (attribute === 'date') {
                value = new Intl.DateTimeFormat('default', {
                    year: 'numeric', 
                    month: 'short', 
                    day: 'numeric'
                }).format(new Date(value));
            }
            if (attribute === 'body') {
                value = marked.parse(value);
            }

            template = template.replace(new RegExp('%' + attribute + '%', 'g'), value);
        }
      return template;
    };

    module.renderThings = things => {
        let type;
        let data = things.data.children || things.data;
        if (things.type === 'comment') {
            type = TYPES[things.type];
            if (data.length) {
                document.querySelectorAll('.comments-open').forEach(el => el.style.display = 'initial');
            }
        }
        data.forEach(item => {
            type = TYPES[item.type];
            const element = document.querySelector(type.element);
            element.style.display = 'block';
            element.querySelector('.items').innerHTML += module.renderThing(type, item);
        });
    };

    module.makeFallbackAvatar = (text_value, img_element) => {
        const p = 2;
        const canvas = document.createElement('canvas');
        canvas.style.imageRendering='pixelated';
        canvas.width = 14;
        canvas.height = 14;
        const context = canvas.getContext('2d');
        const r = 1;

        if (text_value) {
            for (
                let r = 1, i = 28 + text_value.length;
                i--;
            ) {
                // xorshift32
                (r ^= r << 13), (r ^= r >>> 17), (r ^= r << 5);
                const X = i & 3,
                Y = i >> 2;
                if (i >= 28) {
                    // seed state
                    r += text_value.charCodeAt(i - 28);
                    context.fillStyle = '#' + ((r >> 8) & 0xffffff).toString(16).padStart(0, 6);
                } else {
                    // draw pixel
                    if (r >>> 29 > (X * X) / 3 + Y / 2) {
                        context.fillRect(p * 3 + p * X, p * Y, p, p);
                        context.fillRect(p * 3 - p * X, p * Y, p, p);
                    }
                }
            }
            img_element.src = canvas.toDataURL();
        }
    };

    module.checkForFailedAvatars = () => {
        document.querySelectorAll('#interactions .avatar').forEach(avatar => {
            avatar.onerror = err => module.makeFallbackAvatar(avatar.dataset.username, avatar);
        });
    };

    module.saveData = (what, where) => localStorage.setItem(where, JSON.stringify(what));

    module.loadData = what => JSON.parse(localStorage.getItem(what));

    let interactions = {
        date: module.loadData(`interactions-date-${pageURL_base64}`) || 0,
        comments: module.loadData(`interactions-comments-${pageURL_base64}`) || {},
        webmentions: module.loadData(`interactions-mentions-${pageURL_base64}`) || {}
    };

    // is it more than a day old?
    const now = Date.now();
    const oneHour = 60 * 60 * 1000;
    if (new Date(interactions.date) < (now - oneHour)) {
        module.saveData(now, `interactions-date-${pageURL_base64}`);

        if (githubIssueID) {
            module.fetchGithubIssue(githubIssueID).then(issue => module.fetchGithubComments(issue).then(comments => {
                if (!comments) return;
                interactions.comments = {
                    type: 'comment',
                    data: comments.map(comment => Object.assign(comment, {type: 'comment'}))
                };
                module.saveData(interactions.comments, `interactions-comments-${pageURL_base64}`);
                module.renderThings(interactions.comments);
                module.checkForFailedAvatars();
            }));
        }
        if (pageURL) {
            module.fetchWebmentions(pageURL).then(mentions => {
                if (!mentions) return;
                interactions.webmentions = {
                    type: 'webmention',
                    data: mentions.children.map(mention => Object.assign(mention, {type: mention['wm-property'].replace('in-reply-to', 'reply').replace('-of', '')}))
                };
                module.saveData(interactions.webmentions, `interactions-mentions-${pageURL_base64}`);
                module.renderThings(interactions.webmentions);
                module.checkForFailedAvatars();
            });
        }
    } else {
        module.renderThings(interactions.comments);
        module.renderThings(interactions.webmentions);
        module.checkForFailedAvatars();
    }
}());
