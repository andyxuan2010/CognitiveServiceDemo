(() => {
  "use strict";
  if (document.querySelector("[data-language-switcher], .language-switcher")) return;

  const githubLink = [...document.querySelectorAll("a[href]")]
    .map(link => link.href)
    .find(href => /github\.com\/andyxuan2010\//i.test(href));
  const repository = githubLink?.match(/github\.com\/([^/]+)\/([^/#?]+)/i);
  if (!repository) return;
  const owner = repository[1];
  const repo = repository[2].replace(/\.git$/i, "");
  const storageKey = `repo-language:${owner}/${repo}`;

  const themeButton = document.querySelector("#themeButton, [data-theme-toggle], .theme-button");
  const topbar = themeButton?.closest("header, nav, .topbar") || document.querySelector(".topbar, header, nav");
  if (!topbar) return;
  const insertionPoint = themeButton?.parentElement === topbar ? themeButton : null;

  const style = document.createElement("style");
  style.textContent = ".repo-language-switcher{display:inline-flex;align-items:center;gap:4px;flex:0 0 auto;margin-left:12px;color:var(--muted,#667085);font-size:13px;font-weight:700;white-space:nowrap}.repo-language-switcher button{min-width:38px;min-height:36px;padding:7px 9px;border:0;border-radius:10px;color:inherit;background:transparent;font:inherit;cursor:pointer}.repo-language-switcher button:hover,.repo-language-switcher button:focus-visible{color:var(--ink,#172033);background:var(--soft,#edf4ff)}.repo-language-switcher button.active{color:#fff;background:var(--green,var(--accent,#26765a));box-shadow:0 10px 28px rgba(35,107,81,.16)}.repo-language-switcher .separator{color:var(--muted,#667085);font-weight:600}.repo-language-switcher button:disabled{cursor:wait;opacity:.65}@media(max-width:650px){.repo-language-switcher{margin-left:6px;gap:1px}.repo-language-switcher button{min-width:32px;padding:6px 5px}}";
  document.head.append(style);

  const controls = document.createElement("div");
  controls.className = "repo-language-switcher";
  controls.dataset.languageSwitcher = "true";
  controls.setAttribute("aria-label", "Choose language");
  controls.innerHTML = '<button type="button" data-repo-language="en" lang="en">EN</button><span class="separator" aria-hidden="true">/</span><button type="button" data-repo-language="fr" lang="fr">FR</button><span class="separator" aria-hidden="true">/</span><button type="button" data-repo-language="zh" lang="zh-CN">中文</button>';
  if (insertionPoint) topbar.insertBefore(controls, insertionPoint);
  else topbar.append(controls);

  const buttons = [...controls.querySelectorAll("button")];
  let active = "en";
  const setActive = language => buttons.forEach(button => button.classList.toggle("active", button.dataset.repoLanguage === language));
  setActive(active);

  const translationCandidates = language => {
    const suffix = language === "zh" ? "CN" : "FR";
    return [
      `README.${suffix}.md`,
      `readme.${suffix}.md`,
      `README_${suffix}.md`,
      `README-${suffix}.md`
    ];
  };
  const rawUrl = path => `https://raw.githubusercontent.com/${owner}/${repo}/main/${path}`;

  async function loadTranslation(language) {
    const content = document.querySelector("#content");
    if (!content || typeof window.marked === "undefined" || typeof window.DOMPurify === "undefined") return false;
    for (const path of translationCandidates(language)) {
      try {
        const response = await fetch(rawUrl(path), { cache: "no-store" });
        if (!response.ok) continue;
        const markdown = await response.text();
        content.innerHTML = window.DOMPurify.sanitize(window.marked.parse(markdown));
        const status = document.querySelector("#status");
        if (status) status.textContent = path;
        return true;
      } catch {
        // A missing or unreachable translation keeps the English source visible.
      }
    }
    return false;
  }

  async function choose(language) {
    buttons.forEach(button => { button.disabled = true; });
    if (language === "en") {
      localStorage.removeItem(storageKey);
      window.location.reload();
      return;
    }
    const loaded = await loadTranslation(language);
    active = loaded ? language : "en";
    if (loaded) localStorage.setItem(storageKey, language);
    else localStorage.removeItem(storageKey);
    setActive(active);
    buttons.forEach(button => { button.disabled = false; });
  }

  buttons.forEach(button => button.addEventListener("click", () => choose(button.dataset.repoLanguage)));
  window.addEventListener("load", async () => {
    const saved = localStorage.getItem(storageKey);
    if (saved === "fr" || saved === "zh") {
      const loaded = await loadTranslation(saved);
      active = loaded ? saved : "en";
      if (!loaded) localStorage.removeItem(storageKey);
      setActive(active);
    }
  }, { once: true });
})();
