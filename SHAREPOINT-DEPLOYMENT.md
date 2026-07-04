# Deploying to SharePoint Online

This site is a single self-contained `index.html` file with no external
dependencies, which makes it flexible to host. This guide covers three
approaches for using it inside SharePoint Online (modern experience), in
order of recommendation.

## Option A: Upload to a Document Library / Site Assets

The simplest path: upload `index.html` to a Document Library (or the
`SiteAssets` library) and link to it directly.

- Go to the target library, upload `index.html`, and copy its sharing link
  or direct URL.
- Add that URL as a link on a page, in navigation, or in a Quick Links web
  part.

**Caveat:** SharePoint Online frequently forces `.html` files to download
rather than render in the browser, depending on tenant-level "browser file
handling" settings. Where this happens, the classic workaround is renaming
the file to `.aspx` so it renders instead of downloading.

**.aspx caveats:**

- In modern document libraries, uploading and rendering custom `.aspx` pages
  is often blocked by the tenant's `CustomScript` setting (also referred to
  as "Allow users to run custom script" / `DenyAddAndCustomizePages`).
- Administrators can relax this per-site with PowerShell:

  ```powershell
  Set-SPOSite -Identity <site-url> -DenyAddAndCustomizePages $false
  ```

- **Security implications:** disabling this restriction re-enables custom
  script execution on the site, which also permits arbitrary client-side
  script injection (e.g., via web parts or page content). This weakens the
  isolation SharePoint enforces by default and should only be done on sites
  where the risk is understood and accepted — not tenant-wide, and not on
  sites containing sensitive data.

## Option B: External static hosting + Embed web part

Host `index.html` on external static hosting — Azure Static Web Apps, Azure
Blob Storage static website hosting, or GitHub Pages — and reference it from
SharePoint using the **Embed** web part with an iframe pointing at the
external URL.

- No file-rendering quirks: the external host serves the file with correct
  `Content-Type: text/html`, so there is no download-forcing behavior to
  work around.
- **Requirement:** the target domain must be added to the site's **HTML
  Field Security** allowed domains list (tenant admin: SharePoint admin
  center → Settings, or via PowerShell) before the iframe will render;
  otherwise the embedded content is stripped.
- This is a good middle ground when you want native single-file simplicity
  but don't want to fight tenant file-handling policy.

## Option C: Rebuild as an SPFx web part

For a fully native, enterprise-grade experience, port the page into an SPFx
(SharePoint Framework) web part. This gives you:

- Native integration with the page canvas, theming, and permissions model
- No reliance on file-type workarounds or embed/iframe allowlisting
- Proper packaging, versioning, and deployment through the tenant app catalog

This is the long-term path for teams that want the site to feel like a
first-class part of the SharePoint site rather than an embedded asset. Since
the current implementation keeps all CSS and JS self-contained in one file,
migrating the markup/styles/scripts into an SPFx web part is comparatively
straightforward — the logic doesn't need to be disentangled from a build
toolchain first.

## Why the site is built this way

- **No external requests** — nothing to allowlist, no CSP exceptions needed,
  no risk of a CDN or font host being blocked by tenant network/security
  policy.
- **Single file** — trivial to upload, version, and hand off; no build
  artifacts or folder structure to keep in sync.
- **System fonts only** — avoids font licensing questions and eliminates
  font-loading requests entirely, which matters inside a tenant where
  outbound requests may be restricted or monitored.
