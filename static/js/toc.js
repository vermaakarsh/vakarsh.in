document.addEventListener("DOMContentLoaded", () => {
  const toc = document.querySelector(".toc");
  if (!toc) return;

  const sections = Array.from(toc.querySelectorAll('a[href*="#"]'), (link) => ({
    link,
    heading: document.getElementById(decodeURIComponent(link.hash.slice(1))),
  })).filter(({ heading }) => heading);
  if (!sections.length) return;

  toc.querySelectorAll("li.parent").forEach((item) => item.classList.remove("parent"));

  let active;
  let frame;
  const update = () => {
    frame = undefined;
    const readingLine = Math.min(120, window.innerHeight * 0.2);
    const atBottom = window.scrollY > 0 &&
      Math.ceil(window.scrollY + window.innerHeight) >= document.documentElement.scrollHeight;
    const current = atBottom
      ? sections.at(-1)
      : sections.findLast(({ heading }) => heading.getBoundingClientRect().top <= readingLine);
    if (current === active) return;

    active?.link.removeAttribute("aria-current");
    active?.link.closest("li").classList.remove("selected");
    current?.link.setAttribute("aria-current", "location");
    current?.link.closest("li").classList.add("selected");
    active = current;
  };

  const scheduleUpdate = () => {
    if (frame === undefined) frame = requestAnimationFrame(update);
  };

  window.addEventListener("scroll", scheduleUpdate, { passive: true });
  window.addEventListener("resize", scheduleUpdate);
  window.addEventListener("pageshow", scheduleUpdate);
  update();
});
