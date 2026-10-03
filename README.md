# vakarsh.in

A personal blog built with [Zola](https://www.getzola.org/) and the [Apollo theme](https://github.com/not-matthias/apollo), published with GitHub Pages.

## Publishing boundary

`Owl` is the private writing source. This public repository is **only the published site**. It does not clone Owl or receive automatic access to it. Drafts, notes, and the Hashnode archive are not imported by the site build.

To publish a piece, finish it on a private Owl writing branch and set `status: published`, include `AV` in `outlets`, and add `publish_on_site: true` to its YAML front matter. It also needs a title, publication date, description, and at least one tag. Merging that change to Owl's `publish` branch runs its publishing workflow: it exports only the opted-in Markdown body and public metadata, then opens or updates a pull request here. Review that public PR and merge it to publish. A merge to this repository's `main` deploys automatically. Owl's `main` and unmerged writing branches do not export posts.

The Owl workflow holds a fine-grained token that can write **only this public site repository**; this site has no credential that can read Owl. Nothing copies drafts, `ready` pieces, other outlets, or the Hashnode archive. The exporter will not overwrite a manually maintained site post and does not auto-delete published posts; unpublishing needs a deliberate site change.

## Local preview

Install Zola 0.23.6 and fetch the pinned Apollo theme:

```sh
git clone https://github.com/not-matthias/apollo themes/apollo
git -C themes/apollo checkout d7e0b55de74939bc6fb6ba4daea1c521ce53735d
zola serve
```

For a clean build, run `zola check --skip-external-links && zola build`, then `ruby scripts/check_style_cache.rb`. Custom styles load through Apollo's `head_end` hook with a content-hashed URL, so existing visitors get new styling after a deployment rather than a cached previous version. The `themes/apollo` checkout and generated `public/` are ignored; GitHub Actions fetches the same pinned theme for every build. Tags are generated from public page and post front matter; the About page's `personal` tag keeps the index navigable before the first post is published.

The home page has two short introductory paragraphs in `content/_index.md`, then Highlighted articles and Recent articles. Both lists use compact date/title rows. The navigation order is `/posts`, `/projects`, `/talks`, `/tags`, `/about me`. The About me link retains the `/about/` URL. Projects is maintained in `content/work.md` and served at `/projects/`; `/work/` redirects to it. Talks has an honest empty state in `content/talks.md` until real entries are supplied. Owl's publication path remains `content/posts/`, unchanged. Apollo's article table of contents is enabled in `config.toml`. Its native sidebar appears on wide screens, while `templates/apollo/body_end.html` moves the same TOC into a collapsible in-article section on narrower screens.

Recent articles automatically shows the newest five published posts from Owl. To curate highlights, add published post paths to `[extra].highlighted_posts` in `config.toml`, for example `highlighted_posts = ["posts/my-essay.md"]`. Selection follows that list's order and only matches posts visible in the published posts section; drafts and missing paths cannot appear. Content still comes exclusively through Owl. Leave the list empty until there are real published posts to highlight. After building, run `ZOLA=/path/to/zola ruby scripts/check_home_articles.rb` for homepage and isolated article-selection regressions; test articles are created only in a temporary build, never under this repository's content.

The name-side social links use Apollo's native GitHub, LinkedIn, YouTube, and RSS icons. `static/images/akarsh-favicon.png` is the existing 160px blog-author image from the user-supplied avatar kit, not a generated replacement. Apollo's head hook loads it as a content-versioned favicon and touch icon on every themed page. Run `ruby scripts/check_navigation_identity.rb` after building to verify these links, navigation order, and icons.

The short, personal About page uses `templates/about.html`, with its introduction in `[extra].intro` and dated milestones in `[[extra.journey]]` in `content/about.md`. Keep milestones oldest-first in that file; the `journey` component renders them newest-first in the Markdown body (so the text stays in search). It intentionally omits article dates and a table of contents. The square portrait is the supplied `colour-cutout.svg` from Akarsh's avatar kit, stored as `static/images/akarsh-avatar.svg`; the rest of the kit is not bundled. To replace it, update `portrait` and `portrait_alt` in `content/about.md`. Its content-hashed URL prevents stale replacements, and reserved dimensions prevent layout shifts. Run `ruby scripts/check_about_portrait.rb` after building to check it. Only user-approved family details and public professional/channel information belong here, not private drafts or employer material.

## Hosting

GitHub Pages builds on `main` and deploys the `public/` artifact. Set the Pages source to **GitHub Actions** and the custom domain to `vakarsh.in`. At Namecheap, point the apex to GitHub Pages' four A records and `www` to `vermaakarsh.github.io`; leave mail-related DNS records untouched. After DNS and certificate provisioning, enable **Enforce HTTPS** in Pages settings.
