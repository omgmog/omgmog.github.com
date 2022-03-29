(function () {
    'use strict';
    if (!'fetch' in window) return;

    const GH_FETCH_OPTS = {Accept: "application/vnd.github.v3.full+json", cache: "force-cache"};
  

    const module = {};

    // mentiontypes
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

    module.fetchGithubComments = async function (issueID) {
        if (!issueID) return;
        this.issue = await fetch(`https://api.github.com/repos/omgmog/omgmog.github.com/issues/${issueID}`, GH_FETCH_OPTS).then(response => response.json());
        this.comments = await fetch(this.issue.comments_url, GH_FETCH_OPTS).then(response => response.json());
        return this.comments;
    };
    module.fetchWebmentions = async function (url) {
        this.webmentions = await fetch(`https://webmention.io/api/mentions.jf2?target=${url}`).then(response => response.json());
        return this.webmentions;
    };

    module.standardOwner = (who) => {
        // Just to normalize my own presence in the comments and webmentions
        if (
            (
                who.login === 'omgmog' ||
                who.name === 'Max Glenister'
            ) && (
                who.html_url === 'https://github.com/omgmog' ||
                who.url === 'https://twitter.com/omgmog'
            )
        ) {
            return {
                login: 'Max Glenister (omgmog)',
                name: 'Max Glenister (omgmog)',
                html_url: who.html_url,
                url: who.url,
                avatar_url: '/assets/max2020-1a.png',
                photo: '/assets/max2020-1a.png',
            }
        } else {
            return who;
        }
    };

    module.saveData = (what, where) => {
        localStorage.setItem(where, JSON.stringify(what));
    }
    module.loadData = (what) => {
        return JSON.parse(localStorage.getItem(what));
    }

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
    }
    module.renderThing = (type, data) => {
        let template = type.template;
        const attributes = Object.keys(type.attributes);
        for (const index in attributes) {
            const attribute = attributes[index];
            let value = data[type.attributes[attribute]];
            if (!value) {
                // probably not on the original object, but we're adding it in the type..
                value = type.attributes[attribute];
            }
            if (!value || (typeof value !== 'string')) {
                value = data[type.attributes[attribute][0]];
            }
            if (!value || (typeof value !== 'string')) {
                value = data[type.attributes[attribute][0]][type.attributes[attribute][1]];
            }

            // special cases to handle dates and bodies
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

    module.checkForFailedAvatars = () => {
        document.querySelectorAll('#interactions .avatar').forEach(avatar => {
            avatar.onerror = err => avatar.classList.add('load-failed');
        });
    }

    const pageURL_base64 = btoa(pageURL);

    let interactions = {
        date: module.loadData(`interactions-date-${pageURL_base64}`) || 0,
        comments: module.loadData(`interactions-comments-${pageURL_base64}`) || {},
        webmentions: module.loadData(`interactions-mentions-${pageURL_base64}`) || {}
    };

    // is it more than a day old?
    const now = Date.now();
    const oneDay = 24 * 60 * 60 * 1000;
    const olderThanOneDay = new Date(interactions.date) < (now - oneDay);
    if (olderThanOneDay) {
        module.saveData(now, `interactions-date-${pageURL_base64}`);

        if (githubIssueID) {
            module.fetchGithubComments(githubIssueID).then(comments => {
                if (!comments) return;
                interactions.comments = {
                    type: 'comment',
                    data: comments.map(comment => Object.assign(comment, {type: 'comment'}))
                };
                module.saveData(interactions.comments, `interactions-comments-${pageURL_base64}`);
                module.renderThings(interactions.comments);
                module.checkForFailedAvatars();
            });
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
