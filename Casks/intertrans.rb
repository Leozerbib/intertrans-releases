cask "intertrans" do
  version "1.3.0"
  sha256 "46fe7271c159d2e6e6c5e841931d4ee6907182a7e76b3c169f9d32aac1e74d5b"

  url "https://github.com/Leozerbib/intertrans-releases/releases/download/v#{version}/Intertrans-#{version}.zip"
  name "Intertrans"
  desc "Dictée vocale 100 % locale (Parakeet, Whisper) : réunions, notes, stats"
  homepage "https://github.com/Leozerbib/intertrans-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Intertrans.app"

  # Une Intertrans installée hors de Homebrew (scripts/build-app.sh la copie dans ~/Applications) est rangée par
  # la nouvelle version à son premier lancement (LegacyApp.tidy), avec les autorisations fantômes de l'ancienne
  # signature (Permissions.purgeIfSignerChanged). Pas ici : pendant un `brew upgrade`, les étapes de la cask
  # tournent alors que la version de Homebrew est encore en place, et Homebrew y refuse `tccutil`.
  # Les données (~/Library/Application Support/Intertrans) et les réglages ne bougent pas.
  preflight_steps do
    terminate_process "Intertrans"
  end

  uninstall quit: "app.intertrans.mac"

  # ~/Library/Application Support/Intertrans n'est pas listé : il garde l'historique, le vocabulaire et les
  # modèles (plusieurs centaines de Mo). Le supprimer reste un geste à faire à la main.
  zap trash: [
    "~/Library/Caches/app.intertrans.mac",
    "~/Library/HTTPStorages/app.intertrans.mac",
    "~/Library/Preferences/app.intertrans.mac.plist",
    "~/Library/Saved Application State/app.intertrans.mac.savedState",
  ]

  caveats <<~EOS
    Intertrans est signée par un certificat auto-signé (« Interwarp Dev »), sans notarisation Apple.
    Si macOS refuse de l'ouvrir au premier lancement, ou après une mise à jour, lève la quarantaine
    de cette version, une fois :
      xattr -dr com.apple.quarantine "#{appdir}/Intertrans.app"
    ou Réglages Système › Confidentialité et sécurité › « Ouvrir quand même ».
    Sur un Mac géré, si un outil de l'entreprise bloque l'app, passe par l'IT : ne contourne rien.

    Une ancienne Intertrans (hors Homebrew) a pu être rangée dans
      ~/Library/Application Support/Intertrans/ancienne-app.noindex
    Ton historique, tes réglages et tes modèles sont repris tels quels. Le micro et l'accessibilité
    sont redemandés une fois.

    Mise à jour : brew upgrade --cask intertrans
  EOS
end
