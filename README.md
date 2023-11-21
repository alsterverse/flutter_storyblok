### Code generator

Create a Storyblok account at https://www.storyblok.com

To generate the blocks you will need the following information from your
Storyblok account:

1. Personal access token found under My account/Security/Personal access token
2. Space ID found under Settings/General/Space

To run the generator: `cd flutter_storyblok`
`dart run storyblok_sourcegen [SPACE ID] [ACCESS TOKEN] "lib/bloks.generated.dart"`

### API Documentation

[Storyblok Content Delivery API V2 Reference](https://www.storyblok.com/docs/api/content-delivery)

[Storyblok Management API Reference](https://www.storyblok.com/docs/api/management)
