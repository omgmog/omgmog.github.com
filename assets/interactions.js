(function () {
    'use strict';
  
    if (!'fetch' in window) return;

    const GH_FETCH_OPTS = {Accept: "application/vnd.github.v3.full+json", cache: "force-cache"};
  
    const tpl = (string, data) => {
      for (const token in data) {
        string = string.replace(new RegExp('%' + token + '%', 'g'), data[token]);
      }
      return string;
    };
    const renderInteraction = (type, data) => {
        let template = TEMPLATES[type.template];
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

    const module = {};

    // mentiontypes
    const TYPES = [
        {
            type: 'comment',
            wmProperty: null,
            template: 'reply',
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
        {
            type: 'reply',
            wmProperty: 'in-reply-to',
            template: 'reply',
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
        {
            type: 'like',
            wmProperty: 'like-of',
            template: 'like',
            element: '#likes',
            attributes: {
                verb: 'Liked',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '❤️'
            }
        },
        {
            type: 'bookmark',
            wmProperty: 'bookmark-of',
            template: 'bookmark',
            element: '#bookmarks',
            attributes: {
                verb: 'Bookmarked',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '⭐'
            }
        },
        {
            type: 'repost',
            wmProperty: 'repost-of',
            template: 'repost',
            element: '#reposts',
            attributes: {
                verb: 'reposted',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                emoji: '🔁'
            }
        },
        {
            type: 'mention',
            wmProperty: 'mention-of',
            template: 'mention',
            element: '#mentions',
            attributes: {
                verb: 'Mentioned',
                url: ['url'] 
            }
        }
    ];

    const TEMPLATES = {
        reply: document.getElementById('tpl-reply').innerHTML,
        like: document.getElementById('tpl-like').innerHTML,
        bookmark: document.getElementById('tpl-bookmark').innerHTML,
        mention: document.getElementById('tpl-mention').innerHTML,
        repost: document.getElementById('tpl-repost').innerHTML
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

    module.saveData = (value, where) => {
        localStorage.setItem(where, JSON.stringify(value));
    }
    module.loadData = (what) => {
        return JSON.parse(localStorage.getItem(what));
    }
  
    // Comments
    module.renderComments = (data) => {
        let parent = document.getElementById('comments');
        let items = parent.querySelector('.items');
        let html_out = '';
        let type = TYPES.filter(data => data.type === 'comment')[0];
        data.forEach(item => {
            item[type.attributes.author_name[0]] = module.standardOwner(item[type.attributes.author_name[0]]);
            html_out += renderInteraction(
                type,
                item
            )
        });
        items.innerHTML = html_out;
    }

    // Replies
    module.renderReplies = (data) => {
        let parent = document.getElementById('replies');
        let items = parent.querySelector('.items');
        let html_out = '';
        let type = TYPES.filter(data => data.type === 'reply')[0];
        data.forEach(item => {
            item[type.attributes.author_name[0]] = module.standardOwner(item[type.attributes.author_name[0]]);
            html_out += renderInteraction(
                type,
                item
            )
        });
        items.innerHTML = html_out;
    }

    // Likes
    module.renderLikes = (data) => {
        let parent = document.getElementById('likes');
        let items = parent.querySelector('.items');
        let html_out = '';
        let type = TYPES.filter(data => data.type === 'like')[0];
        data.forEach(item => {
            item[type.attributes.author_name[0]] = module.standardOwner(item[type.attributes.author_name[0]]);
            html_out += renderInteraction(
                type,
                item
            )
        });
        items.innerHTML = html_out;
    }

    // Bookmarks
    module.renderBookmarks = (data) => {
        let parent = document.getElementById('bookmarks');
        let items = parent.querySelector('.items');
        let html_out = '';
        let type = TYPES.filter(data => data.type === 'bookmark')[0];
        data.forEach(item => {
            item[type.attributes.author_name[0]] = module.standardOwner(item[type.attributes.author_name[0]]);
            html_out += renderInteraction(
                type,
                item
            )
        });
        items.innerHTML = html_out;
    }
    // Reposts
    module.renderReposts = (data) => {
        let parent = document.getElementById('reposts');
        let items = parent.querySelector('.items');
        let html_out = '';
        let type = TYPES.filter(data => data.type === 'repost')[0];
       
        data.forEach(item => {
            item[type.attributes.author_name[0]] = module.standardOwner(item[type.attributes.author_name[0]]);
            html_out += renderInteraction(
                type,
                item
            )
        });
        items.innerHTML = html_out;
    }
    // Mentions
    module.renderMentions = (data) => {
        let parent = document.getElementById('mentions');
        let items = parent.querySelector('.items');
        let html_out = '';
        let type = TYPES.filter(data => data.type === 'mention')[0];
       
        data.forEach(item => {
            html_out += renderInteraction(
                type,
                item
            )
        });
        items.innerHTML = html_out;
    }
    module.checkForEmptyElements = (what) => {
        what.forEach(type => {
            switch(type) {
                case 'comments':
                    if (!interactions_comments.length) { 
                        document.getElementById('comments').style.display = 'none'}
                    break;
                case 'replies':
                    if (!interactions_replies.length) { 
                        document.getElementById('replies').style.display = 'none'}
                    break;
                case 'likes':
                    if (!interactions_likes.length) { 
                        document.getElementById('likes').style.display = 'none'}
                    break;
                case 'bookmarks':
                    if (!interactions_bookmarks.length) { 
                        document.getElementById('bookmarks').style.display = 'none'}
                    break;
                case 'reposts':
                    if (!interactions_reposts.length) { 
                        document.getElementById('reposts').style.display = 'none'}
                    break;
                case 'mentions':
                    if (!interactions_mentions.length) { 
                        document.getElementById('mentions').style.display = 'none'}
                    break;
            }
        })
    }
    module.checkForFailedAvatars = () => {
        document.querySelectorAll('#interactions .avatar').forEach(avatar => {
            avatar.onerror = err => avatar.classList.add('load-failed');
        });
    }

    const pageURL_base64 = btoa(pageURL);

    let interactions_date = module.loadData(`interactions-${pageURL_base64}-date`) || 0;
    let interactions_comments = module.loadData(`interactions-${pageURL_base64}-comments`) || [];     // github issue comments
    let interactions_replies = module.loadData(`interactions-${pageURL_base64}-replies`) || [];      // in-reply-to
    let interactions_likes = module.loadData(`interactions-${pageURL_base64}-likes`) || [];        // like-of
    let interactions_bookmarks = module.loadData(`interactions-${pageURL_base64}-bookmarks`) || [];    // bookmark-of
    let interactions_reposts = module.loadData(`interactions-${pageURL_base64}-reposts`) || [];      // repost-of
    let interactions_mentions = module.loadData(`interactions-${pageURL_base64}-mentions`) || [];     // mention-of

    // is it more than a day old?
    const now = Date.now();
    const oneDay = 24 * 60 * 60 * 1000;
    const olderThanOneDay = new Date(interactions_date) < (now - oneDay);
    if (olderThanOneDay) {
        module.saveData(now, `interactions-${pageURL_base64}-date`);

        if (githubIssueID) {
            module.fetchGithubComments(githubIssueID).then(comments => {
                interactions_comments = comments;
                module.saveData(interactions_comments, `interactions-${pageURL_base64}-comments`);
                module.renderComments(interactions_comments);
                module.checkForFailedAvatars();
                module.checkForEmptyElements(['comments']);
            });
        } else {
            module.checkForEmptyElements(['comments']);
        }
        if (pageURL) {
            module.fetchWebmentions(pageURL).then(mentions => {
                if (!mentions) return;
    
                interactions_replies = mentions.children.filter(mention => mention['wm-property'] === 'in-reply-to');
                interactions_likes = mentions.children.filter(mention => mention['wm-property'] === 'like-of');
                interactions_bookmarks = mentions.children.filter(mention => mention['wm-property'] === 'bookmark-of');
                interactions_reposts = mentions.children.filter(mention => mention['wm-property'] === 'repost-of');
                interactions_mentions = mentions.children.filter(mention => mention['wm-property'] === 'mention-of');
    
                module.saveData(interactions_replies, `interactions-${pageURL_base64}-replies`);
                module.saveData(interactions_likes, `interactions-${pageURL_base64}-likes`);
                module.saveData(interactions_bookmarks, `interactions-${pageURL_base64}-bookmarks`);
                module.saveData(interactions_reposts, `interactions-${pageURL_base64}-reposts`);
                module.saveData(interactions_mentions, `interactions-${pageURL_base64}-mentions`);
                module.renderReplies(interactions_replies);
                module.renderLikes(interactions_likes);
                module.renderBookmarks(interactions_bookmarks);
                module.renderReposts(interactions_reposts);
                module.renderMentions(interactions_mentions);
                module.checkForEmptyElements(['replies', 'likes', 'bookmarks', 'reposts', 'mentions']);
                module.checkForFailedAvatars();
            });
        }
    } else {
        module.renderComments(interactions_comments);
        module.renderReplies(interactions_replies);
        module.renderLikes(interactions_likes);
        module.renderBookmarks(interactions_bookmarks);
        module.renderReposts(interactions_reposts);
        module.renderMentions(interactions_mentions);
        module.checkForEmptyElements(['comments', 'replies', 'likes', 'bookmarks', 'reposts', 'mentions']);
        module.checkForFailedAvatars();
    }
}());
