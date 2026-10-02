# vakarsh.in

A personal blog built with [Zola](https://www.getzola.org/) and the [Apollo theme](https://github.com/not-matthias/apollo), published with GitHub Pages.

## Publishing boundary

`Owl` is the private writing source. This public repository is **only the published site**. It does not clone Owl or receive automatic access to it. Drafts, notes, and the Hashnode archive are not imported by the site build.

To publish a piece, finish it in private Owl and set `status: published`, include `AV` in `outlets`, and add `publish_on_site: true` to its YAML front matter. It also needs a title, publication date, description, and at least one tag. Merging that change to Owl's `main` runs its publishing workflow: it exports only the opted-in Markdown body and public metadata, then opens or updates a pull request here. Review that public PR and merge it to publish. A merge to this repository's `main` deploys automatically.

The Owl workflow holds a fine-grained token that can write **only this public site repository**; this site has no credential that can read Owl. Nothing copies drafts, `ready` pieces, other outlets, or the Hashnode archive. The exporter will not overwrite a manually maintained site post and does not auto-delete published posts; unpublishing needs a deliberate site change.

## Local preview

Install Zola 0.23.6 and fetch the pinned Apollo theme:

```sh
git clone https://github.com/not-matthias/apollo themes/apollo
git -C themes/apollo checkout d7e0b55de74939bc6fb6ba4daea1c521ce53735d
zola serve
```

For a clean build, run `zola check --skip-external-links && zola build`. The `themes/apollo` checkout and generated `public/` are ignored; GitHub Actions fetches the same pinned theme for every build. Tags are generated from public page and post front matter; the About page's `personal` tag keeps the index navigable before the first post is published.

The home-page introduction and selected work entries live in `content/_index.md`; the fuller biography is in `content/about.md`. Apollo's article table of contents is enabled in `config.toml`. Its native sidebar appears on wide screens, while `templates/apollo/body_end.html` moves the same TOC into a collapsible in-article section on narrower screens.

## Hosting

GitHub Pages builds on `main` and deploys the `public/` artifact. Set the Pages source to **GitHub Actions** and the custom domain to `vakarsh.in`. At Namecheap, point the apex to GitHub Pages' four A records and `www` to `vermaakarsh.github.io`; leave mail-related DNS records untouched. After DNS and certificate provisioning, enable **Enforce HTTPS** in Pages settings.
