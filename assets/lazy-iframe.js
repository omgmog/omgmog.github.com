document.querySelectorAll(".iframe [data-src]").forEach(function (el) {
  el.addEventListener("click", function () {
    var iframe = document.createElement("iframe");
    iframe.className = el.className.replace("placeholder", "").trim();
    iframe.width = el.clientWidth || parseInt(el.getAttribute("width")) || 600;
    iframe.height =
      el.clientHeight || parseInt(el.getAttribute("height")) || 350;
    iframe.allowFullscreen = true;
    iframe.allow =
      "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture";
    iframe.src = el.dataset.src;
    el.replaceWith(iframe);
  });
});
