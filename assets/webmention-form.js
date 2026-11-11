// "Link to your reply" form under Discussion: sends the Webmention with fetch() so the page doesn't navigate.
// Without JS the form posts to webmention.io directly (its own confirmation page).
(() => {
  "use strict";
  const form = document.querySelector(".wm-form");
  if (!form) return;
  const status = form.querySelector(".wm-form__status");
  const input = form.elements.source;
  const btn = form.querySelector("button");

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    btn.disabled = true;
    status.className = "wm-form__status";
    status.textContent = "Sending…";
    try {
      const res = await fetch(form.action, { method: "POST", body: new URLSearchParams(new FormData(form)) });
      if (!res.ok) throw new Error(res.status);
      status.textContent = "Sent. It will show up here once it has been verified.";
      input.value = "";
    } catch (err) {
      status.classList.add("is-error");
      status.textContent = "That didn't go through. Check the link is public and mentions this post, then try again.";
    }
    btn.disabled = false;
  });
})();
