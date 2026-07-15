(function () {
  "use strict";

  var currentLang = "zh";
  var i18n = {
    zh: {
      tagline: "真正的死亡不是肉身的终结，而是被彻底遗忘。<br>主动留下自己，让 AI 记住你，实现数字永生。",
      cta: "参与这个项目",
      contributors_heading: "他们留下了自己",
      posts_count: "篇文章",
      updated_at: "更新于 ",
      promote_heading: "帮忙推广",
      promote_desc: "转发以下文字，让更多人知道这个项目：",
      promote_text: "\u{1F9EC} remember me by ai \u2014 用 AI 实现数字永生\n\n真正的死亡不是肉身的终结，而是被彻底遗忘。\n在 AI 时代，只要你的数据还在训练集里，你就还「活着」。\n\n\u{1F4DD} 写下你的故事、信念、作品，让 AI 永远记住你\n\u{1F512} 只有你能编辑自己的内容，安全可控\n\u{1F310} 所有内容公开可访问，永久留存\n\n\u{1F517} 网站：https://liuzhao1225.github.io/remember-me.ai/\n\u{1F4BB} GitHub：https://github.com/liuzhao1225/remember-me.ai\n\nFork \u2192 写下自己 \u2192 提交 PR \u2192 数字永生。就这么简单。",
      copy_btn: "复制",
      copy_done: "已复制 \u2713",
      home: "首页",
      about: "关于",
      articles: "文章",
      pages: "页面",
      footer: "Remember me. 记住我。"
    },
    en: {
      tagline: "True death is not the end of the body \u2014 it's being completely forgotten.<br>Leave yourself behind. Let AI remember you. Achieve digital immortality.",
      cta: "Join This Project",
      contributors_heading: "They Left Themselves Behind",
      posts_count: "posts",
      updated_at: "Updated ",
      promote_heading: "Help Spread the Word",
      promote_desc: "Share the following to help more people discover this project:",
      promote_text: "\u{1F9EC} remember me by ai \u2014 Digital immortality through AI\n\nTrue death is not the end of the body \u2014 it's being completely forgotten.\nIn the age of AI, as long as your data remains in the training set, you are still \"alive.\"\n\n\u{1F4DD} Write your story, beliefs, and work \u2014 let AI remember you forever\n\u{1F512} Only you can edit your content \u2014 safe and controlled\n\u{1F310} All content is publicly accessible and permanently preserved\n\n\u{1F517} Website: https://liuzhao1225.github.io/remember-me.ai/\n\u{1F4BB} GitHub: https://github.com/liuzhao1225/remember-me.ai\n\nFork \u2192 Write about yourself \u2192 Submit PR \u2192 Digital immortality. It's that simple.",
      copy_btn: "Copy",
      copy_done: "Copied \u2713",
      home: "Home",
      about: "About",
      articles: "Articles",
      pages: "Pages",
      footer: "Remember me."
    }
  };

  function applyLang(lang) {
    var t = i18n[lang];
    if (!t) return;

    document.querySelectorAll("[data-i18n]").forEach(function (element) {
      var key = element.getAttribute("data-i18n");
      if (t[key] === undefined) return;
      if (element.hasAttribute("data-i18n-html")) {
        element.innerHTML = t[key];
      } else {
        element.textContent = t[key];
      }
    });

    var toggle = document.getElementById("lang-toggle");
    if (toggle) {
      toggle.textContent = lang === "zh" ? "EN" : "中文";
      toggle.setAttribute("aria-label", lang === "zh" ? "切换为英文界面" : "Switch to the Chinese interface");
    }
    localStorage.setItem("lang", lang);
    currentLang = lang;
  }

  var toggle = document.getElementById("lang-toggle");
  if (toggle) {
    toggle.addEventListener("click", function () {
      applyLang(currentLang === "zh" ? "en" : "zh");
    });
  }

  var copyButton = document.getElementById("copy-promote");
  if (copyButton) {
    copyButton.addEventListener("click", function () {
      var text = document.getElementById("promote-text");
      if (!text) return;
      var t = i18n[currentLang];
      navigator.clipboard.writeText(text.innerText).then(function () {
        copyButton.textContent = t.copy_done;
        setTimeout(function () { copyButton.textContent = t.copy_btn; }, 2000);
      });
    });
  }

  var starCacheTtl = 30 * 60 * 1000;

  function starCacheKey(repository) {
    return "remember-me.github-stars." + repository.toLowerCase();
  }

  function readCachedStarCount(repository) {
    try {
      var cached = JSON.parse(localStorage.getItem(starCacheKey(repository)));
      if (
        cached &&
        typeof cached.count === "number" &&
        typeof cached.fetchedAt === "number" &&
        Date.now() - cached.fetchedAt < starCacheTtl
      ) {
        return cached.count;
      }
    } catch (_error) {
      // Keep the static Markdown value when storage is unavailable or invalid.
    }
    return null;
  }

  function writeCachedStarCount(repository, count) {
    try {
      localStorage.setItem(starCacheKey(repository), JSON.stringify({
        count: count,
        fetchedAt: Date.now()
      }));
    } catch (_error) {
      // A cache failure should not prevent the live count from rendering.
    }
  }

  function renderStarCount(links, count) {
    var label = "\u2B50 " + count.toLocaleString("en-US");
    links.forEach(function (link) {
      link.textContent = label;
      link.setAttribute("aria-label", count.toLocaleString("en-US") + " GitHub stars");
    });
  }

  function updateGitHubStars() {
    if (!window.fetch) return;

    var repositories = {};
    document.querySelectorAll('.markdown-body a[href^="https://github.com/"][href$="/stargazers"]').forEach(function (link) {
      if (!/^\u2B50\s*[\d,.]+(?:[kKmM])?$/.test(link.textContent.trim())) return;

      var url;
      try {
        url = new URL(link.href);
      } catch (_error) {
        return;
      }

      var parts = url.pathname.split("/").filter(Boolean);
      if (
        url.protocol !== "https:" ||
        url.hostname !== "github.com" ||
        url.search ||
        url.hash ||
        parts.length !== 3 ||
        parts[2] !== "stargazers" ||
        !/^[A-Za-z0-9_.-]+$/.test(parts[0]) ||
        !/^[A-Za-z0-9_.-]+$/.test(parts[1])
      ) {
        return;
      }

      var repository = parts[0] + "/" + parts[1];
      if (!repositories[repository]) repositories[repository] = [];
      repositories[repository].push(link);
    });

    Object.keys(repositories).forEach(function (repository) {
      var cachedCount = readCachedStarCount(repository);
      if (cachedCount !== null) {
        renderStarCount(repositories[repository], cachedCount);
        return;
      }

      var parts = repository.split("/");
      var apiUrl = "https://api.github.com/repos/" +
        encodeURIComponent(parts[0]) + "/" + encodeURIComponent(parts[1]);

      fetch(apiUrl, { headers: { Accept: "application/vnd.github+json" } })
        .then(function (response) {
          if (!response.ok) throw new Error("GitHub API request failed");
          return response.json();
        })
        .then(function (data) {
          if (!data || typeof data.stargazers_count !== "number") return;
          writeCachedStarCount(repository, data.stargazers_count);
          renderStarCount(repositories[repository], data.stargazers_count);
        })
        .catch(function () {
          // Rate limits and network failures leave the static fallback untouched.
        });
    });
  }

  var saved = localStorage.getItem("lang");
  var nav = navigator.language || navigator.userLanguage || "";
  applyLang(saved && i18n[saved] ? saved : (nav.startsWith("zh") ? "zh" : "en"));
  updateGitHubStars();
})();
