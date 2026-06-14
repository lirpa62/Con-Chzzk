(() => {
  const THEME_KEY = "popupTheme";
  const DARK = "dark";
  const LIGHT = "light";

  const normalizeTheme = (theme) => (theme === DARK ? DARK : LIGHT);
  const applyTheme = (theme) => {
    document.documentElement.dataset.theme = normalizeTheme(theme);
  };

  try {
    const savedTheme = localStorage.getItem(THEME_KEY);
    if (savedTheme) {
      applyTheme(savedTheme);
    }
  } catch (_) {
    // localStorage can be unavailable in rare browser states; popup.js will sync later.
  }

  if (globalThis.chrome?.storage?.local) {
    chrome.storage.local.get({ [THEME_KEY]: LIGHT }, (data) => {
      const theme = normalizeTheme(data?.[THEME_KEY]);
      applyTheme(theme);
      try {
        localStorage.setItem(THEME_KEY, theme);
      } catch (_) {
        // Best-effort cache only.
      }
    });
  }
})();
