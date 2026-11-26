# Contributing

## Publishing

Two packages: `flutter_storyblok` (root) and `flutter_storyblok_code_generator` (`code_generator/`). The generator depends on the root, so publish in this order.

Publishing runs in GitHub Actions (`.github/workflows/publish.yml`) when a version tag is pushed. pub.dev checks that the tag matches the version in `pubspec.yaml`.

| Package | Tag |
| --- | --- |
| `flutter_storyblok` | `v<version>`, e.g. `v1.5.0` |
| `flutter_storyblok_code_generator` | `code_generator-v<version>`, e.g. `code_generator-v1.3.1` |

### 1. Bump versions

- `pubspec.yaml` — bump `version`.
- `code_generator/pubspec.yaml` — bump `version` and (if applicable) the `flutter_storyblok` constraint.
- Update both `CHANGELOG.md` files.

Merge the changes to `main`.

### 2. Publish root

```shell
git checkout main && git pull
git tag v<version>
git push origin v<version>
```

### 3. Publish generator

Wait for the root version to appear on pub.dev, otherwise version solving fails. The workflow removes the `dependency_overrides` block before publishing, so leave it in place.

```shell
git tag code_generator-v<version>
git push origin code_generator-v<version>
```

## One-time setup

- On pub.dev, for each package, open **Admin → Automated publishing**, enable publishing from GitHub Actions with repository `alsterverse/flutter_storyblok`, set the tag pattern (`v{{version}}` for the root, `code_generator-v{{version}}` for the generator) and require the GitHub Actions environment `pub.dev`.
- On GitHub, create the environment `pub.dev` under **Settings → Environments**. Optionally add required reviewers so each publish needs approval.
