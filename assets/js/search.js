const searchInput = document.getElementById("searchInput");
const resultsDiv = document.getElementById("results");
const feedUrls = ["/feed.xml", "/archives/feed.xml"];

function highlight(text, searchTerms) {
  const escapedTerms = searchTerms.map(term => term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
  const regex = new RegExp("(" + escapedTerms.join("|") + ")", "gi");
  return text.replace(regex, "<mark>$1</mark>");
}

function getExcerpt(text, term, radius = 60) {
  const index = text.toLowerCase().indexOf(term.toLowerCase());
  if (index === -1) return text.slice(0, radius * 2) + "...";
  const start = Math.max(0, index - radius);
  const end = Math.min(text.length, index + term.length + radius);
  return (start > 0 ? "…" : "") + text.slice(start, end) + (end < text.length ? "…" : "");
}

async function fetchFeed(url) {
  try {
    const res = await fetch(url);
    const text = await res.text();
    const parser = new DOMParser();
    const xml = parser.parseFromString(text, "text/xml");
    return Array.from(xml.querySelectorAll("item")).map(item => ({
      title: item.querySelector("title")?.textContent || "",
      link: item.querySelector("link")?.textContent || "",
      description: item.querySelector("description")?.textContent || ""
    }));
  } catch (e) {
    console.error(`Erreur lors du chargement de ${url}`, e);
    return [];
  }
}

async function fetchAllFeeds() {
  const allItems = await Promise.all(feedUrls.map(fetchFeed));
  return allItems.flat();
}

function searchInItems(items, query) {
  const terms = query.trim().split(/\s+/);
  return items
    .map(item => {
      const text = (item.title + " " + item.description).toLowerCase();
      const matches = terms.every(term => text.includes(term.toLowerCase()));
      if (!matches) return null;

      const firstTerm = terms.find(term => item.description.toLowerCase().includes(term.toLowerCase())) || terms[0];
      const excerptRaw = getExcerpt(item.description, firstTerm);
      const excerpt = highlight(excerptRaw, terms);

      return {
        title: highlight(item.title, terms),
        link: item.link,
        excerpt
      };
    })
    .filter(Boolean);
}

async function doSearch(query) {
  const items = await fetchAllFeeds();
  const results = searchInItems(items, query);
  resultsDiv.innerHTML = results.length
    ? results.map(res => `
        <div class="result">
          <a href="${res.link}"><h2>${res.title}</h2></a>
          <p>${res.excerpt}</p>
        </div>
      `).join("")
    : "<p>Aucun résultat.</p>";
}

searchInput.addEventListener("input", (e) => {
  const query = e.target.value;
  if (query.length >= 2) {
    doSearch(query);
  } else {
    resultsDiv.innerHTML = "";
  }
});
