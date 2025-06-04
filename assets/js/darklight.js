const body = document.body;
const toggleBtn = document.getElementById("theme-toggle");

// Appliquer un thème donné
function applyTheme(a) {
  if (["light", "dark", "auto"].includes(a)) {
    body.setAttribute("a", a);
    localStorage.setItem("theme", a);
    updateButtonIcon(a);
  }
}

// Mettre à jour le bouton selon le thème
function updateButtonIcon(a) {
  toggleBtn.textContent = {
    light: "🌞",
    dark: "🌜",
    auto: "🌓"
  }[a] || "🌓";
}

// Lire le thème initial
const saved = localStorage.getItem("theme") || "auto";
applyTheme(saved);

// Gérer les clics
toggleBtn.addEventListener("click", () => {
  const current = body.getAttribute("a") || "auto";
  const next = current === "light" ? "dark" : current === "dark" ? "auto" : "light";
  applyTheme(next);
});
