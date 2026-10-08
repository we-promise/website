# Tailwind CSS v4 migration

This migration pairs the dependency upgrade in #121 with the required application
changes. Do not deploy the lockfile-only upgrade ahead of the CSS migration.
The migration branch includes the same Tailwind versions (tailwindcss-rails 4.6.0,
tailwindcss-ruby 4.3.3) so it can be built and reviewed independently on current main.
It intentionally omits unrelated dependency updates from the older Dependabot PR.
Merge this complete change atomically, then reconcile #121; merging both blindly
is unnecessary and may conflict in Gemfile.lock.

## Configuration

- Rails reads `app/assets/tailwind/application.css`; the v3 stylesheet path and
  JavaScript configuration files are retired. Editor integrations should discover
  the CSS entrypoint directly.
- The CSS `@theme` preserves the custom colors, shadow/radius scales, Geist font
  stacks and 450 medium weight. Colors mirror `app/javascript/tailwindColors.js`,
  which remains available to chart controllers; keep the two palettes in sync.
- Explicit `@source` directives scan the application (including Ruby helpers,
  presenters and JavaScript) and public files, without scanning dependencies.
- Forms, typography and legacy aspect-ratio plugins remain. Container queries are
  built into v4; their old plugin is removed.
- The production CSS build uses the standalone gem executable, not npm. The npm
  manifest/lockfile remain aligned for editor/development tooling. Use `npm ci`.
- Layouts no longer request the removed gem-provided `inter-font.css`. They retain
  the existing Google Fonts loading for Geist.
- The v3 default border color is retained explicitly. Utility renames and
  arbitrary-value syntax were migrated with the upstream upgrade tool. Custom
  shadows and radii retain their names instead of adopting v4's default scale.
- The Still shipping introduction explicitly keeps its former desktop line-height:
  v4 retains `leading-relaxed` across a responsive font-size change, unlike v3.

## Validation and review

Run `bin/rails tailwindcss:build`, the production `assets:precompile`, the Rails
suite, Ruby/ERB lint and security checks. Also inspect desktop and mobile home,
pricing, tools, tracking, bank search, and Still shipping pages. Exercise menus,
forms/calculators, charts and focus/hover states before approving release.

Tailwind v4 requires Safari 16.4+, Chrome 111+ and Firefox 128+. Confirm those
browser requirements before landing. No production deployment is part of this PR.

References:
- https://tailwindcss.com/docs/upgrade-guide
- https://github.com/rails/tailwindcss-rails#upgrading-your-application-from-tailwind-v3-to-v4
