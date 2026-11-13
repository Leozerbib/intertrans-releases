# Intertrans, versions publiées

Dictée vocale macOS native, 100 % locale (Parakeet, Whisper sur le Neural Engine) : dictée dans n'importe quelle
app, envoi direct dans Interwarp, réunions, notes vocales, statistiques. Ce dépôt ne contient que l'app compilée :
les zips (dans les [Releases](https://github.com/Leozerbib/intertrans-releases/releases)), le manifeste de la
dernière version (`manifest.json`) et la cask Homebrew (`Casks/intertrans.rb`). Le code source est privé.

Chaque fichier est écrit par la publication d'une version : ne le modifie pas à la main.

## Installer

macOS 14 ou plus récent, Apple Silicon. Homebrew installé.

```sh
brew tap leozerbib/intertrans https://github.com/Leozerbib/intertrans-releases
brew trust leozerbib/intertrans
brew install --cask intertrans
```

`brew trust` ne se fait qu'une fois : les versions récentes de Homebrew refusent de charger une cask venue d'un
tap tiers tant qu'on ne l'a pas approuvé.

L'app va dans `/Applications`. Sans droits admin : `brew install --cask --appdir=~/Applications intertrans`
(ou `export HOMEBREW_CASK_OPTS="--appdir=~/Applications"` dans ton `~/.zprofile`, pour les mises à jour aussi).

## Reprise d'une ancienne Intertrans

Une Intertrans installée autrement (compilée avec `scripts/build-app.sh`, copiée à la main) est reprise toute
seule au premier lancement de la version Homebrew :

- l'ancienne app (`~/Applications/Intertrans.app`) est rangée dans
  `~/Library/Application Support/Intertrans/ancienne-app.noindex`, jamais supprimée, pour qu'il n'y ait pas deux
  Intertrans sur le Mac ;
- l'historique, le vocabulaire, les modèles téléchargés (`~/Library/Application Support/Intertrans`) et les
  réglages restent en place : la nouvelle version les relit tels quels, sans rien retélécharger ;
- le micro et l'accessibilité sont redemandés une fois (l'ancienne signature n'est plus la même). Les mises à
  jour suivantes gardent la même signature et ne redemandent rien.

Avec `--appdir=~/Applications`, l'ancienne app occupe déjà la place : Homebrew refuse de l'écraser. Lance alors
`brew install --cask --force --appdir=~/Applications intertrans` (seule l'app est remplacée, pas les données).

Un historique qu'une version ne sait pas relire n'est jamais écrasé : il est mis de côté sous
`history-illisible-<date>.json`, dans le même dossier.

## Premier lancement : la quarantaine

Intertrans est signée par un certificat auto-signé (« Interwarp Dev »), sans notarisation Apple. Homebrew met
l'app téléchargée en quarantaine ; Gatekeeper peut alors refuser de l'ouvrir. Si c'est le cas, lève la
quarantaine de cette version, une fois :

```sh
xattr -dr com.apple.quarantine /Applications/Intertrans.app
```

ou ouvre Réglages Système › Confidentialité et sécurité, puis « Ouvrir quand même ». Une mise à jour remet la
quarantaine sur la nouvelle version : si macOS bloque de nouveau, refais ce geste.

Sur un Mac géré par une entreprise, si un outil de l'entreprise bloque l'app, passe par l'IT : ne contourne rien.

## Mettre à jour

```sh
brew update
brew upgrade --cask intertrans
```

## Vérifier ce que tu as installé

```sh
codesign -dv --verbose=2 /Applications/Intertrans.app 2>&1 | grep -E 'Identifier|Authority'
shasum -a 256 ~/Library/Caches/Homebrew/downloads/*Intertrans-*.zip
```

`Authority=Interwarp Dev`, et l'empreinte du zip égale à `sha256` dans `manifest.json` et dans les notes de la
Release.

## Désinstaller

```sh
brew uninstall --cask intertrans          # l'app seulement
brew uninstall --zap --cask intertrans    # plus préférences et caches
```

Tes données (`~/Library/Application Support/Intertrans`, dont les modèles) restent en place dans les deux cas :
supprime ce dossier à la main si tu n'en veux plus.

## Manifeste

`https://raw.githubusercontent.com/Leozerbib/intertrans-releases/main/manifest.json` décrit la dernière version :
`version`, `build` (ne fait qu'augmenter), `tag`, `url` du zip, `sha256`, `taille` en octets, `macosMinimum`,
`bundleId`, `certificatSHA1`, `publieLe` (UTC).
