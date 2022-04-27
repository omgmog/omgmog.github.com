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
                url: ['url'],
                domain: ['url']
            }
        },
        'like': {
            template: document.getElementById('tpl-like').innerHTML,
            element: '#likes',
            attributes: {
                verb: 'Liked',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '❤️',
                domain: ['url']
            }
        },
        'bookmark': {
            template: document.getElementById('tpl-bookmark').innerHTML,
            element: '#bookmarks',
            attributes: {
                verb: 'Bookmarked',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '⭐',
                domain: ['url']
            }
        },
        'repost': {
            template: document.getElementById('tpl-repost').innerHTML,
            element: '#reposts',
            attributes: {
                verb: 'reposted',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '🔁',
                domain: ['url']
            }
        },
        'mention': {
            template: document.getElementById('tpl-mention').innerHTML,
            element: '#mentions',
            attributes: {
                verb: 'Mentioned',
                url: ['url'],
                date: ['published'],
                domain: ['url']
            }
        },
        'mention-rich': {
            template: document.getElementById('tpl-mention-rich').innerHTML,
            element: '#mentions',
            attributes: {
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                author_url: ['author', 'url'],
                body: ['content', 'html'],
                date: ['published'],
                verb: 'mentioned',
                url: ['url'],
                domain: ['url']
            }
        }
    };

    const pageURL_base64 = btoa(pageURL[0]); // first URL is the canonical

    const module = {};

    module.fetchGithubIssue = async issueID => await fetch(`https://api.github.com/repos/omgmog/omgmog.github.com/issues/${issueID}`, GH_FETCH_OPTS).then(response => response.json());

    module.fetchGithubComments = async issueData => await fetch(issueData.comments_url, GH_FETCH_OPTS).then(response => response.json());

    module.fetchWebmentions = async url => await fetch(`https://webmention.io/api/mentions.jf2?target=${url}&per-page=1000`).then(response => response.json());

    const DEFAULT_DATE_OPTIONS = {
        year: 'numeric', 
        month: 'short', 
        day: 'numeric',
    };
    module.prettyDate = (dateString, options=DEFAULT_DATE_OPTIONS) => new Intl.DateTimeFormat('default', options).format(new Date(dateString));

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
                if (attribute === 'date') {
                    value = data['wm-received'];
                } else {
                    value = data[type.attributes[attribute][0]][type.attributes[attribute][1]];
                }
            }

            if (attribute === 'date') {
                value = module.prettyDate(value);
            }
            if (attribute === 'body') {
                value = marked.parse(value);
            }
            if (attribute === 'domain') {
                value = new URL(value).hostname;
            }

            template = template.replace(new RegExp('%' + attribute + '%', 'g'), value);
        }
      return template;
    };

    module.renderThings = things => {
        let type;
        let data = things.data?.children || things.data;
        if (things.type === 'comment') {
            type = TYPES[things.type];
            document.querySelectorAll(`.comments-${things.state}`).forEach(el => el.style.display = 'initial');
        }
        data?.forEach(item => {
            type = TYPES[item.type];
            // if we have some content too, let's render it as a rich mention
            if (item.content?.text && item.type === 'mention') {
                type = TYPES['mention-rich'];
            }
            const element = document.querySelector(type.element);
            element.querySelector('.items').innerHTML += module.renderThing(type, item);
            element.style.display = 'block';
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
            img_element.classList.add('fallback');
        }
    };

    module.checkForFailedAvatars = () => {
        document.querySelectorAll('#interactions .avatar').forEach(avatar => {
            avatar.onerror = () => module.makeFallbackAvatar(avatar.dataset.username, avatar);
        });
    };

    module.saveData = (what, where) => localStorage.setItem(where, JSON.stringify(what));

    module.loadData = what => JSON.parse(localStorage.getItem(what));

    // is it more than an hour old?
    const now = Date.now();
    const halfHour = 30 * 60 * 1000;
    let interactions = {
        date: module.loadData(`interactions-date-${pageURL_base64}`) || now - halfHour - 1,
        comments: module.loadData(`interactions-comments-${pageURL_base64}`) || {type:'comment',state:'closed',data:[]},
        webmentions: module.loadData(`interactions-mentions-${pageURL_base64}`) || {}
    };

    module.renderAll = () => {
        module.renderThings(interactions.webmentions);
        module.renderThings(interactions.comments);
        module.checkForFailedAvatars();
    }

    module.fetchAndRender = (what = ['comments', 'webmentions']) => {
        module.saveData(now, `interactions-date-${pageURL_base64}`);

        if (what.includes('comments') && githubIssueID) {
            module.fetchGithubIssue(githubIssueID).then(async issue => {
                const comments = await module.fetchGithubComments(issue) || [];
                
                interactions.comments = {
                    type: 'comment',
                    state: issue.state,
                    data: comments.map(comment => Object.assign(comment, { type: 'comment' }))
                };
                module.saveData(interactions.comments, `interactions-comments-${pageURL_base64}`);
                module.renderThings(interactions.comments);
                module.checkForFailedAvatars();
            });
        }
        if (what.includes('webmentions') && pageURL) {
            interactions.webmentions = {
                type: 'webmention',
                data: []
            };
            pageURL.forEach(url => {
                module.fetchWebmentions(url).then(mentions => {
                    if (!mentions) return;
                    interactions.webmentions.data = [...new Set(interactions.webmentions.data.concat(mentions.children.map(mention => Object.assign(mention, {type: mention['wm-property'].replace('in-reply-to', 'reply').replace('-of', '')}))))];
                    module.saveData(interactions.webmentions, `interactions-mentions-${pageURL_base64}`);
                    module.clearItems('webmentions');
                    module.renderThings(interactions.webmentions);
                    module.checkForFailedAvatars();
                });
            });
                    
        }
    }
    module.clearItems = (what = ['comments', 'webmentions']) => {
        let sections = []
        if (what.includes('comments')) {
            sections.push('#comments');
        }
        if (what.includes('webmentions')) {
            sections.push(
                '#replies',
                '#likes',
                '#bookmarks',
                '#reposts',
                '#mentions'
            )
        }
        
        document.querySelectorAll(sections.join(',')).forEach(section => {
            let list = section.querySelector('.items');
            section.style.display = section.dataset.display;
            list.innerHTML = '';
        });
    }

    // Bind the reload buttons
    document.querySelectorAll('#interactions .reload').forEach(button => {
        button.title = `Last refreshed on ${module.prettyDate(module.loadData(`interactions-date-${pageURL_base64}`), {...DEFAULT_DATE_OPTIONS, hour:'numeric', minute:'numeric' })}`;
        button.onclick = e => {
            module.clearItems(e.target.dataset.what);
            module.fetchAndRender(e.target.dataset.what);
        }
    });
    // Also some initial hidey shoey stuff
    if (!githubIssueID) {
        document.querySelector('.comments-closed').style.display = 'initial';
        document.querySelector('#comments').style.display = 'none';
    }

    // Render from fetch or localStorage
    if (new Date(interactions.date) < (now - halfHour)) {
        module.fetchAndRender();
    } else {
        module.renderAll();
    }
}());
