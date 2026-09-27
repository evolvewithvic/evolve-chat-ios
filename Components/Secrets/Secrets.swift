nonisolated enum Secrets {
    static let sentryDSN: String? = nil
    static let sentryRustDSN: String? = nil
    static let postHogHost: String? = nil
    static let postHogAPIKey: String? = nil
    static let rageshakeURL: String? = nil
    static let mapLibreAPIKey: String? = nil   // no MapTiler key: location sharing stays hidden (MapTilerConfiguration.isEnabled)

}