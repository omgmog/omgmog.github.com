window.makeFallbackAvatar = function(text, img) {
    if (!text) return;
    var p = 2, canvas = document.createElement('canvas');
    canvas.style.imageRendering = 'pixelated';
    canvas.width = 14; canvas.height = 14;
    var ctx = canvas.getContext('2d');
    for (var r = 1, i = 28 + text.length; i--;) {
        r ^= r << 13; r ^= r >>> 17; r ^= r << 5;
        var X = i & 3, Y = i >> 2;
        if (i >= 28) {
            r += text.charCodeAt(i - 28);
            ctx.fillStyle = '#' + ((r >> 8) & 0xffffff).toString(16).padStart(6, '0');
        } else if (r >>> 29 > (X * X) / 3 + Y / 2) {
            ctx.fillRect(p * 3 + p * X, p * Y, p, p);
            ctx.fillRect(p * 3 - p * X, p * Y, p, p);
        }
    }
    img.src = canvas.toDataURL();
    img.classList.add('fallback');
};
document.querySelectorAll('.avatar[data-username]').forEach(function(img) {
    if (!img.getAttribute('src')) {
        window.makeFallbackAvatar(img.dataset.username, img);
    } else {
        img.onerror = function() { window.makeFallbackAvatar(img.dataset.username, img); };
        if (img.complete && img.naturalWidth === 0) window.makeFallbackAvatar(img.dataset.username, img);
    }
});
