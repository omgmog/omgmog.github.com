(function () {
    'use strict';
    if (!'fetch' in window) return;

    const GH_FETCH_OPTS = {Accept: "application/vnd.github.v3.full+json", cache: "force-cache"};
  
    // Initialize templates safely with error handling
    const getTemplateContent = (id) => {
        const element = document.getElementById(id);
        return element ? element.innerHTML : '';
    };

    const TYPES = {
        'comment': {
            template: getTemplateContent('tpl-reply'),
            element: '#comments',
            attributes: {
                verb: 'commented',
                author_name: ['user', 'login'],
                author_avatar_url: ['user', 'avatar_url'],
                author_url: ['user', 'html_url'],
                date: ['created_at'],
                date_formatted: ['created_at'],
                body: ['body'],
                url: ['html_url'] ,
                domain: ['html_url'] 
            }
        },
        'reply': {
            template: getTemplateContent('tpl-reply'),
            element: '#replies',
            attributes: {
                verb: 'replied',
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                author_url: ['author', 'url'],
                date: ['published'],
                date_formatted: ['published'],
                body: ['content', 'text'],
                url: ['url'],
                domain: ['url']
            }
        },
        'like': {
            template: getTemplateContent('tpl-like'),
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
            template: getTemplateContent('tpl-bookmark'),
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
            template: getTemplateContent('tpl-repost'),
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
            template: getTemplateContent('tpl-mention'),
            element: '#mentions',
            attributes: {
                verb: 'Mentioned',
                url: ['url'],
                date: ['published'],
                date_formatted: ['published'],
                domain: ['url']
            }
        },
        'mention-rich': {
            template: getTemplateContent('tpl-mention-rich'),
            element: '#mentions',
            attributes: {
                author_name: ['author', 'name'],
                author_avatar_url: ['author', 'photo'],
                author_url: ['author', 'url'],
                summary: ['summary', 'value'],
                date: ['published'],
                date_formatted: ['published'],
                verb: 'mentioned',
                url: ['url'],
                domain: ['url']
            }
        }
    };

    // Safely encode pageURL for localStorage keys
    const pageURL_base64 = (typeof pageURL !== 'undefined' && pageURL && pageURL[0]) 
        ? btoa(pageURL[0]) 
        : btoa(window.location.href);

    const module = {};

    module.fetchGithubIssue = async issueID => {
        // If we previously stored a rate-limit reset and it's still in the future, skip requesting
        if (module.isRateLimited()) {
            const reset = module.getStoredRateLimitReset();
            return { error: 'rate_limit', resetTime: reset };
        }

        try {
            const response = await fetch(`https://api.github.com/repos/omgmog/omgmog.github.com/issues/${issueID}`, GH_FETCH_OPTS);
            if (!response.ok) {
                if (response.status === 403) {
                    const resetTime = response.headers.get('x-ratelimit-reset');
                    const rateLimitRemaining = response.headers.get('x-ratelimit-remaining');
                    
                    if (rateLimitRemaining === '0' && resetTime) {
                        const resetDate = new Date(parseInt(resetTime) * 1000);
                        console.warn(`GitHub API rate limit exceeded. Resets at ${resetDate.toLocaleTimeString()}`);
                        module.storeRateLimitReset(resetDate);
                        return { error: 'rate_limit', resetTime: resetDate };
                    } else {
                        console.warn('GitHub API access forbidden (403). Check repository permissions or authentication.');
                        return { error: 'forbidden' };
                    }
                }
                if (response.status === 410) {
                    console.warn('GitHub issue is no longer available (410 Gone). Comments are closed.');
                    return { error: 'gone' };
                }
                throw new Error(`GitHub API error: ${response.status} ${response.statusText}`);
            }
            // clear any stored rate limit on success
            module.clearStoredRateLimit();
            return await response.json();
        } catch (error) {
            console.warn('Failed to fetch GitHub issue:', error);
            return { error: 'network' };
        }
    };

    module.fetchGithubComments = async issueData => {
        if (!issueData || !issueData.comments_url) {
            console.warn('Invalid issue data provided to fetchGithubComments');
            return [];
        }
        // Respect stored rate limit
        if (module.isRateLimited()) {
            const reset = module.getStoredRateLimitReset();
            return { error: 'rate_limit', resetTime: reset };
        }
        
        try {
            const response = await fetch(issueData.comments_url, GH_FETCH_OPTS);
            if (!response.ok) {
                if (response.status === 403) {
                    const resetTime = response.headers.get('x-ratelimit-reset');
                    const rateLimitRemaining = response.headers.get('x-ratelimit-remaining');
                    
                    if (rateLimitRemaining === '0' && resetTime) {
                        const resetDate = new Date(parseInt(resetTime) * 1000);
                        console.warn(`GitHub API rate limit exceeded. Resets at ${resetDate.toLocaleTimeString()}`);
                        module.storeRateLimitReset(resetDate);
                        return { error: 'rate_limit', resetTime: resetDate };
                    } else {
                        console.warn('GitHub API access forbidden (403). Check repository permissions or authentication.');
                        return { error: 'forbidden' };
                    }
                }
                throw new Error(`GitHub API error: ${response.status} ${response.statusText}`);
            }
            // clear any stored rate limit on success
            module.clearStoredRateLimit();
            return await response.json();
        } catch (error) {
            console.warn('Failed to fetch GitHub comments:', error);
            return { error: 'network' };
        }
    };

    module.fetchWebmentions = async url => {
        try {
            const response = await fetch(`https://webmention.io/api/mentions.jf2?target=${url}&per-page=1000`);
            if (!response.ok) {
                throw new Error(`Webmention API error: ${response.status} ${response.statusText}`);
            }
            const data = await response.json();
            return data;
        } catch (error) {
            console.warn('Failed to fetch webmentions:', error);
            return { children: [] };
        }
    };

    const DEFAULT_DATE_OPTIONS = {
        year: 'numeric', 
        month: 'short', 
        day: 'numeric',
    };
    module.prettyDate = (dateString, options=DEFAULT_DATE_OPTIONS) => new Intl.DateTimeFormat('default', options).format(new Date(dateString));

    module.renderThing = (type, data) => {
        if (!type || !type.template || !type.attributes || !data) {
            console.warn('Invalid type or data provided to renderThing');
            return '';
        }
        
        let template = type.template;
        const attributes = Object.keys(type.attributes);
        for (const index in attributes) {
            const attribute = attributes[index];
            let value = data[type.attributes[attribute]];

            // generally try and fallback for values
            if (!value) {
                value = type.attributes[attribute];
            }
            if (!value || (typeof value !== 'string')) {
                value = data[type.attributes[attribute][0]];
            }
            if (!value || (typeof value !== 'string')) {
                value = data[type.attributes[attribute][0]]?.[type.attributes[attribute][1]];
            }

            if (attribute === 'date') {
                // sometimes the publish date isn't provided but we might know when the mention was received
                value = value || data['wm-received'];
            }
            if (attribute === 'date_formatted') {
                // sometimes the publish date isn't provided but we might know when the mention was received
                value = value || data['wm-received'];
                // format the date
                value = module.prettyDate(value);
            }

            if (attribute === 'summary') {
                // sometimes we use the summary but if it's not available fallback to truncated body
                if (!data.summary?.value?.length > 0) {
                    const word_limit = 50;
                    const contentText = data.content?.text || '';
                    let words = contentText.replace(/\s+/g,' ').split(' ', word_limit + 1);

                    if (words.length > word_limit) {
                        words[word_limit - 1] += '&hellip;';
                        words = words.slice(0, word_limit);
                    }
                    value = words.join(' ');
                }
            }
            if (attribute === 'body' || attribute === 'summary') {
                // markdown parse the body
                value = marked.parse(value);
            }
            if (attribute === 'domain') {
                // extract the hostname from the url
                try {
                    value = new URL(value).hostname;
                } catch (error) {
                    console.warn('Invalid URL for domain extraction:', value);
                    value = value || '';
                }
            }
            if (attribute === 'author_url') {
                // sometimes there isn't an author url
                value = value || data.url;
            }
            if (attribute === 'url' ) {
                // sometimes a canonical url is available!
                value = data.rels?.canonical || value;

                // If it's a Twitter webmention, use archive.org
                if (value.match('https://twitter.com')) {
                    const date = new Date(data['wm-received']);
                    const [month, year] = [
                        date.getMonth() + 1,
                        date.getFullYear(),
                    ];
                    value = `https://web.archive.org/web/${year}${(month<10?'0':'')}${month}/${value}`;
                }
            }

            template = template.replace(new RegExp('%' + attribute + '%', 'g'), value);
        }
      return template;
    };

    module.renderThings = things => {
        if (!things || !things.type) return;
        
        let type;
        let data = things.data?.children || things.data;
        if (things.type === 'comment') {
            type = TYPES[things.type];
            const state = things.state || 'closed'; // fallback to 'closed' if state is undefined
            document.querySelectorAll(`.comments-${state}`).forEach(el => el.style.display = 'initial');
        }
        
        if (!data || !Array.isArray(data)) return;
        
        data.forEach(item => {
            if (!item || !item.type || !TYPES[item.type]) return;
            
            type = TYPES[item.type];
            // if we have some content too, let's render it as a rich mention
            if (item.content?.text && item.type === 'mention') {
                type = TYPES['mention-rich'];
            }
            
            const element = document.querySelector(type.element);
            if (!element || !element.querySelector('.items')) return;
            
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

    module.saveData = (what, where) => {
        try {
            localStorage.setItem(where, JSON.stringify(what));
        } catch (error) {
            console.warn('Failed to save data to localStorage:', error);
        }
    };

    module.loadData = what => {
        try {
            const data = localStorage.getItem(what);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            console.warn('Failed to load data from localStorage:', error);
            return null;
        }
    };

    module.showRateLimitMessage = (resetTime) => {
        const rateLimitElement = document.querySelector('#github-rate-limit');
        if (rateLimitElement) {
            const resetTimeSpan = rateLimitElement.querySelector('span');
            if (resetTimeSpan) {
                resetTimeSpan.textContent = resetTime.toLocaleTimeString();
            }
            rateLimitElement.style.display = 'block';
            module.updateRetryButtonState(resetTime);
        }
    };
    
    module.hideRateLimitMessage = () => {
        const rateLimitElement = document.querySelector('#github-rate-limit');
        if (rateLimitElement) {
            rateLimitElement.style.display = 'none';
        }
    };
    
    module.showCommentsClosed = () => {
        document.querySelectorAll('.comments-open').forEach(el => el.style.display = 'none');
        document.querySelectorAll('.comments-closed').forEach(el => el.style.display = 'initial');
    };
    
    // Note: retry behavior uses the generic '.reload' binding above


    // Enhance retry button to be disabled while still rate-limited
    module.updateRetryButtonState = (resetTime) => {
        const now = Date.now();
        const shouldEnable = !resetTime || resetTime.getTime() <= now;

        document.querySelectorAll('#interactions .reload').forEach(b => {
            const parts = (b.dataset.what || '').split(',').map(s => s.trim()).filter(Boolean);
            // if button targets comments or no specific target, consider it relevant
            if (parts.length === 0 || parts.includes('comments')) {
                b.disabled = !shouldEnable;
                b.title = shouldEnable ? 'Retry fetching comments now' : `Retry disabled until ${resetTime.toLocaleTimeString()}`;
            }
        });

        if (!shouldEnable && resetTime) {
            // schedule re-enable when reset passes
            const ms = resetTime.getTime() - now + 1000;
            setTimeout(() => {
                document.querySelectorAll('#interactions .reload').forEach(b => {
                    const parts = (b.dataset.what || '').split(',').map(s => s.trim()).filter(Boolean);
                    if (parts.length === 0 || parts.includes('comments')) {
                        b.disabled = false;
                        b.title = 'Retry fetching comments now';
                    }
                });
                module.clearStoredRateLimit();
                module.hideRateLimitMessage();
            }, ms);
        }
    };

    // Rate limit persistence helpers (site-wide, not per-page)
    const RATE_LIMIT_KEY = `github-rate-limit-reset`;

    module.getStoredRateLimitReset = () => {
        try {
            const v = localStorage.getItem(RATE_LIMIT_KEY);
            return v ? new Date(parseInt(v, 10)) : null;
        } catch (e) {
            return null;
        }
    };

    module.storeRateLimitReset = resetDate => {
        try {
            if (resetDate instanceof Date && !isNaN(resetDate)) {
                // store milliseconds since epoch to avoid timezone/precision issues
                localStorage.setItem(RATE_LIMIT_KEY, String(resetDate.getTime()));
            }
        } catch (e) {
            console.warn('Failed to persist rate limit reset time', e);
        }
    };

    module.clearStoredRateLimit = () => {
        try { localStorage.removeItem(RATE_LIMIT_KEY); } catch(e){}
    };

    // Check stored rate limit and avoid making requests until reset passes
    module.isRateLimited = () => {
        const reset = module.getStoredRateLimitReset();
        if (!reset) return false;
        const now = Date.now();
        return reset.getTime() > now;
    };

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

    module.fetchAndRender = async (what = ['comments', 'webmentions']) => {
        module.saveData(Date.now(), `interactions-date-${pageURL_base64}`);

        // COMMENTS
        if (what.includes('comments') && githubIssueID) {
            // If we have a stored reset time and it's still in the future, show message and don't fetch
            const storedReset = module.getStoredRateLimitReset();
            if (storedReset && storedReset.getTime() > Date.now()) {
                module.showRateLimitMessage(storedReset);
                module.updateRetryButtonState(storedReset);
                return;
            }

            try {
                const issue = await module.fetchGithubIssue(githubIssueID);
                if (!issue || issue.error) {
                    if (issue?.error === 'rate_limit' && issue.resetTime) {
                        module.showRateLimitMessage(issue.resetTime);
                        module.updateRetryButtonState(issue.resetTime);
                        return;
                    }
                    if (issue?.error === 'gone') {
                        module.showCommentsClosed();
                        return;
                    }
                    // other errors: do nothing
                    return;
                }

                const comments = await module.fetchGithubComments(issue);
                if (comments?.error) {
                    if (comments.error === 'rate_limit' && comments.resetTime) {
                        module.showRateLimitMessage(comments.resetTime);
                        module.updateRetryButtonState(comments.resetTime);
                        return;
                    }
                    // other errors: do nothing
                    return;
                }

                // success: clear rate-limit and render
                module.hideRateLimitMessage();
                module.clearStoredRateLimit();
                module.updateRetryButtonState();

                interactions.comments = {
                    type: 'comment',
                    state: issue.state || 'closed',
                    data: (Array.isArray(comments) ? comments : []).map(comment => Object.assign(comment, { type: 'comment' }))
                };
                module.saveData(interactions.comments, `interactions-comments-${pageURL_base64}`);
                module.renderThings(interactions.comments);
                module.checkForFailedAvatars();
            } catch (error) {
                console.warn('Error fetching and rendering comments:', error);
            }
        }

        // WEBMENTIONS
        if (what.includes('webmentions') && pageURL) {
            interactions.webmentions = {
                type: 'webmention',
                data: []
            };

            try {
                const allMentions = await Promise.all(pageURL.map(url => module.fetchWebmentions(url).catch(e => null)));
                allMentions.forEach(mentions => {
                    if (!mentions || !mentions.children || !Array.isArray(mentions.children)) return;

                    const validMentions = mentions.children
                        .filter(mention => mention && mention['wm-property'])
                        .map(mention => Object.assign(mention, {
                            type: mention['wm-property']
                                .replace('in-reply-to', 'reply')
                                .replace('-of', '')
                        }));

                    interactions.webmentions.data = [...new Set(interactions.webmentions.data.concat(validMentions))];
                });

                module.saveData(interactions.webmentions, `interactions-mentions-${pageURL_base64}`);
                module.clearItems('webmentions');
                module.renderThings(interactions.webmentions);
                module.checkForFailedAvatars();
            } catch (error) {
                console.warn('Error fetching and rendering webmentions:', error);
            }
        }
    };
    module.renderFetchDate = _ => {
        const fetchedDateElement = document.querySelector('#mentions-last-fetched');
        if (!fetchedDateElement) return;
        
        const output = fetchedDateElement.querySelector('span');
        if (!output) return;
        
        const lastFetchDate = module.loadData(`interactions-date-${pageURL_base64}`);
        if (lastFetchDate) {
            output.innerText = `${module.prettyDate(lastFetchDate, {...DEFAULT_DATE_OPTIONS, hour:'numeric', minute:'numeric' })}`;
            fetchedDateElement.style.display = 'block';
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
            const list = section.querySelector('.items');
            if (list) {
                list.innerHTML = '';
            }
            section.style.display = section.dataset.display || 'none';
        });
    }

    module.getLastUpdatedTime = () => module.loadData(`interactions-date-${pageURL_base64}`) || Date.now();

    // Bind the reload buttons
    document.querySelectorAll('#interactions .reload').forEach(button => {
        const lastUpdate = module.getLastUpdatedTime();
        button.title = `Last refreshed on ${module.prettyDate(lastUpdate, {...DEFAULT_DATE_OPTIONS, hour:'numeric', minute:'numeric' })}`;
        button.onclick = async e => {
            e.preventDefault();
            const btn = e.currentTarget || button;
            const raw = btn.dataset.what || '';
            const whatToRefresh = raw.split(',').map(s => s.trim()).filter(Boolean);
            const targets = whatToRefresh.length ? whatToRefresh : ['comments', 'webmentions'];

            // disable related reload buttons for these targets
            document.querySelectorAll('#interactions .reload').forEach(b => {
                const parts = (b.dataset.what || '').split(',').map(s => s.trim());
                if (targets.some(t => parts.includes(t))) {
                    b.disabled = true;
                    b.title = 'Refreshing...';
                }
            });

            module.clearItems(targets);
            await module.fetchAndRender(targets);

            // Re-enable and update titles for affected buttons
            document.querySelectorAll('#interactions .reload').forEach(b => {
                const parts = (b.dataset.what || '').split(',').map(s => s.trim());
                if (targets.some(t => parts.includes(t))) {
                    b.disabled = false;
                    const last = module.getLastUpdatedTime();
                    b.title = `Last refreshed on ${module.prettyDate(last, {...DEFAULT_DATE_OPTIONS, hour:'numeric', minute:'numeric' })}`;
                }
            });
            module.renderFetchDate(); 
        }
    });
    
    // Initialize retry button state based on any stored reset
    const initialStoredReset = module.getStoredRateLimitReset();
    if (initialStoredReset && initialStoredReset.getTime() > Date.now()) {
        module.showRateLimitMessage(initialStoredReset);
        module.updateRetryButtonState(initialStoredReset);
    } else {
        module.updateRetryButtonState();
    }
    // Also some initial hidey showy stuff
    if (!githubIssueID) {
        const commentsClosed = document.querySelector('.comments-closed');
        const commentsOpen = document.querySelector('.comments-open');
        if (commentsClosed) commentsClosed.style.display = 'initial';
        if (commentsOpen) commentsOpen.style.display = 'none';
    }

    // Render from fetch or localStorage
    try {
        if (new Date(interactions.date) < (now - halfHour)) {
            module.fetchAndRender();
        } else {
            module.renderAll();
        }
    } catch (error) {
        console.warn('Error during initial render:', error);
        // Fallback to empty state
        module.renderAll();
    }
            
    module.renderFetchDate(); 
}());
