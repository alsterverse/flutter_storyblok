## Web

### Publish to web

Building for web compiles the Dart code to JavaScript using `Dart2Js`.

`flutter build web` runs in `--release` mode per default which destroys reflection due to minificiation.

Run `flutter build web --profile` to disable minification.

### HTTPS localhost

#### Install localhost SSL certificate
1. `brew install mkcert`
2. `mkcert -install`
3. `mkcert localhost`

#### Install http-server
1. `npm install -g http-server`
2. Run server `http-server build/web --cors --ssl --cert ~/localhost.pem --key ~/localhost-key.pem`
