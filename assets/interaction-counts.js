// Raises each "N interactions" to the count Refresh saved for that post (see discussion-refresh.js). The build's
// count wins once it catches up. Every include loads this file, so it only runs once.
(() => {
  if (window.__interactionCounts) return;
  const update = () =>
    document.querySelectorAll("[data-interactions]").forEach((el) => {
      let n = +el.dataset.n;
      try {
        n = Math.max(n, +localStorage.getItem("interactions:" + el.dataset.url) || 0);
      } catch (e) {}
      el.querySelector("[data-count]").textContent = `${n} interaction${n === 1 ? "" : "s"}`;
      el.hidden = n === 0;
    });
  window.__interactionCounts = update;
  update();
})();
