# Procurement Excellence — Awwwards-style single-page site

A fully self-contained, single-file website (`index.html`) with zero external
dependencies — no CDNs, no web fonts, no frameworks. Everything (markup,
styles, and behavior) lives in one HTML file, built with vanilla HTML, CSS,
and JavaScript.

## Design

The site follows a dark editorial Awwwards aesthetic, with a set of
scroll-driven animations and interactive flourishes:

- Preloader on initial load
- Canvas-based hero animation
- Infinite marquee (scrolling text/logo strip)
- `IntersectionObserver`-driven reveal animations as content scrolls into view
- Animated numeric counters for statistics
- Custom cursor

## Sections

The page is organized into the following sections, in order:

1. **Hero** — full-viewport introduction with canvas animation
2. **Marquee** — scrolling text strip
3. **Manifesto** — editorial statement / brand positioning
4. **Services** — offering breakdown
5. **Stats** — animated counters
6. **Process** — how-we-work steps
7. **Quote** — pull quote / testimonial
8. **Contact / Footer** — contact details and closing footer

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
