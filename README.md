# Etex Procurement — "Working with Procurement, made simple"

A fully self-contained, single-file website (`index.html`) with zero external
dependencies — no CDNs, no web fonts, no frameworks. Everything (markup,
styles, and behavior) lives in one HTML file, built with vanilla HTML, CSS,
and JavaScript. Content is sourced from the internal "How to work with
Procurement" deck; the visual identity uses the Etex brand palette extracted
from it (charcoal `#151D21`, Etex orange `#F06D0C`, slate, mist, deep blue and
sustainability green) under the "Building better together" tagline.

## Design

The site follows a dark editorial Awwwards aesthetic on the Etex charcoal
ground, with a set of scroll-driven animations and interactive flourishes:

- Preloader on initial load
- Canvas-based hero animation in brand hues (orange / deep blue / slate)
- Infinite marquee (scrolling text strip with etex chevron separators)
- `IntersectionObserver`-driven reveal animations as content scrolls into view
- Scroll-linked word-by-word reveal of the engagement principle
- Custom cursor

## Sections

The page mirrors the deck's structure, in order:

1. **Hero** — "Working with Procurement, made simple" + document meta
   (audience, owner, updated, reading time)
2. **Marquee** — brand and principle strip
3. **Engagement principle** — "Involve Procurement early" word-by-word reveal
4. **When to contact Procurement** — contact-us-when vs. proceed-on-your-own
5. **Engagement principles** — what we expect from each other
6. **Source-to-Pay** — the five-step end-to-end framework
7. **Start a request** — Path A (new sourcing) / Path B (PR/PO) with timelines
8. **Shared responsibility** — business vs. Procurement split
9. **Sustainability & compliance** — embedded, not bolted on
10. **Digital toolbox** — SAP/Ariba, Contract repository, SHAPE4U, Zero
    Initiatives, Power BI, Teams
11. **Contacts** — local teams, category managers, PMO, Teams channel
12. **FAQ** — five common questions (accordion)
13. **Footer** — "Building better, together." with links to the OneP2P
    SharePoint site

## Graceful degradation

- Respects `prefers-reduced-motion`: users who request reduced motion get a
  version of the site with animations disabled or minimized.
- Core content remains accessible and readable without JavaScript; JS is used
  to enhance presentation, not to gate content.

## Local preview

No build step or dependencies are required. Either:

- Open `index.html` directly in a browser, or
- Serve it locally:

  ```
  python3 -m http.server
  ```

  then visit `http://localhost:8000` in a browser.
